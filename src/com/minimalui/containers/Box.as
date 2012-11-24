package com.minimalui.containers {
  import flash.display.Sprite;

  import com.minimalui.base.Element;
  import com.minimalui.base.Style;
  import com.minimalui.events.ElementResizeEvent;
  import com.minimalui.events.FieldChangeEvent;

  public class Box extends Element {
    public var margin:Vector.<Number> = Vector.<Number>([5,5,5,5]);

    protected var mAlign:String = "center";
    protected var mVerticalAlign:String = "middle";
    protected var mWidth:Number = -1;
    protected var mHeight:Number = -1;
    protected var mRealWidth:Number = 0;
    protected var mRealHeight:Number = 0;

    public override function get width():Number { return mWidth > 0 ? mWidth : mRealWidth; }
    public override function get height():Number { return mHeight > 0 ? mHeight : mRealHeight; }

    public override function set width(w:Number):void {
      mWidth = w;
      redraw();
    }
    public override function set height(h:Number):void {
      mHeight = h;
      redraw();
    }
    public function set align(a:String):void {
      mAlign = a;
      redraw();
    }
    public function set valign(a:String):void {
      mVerticalAlign = a;
      redraw();
    }

    protected var mElements:Vector.<Element> = new Vector.<Element>;

    public function Box(items:Vector.<Element> = null) {
      style = new Style();
      if(!items) return;
      lock();
      for each(var i:Element in items) add(i);
      lock(false);
    }

    protected override function onStyleChange(fce:FieldChangeEvent):void {
    }

    protected override function coreRedraw():void {
      var w:Number = mWidth;
      var h:Number = mHeight;
      if(w == -1 || h == -1) {
        var w1:Number = 0;
        var h1:Number = 0;
        for(var i:uint = 0; i < mElements.length; ++i) {
          w1 = Math.max(w1, mElements[i].width);
          h1 = Math.max(h1, mElements[i].height);
        }
        if(w == -1) w = w1 + margin[0] + margin[2];
        if(h == -1) h = h1 + margin[1] + margin[3];
      }

      adjustVertically(h);
      adjustHorisontally(w);
      mRealWidth = w;
      mRealHeight = h;
    }

    protected function adjustVertically(h:Number):void {
      for(var i:uint = 0; i < mElements.length; ++i) {
        switch(mVerticalAlign) {
        case "top":
          mElements[i].y = margin[1];
          break;
        case "middle":
          mElements[i].y = margin[1] + Math.round((h - margin[1] - margin[3] - mElements[i].height) / 2);
          break;
        case "bottom":
          mElements[i].y = h - margin[3] - mElements[i].height;
          break;
        }
      }
    }

    protected function adjustHorisontally(w:Number):void {
      for(var i:uint = 0; i < mElements.length; ++i) {
        switch(mAlign) {
        case "left":
          mElements[i].x = margin[0];
          break;
        case "center":
          mElements[i].x = margin[0] + Math.round((w - margin[0] - margin[2] - mElements[i].width) / 2);
          break;
        case "right":
          mElements[i].x = w - margin[2] - mElements[i].width;
          break;
        }
      }
    }

    public function add(s:Element):void {
      addChild(s);
      if(s.style) s.style.parent = style;
      mElements.push(s);
      s.addEventListener(ElementResizeEvent.RESIZE, onChildResize);
      redraw();
    }

    public function remove(s:Element):Boolean {
      var i:int = mElements.indexOf(s);
      if(i == -1) return false;
      removeAt(i);
      return true;
    }

    public function removeAt(i:uint):Element {
      var s:Element = getChildAt(i) as Element;
      s.removeEventListener(ElementResizeEvent.RESIZE, onChildResize);
      removeChild(s);
      if(s.style) s.style.parent = null;
      mElements.splice(i, 1);
      redraw();
      return s;
    }

    private function onChildResize(ere:ElementResizeEvent):void {
      redraw();
    }
  }
}