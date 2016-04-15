import cryflash.CryObjects.Text.CryTextField;
import cryflash.Registry;
import cryflash.Definitions;

/**
 * ...
 * @author RuneRask
 * refactoring/cleanup by ManuelB (April 10 2014)
 */
class cryflash.Examples.TextField extends CryTextField {
    public function TextField(id:String, caption:String, tooltip:String, isSending:Boolean) {
        super(id, "TempInputField", Registry.buttonContainer);
        addInputTextfield("inputField");
        addHitbox("hitbox");
		addCaption(caption);
		addTooltip(cryflash.Registry.toolTipTextfield, tooltip);
        setIsSending(isSending);
        createEventHandlers();
        placeObject(Registry.columnObjects, Registry.column);
		inputFieldBorder.gotoAndStop(1);
    }
}