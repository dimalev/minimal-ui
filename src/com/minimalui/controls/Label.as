package com.minimalui.controls {
  import flash.display.Sprite;
  import flash.text.engine.TextLine;
  import flash.text.engine.TextBlock;
  import flash.text.engine.TextElement;
  import flash.text.engine.FontDescription;
  import flash.text.engine.ElementFormat;

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

    public static var sDefaultStyle:Style = getDefaultStyle();

    private static function getDefaultStyle():Style {
      var obj:Object = new Object;
      obj[FONT_FAMILY] = "sans serif";
      obj[FONT_SIZE]   = 12;
      obj[FONT_COLOR]  = 0x000000;
      obj[FONT_WEIGHT] = "normal";
      obj[TEXT_ALIGN]  = "left";
      obj[TEXT_VALIGN] = "top";

      return new Style(obj).freeze();
    }
    private var mWidth:Number = -1;
    private var mHeight:Number = -1;

    private var mTextWidth:Number;
    private var mTextHeight:Number;

    private var mFormat:ElementFormat;

    private var mContent:String;

    public override function set width(w:Number):void { mWidth = w; redraw(); }
    public override function set height(h:Number):void { mHeight = h; coreAlign(); }
    public function set text(txt:String):void { mContent = txt; redraw(); }

    public function get textWidth():Number { return mTextWidth; }
    public function get textHeight():Number { return mTextHeight; }

    public override function get width():Number { return mWidth > 0 ? mWidth : mTextWidth; }
    public override function get height():Number { return mHeight > 0 ? mHeight : mTextHeight; }

    public function set content(txt:String):void {
      mContent = txt;
      redraw();
    }

    public function Label(text:String, style:Object = null) {
      this.defaultStyle = sDefaultStyle;
      mContent = text;
      if(style is Style) this.style = style as Style;
      else if(style != null) this.style = new Style(style);
      else this.style = new Style();
      this.style.lock();
      this.style.lock(false);
      redraw();
    }

    protected override function onStyleChange(fce:FieldChangeEvent):void {
      if(Style.doTrace) trace("parent values changed " + fce.fields.join(", "));
      var isAlignChanged:Boolean = fce.contains(Vector.<String>([TEXT_ALIGN, TEXT_VALIGN]));

      if(fce.contains(Vector.<String>([FONT_SIZE, FONT_FAMILY, FONT_COLOR, FONT_WEIGHT]))) {
        this.redraw();
        isAlignChanged = false;
      }

      if(isAlignChanged) this.coreAlign();
    }

    protected override function coreRedraw():void {
      mFormat = new ElementFormat(new FontDescription(style.getString(FONT_FAMILY), style.getString(FONT_WEIGHT)),
                                  style.getNumber(FONT_SIZE), style.getNumber(FONT_COLOR));
      var textElement:TextElement = new TextElement(mContent, mFormat);
      var textBlock:TextBlock = new TextBlock();
      textBlock.content = textElement;

      clean();

      var width:Number = mWidth;
      if(width < 0) width = 4000;
      mTextWidth = 0;
      mTextHeight = 0;

      var tl:TextLine = null;
      while(tl = textBlock.createTextLine(tl, width)) {
        addChild(tl);
        mTextWidth = Math.max(mTextWidth, tl.width);
        mTextHeight += tl.height;
      }
      if(textBlock.lastLine) mTextHeight -= textBlock.lastLine.descent;

      coreAlign();
    }

    protected function coreAlign():void {
      var tl:TextLine = null;

     var yy:Number = 0;
      if(mHeight > 0) {
        switch(style.getValue(TEXT_VALIGN)) {
        case "middle":
          yy = (mHeight - mTextHeight) / 2;
          break;
        case "bottom":
          yy = mHeight - mTextHeight;
          break;
        }
      }

      var width:Number = mWidth;
      if(width < 0) width = mTextWidth;
      for(var i:uint = 0; i < numChildren; ++i) {
        tl = getChildAt(i) as TextLine;
        tl.y = yy + tl.ascent;
        yy += tl.height;
        switch(style.getValue(TEXT_ALIGN)) {
        case "center":
          tl.x = (width - tl.width) / 2;
          break;
        case "left":
          tl.x = 0;
          break;
        case "right":
          tl.x = width - tl.width;
          break;
        }
      }
    }

    protected function clean():void {
      while(numChildren > 0) removeChildAt(0);
    }
  }
}
