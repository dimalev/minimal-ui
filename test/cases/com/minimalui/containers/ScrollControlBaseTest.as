package cases.com.minimalui.containers {
  import org.flexunit.Assert;

  import com.minimalui.base.Element;
  import com.minimalui.containers.ScrollControlBase;
  import com.minimalui.base.LayoutManager;

  import cases.com.minimalui.flexunit.SizeAssert;
  import cases.com.minimalui.flexunit.PosAssert;

  public class ScrollControlBaseTest {
    [Test(description = "Scroll Base should use child measured size if explicitly not set")]
    public function useChildSize():void {
      var scb:ScrollControlBase = new ScrollControlBase("width:200; height:100");
      var e:Element = new Element("width:400; height:150");
      scb.addChild(e);
      LayoutManager.getDefault().forceUpdate();
      e.height = 300;
      LayoutManager.getDefault().forceUpdate();
      SizeAssert.real("scroll base size", scb, 200, 100);
    }
  }
}