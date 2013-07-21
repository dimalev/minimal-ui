package com.minimalui.hatchery {
  import flash.display.DisplayObject;
  import flash.display.MovieClip;
  import flash.events.Event;

  import com.minimalui.base.Element;
  import com.minimalui.base.BaseContainer;
  import com.minimalui.base.LayoutManager;

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

    private function onCoreActivate(e:Event):void { onActivate(); }

    private function onCoreDeactivate(e:Event):void { onDeactivate(); }

    private function onCoreAdd(e:Event):void {
      removeEventListener(Event.ADDED_TO_STAGE, onAdd);
      addEventListener(Event.ACTIVATE, onCoreActivate);
      addEventListener(Event.DEACTIVATE, onCoreDeactivate);
      LayoutManager.setDefault(mLayoutManager = new LayoutManager(stage));
      super.addChild(mStage = new BaseContainer("align:center; valign:middle"));
      mStage.width = stage.stageWidth;
      mStage.height = stage.stageHeight;
      stage.addEventListener(Event.RESIZE, onResizeCore);

      onAdd();
    }

    private function onResizeCore(e:Event):void {
      mStage.width = stage.stageWidth;
      mStage.height = stage.stageHeight;

      onResize();
    }
  }
}