package com.minimalui.controls {
  import flash.display.Sprite;
  import flash.text.engine.TextLine;
  import flash.text.engine.TextBlock;
  import flash.text.engine.TextElement;
  import flash.text.engine.FontDescription;
  import flash.text.engine.ElementFormat;
  import flash.text.engine.TextJustifier;
  import flash.text.engine.LineJustification;

  import com.minimalui.base.Element;
  import com.minimalui.base.Style;

  public class Label extends Element {
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

    private var mFormat:ElementFormat;
    private var mIsFormatChanged:Boolean = true;
    private var mTextBlock:TextBlock;
    private var mIsBlockChanged:Boolean = true;

    private var mText:Vector.<TextLine> = new Vector.<TextLine>;

    public function get text():String {
      return String(mStyle.getString(TEXT_CONTENT));
    }

    public function set text(txt:String):void {
      setStyle(TEXT_CONTENT, txt);
      setDirty();
    }

    public function Label(text:String = "Label", cssorid:String = null, id:String = null) {
      super(cssorid, id);
      style.addInvalidateSize(FONT_SIZE, FONT_FAMILY, FONT_WEIGHT, TEXT_CONTENT);
      style.addInheritable(FONT_SIZE, FONT_FAMILY, FONT_COLOR, FONT_WEIGHT, TEXT_ALIGN, TEXT_VALIGN);
      this.text = text;
    }

    protected override function coreCommitProperties():void {
      if(hasChanged(Vector.<String>([FONT_SIZE, FONT_FAMILY, FONT_COLOR, FONT_WEIGHT, TEXT_ALIGN])))
        mIsFormatChanged = true;
      if(mIsFormatChanged || hasChanged(Vector.<String>([TEXT_CONTENT]))) {
        invalidateSize();
        // mMeasuredWidth = NaN;
      }
    }

    protected override function coreMeasure():void {
      changeFormat();
      changeBlock(4000);
      if(isNaN(mMeasuredWidth)) mMeasuredWidth = mRealWidth;
      if(isNaN(mMeasuredHeight)) mMeasuredHeight = mRealHeight;
    }

    protected override function coreLayout():void {
      clean();

      if(mLayoutWidth != mRealWidth) changeBlock(mLayoutWidth);

      for each(var tl:TextLine in mText) addChild(tl);

      coreAlign();
    }

    protected function coreAlign():void {
      var tl:TextLine = null;

      var pl:Number = style.getNumber(Element.PADDING_LEFT);
      var pr:Number = style.getNumber(Element.PADDING_RIGHT);
      var pt:Number = style.getNumber(Element.PADDING_TOP);
      var pb:Number = style.getNumber(Element.PADDING_BOTTOM);

      var yy:Number = pt;
      switch(style.getValue(TEXT_VALIGN) || "top") {
      case "middle":
        yy = (mLayoutHeight - mRealTextHeight - pt - pb) / 2 + pt;
        break;
      case "bottom":
        yy = mLayoutHeight - mRealTextHeight - pb;
        break;
      }
      // if(yy < 0) yy = 0;

      for(var i:uint = 0; i < numChildren; ++i) {
        tl = getChildAt(i) as TextLine;
        tl.y = yy + tl.height;
        yy += tl.height + tl.descent;
        switch(style.getValue(TEXT_ALIGN) || "left") {
        case "center":
          tl.x = ((mLayoutWidth - pl - pr) - tl.width) / 2 + pl;
          break;
        case "left":
          tl.x = pl;
          break;
        case "right":
          tl.x = mLayoutWidth - tl.width - pr;
          break;
        }
      }
    }

    protected function clean():void {
      while(numChildren > 0) removeChildAt(0);
    }

    private function changeFormat():void {
      if(!mIsFormatChanged) return;
      mFormat = new ElementFormat(new FontDescription(style.getString(FONT_FAMILY) || "sans",
                                                      style.getString(FONT_WEIGHT) || "bold"),
                                  style.getNumber(FONT_SIZE) || 14,
                                  style.getNumber(FONT_COLOR) || 0x00);
      mIsFormatChanged = false;
      setChanged();
    }

    private function changeBlock(w:Number):void {
      if(w <= 0) {
        trace("[Warning] width of Label should be positive integer. given: " + w);
        trace("[Warning] width is set to 4000");
        w = 4000;
      }
      var textElement:TextElement = new TextElement(style.getString(TEXT_CONTENT), mFormat);
      if(w < 4000 && getStyle(TEXT_ALIGN) == "justify") {
        var tj:TextJustifier = TextJustifier.getJustifierForLocale("en");
        tj.lineJustification = LineJustification.ALL_BUT_LAST;
        mTextBlock = new TextBlock(null, null, tj);
      } else mTextBlock = new TextBlock();
      mTextBlock.content = textElement;

      mRealTextWidth = 0;
      mRealTextHeight = 0;

      mText.splice(0, mText.length);
      var tl:TextLine = mTextBlock.createTextLine(null, w);
      while(tl) {
        mText.push(tl);
        mRealTextWidth = Math.max(mRealTextWidth, tl.textWidth);
        mRealTextHeight += tl.height+tl.descent;
        tl = mTextBlock.createTextLine(tl, w);
      }

      mRealWidth = mRealTextWidth + style.getNumber(Element.PADDING_LEFT) + style.getNumber(Element.PADDING_RIGHT);
      mRealHeight = mRealTextHeight + style.getNumber(Element.PADDING_TOP) + style.getNumber(Element.PADDING_BOTTOM);

      mIsBlockChanged = false;
      setChanged();
    }
  }
}
