/**
 * ...
 * @author RuneRask
 * refactoring/cleanup by ManuelB (April 10 2014)
 */
import cryflash.CryObjects.CryBaseObject;
import caurina.transitions.*;
import cryflash.Events.CryEvent;

class cryflash.CryObjects.Buttons.CryButton extends cryflash.CryObjects.CryBaseObject {
    private var caption:String;
    private var tooltip:String;
    private var tooltipTextfield:TextField;
    private var captionTextfield:TextField;

    public function CryButton(id:String, libObj:String, parent:MovieClip) {
        super(id, libObj, parent);
    }

    public function onInputAction():Void {
        dispatchEvent(new CryEvent(CryEvent.ON_RELEASE, this));
    }

    public function onRollOver():Void {
        super.onRollOver();
        if (tooltipTextfield != undefined) {
            tooltipTextfield.text = tooltip;
        }
    }

    public function onRollOut():Void {
        super.onRollOut();
        if (tooltipTextfield != undefined) {
            tooltipTextfield.text = "";
        }
    }

    public function addCaption(mcID:String, text:String):Void {
        captionTextfield = movieClipChild[mcID];
        caption = text;
        captionTextfield.text = caption;
    }

    public function addTooltip(mcID:TextField, text:String):Void {
        tooltipTextfield = mcID;
        tooltip = text;
    }
}