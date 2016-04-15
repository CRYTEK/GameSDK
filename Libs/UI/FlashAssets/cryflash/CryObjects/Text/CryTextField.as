import cryflash.CryObjects.CryBaseObject;
import cryflash.Registry;
import cryflash.Events.CryEvent;

/**
 * ...
 * @author RuneRask
 * refactoring/cleanup by ManuelB (April 10 2014)
 */
class cryflash.CryObjects.Text.CryTextField extends CryBaseObject {
    private var inputField:TextField;
    private var enterBtn:MovieClip;
    public var storedText:String;
    private var listener:Object;
    private var isSending:Boolean;
	private var inputFieldBorder:MovieClip;
	private var captionTextField:TextField;
	private var tooltip:String;
	private var tooltipTextfield:TextField;
	private var caption:String;
	
    public function CryTextField(id:String, libobj:String, parent:MovieClip) {
        super(id, libobj, parent);
        listener = new Object();
        storedText = new String();
		overrideActionNav = true;
    }

    public function createEventHandlers():Void {
		hitbox.onRollOver = cryflash.Delegates.create(this, onRollOver);
		hitbox.onRollOut = cryflash.Delegates.create(this, onRollOut);
		inputField.onKillFocus = cryflash.Delegates.create(this, onRollOut);
		inputField.onChanged = cryflash.Delegates.create(this, onText);
        listener.onKeyDown = cryflash.Delegates.create(this, onKeyDown);
        inputField.onSetFocus = cryflash.Delegates.create(this, setFocus);
    }
	
	public function addTooltip(ttTextfield:TextField, text:String):Void {
        tooltipTextfield = ttTextfield;
        tooltip = text;
    }
	
	public function addCaption(capt: String):Void {
        caption = capt;
		captionTextField = movieClipChild["caption"];
        captionTextField.text = capt;
    }
	
    public function onInputAction():Void {
		var args:Array = new Array();
		Registry.currentTextfield = this;
        args.push("Default");
		args.push("Title");
        args.push(inputField.text);
        args.push(30);
        fscommand("cry_virtualKeyboard", args);		
    }

	private function onRollOver():Void {
		super.onRollOver();	
		if (tooltipTextfield != undefined) {
            tooltipTextfield.text = tooltip;
        }
		captionTextField.textColor = 0x00aef0;
		inputFieldBorder.gotoAndStop(2);
    }

    private function onRollOut():Void {
		super.onRollOut();
		if (tooltipTextfield != undefined) {
            tooltipTextfield.text = "";
        }
		captionTextField.textColor = 0xFFFFFF;
		inputFieldBorder.gotoAndStop(1);
    }
	
    private function onText():Void {
        storedText = inputField.text;
    }

    private function onKeyDown() {
        if (Key.isDown(Key.ENTER)) {
            storedText = inputField.text;
            if (isSending) {
                inputField.text = "";
            }
            dispatchEvent(new CryEvent(CryEvent.CHANGE, this));
        }
        storedText = inputField.text;
    }

    public function setText(value):Void {
        inputField.text = String(value);
        storedText = String(value);
    }

    public function getText():String {
        return storedText;
    }

    private function setFocus():Void {
		onRollOver();
        Key.addListener(listener);
    }
	
    /**
     * Defines whether or not the textfield is meant to send it's information or just store it.
     * For example a chat box input field would send it's text (so whatever is entered dissapears when clicking enter).
     * whereas a field for inputting name, would just hold the information for display and retrieval from other systems.
     *
     * @param    value Set to true if the object is sending.
     */
    public function setIsSending(value:Boolean):Void {
        isSending = value;
    }

    public function addInputTextfield(txtID:String):Void {
        inputField = movieClipChild[txtID];
		inputFieldBorder = movieClipChild["inputBorder"];		
        createEventHandlers();
    }
}