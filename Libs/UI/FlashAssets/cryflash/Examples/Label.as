import cryflash.CryObjects.Text.CryLabel;
import cryflash.Registry;
import cryflash.Definitions;

/**
 * ...
 * @author RuneRask
 * refactoring/cleanup by ManuelB (April 10 2014)
 */
class cryflash.Examples.Label extends CryLabel {
    public function Label(id:String, text:String) {
        super(id, "TempTextField", Registry.buttonContainer);
        defineLabel("textField", "caption", "background");
		setText(text);
        placeObject(Registry.columnObjects, Registry.column);
    }
}