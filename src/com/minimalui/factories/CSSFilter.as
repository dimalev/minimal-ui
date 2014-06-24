package com.minimalui.factories {
  import com.minimalui.base.Style;

  /**
   * Object filter.
   */
  public class CSSFilter {
    public static function fromString(str:String):CSSFilter {
      var parts:Object = /(?<tagName>[-\w\d]+)?(\.(?<cssName>[-\w\d]+))?(:(?<namespace>[-\w\d]+))?/.exec(str);
      return new CSSFilter(parts[1], parts[3], parts[5]);
    }

    public var tagName:String;
    public var className:String;
    public var classNamespace:String;
    public function CSSFilter(tagName:String,
                              className:String = null,
                              classNamespace:String = "default") {
      this.tagName = tagName;
      this.className = className;
      this.classNamespace = classNamespace;
    }

    public function match(tagName:String, classNames:Vector.<String> = null):Boolean {
      if(this.className) {
        if(!classNames) return false;
        if(classNames.indexOf(this.className) < 0) return false;
      }
      if(this.tagName && this.tagName != tagName) return false;
      return true;
    }
  }
}