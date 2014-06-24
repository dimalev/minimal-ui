package com.minimalui.base {
  import com.minimalui.controls.Label;

  public class BaseProgressBar extends BaseContainer {
    public static const PROGRESS:String = "progress";
    protected var mLabel:Label;
    protected var mBackground:Element;
    protected var mBar:Element;

    public function BaseProgressBar(idorcss:String = null, id:String = null) {
      super(idorcss, id);
      buildBackground();
      buildBar();
      addChild(mBackground);
      addChild(mBar);
    }

    protected override function coreCommitProperties():void {
      if(hasChanged(Vector.<String>([PROGRESS]))) {
        mBar.setStyle("percent-width", Math.min(Math.max(style.getNumber(PROGRESS), 0), 100));
      }
      if(hasChanged(Vector.<String>([Label.TEXT_CONTENT]))) {
        mLabel.setStyle("text", Math.min(Math.max(style.getNumber(PROGRESS), 0), 100));
      }
    }

    protected function buildBackground():void {
      mBackground = uifactory.decode(<element border-width="1" border-color="dark-gray" height="7"
                                              percent-height="100" percent-width="100" />);
    }

    protected function buildBar():void {
      mBar = uifactory.decode(<element margin="2" background-color="violet" height="3" />);
    }
  }
}