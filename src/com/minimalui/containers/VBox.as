package com.minimalui.containers {
  import flash.display.Sprite;

  import com.minimalui.base.Element;

  public class VBox extends Box {
    public var elementMargin:Number = 5;

    public function VBox(items:Vector.<Element> = null) {
      super(items);
    }

    protected override function coreRedraw():void {
      var w:Number = mWidth;
      var h:Number = mHeight;
      if(w == -1 || h == -1) {
        var w1:Number = 0;
        for(var i:uint = 0; i < mElements.length; ++i)
          w1 = Math.max(w1, mElements[i].width);
        if(w == -1) w = w1 + margin[0] + margin[2];
        if(h == -1) h = internalHeight() + margin[1] + margin[3] + Math.max(mElements.length - 1, 0) * elementMargin;
      }

      adjustVertically(h);
      adjustHorisontally(w);
      mRealWidth = w;
      mRealHeight = h;
      coreDrawBackground();
    }

    private function internalHeight():Number {
      var h1:Number = 0;
      for(var i:uint = 0; i < mElements.length; ++i)
        h1 += mElements[i].height;
      return h1;
    }

    protected override function adjustVertically(h:Number):void {
      var yy:Number = 0;
      var i:uint;
      var th:Number;
      switch(mVerticalAlign) {
      case "top":
        yy = margin[1];
        break;
      case "middle":
        th = internalHeight() + Math.max(mElements.length - 1, 0) * elementMargin;
        yy = margin[1] + Math.round((h - margin[1] - margin[3] - th) / 2);
        break;
      case "bottom":
        th = internalHeight() + Math.max(mElements.length - 1, 0) * elementMargin;
        yy = h - margin[3] - th;
        break;
      }
      for(i = 0; i < mElements.length; ++i) {
        mElements[i].y = yy;
        yy += mElements[i].height + elementMargin;
      }
    }
  }
}