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
    public static const TEXT:String = "text";
    public static const BACKGROUND_COLOR:String = "background-color";
    public static const BACKGROUND_COLOR_HOVER:String = "background-color-hover";
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
      setStyle(TEXT, text);
      useHandCursor = buttonMode = true;
      construct();
      addMouseListeners();
      cleanDecorators();
    }

    protected override function coreCommitProperties():void {
      if(hasChanged(Vector.<String>([DISABLED]))) {
        mDisabled = useHandCursor = buttonMode = getStyle(DISABLED) == "true";
        setChanged();
      }
      if(hasChanged(Vector.<String>([TEXT]))) {
        mLabel.setStyle(Label.TEXT_CONTENT, getStyle(TEXT));
      }
      super.coreCommitProperties();
    }

    protected override function coreRedraw():void {
      var color:Number = style.hasValue(BACKGROUND_COLOR) ? style.getNumber(BACKGROUND_COLOR) : 0xaa0000;
      var padding:Number = 0;
      if(mIsMouseOver) {
          color = style.hasValue(BACKGROUND_COLOR_HOVER) ? style.getNumber(BACKGROUND_COLOR_HOVER) : 0x00aa00;
          if(mIsMouseDown) padding = 2;
      }
      var red:Number = style.hasValue("background-reduction") ? style.getNumber("background-reduction") : 0.3;
      var cc:Array = [color, Tools.rgbReduce(color, red, red, red)];
      var aa:Array = [1,1];
      var bb:Array = [0,255];
      var xx:Matrix = new Matrix();
      xx.createGradientBox(width, height, 90);// * Math.PI / 180);
      graphics.lineStyle(0, Tools.rgbReduce(color, 0.6, 0.6, 0.6));
      graphics.beginGradientFill(GradientType.LINEAR, cc, aa, bb, xx);
      graphics.drawRect(0,0, width, height);
      graphics.endFill();
      if(!mIsMouseOver) return;
      aa = [0.5,0];
      var R:Number = style.hasValue("light-radius") ? style.getNumber("light-radius") : 25;
      xx.createGradientBox(2*R, 2*R, 0, mMouseX - R, mMouseY - R);
      graphics.lineStyle();
      var lc:Number = style.hasValue("light-color") ? style.getNumber("light-color") : 0xffffff;
      graphics.beginGradientFill(GradientType.RADIAL, [lc,lc], aa, bb, xx);
      var sx:Number = Math.max(0, mMouseX - R);
      var sy:Number = Math.max(0, mMouseY - R);
      graphics.drawRect(sx, sy, Math.min(sx + 2*R, width) - sx, Math.min(sy + 2*R, height) - sy);
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

    private function construct():void {
      mLabel = new Label(getStyle("text") as String);
      addChild(mLabel);
    }
  }
}
