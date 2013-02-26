package com.minimalui.tools {
  public class Tools {
    public static function rgbReduce(cc:Number, r:Number, g:Number, b:Number):Number {
      var rr:uint = uint(cc) >> 16;
      var gg:uint = (uint(cc) >> 8) & 0xff;
      var bb:uint = uint(cc) & 0xff;
      return (Math.round(rr * r) << 16) +
        (Math.round(gg * g) << 8) +
        Math.round(bb * b);
    }

    public static function rgbSpline(c1:Number, c2:Number, d:Number):Number {
      return rgbPlus(rgbReduce(c1, 1-d, 1-d, 1-d), rgbReduce(c2, d, d, d));
    }

    public static function rgbPlus(c1:Number, c2:Number):Number {
      var r1:uint = uint(c1) >> 16;
      var g1:uint = (uint(c1) >> 8) & 0xff;
      var b1:uint = uint(c1) & 0xff;
      var r2:uint = uint(c2) >> 16;
      var g2:uint = (uint(c2) >> 8) & 0xff;
      var b2:uint = uint(c2) & 0xff;
      return ((Math.min(r1 + r2, 256) << 16) +
              (Math.min(g1 + g2, 256) << 8) +
              Math.min(b1 + b2, 256));
    }
  }
}
