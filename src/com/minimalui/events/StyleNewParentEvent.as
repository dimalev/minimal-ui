package com.minimalui.events {
  import flash.events.Event;
  public class StyleNewParentEvent extends Event {
    public static const NEW_PARENT:String = "minimalui.style.new-parent";

    public function StyleNewParentEvent() {
      super(NEW_PARENT);
    }
  }
}
