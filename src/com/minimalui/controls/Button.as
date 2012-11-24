package com.minimalui.controls {
  import flash.display.Sprite;
  import flash.text.engine.FontDescription;
  import flash.text.engine.ElementFormat;
  import flash.events.MouseEvent;

  import com.minimalui.base.Element;
  import com.minimalui.base.Style;
  import com.minimalui.decoration.GradientBackground;
  import com.minimalui.events.ElementResizeEvent;
  import com.minimalui.events.FieldChangeEvent;

  public class Button extends Element {
    public var label:Label;
    public var margin:Vector.<uint> = Vector.<uint>([5,5,5,5]);

    private var mWidth:Number = -1;
    private var mHeight:Number = -1;

    private var mRealWidth:Number;
    private var mRealHeight:Number;

    public override function get width():Number {
      return mWidth > 0 ? mWidth : mRealWidth;
    }
    public override function get height():Number {
      return mHeight > 0 ? mHeight : mRealHeight;
    }

    private var mCallback:Function;

    public function set onClick(f:Function):void { mCallback = f; }

    public override function set height(h:Number):void {
      if(h > 0) label.height = h - margin[1] - margin[3];
      else label.height = -1;
      mHeight = h;
      redraw();
      dispatchResize();
    }
    public override function set width(w:Number):void {
      if(w > 0) label.width = w - margin[0] - margin[2];
      else label.width = -1;
      mWidth = w;
      redraw();
      dispatchResize();
    }

    public function Button(text:String = "Button") {
      style = new Style();
      label = new Label(text);
      label.addEventListener(ElementResizeEvent.RESIZE, onLabelResize);
      label.lock(true);
      label.style.lock();
      label.style.parent = style;
      label.style.setValue(Label.TEXT_ALIGN, "center");
      label.style.setValue(Label.TEXT_VALIGN, "middle");
      label.style.lock(false);
      label.lock(false);
      addChild(label);
      redraw();
      useHandCursor = buttonMode = true;
      addEventListener(MouseEvent.CLICK, coreOnClick);
      backgroundDrawer = new GradientBackground().withBorder(0, 0xeeeeff);
    }

    protected override function onStyleChange(fce:FieldChangeEvent):void {
    }

    private function onLabelResize(ere:ElementResizeEvent):void {
      redraw();
    }

    private function coreOnClick(me:MouseEvent):void {
      if(mCallback === null) return;
      mCallback();
    }

    protected override function coreRedraw():void {
      label.x = margin[0];
      label.y = margin[1];
      if(mWidth > 0) label.width = mWidth - margin[0] - margin[2];
      if(mHeight > 0) label.height = mHeight - margin[1] - margin[3];
      mRealHeight = label.height + margin[1] + margin[3];
      mRealWidth = label.width + margin[0] + margin[2];
    }
  }
}
