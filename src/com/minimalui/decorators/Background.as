package com.minimalui.decorators {
  import com.minimalui.base.Decorator;
  import com.minimalui.base.DecoratorDescriptor;
  import com.minimalui.base.Element;

  public class Background extends Decorator {
    public static const COLOR:String = "background-color";
    public static const TRANSPARENCY:String = "background-transparency";
    public static const RADIUS:String = "background-radius";
    private static var sDescriptor:DecoratorDescriptor =
      new DecoratorDescriptor("background", Background,
                              Vector.<String>([COLOR, TRANSPARENCY, RADIUS]));

    public static function get descriptor():DecoratorDescriptor { return sDescriptor; }

    public function Background(trg:Element) {
      super(trg);
      trg.style.addChange(COLOR, TRANSPARENCY, RADIUS);
    }

    public override function onBeforeRedraw():void {
      if(!target.style.hasValue(COLOR)) return;
      var t:Number = target.style.hasValue(TRANSPARENCY) ? target.style.getNumber(TRANSPARENCY) : 1;
      target.graphics.beginFill(target.style.getNumber(COLOR), t);
      if(target.style.hasValue(RADIUS))
        target.graphics.drawRoundRect(0, 0, target.width, target.height, target.style.getNumber(RADIUS));
      else target.graphics.drawRect(0, 0, target.width, target.height);
      target.graphics.endFill();
    }
  }
}