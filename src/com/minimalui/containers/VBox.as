package com.minimalui.containers {
  import flash.display.Sprite;
  import flash.geom.Rectangle;

  import com.minimalui.base.BaseContainer;
  import com.minimalui.base.Style;
  import com.minimalui.base.Element;

  public class VBox extends BaseContainer {

    public function VBox(items:Vector.<Element> = null, idorcss:String = null, id:String = null) {
      super(idorcss, id);
      if(!items) return;
      for each(var i:Element in items) addChild(i);
      invalidateSize();
    }

    protected override function coreMeasure():void {
      var w:Number = mStyle.getNumber("padding-left") + mStyle.getNumber("padding-right");
      var f:Vector.<Number> = Vector.<Number>([mStyle.getNumber("padding-top")]);
      for(var i:uint = 0; i < numChildren; ++i) {
        var c:Element = getChildAt(i) as Element;
        if(!c) continue;
        var cw:Number = c.measuredWidth;
        w = Math.max(w, cw + Math.max(mStyle.getNumber("padding-left"),  c.style.getNumber("margin-left") )
                           + Math.max(mStyle.getNumber("padding-right"), c.style.getNumber("margin-right"))
                     );

        f.push(c.style.getNumber("margin-top"), c.measuredHeight, c.style.getNumber("margin-bottom"));
      }
      f.push(mStyle.getNumber("padding-bottom"));
      mMeasuredWidth = mRealWidth = w;
      mRealHeight = pack(f, style.getNumber("spacing"));
      mMeasuredHeight = mRealHeight;
    }

    protected override function coreLayout():void {
      var c:Element;
      var e1:Element = numChildren > 0 ? (getChildAt(0) as Element) : null;
      var childMarginTop:Number = e1 ? e1.style.getNumber("margin-top") : 0;
      var e2:Element = numChildren > 0 ? (getChildAt(numChildren - 1) as Element) : null;
      var childMarginBottom:Number = e2 ? e2.style.getNumber("margin-bottom") : 0;
      var contentH:Number = mRealHeight
        - Math.max(mStyle.getNumber("padding-top"), mStyle.getNumber("spacing"), childMarginTop)
        - Math.max(mStyle.getNumber("padding-bottom"), mStyle.getNumber("spacing"), childMarginBottom)
      var contentW:Number = mViewPort.width;

      var lastVerticalMargin:Number = 4000;
      var yy:Number = (mViewPort.height - contentH) / 2;
      switch(mStyle.getString("valign") || "middle") {
      case "top":
        yy = Math.max(mStyle.getNumber("padding-top"), childMarginTop);
        break;
      case "bottom":
        yy = mViewPort.height - contentH;
        break;
      case "middle":
        yy = (mViewPort.height - contentH) / 2;
        break;
      }

      for(var i:uint = 0; i < numChildren; ++i) {
        c = getChildAt(i) as Element;
        if(!c) continue;
        if(c.style.getNumber("margin-top") > lastVerticalMargin)
          yy += (c.style.getNumber("margin-top") - lastVerticalMargin);

        var xx:Number = 0;
        switch(mStyle.getString("align") || "center") {
        case "left":
          xx = Math.max(mStyle.getNumber("padding-left"), c.style.getNumber("margin-left"));
          break;
        case "center":
          xx = ((mViewPort.width - mStyle.getNumber("padding-left") - mStyle.getNumber("padding-right"))
                - c.measuredWidth) / 2 + mStyle.getNumber("padding-left");
          break;
        case "right":
          xx = mViewPort.width - c.measuredWidth
            - Math.max(mStyle.getNumber("padding-right"), c.style.getNumber("margin-right"));
          break;
        }

        c.layout(new Rectangle(xx, yy, c.measuredWidth, c.measuredHeight));

        lastVerticalMargin = Math.max(c.style.getNumber("margin-bottom"), mStyle.getNumber("spacing"));
        yy += c.measuredHeight + lastVerticalMargin;
      }
      setChanged();
    }
  }
}