package cases.com.minimalui.factories {
  import org.flexunit.Assert;
  import com.minimalui.factories.CSSFilter;

  public class CSSFilterTest {
    [Test(description = "Check static CSS Filter parser")]
    public function building():void {
      var cf:CSSFilter = CSSFilter.fromString("box");
      Assert.assertEquals("tag name", "box", cf.tagName);
      Assert.assertNull("class name", cf.className);
      Assert.assertNull("namespace", cf.classNamespace);

      cf = CSSFilter.fromString("box.black");
      Assert.assertEquals("tag name", "box", cf.tagName);
      Assert.assertEquals("class name", "black", cf.className);
      Assert.assertNull("namespace", cf.classNamespace);

      cf = CSSFilter.fromString("box.black:hover");
      Assert.assertEquals("tag name", "box", cf.tagName);
      Assert.assertEquals("class name", "black", cf.className);
      Assert.assertEquals("namespace", "hover", cf.classNamespace);

      cf = CSSFilter.fromString(".black:hover");
      Assert.assertNull("tag name", cf.tagName);
      Assert.assertEquals("class name", "black", cf.className);
      Assert.assertEquals("namespace", "hover", cf.classNamespace);

      cf = CSSFilter.fromString("box:hover");
      Assert.assertEquals("tag name", "box", cf.tagName);
      Assert.assertNull("class name", cf.className);
      Assert.assertEquals("namespace", "hover", cf.classNamespace);
    }

    [Test(description = "Check CSS filter")]
    public function matching():void {
      var cf:CSSFilter = new CSSFilter("box", "black");
      Assert.assertFalse("not match tag only", cf.match("box"));
      Assert.assertFalse("not match wrong styles", cf.match("box", Vector.<String>(["red", "deep"])));
      Assert.assertTrue("match tag and style", cf.match("box", Vector.<String>(["black", "deep"])));
    }
  }
}