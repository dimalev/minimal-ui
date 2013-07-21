package com.minimalui.containers {
  import com.minimalui.base.BaseContainer;
  import com.minimalui.base.layout.ILayout;

  public class VBox extends BaseContainer {

    protected override function getLayout():ILayout { return new RawLayout(false); }

    public function VBox(idorcss:String = null, id:String = null) {
      super(idorcss, id);
    }
  }
}