package cases.com.minimalui.flexunit {
  import org.flexunit.Assert;
  import com.minimalui.base.Element;

  public class PosAssert {
    public static function real(msg:String, e:Element, x:Number, y:Number):void {
      Assert.assertEquals(msg + "[x]", x, e.x);
      Assert.assertEquals(msg + "[y]", y, e.y);
    }
  }
}