import cryflash.CryObjects.CryLoadingDialog;
import cryflash.Registry;
import cryflash.Definitions;
import cryflash.Delegates;

import caurina.transitions.Tweener;

/**
 * ...
 * @author ManuelB
 */

class cryflash.Examples.LoadingDialog extends CryLoadingDialog {
    public function LoadingDialog(caption:String) {
        super("loadingDialog", "TempLoadingDialog", Registry.dialogHolder);

		defineDialog("caption");
        setCaption(caption);		
    }
}