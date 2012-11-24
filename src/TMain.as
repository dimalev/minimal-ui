package {
  import flash.display.Sprite;

  import com.minimalui.base.Element;
  import com.minimalui.base.Style;
  import com.minimalui.controls.Button;
  import com.minimalui.controls.Label;
  import com.minimalui.containers.Box;
  import com.minimalui.containers.VBox;
  import com.minimalui.containers.HBox;
  import com.minimalui.decoration.GradientBackground;

  public class TMain extends Sprite {
    public function TMain() {
      var hbox:Box = new VBox(Vector.<Element>([new Button("First"), new Button("Second"), new Button("Third")]));
      var bb:Button = new Button("Right");
      var h:Box = new HBox(Vector.<Element>([
          hbox,
          new VBox(Vector.<Element>([new Label("Main Menu"), bb, new Button("Right-Bottom")])),
                                            ]));
      // var h:Box = new VBox(Vector.<Sprite>([new Button("Right"), new Label("Hello!"), new Button("Right-Bottom")]));
      addChild(h);
      h.lock();
      h.backgroundDrawer = new GradientBackground([0xb5651d, 0x996515]).withBorder(0, 0xffffff);
      h.style.lock();
      h.style.setValue(Label.FONT_SIZE, 20);
      h.style.setValue(Label.FONT_COLOR, 0xffffff);
      hbox.style.lock();
      hbox.style.setValue(Label.FONT_SIZE, 16);
      hbox.style.setValue(Label.FONT_COLOR, 0xffff00);
      hbox.style.lock(false);
      h.style.lock(false);
      h.lock(false);
      bb.lock();
      bb.width = 300;
      bb.height =120;
      bb.lock(false);
      h.x = (stage.stageWidth - h.width) / 2;
      h.y = (stage.stageHeight - h.height) / 2;
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