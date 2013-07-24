package com.minimalui.resources {
  import flash.display.DisplayObject;
  import flash.display.Bitmap;
  import flash.display.BitmapData;
  import flash.geom.Matrix;
  import flash.geom.Rectangle;
  import flash.utils.describeType;

  public class StaticResources implements IImageStaticSource {
    private var mImages:Object = {};
    private var mParts:Object = {};

    public function StaticResources() {
      var td:XML = describeType(this);
      for each(var v:XML in td.variable) {
        var resource:XML = v.metadata.(@name == "Resource")[0];

        if(resource) {
          var name:String = resource.arg.(@key == "name")[0].@value;
          var parts:XMLList = v.metadata.(@name == "Part");
          for each(var part:XML in parts) {
            mParts[part.arg.(@key == "name")[0].@value] = {
              parent: name,
              x: part.arg.(@key == "x")[0].@value,
              y: part.arg.(@key == "y")[0].@value,
              width: part.arg.(@key == "width")[0].@value,
              height: part.arg.(@key == "height")[0].@value
            }
          }
          mImages[name] = v.@name;
        }
      }
    }

    public function has(resource:String):Boolean {
      return mImages.hasOwnProperty(resource) || mParts.hasOwnProperty(resource);
    }

    public function retrieve(resource:String):DisplayObject {
      if(mImages.hasOwnProperty(resource))
        return (new this[mImages[resource]]) as Bitmap;
      if(mParts.hasOwnProperty(resource)) {
        var buffer:DisplayObject = mParts[resource].parentBuffer;
        if(!buffer) buffer = mParts[resource].parentBuffer = retrieve(mParts[resource].parent)
        return cut(buffer, mParts[resource].x, mParts[resource].y, mParts[resource].width, mParts[resource].height);
      }
      trace("[WARNING] resource not found: " + resource);
      return null;
    }

    private function cut(img:DisplayObject, x:Number, y:Number, w:Number, h:Number):Bitmap {
      var bd:BitmapData = new BitmapData(w,h);
      bd.fillRect(new Rectangle(0,0,w,h), 0x00);
      bd.draw(img, new Matrix(1,0,0,1,-x,-y));
      return new Bitmap(bd);
    }
  }
}
