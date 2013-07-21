package com.minimalui.factories.handlers {
  import com.minimalui.base.Element;
  import com.minimalui.base.BaseButton;
  import com.minimalui.factories.IXMLAttributeHandler;

  public class ButtonHandler implements IXMLAttributeHandler {
    public function handle(name:String, value:String, current:Element, host:Object):Boolean {
      if(name == "click") {
        if(current is BaseButton) {
          if(host.hasOwnProperty(value)) {
            (current as BaseButton).onClick = host[value];
            return true;
          } else trace("[WARNING] Callback not found: " + value);
        } else trace("[WARNING] 'click' attribute on non-button!");
      }
      return false;
    }
  }
}
