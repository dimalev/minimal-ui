package com.minimalui.containers {
  import com.minimalui.base.BaseContainer;
  import com.minimalui.base.Element;
  import com.minimalui.controls.Label;

  import flash.display.DisplayObject;
  import flash.events.MouseEvent;
  import flash.geom.Point;
  import flash.utils.Dictionary;

  public class ToolTips extends BaseContainer {
    protected var mDict:Dictionary = new Dictionary();
    protected var mAlts:Dictionary = new Dictionary();

    protected var mAltProto:XML =
      <label padding="5" padding-bottom="3" padding-top="3" id="alt" background-color="0xaaaa66"
      border-width="1" border-color="0x00" />;

    public function set altProto(proto:XML):void { mAltProto = proto; }

    public function ToolTips(cssorid:String = null, id:String = null) {
      super("percent-width: 100; percent-height: 100; " + cssorid, id);
      mouseEnabled = false;
    }

    public function listenTo(element:Element, alt:String):void {
      element.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
      mDict[element] = alt;
    }

    public function addToolTip(trg:Element, alt:Element):void {
      var w:Number = trg.width;
      alt.mouseEnabled = false;
      alt.setStyle(Element.POSITION, Element.POSITION_ABSOLUTE);
      var p:Point = this.globalToLocal(trg.localToGlobal(new Point(w, 0)));
      addChild(alt);
      // var x:Number = p.x - alt.width/2;
      // var y:Number = p.y - alt.height- 5;
      var x:Number = p.x + 10;//- alt.width/2;
      var y:Number = p.y;// - alt.height- 5;
      alt.move(x, y);
    }

    public function remove(alt:Element):void {
      removeChild(alt);
    }

    protected function onMouseOver(e:MouseEvent):void {
      var trg:Element = (e.currentTarget) as Element;
      var alt:Element = buildAlt(mDict[trg]);
      addToolTip(trg, alt);
      trg.addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
      mAlts[trg] = alt;
    }

    protected function onMouseOut(e:MouseEvent):void {
      var trg:Element = (e.currentTarget) as Element;
      remove(mAlts[trg]);
      delete mAlts[trg];
      trg.removeEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
    }

    private function buildAlt(alt:String):Element {
      var image:Element = layoutManager.uifactory.decode(mAltProto);
      var target:Element;
      if(image is BaseContainer) target = (image as BaseContainer).getById("alt");
      else target = image;
      if(target) target.setStyle("text", alt);
      return image;
    }
  }
}