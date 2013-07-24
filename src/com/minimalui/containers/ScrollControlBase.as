package com.minimalui.containers {
  import flash.display.DisplayObject;
  import flash.display.Sprite;
  import flash.geom.Rectangle;
  import flash.events.MouseEvent;

  import com.minimalui.base.BaseContainer;
  import com.minimalui.base.Element;

  public class ScrollControlBase extends BaseContainer {
    public static const SCROLL_X:String = "scroll-x";
    public static const SCROLL_Y:String = "scroll-y";

    protected var mChild:Element;
    protected var mViewPort:Rectangle = new Rectangle(0, 0, 0, 0);

    public function ScrollControlBase(idorcss:String = null, css:String = null) {
      super(idorcss, css);
      setStyle(Element.SIZING, SIZING_STRICT);
      this.addEventListener(MouseEvent.MOUSE_WHEEL, onWheel);
      super.addChild(hitArea = new Sprite);
      hitArea.visible = false;
      hitArea.mouseEnabled = false;
    }

    protected function onWheel(me:MouseEvent):void {
      var maxDelta:Number = mChild.height;
      var delta:Number = style.getNumber(SCROLL_Y);
      delta = Math.min(maxDelta - height, Math.max(delta - me.delta, 0));
      setStyle(SCROLL_Y, delta);
      invalidateSize();
    }

    protected override function coreMeasure():void {
      if(style.hasValue("width") && style.hasValue("height")) {
        mMeasuredWidth = style.getNumber("width");
        mMeasuredHeight = style.getNumber("height");
        return;
      }
      if(style.hasValue("width")) mMeasuredWidth = style.getNumber("width");
      else mMeasuredWidth = mChild.width;
      if(style.hasValue("height")) mMeasuredHeight = style.getNumber("height");
      else mMeasuredHeight = mChild.height;
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
      mChild.layout();
      setChanged();
    }

    public override function addChild(e:DisplayObject):DisplayObject {
      return super.addChildAt(mChild = e as Element, 0);
    }
  }
}