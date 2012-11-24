package com.minimalui.decoration {
  import flash.display.Sprite;

  public interface IBackgroundDrawer {
    function drawBackground(trg:Sprite, w:Number, h:Number, x:Number = 0, y:Number = 0):void;
  }
}