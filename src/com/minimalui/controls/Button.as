package com.minimalui.controls {
  import flash.display.Sprite;

  import com.minimalui.base.BaseButton;
  import com.minimalui.base.Decorator;
  import com.minimalui.containers.HBox;
  import com.minimalui.decorators.Border;
  import com.minimalui.decorators.Background;
  import com.minimalui.tools.Tools;

  /**
   * Implements basic Button.
   * TODO: Add text setter for label!
   */
  public class Button extends BaseButton {
    public static const BACKGROUND_COLOR_HOVER:String = "background-color-hover";

    private var mLabel:Label;

    /**
     * Default constructor.
     *
     * @param text label on the button
     * @param idorcss if this is last parameter - this is element id, otherwise this parameter is treated as css
     * @param id id of the element.
     */
    public function Button(idorcss:String = null, id:String = null) {
      super(idorcss, id);
      cleanDecorators();
    }

    protected override function construct():void {
      mLabel = new Label();
      mLabel.style.addInheritable(Label.TEXT_CONTENT, true);
      addChild(mLabel);
    }
  }
}
