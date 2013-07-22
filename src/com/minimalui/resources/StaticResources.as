package com.minimalui.resources {
  import flash.display.DisplayObject;
  import flash.display.Bitmap;
  import flash.display.BitmapData;
  import flash.geom.Matrix;
  import flash.geom.Rectangle;
  import flash.utils.describeType;

  public class StaticResources implements IImageStaticSource {
    private var mImages:Object = {};

    public function StaticResources() {
      var td:XML = describeType(this);
      for each(var v:XML in td.variable) {
        var resource:XML = v.metadata.(@name == "Resource")[0];

        if(resource) mImages[resource.arg.(@key == "name")[0].@value] = v.@name;
      }
    }

    public function has(resource:String):Boolean {
      return mImages.hasOwnProperty(resource);
    }

    public function retrieve(resource:String):DisplayObject {
      return new this[mImages[resource]];
    }
  }
}
