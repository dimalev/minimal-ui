package com.minimalui.factories.handlers {
  import com.minimalui.base.Element;
  import com.minimalui.containers.ToolTips;
  import com.minimalui.factories.IXMLAttributeHandler;

  public class ToolTipsHandler implements IXMLAttributeHandler {
    protected var mToolTips:ToolTips;

    public function ToolTipsHandler(tooltips:ToolTips) {
      mToolTips = tooltips;
    }

    public function handle(name:String, value:String, current:Element, host:Object):Boolean {
      if(name == "alt") {
        mToolTips.listenTo(current, value);
        return true;
      }
      return false;
    }
  }
}
