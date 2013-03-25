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
  import com.minimalui.events.FieldChangeEvent;

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
    public static const TEXT_CONTENT:String = "content";

    private var mRealTextWidth:Number;
    private var mRealTextHeight:Number;

    private var mFormat:ElementFormat;
    private var mIsFormatChanged:Boolean = true;
    private var mTextBlock:TextBlock;
    private var mIsBlockChanged:Boolean = true;

    private var mText:Vector.<TextLine> = new Vector.<TextLine>;

    public function set content(txt:String):void {
      setStyle(TEXT_CONTENT, txt);
      setDirty();
      invalidateSize();
    }

    public function Label(text:String = "Label", cssorid:String = null, id:String = null) {
      super(cssorid, id);
      style.addInheritable(FONT_SIZE, FONT_FAMILY, FONT_COLOR, FONT_WEIGHT, TEXT_ALIGN, TEXT_VALIGN);
      content = text;
    }

    protected override function coreCommitProperties():void {
      if(hasChanged(Vector.<String>([FONT_SIZE, FONT_FAMILY, FONT_COLOR, FONT_WEIGHT, TEXT_ALIGN])))
        mIsFormatChanged = true;
      if(hasChanged(Vector.<String>([TEXT_CONTENT]))) mIsBlockChanged = true;
      if(mIsFormatChanged || mIsBlockChanged) {
        invalidateSize();
        setChanged();
      }
    }

    protected override function coreMeasure():void {
      changeFormat();
      changeBlock();
    }

    protected override function coreRedraw():void {
      clean();

      var tl:TextLine = null;
      mRealTextHeight = 0;
      mRealTextWidth = 0;
      while(tl = mTextBlock.createTextLine(tl, mViewPort.width)) {
        addChild(tl);
        mRealTextWidth = Math.max(mRealTextHeight, tl.width);
        mRealTextHeight += tl.height + tl.descent;
      }

      coreAlign();
    }

    protected function coreAlign():void {
      var tl:TextLine = null;

     var yy:Number = 0;
     switch(style.getValue(TEXT_VALIGN) || "top") {
     case "middle":
       yy = (mViewPort.height - mRealTextHeight) / 2;
       break;
     case "bottom":
       yy = mViewPort.height - mRealTextHeight;
       break;
     }
     if(yy < 0) yy = 0;

      for(var i:uint = 0; i < numChildren; ++i) {
        tl = getChildAt(i) as TextLine;
        tl.y = yy + tl.height;
        yy += tl.height + tl.descent;
        switch(style.getValue(TEXT_ALIGN) || "left") {
        case "center":
          tl.x = (mViewPort.width - tl.width) / 2;
          break;
        case "left":
          tl.x = 0;
          break;
        case "right":
          tl.x = mViewPort.width - tl.width;
          break;
        }
      }
    }

    protected function clean():void {
      while(numChildren > 0) removeChildAt(0);
    }

    private function changeFormat():void {
      // if(!mIsFormatChanged) return;
      mFormat = new ElementFormat(new FontDescription(style.getString(FONT_FAMILY) || "sans",
                                                      style.getString(FONT_WEIGHT) || "bold"),
                                  style.getNumber(FONT_SIZE) || 14,
                                  style.getNumber(FONT_COLOR) || 0x00);
      mIsFormatChanged = false;
      mIsBlockChanged = true;
      setChanged();
    }

    private function changeBlock():void {
      // if(!mIsBlockChanged) return;
      var textElement:TextElement = new TextElement(getStyle("content") as String, mFormat);
      if(style.hasValue("width")) {
        var tj:TextJustifier = TextJustifier.getJustifierForLocale("en");
        tj.lineJustification = LineJustification.ALL_BUT_LAST;
        mTextBlock = new TextBlock(null, null, tj);
      } else mTextBlock = new TextBlock();
      mTextBlock.content = textElement;

      var textWidth:Number = 0;
      var textHeight:Number = 0;

      mText.splice(0, mText.length);
      var tl:TextLine = null;
      var w:Number = mStyle.hasValue("width") ? mStyle.getNumber("width") : 4000;
      while(tl = mTextBlock.createTextLine(tl, w)) {
        mText.push(tl);
        textWidth = Math.max(textWidth, tl.width);
        textHeight += tl.height+tl.descent;
      }

      mMeasuredWidth = Math.ceil(Math.max(mStyle.getNumber("width"), textWidth));
      mMeasuredHeight = Math.ceil(Math.max(mStyle.getNumber("height"), textHeight));

      mIsBlockChanged = false;
      setChanged();
    }
  }
}
