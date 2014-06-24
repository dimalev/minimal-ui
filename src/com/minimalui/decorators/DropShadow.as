package com.minimalui.decorators {
  import flash.filters.DropShadowFilter;

  import com.minimalui.base.Decorator;
  import com.minimalui.base.DecoratorDescriptor;
  import com.minimalui.base.Element;

  public class DropShadow extends Decorator {
    public static const DISTANCE:String = "dropshadow-distance";
    public static const ANGLE:String    = "dropshadow-angle";
    public static const COLOR:String    = "dropshadow-color";
    public static const ALPHA:String    = "dropshadow-alpha";
    public static const BLURX:String    = "dropshadow-blur-x";
    public static const BLURY:String    = "dropshadow-blur-y";
    public static const STRENGTH:String = "dropshadow-strength";
    public static const QUALITY:String  = "dropshadow-quality";
    public static const INNER:String    = "dropshadow-inner";
    public static const KNOCKOUT:String = "dropshadow-knockout";

    public static const ALL:Vector.<String> =
      Vector.<String>([DISTANCE, ANGLE, COLOR, ALPHA, BLURX, BLURY, STRENGTH, QUALITY, INNER, KNOCKOUT]);
    private static var sDescriptor:DecoratorDescriptor =
      new DecoratorDescriptor("dropshadow", DropShadow, ALL);

    public static function get descriptor():DecoratorDescriptor { return sDescriptor; }

    public function DropShadow(trg:Element) {
      super(trg);
      var filters:Array = target.filters;
      if(!filters) filters = [];
      filters.push(new DropShadowFilter());
      target.filters = filters;
    }

    public override function onCommitProperties():void {
      if(!target.hasChanged(ALL)) return;
      var filters:Array = target.filters;
      if(!filters) filters = [];
      var id:int = -1;
      for(id = 0; id < filters.length; ++id)
      if(filters[id] is DropShadowFilter) break;
      if(id >= filters.length) {
        trace("Drop Shadow filter is not present!");
        id = filters.length;
        filters.push(new DropShadowFilter);
      }
      filters[id].distance = target.style.getNumber(DISTANCE) || 4.0;
      filters[id].angle = target.style.getNumber(ANGLE) || 45;
      filters[id].color = target.style.getNumber(COLOR) || 0;
      filters[id].alpha = target.style.getNumber(ALPHA) || 1.0;
      filters[id].blurX = target.style.getNumber(BLURX) || 4.0;
      filters[id].blurY = target.style.getNumber(BLURY) || 4.0;
      filters[id].strength = target.style.getNumber(STRENGTH) || 1.0;
      filters[id].quality = target.style.getNumber(QUALITY) || 1.0;
      filters[id].inner = target.style.getString(INNER) == "yes" || false;
      filters[id].knockout = target.style.getString(KNOCKOUT) == "yes" || false;
      target.filters = filters;
    }
  }
}