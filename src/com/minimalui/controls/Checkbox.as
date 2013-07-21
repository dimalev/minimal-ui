package com.minimalui.controls {
  import flash.events.MouseEvent;

  import com.minimalui.base.Element;
  import com.minimalui.base.CheckboxBase;
  import com.minimalui.base.BaseContainer;
  import com.minimalui.containers.RawLayout;
  import com.minimalui.base.layout.ILayout;
  import com.minimalui.decorators.Background;
  import com.minimalui.decorators.Border;

  public class Checkbox extends CheckboxBase {
    public static const BOX_COLOR:String = "box-color";
    public static const BOX_FILL_COLOR:String = "box-fill-color";
    private var mBox:BaseContainer = new BaseContainer("width:20; height:20; border-width:1; border-color:0xff0000;\
background-color: 0xff00; background-transparency: 0; padding-left: 10px");
    private var mLabel:Label = new Label();

    protected override function getLayout():ILayout { return new RawLayout(true); }

    public function Checkbox(idorcss:String = null, id:String = null) {
      super(idorcss, id);
      addChild(mBox);
      addChild(mLabel);
      mLabel.style.addInheritable(Label.TEXT_CONTENT, true);
    }

    protected override function coreCommitProperties():void {
      if(checked) mBox.setStyle("background-transparency", 1);
      else mBox.setStyle("background-transparency", 0);
      if(hasChanged(Vector.<String>([BOX_COLOR]))) mBox.setStyle(Border.COLOR, getStyle(BOX_COLOR));
      if(hasChanged(Vector.<String>([BOX_FILL_COLOR]))) mBox.setStyle(Background.COLOR, getStyle(BOX_FILL_COLOR));
    }
  }
}