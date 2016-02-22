import cryflash.CryObjects.Lists.CryLeaderboard;
import cryflash.CryObjects.Text.CryLabel;
import cryflash.CryObjects.Text.CryTextField;
/**
 * @author RuneRask
 * refactoring/cleanup by ManuelB (April 10 2014)
 */

class cryflash.Registry {
    public static var buttonContainer:MovieClip,
        dialogHolder:MovieClip,
        staticElements:MovieClip,
        column:MovieClip,
        applyGuide:MovieClip,
        resetGuide:MovieClip,
        backGuide:MovieClip,
        actionGuide:MovieClip,
		dialogs:Object,
        images:Object,
        switches:Object,
        sliders:Object,
        listboxes:Object,
        textFields:Object,
        itemSelects:Object,
        columnObjects:Object,
        backObjects:Object,
        applyObjects:Object,
        resetObjects:Object,
		toolTipTextfield:TextField,
        pageName:TextField,
        platform:String,
		userStats:Object,
		currentTextfield:CryTextField,
		leaderboard:CryLeaderboard;

    public static function defineCryReg():Void {
        column = _root.menuRoot.menuContainer;
        backGuide = _root.staticElements.backButton;
        applyGuide = _root.staticElements.applyButton;
        resetGuide = _root.staticElements.resetButton;
        pageName = _root.staticElements.menuTitleText;
        toolTipTextfield = _root.staticElements.tooltipText;
        dialogHolder = _root.dialogs;
        buttonContainer = _root.menuRoot;
        staticElements = _root.staticElements;
    }

    public static function cleanObjects():Void {
        dialogs = { };
        listboxes = { };
        switches = { };
        sliders = { };
        images = { };
        columnObjects = { };
        backObjects = { };
        resetObjects = { };
        applyObjects = { };
        textFields = { };
        itemSelects = { };
    }
}