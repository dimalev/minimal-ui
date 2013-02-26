package com.minimalui.containers {
  import flash.display.Sprite;
  import flash.geom.Rectangle;

  import com.minimalui.base.BaseContainer;
  import com.minimalui.base.Style;
  import com.minimalui.base.Element;

  public class Box extends BaseContainer {
    protected var mRealWidth:Number = 0;
    protected var mRealHeight:Number = 0;

    public function Box(items:Vector.<Element> = null, idorcss:String = null, id:String = null) {
      super(idorcss, id);
      if(!items) return;
      for each(var i:Element in items) addChild(i);
      invalidateSize();
    }

    protected override function coreMeasure():void {
      var l:Number = 0;
      var r:Number = 0;
      var lastHorizontalMargin:Number = 0;
      var w:Number = 0;
      var h:Number= mStyle.getNumber("padding-top") + mStyle.getNumber("padding-bottom");
      for each(var c:Element in mChildren) {
        c.measure();
        var ch:Number = c.measuredHeight;
        h = Math.max(h, ch + Math.max(mStyle.getNumber("padding-top"),    c.style.getNumber("margin-top")   )
                           + Math.max(mStyle.getNumber("padding-bottom"), c.style.getNumber("margin-bottom"))
                     );

        var cw:Number = c.measuredWidth;
        w += cw;
        if(c.style.getNumber("margin-left") > lastHorizontalMargin)
          w += (c.style.getNumber("margin-left") - lastHorizontalMargin);
        w += (lastHorizontalMargin = c.style.getNumber("margin-right"));
      }
      mMeasuredWidth = Math.max(mRealWidth = w, mStyle.getNumber("width"));
      mMeasuredHeight = Math.max(mRealHeight = h, mStyle.getNumber("height"));
    }

    protected override function coreLayout():void {
      var c:Element;
      var contentW:Number = mRealWidth
        - Math.max(mStyle.getNumber("padding-left"), mChildren[0].style.getNumber("margin-left"))
        - Math.max(mStyle.getNumber("padding-right"), mChildren[0].style.getNumber("margin-right"))
      var contentH:Number = mViewPort.height;

      var lastHorizontalMargin:Number = 4000;
      var xx:Number = (mViewPort.width - contentW) / 2;
      switch(mStyle.getString("align") || "center") {
      case "left":
        xx = Math.max(mStyle.getNumber("padding-right"), mChildren[0].style.getNumber("margin-right"));
        break;
      case "right":
        xx = mViewPort.width - contentW;
        break;
      }

      for each(c in mChildren) {
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

        xx += c.measuredWidth + (lastHorizontalMargin = c.style.getNumber("margin-right"));
      }
      setChanged();
    }

    protected override function coreRedraw():void {
      graphics.lineStyle(1);
      graphics.drawRect(0,0, width, height);
    }
  }
}