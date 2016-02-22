import cryflash.CryObjects.Buttons.CryButton;
import cryflash.Events.CryEvent;

/**
 * ...
 * Edited on 12-06-2013. By Rune Rask
 * refactoring/cleanup by ManuelB (April 10 2014)
 */
class cryflash.CryObjects.Buttons.CrySwitch extends cryflash.CryObjects.Buttons.CryButton {
    private var arrowLeft:MovieClip;
    private var arrowRight:MovieClip;
    public var switchTextfield:TextField;
    private var currentIndex:Number;
    private var entries:Array;
    public var currentValue;

    public function CrySwitch(id:String, libobj:String, parent:MovieClip) {
        super(id, libobj, parent);
        currentIndex = 0;
        entries = new Array();
    }

    public function select():Void {
        onRollOver();
    }

    public function onInputLeft(sender:Object):Void {
        onLeft();
    }

    public function onInputRight(sender:Object):Void {
        onRight();
    }
	
    public function addSwitchOption(caption:String, value):Void {
        entries.push({caption: caption, value: value});
        updateSwitch();
    }

    public function clearSwitch():Void {
        while (entries.length > 0) {
            entries.splice(0, 1);
            if (switchTextfield) {
                switchTextfield.text = "";
            }
        }
    }

    public function switchToValue(value):Void {
        for (var i:Number = 0; i < entries.length; i++) {
            if (entries[i].value == value) {
                currentIndex = i;
                updateSwitch();
                dispatchEvent(new CryEvent(CryEvent.CHANGE, this));
                return;
            }
        }
    }

    public function getCurrentValue():String {
        if (entries[currentIndex] != undefined) {
            return entries[currentIndex].value;
        }
    }

    private function updateSwitch():Void {
        if (entries[currentIndex] != undefined) {
            switchTextfield.text = entries[currentIndex].caption;
        }
        else {
            switchTextfield.text = "";
        }
    }

    private function createEventHandlers():Void {
        super.createEventHandlers();
        hitbox.onRelease = cryflash.Delegates.create(this, onRight);

        arrowLeft.onRelease = cryflash.Delegates.create(this, onLeft);
        arrowRight.onRelease = cryflash.Delegates.create(this, onRight);

        arrowLeft.onRollOver = arrowRight.onRollOver = cryflash.Delegates.create(this, onRollOver);
        arrowLeft.onRollOut = arrowLeft.onReleaseOutside = arrowRight.onRollOut = arrowRight.onReleaseOutside = cryflash.Delegates.create(this, onRollOut);
    }

    public function suspendEvents():Void {
        super.suspendEvents();
        arrowRight.enabled = false;
        arrowLeft.enabled = false;
    }

    public function enableEvents():Void {
        super.enableEvents();
        arrowRight.enabled = true;
        arrowLeft.enabled = true;
    }

    private function onLeft():Void {
        currentIndex--;
        if (currentIndex < 0) {
            currentIndex = entries.length - 1;
        }
        updateSwitch();
        currentValue = entries[currentIndex].value;
        dispatchEvent(new CryEvent(CryEvent.CHANGE, this));
    }

    private function onRight():Void {
        currentIndex++;
        if (currentIndex > entries.length - 1) {
            currentIndex = 0;
        }
        updateSwitch();
        currentValue = entries[currentIndex]._value;
        dispatchEvent(new CryEvent(CryEvent.CHANGE, this));
    }

    public function defineSwitchElements(leftArrow:String, rightArrow:String, switchField:String):Void {
        arrowLeft = movieClipChild[leftArrow];
		arrowRight = movieClipChild[rightArrow];
        switchTextfield = movieClipChild[switchField];
    }
}