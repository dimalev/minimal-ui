package com.minimalui.base {
  public class BaseContainer extends Element {
    protected var mChildren:Vector.<Element> = new Vector.<Element>;
    public function BaseContainer(idorcss:String = null, id:String = null) {
      super(idorcss, id);
    }

    public override function addChild(e:Element):Element {
      invalidateSize();
      mChildren.push(e);
      e._parent = this;
      return super.addChild(e) as Element;
    }

    public override function removeChild(e:Element):Element {
      var i:int = mChildren.indexOf(e);
      if(i < 0) return null;
      invalidateSize();
      e._parent = null;
      mChildren.splice(i, 1);
      return super.removeChild(e) as Element;
    }

    public function getById(id:String):Element {
      if(this.id == id) return this;
      for each(var c:Element in mChildren)
        if(c is BaseContainer) {
          var e:Element = (c as BaseContainer).getById(id);
          if(e) return e;
        } else if(c.id == mId) return c;
      return null;
    }
  }
}
