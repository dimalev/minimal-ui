package com.minimalui.factories {
  // import com.minimalui.containers.Box;
  import com.minimalui.base.Element;
  import com.minimalui.base.BaseContainer;
  import com.minimalui.base.Decorator;
  import com.minimalui.base.DecoratorDescriptor;
  import com.minimalui.containers.VBox;
  import com.minimalui.containers.HBox;
  import com.minimalui.containers.ScrollControlBase;
  import com.minimalui.controls.Label;
  import com.minimalui.controls.Button;
  import com.minimalui.controls.Input;

  public class XMLFactory {
    public var mCSS:Object = {};
    public var mCSSperObject:Object = {};

    protected var mDecorators:Vector.<DecoratorDescriptor> = new Vector.<DecoratorDescriptor>;

    public function XMLFactory() {
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
          if(style == "margin" || style == "padding") {
            for each(var s1:String in ["-left", "-top", "-bottom", "-right"])
              line += style + s1 + ":" + value + ";";
          } else {
            line += style + ":" + value + ";";
            for each(var d:DecoratorDescriptor in mDecorators) {
              if(d.styles.indexOf(style) < 0) continue;
              if(cssd.decorators.indexOf(d) < 0) cssd.decorators.push(d);
            }
          }
        }
        cssd.stylesLine = line;
        if(name.charAt(0) == ".") mCSS[name.substr(1)] = cssd;
        else mCSSperObject[name] = cssd;
      }
    }

    public function decode(xml:XML):Element {
      var d:DecoratorDescriptor;
      var el:Element = new (name2class(xml.localName()));
      var styles:String = "";
      var dd:Vector.<DecoratorDescriptor> = new Vector.<DecoratorDescriptor>;
      if(mCSSperObject.hasOwnProperty(xml.localName())) {
        styles += mCSSperObject[xml.localName()].stylesLine;
        for each(d in mCSSperObject[xml.localName()].decorators)
          if(dd.indexOf(d) < 0) dd.push(d);
      }
      for each(var attribute:XML in xml.attributes()) {
        var name:String = attribute.localName();
        if(name == "class") {
          var classes:Array = attribute.toString().split(" ");
          for each(var c:String in classes) {
            if(!mCSS.hasOwnProperty(c)) continue;
            styles += mCSS[c].stylesLine;
            for each(d in mCSS[c].decorators)
              if(dd.indexOf(d) < 0) dd.push(d);
          }
        } else {
          if(name == "margin") el.margins = Number(attribute.toString());
          else if(name == "padding") el.paddings = Number(attribute.toString());
          else if(name == "id") el.id = attribute.toString();
          else {
            styles += name + ": " + attribute.toString().replace(":", "\\:").replace(";", "\\;") + ";";
            for each(d in mDecorators) {
              if(d.styles.indexOf(name) < 0) continue;
              if(dd.indexOf(d) < 0) dd.push(d);
            }
          }
        }
      }

      for each(d in dd) el.addDecorator(d.instanceFor(el));

      el.setStyles(styles);
      if(!(el is BaseContainer)) return el;
      var bc:BaseContainer = BaseContainer(el);
      for each(var child:XML in xml.children()) {
          bc.addChild(decode(child));
      }
      return el;
    }

    public function name2class(name:String):Class {
      switch(name) {
      case "hbox": return HBox;
      case "vbox": return VBox;
      case "label": return Label;
      case "button": return Button;
      case "input": return Input;
      case "scrollControlBase": return ScrollControlBase;
      }
      return null;
    }
  }
}

import com.minimalui.base.DecoratorDescriptor;

class CSSDescriptor {
  public var stylesLine:String;
  public var decorators:Vector.<DecoratorDescriptor> = new Vector.<DecoratorDescriptor>;
}