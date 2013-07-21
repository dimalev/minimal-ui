package com.minimalui.base {
  import flash.display.DisplayObject;

  public class RotatedElementMetrix extends ElementMetrix {
    public function RotatedElementMetrix(o:DisplayObject) {
      super(o);
    }

    public override function validatedSize():void {
      if(mAdaptee is Element) {
        var e:Element = mAdaptee as Element;
        if(!e.isSizeInvalid) {
          w = e.height;
          h = e.width;
        }
      } else w = h = NaN;
    }

    public override function layout(w:Number, h:Number):void {
      if(mAdaptee is Element) {
        var e:Element = mAdaptee as Element;
        e.layout(h, w);
        return;
      }
      mAdaptee.width = h;
      mAdaptee.height = w;
    }

    public override function move(x:Number, y:Number):void {
      if(mAdaptee is Element) {
        var e:Element = mAdaptee as Element;
        e.move(y, x);
        return;
      }

      mAdaptee.x = y;
      mAdaptee.y = x;
    }

    public override function adopt(o:DisplayObject):void {
      mAdaptee = o;
      if(o is Element) {
        var e:Element = o as Element;
        pt = e.style.getNumber(Element.PADDING_LEFT);
        pr = e.style.getNumber(Element.PADDING_BOTTOM);
        pl = e.style.getNumber(Element.PADDING_TOP);
        pb = e.style.getNumber(Element.PADDING_RIGHT);
        mt = e.style.getNumber(Element.MARGIN_LEFT);
        mr = e.style.getNumber(Element.MARGIN_BOTTOM);
        ml = e.style.getNumber(Element.MARGIN_TOP);
        mb = e.style.getNumber(Element.MARGIN_RIGHT);
        mw = e.measuredHeight;
        mh = e.measuredWidth;
        if(!e.isSizeInvalid) {
          w = e.height;
          h = e.width;
        } else w = h = NaN;
        pw = e.style.hasValue(Element.PERCENT_HEIGHT) ? e.style.getNumber(Element.PERCENT_HEIGHT) : NaN;
        ph = e.style.hasValue(Element.PERCENT_WIDTH) ? e.style.getNumber(Element.PERCENT_WIDTH) : NaN;
        return;
      }
      pt = pr = pl = pb = mt = mr = ml = mb = 0;
      mw = w = o.height;
      mh = h = o.width;
      pw = ph = NaN;
    }

    public override function toString():String { return "RotatedElementMetrix"; }
  }
}