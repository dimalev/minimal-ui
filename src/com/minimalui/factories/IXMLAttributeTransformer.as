package com.minimalui.factories {
  import com.minimalui.base.Element;

  public interface IXMLAttributeTransformer {
    function transform(name:String, value:String, current:Element, host:Object):Object;
  }
}
