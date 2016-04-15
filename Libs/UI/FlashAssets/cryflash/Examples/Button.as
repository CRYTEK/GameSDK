import cryflash.CryObjects.Buttons.CryButton;

import caurina.transitions.*;

import cryflash.Registry;
import cryflash.Delegates;

/**
 * ...
 * @author RuneRask
 * refactoring/cleanup by ManuelB (April 10 2014)
 */

class cryflash.Examples.Button extends cryflash.CryObjects.Buttons.CryButton {
    public function Button(id:String, caption:String, tooltip:String) {
        super(id, "TempButton", cryflash.Registry.buttonContainer);
		overrideActionNav = true;
        
		addHitbox("hitbox");
        addTooltip(cryflash.Registry.toolTipTextfield, tooltip);
        addCaption("caption", caption);
        placeObject(Registry.columnObjects, Registry.column);
        createEventHandlers();
    }

    private function onRollOver():Void {
        super.onRollOver();
        captionTextfield.textColor = 0x00aef0;
    }

    private function onRollOut():Void {
        super.onRollOut();
        captionTextfield.textColor = 0xCCCCCC;
    }
}