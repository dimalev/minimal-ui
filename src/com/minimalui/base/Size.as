package com.minimalui.base {
  public class Size {
    public static const TYPE_PIXEL:String = "minimal-ui.size.type.pixel";
    public static const TYPE_SANIMITER:String = "minimal-ui.size.type.santimiter";
    public static const TYPE_PERCENT:String = "minimal-ui.size.type.percent";
    public static const TYPE_NOT_SET:String = "minimal-ui.size.type.not-set";

    public static const SANTIMITER2PIXEL:Number = 100.0;

    public var type:String = TYPE_NOT_SET;
    public var value:Number;

    public Size(t:String = TYPE_NOT_SET, v:Number = 0) {
      type = t;
      value = v;
    }

    public add(asBorder:Vector.<Size>):Size {
      if(asBorder.length != 2) throw new Error("Don't know how to use border with wrong count");
      
    }
  }
}
