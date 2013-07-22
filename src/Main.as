package {
  import flash.display.Sprite;
  import flash.display.DisplayObject;
  import flash.geom.Rectangle;
  import flash.utils.setTimeout;

  import com.minimalui.containers.RawLayout;
  import com.minimalui.decorators.WinButtonBackground;
  import com.minimalui.hatchery.Application;
  import com.minimalui.hatchery.ScreenManager;
  import com.minimalui.hatchery.ToolTips;
  import com.minimalui.base.BaseContainer;
  import com.minimalui.base.Element;
  import com.minimalui.base.LayoutManager;
  import com.minimalui.base.BaseButton;
  import com.minimalui.controls.Label;
  import com.minimalui.controls.Input;
  import com.minimalui.controls.TextLabel;
  import com.minimalui.containers.HBox;
  import com.minimalui.containers.VBox;
  import com.minimalui.controls.Button;
  import com.minimalui.factories.XMLFactory;
  import com.minimalui.factories.FullXMLFactory;
  import com.minimalui.factories.handlers.ToolTipsHandler;

  public class Main extends Application {
    [Embed(source="../res/fontawesome-webfont.ttf", fontName="FontAwesome",fontFamily="FontAwesome")]
    private static var FontAwesome:Class;

    private var mFactory:XMLFactory;
    protected override function onAdd():void {
      mFactory = new FullXMLFactory();
      mFactory.setCSS("\
// hbox {\
//   padding: 10;\
//   background-color: 0xffff;\
//   align: center;\
// }\
text-button {\
  background-gradient-color-1: yellow;\
  padding-left: 10;\
  padding-right: 10;\
  padding-top: 5;\
  padding-bottom: 5;\
}\
.board {\
  background-gradient-color-1: 0x222222;\
  background-gradient-color-1: 0x444444;\
  padding: 10;\
}\
button {\
  padding-left: 10;\
  padding-right: 10;\
  padding-top: 5;\
  padding-bottom: 5;\
}\
");
      usecase5();
    }

    protected var tooltips:ToolTips;

    public function usecase5():void {
      tooltips = new ToolTips();
      mFactory.addAttributeHandler(new ToolTipsHandler(tooltips));

      var xml:XML = <vbox spacing="5" class="board">
        <hbox spacing="5">
          <text-button text="hello" alt="say hello" />
          <text-button text="how are you?" alt="say how are you?" />
          <text-button text="good bye!" alt="say good bye!" />
        </hbox>
        <hbox spacing="5">
          <text-button text="spare money" alt="spare some money" click="summonBubble" />
          <element id="yellowBox" width="60" height="60" background-color="yellow" />
        </hbox>
      </vbox>;

      addChild(mFactory.decode(xml, this));
      addChild(tooltips);
    }

    public var yellowBox:Element;
    public function summonBubble():void {
      var money:Element = mFactory.decode(<label background-color="red" font-size="20" font-color="white">10$</label>);
      tooltips.addToolTip(yellowBox, money);
      setTimeout(function():void { tooltips.remove(money); }, 2000);
    }

    protected var screenManager:ScreenManager;
    /*
      Application multi-view test
    */
    public function usecase4():void {
      screenManager = new ScreenManager("percent-width: 100; percent-height:100");
      addChild(screenManager);
      var xml:XML = <box id="holder">
        <hbox id="first" valign="middle" align="center" width="200" height="200">
          <button text="Next" click="showScreenTwo" />
        </hbox>
        <hbox id="two" valign="middle" align="center" width="200" height="200">
          <button click="showScreenFirst" text="Left" />
          <checkbox text="hello" />
          <button click="showScreenThree" text="Right" />
        </hbox>
        <hbox id="three" valign="middle" align="center" width="200" height="200">
          <button click="showScreenTwo" text="Left" />
          <label text="this is end" />
        </hbox>
      </box>;
      var e:BaseContainer = mFactory.decode(xml, this) as BaseContainer;
      screenManager.addViews(e);
      screenManager.showScreen("first");
    }

    public function showScreenFirst():void { screenManager.showScreen("first"); }
    public function showScreenTwo():void { screenManager.showScreen("two"); }
    public function showScreenThree():void { screenManager.showScreen("three"); }

    public var e:Element;
    /*
      Showing part of an image with clipper and resize
    */
    public function usecase3():void {
      var xml:XML = <scrollControlBase id="scb" width="100" height="100">
                      <box id="b-out" align="center" valign="middle">
                        <box id="b-big" background-color="0xff" width="200" height="200" />
                        <box id="b-small" background-color="0xff0000" width="100" height="100" />
                        <button text="enlarge" click="enlarge" top="25" left="0" />
                        <button text="move" click="move100" bottom="25" left="0" />
                      </box>
                    </scrollControlBase>;
      e = mFactory.decode(xml, this) as Element;
      addChild(e);
    }

    public function move100():void { e.setStyle("scrollX", 100); }
    public function enlarge():void { e.height = 200; }

    /*
      Huge piece of text wrapped.
    */
     public function usecase2():void {
      var xml:XML = <vbox id="main-vbox" width="200" padding="4" background-color="0xffff00" spacing="4">
        <label background-color="0xff00ff" text="When the Nautilus was ready to submerge again, I went back to the saloon. The hatches were closed and our course was set due west." />
        <button text="Wow!" percent-width="100" />
      </vbox>;
      var e:VBox = mFactory.decode(xml, this) as VBox;
      addChild(e);
    }

    /*
      Complex view
    */
    public function usecase1():void {
      mFactory.addDecorator(WinButtonBackground.descriptor);
      mFactory.setCSS("\
label {\
  font-size: 20;\
  font-color: 0xff00;\
}\
\
text-button {\
  background-gradient-color-1: yellow;\
  border-width: 1;\
  border-color: back;\
  font-weight: bold;\
  font-family: _sans;\
  padding: 5;\
  padding-left: 20;\
  padding-right: 20;\
}\
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
      var xml:XML = <hbox id="main-hbox" valign="middle" font-size="14">
        <vbox margin-right="20" id="vbox-left">
          <label text="Game" id="label-Game" />
          <text-button text="Play" id="playBtn" width="120" spacing="5" click="say1" />
          <text-button text="Load" disabled="true" id="button-load" />
          <text-label id="txtLbl" text="This is simple text" />
          <button id="button-exit" layout="horizontal" background-color="0xbbbbbb"
                      padding="5" spacing="5">
            <text-label text="\uf0fc"
                   font-family="FontAwesome" font-size="16" font-color="0xff" />
            <label text="Have Beer" font-color="0xff" />
          </button>
          <input holder="Enter something" percent-width="100" height="25" id="somethingInp" />
        </vbox>
        <scrollControlBase height="50">
        <vbox id="vbox-right">
          <label text="Settings" id="label-settings" />
          <button id="imgBtn" border-width="1" padding="3" click="say3" >
            <image src="http://images.wikia.com/dungeonkeeper/images/0/01/Dark_Angel-icon.png" />
          </button>
          <vbox id="vbox-right">
            <button text="Vi:deo:" id="button-video" click="say2" />
            <checkbox text="hello" box-color="0xffffff" box-fill-color="0xff0000" />
            <text-button text="Network" id="button-network" />
            <text-button text="Controls" id="button-controls" />
          </vbox>
        </vbox>
        </scrollControlBase>
      </hbox>;
      var e:HBox = mFactory.decode(xml, this) as HBox;
      addChild(e);
    }

    public var imgBtn:BaseButton;
    public var playBtn:BaseButton;
    public var somethingInp:Input;
    public var txtLbl:TextLabel;

    public function say1():void {
      imgBtn.scaleX = imgBtn.scaleY = 0.3;
    }

    public function say2():void {
      imgBtn.scaleX = imgBtn.scaleY = 1;
    }

    public function say3():void {
      txtLbl.text = somethingInp.text;
    }
  }
}