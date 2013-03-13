package com.minimalui.controls {
  import com.minimalui.base.Element;

  public class Scroll extends BaseContainer {
    private var mRunner:Element = new Element;
    public function Scroll(css:String) {
      super(css);
      construct();
    }

    protected override function coreCommitProperties():void {
      if(hasChanged(Vector.<String>(["width"])) {
        mRunner.setStyle("width", getStyle("width"));
      }
      if(hasChanged(Vector.<String>(["runner-color"])) {
        mRunner.setStyle("background-color", getStyle("runner-color"));
      }
    }

    private function construct():void {
      addChild(mRunner);

    }
  }
}