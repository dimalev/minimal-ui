package com.minimalui.factories {
  import com.minimalui.factories.handlers.CallbackHandler;
  import com.minimalui.factories.handlers.ButtonHandler;
  import com.minimalui.factories.transformers.ColorTransformer;
  import com.minimalui.factories.transformers.RulerTransformer;
  import com.minimalui.base.BaseButton;
  import com.minimalui.controls.Label;
  import com.minimalui.controls.TextLabel;
  import com.minimalui.controls.Button;
  import com.minimalui.controls.Checkbox;
  import com.minimalui.controls.Input;
  import com.minimalui.containers.VBox;
  import com.minimalui.containers.HBox;
  import com.minimalui.containers.ScrollControlBase;
  import com.minimalui.hatchery.Image;
  import com.minimalui.decorators.Background;
  import com.minimalui.decorators.GradientBackground;
  import com.minimalui.decorators.Border;

  public class FullXMLFactory extends XMLFactory {
    public function FullXMLFactory() {
      super();
      addDecorator(Border.descriptor);
      addDecorator(Background.descriptor);
      addDecorator(GradientBackground.descriptor);

      addAttributeHandler(new CallbackHandler);
      addAttributeHandler(new ButtonHandler);

      addAttributeTransformer(new ColorTransformer);
      addAttributeTransformer(new RulerTransformer);

      addTagHandler("hbox", HBox);
      addTagHandler("vbox", VBox);
      addTagHandler("label", Label);
      addTagHandler("text-label", TextLabel);
      addTagHandler("text-button", Button);
      addTagHandler("button", BaseButton);
      addTagHandler("input", Input);
      addTagHandler("scrollControlBase", ScrollControlBase);
      addTagHandler("checkbox", Checkbox);
      addTagHandler("image", Image);
    }
  }
}
