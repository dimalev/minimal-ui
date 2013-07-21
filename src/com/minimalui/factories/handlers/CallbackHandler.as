package com.minimalui.factories.handlers {
  import com.minimalui.base.Element;
  import com.minimalui.factories.IXMLAttributeHandler;

  public class CallbackHandler implements IXMLAttributeHandler {
    public function handle(name:String, value:String, current:Element, host:Object):Boolean {
      if(name.match(/^on/)) {
        if(current.hasOwnProperty(name)) {
          if(host.hasOwnProperty(value)) {
            current[name] = host[value];
            return true;
          } else trace("[WARNING] callback not found in host object: " + name + " = " + value);
        }
      }
      return false;
    }
  }
}
