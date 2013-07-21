package com.minimalui.decorators {
  import com.minimalui.base.Decorator;
  import com.minimalui.base.DecoratorDescriptor;
  import com.minimalui.base.Element;

  public class Border extends Decorator {
    public static const WIDTH:String = "border-width";
    public static const DELTA:String = "border-delta";
    public static const COLOR:String = "border-color";
    private static var sDescriptor:DecoratorDescriptor =
      new DecoratorDescriptor("border", Border,
                              Vector.<String>([WIDTH, COLOR, DELTA]));

    public static function get descriptor():DecoratorDescriptor { return sDescriptor; }

    public function Border(trg:Element) {
      super(trg);
      trg.style.addChange(WIDTH, COLOR, DELTA);
    }

    public override function onAfterRedraw():void {
      if(!target.style.hasValue(WIDTH)) return;
      var step:Number = target.style.getNumber(DELTA);
      var color:Number = target.style.hasValue(COLOR) ? target.style.getNumber(COLOR) : 0xAAAAAA;
      target.graphics.lineStyle(target.style.getNumber(WIDTH), color);
      target.graphics.drawRect(step, step, target.width - 2 * step - 1, target.height - 2 * step - 1);
      target.graphics.lineStyle(-1);
    }
  }
}