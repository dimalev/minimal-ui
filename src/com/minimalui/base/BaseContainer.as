package com.minimalui.base {
  import flash.display.DisplayObject;
  import flash.geom.Rectangle;

  public class BaseContainer extends Element {
    protected var mChildren:Vector.<Element> = new Vector.<Element>;
    public function BaseContainer(idorcss:String = null, id:String = null) {
      super(idorcss, id);
    }

    public override function addChild(d:DisplayObject):DisplayObject {
      var e:Element = d as Element;
      invalidateSize();
      mChildren.push(e);
      e._parent = this;
      return super.addChild(e) as Element;
    }

    public override function removeChild(d:DisplayObject):DisplayObject {
      var e:Element = d as Element;
      var i:int = mChildren.indexOf(e);
      if(i < 0) return null;
      invalidateSize();
      e._parent = null;
      mChildren.splice(i, 1);
      return super.removeChild(e) as Element;
    }

    public override function removeChildAt(i:int):DisplayObject {
      if(i > mChildren.length) return null;
      return removeChild(mChildren[i]);
    }

    public function getById(id:String):Element {
      if(this.id == id) return this;
      for each(var c:Element in mChildren)
        if(c is BaseContainer) {
          var e:Element = (c as BaseContainer).getById(id);
          if(e) return e;
        } else if(c.id == id) return c;
      return null;
    }

    protected override function coreMeasure():void {
      mMeasuredWidth = mStyle.getNumber("width");
      mMeasuredHeight = mStyle.getNumber("height");
      for each(var c:Element in mChildren) {
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
      for each(var c:Element in mChildren) {
        c.layout(new Rectangle(Math.max(mStyle.getNumber("padding-left"), c.style.getNumber("margin-left")),
                               Math.max(mStyle.getNumber("padding-top"), c.style.getNumber("margin-top")),
                               c.measuredWidth, c.measuredHeight));
      }
      setChanged();
    }

    protected override function coreCommitProperties():void {
      super.coreCommitProperties();
      for each(var e:Element in mChildren) e.commitProperties();
    }
  }
}
