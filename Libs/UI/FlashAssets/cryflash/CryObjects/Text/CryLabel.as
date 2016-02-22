import cryflash.CryObjects.CryBaseObject;

/**
 * ...
 * @author RuneRask
 * refactoring/cleanup by ManuelB (April 10 2014)
 */
class cryflash.CryObjects.Text.CryLabel extends cryflash.CryObjects.CryBaseObject {
    private var captionTextField:TextField;
    private var titleTextField:TextField;
    private var background:MovieClip;
    private var textLines:Array;
    private var caption:String;

    public function CryLabel(id:String, libObj:String, parent:MovieClip) {
        super(id, libObj, parent);
    }

    public function defineLabel(textField:String, caption:String, background:String):Void {
        captionTextField = movieClipChild[textField];
        titleTextField = movieClipChild[caption];
        background = movieClipChild[background];
    }

    private function setText(text:String):Void {
        textLines = text.split("<br>");
        captionTextField.text = "";

        for (var i:Number = 0; i < textLines.length; i++) {
            captionTextField.text += textLines[i] + newline;
        }

        captionTextField._height = captionTextField.textHeight;
        background._height = captionTextField._height + 10;
    }
}