import cryflash.Core.CryConsoleDisplay;
import cryflash.CryObjects.CryBaseObject;
import cryflash.Registry;
import cryflash.Delegates;

/**
 * ...
 * @author RuneRask
 * refactoring/cleanup by ManuelB (April 10 2014)
 */

class cryflash.Core.CryConsoleNav {
    private var curObj:CryBaseObject;
    private var currentIndex:Number;
    private var columnObjects:Array;
    private var display:CryConsoleDisplay;
    private var mouseDelegate:Object;

    private var MAXHEIGHT = 500;

    function CryConsoleNav(display:CryConsoleDisplay) {
        currentIndex = 0;
        this.display = display;
    }

    public function navigate(input:String):Void {
        if (columnObjects.length > 0) {
            switch (input) {
			case "left":
				if(!curObj.suspended) {
					curObj.onInputLeft(this);
				}
				break;
			case "right":
				if(!curObj.suspended) {
					curObj.onInputRight(this);
				}
				break;
			case "up":
				if (curObj != undefined && !curObj.suspended) {
					if(!columnObjects[currentIndex].focusControl)
						currentIndex = currentIndex < 1 ? columnObjects.length - 1 : currentIndex - 1;
					columnObjects[currentIndex].onInputUp(this);
					curObj.deselect();
					curObj = columnObjects[currentIndex];
					this.display.showConsoleButton(curObj.id);
					curObj.select();
				}
				break;
			case "down":
				if (curObj != undefined && !curObj.suspended) {
					if(!columnObjects[currentIndex].focusControl)
						currentIndex = currentIndex < columnObjects.length - 1 ? currentIndex + 1 : 0;
					columnObjects[currentIndex].onInputDown(this);
					curObj.deselect();	
					curObj = columnObjects[currentIndex];
					this.display.showConsoleButton(curObj.id);
					curObj.select();
				}
				break;
			case "action":
				if (curObj.overrideActionNav == true && !curObj.suspended) {
					curObj.onInputAction(this);
				} else {
					fscommand("onButton", display.applyAction);
				}
				break;
			case "back":
				fscommand("onButton", display.backAction);
				break;
			case "apply":
				fscommand("onButton", display.applyAction);
				break;
			case "reset":
				fscommand("onButton", display.resetAction);
				break;
            }
        }
    }

    public function reset():Void {
		columnObjects = [];
		for (var key in Registry.columnObjects) {
			var columnObject = Registry.columnObjects[key];
			if (columnObject.selectable) {
				columnObjects[columnObject.orderPosition] = columnObject;
			}
		}
		
		if(columnObjects.length > 0) {
			currentIndex = 0;
			curObj = columnObjects[0];
			curObj.select();
			this.display.showConsoleButton(curObj.id);
		} else {
			curObj = undefined;
		}
    }
}