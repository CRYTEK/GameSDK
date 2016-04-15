import cryflash.CryObjects.Buttons.CryButton;

import caurina.transitions.*

import cryflash.Registry;
import cryflash.Definitions;
import cryflash.Delegates;

/**
 * ...
 * @author RuneRask
 * refactoring/cleanup by ManuelB (April 10 2014)
 */
class cryflash.Examples.ResetButton extends CryButton {
    private var highlight:MovieClip;
    private var spFormat:TextFormat;

    public function ResetButton(id:String, caption:String, tooltip:String) {
        super(id, "TempResetButton", Registry.staticElements);
        addCaption("caption", caption);
        addTooltip(Registry.toolTipTextfield, tooltip);
        addHitbox("hitbox");
        placeObject(Registry.resetObjects, Registry.resetGuide);
        highlight = movieClipChild["highlight"];
        createEventHandlers();

        spFormat = new TextFormat();
        spFormat.letterSpacing = 4;

        movieClipChild.onEnterFrame = Delegates.create(this, onEnter);
    }

    public function onRollOver() {
        super.onRollOver();
        Tweener.addTween(highlight, {_alpha: 100, time: 1});
        captionTextfield.setNewTextFormat(spFormat);
    }

    public function onRollOut() {
        super.onRollOut();
        Tweener.addTween(highlight, {_alpha: 0, time: 1});
        captionTextfield.setNewTextFormat(spFormat);
    }

    private function onEnter():Void {
        captionTextfield.setNewTextFormat(spFormat);
        delete movieClipChild.onEnterFrame;
    }
}