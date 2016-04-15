import cryflash.CryObjects.Buttons.CryButton;

import caurina.transitions.*

import cryflash.Registry;
import cryflash.Delegates;

/**
 * ...
 * @author RuneRask
 */
class cryflash.Examples.BackButton extends CryButton {
    private var highlight:MovieClip;
    private var spFormat:TextFormat;

    public function BackButton(id:String, caption:String, tooltip:String) {
        super(id, "TempBackButton", Registry.staticElements);
        addCaption("caption", caption);
        addHitbox("hitbox");
        placeObject(cryflash.Registry.backObjects, Registry.backGuide);
        highlight = movieClipChild["highlight"];

        createEventHandlers();

        spFormat = new TextFormat();
        spFormat.letterSpacing = 5;

        movieClipChild.onEnterFrame = Delegates.create(this, onEnter);
    }

    public function onRollOver() {
        super.onRollOver();
        captionTextfield.textColor = 0x00A1DE;
        captionTextfield.setNewTextFormat(spFormat);
    }

    public function onRollOut() {
        super.onRollOut();
        captionTextfield.textColor = 0xFFFFFF;
        captionTextfield.setNewTextFormat(spFormat);
    }

    private function onEnter():Void {
        captionTextfield.setNewTextFormat(spFormat);
        delete movieClipChild.onEnterFrame;
    }
}