import cryflash.Delegates;
import cryflash.Events.CryEvent;

/**
 * Edited on 12-06-2013. By Rune Rask
 * refactoring/cleanup by ManuelB (April 10 2014)
 */
class cryflash.CryObjects.Buttons.CrySlider extends cryflash.CryObjects.Buttons.CryButton {
    private var leftArrow:MovieClip;
    private var rightArrow:MovieClip;
    public var percentBar:MovieClip;
    public var percentHit:MovieClip;
    public var sliderValue:TextField;
    private var min:Number;
    private var max:Number;
    public var value:Number;

    public function CrySlider(id:String, min:Number, max:Number, libobj:String, parent:MovieClip) {
        super(id, libobj, parent);
        this.min = min;
        this.max = max;
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

    public function getCurrentValue():String {
        return String(value);
    } 

    public function setValue(val:Number):Void {
        if (val < min)
            val = min;
        if (val > max)
            val = max;

        value = val;
        percentBar._xscale = (value / max) * 100;
        sliderValue.text = String(value);

        dispatchEvent(new CryEvent(CryEvent.CHANGE, this));
    }

    public function addSliderObjectReferences(leftArrow:String, rightArrow:String, sliderValue:String, sliderBar:String, sliderHitbox:String):Void {
        this.leftArrow = movieClipChild[leftArrow];
        this.rightArrow = movieClipChild[rightArrow];
        this.percentBar = movieClipChild[sliderBar];
        this.percentHit = movieClipChild[sliderHitbox];
        this.sliderValue = movieClipChild[sliderValue];
    }

    public function suspendEvents():Void {
        super.suspendEvents();
        rightArrow.enabled = false;
        leftArrow.enabled = false;
        percentHit.enabled = false;
    }

    public function enableEvents():Void {
        super.enableEvents();
        rightArrow.enabled = true;
        leftArrow.enabled = true;
        percentHit.enabled = true;
    }
	
	private function createEventHandlers():Void {
        super.createEventHandlers();
        percentHit.onRelease = cryflash.Delegates.create(this, onBarRelease);
        leftArrow.onRelease = cryflash.Delegates.create(this, onLeft);
        rightArrow.onRelease = cryflash.Delegates.create(this, onRight);

        percentHit.onRollOver = cryflash.Delegates.create(this, onRollOver);
        leftArrow.onRollOver = cryflash.Delegates.create(this, onRollOver);
        rightArrow.onRollOver = cryflash.Delegates.create(this, onRollOver);
        percentHit.onRollOut = percentHit.onReleaseOutside = cryflash.Delegates.create(this, onRollOut);
        leftArrow.onRollOut = leftArrow.onReleaseOutside = cryflash.Delegates.create(this, onRollOut);
        rightArrow.onRollOut = rightArrow.onReleaseOutside = cryflash.Delegates.create(this, onRollOut);
    }
	
    private function onLeft():Void {
        setValue(value -= (max / 20));
    }

    private function onRight():Void {
        setValue(value += (max / 20));
    }

    private function onBarRelease():Void {
        var mouseHit:Number;
        var hitPercent:Number;

        mouseHit = percentHit._width - percentHit._xmouse;
        hitPercent = 100 - (Math.round((mouseHit / percentHit._width) * 100));
        var dealtNumber:Number = max * (hitPercent / 100);

        setValue(dealtNumber);
    }
}