package com.minimalui.factories {
  import com.minimalui.base.Element;

  public interface IXMLAttributeHandler {
    function handle(name:String, value:String, current:Element, host:Object):Boolean;
  }
}
