package com.minimalui.base {
  import flash.display.MovieClip;
  import flash.events.Event;

  public class Application extends MovieClip {

    private var mScreens:Object = {};
    private var mCurrentScreen:Element;
    private var mInternalContainer:BaseContainer;

    private var mLayoutManager:LayoutManager;

    public function get layoutManager():LayoutManager { return mLayoutManager; }

    public function get currentScreen():Element { return mCurrentScreen; }

    public function Application() {
      addEventListener(Event.ADDED_TO_STAGE, onCoreAdd);
    }

    public final function addScreen(name:String, screen:Element):void {
      mScreens[name] = screen;
    }

    public final function showScreen(name:String):void {
      if(mCurrentScreen) mInternalContainer.removeChild(mCurrentScreen);
      mInternalContainer.addChild(mCurrentScreen = mScreens[name]);
    }

    public final function clearScreen():void {
      if(!mCurrentScreen) return;
      mInternalContainer.removeChild(mCurrentScreen);
      mCurrentScreen = null;
    }

    protected function onAdd():void {}

    private function onCoreAdd(e:Event):void {
      removeEventListener(Event.ADDED_TO_STAGE, onAdd);
      LayoutManager.setDefault(mLayoutManager = new LayoutManager(stage));
      addChild(mInternalContainer = new BaseContainer("align: center; valign:middle"));
      mInternalContainer.width = stage.stageWidth;
      mInternalContainer.height = stage.stageHeight;

      onAdd();
    }
  }
}