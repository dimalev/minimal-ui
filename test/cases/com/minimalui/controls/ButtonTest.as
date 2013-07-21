package cases.com.minimalui.controls {
  import org.flexunit.Assert;

  import cases.com.minimalui.flexunit.SizeAssert;
  import cases.com.minimalui.flexunit.PosAssert;

  import com.minimalui.base.LayoutManager;
  import com.minimalui.factories.FullXMLFactory;
  import com.minimalui.factories.XMLFactory;
  import com.minimalui.controls.Label;
  import com.minimalui.base.BaseButton;

  public class ButtonTest {
    private static var sFactory:XMLFactory;
    [BeforeClass]
    public static function setupFactory():void {
      sFactory = new FullXMLFactory();
    }

    [Test(description = "basic sizes")]
    public function paddings():void {
      var l:BaseButton = sFactory.decode(<button padding="10" layout="horizontal"><text-label text="hello" /></button>) as BaseButton;
      LayoutManager.getDefault().forceUpdate();
      SizeAssert.real("button measured size", l, l.measuredWidth, l.measuredHeight);
    }
  }
}
