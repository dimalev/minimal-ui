package com.minimalui.base {
  import flash.display.Stage;
  import flash.events.Event;e

  public class LayoutManager {
    private static var sDefault:LayoutManager;
    public static function getDefault():LayoutManager { return sDefault; }
    public static function setDefault(lm:LayoutManager):void {
      if(sDefault) throw new Error("There is already set default layout manager.");
      sDefault = lm;
    }

    private var mDirty:Vector.<Element> = new Vector.<Element>;
    private var mResized:Vector.<Element> = new Vector.<Element>;

    public function LayoutManager(st:Stage) {
      st.addEventListener(Event.ENTER_FRAME, tick);
    }

    public function setDirty(e:Element):void {
      if(mDirty.indexOf(e) >=0) return;
      mDirty.push(e);
    }

    public function invalidateSize(e:Element):void {
      if(mResized.indexOf(e) >=0) return;
      mResized.push(e);
    }

    public function tick(e:Event):void {
      var changed:Vector.<Element> = new Vector.<Element>;

      while(mDirty.length > 0) {
        var dirty:Vector.<Element> = mDirty.splice(0, mDirty.length);
        for each(var e:Element in dirty) {
          if(changed.indexOf(e) <= 0) changed.push(e);
          e.commitProperties();
        }
      }

      var parents:Vector.<Element> = new Vector.<Element>;
      var resized:Vector.<Element> = mResized.splice(0, mResized.length);
      for each(e in resized) {
        var p:Element = e;
        while(true) {
          p.invalidateSize();
          if(p.parent = null) break;
          p = p.parent;
        }
        if(parents.indexOf(p) < 0) parents.push(p);
      }

      mResized.splice(0, mResized.length);
      for each(e in parents) { e.measure(); }
      if(mResized.length > 0) throw new Error("Should not exist resized elements after measure step!");

      for each(e in parents) e.layout();
      for each(e in changed) e.redraw();
    }
  }
}
