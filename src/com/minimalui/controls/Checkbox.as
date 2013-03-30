package com.minimalui.controls {
  import flash.events.MouseEvent;

  import com.minimalui.base.Element;
  import com.minimalui.base.BaseContainer;
  import com.minimalui.containers.HBox;

  public class Checkbox extends HBox {
    private var mBox:BaseContainer = new BaseContainer("width:20; height:20; border-width:1; border-color:0xff0000;\
background-color: 0xff00; background-transparency: 0; padding-left: 10px");
    private var mLabel:Label = new Label();

    public function get checked():Boolean {
      return style.hasValue("checked") ? getStyle("checked") == "yes" : false;
    }
    public function set checked(bb:Boolean):void {
      setStyle("checked", bb ? "yes" : "no");
    }

    public function Checkbox(idorcss:String = null, id:String = null) {
      super(Vector.<Element>([mBox, mLabel]), idorcss, id);
      mLabel.style.delValue("content");
      mLabel.style.addInheritable(Label.TEXT_CONTENT);
      mBox.useHandCursor = mBox.buttonMode = true;

      addEventListener(MouseEvent.CLICK, onClick);
    }

    private function onClick(me:MouseEvent):void {
      trace("click! " + (style.hasValue("checked") ? "yes" : "no"));
      checked = !checked;
    }

    protected override function coreCommitProperties():void {
      trace("setting color: " + (checked ? "yes" : "no"));
      if(checked) mBox.setStyle("background-transparency", 1);
      else mBox.setStyle("background-transparency", 0);
      mBox.setChanged();
    }
  }
}