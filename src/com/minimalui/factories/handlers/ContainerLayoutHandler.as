package com.minimalui.factories.handlers {
  import com.minimalui.base.Element;
  import com.minimalui.base.BaseContainer;
  import com.minimalui.base.layout.FreeLayout;
  import com.minimalui.containers.RawLayout;
  import com.minimalui.factories.IXMLAttributeHandler;

  public class ContainerLayoutHandler implements IXMLAttributeHandler {
    public function handle(name:String, value:String, current:Element, host:Object):Boolean {
      if(name == "layout") {
        if(current is BaseContainer) {
          if(value == "vertical") BaseContainer(current).containerLayout = new RawLayout(false);
          else if(value == "horizontal") BaseContainer(current).containerLayout = new RawLayout(true);
          else if(value == "heap") BaseContainer(current).containerLayout = new FreeLayout();
          else {
            trace("[WARNING] Unknown layout value: " + value);
            return false;
          }
          return true;
        } else trace("[WARNING] Setting layout for not-container");
      }
      return false;
    }
  }
}
