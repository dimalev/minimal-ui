package com.minimalui.factories.handlers {
  import com.minimalui.base.Element;
  import com.minimalui.base.BaseCheckbox;
  import com.minimalui.hatchery.RadioGroup;
  import com.minimalui.factories.IXMLAttributeHandler;

  public class CheckboxHelpersHandler implements IXMLAttributeHandler {
    public function handle(name:String, value:String, current:Element, host:Object):Boolean {
      if(name == "toggle-on-click" && current is BaseCheckbox) {
        (current as BaseCheckbox).toggleOnClick = value == "yes";
        return true;
      }
      return false;
    }
  }
}
