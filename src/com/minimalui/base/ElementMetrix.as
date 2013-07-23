package com.minimalui.base {
  import flash.display.DisplayObject;

  public class ElementMetrix {
    public var t:Number;
    public var l:Number;
    public var r:Number;
    public var b:Number;
    public var pt:Number;
    public var pr:Number;
    public var pl:Number;
    public var pb:Number;
    public var mt:Number;
    public var mr:Number;
    public var ml:Number;
    public var mb:Number;
    public var w:Number;
    public var h:Number;
    public var pw:Number;
    public var ph:Number;
    public var mw:Number;
    public var mh:Number;
    public var pos:String;

    protected var mAdaptee:DisplayObject;

    public final function get adaptee():DisplayObject { return mAdaptee; }

    public function ElementMetrix(o:DisplayObject) {
      adopt(o);
    }

    public function validatedSize():void {
      if(mAdaptee is Element) {
        var e:Element = mAdaptee as Element;
        if(!e.isSizeInvalid) {
          w = e.width
          h = e.height;
        }
      } else w = h = NaN;
    }

    public function layout(w:Number, h:Number):void {
      if(mAdaptee is Element) {
        var e:Element = mAdaptee as Element;
        e.layout(w,h);
        validatedSize();
        return;
      }
      mAdaptee.width = w;
      mAdaptee.height = h;
    }

    public function move(x:Number, y:Number):void {
      if(mAdaptee is Element) {
        var e:Element = mAdaptee as Element;
        e.move(x, y);
        return;
      }
      mAdaptee.x = x;
      mAdaptee.y = y;
    }

    public function adopt(o:DisplayObject):void {
      mAdaptee = o;
      if(o is Element) {
        var e:Element = o as Element;
        t = e.style.hasValue(Element.TOP)    ? e.style.getNumber(Element.TOP)    : NaN;
        r = e.style.hasValue(Element.RIGHT)  ? e.style.getNumber(Element.RIGHT)  : NaN;
        l = e.style.hasValue(Element.LEFT)   ? e.style.getNumber(Element.LEFT)   : NaN;
        b = e.style.hasValue(Element.BOTTOM) ? e.style.getNumber(Element.BOTTOM) : NaN;
        pt = e.style.getNumber(Element.PADDING_TOP);
        pr = e.style.getNumber(Element.PADDING_RIGHT);
        pl = e.style.getNumber(Element.PADDING_LEFT);
        pb = e.style.getNumber(Element.PADDING_BOTTOM);
        mt = e.style.getNumber(Element.MARGIN_TOP);
        mr = e.style.getNumber(Element.MARGIN_RIGHT);
        ml = e.style.getNumber(Element.MARGIN_LEFT);
        mb = e.style.getNumber(Element.MARGIN_BOTTOM);
        mw = e.measuredWidth;
        mh = e.measuredHeight;
        pos = e.style.hasValue(Element.POSITION) ? e.style.getString(Element.POSITION) : Element.POSITION_RELATIVE;
        if(!e.isSizeInvalid) {
          w = e.width;
          h = e.height;
        } else w = h = NaN;
        pw = e.style.hasValue(Element.PERCENT_WIDTH) ? e.style.getNumber(Element.PERCENT_WIDTH) : NaN;
        ph = e.style.hasValue(Element.PERCENT_HEIGHT) ? e.style.getNumber(Element.PERCENT_HEIGHT) : NaN;
        return;
      }
      pt = pr = pl = pb = mt = mr = ml = mb = 0;
      mw = w = o.width;
      mh = h = o.height;
      pw = ph = NaN;
    }

    public function toString():String { return "ElementMetrix"; }
  }
}