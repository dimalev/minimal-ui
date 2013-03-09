package com.minimalui.decorators {
  import com.minimalui.base.Decorator;
  import com.minimalui.base.Element;

  public class Border extends Decorator {
    public function Border(trg:Element) {
      super(trg);
    }

    public override function onAfterRedraw():void {
      if(!target.style.hasValue("border-width")) return;
      var step:Number = target.style.getNumber("border-delta");
      var color:Number = target.style.hasValue("border-color") ? target.style.getNumber("border-color") : 0xAAAAAA;
      target.graphics.lineStyle(target.style.getNumber("border-width"), color);
      target.graphics.drawRect(step, step, target.width - 2 * step - 1, target.height - 2 * step - 1);
      target.graphics.lineStyle(-1);
    }
  }
}
