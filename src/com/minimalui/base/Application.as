package com.minimalui.base {
  import flash.display.MovieClip;
  import flash.events.Event;

  public class Application extends MovieClip {

    private var mScreens:Object = {};
    private var mCurrentScreen:Element;

    public function Application() {
      addEventListener(Event.ADDED_TO_STAGE, onCoreAdd);
    }

    public final function addScreen(name:String, screen:Element):void {
      mScreens[name] = screen;
    }

    public final function showScreen(name:String):void {
      if(mCurrentScreen) removeChild(mCurrentScreen);
      addChild(mCurrentScreen = mScreens[name]);
      mCurrentScreen.x = (stage.stageWidth - mCurrentScreen.width) / 2;
      mCurrentScreen.y = (stage.stageHeight - mCurrentScreen.height) / 2;
    }

    public final function clearScreen():void {
      if(!mCurrentScreen) return;
      removeChild(mCurrentScreen);
      mCurrentScreen = null;
    }

    protected function onAdd():void {}

    private function onCoreAdd(e:Event):void {
      removeEventListener(Event.ADDED_TO_STAGE, onAdd);
      LayoutManager.setDefault(new LayoutManager(stage));

      onAdd();
    }
  }
}