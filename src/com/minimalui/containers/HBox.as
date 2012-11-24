package com.minimalui.containers {
  import flash.display.Sprite;

  import com.minimalui.base.Element;

  public class HBox extends Box {
    public var elementMargin:Number = 5;

    public function HBox(items:Vector.<Element> = null) {
      super(items);
    }

    protected override function coreRedraw():void {
      var w:Number = mWidth;
      var h:Number = mHeight;
      if(w == -1 || h == -1) {
        var h1:Number = 0;
        for(var i:uint = 0; i < mElements.length; ++i)
          h1 = Math.max(h1, mElements[i].height);
        if(h == -1) h = h1 + margin[1] + margin[3];
        if(w == -1) w = internalWidth() + margin[0] + margin[2] + Math.max(mElements.length - 1, 0) * elementMargin;
      }

      adjustVertically(h);
      adjustHorisontally(w);
      mRealWidth = w;
      mRealHeight = h;
      coreDrawBackground();
    }

    private function internalWidth():Number {
      var w:Number = 0;
      for(var i:uint = 0; i < mElements.length; ++i)
        w += mElements[i].width;
      return w;
    }

    protected override function adjustHorisontally(w:Number):void {
      var xx:Number = 0;
      var i:uint;
      var tw:Number;
      switch(mAlign) {
      case "left":
        xx = margin[0];
        break;
      case "center":
        tw = internalWidth() + Math.max(mElements.length - 1, 0) * elementMargin;
        xx = margin[0] + Math.round((w - margin[0] - margin[2] - tw) / 2);
        break;
      case "right":
        tw = internalWidth() + Math.max(mElements.length - 1, 0) * elementMargin;
        xx = w - margin[2] - tw;
        break;
      }
      for(i = 0; i < mElements.length; ++i) {
        mElements[i].x = xx;
        xx += mElements[i].width + elementMargin;
      }
    }
  }
}