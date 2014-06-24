package com.minimalui.base {
  import flash.display.DisplayObject;
  import flash.display.MovieClip;
  import flash.display.StageScaleMode;
  import flash.display.StageAlign;
  import flash.events.Event;
  import flash.utils.describeType;
  import flash.ui.Multitouch;
  import flash.ui.MultitouchInputMode;

  import com.minimalui.containers.ToolTips;
  import com.minimalui.factories.XMLFactory;
  import com.minimalui.factories.handlers.ToolTipsHandler;

  /**
   *  Takes care of installing all the required infrastructure of minimal ui ecosystem. you just have to override
   *  protected void onAdd function.
   */
  public class Application extends MovieClip {

    private var mStage:BaseContainer;

    private var mLayoutManager:LayoutManager;

    protected var mUIFactory:XMLFactory;
    protected var mScreenManager:ScreenManager;
    protected var mModalLayer:BaseContainer;
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

    public final function showModal(el:Element):void {
      mModalLayer.addChild(el);
      el.addEventListener(Event.CLOSE, onModalClose);
      mScreenManager.mouseChildren = mScreenManager.mouseEnabled = false;
    }

    private function onModalClose(e:Event):void {
      mModalLayer.removeChild((e.target) as Element);
      mScreenManager.mouseChildren = mScreenManager.mouseEnabled = mModalLayer.numChildren == 0;
    }

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

    /**
     * Override this to create own main screen layout. For example you can player toolbar in the bottom of the screen,
     * or main menu on top. But don't forget to initialize mScreenManager!
     */
    protected function initScreenManager():void {
      mScreenManager = getScreenManager();
      addChild(mScreenManager);
    }

    private function onCoreActivate(e:Event):void { onActivate(); }

    private function onCoreDeactivate(e:Event):void { onDeactivate(); }

    private function onCoreAdd(e:Event):void {
      Multitouch.inputMode=MultitouchInputMode.TOUCH_POINT;
      stage.align = StageAlign.TOP_LEFT;
      stage.scaleMode = StageScaleMode.NO_SCALE;
      // Listeners
      removeEventListener(Event.ADDED_TO_STAGE, onAdd);
      addEventListener(Event.ACTIVATE, onCoreActivate);
      addEventListener(Event.DEACTIVATE, onCoreDeactivate);
      // Factory
      mUIFactory = getXMLFactory();
      // Layout
      LayoutManager.setDefault(mLayoutManager = new LayoutManager(stage, mUIFactory));

      // Fake stage to layout elements
      super.addChild(mStage = new BaseContainer("align:center; valign:middle"));
      mStage.width = stage.stageWidth;
      mStage.height = stage.stageHeight;
      stage.addEventListener(Event.RESIZE, onResizeCore);

      // Styles
      corePlugStyles();

      // Init tool tips
      mToolTips = getToolTips();
      if(mToolTips) mUIFactory.addAttributeHandler(new ToolTipsHandler(mToolTips));

      // Screen manager
      initScreenManager();

      // Interface
      corePlugInterface();

      // Modal layer
      mModalLayer = new BaseContainer("percent-width:100; percent-height:100; align:center; valign:middle");

      // initiating main components
      addChild(mModalLayer);

      // Plug tooltips
      addChild(mToolTips);

      onAdd();
    }

    private function corePlugStyles():void {
      var td:XML = describeType(this);
      for each(var v:XML in td.variable) {
        var CSS:XML = v.metadata.(@name == "CSS")[0];
        if(CSS) {
          // TODO: filter by screen size, dpi of other parameters
          // For example: [CSS(min-w=800, min-h=600)] and [CSS(max-w=800, max-h=600)] can split interface for small
          // screens and big ones
          uifactory.cssFactory.parse(String(new this[v.@name]()));
        }
      }
    }

    private function corePlugInterface():void {
      var td:XML = describeType(this);
      for each(var v:XML in td.variable) {
        var Interface:XML = v.metadata.(@name == "Interface")[0];
        if(Interface) {
          // TODO: filter by screen size, dpi of other parameters
          var screen:BaseContainer = uifactory.decode(new XML(new this[v.@name]()), this) as BaseContainer;
          screenManager.addScreen(screen.id, screen);
        }
      }
    }

    private function onResizeCore(e:Event):void {
      mStage.width = stage.stageWidth;
      mStage.height = stage.stageHeight;

      onResize();
    }
  }
}