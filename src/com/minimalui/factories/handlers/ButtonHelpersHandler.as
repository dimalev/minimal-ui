package com.minimalui.factories.handlers {
  import com.minimalui.base.Element;
  import com.minimalui.base.BaseButton;
  import com.minimalui.factories.IXMLAttributeHandler;

  public class ButtonHelpersHandler implements IXMLAttributeHandler {
    public function handle(name:String, value:String, current:Element, host:Object):Boolean {
      if(name == "disabled" && current is BaseButton) {
        (current as BaseButton).disabled = value == "yes";
        return true;
      }
      return false;
    }
  }
}
