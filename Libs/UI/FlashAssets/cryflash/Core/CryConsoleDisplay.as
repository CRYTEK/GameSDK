/**
 * ...
 * @author RuneRask
 * refactoring/cleanup by ManuelB (April 10 2014)
 */
class cryflash.Core.CryConsoleDisplay {
    public var consoleTooltips:MovieClip;

    public var backAction:String;
    public var applyAction:String;
    public var actionAction:String;
    public var quitAction:String;
    public var resetAction:String;

    private var spot1Text:TextField;
    private var spot2Text:TextField;
    private var spot3Text:TextField;
    private var spot4Text:TextField;

    private var spot1Symbol:MovieClip;
    private var spot2Symbol:MovieClip;
    private var spot3Symbol:MovieClip;
    private var spot4Symbol:MovieClip;

    private var platform:String;

    private static var PC:String = "pc";
    private static var XBOX:String = "XBox";
    private static var PS4:String = "PS4";
	
	private var buttonMappings = {};
	
    /**
     * CryConsoleDisplay handles displaying button tooltips for consoles.
     */
    public function CryConsoleDisplay(consoleTT:MovieClip, platform:String) {
        consoleTooltips = consoleTT;
        this.platform = platform;

        backAction = "";
        applyAction = "";
        resetAction = "";
        quitAction = "";

        spot1Symbol = consoleTooltips.symbol1;
        spot2Symbol = consoleTooltips.symbol2;
        spot3Symbol = consoleTooltips.symbol3;
        spot4Symbol = consoleTooltips.symbol4;

        spot1Text = consoleTooltips.caption1;
        spot2Text = consoleTooltips.caption2;
        spot3Text = consoleTooltips.caption3;
        spot4Text = consoleTooltips.caption4;

        clear();
    }
	
	//id is the id of the object of which the buttonMapping should be shown
	public function showConsoleButton(id:String) {
		if (buttonMappings[id]) {
			buttonMappings[id].call(this);
		} else if (buttonMappings["apply"]) {
			buttonMappings["apply"].call(this);
		}
	}

    public function getPlatform():String {
        return this.platform;
    }

    public function clear():Void {
        spot1Text.text = "";
        spot2Text.text = "";
        spot3Text.text = "";
        spot4Text.text = "";
        spot1Symbol.gotoAndStop("NONE");
        spot2Symbol.gotoAndStop("NONE");
        spot3Symbol.gotoAndStop("NONE");
        spot4Symbol.gotoAndStop("NONE");
		
		buttonMappings = { };
    }

	public function addButtonMapping( id:String, fkt:Function ) {
		buttonMappings[id] = fkt;
	}
	
    public function addBackButton(caption:String, id:String):Void {
       	if (platform === XBOX) {
			spot3Symbol.gotoAndStop("XB_B");
			spot3Text.text = caption;
			backAction = id;
		} else if (platform === PS4) {
			spot3Symbol.gotoAndStop("PS_CIRCLE");
			spot3Text.text = caption;
			backAction = id;
		}
    }

    public function addResetButton(caption:String, id:String):Void {
       	if (platform === XBOX) {
			spot2Symbol.gotoAndStop("XB_X");
			spot2Text.text = caption;
			resetAction = id;
		} else if (platform === PS4) {
			spot2Symbol.gotoAndStop("PS_SQUARE");
			spot2Text.text = caption;
			resetAction = id;
		}
    }

    public function addApplyButton(caption:String, id:String):Void {
		addButtonMapping("apply", function() {
			if (platform === XBOX) {
				spot1Symbol.gotoAndStop("XB_A");
				spot1Text.text = caption;
				applyAction = id;
			} else if (platform === PS4) {
				spot1Symbol.gotoAndStop("PS_CROSS");
				spot1Text.text = caption;
				applyAction = id;
			}
		});
		if(spot1Text.text === "") {
			showConsoleButton();
		}
    }

    public function addQuitButton(caption:String, id:String):Void {
		if (platform === XBOX) {
			spot3Symbol.gotoAndStop("XB_B");
			spot3Text.text = caption;
			quitAction = id;
		}
		else if (platform === PS4) {
			spot3Symbol.gotoAndStop("PS_CIRCLE");
			spot3Text.text = caption;
			quitAction = id;
		}
    }

    public function addActionButton(caption:String, id:String):Void {
        addButtonMapping(id, function() {
			if (platform === XBOX) {
				spot1Symbol.gotoAndStop("XB_A");
				spot1Text.text = caption;
				actionAction = id;
			} else if (platform === PS4) {
				spot1Symbol.gotoAndStop("PS_CROSS");
				spot1Text.text = caption;
			}
		});
    }
}