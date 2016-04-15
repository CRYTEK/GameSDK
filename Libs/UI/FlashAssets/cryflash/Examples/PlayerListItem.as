import cryflash.CryObjects.Lists.CryListItem;
import cryflash.CryObjects.Lists.CryListbox;
import cryflash.Delegates;
import caurina.transitions.*;

class cryflash.Examples.PlayerListItem extends CryListItem
{	
	var muteButton:MovieClip;
	var iconMuted:MovieClip;
	var iconUnmuted:MovieClip;
	var muted = false;
	var muteButtonSelected = false;
	
	public function PlayerListItem(id:String, value, parentList:CryListbox, muted:Boolean) {
		super(id, value, "TempPlayerListboxItem", parentList);
		
		this.muted = muted;
		muteButton = movieClipChild["muteButton"];
		iconMuted = muteButton.iconMuted;
		iconUnmuted = muteButton.iconUnmuted;
	}
	
	public function createEventHandlers() {
		super.createEventHandlers();
		muteButton.highlight.onRelease = Delegates.create(this, function() {setMute(!muted);});
		muteButton.highlight.onRollOver = Delegates.create(this, highlightMuteButton);
		muteButton.highlight.onRollOut = Delegates.create(this, unHighlightMuteButton);
	}
	
	public function setMute(mute:Boolean) {
		muted = mute;
		if (muted) {
			iconMuted._alpha = 100;
			iconUnmuted._alpha = 0;
		} else {
			iconMuted._alpha = 0;
			iconUnmuted._alpha = 100;
		}
		fscommand("playerMuteChanged", [id, index, muted]);
	}
	
	public function onInputLeft(nav):Void {
		selectMuteButton();
	}
	
	public function onInputRight(nav):Void {
		selectMuteButton();
	}
	
	public function onInputAction() {
		if (muteButtonSelected) {
			setMute(!muted);
		}
	}
	
	public function selectMuteButton() {
		muteButtonSelected = !muteButtonSelected;
		if (muteButtonSelected) {
			parentList.overrideActionNav = true;
			super.onRollOut();
			highlightMuteButton();
		} else {
			parentList.overrideActionNav = false;
			super.onRollOver();
			unHighlightMuteButton();
		}
	}
	
	private function highlightMuteButton() {
		Tweener.addTween(muteButton.highlight, {_alpha: 100, time: 1});
	}
	
	private function unHighlightMuteButton() {
		Tweener.addTween(muteButton.highlight, {_alpha: 0, time: 1});
	}
}
