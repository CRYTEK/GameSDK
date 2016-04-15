import cryflash.CryObjects.Buttons.CryButton;

import caurina.transitions.*;

import cryflash.Registry;
import cryflash.Delegates;

/**
 * ...
 * @author RuneRask
 * refactoring/cleanup by ManuelB (April 10 2014)
 */

class cryflash.Examples.ButtonDisabled extends cryflash.CryObjects.Buttons.CryButton {
    public function ButtonDisabled(id:String, caption:String, tooltip:String) {
        super(id, "TempButton", cryflash.Registry.buttonContainer);
		selectable = false;
		
		addHitbox("hitbox");
        addTooltip(cryflash.Registry.toolTipTextfield, tooltip);
        addCaption("caption", caption);
		
		captionTextfield.textColor = 0x555555;
     
		placeObject(Registry.columnObjects, Registry.column);
        createEventHandlers();
		
    }

    private function onRollOver():Void {
		super.onRollOver();
	};
	private function onInputAction():Void {};
    private function onRollOut():Void {
		super.onRollOut();
	};
}