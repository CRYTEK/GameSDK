import cryflash.Events.CryEvent;

/**
 * ...
 * @author RuneRask
 * refactoring/cleanup by ManuelB (April 10 2014)
 */
class cryflash.CryObjects.CryDialog extends cryflash.CryObjects.CryBaseObject {
    private var button1Caption:String;
    private var button2Caption:String;
    private var dialogCaption:String;
	private var tooltipTextfield:TextField;
    private var dialogTextfield:TextField;
    public var button1Textfield:TextField;
    public var button2Textfield:TextField;
    public var button1:MovieClip;
    public var button2:MovieClip;

    public function CryDialog(id:String, libobj:String, parent:MovieClip) {
        super(id, libobj, parent);
        mcX = (Stage.width / 2) - (movieClipChild._width / 2);
        mcY = (Stage.height / 2) - (movieClipChild._height / 2);
    }

    public function defineDialog(btn1:String, btn2:String, btn1textField:String, btn2textField:String, diaTextfield:String):Void {
        button1 = movieClipChild[btn1];
        button2 = movieClipChild[btn2];
        dialogTextfield = movieClipChild[diaTextfield];
        button1Textfield = movieClipChild[btn1textField];
        button2Textfield = movieClipChild[btn2textField];
    }

    public function defineContent(diaCaption:String, btn1Caption:String, btn2Caption:String):Void {
        dialogCaption = diaCaption;
		button1Caption = btn1Caption;
        button2Caption = btn2Caption;

        button1Textfield.text = button1Caption;
        button2Textfield.text = button2Caption;
        dialogTextfield.text = dialogCaption;
    }

    public function createEventHandlers():Void {
        button1.onRelease = cryflash.Delegates.create(this, onAccept);
        button2.onRelease = cryflash.Delegates.create(this, onDecline);
        button1.onRollOver = cryflash.Delegates.create(this, onRollOver1);
        button2.onRollOver = cryflash.Delegates.create(this, onRollOver2);
        button1.onRollOut = button1.onReleaseOutside = cryflash.Delegates.create(this, onRollOut1);
        button2.onRollOut = button2.onReleaseOutside = cryflash.Delegates.create(this, onRollOut2);
    }

    private function onRollOver1():Void {
        if (tooltipTextfield) {
            tooltipTextfield.text = button1Caption;
        }
    }

    private function onRollOver2():Void {
        if (tooltipTextfield) {
            tooltipTextfield.text = button2Caption;
        }
    }

    private function onRollOut1():Void {
        if (tooltipTextfield) {
            tooltipTextfield.text = "";
        }
    }

    private function onRollOut2():Void {
        if (tooltipTextfield) {
            tooltipTextfield.text = "";
        }
    }

    private function onAccept():Void {
        dispatchEvent(new CryEvent(CryEvent.ACCEPTED, this));
    }

    private function onDecline():Void {
        dispatchEvent(new CryEvent(CryEvent.DECLINED, this));
    }
}