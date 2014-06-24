package com.minimalui.containers {
  import flash.geom.Rectangle;
  import flash.display.DisplayObject;

  import com.minimalui.base.BaseContainer;
  import com.minimalui.base.ElementMetrix;
  import com.minimalui.base.RotatedElementMetrix;
  import com.minimalui.base.layout.BaseLayout;

  // TODO: Take care of absolutely positioned elements
  public class RawLayout extends BaseLayout {
    private static const ALIGNS:Array = ["left", "center", "right"];
    private static const VALIGNS:Array = ["top", "middle", "bottom"];
    private var mIsVertical:Boolean;
    private var mAlign:String = BaseContainer.ALIGN;
    private var mValign:String = BaseContainer.VALIGN;
    private var mAligns:Array = ALIGNS;
    private var mValigns:Array = VALIGNS;

    private var mDebug:Boolean = false;

    public function set debug(bb:Boolean):void { mDebug = bb; }

    public function RawLayout(isVertical:Boolean) {
      mIsVertical = isVertical;
      if(mIsVertical) {
        mAligns = VALIGNS;
        mValigns = ALIGNS;
        mAlign = BaseContainer.VALIGN;
        mValign = BaseContainer.ALIGN;
      }
    }

    public override function measure():Rectangle {
      var res:Object = columnProps(buildTargetMetrix(),
                                   target.style.getNumber(BaseContainer.SPACING),
                                   buildMetrixes());
      if(mDebug) trace("measured: " + res.w + " " + res.h);
      return mIsVertical ? new Rectangle(0, 0, res.h, res.w) : new Rectangle(0, 0, res.w, res.h);
    }

    public override function layout(columnWidth:Number, columnHeight:Number):Rectangle {
      if(mDebug) trace("expected: " + columnWidth + " " + columnHeight);
      var me:ElementMetrix = buildTargetMetrix();
      var metrixies:Vector.<ElementMetrix> = buildMetrixes();
      var sp:Number = target.style.getNumber(BaseContainer.SPACING);

      if(mIsVertical) {
        var cc:Number = columnWidth;
        columnWidth = columnHeight;
        columnHeight = cc;
      }

      var pp:Object;
      var i:uint;
      var w:Number, h:Number;
      var em:ElementMetrix;
      var cn:uint = metrixies.length;

      // split elements into columns. call only layout
      var lpt:Number = me.pt;

      var computedColumnWidth:Number = columnWidth;
      var computedColumnHeight:Number = columnHeight;
      if(mDebug) trace("computedColumnHeight = " + computedColumnHeight);

      // trace("fixed elements " + computedColumnHeight + "x" + computedColumnWidth);
      for(i = 0; i < cn; ++i) {
        em = metrixies[i];
        var skipSize:Boolean = false;

        pp = maxex({l: [me.pl, em.ml],
                    r: [me.pr, em.mr],
                    t: [lpt, em.mt],
                    b: i < cn - 1 ? [metrixies[i+1].mt, sp, em.mb] : [me.pb, em.mb]});

        if(isNaN(em.pw) && isNaN(em.ph)) {
          // trace(computedColumnWidth + " " + pp.l + " " + pp.r + " " + em.mw);
          w = Math.min(computedColumnWidth - pp.l - pp.r, em.mw);
          h = computedColumnHeight < 0 ? em.mh : Math.min(computedColumnHeight - pp.t - pp.b, em.mh);
          // trace(" w: " + w + " h:" + h);
          em.layout(w, h);
          em.validatedSize();
          // trace(" rw: " + em.w + " rh:" + em.h);
        }

        if(isNaN(em.pw))
          computedColumnWidth = Math.max(computedColumnWidth, (isNaN(em.w) ? em.mw : em.w) + pp.l + pp.r);

        if(isNaN(em.ph)) {
          if(mDebug) trace("value of height: " + em.rh);
          computedColumnHeight -= (isNaN(em.rh) ? em.mh : em.rh);
        }
        computedColumnHeight -= pp.t;

        lpt = pp.b;
      }
      computedColumnHeight -= lpt;
      var contentH:Number = columnHeight - Math.max(0, computedColumnHeight);
      var contentW:Number = Math.max(columnWidth, computedColumnWidth);
      if(mDebug) trace("computedColumnHeight = " + computedColumnHeight);
      if(mDebug) trace("columnHeight = " + columnHeight);
      if(mDebug) trace("columnH = " + contentH);

      if(mDebug) trace("width: " + contentW);
      for(i = 0; i < cn; ++i) {
        em = metrixies[i];
        if(isNaN(em.pw) && isNaN(em.ph)) continue;
        var emp:ElementMetrix = i > 0 ? metrixies[i - 1] : null;
        var emn:ElementMetrix = i < cn - 1 ? metrixies[i + 1] : null;

        pp = maxex({l: [me.pl, em.ml],
                    r: [me.pr, em.mr],
                    t: [emp ? emp.mt : me.pt, em.mt, i > 0 ? 0 : sp],
                    b: [emn ? emn.mt : me.pb, sp, em.mb]});

        w = isNaN(em.pw) ? Math.min(em.mw, contentW - pp.l - pp.r) : (contentW - pp.l - pp.r) * em.pw / 100;
        h = isNaN(em.ph) ? (contentH < 0 ? em.mh : Math.min(contentH - pp.t - pp.b, em.mh)) : (computedColumnHeight) * em.ph / 100;
        // trace(" w: " + w + " h:" + h);
        em.layout(w, h);
        if(mDebug) trace("gave: " + w + " " + h);
        em.validatedSize();
        // trace(" rw: " + em.w + " rh:" + em.h);
        contentW = Math.max(contentW, em.w);
      }

      var f:Vector.<Number> = Vector.<Number>([me.pt]);
      for each(em in metrixies) f.push(em.mt, em.h, em.mb);
      f.push(me.pb);
      var realContentHeight:Number = pack(f, sp);
      contentH = Math.max(columnHeight, realContentHeight);

      var lastVerticalMargin:Number = 4000;
      var yy:Number;
      if(metrixies.length > 0) {
        switch(target.getStyle(mValign) || mValigns[1]) {
        case mValigns[0]:
          yy = Math.max(me.pt, metrixies[0].mt);
        break;
        case mValigns[2]:
          yy = contentH - (realContentHeight - Math.max(me.pt, metrixies[0].mt));
        break;
        case mValigns[1]:
          yy = (contentH - realContentHeight + Math.max(me.pt, metrixies[0].mt) +
                Math.max(me.pb, metrixies[cn-1].mb)) / 2;
        break;
        }
      }

      if(mDebug) trace("Posing:");
      for each(em in metrixies) {
        if(mDebug) trace("s: " + em.mw + " " + em.mh + " " + em.w + " " + em.h);
        if(em.mt > lastVerticalMargin) yy += (em.mt - lastVerticalMargin);

        var xx:Number = 0;
        switch(target.getStyle(mAlign) || mAligns[1]) {
        case mAligns[0]:
          xx = Math.max(me.pl, em.ml);
          break;
        case mAligns[1]:
          xx = ((contentW - me.pl - me.pr) - em.w) / 2 + me.pl;
          break;
        case mAligns[2]:
          xx = contentW - em.w - Math.max(me.pr, em.mr);
          break;
        }

        // trace(" yy = " + yy);
        // trace(" xx = " + xx);
        em.move(xx, yy);

        lastVerticalMargin = Math.max(em.mb, sp);
        yy += em.h + lastVerticalMargin;
      }
      if(mDebug) trace("----------");

      return mIsVertical ? new Rectangle(0, 0, contentH, contentW) : new Rectangle(0, 0, contentW, contentH);
    }

    protected function maxex(o:Object):Object {
      var res:Object = {};
      for(var key:String in o)
        if(o.hasOwnProperty(key))
          res[key] = Math.max.apply(Math, o[key]);
      return res;
    }

    protected function pack(f:Vector.<Number>, s:Number):Number {
      var N:uint = (f.length - 2) / 3;
      var res:Number = 0;
      for(var i:uint = 1; i <= N; ++i)
        res += Math.max(f[i*3-3], f[i*3-2], (i > 1 ? s : 0)) + f[i*3-1];
      res += Math.max(f[i*3-3], f[i*3-2]);
      return res;
    }

    /**
     * Finds column properties for given column properties and elements.
     *
     * @param cm:ElementMetrix Column metrix.
     * @param sp:Number Column spacing.
     * @param els:Vector.<ElementMetrix> Children of column.
     *
     * @returns Object of format {columnWidth, columnHeight, columnLeftPadding, columnRightPadding}
     */
    protected function columnProps(holder:ElementMetrix, sp:Number, els:Vector.<ElementMetrix>):Object {
      var w:Number = holder.pl + holder.pr;
      var f:Vector.<Number> = Vector.<Number>([holder.pt]);
      if(mDebug) trace("Elements:");
      for each( var em:ElementMetrix in els) {
        if(mDebug) trace("s: " + em.mw + " " + em.mh + " " + em.ml + " " + em.mt + " " + em.mr + " " + em.mb);
        w = Math.max(w, (isNaN(em.pw) ? em.mw : 0) +
                        Math.max(holder.pl, em.ml) +
                        Math.max(holder.pr, em.mr));
        f.push(em.mt, isNaN(em.ph) ? em.mh : 0, em.mb);
      }
      if(mDebug) trace("------------");
      f.push(holder.pb);
      return { w: w, h:pack(f, sp) };
    }

    protected function buildTargetMetrix():ElementMetrix {
      return mIsVertical ? new RotatedElementMetrix(target) : new ElementMetrix(target);
    }

    protected function buildMetrixes():Vector.<ElementMetrix> {
      var els:Vector.<DisplayObject> = target.visibleChildren;
      var res:Vector.<ElementMetrix> = new Vector.<ElementMetrix>;
      var o:DisplayObject;
      var C:Class = mIsVertical ? RotatedElementMetrix : ElementMetrix;
      for each(o in els)
        if(o.visible) res.push(new C(o));
      return res;
    }
 }
}