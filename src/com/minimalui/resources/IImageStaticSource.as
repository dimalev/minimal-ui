package com.minimalui.resources {
  import flash.display.DisplayObject;

  public interface IImageStaticSource {
    function has(resource:String):Boolean;
    function retrieve(resource:String):DisplayObject;
  }
}