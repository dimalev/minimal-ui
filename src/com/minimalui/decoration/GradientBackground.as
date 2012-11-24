package com.minimalui.decoration {
  import flash.display.Sprite;
  import flash.display.GradientType;
  import flash.geom.Matrix;

  public class GradientBackground implements IBackgroundDrawer {
    private var mColors:Array;
    private var mBorderWidth:Number = NaN;
    private var mBorderColor:Number = 0;
    public function set colors(cc:Array):void {
      mColors = cc;
    }

    public function GradientBackground(cc:Array = null) {
      mColors = cc || [0x2222ee, 0x5555ff];
    }

    public function withBorder(w:Number = NaN, c:Number = 0):GradientBackground {
      mBorderWidth = w;
      mBorderColor = c;
      return this;
    }

    public function drawBackground(trg:Sprite, w:Number, h:Number, x:Number = 0, y:Number = 0):void {
      var xx:Matrix = new Matrix();
      xx.createGradientBox(w, h, 0, x, y);
      trg.graphics.lineStyle();
      trg.graphics.beginGradientFill(GradientType.LINEAR, mColors, [1,1], [64,255], xx);
      // graphics.beginFill(0x3333ff);
      trg.graphics.drawRect(x, y, w, h);
      trg.graphics.endFill();
      if(isNaN(mBorderWidth)) return;
      trg.graphics.lineStyle(mBorderWidth, mBorderColor);
      trg.graphics.drawRect(1,1,w-1-2*Math.max(1, mBorderWidth),h-1-2*Math.max(1, mBorderWidth));
    }
  }
}