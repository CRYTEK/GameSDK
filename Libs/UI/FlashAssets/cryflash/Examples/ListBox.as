import cryflash.CryObjects.Lists.CryListbox;
import cryflash.Registry;
import cryflash.Definitions;

/**
 * ...
 * @author RuneRask
 * refactoring/cleanup by ManuelB (April 10 2014)
 */
class cryflash.Examples.ListBox extends CryListbox {

    public function ListBox(id, caption) {
        super(id, "TempList", Registry.buttonContainer);
        initListbox();
        addTitle("caption", caption);
        tooltipTextfield = Registry.toolTipTextfield;
        placeObject(Registry.columnObjects, Registry.column);

        createEventHandlers();
    }
	
	public function onInputAction() {
		if(selectedItem != undefined) {
			selectedItem.onInputAction();
		}
	}
}