package com.minimalui.events {
  import flash.events.Event;
  public class FieldChangeEvent extends Event {
    public static const CHANGE:String = "minimalui.style.change-field";

    public var fields:Vector.<String>;

    public function FieldChangeEvent(fields:Vector.<String>) {
      super(CHANGE);
      this.fields = fields;
    }

    public function contains(fields:Vector.<String>):Boolean {
      for each(var field:String in fields)
        if(this.fields.indexOf(field) >= 0) return true;
      return false;
    }
  }
}
