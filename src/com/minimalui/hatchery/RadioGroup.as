package com.minimalui.hatchery {
  import flash.events.Event;
  import flash.events.EventDispatcher;

  import com.minimalui.events.MEvent;
  import com.minimalui.base.BaseCheckbox;

  public class RadioGroup extends EventDispatcher {
    protected var mCheckBoxes:Vector.<BaseCheckbox> = new Vector.<BaseCheckbox>;
    protected var mChecked:BaseCheckbox;
    protected var mCanBeEmpty:Boolean;
    protected var mOnChange:Function;

    public function set onChange(cb:Function):void { mOnChange = cb; }
    public function get onChange():Function { return mOnChange; }

    public function get checked():BaseCheckbox { return mChecked; }

    public function set checked(cb:BaseCheckbox):void {
      if(mChecked) mChecked.checked = false;
      mChecked = cb;
      if(!mChecked) return;
      mChecked.checked = true;
      this.dispatchEvent(new Event(Event.CHANGE));
    }

    public function push(cb:BaseCheckbox):void {
      cb.addEventListener(MEvent.BUTTON_CLICK, onClick);
      cb.isTurnOffableByMouse = mCanBeEmpty;
      mCheckBoxes.push(cb);
      if(cb.checked) {
        if(mChecked) mChecked.checked = false;
        mChecked = cb;
      }
    }

    public function RadioGroup(canBeEmpty:Boolean = false) { mCanBeEmpty = canBeEmpty; }

    protected function onClick(me:MEvent):void {
      var tg:BaseCheckbox = me.target as BaseCheckbox;
      mChecked = tg.checked ? tg : null;
      for each(var cb:BaseCheckbox in mCheckBoxes)
        if(cb != tg) cb.checked = false;
      mOnChange(tg);
      this.dispatchEvent(new Event(Event.CHANGE));
    }
  }
}