/**
 * @author RuneRask
 * Added on 14-02-2013. By Rune Rask
 * Edited on 23-05-2013. By Rune Rask
 * refactoring/cleanup by ManuelB (April 10 2014)
 */

import cryflash.Core.CryConsoleDisplay;
import cryflash.Core.CryConsoleNav;
import cryflash.*;
import cryflash.CryObjects.Buttons.CryButton;
import cryflash.CryObjects.CryBaseObject;
import cryflash.CryObjects.Lists.CryLeaderboard;
import cryflash.CryObjects.Lists.UserStats;
import cryflash.Events.CryEvent;
import cryflash.CryObjects.Text.CryTextField;
import cryflash.CryObjects.Lists.CryListbox;
import cryflash.CryObjects.Lists.CryListItem;
import cryflash.CryObjects.Text.CryLabel;
import cryflash.CryObjects.Lists.CryUserStats;
import cryflash.CryObjects.Various.CryImage;
import cryflash.CryObjects.CryDialog;
import cryflash.Examples.ButtonDisabled;
import cryflash.Examples.LoadingDialog;
import cryflash.Examples.Dialog;
import cryflash.Examples.Image;
import cryflash.Examples.ItemSelect;
import cryflash.Examples.ListBox;
import cryflash.Examples.ApplyButton;
import cryflash.Examples.BackButton;
import cryflash.Examples.Button;
import cryflash.Examples.Label;
import cryflash.Examples.PlayerListItem;
import cryflash.Examples.ResetButton;
import cryflash.Examples.Seperator;
import cryflash.Examples.Slider;
import cryflash.Examples.Switch;
import cryflash.Examples.TextField;

import caurina.transitions.*;
import caurina.transitions.properties.DisplayShortcuts;
import flash.filters.GlowFilter;

import src.CryFlash.baseObjects.BaseObject;

class cryflash.Main {
    private var oldPageNameY:Number,
        consoleDisplay:CryConsoleDisplay,
        consoleNav:CryConsoleNav,
        loadingIndicator:MovieClip,
     
        eCIE_Up:Number = 0,
        eCIE_Down:Number = 1,
        eCIE_Left:Number = 2,
        eCIE_Right:Number = 3,
        eCIE_Action:Number = 4,
        eCIE_Back:Number = 5,
        eCIE_Start:Number = 6,
        eCIE_Select:Number = 7,
        eCIE_ShoulderL1:Number = 8,
        eCIE_ShoulderL2:Number = 9,
        eCIE_ShoulderR1:Number = 10,
        eCIE_ShoulderR2:Number = 11,
        eCIE_Button3:Number = 12,
        eCIE_Button4:Number = 13,
        PS4 = "PS4",
        XBOX = "XBox",
        PC = "pc",
        holder:MovieClip,
        hWidth:Number,
        hHeight:Number,
        imgListen:Object,
        imgLoader:MovieClipLoader,
        dialogActive:Boolean,
        langBar:LanguageBar;

    /**
     * CryInit (Inits the menu system).
     * @param platform: What system is are we initializing? (PC/Xbox/PS).
     */
    public function cryInit(platform):Void {
        Registry.defineCryReg();
        Registry.cleanObjects();
        loadingIndicator = _root.preloader;
        oldPageNameY = Registry.pageName._y;
        dialogActive = false;
        consoleDisplay = new CryConsoleDisplay(_root.staticElements.consoleTooltips, platform);
        consoleNav = new CryConsoleNav(consoleDisplay);
        Registry.platform = platform;
        langBar = null;
    }

    public function cleanScreen():Void {
        var i:Number;
		for (var key in Registry.columnObjects) {
			Registry.columnObjects[key].destroy();
		}
		for (var key in Registry.applyObjects) {
			Registry.applyObjects[key].destroy();
		}
		for (var key in Registry.resetObjects) {
			Registry.resetObjects[key].destroy();
		}
		for (var key in Registry.backObjects) {
			Registry.backObjects[key].destroy();
		}
		for (var key in Registry.dialogs) {
			Registry.dialogs[key].destroy();
		}
		for (var key in Registry.images) {
			var curImage:CryImage = Registry.images[key];
			if (curImage.isVisible == true) {
				hideImage(curImage.id);
			}
			curImage.destroy();
		}
		
        Registry.cleanObjects();
        Registry.toolTipTextfield.text = "";

        consoleDisplay.resetAction = "";
        consoleDisplay.applyAction = "";
        consoleDisplay.backAction = "";

        consoleDisplay.clear();
    }

	private function initLanguageBar()
	{
		if (langBar == null)
		{
			langBar = new LanguageBar(_root);
		}
	}

	private function destroyLanguageBar()
	{
		if (langBar != null)
		{
			langBar.destroy();
			langBar = null;
		}
	}

    private function onButton(e:CryEvent):Void {
        fscommand("onButton", e.target.id);
    }

    private function onDialogConfirm(e:CryEvent):Void {
        var args:Array = new Array();
        args.push(e.target.id);
        args.push(true);
        fscommand("onConfirm", args);
    }

    private function onDialogDecline(e:CryEvent):Void {
        var args:Array = new Array();
        args.push(e.target.id);
        args.push(false);
        fscommand("onConfirm", args);
    }

    private function onClose(e:CryEvent):Void {
        fscommand("onButton", e.target.id);
    }

    private function onChange(e:CryEvent):Void {
        var args:Array = new Array();
        args.push(e.target.id);
        args.push(e.target.getCurrentValue());
        fscommand("onControl", args);
    }

    private function onTextFieldChanged(e:CryEvent):Void {
        var args:Array = new Array();
        args.push(e.target.id);
        var text:Array = e.target.storedText.split(",");
        var correctedText:String = new String();

        for (var i:Number = 0; i < text.length; i++) {
            if (i == 0)
                correctedText = text[0] + ".";
            else
                correctedText += text[i] + ".";
        }
        args.push(correctedText);
        fscommand("textfieldChanged", args);
    }
	
	public function getListboxItemCaption(id:String):String {
		if (Registry.listboxes[id] != undefined) {
			return Registry.listboxes[id].getCurrentCaption();
		}
	
        return "-1";
	}
	
	public function getListboxItemValue(id:String):String {
		if (Registry.listboxes[id] != undefined) {
			return Registry.listboxes[id].getCurrentValue();
		}
	
        return "-1";
	}
	
    public function getControlVal(id:String):String {
		if (Registry.sliders[id] != undefined) {
			return Registry.sliders[id].getCurrentValue();
		} 
		else if (Registry.switches[id] != undefined) {
			return Registry.switches[id].getCurrentValue();
		}
		else if (Registry.listboxes[id] != undefined) {
			return Registry.listboxes[id].getCurrentValue();
		}
	
        return "-1";
    }

    public function setControlVal(id, value):Void {
		if (Registry.sliders[id] != undefined) {
			Registry.sliders[id].setValue(value);
		} 
		else if (Registry.switches[id] != undefined) {
			Registry.switches[id].switchToValue(value);
		}
    }

    public function addButton(caption:String, tooltip:String, consoleButtonCaption: String, id:String):Void {
        var newButton:Button = new Button(id, caption, tooltip);

        newButton.addEventListener(CryEvent.ON_RELEASE, this, "onButton");
        newButton.addEventListener(CryEvent.CLOSE, this, "onClose");

        if (consoleDisplay.getPlatform() == "XBox" || consoleDisplay.getPlatform() == "PS4") {
            consoleDisplay.addActionButton(consoleButtonCaption, id);
        }
        consoleNav.reset();
    }
	
	public function addDisabledButton(caption:String, tooltip:String, id:String):Void {
        var newButton:ButtonDisabled = new ButtonDisabled(id, caption, tooltip);
        consoleNav.reset();
    }

    public function removeButton(id:String):Void {
		if (Registry.columnObjects[id] != undefined) {
			Registry.columnObjects[id].destroy();
			delete Registry.columnObjects[id];			
		}
    }

    public function addSeparator(id:String):Void {
        var newSeparator = new Seperator(id);
        consoleNav.reset();
    }
	
    public function addTextField(caption:String, tooltip:String, consoleButtonCaption:String, isSending:Boolean, id:String):Void {
        var newTextField = new TextField(id, caption, tooltip, isSending);
        newTextField.addEventListener(CryEvent.CHANGE, this, "onTextFieldChanged");
		if (consoleDisplay.getPlatform() == "XBox" || consoleDisplay.getPlatform() == "PS4") {
            consoleDisplay.addActionButton(consoleButtonCaption, id);
        }
        Registry.textFields[id] = newTextField;
        initLanguageBar();
    }
	
    public function setTextFieldText(id, value):Void {        
		if (Registry.textFields[id] != undefined) {
			Registry.textFields[id].setText(value);
		}
    }

    public function getTextFieldText(id):String {
        if (Registry.textFields[id] != undefined) {
			return Registry.textFields[id].getText();
		}
    }

    public function addSwitch(caption:String, tooltip:String, Val, id:String):Void {
        var newSwitch = new Switch(id, caption, tooltip);
        newSwitch.addEventListener(CryEvent.CHANGE, this, "onChange");

        Registry.switches[id] = newSwitch;
        consoleNav.reset();
    }

    public function addSwitchOption(id:String, caption:String, value:String):Void {
		if (Registry.switches[id] != undefined) {
			Registry.switches[id].addSwitchOption(caption, value);
		}
    }

    public function addSwitchOptionsFromString(id:String, options:String, delimiter:String):Void {
        var edOptions:Array = options.split(delimiter);
        if (edOptions.length > 0) {
            for (var i:Number = 0; i < edOptions.length; i++) {
                addSwitchOption(id, edOptions[i], edOptions[i]);
            }
        }
    }

    public function clearSwitchOptions(id):Void {
		if (Registry.switches[id]) {
			Registry.switches[id].clearSwitch();
		}
    }

    public function addSlider(caption:String, tooltip:String, min, max, step, val, id:String):Void {
        var newSlider:Slider = new Slider(id, min, max, val, caption, tooltip);
        Registry.sliders[id] = newSlider;
        consoleNav.reset();
    }

    public function addListbox(id:String, caption:String, tooltip:String):Void {
        var newList:ListBox = new ListBox(id, caption);
        Registry.listboxes[id] = newList;
        newList.addEventListener(CryEvent.CHANGE, this, "onChange");
        consoleNav.reset();
    }

    public function addListboxItem(id:String, caption:String, value:String):Void {
		var listBox = Registry.listboxes[id];
		if (listBox != undefined) {
			var newItem = new CryListItem(id, value, "TempListboxItem", listBox);

			newItem.addCaption(caption);
			newItem.createEventHandlers();
	//		newItem.addTooltip(Registry.tooltipTextfield, caption);
			listBox.addItem(newItem);
		}
    }
	
	public function removeListboxItem(id:String, index:String) {
		var listBox:CryListbox = Registry.listboxes[id];
		if (listBox != undefined) {
			listBox.removeItem(parseInt(index));
		}
	}
	
    public function clearListbox(id:String):Void {
		if (Registry.listboxes[id] != undefined) {
			Registry.listboxes[id].clearList();
		}
    }
	
	function setPlayerMuted(id:String, index:String, muted:Boolean) {
		var listBox:CryListbox = Registry.listboxes[id];
		if (listBox != undefined) {
			var listboxItem = listBox.items[index];
			if (listboxItem != undefined && listboxItem.hasOwnProperty("muted")) {
				listboxItem.setMute(muted);
			}
		}
	}

	public function addPlayerListboxItem(id:String, caption:String, value:String, muted: Boolean):Void {
		var listBox = Registry.listboxes[id];
		if (listBox != undefined) {
			var newItem = new PlayerListItem(id, value, listBox, muted);

			newItem.addCaption(caption);
			newItem.createEventHandlers();
			listBox.addItem(newItem);
			newItem.mcX = 0;
		}
    }
	
	public function addLeaderboard(columnTitles:String, linebreakIndex:Number, scrollable:Boolean) {
		if (Registry.leaderboard !== undefined) {
			Registry.leaderboard.destroy();
		}
		Registry.leaderboard = new CryLeaderboard("leaderboard", Registry.buttonContainer);
		Registry.leaderboard.initLeaderboard(columnTitles, linebreakIndex, scrollable);
	}
	
	public function appendLeaderboardRow(data:String) {
		if (Registry.leaderboard == undefined) {
			return;
		}
		
		Registry.leaderboard.addRow(data);
	}
	
	public function clearLeaderboard() {
		if (Registry.leaderboard == undefined) {
			return;
		}
		
		Registry.leaderboard.clear();
	}
	
	public function setLeaderboardItemIcon(index, iconKeyframe) {
		Registry.leaderboard.setIcon(index, iconKeyframe);
	}

	public function addUserStats(linebreakIndex:Number, scrollable:Boolean) {
		if (Registry.userStats !== undefined) {
			Registry.userStats.destroy();
		}
		
		Registry.userStats = new CryUserStats("userStats", Registry.buttonContainer);
		Registry.userStats.initUserStats(linebreakIndex, scrollable);
	}
	
	public function appendUserStatsCell(title:String, value:String) {
		if (Registry.userStats === undefined) {
			return;
		}
		
		Registry.userStats.addCell(title, value);
	}
	
	public function clearUserStats() {
		if (Registry.userStats == undefined) {
			return;
		}
		
		Registry.userStats.clear();
	}
	
	public function setUserStatsItemColor(index, color) {
		Registry.userStats.setCellColor(index, color);
	}

    public function addScreenText(id:String, caption:String, tooltip:String):Void {
        var newLabel:Label = new Label(id, caption);
        consoleNav.reset();
        moveOverlay();  
    }

    public function addBackButton(id:String):Void {
        if (consoleDisplay.getPlatform() == "XBox" || consoleDisplay.getPlatform() == "PS4") {
            consoleDisplay.addBackButton("Back", id);
        } else {
            var newBackButton:BackButton = new BackButton(id, "BACK", "BACK");
            newBackButton.addEventListener(CryEvent.ON_RELEASE, this, "onButton");
        }
        consoleDisplay.backAction = id;
    }

    public function addApplyButton(caption:String, tooltip:String, id:String):Void {
        if (consoleDisplay.getPlatform() == "XBox" || consoleDisplay.getPlatform() == "PS4") {
            consoleDisplay.addApplyButton(caption, id);
        }
        else {
            var newApplyButton:ApplyButton = new ApplyButton(id, caption, tooltip);
            newApplyButton.addEventListener(CryEvent.ON_RELEASE, this, "onButton");
        }
        consoleDisplay.applyAction = id;
    }

    public function addDefaultButton(caption:String, tooltip:String, id:String):Void {
        if (consoleDisplay.getPlatform() == "XBox" || consoleDisplay.getPlatform() == "PS4") {
            consoleDisplay.addResetButton(caption, id);
        }
        else {
            var newDefaultButton = new ResetButton(id, caption, tooltip);
            newDefaultButton.addEventListener(CryEvent.ON_RELEASE, this, "onButton");
        }
        consoleDisplay.resetAction = id;
    }

    public function addQuitButton(caption:String, tooltip:String, id:String):Void {
        if (consoleDisplay.getPlatform() == "XBox" || consoleDisplay.getPlatform() == "PS4") {
            consoleDisplay.addQuitButton(caption, id);
        }
        else {
            var newBackButton:BackButton = new BackButton(id, caption, tooltip);
            newBackButton.addEventListener(CryEvent.ON_RELEASE, this, "onButton");
        }
        consoleDisplay.backAction = id;
    }

    public function addImage(path:String, id:String, xPos:Number, yPos:Number, width:Number, height:Number, visible:Boolean):Void {
        var exists:Boolean = false;

		if (Registry.images[id] != undefined) {
			return;
		}
	
        var image = new Image(id, path, width, height, xPos, yPos, visible);
        Registry.images[id] = image;
    }

    public function showImage(id):Void {
		if(Registry.images[id] != undefined) {
			Registry.images[id].showImage();
		}
    }

    public function hideImage(id):Void {
		if(Registry.images[id] != undefined) {
			Registry.images[id].hideImage();
		}
    }

    public function hideConfirmDiag():Void {
        for(var key in Registry.dialogs) {
			Registry.dialogs[key].removeAllEventListeners(CryEvent.ON_RELEASE);
			Registry.dialogs[key].removeAllEventListeners(CryEvent.ON_ROLLOUT);
			Registry.dialogs[key].removeAllEventListeners(CryEvent.ON_ROLLOVER);
			Registry.dialogs[key].destroy();
		}

		for (var key in Registry.columnObjects) {
			Registry.columnObjects[key].enableEvents();
		}

        Tweener.addTween(cryflash.Registry.buttonContainer, {_alpha: 100, _z: -100, time: 1 });
        Tweener.addTween(cryflash.Registry.staticElements, {_alpha: 100, _z: -100, time: 1 });
        Tweener.addTween(_root.overlay, { _alpha: 75, _z: -100, time: 1 });

        dialogActive = false;
    }

    public function showConfirmDiag(msg:String, btn1:String, btn2:String, id:String):Void {
        if (!dialogActive) {
			var newDiag:Dialog = new Dialog(id, msg, btn1, btn2);
			
			newDiag.addEventListener(CryEvent.ACCEPTED, this, "onDialogConfirm");
			newDiag.addEventListener(CryEvent.DECLINED, this, "onDialogDecline");
			if (Registry.platform == XBOX) {
				newDiag.xBoxTooltip._alpha = 100;
			}
			else if (Registry.platform == PS4) {
				newDiag.psTooltip._alpha = 100;
			}

			Tweener.addTween(cryflash.Registry.buttonContainer, { _alpha: 0, _z: 3000, time: 1 });
			Tweener.addTween(cryflash.Registry.staticElements, { _alpha: 0, _z: 2600, time: 1 });
			Tweener.addTween(_root.overlay, { _alpha: 0, _z: 2600, time: 1 });

			dialogActive = true;
			Registry.dialogs[id] = newDiag;
			for (var key in Registry.columnObjects) {
				Registry.columnObjects[key].suspendEvents();
			}
		}
    }
	
	public function displayLoadingDialog(caption:String):Void {
		if (Registry.dialogs["__loading"] !== undefined) {
			Registry.dialogs["__loading"].destroy();
		}
		Registry.dialogs["__loading"] = new LoadingDialog(caption);
		for (var key in Registry.columnObjects) {
			Registry.columnObjects[key].suspendEvents();
		}
	}
	
	public function removeLoadingDialog():Void {
		for (var key in Registry.columnObjects) {
			Registry.columnObjects[key].enableEvents();
		}
		Registry.dialogs["__loading"].destroy();
	}
	
    public function addItemSelect(id:String, caption:String, tooltip:String):Void {
        Registry.itemSelects[id] = new ItemSelect(id, caption, tooltip);
    }

    public function addSelectItem(id:String, caption:String, _Value:String):Void {        
		if (Registry.itemSelects[id] != undefined) {
			Registry.itemSelects[id].addSwitchOption(caption, _Value);
		}
    }

    public function showLoader():Void {
        _root.loadingScreen._alpha = 100;
        _root.loadingScreen.gotoAndPlay(1);
    }

    public function hideLoader():Void {
        _root.loadingScreen._alpha = 0;
    }

    public function hideBG():Void {
        _root.bg_image._alpha = 0;
    }

    public function showBG():Void {
        _root.bg_image._alpha = 100;
    }

    public function showlogo():Void {
        Tweener.addTween(Registry.staticElements.inLogoLogo, { _alpha: 100, time: 1 });
        Registry.pageName._alpha = 0;
        Tweener.addTween(_root.overlay, { _x: ( -Stage.width / 2), time: 1 } );
    }

    public function hidelogo():Void {
        Tweener.addTween(Registry.staticElements.inLogoLogo, { _alpha: 0, time: 1 });
        Registry.pageName._alpha = 100;
        Tweener.addTween(_root.overlay, { _x: ( -Stage.width * 0.20), time: 1 } );
    }

    public function cry_onSetup(platform:Number):Void {
        switch (platform) {
            case 0:
                cryInit(PC);
                break;
            case 1:
                cryInit(XBOX);
                break;
            case 2:
                cryInit(PS4);
                break;
        }
    }

    public function setVersion(ver:String):Void {
        Registry.staticElements.version.text = ver;
    }

    public function setupScreen(_ScreenName:String):Void {
        cleanScreen();
        destroyLanguageBar();
        var pnFormat:TextFormat = new TextFormat();
        pnFormat.letterSpacing = 10;

        Registry.pageName.text = _ScreenName;
        Registry.pageName._y = Registry.pageName._y - 50;
        Registry.pageName._alpha = 0;
        Registry.buttonContainer._alpha = 0;
        Registry.pageName.setNewTextFormat(pnFormat);
        Registry.pageName.text = _ScreenName;
        moveOverlay();
    }

    private function moveOverlay():Void {
        Tweener.addTween(Registry.pageName, { _y: oldPageNameY, _alpha: 100, time: 0.5});
        Tweener.addTween(Registry.buttonContainer, {_alpha: 100, time: 0.5 });
    }
	
    public function setLevelLoadingImage(imagePath:String):Void {
        imagePath = "img://" + imagePath;

        var container = _root.loadingScreen.imageContainer;
		container._alpha = 0;
		var width = container._width;
		var height = container._height;
		
        imgLoader = new MovieClipLoader();
        imgListen = new Object();
		
        imgListen.onLoadInit = cryflash.Delegates.create(this, function() {
			 container._alpha = 100;
			 container._width = width;
			 container._height = height;
		});

        imgLoader.addListener(imgListen);
        imgLoader.loadClip(imagePath, container);
    }

	
	public function cry_onVirtualKeyboard(success:Boolean, input:String) {
		var currentTextfield = Registry.currentTextfield;
		if (currentTextfield != null && success) {
			currentTextfield.setText(input);
			currentTextfield.dispatchEvent(new CryEvent(CryEvent.CHANGE, currentTextfield));
		}
	}

    public function cry_onController(iButton:Number, buttonReleased:Boolean) {
        if (buttonReleased) {
            return;
        }

        if (langBar != null && langBar.isCandidateListOpen()) // Don't take focus away from the candidate list, ever
            return;

        switch (iButton) {
            case eCIE_Up:
                consoleNav.navigate("up");
                break;
            case eCIE_Down:
                consoleNav.navigate("down");
                break;
            case eCIE_Left:
                consoleNav.navigate("left");
                break;
            case eCIE_Right:
                consoleNav.navigate("right");
                break;
            case eCIE_Action:
				if (dialogActive) {
					for (var key in Registry.dialogs) {
						fscommand("onConfirm", [Registry.dialogs[key].id, true]);
					}
				}
                else {
                    consoleNav.navigate("action");
                }
                break;
            case eCIE_Back:
                if (dialogActive) {
					for (var key in Registry.dialogs) {
						fscommand("onConfirm", [Registry.dialogs[key].id, false]);
					}
                }
                else {
                    fscommand("onButton", consoleDisplay.backAction);
                }
                break;
            case eCIE_Button3:
                consoleNav.navigate("apply");
                break;
            case eCIE_Button4:
                consoleNav.navigate("reset");
                break;
        }
    }
}