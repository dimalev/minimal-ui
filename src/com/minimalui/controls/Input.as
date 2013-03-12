package com.minimalui.controls {
  import flash.display.Sprite;
  import flash.events.FocusEvent;
  import flash.display.GradientType;
  import flash.geom.Matrix;
  import flash.geom.Point;
  import flash.geom.Rectangle;
  import flash.text.TextField;
  import flash.text.TextFieldType;

  import com.minimalui.base.BaseContainer;
  import com.minimalui.base.Decorator;
  import com.minimalui.decorators.Border;
  import com.minimalui.decorators.Background;
  import com.minimalui.tools.Tools;

  /**
   * Implements basic Input field.
   */
  public class Input extends BaseContainer {
    public static const DISABLED:String = "disabled";
    private var mHolder:Label;
    private var mInput:TextField;
    private var mDisabled:Boolean = false;
    private var mIsFocused:Boolean = false;

    public function get text():String { return mInput.text; }

    /**
     * Default constructor.
     *
     * @param text label on the button
     * @param idorcss if this is last parameter - this is element id, otherwise this parameter is treated as css
     * @param id id of the element.
     */
   public function Input(holder:String = "Button", idorcss:String = null, id:String = null) {
      super(idorcss, id);
      setStyle("holder", holder);
      if(!style.hasValue("border-width")) setStyles("border-width:2; border-color:0xAAAAAA");
      construct();
      addListeners();
    }

    protected override function coreLayout():void {
      super.coreLayout();
      mInput.width = mViewPort.width;
      mInput.height = mViewPort.height;
    }

    protected override function coreCommitProperties():void {
      if(hasChanged(Vector.<String>(["width", "height"]))) {
        if(style.hasValue("width")) mHolder.width = mInput.width = style.getNumber("width");
        if(style.hasValue("height")) mHolder.height = mInput.height = style.getNumber("height");
        invalidateSize();
      }
      if(hasChanged(Vector.<String>([DISABLED]))) {
        mDisabled = useHandCursor = buttonMode = getStyle("disabled") == "true";
        setChanged();
      }
      mHolder.setStyle("content", getStyle("holder"));
      super.coreCommitProperties();
    }

    protected override function coreRedraw():void {
      mHolder.visible = !mIsFocused && mInput.text.length == 0;
    }

    private function addListeners():void {
      mInput.addEventListener(FocusEvent.FOCUS_IN, onFocus);
    }

    private function onFocus(e:FocusEvent):void {
      mIsFocused = true;
      mInput.addEventListener(FocusEvent.FOCUS_OUT, onBlur);
      setChanged();
    }

    private function onBlur(e:FocusEvent):void {
      mIsFocused = false;
      mInput.removeEventListener(FocusEvent.FOCUS_OUT, onBlur);
      setChanged();
    }

    private function construct():void {
      mHolder = new Label(getStyle("holder") as String);
      addChild(mHolder);
      mInput = new TextField();
      mInput.type = TextFieldType.INPUT;
      addChild(mInput);
      mHolder.width = mInput.width = 120;
      mHolder.height = mInput.width = 30;
    }
  }
}
