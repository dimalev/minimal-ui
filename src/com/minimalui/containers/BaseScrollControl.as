package com.minimalui.containers {
  import flash.display.DisplayObject;
  import flash.display.Sprite;
  import flash.geom.Rectangle;
  import flash.events.MouseEvent;
  import flash.events.TouchEvent;

  import com.minimalui.base.BaseContainer;
  import com.minimalui.base.Element;

  public class BaseScrollControl extends BaseContainer {
    public static const SCROLL_X:String = "scroll-x";
    public static const SCROLL_Y:String = "scroll-y";

    protected var mChild:Element;
    protected var mViewPort:Rectangle = new Rectangle(0, 0, 0, 0);

    private var mTouchY:Number;

    public function BaseScrollControl(idorcss:String = null, css:String = null) {
      super(idorcss, css);
      setStyle(Element.SIZING, SIZING_STRICT);
      addEventListener(MouseEvent.MOUSE_WHEEL, onWheel);
      addEventListener(TouchEvent.TOUCH_BEGIN, onTouch);
      super.addChild(hitArea = new Sprite);
      hitArea.visible = false;
      hitArea.mouseEnabled = false;
    }

    protected function onTouch(te:TouchEvent):void {
      mTouchY = te.stageY;
      addEventListener(TouchEvent.TOUCH_MOVE, onTouchMove);
      addEventListener(TouchEvent.TOUCH_END, onTouchEnd);
    }

    protected function onTouchEnd(te:TouchEvent):void {
      removeEventListener(TouchEvent.TOUCH_MOVE, onTouchMove);
      removeEventListener(TouchEvent.TOUCH_END, onTouchEnd);
    }

    protected function onTouchMove(te:TouchEvent):void {
      var md:Number = te.stageY - mTouchY;
      mTouchY = te.stageY;
      var maxDelta:Number = mChild.height;
      var delta:Number = style.getNumber(SCROLL_Y);
      delta = Math.min(maxDelta - height, Math.max(delta - md, 0));
      setStyle(SCROLL_Y, delta);
      invalidateSize();
      mTouchY = te.stageY;
    }

    protected function onWheel(me:MouseEvent):void {
      var maxDelta:Number = mChild.height;
      var delta:Number = style.getNumber(SCROLL_Y);
      delta = Math.min(maxDelta - height, Math.max(delta - me.delta * 5, 0));
      setStyle(SCROLL_Y, delta);
      invalidateSize();
    }

    protected override function coreMeasure():void {
      mChild.measure();
      if(style.hasValue("width")) mMeasuredWidth = style.getNumber("width");
      else mMeasuredWidth = mChild.measuredWidth;
      if(style.hasValue("height")) mMeasuredHeight = style.getNumber("height");
      else mMeasuredHeight = mChild.measuredHeight;
    }

    protected override function coreCommitProperties():void {
      super.coreCommitProperties();
      if(hasChanged(Vector.<String>(["height", "width", "scrollX", "scrollY"]))) {
        invalidateSize();
      }
    }

    protected override function coreLayout():void {
      hitArea.graphics.clear();
      hitArea.graphics.beginFill(0xff);
      hitArea.graphics.drawRect(0, 0, mLayoutWidth, mLayoutHeight);
      hitArea.graphics.endFill();
      mViewPort.height = mLayoutHeight;
      mViewPort.width = mLayoutWidth;
      mViewPort.x = style.getNumber(SCROLL_X);
      mViewPort.y = style.getNumber(SCROLL_Y);
      mChild.scrollRect = mViewPort;
      var w:Number = mChild.style.hasValue(Element.PERCENT_WIDTH) ?
        mLayoutWidth * mChild.style.getNumber(Element.PERCENT_WIDTH) / 100 : mChild.measuredWidth;
      var h:Number = mChild.style.hasValue(Element.PERCENT_WIDTH) ?
        mLayoutHeight * mChild.style.getNumber(Element.PERCENT_WIDTH) / 100 : mChild.measuredHeight;
      mChild.layout(w, h);
      var maxDelta:Number = mChild.height;
      var delta:Number = style.getNumber(SCROLL_Y);
      delta = Math.min(maxDelta - height, Math.max(delta, 0));
      setStyle(SCROLL_Y, delta);
      setChanged();
    }

    public override function addChild(e:DisplayObject):DisplayObject {
      return super.addChildAt(mChild = e as Element, 0);
    }
  }
}