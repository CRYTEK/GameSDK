import cryflash.Events.CryEvent;

/**
 * ...
 * @author ManuelB 
 */

class cryflash.CryObjects.CryLoadingDialog extends cryflash.CryObjects.CryBaseObject {
    private var dialogTextfield:TextField;
	
    public function CryLoadingDialog(id:String, libobj:String, parent:MovieClip) {
        super(id, libobj, parent);
        mcX = (Stage.width / 2) - (movieClipChild._width / 2);
        mcY = (Stage.height / 2) - (movieClipChild._height / 2);
    }

    public function defineDialog(diaTextfield:String):Void {
        dialogTextfield = movieClipChild[diaTextfield];
    }

    public function setCaption(caption:String):Void {
	    dialogTextfield.text = caption;
    }
}