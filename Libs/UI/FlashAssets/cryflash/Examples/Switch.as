import cryflash.CryObjects.Buttons.CrySwitch;
import cryflash.Definitions;
import cryflash.Registry;

import caurina.transitions.*

/**
 * ...
 * @author RuneRask
 * refactoring/cleanup by ManuelB (April 10 2014)
 */

class cryflash.Examples.Switch extends cryflash.CryObjects.Buttons.CrySwitch {
    public function Switch(id:String, caption:String, tooltip:String) {
        super(id, "TempSwitch", cryflash.Registry.buttonContainer);

        addHitbox("hitbox");
        addCaption("caption", caption);
        addTooltip(Registry.toolTipTextfield, tooltip);
        defineSwitchElements("leftArrow", "rightArrow", "switchField");

        placeObject(Registry.columnObjects, Registry.column);
        createEventHandlers();
    }

    private function onRollOver():Void {
        super.onRollOver();
        Tweener.addTween(arrowRight, {_alpha: 100, time: 0.5 });
        Tweener.addTween(arrowLeft, {_alpha: 100, time: 0.5 });
        switchTextfield.textColor = 0x00A1DE;
        captionTextfield.textColor = 0x00A1DE;
    }

    private function onRollOut():Void {
        super.onRollOut();
        Tweener.addTween(arrowRight, {_alpha: 0, time: 0.5});
        Tweener.addTween(arrowLeft, {_alpha: 0, time: 0.5});
        switchTextfield.textColor = 0xFFFFFF;
        captionTextfield.textColor = 0xFFFFFF;
    }
}