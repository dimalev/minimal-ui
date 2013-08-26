package com.minimalui.factories.handlers {
  import flash.display.Loader;
  import flash.net.URLRequest;

  import com.minimalui.base.Element;
  import com.minimalui.hatchery.Image;
  import com.minimalui.factories.IXMLAttributeHandler;
  import com.minimalui.resources.IImageStaticSource;

  public class StaticSourceImageHandler implements IXMLAttributeHandler {
    private var mSource:IImageStaticSource;

    public function StaticSourceImageHandler(source:IImageStaticSource) {
      mSource = source;
    }

    public function handle(name:String, value:String, current:Element, host:Object):Boolean {
      if(name == Image.STATIC_SRC) {
        if(current is Image) {
          if(mSource.has(value))
            (current as Image).content = mSource.retrieve(value);
          else trace("[WARNING] Static image " + name + " not found!");
        } else trace("[WARNING] 'static-src' is specified for not-image element!");
      }
      return false;
    }
  }
}
