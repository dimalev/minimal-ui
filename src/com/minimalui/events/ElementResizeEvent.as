package com.minimalui.events {
  import flash.events.Event;
  public class ElementResizeEvent extends Event {
    public static const RESIZE:String = "minimalui.element.resize";

    public function ElementResizeEvent() {
      super(RESIZE);
    }
  }
}
