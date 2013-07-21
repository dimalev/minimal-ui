package com.minimalui.events {
  import flash.events.Event;

  public class MEvent extends Event {
    public static const BUTTON_CLICK:String = "minimalui.button.click";
    public static const OVER:String = "minimalui.button.over";
    public static const OUT:String = "minimalui.button.out";

    public function MEvent(type:String) {
      super(type);
    }
  }
}
