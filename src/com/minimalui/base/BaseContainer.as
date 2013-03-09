package com.minimalui.base {
  import flash.display.DisplayObject;
  import flash.geom.Rectangle;

  /**
   * Basic container. Groups elements independently one above another, while aligning them according to settings.
   * Brings valuable tool functions for such derives as Horizontal and Vertical box.
   */
  public class BaseContainer extends Element {
    /**
     * Constructs container with given CSS properties and/or id.
     *
     * @param idorcss treated as id, if this is only parameter, or CSS properties, if not, or not match \w+ pattern.
     * @param id id of the element, if passed.
     */
    public function BaseContainer(idorcss:String = null, id:String = null) {
      super(idorcss, id);
    }

    public override function addChild(d:DisplayObject):DisplayObject {
      var e:Element = d as Element;
      if(null == e) return super.addChild(d);
      invalidateSize();
      return super.addChild(e) as Element;
    }

    public override function removeChild(d:DisplayObject):DisplayObject {
      var e:Element = d as Element;
      if(null == e) return super.removeChild(d);
      var i:int = getChildIndex(e);
      if(i < 0) return null;
      invalidateSize();
      return super.removeChild(e) as Element;
    }

    public override function removeChildAt(i:int):DisplayObject {
      if(i > numChildren) return null;
      return super.removeChildAt(i);
    }

    public function getById(id:String):Element {
      if(this.id == id) return this;
      for(var i:uint = 0; i < numChildren; ++i) {
        var c:Element = getChildAt(i) as Element;
        if(c is BaseContainer) {
          var e:Element = (c as BaseContainer).getById(id);
          if(e) return e;
        } else if(c.id == id) return c;
      }
      return null;
    }

    protected override function coreMeasure():void {
      mMeasuredWidth = mStyle.getNumber("width");
      mMeasuredHeight = mStyle.getNumber("height");
      for(var i:uint = 0; i < numChildren; ++i) {
        var c:Element = getChildAt(i) as Element;
        if(null == c) continue;
        var innerw:Number = c.measuredWidth
          + Math.max(mStyle.getNumber("padding-left"), c.style.getNumber("margin-left"))
          + Math.max(mStyle.getNumber("padding-right"), c.style.getNumber("margin-right"));
        var innerh:Number = c.measuredHeight
          + Math.max(mStyle.getNumber("padding-top"), c.style.getNumber("margin-top"))
          + Math.max(mStyle.getNumber("padding-bottom"), c.style.getNumber("margin-bottom"));
        mMeasuredWidth = Math.max(mMeasuredWidth, innerw);
        mMeasuredHeight = Math.max(mMeasuredHeight, innerh);
      }
    }

    protected override function coreLayout():void {
      super.coreLayout();
      for(var i:uint = 0; i < numChildren; ++i) {
        var c:Element = getChildAt(i) as Element;
        if(null == c) continue;
        c.layout(new Rectangle(Math.max(mStyle.getNumber("padding-left"), c.style.getNumber("margin-left")),
                               Math.max(mStyle.getNumber("padding-top"), c.style.getNumber("margin-top")),
                               c.measuredWidth, c.measuredHeight));
      }
      setChanged();
    }

    /**
     * Tool function.
     */
    protected function pack(f:Vector.<Number>, s:Number):Number {
      var N:uint = (f.length - 2) / 3;
      var res:Number = 0;
      for(var i:uint = 1; i <= N; ++i)
        res += Math.max(f[i*3-3], f[i*3-2], s) + f[i*3-1];
      res += Math.max(f[i*3-3], f[i*3-2], s);
      return res;
    }
  }
}
