package com.minimalui.base {
  import flash.display.Sprite;
  import flash.geom.Rectangle;

  import com.minimalui.decoration.IBackgroundDrawer;
  import com.minimalui.base.Style;
  import com.minimalui.events.FieldChangeEvent;
  import com.minimalui.events.StyleNewParentEvent;
  import com.minimalui.events.ElementResizeEvent;
  import com.minimalui.decorators.Border;

  public class Element extends Sprite {
    protected var defaultStyle:Style;
    protected var mStyle:Style = new Style;
    protected var mMeasuredWidth:int;
    protected var mMeasuredHeight:int;
    protected var mViewPort:Rectangle;
    protected var mParent:BaseContainer;

    protected var mDecorators:Vector.<Decorator> = new Vector.<Decorator>;

    private var mId:String;
    private var mDirty:Boolean = false;
    private var mResized:Boolean = false;
    private var mLayoutManager:LayoutManager;
    private var mIsChanged:Boolean = false;
    private var mCoreDecorators:Vector.<Decorator> = new Vector.<Decorator>;

    private var mResizableAttributes:Array = ["width", "height"];

    public final function get isChanged():Boolean { return mIsChanged; }
    protected final function setChanged():void { mIsChanged = true; }

    public final function get layoutManager():LayoutManager {
      if(mLayoutManager) return mLayoutManager;
      if(mParent) return mParent.layoutManager;
      return LayoutManager.getDefault();
    }

    public final function getParent():BaseContainer { return mParent; }
    public final function set _parent(p:BaseContainer):void {
      setDirty();
      mParent = p;
      if(mParent == null) mStyle.parent = null;
      else mStyle.parent = mParent.style;
    }

    public function get measuredWidth():int { return mMeasuredWidth; }
    public function get measuredHeight():int { return mMeasuredHeight; }

    public final function get isDirty():Boolean { return mDirty; }
    public final function setDirty():void {
      if(mDirty) return;
      mDirty = true;
      layoutManager.setDirty(this);
    }

    public final function get isSizeValid():Boolean { return mResized; }
    public final function invalidateSize():void {
      if(mResized) return;
      mResized = true;
      layoutManager.invalidateSize(this);
    }

    public final override function set x(xx:Number):void { setStyle("x", xx); }
    public final override function set y(yy:Number):void { setStyle("y", yy); }

    protected final function set coreX(xx:Number):void { super.x = xx; }
    protected final function set coreY(yy:Number):void { super.y = yy; }

    public override function get height():Number {
      if(mResized) measure();
      if(!mViewPort) return Math.max(super.height, measuredHeight);
      return Math.max(mViewPort.height, super.height);
    }
    public override function get width():Number {
      if(mResized) measure();
      if(!mViewPort) return Math.max(super.width, measuredWidth);
      return Math.max(mViewPort.width, super.width);
    }

    public final override function set width(w:Number):void { setStyle("width", w); }
    public final override function set height(h:Number):void { setStyle("height", h); }

    public final function get id():String { return mId; }

    public function get style():Style { return mStyle; }

    public function Element(idorcss:String = null, id:String = null) {
      mCoreDecorators.push(new Border(this));
      if(!id && !idorcss) return;
      if(!id && idorcss && idorcss.match(/^[\w]+[\w\d\-]*$/)) {
        mId = idorcss;
        return;
      }
      mId = id;
      if(idorcss != null) setStyles(idorcss);
    }

    public function setStyle(name:String, v:Object):void {
      if(mResizableAttributes.indexOf(name) >= 0) invalidateSize();
      setDirty();
      mStyle.setValue(name, v);
    }

    public function getStyle(name:String):Object { return mStyle.getValue(name); }

    public function setStyles(css:String):void {
      mStyle.setCSS(css);
    }

    public final function commitProperties():void {
      coreCommitProperties();
      mStyle.cleanChanged();
      mDirty = false;
    }

    public final function measure():void {
      coreMeasure();
      mResized = false;
    }

    public final function layout(viewPort:Rectangle = null):void {
      mViewPort = viewPort;
      if(!mViewPort) {
        mViewPort = new Rectangle(0, 0, measuredWidth, measuredHeight);
        if(mStyle.hasValue("x")) mViewPort.x = mStyle.getNumber("x") || 0;
        if(mStyle.hasValue("y")) mViewPort.y = mStyle.getNumber("y") || 0;
        if(mStyle.hasValue("width")) mViewPort.width = mStyle.getNumber("width") || measuredWidth;
        if(mStyle.hasValue("height")) mViewPort.height = mStyle.getNumber("height") || measuredHeight;
      }
      mViewPort.width = Math.ceil(mViewPort.width);
      mViewPort.height = Math.ceil(mViewPort.height);
      coreX = Math.round(mViewPort.x);
      coreY = Math.round(mViewPort.y);
      coreLayout();
      mResized = false;
      redraw();
    }

    public final function redraw():void {
      if(!isChanged) return;
      var d:Decorator;
      graphics.clear();
      for each(d in mCoreDecorators) d.onBeforeRedraw();
      coreRedraw();
      for each(d in mCoreDecorators) d.onAfterRedraw();
      mIsChanged = false;
    }

    protected function hasChanged(values:Vector.<String>):Boolean {
      return mStyle.changed.some(function(v:String, k:int, a:Vector.<String>):Boolean {
          return this.indexOf(v) >= 0;
        }, values);
    }

    protected function coreCommitProperties():void { "Implement ME!"; }

    protected function coreMeasure():void { "Implement ME!"; }

    protected function coreLayout():void { "Implement ME!"; }

    protected function coreRedraw():void { "Implement ME!"; }
  }
}