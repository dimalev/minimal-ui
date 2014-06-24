package com.minimalui.decorators {
  import flash.display.GradientType;
  import flash.geom.Matrix;
  import flash.geom.Point;

  import com.minimalui.base.Decorator;
  import com.minimalui.base.DecoratorDescriptor;
  import com.minimalui.base.BaseButton;
  import com.minimalui.base.Element;
  import com.minimalui.tools.Tools;

  public class WinButtonBackground extends Decorator {
    public static const COLOR:String = "win-background-color";
    public static const BORDER_COLOR:String = "win-border-color";
    public static const HOVER:String = "win-background-color-hover";
    public static const DISABLED:String = "win-background-disabled-color";
    public static const REDUCTION:String = "win-background-reduction";
    public static const LIGHT_RADIUS:String = "win-light-radius";
    public static const LIGHT_COLOR:String = "win-light-color";
    private static var sDescriptor:DecoratorDescriptor =
      new DecoratorDescriptor("win-button-background", WinButtonBackground,
                              Vector.<String>([COLOR, HOVER, DISABLED, REDUCTION, LIGHT_RADIUS, LIGHT_COLOR]));

    public static function get descriptor():DecoratorDescriptor { return sDescriptor; }

    public function WinButtonBackground(trg:Element) {
      super(trg);
      trg.style.addChange(COLOR, HOVER, DISABLED, REDUCTION, LIGHT_RADIUS, LIGHT_COLOR);
    }

    public override function onBeforeRedraw():void {
      var color:Number = target.style.hasValue(COLOR) ? target.style.getNumber(COLOR) : 0xaa0000;
      var borderColor:Number = target.style.hasValue(BORDER_COLOR) ? target.style.getNumber(BORDER_COLOR) : color;
      var padding:Number = 0;
      if((target as BaseButton).disabled) {
        color = target.style.hasValue(DISABLED) ? target.style.getNumber(DISABLED) : 0x777777;
      } else if((target as BaseButton).isMouseOver) {
          color = target.style.hasValue(HOVER) ? target.style.getNumber(HOVER) : 0x00aa00;
          if((target as BaseButton).isMouseDown) padding = 2;
      }
      var red:Number = target.style.hasValue(REDUCTION) ? target.style.getNumber(REDUCTION) : 0.3;
      var cc:Array = [color, Tools.rgbReduce(color, red, red, red)];
      var aa:Array = [1,1];
      var bb:Array = [0,255];
      var xx:Matrix = new Matrix();
      xx.createGradientBox(target.width, target.height, 90);// * Math.PI / 180);
      target.graphics.lineStyle(0, Tools.rgbReduce(borderColor, 0.6, 0.6, 0.6));
      target.graphics.beginGradientFill(GradientType.LINEAR, cc, aa, bb, xx);
      target.graphics.drawRect(0,0, target.width, target.height);
      target.graphics.endFill();
      if(!(target as BaseButton).isMouseOver || (target.getStyle("disabled") == "true")) return;
      aa = [0.5,0];
      var R:Number = target.style.hasValue(LIGHT_RADIUS) ? target.style.getNumber(LIGHT_RADIUS) : 25;
      xx.createGradientBox(2*R, 2*R, 0, target.mouseX - R, target.mouseY - R);
      target.graphics.lineStyle();
      var lc:Number = target.style.hasValue(LIGHT_COLOR) ? target.style.getNumber(LIGHT_COLOR) : 0xffffff;
      target.graphics.beginGradientFill(GradientType.RADIAL, [lc,lc], aa, bb, xx);
      var sx:Number = Math.max(0, target.mouseX - R);
      var sy:Number = Math.max(0, target.mouseY - R);
      target.graphics.drawRect(sx, sy, Math.min(sx + 2*R, target.width) - sx, Math.min(sy + 2*R, target.height) - sy);
      target.graphics.endFill();
    }
  }
}