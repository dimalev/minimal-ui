package com.minimalui.factories.handlers {
  import flash.display.Loader;
  import flash.net.URLRequest;

  import com.minimalui.base.Element;
  import com.minimalui.hatchery.Image;
  import com.minimalui.factories.IXMLAttributeHandler;

  public class ImageHandler implements IXMLAttributeHandler {
    public function handle(name:String, value:String, current:Element, host:Object):Boolean {
      if(name == Image.SRC) {
        if(current is Image)
          (((current as Image).content = new Loader()) as Loader).load(new URLRequest(attribute));
        else trace("[WARNING] 'src' is specified for not-image element!");
        return true;
      }
      return false;
    }
  }
}
