package com.minimalui.decorators {
  import flash.display.GradientType;
  import flash.geom.Matrix;

  import com.minimalui.base.Decorator;
  import com.minimalui.base.DecoratorDescriptor;
  import com.minimalui.base.Element;

  public class GradientBackground extends Decorator {
    private static const sDD:DecoratorDescriptor = new DecoratorDescriptor("background-gradient", GradientBackground,
        Vector.<String>(["background-gradient-color-1", "background-gradient-color-2"]));

    public static function get descriptor():DecoratorDescriptor { return sDD; }

    public function GradientBackground(trg:Element) {
      super(trg);
    }

    public override function onBeforeRedraw():void {
      if(!target.style.hasValue("background-gradient-color-1")
         || !target.style.hasValue("background-gradient-color-2")) return;
      var c1:Number = target.style.getNumber("background-gradient-color-1");
      var c2:Number = target.style.getNumber("background-gradient-color-2");
      var m:Matrix = new Matrix();
      m.createGradientBox(target.width, target.height, Math.PI/2);
      target.graphics.beginGradientFill(GradientType.LINEAR, [c1, c2], [1,1], [0, 255], m);
      target.graphics.drawRect(0, 0, target.width, target.height);
      target.graphics.endFill();
    }
  }
}
