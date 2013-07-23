package com.minimalui.base {
  import flash.display.Stage;
  import flash.display.DisplayObject;
  import flash.events.Event;

  import com.minimalui.base.debug.LayoutReports;
  import com.minimalui.factories.XMLFactory;

  /**
   * Controls and takes care of layout and update process.
   */
  public final class LayoutManager {
    private static var sDefault:LayoutManager;
    /**
     * Get default manager.
     */
    public static function getDefault():LayoutManager { return sDefault; }
    /**
     * Set default manager.
     */
    public static function setDefault(lm:LayoutManager):void {
      if(sDefault) throw new Error("There is already set default layout manager.");
      sDefault = lm;
    }

    private var mVersatiles:Vector.<Element> = new Vector.<Element>;

    private var mDirty:Vector.<Element> = new Vector.<Element>;
    private var mResized:Vector.<Element> = new Vector.<Element>;
    private var mChanged:Vector.<Element> = new Vector.<Element>;

    private var mMeasured:Vector.<Element> = new Vector.<Element>;

    private var mStage:Stage;
    private var mFactory:XMLFactory;
    private var mReport:LayoutReports = new LayoutReports;

    /**
     * Get reports about each layout cycle.
     */
    public function get reports():LayoutReports { return mReport; }

    /**
     * Current stage.
     */
    public function get stage():Stage { return mStage; }

    /**
     * Default layout factory.
     */
    public function get uifactory():XMLFactory { return mFactory; }

    /**
     * Constructor.
     *
     * @param st Reference to stage object. One of uses - update elements on EXIT_FRAME event
     */
    public function LayoutManager(st:Stage = null, f:XMLFactory = null) {
      // TODO: move no-staged layout into another layout strategy - stage-less.
      if(st) {
        mStage = st;
        mStage.addEventListener(Event.ENTER_FRAME, beforeTick);
        mStage.addEventListener(Event.EXIT_FRAME, tick);
      }
      mFactory = f;
    }

    /**
     * Mark object as dirty. See layout stages description.
     *
     * @param e Target element.
     */
    public function setDirty(e:Element):void {
      if(mDirty.indexOf(e) >=0) return;
      mDirty.push(e);
    }

    /**
     * Marks element as persistently changed. Calls redraw on each enter frame.
     *
     * @param e Target element.
     * @param bb If it is versatile.
     */
    public function setVersatile(e:Element, b:Boolean):void {
      var i:int = mVersatiles.indexOf(e);
      if(b) {
        if(i < 0) mVersatiles.push(e);
      } else {
        if(i >= 0) mVersatiles.splice(i, 1);
      }
    }

    /**
     * Mark object as resized. See layout stages description.
     *
     * @param e Target element.
     */
    public function invalidateSize(e:Element):void {
      if(mResized.indexOf(e) >=0) return;
      mResized.push(e);
    }

    /**
     * Mark object as changed. See layout stages description.
     *
     * @param e Target element.
     */
    public function setChanged(e:Element):void {
      if(mChanged.indexOf(e) >=0) return;
      mChanged.push(e);
    }

    /**
     * @private
     */
    public function beforeTick(event:Event):void {
      var versatiles:Vector.<Element> = mVersatiles.slice();
      for each(var versatile:Element in versatiles)
        if(!versatile.isChanged) versatile.update();
    }

    /**
     * @private
     */
    public function tick(event:Event):void { forceUpdate(); }

    /**
     * Perform all layout and validation stages.
     */
    public function forceUpdate():void {
      mReport.startReport();
      while(mDirty.length > 0) {
        mReport.stage(LayoutReports.COMMIT_STEP, mDirty.slice());
        commitStage();
      }
      layoutStage();
      mReport.stage(LayoutReports.LAYOUT_STEP, mMeasured.splice(0, mMeasured.length));
      mReport.stage(LayoutReports.REDRAW_STEP, mChanged.slice());
      redrawStage();
      mReport.endReport();
    }

    private function commitStage():void {
      var e:Element;
      var dirty:Vector.<Element> = mDirty.splice(0, mDirty.length);
      for each(e in dirty) e.commitProperties();
      for each(e in dirty) e.style.cleanChanged();
    }

    private function layoutStage():void {
      var e:Element;

      var parents:Vector.<Element> = new Vector.<Element>;
      var resized:Vector.<Element> = mResized.slice(0, mResized.length);
      for each(e in resized) {
        var p:Element = e;
        while(true) {
          p.invalidateSize();
          if(!(p.parent && p.parent is BaseContainer)) break;
          p = BaseContainer(p.parent);
        }
        if(parents.indexOf(p) < 0) parents.push(p);
      }

      mResized.splice(0, mResized.length); // All for measurement

      for each(e in parents) /*if(e.stage)*/ recursiveMeasure(e); // make root-element dependent!

      for each(e in parents) /*if(e.stage)*/ { // make root-element dependent!
        e.layout();
        e.move();
      }
    }

    private function recursiveMeasure(e:Element):void {
      if(e is BaseContainer)
        for(var i:uint = 0; i < e.numChildren; ++i) {
          var c:DisplayObject = e.getChildAt(i);
          if(!(c is Element)) continue;
          var ce:Element = Element(c);
          if(!ce.isSizeInvalid) continue;
          recursiveMeasure(ce);
        }
      mMeasured.push(e);
      e.measure();
    }

    private function redrawStage():void {
      var changed:Vector.<Element> = mChanged.splice(0, mChanged.length);
      for each(var e:Element in changed) e.redraw();
    }
  }
}
