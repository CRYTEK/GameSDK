/**
 * ...
 * @author manuelb
 */

import cryflash.CryObjects.CryBaseObject;
import cryflash.Events.CryEvent;
import caurina.transitions.*;
import cryflash.*;
 
class cryflash.CryObjects.Lists.CryUserStatsCell extends CryBaseObject {
	private var title:String;
	private var value:String;
	
	private var TEMPLATE_NAME:String = "TempUserStatsCell"; 
	private var AVAILABLE_COLORS = ["black", "red", "green", "blue"];
		
	public function CryUserStatsCell(id:String, title:String, value:String, container) {
		super(id, TEMPLATE_NAME , container);
		setTitle(title);
		setValue(value);
		
		movieClipChild['background'].gotoAndStop("black");
	}
	
	public function setBackgroundColor(color:String) {
		if(AVAILABLE_COLORS.toString().indexOf(color) !== -1) {
			movieClipChild['background'].gotoAndStop(color);
		} else {
			movieClipChild['background'].gotoAndStop("black");
		}
	}

    public function getValue():String {
        return this.value;
    }
	
    public function setValue(value: String):Void {
        this.value = value;
        movieClipChild["value"].text = value;        
    }

    public function getTitle():String {
        return this.title;
    }
	
    public function setTitle(title: String):Void {
        this.title = title;
        movieClipChild["title"].text = title;
    }
}