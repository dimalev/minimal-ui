package com.minimalui.base {
  import flash.display.DisplayObject;
  import flash.geom.Rectangle;
  import com.minimalui.decorators.Border;
  import com.minimalui.decorators.Background;

  public class BaseContainer extends Element {
    public function BaseContainer(idorcss:String = null, id:String = null) {
      super(idorcss, id);
      addDecorator(new Border(this));
      addDecorator(new Background(this));
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
        c.measure();
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

    protected override function coreCommitProperties():void {
      super.coreCommitProperties();
      // for(var i:uint = 0; i < numChildren; ++i) {
      //   var c:Element = getChildAt(i) as Element;
      //   if(null == c) continue;
      //   c.commitProperties();
      // }
    }
  }
}
