package com.minimalui.factories.transformers {
  import com.minimalui.base.Element;
  import com.minimalui.factories.IXMLAttributeTransformer;

  public class ColorTransformer implements IXMLAttributeTransformer {
    private var mColorScheme:Object = {
      "red":    0xff0000,
      "green":  0x00ff00,
      "blue":   0x0000ff,
      "black":  0x000000,
      "yellow": 0xffff00,
      "violet": 0x990099,
      "brown":  0xcc9900,
      "white":  0xffffff,
      "gray":   0x888888,
      "dark-gray": 0x444444,
      "light-gray": 0xbbbbbb
    };

    public function transform(name:String, value:String, current:Element, host:Object):Object {
      if(name.indexOf("color") < 0 || !mColorScheme.hasOwnProperty(value)) return null;
      return {newName: name, newValue: mColorScheme[value]};
    }
  }
}
