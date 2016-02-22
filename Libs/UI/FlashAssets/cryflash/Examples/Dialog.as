import cryflash.CryObjects.CryDialog;
import cryflash.Registry;
import cryflash.Definitions;
import cryflash.Delegates;

import caurina.transitions.Tweener;

/**
 * ...
 * @author RuneRask
 * refactoring/cleanup by ManuelB (April 10 2014)
 */
class cryflash.Examples.Dialog extends CryDialog {
    private var btn1Highlight:MovieClip;
    private var btn2Highlight:MovieClip;
    public var psTooltip:MovieClip;
    public var xBoxTooltip:MovieClip;

    public function Dialog(id:String, dialogCaption:String, button1Caption:String, button2Caption:String) {
        super(id, "TempDialog", Registry.dialogHolder);

        defineDialog("button1", "button2", "button1Caption", "button2Caption", "dialogCaption");
        defineContent(dialogCaption, button1Caption, button2Caption);
        tooltipTextfield = Registry.toolTipTextfield;

        btn1Highlight = movieClipChild["button1Highlight"];
        btn2Highlight = movieClipChild["button2Highlight"];
        psTooltip = movieClipChild["playstationTooltip"];
        xBoxTooltip = movieClipChild["xboxTooltip"];
        createEventHandlers();
    }

    private function onRollOver1():Void {
        super.onRollOver1();
        button1Textfield.textColor = 0xFFFFFF;
        Tweener.addTween(btn1Highlight, {_alpha: 100, time: 1});
    }

    private function onRollOver2():Void {
        super.onRollOver2();
        button2Textfield.textColor = 0xFFFFFF;
        Tweener.addTween(btn2Highlight, {_alpha: 100, time: 1});
    }

    private function onRollOut1():Void {
        super.onRollOut1();
        button1Textfield.textColor = 0x000000;
        Tweener.addTween(btn1Highlight, {_alpha: 0, time: 1});
    }

    private function onRollOut2():Void {
        super.onRollOut2();
        button2Textfield.textColor = 0x000000;
        Tweener.addTween(btn2Highlight, {_alpha: 0, time: 1});
    }
}