package {
  import flash.display.Sprite;
  import flash.geom.Rectangle;

  import com.minimalui.base.Element;
  import com.minimalui.base.LayoutManager;
  import com.minimalui.base.BaseContainer;
  // import com.minimalui.controls.Button;
  import com.minimalui.controls.Label;
  import com.minimalui.controls.Button;
  import com.minimalui.containers.VBox;
  import com.minimalui.containers.HBox;
  // import com.minimalui.containers.Box;
  // import com.minimalui.containers.VBox;
  // import com.minimalui.containers.HBox;
  // import com.minimalui.decoration.GradientBackground;

  public class TMain extends Sprite {
    public function TMain() {
      LayoutManager.setDefault(new LayoutManager(stage));
      var l:Label = new Label("hello, world!\nThis is number ONE!\nREad mgg mind", "border-width:1");
      var l1:Label = new Label("The other gggg. Read me well!", "border-width:1");
      var l2:Button = new Button("New Game");
      var l21:Button = new Button("Load Game");
      var l22:Button = new Button("Quit Game");
      var b:VBox = new VBox(null, "border-width:1; vertical-spacing:5");
      var b1:VBox = new VBox(null, "border-width:1; vertical-spacing:5;padding-left:10; padding-right:10");
      var hb:HBox = new HBox(null, "padding-top:5; padding-bottom:5; padding-left:5; padding-right:5; border-width:1; horizontal-spacing:10");
      b.addChild(l);
      // b.setStyle("padding-top", 10);
      // l.setStyle("margin-right", 20);
      b.addChild(l1);
      // l1.setStyle("font-color", 0x00ff00);
      b1.addChild(l2);
      b1.addChild(l21);
      b1.addChild(l22);
      // l2.setStyle("font-color", 0x00ff);
      // l2.setStyle("font-size", 20);
      hb.addChild(b);
      hb.addChild(b1);
      addChild(hb);
      hb.x = 100;
      // addChild(b);
      // b.layout(new Rectangle(0, 0, 500, 500));
      // var hbox:Box = new VBox(Vector.<Element>([new Button("First"), new Button("Second"), new Button("Third")]));
      // var bb:Button = new Button("Right");
      // var h:Box = new HBox(Vector.<Element>([
      //     hbox,
      //     new VBox(Vector.<Element>([new Label("Main Menu"), bb, new Button("Right-Bottom")])),
      //                                       ]));
      // // var h:Box = new VBox(Vector.<Sprite>([new Button("Right"), new Label("Hello!"), new Button("Right-Bottom")]));
      // addChild(h);
      // h.lock();
      // h.backgroundDrawer = new GradientBackground([0xb5651d, 0x996515]).withBorder(0, 0xffffff);
      // h.style.lock();
      // h.style.setValue(Label.FONT_SIZE, 20);
      // h.style.setValue(Label.FONT_COLOR, 0xffffff);
      // hbox.style.lock();
      // hbox.style.setValue(Label.FONT_SIZE, 16);
      // hbox.style.setValue(Label.FONT_COLOR, 0xffff00);
      // hbox.style.lock(false);
      // h.style.lock(false);
      // h.lock(false);
      // bb.lock();
      // bb.width = 300;
      // bb.height =120;
      // bb.lock(false);
      // h.x = (stage.stageWidth - h.width) / 2;
      // h.y = (stage.stageHeight - h.height) / 2;
      // hbox.redraw();
      // h.add(new Button("Begin Battle"));
      // h.add(new Button("Find Enemy"));
      // h.add(new Button("Go Android"));
      // b.onClick = function():void {
      //   b.visible = false;
      // }
      // h.redraw();
    }
  }
}