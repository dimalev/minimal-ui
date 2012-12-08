package com.minimalui.controls {
  import flash.display.Sprite;
  import flash.events.MouseEvent;

  import com.minimalui.base.BaseContainer;

  public class Button extends BaseContainer {
    private var mLabel:Label;
    private var mCallback:Function;

    public function set onClick(f:Function):void { mCallback = f; }

    public function Button(text:String = "Button", idorcss:String = null, id:String = null) {
      super(idorcss, id);
      mStyle.setCSS("align:center; valign:center; padding-right:5; padding-left:5; padding-bottom:5; padding-top:5;");
      mLabel = new Label(text);
      addChild(mLabel);
      useHandCursor = buttonMode = true;
      addEventListener(MouseEvent.CLICK, coreOnClick);
    }

    private function coreOnClick(me:MouseEvent):void {
      if(mCallback === null) return;
      mCallback();
    }

    protected override function coreRedraw():void {
      graphics.beginFill(0xff00);
      graphics.drawRect(0, 0, width, height);
      graphics.endFill();
    }
  }
}
