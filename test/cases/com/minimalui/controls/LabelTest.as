package cases.com.minimalui.controls {
  import org.flexunit.Assert;

  import cases.com.minimalui.flexunit.SizeAssert;
  import cases.com.minimalui.flexunit.PosAssert;

  import com.minimalui.base.LayoutManager;
  import com.minimalui.controls.Label;

  public class LabelTest {
    // private static var sFactory:XMLFactory;
    // [BeforeClass]
    // public static function setupFactory():void {
    //   sFactory = new XMLFactory();
    // }

    [Test(description = "basic sizes")]
    public function paddings():void {
      var l:Label = new Label("This is ME!");
      LayoutManager.getDefault().forceUpdate();
      SizeAssert.real("label measured size", l, l.measuredWidth, l.measuredHeight);
    }
  }
}
