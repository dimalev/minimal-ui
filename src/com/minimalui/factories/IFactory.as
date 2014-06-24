package com.minimalui.factories {
  import com.minimalui.base.Element;

  /**
   * Basic configurable interface for building user interface.
   */
  public interface IFactory {
    function decode(data:*, host:Object = null, el:Element = null):Element;
  }
}
