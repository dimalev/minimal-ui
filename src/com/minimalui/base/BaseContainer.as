package com.minimalui.base {
  import flash.display.DisplayObject;
  import flash.geom.Rectangle;

  import com.minimalui.base.layout.FreeLayout;
  import com.minimalui.base.layout.ILayout;

  /**
   * Basic container. Groups elements independently one above another, while aligning them according to settings.
   * Brings valuable tool functions for such derives as Horizontal and Vertical box.
   */
  public class BaseContainer extends Element {
    public static const ALIGN:String = "align";
    public static const VALIGN:String = "valign";
    public static const SPACING:String = "spacing";

    protected var mLayout:ILayout = getLayout();

    public function get containerLayout():ILayout { return mLayout; }

    public function set containerLayout(l:ILayout):void {
      mLayout = l;
      mLayout.target = this;
      invalidateSize();
    }

    public function get visibleChildren():Vector.<DisplayObject> {
      var res:Vector.<DisplayObject> = new Vector.<DisplayObject>;
      for(var i:uint = 0; i < numChildren; ++i) {
        var c:DisplayObject = getChildAt(i);
        if(!c.visible) continue;
        res.push(c);
      }
      return res;
    }

    /**
     * Constructs container with given CSS properties and/or id.
     *
     * @param idorcss treated as id, if this is only parameter, or CSS properties, if not, or not match \w+ pattern.
     * @param id id of the element, if passed.
     */
    public function BaseContainer(idorcss:String = null, id:String = null) {
      super(idorcss, id);
      mLayout.target = this;
    }

    /**
     * Layout provider.
     *
     * @returns Layout manager for this container.
     */
    protected function getLayout():ILayout { return new FreeLayout(); }

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
        if(!c) continue;
        if(c is BaseContainer) {
          var e:Element = (c as BaseContainer).getById(id);
          if(e) return e;
        } else if(c.id == id) return c;
      }
      return null;
    }

    protected override function coreMeasure():void {
      var size:Rectangle = mLayout.measure();
      mRealWidth = size.width;
      mRealHeight = size.height;
    }

    protected override function coreLayout():void {
      var size:Rectangle = mLayout.layout(mLayoutWidth, mLayoutHeight);
      mLayoutWidth = Math.max(mLayoutWidth, size.width);
      mLayoutHeight = Math.max(mLayoutHeight, size.height);
      setChanged();
    }

    /**
     * Tool function.
     */
    protected function pack(f:Vector.<Number>, s:Number):Number {
      var N:uint = (f.length - 2) / 3;
      var res:Number = 0;
      for(var i:uint = 1; i <= N; ++i)
        res += Math.max(f[i*3-3], f[i*3-2], (i > 0 ? s : 0)) + f[i*3-1];
      res += Math.max(f[i*3-3], f[i*3-2]);
      return res;
    }

    protected function maxex(o:Object):Object {
      var res:Object = {};
      for(var key:String in o)
        if(o.hasOwnProperty(key))
          res[key] = Math.max.apply(Math, o[key]);
      return res;
    }
  }
}
