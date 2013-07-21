package com.minimalui.factories.handlers {
  import com.minimalui.base.Element;
  import com.minimalui.controls.Checkbox;
  import com.minimalui.hatchery.RadioGroup;
  import com.minimalui.factories.IXMLAttributeHandler;

  public class RadioGroupHandler implements IXMLAttributeHandler {
    protected var mRadioGroups:Object = {};

    public function handle(name:String, value:String, current:Element, host:Object):Boolean {
      if(name == "radio-group") {
        if(current is Checkbox) {
          var group:RadioGroup;
          if(mRadioGroups.hasOwnProperty(value)) group = mRadioGroups[value];
          else {
            group = new RadioGroup();
            mRadioGroups[value] = group;
          }
          group.push(current as Checkbox);
          return true;
        } else trace("[WARNING] 'radio-group' attribute on non-checkbox!");
      }
      return false;
    }
  }
}
