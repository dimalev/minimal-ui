package com.minimalui.base {
  import flash.display.Sprite;
  import flash.geom.Rectangle;
  import flash.events.Event;

  import com.minimalui.base.Style;
  import com.minimalui.decorators.Border;
  import com.minimalui.decorators.Background;
  import com.minimalui.factories.IFactory

  /**
   * Base class for Minimal UI package drawing and managing. Extending this class you may be sure to be successfully
   * updated, validated, layout and moved within Minimal UI runtime routes. Additionally a set of styles and helpers are
   * already present.
   * Element can be set as Dirty, Invalidated Size, and Changed. On dirty objects commitProperties() is called on
   * update process. On Elements with invalidated size, measure(), layout(w, h) and move(x, y) is called on update
   * process. When redraw  is called, Element checks if it was changed. Dirty object can set itself with invalidated
   * size on  commitProperties() call. Both dirty element and element with invalidated size are subject to be redrawn if
   * Changed is set when any of the steps is called. Layout Manager resolves commitProperties and redraw in random
   * order, layout(w, h) and move(x, y) has to be called by each parent for his children, and measure is called
   * recursively from children to parents.
   */
  public class Element extends Sprite {
    public static const WIDTH:String = "width";
    public static const HEIGHT:String = "height";
    public static const PERCENT_WIDTH:String = "percent-width";
    public static const PERCENT_HEIGHT:String = "percent-height";
    public static const SIZING:String = "sizing";
    public static const POSITION:String = "position";

    public static const LEFT:String = "left";
    public static const RIGHT:String = "right";
    public static const TOP:String = "top";
    public static const BOTTOM:String = "bottom";

    public static const PADDING_LEFT:String = "padding-left";
    public static const PADDING_RIGHT:String = "padding-right";
    public static const PADDING_TOP:String = "padding-top";
    public static const PADDING_BOTTOM:String = "padding-bottom";
    public static const MARGIN_LEFT:String = "margin-left";
    public static const MARGIN_RIGHT:String = "margin-right";
    public static const MARGIN_TOP:String = "margin-top";
    public static const MARGIN_BOTTOM:String = "margin-bottom";

    public static const SIZING_STRICT:String = "strict";
    public static const SIZING_ADAPTIVE:String = "adaptive";

    public static const POSITION_ABSOLUTE:String = "absolute";
    public static const POSITION_RELATIVE:String = "relative";

    /**
     * Current element style set.
     */
    protected var mStyle:Style;
    /**
     * Element preferred width.
     */
    protected var mMeasuredWidth:Number;
    /**
     * Element preferred height.
     */
    protected var mMeasuredHeight:Number;
    /**
     * Element real width.
     */
    protected var mRealWidth:Number;
    /**
     * Element real height.
     */
    protected var mRealHeight:Number;
    /**
     * Width dedicated to the element by his parent.
     */
    protected var mLayoutWidth:Number;
    /**
     * Height dedicated to the element by his parent.
     */
    protected var mLayoutHeight:Number;

    /**
     * List of Decorators used to draw this object.
     */
    protected var mDecorators:Vector.<Decorator> = new Vector.<Decorator>;

    private var mId:String;
    private var mDirty:Boolean = false;
    private var mResized:Boolean = false;
    private var mLayoutManager:LayoutManager;
    private var mIsChanged:Boolean = false;

    private var mResizableAttributes:Array = [WIDTH, HEIGHT];

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

    public final function set versatile(b:Boolean):void { layoutManager.setVersatile(this, b); }

    public override function set visible(b:Boolean):void {
      super.visible = b;
			invalidateSize();
			layoutManager.forceUpdate();
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
     * Get UI factory associated with this element.
     *
     * @return UI factory associated with this element.
     */
    public final function get uifactory():IFactory {
      return layoutManager.uifactory;
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
     * Height set by parent container.
     */
    public final function get layoutHeight():Number { return mLayoutHeight; }

    /**
     * Width set by parent container.
     */
    public final function get layoutWidth():Number { return mLayoutWidth; }

    /**
     * Width preferred by this element.
     */
    public final function get realWidth():Number { return mRealWidth; }
    /**
     * Height preferred by this element.
     */
    public final function get realHeight():Number { return mRealHeight; }

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
    public final function get isSizeInvalid():Boolean { return mResized; }
    /**
     * Set element to be measured as soon as possible.
     */
    public final function invalidateSize():void {
      if(mResized) return;
      mLayoutWidth = mLayoutHeight = NaN;
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
     * Real element height. To get preferred size check styles.
     */
    public final override function get height():Number {
      if(isSizeInvalid) layoutManager.forceUpdate();
      if(style.getValue(SIZING) == SIZING_STRICT) {
        if(isNaN(mLayoutHeight)) {
          if(isNaN(mMeasuredHeight)) return Math.ceil(super.height);
          else return Math.ceil(measuredHeight);
        }
        return Math.ceil(mLayoutHeight);
      }
      if(isNaN(mLayoutHeight)) return Math.ceil(Math.max(measuredHeight));
      return Math.ceil(Math.max(mLayoutHeight));
      // if(isNaN(mLayoutHeight)) return Math.ceil(Math.max(super.height, measuredHeight));
      // return Math.ceil(Math.max(super.height, mLayoutHeight));
    }

    /**
     * Real element width. To get preferred size check styles.
     */
    public final override function get width():Number {
      if(isSizeInvalid) layoutManager.forceUpdate();
      if(style.getValue(SIZING) == SIZING_STRICT) {
        if(isNaN(mLayoutWidth)) {
          if(isNaN(mMeasuredWidth)) return Math.ceil(super.width);
          else return Math.ceil(measuredWidth);
        }
        return Math.ceil(mLayoutWidth);
      }
      if(isNaN(mLayoutWidth)) return Math.ceil(Math.max(measuredWidth));
      return Math.ceil(Math.max(mLayoutWidth));
      // if(isNaN(mLayoutWidth)) return Math.ceil(Math.max(super.width, measuredWidth));
      // return Math.ceil(Math.max(super.width, mLayoutWidth));
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
      setDirty();
      invalidateSize();
      setChanged();
      mStyle = new Style(this);
      mStyle.addInvalidateSize(WIDTH, HEIGHT);
      addEventListener(Event.ADDED, onNewParent);
      addDecorator(new Border(this));
      addDecorator(new Background(this));
      addAutoInitializeListeners();
      if(!id && !idorcss) return;
      if(!id && idorcss && idorcss.match(/^[\w]+[\w\d\-]*$/)) {
        mId = idorcss;
        return;
      }
      mId = id;
      if(idorcss != null) setStyles(idorcss);
    }

    /**
     * Called automatically on first enter, exit frame or after added to stage. override coreInitialize function to
     * perform initialization.
     */
    public function initialize():void {
      removeEventListener(Event.EXIT_FRAME, onFirstExit);
      removeEventListener(Event.ENTER_FRAME, onFirstEnter);
      removeEventListener(Event.ADDED_TO_STAGE, onFirstEnter);
      coreInitialize();
    }

    /**
     * First called function of your class. It is believed that all the initial css is set when this is called.
     */
    protected function coreInitialize():void {
    }

    private function addAutoInitializeListeners():void {
      addEventListener(Event.EXIT_FRAME, onFirstExit);
      addEventListener(Event.ENTER_FRAME, onFirstEnter);
      addEventListener(Event.ADDED_TO_STAGE, onFirstEnter);
    }

    private function onFirstExit(e:Event):void {
      initialize();
    }

    private function onFirstEnter(e:Event):void {
      initialize();
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
    public final function setStyle(name:String, v:Object):void { mStyle.setValue(name, v); }

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
    public final function setStyles(css:String):void { mStyle.setCSS(css); }

    public final function commitProperties():void {
      for each(var d:Decorator in mDecorators) d.onCommitProperties();
      coreCommitProperties();
      mDirty = false;
    }

    public final function measure():void {
      mMeasuredWidth = mMeasuredHeight = mRealWidth = mRealHeight = NaN;

      if(mStyle.hasValue("width")) mMeasuredWidth = mStyle.getNumber("width");
      if(mStyle.hasValue("height")) mMeasuredHeight = mStyle.getNumber("height");

      coreMeasure();

      if(isNaN(mRealWidth)) mRealWidth = mMeasuredWidth;
      else if(isNaN(mMeasuredWidth)) mMeasuredWidth = mRealWidth;
      if(isNaN(mRealHeight)) mRealHeight = mMeasuredHeight;
      else if(isNaN(mMeasuredHeight)) mMeasuredHeight = mRealHeight;

      if(isNaN(mMeasuredWidth)) mRealWidth = mMeasuredWidth = 1;
      if(isNaN(mMeasuredHeight)) mRealHeight = mMeasuredHeight = 1;

      mMeasuredHeight = Math.ceil(mMeasuredHeight);
      mMeasuredWidth = Math.ceil(mMeasuredWidth);
      mRealHeight = Math.ceil(mRealHeight);
      mRealWidth = Math.ceil(mRealWidth);
    }

    public final function layout(w:Number = NaN, h:Number = NaN):void {
      if(isNaN(w)) w = measuredWidth;
      if(isNaN(h)) h = measuredHeight;
      mLayoutWidth = Math.ceil(w);
      mLayoutHeight = Math.ceil(h);
      coreLayout();
      mResized = false;
    }

    public final function move(x:Number = NaN, y:Number = NaN):void {
      if(style.hasValue("x")) x = style.getNumber("x");
      if(style.hasValue("y")) y = style.getNumber("y");
      super.x = Math.ceil(x);
      super.y = Math.ceil(y);
      coreMove();
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

    public final function update():void {
      coreUpdate();
    }

    /**
     * Check if any of given styles changed.
     *
     * @param values - list of styles to check.
     *
     * @return if any of given styles changed.
     */
    public final function hasChanged(values:Vector.<String>):Boolean {
      return mStyle.changed.some(function(v:String, k:int, a:Vector.<String>):Boolean {
          return this.indexOf(v) >= 0;
        }, values);
    }

    protected function coreCommitProperties():void {
      if(hasChanged(Vector.<String>(['x', 'y']))) invalidateSize();
    }

    protected function coreMeasure():void { "Implement ME!"; }

    protected function coreLayout():void { "Implement ME!"; }

    protected function coreMove():void { "Implement ME!"; }

    protected function coreRedraw():void { "Implement ME!"; }

    protected function coreUpdate():void { "Implement ME!"; }

    public override function toString():String { return "[" + super.toString() + "(id="+mId+")]"; }
  }
}