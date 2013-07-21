package com.minimalui.base {
  import flash.display.Sprite;
  import flash.events.MouseEvent;

  import com.minimalui.events.MEvent;

  import com.minimalui.base.BaseContainer;

  /**
   * Implements basic Button.
   */
  public class BaseButton extends BaseContainer {
    public static const DISABLED:String = "disabled";

    private var mCallback:Function;

    private var mIsMouseDown:Boolean = false;
    private var mIsMouseOver:Boolean = false;

    public function set disabled(bb:Boolean):void { setStyle(DISABLED, bb ? "true" : "false") }

    public function get disabled():Boolean {
      return style.hasValue(DISABLED) ? getStyle(DISABLED) == "true" : false;
    }

    /**
     * Easy shortcut to click event. Dispatched before calling firing click event.
     *
     * @param f callback called on clicking.
     */
    public final function set onClick(f:Function):void {
      mCallback = f;
    }

    /**
     * If mouse is currently down.
     */
    public function get isMouseDown():Boolean { return mIsMouseDown; }

    /**
     * If mouse is currently over.
     */
    public function get isMouseOver():Boolean { return mIsMouseOver; }

    /**
     * Default constructor.
     *
     * @param idorcss if this is last parameter - this is element id, otherwise this parameter is treated as css
     * @param id id of the element.
     */
   public function BaseButton(idorcss:String = null, id:String = null) {
      super(idorcss, id);
      if(!style.hasValue(BaseContainer.ALIGN)) setStyle(BaseContainer.ALIGN, "center");
      if(!style.hasValue(BaseContainer.VALIGN)) setStyle(BaseContainer.VALIGN, "middle");
      useHandCursor = buttonMode = true;
      construct();
      addMouseListeners();
    }

    protected override function coreCommitProperties():void {
      if(hasChanged(Vector.<String>([DISABLED]))) {
        useHandCursor = buttonMode = !(getStyle(DISABLED) == "true");
        setChanged();
      }
      super.coreCommitProperties();
    }

    protected function onMouseMove():void { "Implement custom mouse move handling"; }
    protected function onMouseOver():void { "Implement custom mouse over handling"; }
    protected function onMouseOut():void { "Implement custom mouse out handling"; }
    protected function onMouseDown():void { "Implement custom mouse down handling"; }
    protected function onMouseUp():void { "Implement custom mouse up handling"; }
    protected function onMouseClick():void { "Implement custom mouse click handling"; }

    private function coreOnClick(me:MouseEvent):void {
      if(disabled) return;
      onMouseClick();
      if(mCallback !== null) mCallback();
      dispatchEvent(new MEvent(MEvent.BUTTON_CLICK));
      setChanged();
    }

    private function addMouseListeners():void {
      addEventListener(MouseEvent.CLICK, coreOnClick);
      addEventListener(MouseEvent.MOUSE_OVER, onCoreMouseOver);
      addEventListener(MouseEvent.MOUSE_OUT, onCoreMouseOut);
      addEventListener(MouseEvent.MOUSE_DOWN, onCoreMouseDown);
    }

    private function onCoreMouseMove(me:MouseEvent):void {
      onMouseMove();
      setChanged();
    }

    private function onCoreMouseOver(me:MouseEvent):void {
      addEventListener(MouseEvent.MOUSE_MOVE, onCoreMouseMove);
      mIsMouseOver = true;
      onMouseOver();
      setChanged();
    }

    private function onCoreMouseOut(me:MouseEvent):void {
      removeEventListener(MouseEvent.MOUSE_MOVE, onCoreMouseMove);
      mIsMouseOver = false;
      onMouseOut();
      setChanged();
    }

    private function onCoreMouseDown(me:MouseEvent):void {
      mIsMouseDown = true;
      stage.addEventListener(MouseEvent.MOUSE_UP, onCoreMouseUp);
      onMouseDown();
      setChanged();
    }

    private function onCoreMouseUp(me:MouseEvent):void {
      mIsMouseDown = false;
      onMouseUp();
      setChanged();
    }

    protected function construct():void {
      "Implement this with your own parts of button";
    }
  }
}
