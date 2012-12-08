package com.minimalui.controls {
  import flash.display.Sprite;

  import com.minimalui.base.Element;

  public class ElementWrapper extends Element {
    private var mTrg:Sprite;

    public function get instance():Sprite { return mTrg; }

    public function ElementWrapper(s:Sprite) {
      addChild(mTrg = s);
    }

    protected override function coreMeasure():void {
      mMeasuredWidth = mTrg.width;
      mMeasuredHeight = mTrg.height;
    }
  }
}