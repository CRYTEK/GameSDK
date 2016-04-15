import cryflash.CryObjects.Buttons.CryButton;
import cryflash.CryObjects.CryBaseObject;
import cryflash.CryObjects.Lists.CryListbox;
import cryflash.Events.CryEvent;

import caurina.transitions.*;
import cryflash.*;

/**
 * @author RuneRask
 * refactoring/cleanup by ManuelB (April 10 2014)
 */

class cryflash.CryObjects.Lists.CryListItem extends cryflash.CryObjects.Buttons.CryButton {
	public var index;
	private var parentList:CryListbox;
	private var highlight: MovieClip;
	private var value;
	
    public function CryListItem(id:String, value, libobj:String, parentList:CryListbox) {
		super(id || parentList.items.length + 1, libobj, parentList.listContainer);
		
		this.value = value;
		this.parentList = parentList;
        movieClipChild.cacheAsBitmap = true; 
		this.highlight = movieClipChild["highlight"];
    }

    public function createEventHandlers():Void {
        super.createEventHandlers();
        highlight.onRollOver = cryflash.Delegates.create(this, onRollOver);
        highlight.onRollOut = cryflash.Delegates.create(this, onRollOut);
        highlight.onRelease = highlight.onReleaseOutside = cryflash.Delegates.create(this, onRelease);
    }

    private function onRelease():Void {
        super.onRelease();
        select();
    }

    public function select():Void {
        dispatchEvent(new CryEvent(CryEvent.ON_RELEASE, this));
        Tweener.addTween(highlight, {_alpha: 100 });
    }

    public function deselect():Void {
        Tweener.addTween(highlight, {_alpha: 0 });
    }

    private function onRollOver():Void {
        super.onRollOver();
        if (parentList.selectedItem == this) {
            return;
        } else {
            Tweener.addTween(highlight, { _alpha: 50 });
        }
    }

    private function onRollOut():Void {
        super.onRollOut();
        if (parentList.selectedItem == this) {
            return;
        } else {
            Tweener.addTween(highlight, {_alpha: 0 });
        }
    }

    public function getCaption():String {
        return captionTextfield.text;
    }
	
	public function getValue():String {
		return value;
	}

    public function addCaption(capt: String):Void {
        caption = capt;
        captionTextfield = movieClipChild["caption"];
        captionTextfield.text = capt;
    }

    public function setCaption(capt:String):Void {
        captionTextfield.text = capt;
    }
}