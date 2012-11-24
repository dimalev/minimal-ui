package com.minimalui.controls {
  import flash.display.Sprite;

  import com.minimalui.base.Element;

  public class ElementWrapper extends Element {
    private var mTrg:Sprite;

    public override function get width():Number { return mTrg.width; }
    public override function get height():Number { return mTrg.height; }

    public function get instance():Sprite { return mTrg; }

    public function ElementWrapper(s:Sprite) {
      addChild(mTrg = s);
    }
  }
}