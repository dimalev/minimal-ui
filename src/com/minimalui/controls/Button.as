package com.minimalui.controls {
  import flash.display.Sprite;
  import flash.display.GradientType;
  import flash.geom.Matrix;
  import flash.geom.Point;

  import com.minimalui.base.BaseContainer;
  import com.minimalui.base.Decorator;
  import com.minimalui.containers.HBox;
  import com.minimalui.decorators.Border;
  import com.minimalui.decorators.Background;
  import com.minimalui.tools.Tools;

  /**
   * Implements basic Button.
   */
  public class Button extends BaseButton {
    public static const BACKGROUND_COLOR_HOVER:String = "background-color-hover";

    /**
     * Default constructor.
     *
     * @param text label on the button
     * @param idorcss if this is last parameter - this is element id, otherwise this parameter is treated as css
     * @param id id of the element.
     */
   public function Button(idorcss:String = null, id:String = null) {
      super(idorcss, id);
      cleanDecorators();
    }

    protected override function coreRedraw():void {
      var color:Number = style.hasValue(BACKGROUND_COLOR) ? style.getNumber(BACKGROUND_COLOR) : 0xaa0000;
      var padding:Number = 0;
      if((getStyle("disabled") == "true")) {
        color = style.hasValue(BACKGROUND_DISABLED_COLOR) ? style.getNumber(BACKGROUND_DISABLED_COLOR) : 0x777777;
      } else if(isMouseOver) {
          color = style.hasValue(BACKGROUND_COLOR_HOVER) ? style.getNumber(BACKGROUND_COLOR_HOVER) : 0x00aa00;
          if(isMouseDown) padding = 2;
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
      if(!isMouseOver || (getStyle("disabled") == "true")) return;
      aa = [0.5,0];
      var R:Number = style.hasValue("light-radius") ? style.getNumber("light-radius") : 25;
      xx.createGradientBox(2*R, 2*R, 0, mouseX - R, mouseY - R);
      graphics.lineStyle();
      var lc:Number = style.hasValue("light-color") ? style.getNumber("light-color") : 0xffffff;
      graphics.beginGradientFill(GradientType.RADIAL, [lc,lc], aa, bb, xx);
      var sx:Number = Math.max(0, mouseX - R);
      var sy:Number = Math.max(0, mouseY - R);
      graphics.drawRect(sx, sy, Math.min(sx + 2*R, width) - sx, Math.min(sy + 2*R, height) - sy);
      graphics.endFill();
    }
  }
}
