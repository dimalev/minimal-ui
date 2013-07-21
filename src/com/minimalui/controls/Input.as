package com.minimalui.controls {
  import flash.display.Sprite;
  import flash.events.FocusEvent;
  import flash.display.GradientType;
  import flash.geom.Matrix;
  import flash.geom.Point;
  import flash.geom.Rectangle;
  import flash.text.TextField;
  import flash.text.TextFormat;
  import flash.text.TextFieldType;

  import com.minimalui.base.Element;
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
    public static const HOLDER:String = "holder";
    public static const HOLDER_COLOR:String = "holder-color";
    public static const MULTILINE:String = "multiline";

    private var mHolder:Label;
    private var mInput:TextField;
    private var mDisabled:Boolean = false;
    private var mIsFocused:Boolean = false;

    public function get text():String { return mInput.text; }
    public function set text(txt:String):void {
      mInput.text = txt;
      setChanged();
    }

    public function get maxScrollV():Number { return mInput.maxScrollV; }
    public function get scrollV():Number { return mInput.scrollV; }
    public function set scrollV(sv:Number):void { mInput.scrollV = sv; }
    public function get maxScrollH():Number { return mInput.maxScrollH; }
    public function get scrollH():Number { return mInput.scrollH; }
    public function set scrollH(sh:Number):void { mInput.scrollH = sh; }

    public function set multiline(b:Boolean):void  { mInput.multiline = b; }

    /**
     * Default constructor.
     *
     * @param text label on the button
     * @param idorcss if this is last parameter - this is element id, otherwise this parameter is treated as css
     * @param id id of the element.
     */
   public function Input(holder:String = "", idorcss:String = null, id:String = null) {
      super(idorcss, id);
      style.addInheritable(Label.FONT_SIZE, Label.FONT_FAMILY, Label.FONT_COLOR,
                           Label.FONT_WEIGHT, Label.TEXT_ALIGN, Label.TEXT_VALIGN);
      setStyle(HOLDER, holder);
      if(!style.hasValue("border-width")) setStyles("border-width:2; border-color:0xAAAAAA");
      construct();
      addListeners();
    }

    // protected override function core

    protected override function coreCommitProperties():void {
      if(hasChanged(Vector.<String>([HOLDER, HOLDER_COLOR]))) {
        mHolder.setStyle(Label.TEXT_CONTENT, style.getString(HOLDER));
        mHolder.setStyle(Label.FONT_COLOR, style.getNumber(HOLDER_COLOR));
      }
      if(hasChanged(Vector.<String>(["width", "height"]))) {
        if(style.hasValue("width")) mHolder.width = mInput.width = style.getNumber("width");
        if(style.hasValue("height")) mHolder.height = mInput.height = style.getNumber("height");
        invalidateSize();
      }
      if(hasChanged(Vector.<String>([MULTILINE]))) multiline = (style.getString(MULTILINE) == "yes");
      if(hasChanged(Vector.<String>([Label.TEXT_CONTENT]))) text = style.getString(Label.TEXT_CONTENT) || "";
      if(hasChanged(Vector.<String>([Label.FONT_FAMILY, Label.FONT_SIZE, Label.FONT_COLOR, Label.TEXT_ALIGN,
                                     Label.FONT_WEIGHT]))) {
        var nf:TextFormat = new TextFormat(style.getString(Label.FONT_FAMILY) || "sans",
                                           style.getNumber(Label.FONT_SIZE) || 14,
                                           style.getNumber(Label.FONT_COLOR) || 0x00,
                                           style.getString(Label.FONT_WEIGHT) == "bold" || null);
        nf.align = style.getString(Label.TEXT_ALIGN) || "left";
        mInput.defaultTextFormat = nf;
        mInput.setTextFormat(nf);
        if(!(style.hasValue("height") || style.hasValue("percent-height"))) {
          mInput.height = mInput.textHeight + 4;
        }
      }
      if(hasChanged(Vector.<String>([DISABLED]))) {
        mDisabled = useHandCursor = buttonMode = getStyle("disabled") == "true";
        setChanged();
      }
      mHolder.setStyle(Label.TEXT_CONTENT, getStyle("holder"));
      super.coreCommitProperties();
    }

    protected override function coreLayout():void {
      mInput.width = mLayoutWidth;
      mInput.height = mLayoutHeight;
      mHolder.layout(mLayoutWidth, mLayoutHeight);
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

    protected function construct():void {
      mHolder = new Label(getStyle("holder") as String, "percent-width: 100; percent-height: 100");
      addChild(mHolder);
      mInput = new TextField();
      mInput.type = TextFieldType.INPUT;
      addChild(mInput);
      mHolder.width = mInput.width = 120;
      mHolder.height = mInput.height = 20;
    }
  }
}
