import cryflash.CryObjects.CryBaseObject;
import cryflash.Registry;

/**
 * @author RuneRask
 * refactoring/cleanup by ManuelB (April 10 2014)
 */

class cryflash.Examples.Seperator extends cryflash.CryObjects.CryBaseObject {
	public function Seperator(id:String) {
		super(id, "TempSeperator", cryflash.Registry.buttonContainer);
        selectable = false;
		placeObject(Registry.columnObjects, Registry.column);
    }
}