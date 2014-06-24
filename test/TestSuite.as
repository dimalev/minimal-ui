package {
  import cases.com.minimalui.base.layout.FreeLayoutTest;
  import cases.com.minimalui.controls.LabelTest;
  import cases.com.minimalui.controls.ButtonTest;
  import cases.com.minimalui.factories.CSSFilterTest;

  [Suite]
  [RunWith("org.flexunit.runners.Suite")]
  public class TestSuite {
    public var test1:FreeLayoutTest;
    public var test2:LabelTest;
    public var test3:ButtonTest;
    public var test4:CSSFilterTest;
  }
}