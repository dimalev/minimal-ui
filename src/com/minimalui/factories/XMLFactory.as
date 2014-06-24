package com.minimalui.factories {
  // import com.minimalui.containers.Box;
  import com.minimalui.base.Style;
  import com.minimalui.base.Element;
  import com.minimalui.base.BaseContainer;
  import com.minimalui.base.Decorator;
  import com.minimalui.base.DecoratorDescriptor;
  import com.minimalui.factories.handlers.HelpersHandler;
  import com.minimalui.factories.handlers.ContainerLayoutHandler;

  /**
   * XML parser and object builder.
   */
  public class XMLFactory implements IFactory {
    protected var mMapping:Object = {};
    protected var mDecorators:Vector.<DecoratorDescriptor> = new Vector.<DecoratorDescriptor>;
    protected var mAttributeTransformers:Vector.<IXMLAttributeTransformer> = new Vector.<IXMLAttributeTransformer>;
    protected var mAttributeHandlers:Vector.<IXMLAttributeHandler> = new Vector.<IXMLAttributeHandler>;
    protected var mCSS:CSSFactory = new CSSFactory;

    /**
     * CSS styles and classes provider.
     */
    public function get cssFactory():CSSFactory { return mCSS; }

    /**
     * Register attribute handler.
     *
     * @param ah XML Attribute handler.
     */
    public function addAttributeHandler(ah:IXMLAttributeHandler):void {
      mAttributeHandlers.push(ah);
    }

    /**
     * Register attribute transformer.
     *
     * @param at XML attribute transformer.
     */
    public function addAttributeTransformer(at:IXMLAttributeTransformer):void {
      mAttributeTransformers.push(at);
    }

    /**
     * Register tag handler by class representing it as UI Element.
     *
     * @param name tag name to handle.
     * @param cl Class to create.
     */
    public function addTagHandler(name:String, cl:Class):void {
      if(mMapping.hasOwnProperty(name))
        trace("[WARNING] Name is already occupied " + name + ": " + mMapping[name]);
      mMapping[name] = cl;
    }

    /**
     * Register decorator.
     *
     * @param d Decorator descriptor.
     */
    public function addDecorator(d:DecoratorDescriptor):void {
      if(mDecorators.indexOf(d) >= 0) return;
      mDecorators.push(d);
    }

    public function XMLFactory() {
      addAttributeHandler(new HelpersHandler);
      addAttributeHandler(new ContainerLayoutHandler);

      addTagHandler("element", Element);
      addTagHandler("box", BaseContainer);
    }

    private function merge(o1:Object, o2:Object):void {
      for(var k:String in o2)
        if(o2.hasOwnProperty(k) && !o1.hasOwnProperty(k)) o1[k] = o2[k];
    }

    public function decode(data:*, host:Object = null, el:Element = null):Element {
      if(!(data is XML)) {
        trace("XMLFactory can parse only xml. given: " + data);
        return el;
      }
      var xml:XML = data as XML;
      var tagName:String = xml.localName();
      var d:DecoratorDescriptor;
      var name:String;
      var nsname:String;
      var value:String;
      var shouldInitialize:Boolean = false;
      var cl:Class = name2class(tagName);
      if(null == el) {
        if(null == cl) {
          trace("[ERROR] XML factory create element: no such tag handler: " + tagName);
          return null;
        }
        el = new cl;
        shouldInitialize = true;
      } else if(!(el is cl)) trace("[WARNING] XML factory create element: type mismatch! Expected " + cl);
      var styles:Object = [];
      var dd:Vector.<DecoratorDescriptor> = new Vector.<DecoratorDescriptor>;
      var rawCSS:String = "";
      var classes:Vector.<String> = null;
      for each(var attribute:XML in xml.attributes()) {
        name = attribute.localName();
        value = attribute.toString();
        if(name == "class") classes = Vector.<String>(value.split(" "));
        else styles[name] = value;
      }
      merge(styles, cssFactory.extraStylesFor(tagName, classes));

      var parsedStyles:Object = {};
      for(nsname in styles) {
        var parts:Array = nsname.split(":");
        name = parts[0];
        var ns:String = parts.length > 1 ? parts[1] : Style.DEFAULT_NAMESPACE;
        value = styles[nsname];
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
          for each(d in mDecorators) {
            if(d.styles.indexOf(name.split(":")[0]) < 0 && !(value == "on" && name == d.name)) continue;
            if(dd.indexOf(d) < 0) dd.push(d);
          }
          parsedStyles[name + ":" + ns] = value;
        }
      }

      for each(d in dd) el.addDecorator(d.instanceFor(el));

      el.style.setValues(parsedStyles);
      if(!(el is BaseContainer)) {
        if((el is Element) && shouldInitialize) (el as Element).initialize();
        return el;
      }
      var bc:BaseContainer = BaseContainer(el);
      for each(var child:XML in xml.children()) {
        var e:Element = decode(child, host);
        if(e) bc.addChild(e);
      }
      if((el is Element) && shouldInitialize) (el as Element).initialize();
      return el;
    }

    protected function name2class(tagName:String):Class {
      if(!mMapping.hasOwnProperty(tagName)) return null;
      return mMapping[tagName];
    }
  }
}
