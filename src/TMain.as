package {
  import flash.display.Sprite;
  import flash.geom.Rectangle;

  import com.minimalui.hatchery.Application;
  import com.minimalui.base.BaseContainer;
  import com.minimalui.base.Element;
  import com.minimalui.base.LayoutManager;
  import com.minimalui.containers.HBox;
  import com.minimalui.containers.VBox;
  import com.minimalui.controls.Button;
  import com.minimalui.factories.XMLFactory;

  public class TMain extends Application {
    private var mFactory:XMLFactory;
    protected override function onAdd():void {
      mFactory = new XMLFactory();
      mFactory.setCSS("\
hbox {\
  padding: 10;\
  background-color: 0xffff;\
  align: center;\
}\
");
      usecase4();
    }

    /*
      Application multi-view test
    */
    public function usecase4():void {
      var xml:XML = <box id="holder">
        <hbox id="first" valign="middle" align="center" width="200" height="200">
          <button id="next" text="Next" />
        </hbox>
        <hbox id="two" valign="middle" align="center" width="200" height="200">
          <button id="back" text="Left" />
          <checkbox content="hello" />
          <button id="next" text="Right" />
        </hbox>
        <hbox id="three" valign="middle" align="center" width="200" height="200">
          <button id="back" text="Left" />
          <label content="this is end" />
        </hbox>
      </box>;
      var e:BaseContainer = mFactory.decode(xml) as BaseContainer;
      screenManager.addViews(e);
      (screenManager.select("#first#next") as Button).onClick = function():void { screenManager.showScreen("two"); };
      (screenManager.select("#two#next") as Button).onClick = function():void { screenManager.showScreen("three"); };
      (screenManager.select("#two#back") as Button).onClick = function():void { screenManager.showScreen("first"); };
      (screenManager.select("#three#back") as Button).onClick = function():void { screenManager.showScreen("two"); };
      screenManager.showScreen("first");
    }

    /*
      Long text wrapped in lines based on parent size with button in bottom
    */
    public function usecase3():void {
      var xml:XML = <hbox id="main-hbox" valign="middle" width="200" height="200">
        <button text="hello" />
      </hbox>;
      var e:HBox = mFactory.decode(xml) as HBox;
      addChild(e);
    }

    /*
      Huge piece of text wrapped.
    */
     public function usecase2():void {
      var xml:XML = <vbox id="main-hbox" valign="middle" width="200">
        <label content="When the Nautilus was ready to submerge again, I went back to the saloon. The hatches were closed and our course was set due west." />
        <button text="Wow!" />
      </vbox>;
      var e:VBox = mFactory.decode(xml) as VBox;
      addChild(e);
    }

    /*
      Complex view
    */
    public function usecase1():void {
      mFactory.setCSS("\
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
}\
\
hbox {\
  padding: 10;\
  background-color: 0xffff;\
  align: center;\
}\
vbox {\
  spacing:5;\
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
        <vbox id="vbox-right">
        <label content="Settings" id="label-settings" />
        <scrollControlBase width="100" height="100">
          <vbox id="vbox-right">
            <button text="Vi:deo:" id="button-video" />
            <checkbox content="hello" />
            <button text="Network" id="button-network" />
            <button text="Controls" id="button-controls" />
          </vbox>
        </scrollControlBase>
        </vbox>
      </hbox>;
      var e:HBox = mFactory.decode(xml) as HBox;
      addChild(e);
    }
  }
}