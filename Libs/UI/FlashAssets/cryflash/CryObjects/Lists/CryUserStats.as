import cryflash.CryObjects.CryBaseObject;
import cryflash.CryObjects.Lists.CryUserStatsCell;
import cryflash.CryObjects.Various.CryScrollArea;
import cryflash.Events.CryEvent;
import cryflash.Delegates;
import cryflash.Registry;

/**
 * @author ManuelB
 */

class cryflash.CryObjects.Lists.CryUserStats extends cryflash.CryObjects.CryBaseObject {
	public var focusControl:Boolean = false;
	private var scrollable: Boolean;
	public  var cells:Array;
	private var scrollArea:CryScrollArea;
	private var currentRow:Number;
	private var currentCell:Number;
	private var uSContainer;
	private var linebreakIndex:Number;
	private var captionTextField:TextField;
    private var mouseListener:Object;
	private var TEMPLATE_NAME = "TempUserStats";
	private var SCROLL_SPEED = 15;
	private var CELL_WIDTH = 160;
	private var CELL_HEIGHT = 90;
	
	public function CryUserStats(id:String, parent:MovieClip) {
        super(id, TEMPLATE_NAME, parent);
		placeObject(Registry.columnObjects, Registry.column)
    }

	public function setCellColor(index:Number, color:String) {
		this.cells[index].setBackgroundColor(color);
	}
	
    public function initUserStats(linebreakIndex:Number, scrollable:Boolean):Void {
		this.uSContainer = movieClipChild["userStatsHolder"];
		this.linebreakIndex = linebreakIndex;
		
		cells = [];
		currentRow = 0;
		currentCell = 0;
		this.scrollable = scrollable;
		
		if (scrollable) {
			scrollArea = new CryScrollArea(this.uSContainer, cells);
			createEventHandlers();
		}
    }
	
	public function addCell(title, value) {
		var cell = new CryUserStatsCell("uSCell_" + currentCell, title, value, this.uSContainer);
		
		cell.mcX = (currentCell % linebreakIndex) * CELL_WIDTH;
		cell.mcY = currentRow * CELL_HEIGHT;
		cells.push(cell);
	
		currentCell++;
		if (currentCell % linebreakIndex == 0) {
			currentRow++;
		}
		
		if (scrollable) {	
			scrollArea.updateScrollbar();
		}
	}
	
	public function addRow(data:String) {
		var dataArray = data.split("|");
		
	}
	
	public function clear() {
		for (var i = 0; i < cells.length; i++) {
			cells[i].destroy();
		}
		currentRow = 0;
		currentCell = 0;
		cells = [];
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