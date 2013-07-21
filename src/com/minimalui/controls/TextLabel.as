package com.minimalui.controls {
  import flash.display.Sprite;
  import flash.text.TextField;
  import flash.text.TextFormat;
  import flash.text.Font;

  import com.minimalui.base.Element;
  import com.minimalui.base.Style;

  public class TextLabel extends Element {
    /* font data */
    public static const FONT_FAMILY:String = "font-family";
    public static const FONT_SIZE:String = "font-size";
    public static const FONT_COLOR:String = "font-color";
    public static const FONT_WEIGHT:String = "font-weight";

    /* position data */
    public static const TEXT_ALIGN:String = "text-align";
    public static const TEXT_VALIGN:String = "text-valign";

    /* data */
    public static const TEXT_CONTENT:String = "text";

    private var mRealTextWidth:Number;
    private var mRealTextHeight:Number;

    private var mFormat:TextFormat;
    private var mIsFormatChanged:Boolean = true;
    private var mText:TextField = new TextField;
    private var mTempText:TextField = new TextField;
    private var mIsBlockChanged:Boolean = true;

    public function get text():String {
      return mStyle.getString(TEXT_CONTENT);
    }

    public function set text(txt:String):void {
      setStyle(TEXT_CONTENT, txt);
      setDirty();
      invalidateSize();
    }

    public function TextLabel(text:String = "TextLabel", cssorid:String = null, id:String = null) {
      super(cssorid, id);
      addChild(mText);
      mText.selectable = false;
      mText.mouseEnabled = false;
      mText.wordWrap = mTempText.wordWrap = true;
      mText.multiline = mTempText.multiline = true;
      style.addInvalidateSize(FONT_SIZE, FONT_FAMILY, FONT_WEIGHT, TEXT_CONTENT);
      style.addInheritable(FONT_SIZE, FONT_FAMILY, FONT_COLOR, FONT_WEIGHT, TEXT_ALIGN, TEXT_VALIGN);
      this.text = text;
    }

    protected override function coreCommitProperties():void {
      if(hasChanged(Vector.<String>([FONT_SIZE, FONT_FAMILY, FONT_COLOR, FONT_WEIGHT, TEXT_ALIGN])))
        mIsFormatChanged = true;
      if(mIsFormatChanged || hasChanged(Vector.<String>([TEXT_CONTENT]))) {
        setChanged();
      }
    }

    protected override function coreMeasure():void {
      changeFormat();
      if(!isNaN(mMeasuredWidth)) changeBlock(mMeasuredWidth);
      else {
        changeBlock(4000);
        mMeasuredWidth = mRealWidth;
      }
      if(isNaN(mMeasuredHeight)) mMeasuredHeight = mRealHeight;
    }

    protected override function coreLayout():void {
      if(mLayoutWidth < mRealWidth) changeBlock(mLayoutWidth);

      mText.text = String(getStyle(TEXT_CONTENT));
      mText.width = mLayoutWidth;
      mText.height = mLayoutHeight;
    }

    private function changeFormat():void {
      if(!mIsFormatChanged) return;
      mFormat = new TextFormat();
      var isEmbed:Boolean = false;
      if(style.hasValue(FONT_FAMILY)) {
        var customFontName:String = style.getString(FONT_FAMILY) as String;
        var fs:Array = Font.enumerateFonts(false);
        for each(var f:Font in fs) if(f.fontName == customFontName) isEmbed = true;
        mFormat.font = customFontName;
      }
      mFormat.size = style.getNumber(FONT_SIZE) || 14,
      mFormat.color = style.getNumber(FONT_COLOR) || 0x00,
      mFormat.bold = style.getString(FONT_WEIGHT) == "bold";
      mFormat.align = getStyle(TEXT_ALIGN) as String;
      mTempText.embedFonts = mText.embedFonts = isEmbed;
      mTempText.defaultTextFormat = mText.defaultTextFormat = mFormat;
      mIsFormatChanged = false;
      setChanged();
    }

    private function changeBlock(w:Number):void {
      mTempText.text = String(getStyle(TEXT_CONTENT));
      mTempText.width = w;

      mRealWidth = mRealTextWidth = mTempText.textWidth + 4
        + style.getNumber(Element.PADDING_LEFT)
        + style.getNumber(Element.PADDING_RIGHT);
      mRealHeight = mRealTextHeight = mTempText.textHeight + 2
        + style.getNumber(Element.PADDING_TOP)
        + style.getNumber(Element.PADDING_BOTTOM);

      mIsBlockChanged = false;
      setChanged();
    }
  }
}
