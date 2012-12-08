package cases {
  import org.flexunit.Assert;
  import com.minimalui.base.Style;

  public class StylesTest {
    [Test(description = "test changed values")]
    public function changed():void {
      var s:Style = new Style();
      s.setValue("f1", "v1");
      s.setValue("f2", "v2");
      Assert.assertEquals("Counting own changed values", 2, s.changed.length);
      s.cleanChanged();
      Assert.assertEquals("After cleaning changed values", 0, s.changed.length);
      var p:Style = new Style();
      p.setValue("f3", "v2");
      p.setValue("f4", "v4");
      s.parent = p;
      Assert.assertEquals("Parent values not set as inheritable should not be poplated", 0, s.changed.length);
      s.addInheritable("f4");
      Assert.assertEquals("One inheritable field changed", 1, s.changed.length);
      var p2:Style = new Style();
      p2.setValue("f4", "v20");
      p2.setValue("f5", "v5");
      s.addInheritable("f5");
      p.parent = p2;
      Assert.assertEquals("Two inheritable field changed", 2, s.changed.length);
      Assert.assertEquals("Father value", "v4", s.getValue("f4"));
      Assert.assertEquals("Grand-Father value", "v5", s.getValue("f5"));
    }
  }
}