package com.minimalui.base {
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
      ;
      var reg:RegExp = /(#| )?([\w\d\-]+)/g;
      var holder:Element = mHost;
      var res:Object = reg.exec(path);
      while(res) {
        if(!(holder is BaseContainer)) return null;
        if(res[1] == "#") {
          holder = (holder as BaseContainer).getById(res[2]);
        } else {
          return null;
        }
        res = reg.exec(path);
      }
      return holder;
    }

    // ----
    // -- START OF ALPHA SCREEN CHANGING
    // ----

    // protected var mPreviousScreen:Element;
    // protected var mIsRemoving:Boolean = false;
    // protected var mIsShowing:Boolean = false;

    // public function displayScreen(screen:Element):void {
    //   if(mCurrentScreen) {
    //     mPreviousScreen = mCurrentScreen;
    //     mIsRemoving = true;
    //     addEventListener(Event.ENTER_FRAME, onEnterFrame);
    //     mCurrentScreen = screen;
    //     mCurrentScreen.alpha = 0;
    //   } else {
    //     mIsShowing = true;
    //     mCurrentScreen = screen;
    //     mCurrentScreen.alpha = 0;
    //     addChild(mCurrentScreen);
    //     addEventListener(Event.ENTER_FRAME, onEnterFrame);
    //   }
    // }

    // protected function onEnterFrame(e:Event):void {
    //   if(mIsRemoving) {
    //      mPreviousScreen.alpha -= 0.1;
    //      if(mPreviousScreen.alpha <= 0) {
    //        mPreviousScreen.cacheAsBitmap = false;
    //        removeChild(mPreviousScreen);
    //        mPreviousScreen.alpha = 1;
    //        mIsRemoving = !(mIsShowing = true);
    //        addChild(mCurrentScreen);
    //      }
    //   } else {
    //      mCurrentScreen.alpha += 0.1;
    //      if(mCurrentScreen.alpha >= 1) {
    //        mIsShowing = false;
    //        removeEventListener(Event.ENTER_FRAME, onEnterFrame);
    //      }
    //   }
    // }

    // ----
    // -- END OF ALPHA SCREEN CHANGING
    // ----

    public function displayScreen(screen:Element):void {
      if(mCurrentScreen) removeChild(mCurrentScreen);
      addChild(mCurrentScreen = screen);
      dispatchEvent(new Event(Event.CHANGE));
    }

    public final function addScreen(name:String, screen:Element):void {
      mScreens[name] = screen;
    }

    public final function getScreen(name:String):Element { return mScreens[name]; }

    public final function showScreen(name:String):void {
      displayScreen(mScreens[name]);
    }

    public final function clearScreen():void {
      if(!mCurrentScreen) return;
      removeChild(mCurrentScreen);
      mCurrentScreen = null;
    }
  }
}