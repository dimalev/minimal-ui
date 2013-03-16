package com.minimalui.containers {
  import flash.display.DisplayObject;
  import flash.geom.Rectangle;

  import com.minimalui.base.Element;
  import com.minimalui.base.BaseContainer;
  import com.minimalui.controls.Scroll;

  public class ScrollControlBase extends BaseContainer {
    protected var mVerticalScroll:Scroll;

    protected var mChild:Element;

    public function ScrollControlBase(idorcss:String = null, css:String = null) {
      super(idorcss, css);
      construct();
    }

    protected override function coreCommitProperties():void {
      if(hasChanged(Vector.<String>(["height"]))) mVerticalScroll.height = style.getNumber("height");
      if(hasChanged(Vector.<String>(["width"]))) mVerticalScroll.x = style.getNumber("width") - mVerticalScroll.style.getNumber("width");
    }

    protected override function coreLayout():void {
      if(mViewPort.height < mChild.realHeight && !mChild.scrollRect) {
        mChild.scrollRect = new Rectangle(0, 0, mViewPort.width, mViewPort.height);
        mVerticalScroll.visible = true;
        mVerticalScroll.setChanged();
      }
      if(mViewPort.height >= mChild.realHeight && mChild.scrollRect) {
        mVerticalScroll.visible = false;
        mChild.scrollRect = null;
      }
      super.coreLayout();
    }

    public override function addChild(e:DisplayObject):DisplayObject {
      mVerticalScroll.target = e as Element;
      return super.addChildAt(mChild = e as Element, 0);
    }

    protected function construct():void {
      mVerticalScroll = new Scroll("runner-color:0xff");
      super.addChild(mVerticalScroll);
    }
  }
}