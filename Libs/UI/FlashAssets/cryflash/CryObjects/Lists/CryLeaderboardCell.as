/**
 * ...
 * @author manuelb
 */

import cryflash.CryObjects.CryBaseObject;
import cryflash.Events.CryEvent;
import caurina.transitions.*;
import cryflash.*;
 
class cryflash.CryObjects.Lists.CryLeaderboardCell extends CryBaseObject {
	private var text:String;
	private var TEMPLATE_NAME:String = "TempLeaderboardCell"; 
	
	public function CryLeaderboardCell(id:String, text, container) {
		super(id, TEMPLATE_NAME , container);
		setCaption(text);
		if(movieClipChild['icon']) {
			movieClipChild['icon'].gotoAndStop(1);
		}
	}

    public function getCaption():String {
        return this.text;
    }
	
    public function setCaption(text: String):Void {
        this.text = text;
        movieClipChild["caption"].text = text;        
    }
}