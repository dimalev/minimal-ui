package com.minimalui.decorators {
  import com.minimalui.base.Decorator;
  import com.minimalui.base.Element;

  public class Border extends Decorator {
    public function Border(trg:Element) {
      super(trg);
    }

    public override function onBeforeRedraw():void {
      if(!target.style.hasValue("border-width")) return;
      target.graphics.lineStyle(target.style.getNumber("border-width"));
      target.graphics.drawRect(0, 0, target.width, target.height);
    }
  }
}
