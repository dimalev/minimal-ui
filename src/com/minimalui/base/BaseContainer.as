package com.minimalui.base {
  import flash.display.DisplayObject;
  import flash.geom.Rectangle;

  /**
   * Basic container. Groups elements independently one above another, while aligning them according to settings.
   * Brings valuable tool functions for such derives as Horizontal and Vertical box.
   */
  public class BaseContainer extends Element {
    /**
     * Constructs container with given CSS properties and/or id.
     *
     * @param idorcss treated as id, if this is only parameter, or CSS properties, if not, or not match \w+ pattern.
     * @param id id of the element, if passed.
     */
    public function BaseContainer(idorcss:String = null, id:String = null) {
      super(idorcss, id);
    }

    public override function addChild(d:DisplayObject):DisplayObject {
      var e:Element = d as Element;
      if(null == e) return super.addChild(d);
      invalidateSize();
      return super.addChild(e) as Element;
    }

    public override function removeChild(d:DisplayObject):DisplayObject {
      var e:Element = d as Element;
      if(null == e) return super.removeChild(d);
      var i:int = getChildIndex(e);
      if(i < 0) return null;
      invalidateSize();
      return super.removeChild(e) as Element;
    }

    public override function removeChildAt(i:int):DisplayObject {
      if(i > numChildren) return null;
      return super.removeChildAt(i);
    }

    public function getById(id:String):Element {
      if(this.id == id) return this;
      for(var i:uint = 0; i < numChildren; ++i) {
        var c:Element = getChildAt(i) as Element;
        if(!c) continue;
        if(c is BaseContainer) {
          var e:Element = (c as BaseContainer).getById(id);
          if(e) return e;
        } else if(c.id == id) return c;
      }
      return null;
    }

    protected override function coreMeasure():void {
      mMeasuredWidth = style.getNumber(Element.PADDING_LEFT) + style.getNumber(Element.PADDING_RIGHT);
      mMeasuredHeight = style.getNumber(Element.PADDING_TOP) + style.getNumber(Element.PADDING_BOTTOM);
      for(var i:uint = 0; i < numChildren; ++i) {
        var o:DisplayObject = getChildAt(i);
        var innerW:Number;
        var innerH:Number;
        if(!(o is Element)) {
          innerW = o.width + style.getNumber(Element.PADDING_LEFT) + style.getNumber(Element.PADDING_RIGHT);
          innerH = o.height + style.getNumber(Element.PADDING_TOP) + style.getNumber(Element.PADDING_BOTTOM);
        } else {
          var c:Element = o as Element;
          innerW = c.measuredWidth
            + Math.max(style.getNumber(Element.PADDING_LEFT), c.style.getNumber(Element.MARGIN_LEFT))
            + Math.max(style.getNumber(Element.PADDING_RIGHT), c.style.getNumber(Element.MARGIN_RIGHT));
          innerH = c.measuredHeight
            + Math.max(style.getNumber(Element.PADDING_TOP), c.style.getNumber(Element.MARGIN_TOP))
            + Math.max(style.getNumber(Element.PADDING_BOTTOM), c.style.getNumber(Element.MARGIN_BOTTOM));
        }
        mMeasuredWidth = Math.max(mMeasuredWidth, innerW);
        mMeasuredHeight = Math.max(mMeasuredHeight, innerH);
      }
      mRealWidth = mMeasuredWidth;
      mRealHeight = mMeasuredHeight;
    }

    protected override function coreLayout():void {
      for(var i:uint = 0; i < numChildren; ++i) {
        var c:Element = getChildAt(i) as Element;
        if(null == c) continue;
        var w:Number = c.measuredWidth;
        var h:Number = c.measuredHeight;
        var l:Number = Math.max(mStyle.getNumber("padding-left"), c.style.getNumber("margin-left"));
        var r:Number = Math.max(mStyle.getNumber("padding-right"), c.style.getNumber("margin-right"));
        var t:Number = Math.max(mStyle.getNumber("padding-top"), c.style.getNumber("margin-top"));
        var b:Number = Math.max(mStyle.getNumber("padding-bottom"), c.style.getNumber("margin-bottom"));
        if(c.style.hasValue("percent-width"))
          w = c.style.getNumber("percent-width") * (mViewPort.width - l - r) / 100;
        if(c.style.hasValue("percent-height"))
          w = c.style.getNumber("percent-height") * (mViewPort.height - t - b) / 100;
        switch(getStyle("align") || "left") {
        case "center":
          l = (mViewPort.width - w) / 2;
          break;
        case "right":
          l = mViewPort.width - w - r;
          break;
        }
        switch(getStyle("valign") || "top") {
        case "middle":
          t = (mViewPort.height - h) / 2;
          break;
        case "bottom":
          t = mViewPort.height - h - b;
          break;
        }
        c.layout(new Rectangle(l, t, w, h));
      }
      setChanged();
    }

    /**
     * Tool function.
     */
    protected function pack(f:Vector.<Number>, s:Number):Number {
      var N:uint = (f.length - 2) / 3;
      var res:Number = 0;
      for(var i:uint = 1; i <= N; ++i)
        res += Math.max(f[i*3-3], f[i*3-2], s) + f[i*3-1];
      res += Math.max(f[i*3-3], f[i*3-2], s);
      return res;
    }
  }
}
