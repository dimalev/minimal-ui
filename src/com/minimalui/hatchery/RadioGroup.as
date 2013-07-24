package com.minimalui.hatchery {
  import flash.events.Event;
  import flash.events.EventDispatcher;

  import com.minimalui.events.MEvent;
  import com.minimalui.base.CheckboxBase;

  public class RadioGroup extends EventDispatcher {
    protected var mCheckBoxes:Vector.<CheckboxBase> = new Vector.<CheckboxBase>;
    protected var mChecked:CheckboxBase;

    public function get checked():CheckboxBase { return mChecked; }

    public function set checked(cb:CheckboxBase):void {
      if(mChecked) mChecked.checked = false;
      mChecked = cb;
      if(!mChecked) return;
      mChecked.checked = true;
      this.dispatchEvent(new Event(Event.CHANGE));
    }

    public function push(cb:CheckboxBase):void {
      cb.addEventListener(MEvent.BUTTON_CLICK, onClick);
      cb.isTurnOffableByMouse = false;
      mCheckBoxes.push(cb);
      if(cb.checked) {
        if(mChecked) mChecked.checked = false;
        mChecked = cb;
      }
    }

    protected function onClick(me:MEvent):void {
      var tg:CheckboxBase = me.target as CheckboxBase;
      mChecked = tg.checked ? tg : null;
      for each(var cb:CheckboxBase in mCheckBoxes)
        if(cb != tg) cb.checked = false;
      this.dispatchEvent(new Event(Event.CHANGE));
    }
  }
}