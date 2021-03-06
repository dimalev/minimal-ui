package com.minimalui.base {
  /**
   * Adds unified effects and capabilities to Element.
   *
   * TODO: add onRemove callback to clean the object.
   */
  public class Decorator {
    private var mTarget:Element;

    public function get target():Element { return mTarget; }

    public function Decorator(trg:Element) {
      mTarget = trg;
    }

    public function onCommitProperties():void { "Implement ME!"; }

    public function onBeforeRedraw():void { "Implement ME!"; }
    public function onAfterRedraw():void { "Implement ME!"; }
  }
}
