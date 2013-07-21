package cases.com.minimalui.flexunit {
  import org.flexunit.Assert;
  import com.minimalui.base.Element;

  public class SizeAssert {
    public static function measured(msg:String, e:Element, mw:Number, mh:Number):void {
      Assert.assertEquals(msg + "[measured-width]", mw, e.measuredWidth);
      Assert.assertEquals(msg + "[measured-height]", mh, e.measuredHeight);
    }

    public static function real(msg:String, e:Element, w:Number, h:Number):void {
      Assert.assertEquals(msg + "[real-width]", w, e.width);
      Assert.assertEquals(msg + "[real-height]", h, e.height);
    }
  }
}