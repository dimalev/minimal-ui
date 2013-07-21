package com.minimalui.base.layout {
  import flash.geom.Rectangle;

  import com.minimalui.base.BaseContainer;

  /**
   * Encapsulates layout logic to make BaseContainer more flexible.
   */
  public class BaseLayout implements ILayout {
    protected var mTarget:BaseContainer;

    public function set target(trg:BaseContainer):void { mTarget = trg; }
    public function get target():BaseContainer { return mTarget; }

    public function measure():Rectangle {
      throw new Error("You should implement measure!");
    }

    public function layout(width:Number, height:Number):Rectangle {
      throw new Error("You should implement layout!");
    }
  }
}
