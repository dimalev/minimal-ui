package com.minimalui.hatchery {
  import flash.display.MovieClip;
  import flash.events.Event;

  import com.minimalui.base.BaseContainer;
  import com.minimalui.base.Element;

  public class ScreenManager extends BaseContainer {

    private var mScreens:Object = {};
    private var mCurrentScreen:Element;
    private var mHost:BaseContainer;

    public function get currentScreen():Element { return mCurrentScreen; }

    public function ScreenManager(css:String = null) {
      super(css);
      if(!style.hasValue(BaseContainer.ALIGN)) setStyle(BaseContainer.ALIGN, "center");
      if(!style.hasValue(BaseContainer.VALIGN)) setStyle(BaseContainer.VALIGN, "middle");
    }

    public final function addViews(bc:BaseContainer):void {
      mHost = bc;
      var cc:uint = mHost.numChildren;
      for(var i:uint = 0; i < cc; ++i) {
        var child:Element = bc.getChildAt(i) as Element;
        addScreen(child.id, child);
      }
    }

    public final function select(path:String):Element {
      var res:Object;
      var reg:RegExp = /(#| )?([\w\d\-]+)/g;
      var holder:Element = mHost;
      while(res = reg.exec(path)) {
        if(!(holder is BaseContainer)) return null;
        if(res[1] == "#") {
          holder = (holder as BaseContainer).getById(res[2]);
        } else {
          return null;
        }
      }
      return holder;
    }

    public final function addScreen(name:String, screen:Element):void {
      mScreens[name] = screen;
    }

    public final function getScreen(name:String):Element { return mScreens[name]; }

    public final function showScreen(name:String):void {
      if(mCurrentScreen) removeChild(mCurrentScreen);
      addChild(mCurrentScreen = mScreens[name]);
    }

    public final function clearScreen():void {
      if(!mCurrentScreen) return;
      removeChild(mCurrentScreen);
      mCurrentScreen = null;
    }
  }
}