package com.minimalui.base {
  import flash.display.DisplayObject;
  import flash.display.MovieClip;
  import flash.events.Event;

  import com.minimalui.hatchery.ToolTips;
  import com.minimalui.factories.XMLFactory;
  import com.minimalui.factories.handlers.ToolTipsHandler;

  /**
   *  Takes care of installing all the required infrastructure of minimal ui ecosystem. you just have to override
   *  protected void onAdd function.
   *
   *  TODO: add uifactory, by default it will be XMLFactory. you can overload it's creation.
   *  TODO: add default screen manager. same as factory. maybe parameterize it with XML files of screens, or Classes
   *        implementing screens.
   */
  public class Application extends MovieClip {

    private var mStage:BaseContainer;

    private var mLayoutManager:LayoutManager;

    protected var mUIFactory:XMLFactory;
    protected var mScreenManager:ScreenManager;
    protected var mToolTips:ToolTips;

    public override function get numChildren():int { return mStage.numChildren; }

    /**
     * Application layout manager.
     */
    public function get layoutManager():LayoutManager { return mLayoutManager; }

    public function Application() {
      addEventListener(Event.ADDED_TO_STAGE, onCoreAdd);
    }

    public override function addChild(d:DisplayObject):DisplayObject { return mStage.addChild(d); }

    public override function addChildAt(d:DisplayObject, i:int):DisplayObject { return mStage.addChildAt(d, i); }

    public override function removeChild(d:DisplayObject):DisplayObject { return mStage.removeChild(d); }

    public override function removeChildAt(i:int):DisplayObject { return mStage.removeChildAt(i); }

    public final function get uifactory():XMLFactory { return mUIFactory; }

    public final function get screenManager():ScreenManager { return mScreenManager; }

    public final function get tooltips():ToolTips { return mToolTips; }

    /**
     * Entry point for your application.
     */
    protected function onAdd():void {}

    /**
     * Stage resize reactor.
     */
    protected function onResize():void {}

    protected function onActivate():void {}

    protected function onDeactivate():void {}

    protected function getXMLFactory():XMLFactory { return new XMLFactory; }

    protected function getScreenManager():ScreenManager {
      return new ScreenManager("percent-width:100; percent-height:100");
    }

    protected function getToolTips():ToolTips { return new ToolTips; }

    private function onCoreActivate(e:Event):void { onActivate(); }

    private function onCoreDeactivate(e:Event):void { onDeactivate(); }

    private function onCoreAdd(e:Event):void {
      // Listeners
      removeEventListener(Event.ADDED_TO_STAGE, onAdd);
      addEventListener(Event.ACTIVATE, onCoreActivate);
      addEventListener(Event.DEACTIVATE, onCoreDeactivate);
      // Factory
      mUIFactory = getXMLFactory();
      // Layout
      LayoutManager.setDefault(mLayoutManager = new LayoutManager(stage, mUIFactory));
      // Tool tips
      mToolTips = getToolTips();
      if(mToolTips) mUIFactory.addAttributeHandler(new ToolTipsHandler(mToolTips));
      // Screen manager
      mScreenManager = getScreenManager();
      // Fake stage to layout elements
      super.addChild(mStage = new BaseContainer("align:center; valign:middle"));
      mStage.width = stage.stageWidth;
      mStage.height = stage.stageHeight;
      stage.addEventListener(Event.RESIZE, onResizeCore);

      // initiating main components
      addChild(mScreenManager);
      addChild(mToolTips);

      onAdd();
    }

    private function onResizeCore(e:Event):void {
      mStage.width = stage.stageWidth;
      mStage.height = stage.stageHeight;

      onResize();
    }
  }
}