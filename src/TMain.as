package {
  import flash.display.Sprite;
  import flash.geom.Rectangle;

  import com.minimalui.base.Element;
  import com.minimalui.base.LayoutManager;
  import com.minimalui.containers.HBox;
  import com.minimalui.controls.Button;
  import com.minimalui.factories.XMLFactory;

  public class TMain extends Sprite {
    public function TMain() {
      LayoutManager.setDefault(new LayoutManager(stage));
      var f:XMLFactory = new XMLFactory();
      f.setCSS("\
label {\
  font-size: 20;\
  font-color: 0xff00;\
  margin-bottom:5;\
}\
\
button {\
  border-width:1;\
  padding: 8;\
  font-color: 0xaaaaaa;\
  background-color: 0xff0000;\
  margin-bottom:5;\
}\
\
hbox {\
  padding: 10;\
  background-color: 0xffff;\
  align: center;\
}\
");
      var xml:XML = <hbox id="main-hbox" valign="middle">
        <vbox margin-right="20" id="vbox-left">
          <label content="Game" id="label-Game" />
          <button text="Play" id="button-play" width="120" height="80" align="right" />
          <button text="Load" disabled="true" id="button-load" />
          <button text="Exit" disabled="true" id="button-exit" />
        <input holder="Enter something" />
        </vbox>
        <scrollControlBase width="100" height="100">
          <vbox id="vbox-right" overflow="clip">
            <label content="Settings" id="label-settings" />
            <button text="Video" id="button-video" />
            <button text="Audio" id="button-audio" />
            <button text="Network" id="button-network" />
            <button text="Controls" id="button-controls" />
          </vbox>
        </scrollControlBase>
      </hbox>;
      var e:HBox = f.decode(xml) as HBox;
      addChild(e);
      // (e.getById("play") as Button).onClick = function():void { e.x = 200; };
      // (e.getById("exit") as Button).onClick = function():void { e.y = 200; };
    }
  }
}