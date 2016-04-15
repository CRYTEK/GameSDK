import cryflash.CryObjects.Buttons.CrySlider;
import cryflash.Registry;
import cryflash.Definitions;

import caurina.transitions.*

/**
 * ...
 * @author RuneRask
 * refactoring/cleanup by ManuelB (April 10 2014)
 */

class cryflash.Examples.Slider extends cryflash.CryObjects.Buttons.CrySlider {
    private var color1:Color;
    private var color2:Color;

    public function Slider(id:String, min, max, val, caption:String, tooltip:String) {
        super(id, min, max, "TempSlider", cryflash.Registry.buttonContainer);

        color1 = new Color(movieClipChild["sliderBar"]);
        color2 = new Color(movieClipChild["hitbox"]);

		addSliderObjectReferences("leftArrow", "rightArrow", "sliderValue", "sliderBar", "hitbox");
        addHitbox("hitbox");
        addCaption("caption", caption);
        addTooltip(Registry.toolTipTextfield, tooltip);
        placeObject(Registry.columnObjects, Registry.column);
        createEventHandlers();
		setValue(val);
    }

    private function onRollOver():Void {
        super.onRollOver();
        Tweener.addTween(leftArrow, {_alpha: 100, time: 0.5});
        Tweener.addTween(rightArrow, {_alpha: 100, time: 0.5});
        sliderValue.textColor = 0x00A1DE;
        captionTextfield.textColor = 0x00A1DE;
        color1.setRGB(0x00A1DE);
        color2.setRGB(0x00A1DE);
    }

    private function onRollOut():Void {
        super.onRollOut();
        Tweener.addTween(rightArrow, { _alpha: 0, time: 0.5  });
        Tweener.addTween(leftArrow, { _alpha: 0, time: 0.5 });
        sliderValue.textColor = 0xFFFFFF;
        captionTextfield.textColor = 0xFFFFFF;
        color1.setRGB(0xFFFFFF);
        color2.setRGB(0xFFFFFF);
    }
}