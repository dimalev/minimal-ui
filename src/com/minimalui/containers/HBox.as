package com.minimalui.containers {
  import com.minimalui.base.BaseContainer;
  import com.minimalui.base.layout.ILayout;

  public class HBox extends BaseContainer {

    protected override function getLayout():ILayout { return new RawLayout(true); }

    public function HBox(idorcss:String = null, id:String = null) {
      super(idorcss, id);
    }
  }
}