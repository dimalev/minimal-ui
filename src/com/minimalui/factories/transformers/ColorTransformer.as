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
      "dark-yellow": 0xeeee00,
      "magenta":0xff00ff,
      "rose":   0xff00cc,
      "grape":  0xcc00ff,
      "cyan":   0x00ffff,
      "violet": 0x990099,
      "brown":  0xcc9900,
      "white":  0xffffff,
      "orange": 0xffa500,
      "dark-orange": 0xff7f00,
      "dark-orange-2": 0x8b4500,
      "dark-salmon": 0xe9967a,
      "orange-red": 0xff2400,
      "pink":   0xffc0cb,
      "hot-pink": 0xff69b4,
      "deep-pink": 0xff1493,
      "light-pink": 0xffb6c1,
      "coral": 0xff7f50,
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
