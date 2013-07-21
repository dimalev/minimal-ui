package com.minimalui.base.layout {
  import flash.geom.Rectangle;

  import com.minimalui.base.BaseContainer;

  /**
   * Encapsulates layout logic to make BaseContainer more flexible.
   */
  public interface ILayout {
    function set target(trg:BaseContainer):void;
    function get target():BaseContainer;
    /**
     * Preform measurement stage of Element layout process.
     *
     * @returns Estimated size of Container.
     */
    function measure():Rectangle;

    /**
     * Preform layout stage of Element layout process.
     *
     * @param width Requested width of Container
     * @param height Requested height of Container
     *
     * @returns Real size of Container.
     */
    function layout(width:Number, height:Number):Rectangle;
  }
}
