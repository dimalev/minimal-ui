package cases.com.minimalui.base {
  import com.minimalui.base.ElementMetrix;

  public class ElementMetrixStub extends ElementMetrix {

    public var lw:Number;
    public var lh:Number;
    public var mx:Number;
    public var my:Number;

    public final function get adaptee():DisplayObject { return mAdaptee; }

    public function ElementMetrix(o:DisplayObject) {
      adopt(o);
    }

    public override function validatedSize():void {
    }

    public override function layout(w:Number, h:Number):void {
      lw = w;
      lh = h;
    }

    public override function move(x:Number, y:Number):void {
      mx = x;
      my = y;
    }

    public override function adopt(o:DisplayObject):void {
    }

    public override function toString():String { return "ElementMetrixStub"; }
  }
}
