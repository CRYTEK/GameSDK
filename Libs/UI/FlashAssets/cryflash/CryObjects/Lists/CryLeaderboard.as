import cryflash.CryObjects.CryBaseObject;
import cryflash.CryObjects.Lists.CryLeaderboardCell;
import cryflash.CryObjects.Lists.CryLeaderboardColumnCaption;
import cryflash.CryObjects.Lists.CryListItem;
import cryflash.CryObjects.Various.CryScrollArea;
import cryflash.Events.CryEvent;
import cryflash.Delegates;
import cryflash.Registry;

/**
 * @author ManuelB
 */

class cryflash.CryObjects.Lists.CryLeaderboard extends cryflash.CryObjects.CryBaseObject {
	public var focusControl:Boolean = false;
	public var cells:Array;
	private var scrollable: Boolean;
	private var columnTitles:Array;
	private var scrollArea:CryScrollArea;
	private var currentRow:Number;
	private var lBContainer;
	private var columns:Number;
	private var linebreakIndex:Number;
	private var columnOffset:Number;
	private var captionTextField:TextField;
    private var mouseListener:Object;
	private var SCROLL_SPEED = 15;
	private var CELL_WIDTH = 160;
	private var CELL_HEIGHT = 32;
	private var COLUMN_OFFSET = 20;
    
	public function CryLeaderboard(id:String, parent:MovieClip) {
        super(id, "TempLeaderboard", parent);
		placeObject(Registry.columnObjects, Registry.column)
    }

	public function setIcon(index:Number, iconKeyframe:Number) {
		this.cells[index].movieClipChild['icon'].gotoAndStop(iconKeyframe);
	}
	
    public function initLeaderboard(columnTitles:String, linebreakIndex:Number, scrollable:Boolean):Void {
		this.columnTitles = columnTitles.split(",");
		
		this.lBContainer = movieClipChild["leaderboardHolder"];
		this.linebreakIndex = linebreakIndex;
		columns = this.columnTitles.length;
		
		cells = [];
		currentRow = 0;
		columnOffset = 0;
		this.scrollable = scrollable;
		
		if (scrollable) {
			scrollArea = new CryScrollArea(this.lBContainer, cells);
			createEventHandlers();
		}
    }
	
	public function addRow(data:String) {
		var dataArray = data.split("|");
		var yPos = (currentRow % linebreakIndex) * CELL_HEIGHT;
		
		if (currentRow !== 0 && currentRow % linebreakIndex === 0) {
			columnOffset += CELL_WIDTH * columns + COLUMN_OFFSET;
		}
		
		if (currentRow === 0 || currentRow % linebreakIndex === 0) {
			for (var i = 0; i < columns; i++) {
				var titleCaption = new CryLeaderboardColumnCaption(columnTitles[i] + "_" + (i + currentRow / linebreakIndex),
						columnTitles[i], movieClipChild["columnCaptionHolder"]);
				titleCaption.mcY = 0;
				titleCaption.mcX = i * CELL_WIDTH + columnOffset;
			}
			yPos = 0;
		}
		
		for (var i = 0; i < dataArray.length; i++) {
			var cell = new CryLeaderboardCell("LBCell_" + currentRow + "_" + i, dataArray[i], this.lBContainer);
			cell.mcX = i * CELL_WIDTH + columnOffset;	
			
			cell.mcY = yPos;
			cells.push(cell);
		}
		currentRow++;
		
		if (scrollable) {	
			scrollArea.updateScrollbar();
		}
	}
	
	public function clear() {
		for (var i = 0; i < cells.length; i++) {
			cells[i].destroy();
		}
		currentRow = 0;
		columnOffset = 0;
		cells = [];
	}

    public function addTitle(titleID:String, text:String):Void {
        captionTextField = movieClipChild[titleID];
        captionTextField.text = text;
    }
	
    public function onInputDown(nav):Void {
		if (scrollArea != undefined) {
			scrollArea.scrollDown(SCROLL_SPEED);
		}
    }

    public function onInputUp(nav):Void {
		if (scrollArea != undefined) {
			scrollArea.scrollUp(SCROLL_SPEED);
		}
    }
	
	public function select():Void {}
    
    private function createEventHandlers():Void {
		var mouseListener = new Object();
        mouseListener.onMouseWheel = Delegates.create(this, onWheel);
		Mouse.addListener(mouseListener);
	}

    private function onWheel(delta):Void {
		if (delta < 0)
			scrollArea.scrollUp(SCROLL_SPEED);
		else
			scrollArea.scrollDown(SCROLL_SPEED);
    }
}