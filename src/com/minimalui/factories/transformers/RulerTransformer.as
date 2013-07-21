package com.minimalui.factories.transformers {
  import com.minimalui.base.Element;
  import com.minimalui.factories.IXMLAttributeTransformer;

  import flash.system.Capabilities;

  public class RulerTransformer implements IXMLAttributeTransformer {
    private var mDPC:Number;
    private var mDPI:Number;

    public function RulerTransformer(dpi:Number = NaN) {
      if(isNaN(dpi)) dpi = Capabilities.screenDPI;
      mDPI = dpi;
      mDPC = dpi / 2.54;
    }
    public function transform(name:String, value:String, current:Element, host:Object):Object {
      var res:Object;
      var output:Object;
      if(value.match(/(\d+)sm/)) {
        res = /(\d+)sm/.exec(value);
        output = { newName: name, newValue: Math.round(Number(res[1]) * mDPC) };
      } else if(value.match(/(\d+)inch/)) {
        res = /(\d+)inch/.exec(value);
        output = { newName: name, newValue: Math.round(Number(res[1]) * mDPI) };
      }
      return output;
    }
  }
}
