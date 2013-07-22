package com.minimalui.base.layout {
  import flash.geom.Rectangle;
  import flash.display.DisplayObject

  import com.minimalui.base.Element;
  import com.minimalui.base.ElementMetrix;
  import com.minimalui.base.BaseContainer;

  public class FreeLayout extends BaseLayout {
    public override function measure():Rectangle {
      var metrixes:Vector.<ElementMetrix> = buildMetrixes();
      var me:ElementMetrix = buildTargetMetrix();
      var res:Rectangle = new Rectangle(me.pl + me.pr, me.pt + me.pb);
      for each(var o:ElementMetrix in metrixes) {
          // TODO: Take position in account and measure bounds depending on x,y of absolute elements
        if(isNaN(o.pw))
          res.width = Math.max(res.width, o.mw + Math.max(me.pl, o.ml) + Math.max(me.pr, o.mr));
        if(isNaN(o.ph))
          res.height = Math.max(res.height, o.mh + Math.max(me.pt, o.mt) + Math.max(me.pb, o.mb));
      }
      res.height = Math.max(res.height, target.style.getNumber("height"));
      res.width = Math.max(res.width, target.style.getNumber("width"));
      return res;
    }

    public override function layout(width:Number, height:Number):Rectangle {
      var metrixes:Vector.<ElementMetrix> = buildMetrixes();
      var me:ElementMetrix = buildTargetMetrix();
      var res:Rectangle = new Rectangle(me.pl + me.pr, me.pt + me.pb);
      for each(var o:ElementMetrix in metrixes) {
        var w:Number = o.mw;
        var h:Number = o.mh;
        var l:Number = Math.max(me.pl, o.ml);
        var r:Number = Math.max(me.pr, o.mr);
        var t:Number = Math.max(me.pt, o.mt);
        var b:Number = Math.max(me.pb, o.mb);
        if(!isNaN(o.pw))
          w = o.pw * (width - l - r) / 100;
        if(!isNaN(o.ph))
          h = o.ph * (height - t - b) / 100;
        o.layout(w, h);
        switch(target.getStyle("align") || "left") {
        case "center":
          l = (width - w) / 2;
          break;
        case "right":
          l = width - w - r;
          break;
        }
        l = Math.min(Math.max(l, o.ml, me.pl), width - w - Math.max(o.mr, me.pr))
        switch(target.getStyle("valign") || "top") {
        case "middle":
          t = (height - h) / 2;
          break;
        case "bottom":
          t = height - h - b;
          break;
        }
        t = Math.min(Math.max(t, o.mt, me.pt), height - h - Math.max(o.mb, me.pb))
        var x:Number = l;
        var y:Number = t;
        if(!isNaN(o.l)) x = o.l;
        else if(!isNaN(o.r)) x = width - o.r - w;
        if(!isNaN(o.t)) y = o.t;
        else if(!isNaN(o.b)) y = height - o.b - h;
        if(o.pos == Element.POSITION_RELATIVE) o.move(x, y);
        res.width = Math.max(res.width, w + l + r);
        res.height = Math.max(res.height, h + t + b);
      }
      return res;
    }

    protected function buildTargetMetrix():ElementMetrix {
      return new ElementMetrix(target);
    }

    protected function buildMetrixes():Vector.<ElementMetrix> {
      var els:Vector.<DisplayObject> = target.visibleChildren;
      var res:Vector.<ElementMetrix> = new Vector.<ElementMetrix>;
      var o:DisplayObject;
      for each(o in els) res.push(new ElementMetrix(o));
      return res;
    }
  }
}
