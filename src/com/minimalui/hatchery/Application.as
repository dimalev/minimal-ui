package com.minimalui.hatchery {
  import flash.display.MovieClip;
  import flash.events.Event;

  import com.minimalui.base.Element;
  import com.minimalui.base.LayoutManager;

  /**
   *  Takes care of installing all the required infrastructure of minimal ui ecosystem. you just have to override
   *  protected void onAdd function.
   */
  public class Application extends MovieClip {

    private var mScreens:Object = {};
    private var mCurrentScreen:Element;
    private var mInternalContainer:ScreenManager;

    private var mLayoutManager:LayoutManager;

    /**
     * Application layout manager.
     */
    public function get layoutManager():LayoutManager { return mLayoutManager; }

    /**
     * Application screen manager.
     */
    public function get screenManager():ScreenManager { return mInternalContainer; }

    public function Application() {
      addEventListener(Event.ADDED_TO_STAGE, onCoreAdd);
    }

    /**
     * Entry point for your application.
     */
    protected function onAdd():void {}

    /**
     * Stage resize reactor.
     */
    protected function onResize():void {}

    private function onCoreAdd(e:Event):void {
      removeEventListener(Event.ADDED_TO_STAGE, onAdd);
      LayoutManager.setDefault(mLayoutManager = new LayoutManager(stage));
      addChild(mInternalContainer = new ScreenManager());
      mInternalContainer.width = stage.stageWidth;
      mInternalContainer.height = stage.stageHeight;
      stage.addEventListener(Event.RESIZE, onResizeCore);

      onAdd();
    }

    private function onResizeCore(e:Event):void {
      mInternalContainer.width = stage.stageWidth;
      mInternalContainer.height = stage.stageHeight;

      onResize();
    }
  }
}