package com.minimalui.base.debug {
  import com.minimalui.base.Element;

  public class LayoutReports {
    public static const COMMIT_STEP:String = "minimalui.layout.step.commit";
    public static const MEASURE_STEP:String = "minimalui.layout.step.measure";
    public static const LAYOUT_STEP:String = "minimalui.layout.step.layout";
    public static const REDRAW_STEP:String = "minimalui.layout.step.redraw";

    public static var REPORTS_BUFFER:uint = 20;

    protected var mDoReports:Boolean = false;
    protected var mReports:Array = [];
    protected var mCurrentReport:Object;

    public final function set doReports(bb:Boolean):void { mDoReports = bb; }

    public function LayoutReports() {
    }

    public function startReport():void {
      if(!mDoReports) return;
      mReports.push(mCurrentReport = {});
      if(mReports.length > REPORTS_BUFFER) mReports.shift();
    }

    public function stage(type:String, arr:Vector.<Element>):void {
      if(!mDoReports) return;
      mCurrentReport[type] = arr;
    }

    public function endReport():void {
      if(!mDoReports) return;
      mCurrentReport = null;
    }
  }
}