package com.minimalui.controls {
  import flash.display.Sprite;
  import flash.events.MouseEvent;
  import flash.display.GradientType;
  import flash.geom.Matrix;
  import flash.geom.Point;

  import com.minimalui.events.MEvent;

  import com.minimalui.base.BaseContainer;
  import com.minimalui.base.Decorator;
  import com.minimalui.containers.HBox;
  import com.minimalui.decorators.Border;
  import com.minimalui.decorators.Background;
  import com.minimalui.tools.Tools;

  /**
   * Implements basic Button.
   */
  public class Button extends HBox {
    public static const DISABLED:String = "disabled";
    private var mLabel:Label;
    private var mCallback:Function;
    private var mDisabled:Boolean = false;

    private var mIsMouseDown:Boolean = false;
    private var mIsMouseOver:Boolean = false;
    private var mMouseX:Number = 0;
    private var mMouseY:Number = 0;

    /**
     * Easy shortcut to click event. Dispatched before calling firing click event.
     *
     * @param f callback called on clicking.
     */
    public final function set onClick(f:Function):void {
      mCallback = f;
    }

    /**
     * Default constructor.
     *
     * @param text label on the button
     * @param idorcss if this is last parameter - this is element id, otherwise this parameter is treated as css
     * @param id id of the element.
     */
   public function Button(text:String = "Button", idorcss:String = null, id:String = null) {
      super(null, idorcss, id);
      useHandCursor = buttonMode = true;
      construct(text);
      addMouseListeners();
      cleanDecorators();
    }

    protected override function coreCommitProperties():void {
      if(hasChanged(Vector.<String>([DISABLED]))) {
        mDisabled = useHandCursor = buttonMode = getStyle("disabled") == "true";
        setChanged();
      }
      mLabel.setStyle("content", getStyle("text"));
      super.coreCommitProperties();
    }

    protected override function coreRedraw():void {
      var color:Number = 0xff0000;
      var padding:Number = 0;
      if(mIsMouseOver) {
          color = 0x00ff00;
          if(mIsMouseDown) padding = 2;
      }
      var cc:Array = [color, Tools.rgbReduce(color, 0.3, 0.3, 0.3)];
      var aa:Array = [1,1];
      var bb:Array = [0,255];
      var xx:Matrix = new Matrix();
      xx.createGradientBox(width, height, 90);// * Math.PI / 180);
      graphics.lineStyle(0, Tools.rgbReduce(color, 0.6, 0.6, 0.6));
      graphics.beginGradientFill(GradientType.LINEAR, cc, aa, bb, xx);
      graphics.drawRect(0,0, width, height);
      graphics.endFill();
      if(!mIsMouseOver) return;
      aa = [0.6,0];
      xx.createGradientBox(100, 100, 0, mMouseX - 50, height - 50);// * Math.PI / 180);
      graphics.lineStyle();
      graphics.beginGradientFill(GradientType.RADIAL, cc, aa, bb, xx);
      var sx:Number = Math.max(0, mMouseX - 50);
      var sy:Number = Math.max(0, height - 50);
      graphics.drawRect(sx, sy, Math.min(sx + 100, width) - sx, Math.min(sy + 100, height) - sy);
      graphics.endFill();
    }

    private function coreOnClick(me:MouseEvent):void {
      if(mCallback !== null) mCallback();
      dispatchEvent(new MEvent(MEvent.BUTTON_CLICK));
      layoutManager.forceUpdate();
    }

    private function addMouseListeners():void {
      addEventListener(MouseEvent.CLICK, coreOnClick);
      addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
      addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
      addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
    }

    private function onMouseMove(me:MouseEvent):void {
      var p:Point = globalToLocal(new Point(me.stageX, me.stageY));
      mMouseX = p.x;
      mMouseY = p.y;
      setChanged();
    }

    private function onMouseOver(me:MouseEvent):void {
      addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
      mIsMouseOver = true;
      setChanged();
    }

    private function onMouseOut(me:MouseEvent):void {
      removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
      mIsMouseOver = false;
      setChanged();
    }

    private function onMouseDown(me:MouseEvent):void {
      mIsMouseDown = true;
      setChanged();
      layoutManager.stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
    }

    private function onMouseUp(me:MouseEvent):void {
      mIsMouseDown = false;
      setChanged();
    }

    private function construct(text:String):void {
      mLabel = new Label(text);
      addChild(mLabel);
    }
  }
}
