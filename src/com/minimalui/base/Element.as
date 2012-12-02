package com.minimalui.base {
  import flash.display.Sprite;
  import flash.geom.Rectangle;

  import com.minimalui.decoration.IBackgroundDrawer;
  import com.minimalui.base.Style;
  import com.minimalui.events.FieldChangeEvent;
  import com.minimalui.events.StyleNewParentEvent;
  import com.minimalui.events.ElementResizeEvent;

  public class Element extends Sprite {
    protected var defaultStyle:Style;
    protected var mStyle:Style;
    protected var mMisuredWidth:Number;
    protected var mMisuredHeight:Number;
    protected var mViewPort:Rectangle;
    protected var mParent:BaseContainer;

    private var mId:String;
    private var mDirty:Boolean = false;
    private var mResized:Boolean = false;
    private var mLayoutManager:LayoutManager;
    private var mIsChanged:Boolean = false;

    private var mResizableAttributes:Array = ["width", "height"];

    public final get isChanged():void { return mIsChanged; }
    protected final setChanged():void { mIsChanged = true; }

    public final function get layoutManager():LayoutManager {
      if(mLayoutManager) return mLayoutManager;
      if(mParent) return mParent.LayoutManager();
      return LayoutManager.getDefault();
    }

    public final function get parent():BaseContainer { return mParent; }
    protected final function set _parent(p:BaseContainer):void {
      setDirty();
      mParent = p;
      if(mParent == null) mStyle.parent = null;
      else mStyle.parent = mParent.style;
    }

    public function get misuredWidth():Number { return mMisuredWidth; }
    public function get misuredHeight():Number { return mMisuredHeight; }

    public final function get isDirty():Boolean { return mDirty; }
    protected final function setDirty():void {
      if(mDirty) return;
      mDirty = true;
      layoutManager.setDirty(this);
    }

    public final function get isSizeValid():Boolean { return mResized; }
    protected final function invalidateSize():void {
      if(mResized) return;
      mResized = true;
      layoutManager.invalidateSize(this);
    }

    public final override function set x(xx:Number):void { setStyle("x", xx); }
    public final override function set y(yy:Number):void { setStyle("y", yy); }

    public final override function set width(w:Number):void { setStyle("width", w); }
    public final override function set height(h:Number):void { setStyle("height", h); }

    public final function get id():String { return mId; }

    public function get style():Style { return mStyle; }

    public function Element(idorcss:String = null, id:String = null) {
      if(id == null && idorcss.match(/\w+/)) {
        mId = id;
        return;
      }
      mId = id;
      if(idorcss != "" && idorcss != null) setStyles(idorcss);
    }

    public function setStyle(name:String, v:Object):Object {
      if(mResizableAttributes.indexOf(name) >= 0) invalidateSize();
      setDirty();
      return mStyle.setValue(name, v);
    }

    public function getStyle(name:String):Object { return mStyle.getValue(name); }

    public function setStyles(css:String):void {
      throw new Error("Set styles as css string is not implemented yet");
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
      coreLayout();
      mResized = false;
      redraw();
    }

    public final function redraw():void {
      if(!isChanged) return;
      graphics.clear();
      coreRedraw();
      mIsChanged = false;
    }

    protected function coreCommitProperties():void { "Implement ME!"; }

    protected function coreMeasure():void { "Implement ME!"; }

    protected function coreLayout():void { "Implement ME!"; }

    protected function coreRedraw():void { "Implement ME!"; }
  }
}