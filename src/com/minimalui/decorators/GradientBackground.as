package com.minimalui.decorators {
  import flash.display.GradientType;
  import flash.geom.Matrix;

  import com.minimalui.base.Decorator;
  import com.minimalui.base.DecoratorDescriptor;
  import com.minimalui.base.Element;
  import com.minimalui.tools.Tools;

  public class GradientBackground extends Decorator {
    public static const LEFT_COLOR:String = "background-gradient-color-1";
    public static const RIGHT_COLOR:String = "background-gradient-color-2";
    public static const ROTATION:String = "background-gradient-rotation";
    public static const RADIUS:String = "background-gradient-radius";
    private static const sDD:DecoratorDescriptor = new DecoratorDescriptor("background-gradient", GradientBackground,
                                                       Vector.<String>([LEFT_COLOR, RIGHT_COLOR, ROTATION,RADIUS]));

    public static function get descriptor():DecoratorDescriptor { return sDD; }

    public function GradientBackground(trg:Element) {
      super(trg);
      trg.style.addChange(LEFT_COLOR, RIGHT_COLOR, ROTATION, RADIUS);
    }

    public override function onBeforeRedraw():void {
      if(!target.style.hasValue(LEFT_COLOR)) return;
      var c1:Number = target.style.hasValue(LEFT_COLOR) ? target.style.getNumber(LEFT_COLOR) : 0xffff00;
      var c2:Number = target.style.hasValue(RIGHT_COLOR) ?
        target.style.getNumber(RIGHT_COLOR) :
        Tools.rgbReduce(c1, 0.5, 0.5, 0.5);
      var m:Matrix = new Matrix();
      var a:Number = (target.style.hasValue(ROTATION) ? target.style.getNumber(ROTATION) : 90) / 180 * Math.PI;
      m.createGradientBox(target.width, target.height, a);
      target.graphics.beginGradientFill(GradientType.LINEAR, [c1, c2], [1,1], [0, 255], m);
      if(target.style.hasValue(RADIUS))
        target.graphics.drawRoundRect(0, 0, target.width, target.height, target.style.getNumber(RADIUS));
      else target.graphics.drawRect(0, 0, target.width, target.height);
      target.graphics.endFill();
    }
  }
}