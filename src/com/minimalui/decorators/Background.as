package com.minimalui.decorators {
  import com.minimalui.base.Decorator;
  import com.minimalui.base.Element;

  public class Background extends Decorator {
    public function Background(trg:Element) {
      super(trg);
    }

    public override function onBeforeRedraw():void {
      if(!target.style.hasValue("background-color")) return;
      target.graphics.beginFill(target.style.getNumber("background-color"));
      target.graphics.drawRect(0, 0, target.width, target.height);
      target.graphics.endFill();
    }
  }
}
