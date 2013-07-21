package cases.com.minimalui.base.layout {
  import org.flexunit.Assert;

  import cases.com.minimalui.flexunit.SizeAssert;
  import cases.com.minimalui.flexunit.PosAssert;
  import com.minimalui.base.layout.FreeLayout;
  import com.minimalui.base.Element;
  import com.minimalui.base.LayoutManager;
  import com.minimalui.base.BaseContainer;

  public class FreeLayoutTest {
    [Test(description = "Testing centered simple layout")]
    public function simple():void {
      var bc:BaseContainer = new BaseContainer("align: center; valign: middle");
      var e1:Element = new Element("width: 100; height: 100");
      var e2:Element = new Element("width: 150; height: 50");
      var e3:Element = new Element("width: 50; height: 150");
      bc.addChild(e1);
      bc.addChild(e2);
      bc.addChild(e3);
      LayoutManager.getDefault().forceUpdate();
      SizeAssert.measured("basecontainer", bc, 150, 150);
      PosAssert.real("element 1", e1, 25, 25);
      PosAssert.real("element 2", e2, 0, 50);
      PosAssert.real("element 3", e3, 50, 0);
    }

    [Test(description="Margins of different elements in rectangle")]
    public function rectangle():void {
      var bc:BaseContainer = new BaseContainer("align: center; valign: middle;");
      bc.paddings = 50;
      var top:Element = new Element("width: 50; height: 50; margin-bottom:100");
      var bottom:Element = new Element("width: 50; height: 50; margin-top:100");
      var left:Element = new Element("width: 50; height: 100; margin-right:150");
      var right:Element = new Element("width: 50; height: 100; margin-left:150");
      var bg:Element = new Element("percent-width: 100; percent-height: 100");
      bc.addChild(top);
      bc.addChild(bottom);
      bc.addChild(left);
      bc.addChild(right);
      bc.addChild(bg);
      LayoutManager.getDefault().forceUpdate();
      SizeAssert.measured("box size", bc, 250, 200);
      PosAssert.real("top element", top, 100, 50);
      PosAssert.real("bottom element", bottom, 100, 100);
      PosAssert.real("left element", left, 50, 50);
      PosAssert.real("right element", right, 150, 50);
      SizeAssert.real("bg element size", bg, 150, 100);
      PosAssert.real("bg element possition", bg, 50, 50);
    }
  }
}