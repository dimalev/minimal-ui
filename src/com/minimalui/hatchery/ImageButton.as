package com.minimalui.hatchery {
  import com.minimalui.controls.BaseButton;

  /**
   * Implements basic ImageButton.
   */
  public class ImageButton extends BaseButton {

    protected var mImage:Image;

    public function set image(i:Image):void {
      if(mImage) removeChild(mImage);
      if(!(mImage = i)) return;
      addChild(mImage)
    }

    /**
     * Default constructor.
     *
      * @param idorcss if this is last parameter - this is element id, otherwise this parameter is treated as css
     * @param id id of the element.
     */
    public function ImageButton(idorcss:String = null, id:String = null) {
      super(idorcss, id);
      cleanDecorators();
    }
  }
}
