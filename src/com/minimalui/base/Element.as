package com.minimalui.base {
  import flash.display.Sprite;
  import flash.events.Event;

  import com.minimalui.decoration.IBackgroundDrawer;
  import com.minimalui.base.Style;
  import com.minimalui.events.FieldChangeEvent;
  import com.minimalui.events.StyleNewParentEvent;
  import com.minimalui.events.ElementResizeEvent;

  public class Element extends Sprite {
    protected var defaultStyle:Style;

    public static function ss():Style { return null; }

    public override function set x(xx:Number):void { super.x = Math.round(xx); }
    public override function set y(yy:Number):void { super.y = Math.round(yy); }

    private var mLocks:uint = 0;
    private var mChanged:Boolean = false;

    protected var mStyle:Style;
    public function get style():Style { return mStyle; }
    public function set style(s:Style):void {
      if(mStyle) {
        mStyle.defaults = null;
        mStyle.removeEventListener(FieldChangeEvent.CHANGE, onStyleChange);
        mStyle.removeEventListener(StyleNewParentEvent.NEW_PARENT, onAncestorChange);
      }
      mStyle = s;
      if(!mStyle) return;
      mStyle.defaults = this.defaultStyle;
      mStyle.addEventListener(FieldChangeEvent.CHANGE, onStyleChange);
      mStyle.addEventListener(StyleNewParentEvent.NEW_PARENT, onAncestorChange);
    }

    protected function onStyleChange(fce:FieldChangeEvent):void {
      redraw();
    }

    protected function onAncestorChange(snpe:StyleNewParentEvent):void {
      redraw();
    }

    private var mBackgroundDrawer:IBackgroundDrawer;
    public function set backgroundDrawer(bd:IBackgroundDrawer):void {
      mBackgroundDrawer = bd;
      redraw();
    }

    public function Element() {
      addEventListener(Event.ENTER_FRAME, onEnter);
    }

    private function onEnter(e:Event):void {
      if(mLocks == 0) return;
      mLocks = 0;
      if(mChanged) redraw();
      throw new Error("Overlock!");
    }

    public function lock(bb:Boolean = true):void {
      if(bb) ++mLocks;
      else --mLocks;
      if(mLocks > 0) return;
      if(mChanged) redraw();
    }

    public final function redraw():void {
      if(mLocks > 0) {
        mChanged = true;
        return;
      }
      var ww:Number = width;
      var hh:Number = height;
      graphics.clear();
      coreRedraw();
      mChanged = false;
      coreDrawBackground();
      if(ww != width || hh != height)
        dispatchResize();
    }

    protected function dispatchResize():void {
      dispatchEvent(new ElementResizeEvent());
    }

    protected function coreDrawBackground():void {
      if(!mBackgroundDrawer) return;
      mBackgroundDrawer.drawBackground(this, width, height);
    }

    protected function coreRedraw():void {
      "Implement ME!";
    }
  }
}