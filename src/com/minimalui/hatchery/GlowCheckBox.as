package com.minimalui.hatchery {
  import flash.filters.GlowFilter;

  import com.minimalui.base.BaseCheckbox;

  public class GlowCheckBox extends BaseCheckbox {
    public static const BOX_COLOR:String = "box-color";
    public static const BOX_FILL_COLOR:String = "box-fill-color";

    public function GlowCheckBox(idorcss:String = null, id:String = null) {
      super(idorcss, id);
    }

    protected override function coreCommitProperties():void {
      if(checked) filters = [new GlowFilter(0xff)];
      else filters = [];
    }
  }
}