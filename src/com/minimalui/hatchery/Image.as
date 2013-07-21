package com.minimalui.hatchery {
  import flash.display.DisplayObject;
  import flash.display.Loader;
  import flash.events.Event;
  import flash.net.URLRequest;

  import com.minimalui.base.Element;

  public class Image extends Element {
    public static const SRC:String = "src";
    public static const STATIC_SRC:String = "static-src";

    protected var mContent:DisplayObject;
    public function set content(d:DisplayObject):void {
      if(mContent) {
        removeChild(mContent);
        if(mContent is Loader)
          (mContent as Loader).contentLoaderInfo.removeEventListener(Event.COMPLETE, onLoaded);
      }
      if(mContent = d) {
        addChild(d);
        if(d is Loader)
          (d as Loader).contentLoaderInfo.addEventListener(Event.COMPLETE, onLoaded);
      }
      invalidateSize();
    }

    public function get content():DisplayObject { return mContent; }

    protected override function coreCommitProperties():void {
      if(hasChanged(Vector.<String>([SRC]))) {
        var l:Loader = new Loader;
        l.load(new URLRequest(getStyle(SRC) as String));
        content = l;
      }
    }

    protected override function coreMeasure():void {
      if(mContent) {
        if(mContent is Loader) {
          var loader:Loader = mContent as Loader;
          if(loader.contentLoaderInfo.bytesLoaded == loader.contentLoaderInfo.bytesTotal &&
             loader.contentLoaderInfo.bytesTotal > 0) {
            if(isNaN(mMeasuredWidth)) mMeasuredWidth = loader.contentLoaderInfo.width;
            if(isNaN(mMeasuredHeight)) mMeasuredHeight = loader.contentLoaderInfo.height;
            return;
          }
        } else {
          if(isNaN(mMeasuredWidth)) mMeasuredWidth = mContent.width;
          if(isNaN(mMeasuredHeight)) mMeasuredHeight = mContent.height;
          return;
        }
      }
      mRealWidth = mRealHeight = mMeasuredWidth = mMeasuredHeight = NaN;
    }

    protected override function coreLayout():void {
      if(!mContent) return;
      mContent.width = mLayoutWidth;
      mContent.height = mLayoutHeight;
    }

    public function Image(child:DisplayObject = null, cssorid:String = null, id:String = null) {
      super(cssorid, id);
      content = child;
    }

    private function onLoaded(e:Event):void {
      (mContent as Loader).contentLoaderInfo.removeEventListener(Event.COMPLETE, onLoaded);
      invalidateSize();
    }
  }
}