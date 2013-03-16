package com.minimalui.controls {
  import flash.geom.Rectangle;
  import flash.events.MouseEvent;

  import com.minimalui.base.Element;
  import com.minimalui.base.BaseContainer;

  public class Scroll extends Element {
    private var mPossition:Number = 0;

    private var mTarget:Element;

    public function set target(e:Element):void {
      mTarget = e;
      if(!mTarget) return;
      //possition = 0;
    }

    public function get possition():Number { return mPossition; }

    public function set possition(dd:Number):void {
      if(!mTarget) return;
      mPossition = dd;
      setChanged();
    }

    public function Scroll(css:String = null) {
      super(css);
      if(!style.hasValue("width")) setStyle("width", 9);
      addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
      // construct();
    }

    // private var mMouseX:Number;
    private var mMouseY:Number;

    protected function onMouseDown(me:MouseEvent):void {
      removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
      layoutManager.stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
      layoutManager.stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
      // mMouseX = me.stageX;
      mMouseY = me.stageY;
    }

    protected function onMouseUp(me:MouseEvent):void {
      possition = Math.max(0, Math.min(1, possition))
      addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
      layoutManager.stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
      layoutManager.stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
    }

    protected function onMouseMove(me:MouseEvent):void {
      var delta:Number = me.stageY - mMouseY;
      mMouseY = me.stageY;
      possition += delta / (realHeight * (1 - mTarget.scrollRect.height / mTarget.realHeight));
    }

    protected override function coreCommitProperties():void {
      // if(hasChanged(Vector.<String>(["width"]))) {
      //   // mRunner.setStyle("width", getStyle("width"));
      // }
      // if(hasChanged(Vector.<String>(["runner-color"]))) {
      //   mRunner.setStyle("background-color", getStyle("runner-color"));
      // }
    }

    protected override function coreRedraw():void {
      if(!mTarget || !mTarget.scrollRect) return;
      mTarget.scrollRect = new Rectangle(0, Math.max(0, Math.min(1, possition)) * (mTarget.realHeight - mTarget.scrollRect.height),
                                         mTarget.scrollRect.width, mTarget.scrollRect.height);
      graphics.clear();
      graphics.lineStyle(1, 0xffffff, 0.7);
      graphics.beginFill(0x999999, 0.3);
      graphics.drawRect(0, Math.max(0, Math.min(1, mPossition)) * realHeight * (1 - mTarget.scrollRect.height / mTarget.realHeight),
                             width, realHeight * mTarget.scrollRect.height / mTarget.realHeight);
      graphics.endFill();
      // mRunner.y = mTarget.scrollRect.y / (mTarget.realHeight - mTarget.scrollRect.height) * realHeight;
      // mRunner.height = realHeight * mTarget.scrollRect.height / mTarget.realHeight;
    }

    private function construct():void {
      // addChild(mRunner);
      // mRunner.setStyle("width", style.hasValue("width") ? getStyle("width") : 10);
      // mRunner.setStyle("height", style.hasValue("height") ? getStyle("height") : 80);
    }
  }
}