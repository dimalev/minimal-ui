package com.minimalui.factories {
  // import com.minimalui.containers.Box;
  import com.minimalui.base.Element;
  import com.minimalui.base.BaseContainer;
  import com.minimalui.base.Decorator;
  import com.minimalui.base.DecoratorDescriptor;
  import com.minimalui.factories.handlers.HelpersHandler;
  import com.minimalui.factories.handlers.ContainerLayoutHandler;

  public class XMLFactory {
    public var mCSS:Object = {};
    public var mCSSperObject:Object = {};

    protected var mMapping:Object = {};
    protected var mDecorators:Vector.<DecoratorDescriptor> = new Vector.<DecoratorDescriptor>;
    protected var mAttributeTransformers:Vector.<IXMLAttributeTransformer> = new Vector.<IXMLAttributeTransformer>;
    protected var mAttributeHandlers:Vector.<IXMLAttributeHandler> = new Vector.<IXMLAttributeHandler>;

    public function addAttributeHandler(ah:IXMLAttributeHandler):void {
      mAttributeHandlers.push(ah);
    }

    public function addAttributeTransformer(at:IXMLAttributeTransformer):void {
      mAttributeTransformers.push(at);
    }

    public function addTagHandler(name:String, cl:Class):void {
      if(mMapping.hasOwnProperty(name))
        trace("[WARNING] Name is already occupied " + name + ": " + cl);
      mMapping[name] = cl;
    }

    public function XMLFactory() {
      addAttributeHandler(new HelpersHandler);
      addAttributeHandler(new ContainerLayoutHandler);

      addTagHandler("element", Element);
      addTagHandler("box", BaseContainer);
    }

    public function addDecorator(d:DecoratorDescriptor):void {
      if(mDecorators.indexOf(d) >= 0) return;
      mDecorators.push(d);
    }

    public function setCSS(styles:String):void {
      var records:Array = styles.split("}");
      for each(var record:String in records) {
        var cssd:CSSDescriptor = new CSSDescriptor;
        var parts:Array = record.split("{");
        if(parts.length != 2) continue;
        var name:String = parts[0].replace(/(^\s*|\s*$)/g, "");
        var line:String = "";
        parts = parts[1].split(";");
        for each(var part:String in parts) {
          var values:Array = part.split(":");
          if(values.length != 2) continue;
          var style:String = values[0].replace(/(^\s*|\s*$)/g, "");
          var value:String = values[1].replace(/(^\s*|\s*$)/g, "");
          cssd.extraStyles[style] = value;
        }
        if(name.charAt(0) == ".") mCSS[name.substr(1)] = cssd;
        else mCSSperObject[name] = cssd;
      }
    }

    private function merge(o1:Object, o2:Object):void {
      for(var k:String in o2)
        if(o2.hasOwnProperty(k)) o1[k] = o2[k];
    }

    public function decode(xml:XML, host:Object = null, el:Element = null):Element {
      var d:DecoratorDescriptor;
      var name:String;
      var value:String;
      var cl:Class = name2class(xml.localName());
      if(null == el) el = new cl;
      else if(!(el is cl)) trace("[WARNING] XML factory create element type mismatch! Expected " + cl);
      var styles:Object = [];
      var dd:Vector.<DecoratorDescriptor> = new Vector.<DecoratorDescriptor>;
      var rawCSS:String = "";
      if(mCSSperObject.hasOwnProperty(xml.localName()))
        merge(styles, mCSSperObject[xml.localName()].extraStyles);
      for each(var attribute:XML in xml.attributes()) {
        name = attribute.localName();
        value = attribute.toString();
        if(name == "class") {
          var classes:Array = value.split(" ");
          for each(var c:String in classes) {
            if(!mCSS.hasOwnProperty(c)) continue;
            merge(styles, mCSS[c].extraStyles);
          }
        } else styles[name] = value;
      }

      for(name in styles) {
        value = styles[name];
        var isHandled:Boolean = false;
        for each(var iat:IXMLAttributeTransformer in mAttributeTransformers) {
          var res:Object = iat.transform(name, value, el, host);
          if(!res) continue;
          name = res.newName;
          value = res.newValue;
        }
        for each(var iah:IXMLAttributeHandler in mAttributeHandlers) {
          if(iah.handle(name, value, el, host)) {
            isHandled = true;
            break;
          }
        }
        if(!isHandled) {
          rawCSS += name + ": " + value.replace(/:/g, "\\:").replace(/;/g , "\\;") + "; ";
          for each(d in mDecorators) {
            if(d.styles.indexOf(name) < 0 && !(value == "on" && name == d.name)) continue;
            if(dd.indexOf(d) < 0) dd.push(d);
          }
        }
      }

      // trace("rawCSS: " + rawCSS);

      for each(d in dd) el.addDecorator(d.instanceFor(el));

      el.setStyles(rawCSS);
      if(!(el is BaseContainer)) return el;
      var bc:BaseContainer = BaseContainer(el);
      for each(var child:XML in xml.children()) {
        bc.addChild(decode(child, host));
      }
      return el;
    }

    public function name2class(name:String):Class {
      var cl:Class = mMapping[name];
      if(cl) return cl;
      trace("[ERROR] Class for object not found: " + name);
      return null;
    }
  }
}

import com.minimalui.base.DecoratorDescriptor;

class CSSDescriptor {
  public var extraStyles:Object = {};
}
