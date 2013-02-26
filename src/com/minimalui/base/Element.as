package com.minimalui.base {
  import flash.display.Sprite;
  import flash.geom.Rectangle;
  import flash.events.Event;

  import com.minimalui.base.Style;
  import com.minimalui.events.FieldChangeEvent;
  import com.minimalui.events.StyleNewParentEvent;
  import com.minimalui.events.ElementResizeEvent;

  /**
   * Base class for Minimal UI package drawing and managing. Extending this class you may be sure to be successfully
   * updated, validated and layout within Minimal UI runtime routes. Additionally a set of styles and helpers are
   * already present.
   * Element can be set as Dirty, Invalidated Size, and Changed. On dirty objects commitProperties() is called on
   * update process. On Elements with invalidated size, measure() and layout() is called on update process. When redraw
   * is called, Element checks if it was changed. Dirty object can set itself with invalidated size on
   * commitProperties() call. Both dirty element and element with invalidated size is subject to be redrawn if Changed
   * is set when commitProperties(), measure() or layout() is called.
   */
  public class Element extends Sprite {
    public static const SIZES_PROPERTIES:Vector.<String> = Vector.<String>(["width", "height"]);
    /**
     * Current element style set.
     */
    protected var mStyle:Style = new Style;
    /**
     * Element preferred width.
     */
    protected var mMeasuredWidth:int;
    /**nn
     * Element preferred height.
     */
    protected var mMeasuredHeight:int;
    /**
     * Parent area dedicated to this object. This is what layout wants this object to look like.
     */
    protected var mViewPort:Rectangle;

    /**
     * List of Decorators used to draw this object.
     */
    protected var mDecorators:Vector.<Decorator> = new Vector.<Decorator>;

    private var mId:String;
    private var mDirty:Boolean = false;
    private var mResized:Boolean = false;
    private var mLayoutManager:LayoutManager;
    private var mIsChanged:Boolean = false;
    // private var mCoreDecorators:Vector.<Decorator> = new Vector.<Decorator>;
    // private var mDecoratorNames:Vector.<String> = new Vector.<String>;

    private var mResizableAttributes:Array = ["width", "height"];

    /**
     * If this element should be redrawn.
     *
     * @return If this element should be redrawn.
     */
    public final function get isChanged():Boolean { return mIsChanged; }
    /**
     * Set element to be redrawn when possible.
     */
    public final function setChanged():void {
      if(isChanged) return;
      mIsChanged = true;
      layoutManager.setChanged(this);
    }

    /**
     * Get layout manager associated with this element.
     *
     * @return Layout manager associated with this element.
     */
    public final function get layoutManager():LayoutManager {
      if(mLayoutManager) return mLayoutManager;
      if(parent && parent is Element) return (parent as Element).layoutManager;
      return LayoutManager.getDefault();
    }

    /**
     * Decorators applied to element.
     */
    public final function get decorators():Vector.<Decorator> { return mDecorators.slice(); }

    /**
     * Style helper method to set all the margins of the object at once. These include left, right, top and bottom.
     *
     * @param m Margin in pixels.
     */
    public final function set margins(m:Number):void {
      var names:Array = ["margin-left", "margin-bottom", "margin-top", "margin-right"];
      var name:String;
      if(isNaN(m)) {
        for each(name in names) style.delValue(name);
        return;
      }
      for each(name in names) style.setValue(name, m);
    }

    /**
     * Style helper method to set all the paddings of the object at once. These include left, right, top and bottom.
     *
     * @param p Padding in pixels.
     */
    public final function set paddings(p:Number):void {
      var names:Array = ["padding-left", "padding-bottom", "padding-top", "padding-right"];
      var name:String;
      if(isNaN(p)) {
        for each(name in names) style.delValue(name);
        return;
      }
      for each(name in names) style.setValue(name, p);
    }

    /**
     * Width preferred by this element.
     */
    public final function get measuredWidth():int { return mMeasuredWidth; }
    /**
     * Height preferred by this element.
     */
    public final function get measuredHeight():int { return mMeasuredHeight; }

    /**
     * If element needs to be validated.
     */
    public final function get isDirty():Boolean { return mDirty; }
    /**
     * Set element to be validated, as soon as possible.
     */
    public final function setDirty():void {
      if(mDirty) return;
      mDirty = true;
      layoutManager.setDirty(this);
    }

    /**
     * If element has a valid measured size.
     */
    public final function get isSizeValid():Boolean { return mResized; }
    /**
     * Set element to be measured as soon as possible.
     */
    public final function invalidateSize():void {
      if(mResized) return;
      mResized = true;
      layoutManager.invalidateSize(this);
    }

    /**
     * Preferred X positioning for element.
     */
    public final override function set x(xx:Number):void { setStyle("x", xx); }
    /**
     * Preferred Y positioning for element.
     */
    public final override function set y(yy:Number):void { setStyle("y", yy); }
    /**
     * Preferred X positioning for element.
     */
    public final override function get x():Number {
      layoutManager.forceUpdate();
      return mStyle.hasValue("x") ? mStyle.getNumber("x") : super.x;
    }
    /**
     * Preferred Y positioning for element.
     */
    public final override function get y():Number {
      layoutManager.forceUpdate();
      return mStyle.hasValue("y") ? mStyle.getNumber("y") : super.y;
    }

    protected final function set coreX(xx:Number):void { super.x = xx; }
    protected final function set coreY(yy:Number):void { super.y = yy; }

    /**
     * Real element width. To get preferred size check styles.
     */
    public final override function get height():Number {
      layoutManager.forceUpdate();
      if(!mViewPort) return Math.max(super.height, measuredHeight);
      return Math.max(mViewPort.height, super.height);
    }
    /**
     * Real element height. To get preferred size check styles.
     */
    public final override function get width():Number {
      layoutManager.forceUpdate();
      if(!mViewPort) return Math.max(super.width, measuredWidth);
      return Math.max(mViewPort.width, super.width);
    }

    /**
     * Set preferred width.
     */
    public final override function set width(w:Number):void { setStyle("width", w); }
    /**
     * Set preferred height.
     */
    public final override function set height(h:Number):void { setStyle("height", h); }

    /**
     * Set element id.
     */
    public final function get id():String { return mId; }
    /**
     * Get element id.
     */
    public final function set id(i:String):void { mId = i; }

    /**
     * Get element style descriptor.
     */
    public final function get style():Style { return mStyle; }

    /**
     * Constructs element with given CSS properties and/or id.
     *
     * @param idorcss treated as id, if this is only parameter, or CSS properties, if not, or not match \w+ pattern.
     * @param id id of the element, if passed.
     */
    public function Element(idorcss:String = null, id:String = null) {
      // mCoreDecorators.push(new Background(this));
      // mCoreDecorators.push(new Border(this));
      setDirty();
      setChanged();
      addEventListener(Event.ADDED, onNewParent);
      if(!id && !idorcss) return;
      if(!id && idorcss && idorcss.match(/^[\w]+[\w\d\-]*$/)) {
        mId = idorcss;
        return;
      }
      mId = id;
      if(idorcss != null) setStyles(idorcss);
    }

    private function onNewParent(e:Event):void {
      if(!(parent is Element)) return;
      mStyle.parent = (parent as Element).style;
    }

    /**
     * Add decorator.
     *
     * @param d Decorator to be added.
     */
    public final function addDecorator(d:Decorator):void {
      // if(mDecoratorNames.indexOf(d.name) >= 0) return;
      mDecorators.push(d);
    }
    /**
     * Remove decorator.
     *
     * @param d Decorator to be removed.
     */
    public final function removeDecorator(d:Decorator):void {
      var i:int = mDecorators.indexOf(d);
      if(i < 0) return;
      mDecorators.splice(i, 1);
    }

    /**
     * Remove all decorators.
     */
    public final function cleanDecorators():void {
      var decs:Vector.<Decorator> = decorators;
      for each(var decorator:Decorator in decs)
        removeDecorator(decorator);
    }

    /**
     * Set style property.
     *
     * @param name Property name.
     * @param v New Property groove.
     */
    public final function setStyle(name:String, v:Object):void {
      if(mResizableAttributes.indexOf(name) >= 0) invalidateSize();
      setDirty();
      mStyle.setValue(name, v);
    }

    /**
     * Not the best style value getter. This method makes you using cast in the code, better to use typed getter.
     *
     * @param name Name of the property.
     *
     * @return Value of the property.
     */
    public final function getStyle(name:String):Object { return mStyle.getValue(name); }

    /**
     * Bulk style setter, formatted as css.
     *
     * @param css CSS descriptor.
     */
    public final function setStyles(css:String):void {
      mStyle.setCSS(css);
      setDirty();
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
      if(!mViewPort) mViewPort = new Rectangle(super.x, super.y, measuredWidth, measuredHeight);
      if(mStyle.hasValue("x")) mViewPort.x = mStyle.getNumber("x");
      if(mStyle.hasValue("y")) mViewPort.y = mStyle.getNumber("y");
      if(mStyle.hasValue("width")) mViewPort.width = mStyle.getNumber("width") || measuredWidth;
      if(mStyle.hasValue("height")) mViewPort.height = mStyle.getNumber("height") || measuredHeight;
      mViewPort.width = Math.ceil(mViewPort.width);
      mViewPort.height = Math.ceil(mViewPort.height);
      coreX = Math.round(mViewPort.x);
      coreY = Math.round(mViewPort.y);
      coreLayout();
    }

    public final function redraw():void {
      if(!isChanged) return;
      var d:Decorator;
      graphics.clear();
      for each(d in mDecorators) d.onBeforeRedraw();
      coreRedraw();
      for each(d in mDecorators) d.onAfterRedraw();
      mIsChanged = false;
    }

    protected function hasChanged(values:Vector.<String>):Boolean {
      return mStyle.changed.some(function(v:String, k:int, a:Vector.<String>):Boolean {
          return this.indexOf(v) >= 0;
        }, values);
    }

    protected function coreCommitProperties():void {
      if(hasChanged(Vector.<String>(['x', 'y']))) invalidateSize();
    }

    protected function coreMeasure():void {
      "Implement ME!";
      mMeasuredWidth = Math.max(super.width, mStyle.getNumber("width"));
      mMeasuredHeight = Math.max(super.height, mStyle.getNumber("height"));
    }

    protected function coreLayout():void {
      "Implement ME!";
      this.coreX = mViewPort.x;
      this.coreY = mViewPort.y;
    }

    protected function coreRedraw():void { "Implement ME!"; }
  }
}