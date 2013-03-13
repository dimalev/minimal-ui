package com.minimalui.containers {
  import flash.display.Sprite;
  import flash.geom.Rectangle;

  import com.minimalui.base.BaseContainer;
  import com.minimalui.base.Style;
  import com.minimalui.base.Element;

  public class HBox extends BaseContainer {

    public function HBox(items:Vector.<Element> = null, idorcss:String = null, id:String = null) {
      super(idorcss, id);
      if(!items) return;
      for each(var i:Element in items) addChild(i);
      invalidateSize();
    }

    protected override function coreMeasure():void {
      var f:Vector.<Number> = Vector.<Number>([mStyle.getNumber("padding-left")]);
      var h:Number= mStyle.getNumber("padding-top") + mStyle.getNumber("padding-bottom");
      for(var i:uint = 0; i < numChildren; ++i) {
        var c:Element = getChildAt(i) as Element;
        if(!c) continue;
        var ch:Number = c.measuredHeight;
        h = Math.max(h, ch + Math.max(mStyle.getNumber("padding-top"),    c.style.getNumber("margin-top")   )
                           + Math.max(mStyle.getNumber("padding-bottom"), c.style.getNumber("margin-bottom"))
                     );

        f.push(c.style.getNumber("margin-left"), c.measuredWidth, c.style.getNumber("margin-right"));
      }
      f.push(mStyle.getNumber("padding-right"));
      mRealWidth = pack(f, mStyle.getNumber("spacing"));
      mMeasuredWidth = mRealWidth;
      mMeasuredHeight = mRealHeight = h;
    }

    protected override function coreLayout():void {
      var c:Element;
      var childMarginLeft:Number = numChildren > 0 ? (getChildAt(0) as Element).style.getNumber("margin-left") : 0;
      var childMarginRight:Number =
        numChildren > 0 ? (getChildAt(numChildren-1) as Element).style.getNumber("margin-right") : 0;
      var contentW:Number = mRealWidth
        - Math.max(mStyle.getNumber("padding-left"), mStyle.getNumber("spacing"), childMarginLeft)
        - Math.max(mStyle.getNumber("padding-right"), mStyle.getNumber("spacing"), childMarginRight);
      var contentH:Number = mViewPort.height;

      var lastHorizontalMargin:Number = 4000;
      var xx:Number = (mViewPort.width - contentW) / 2;
      switch(mStyle.getString("align") || "center") {
      case "left":
        xx = Math.max(mStyle.getNumber("padding-left"), childMarginLeft);
        break;
      case "right":
        xx = mViewPort.width - contentW;
        break;
      case "center":
        xx = (mViewPort.width - contentW) / 2;
        break;
      }

      for(var i:uint = 0; i < numChildren; ++i) {
        c = getChildAt(i) as Element;
        if(!c) continue;
        if(c.style.getNumber("margin-left") > lastHorizontalMargin)
          xx += (c.style.getNumber("margin-left") - lastHorizontalMargin);

        var yy:Number = 0;
        switch(mStyle.getString("valign") || "middle") {
        case "top":
          yy = Math.max(mStyle.getNumber("padding-top"), c.style.getNumber("margin-top"));
          break;
        case "middle":
          yy = ((mViewPort.height - mStyle.getNumber("padding-top") - mStyle.getNumber("padding-bottom"))
                - c.measuredHeight) / 2 + mStyle.getNumber("padding-top");
          break;
        case "bottom":
          yy = mViewPort.height - c.measuredHeight
            - Math.max(mStyle.getNumber("padding-bottom"), c.style.getNumber("margin-bottom"));
          break;
        }

        c.layout(new Rectangle(xx, yy, c.measuredWidth, c.measuredHeight));

        lastHorizontalMargin = Math.max(c.style.getNumber("margin-right"), mStyle.getNumber("spacing"));
        xx += c.measuredWidth + lastHorizontalMargin;
      }
      setChanged();
    }

    // protected override function coreRedraw():void {
    //   graphics.lineStyle(0, 0xff);
    //   graphics.drawRect(0,0,mRealWidth, mRealHeight);
    // }
  }
}