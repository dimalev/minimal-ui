package com.minimalui.factories.handlers {
  import com.minimalui.base.Element;
  import com.minimalui.factories.IXMLAttributeHandler;

  public class HelpersHandler implements IXMLAttributeHandler {
    public function handle(name:String, value:String, current:Element, host:Object):Boolean {
      if(name == "padding") {
        current.paddings = Number(value);
        return true;
      }
      if(name == "margin") {
        current.margins = Number(value);
        return true;
      }
      if(name == "id") {
        current.id = value;
        if(host && host.hasOwnProperty(value))
          host[value] = current;
        return true;
      }
      return false;
    }
  }
}
