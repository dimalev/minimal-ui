package com.minimalui.events {
  import flash.events.Event;

  public class MEvent extends Event {
    public static const BUTTON_CLICK:String = "minimalui.button.click";

    public function MEvent(type:String) {
      super(type);
    }
  }
}
