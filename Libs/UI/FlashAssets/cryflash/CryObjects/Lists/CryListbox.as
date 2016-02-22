import caurina.transitions.properties.CurveModifiers;
import cryflash.CryObjects.CryBaseObject;
import cryflash.CryObjects.Lists.CryLeaderboard;
import cryflash.CryObjects.Lists.CryListItem;
import cryflash.CryObjects.Various.CryScrollArea;
import cryflash.Events.CryEvent;
import cryflash.Delegates;

/**
 * ...
 * @author RuneRask
 * refactoring/cleanup by ManuelB (April 10 2014)
 */
class cryflash.CryObjects.Lists.CryListbox extends cryflash.CryObjects.CryBaseObject {
    public var selectedItem:CryListItem;
	public var focusControl = false;
	public var items:Array;
	public var scrollArea: CryScrollArea;
	public var listContainer:MovieClip;
	private var currentIndex:Number;
    private var captionTextField:TextField;
    private var tooltipTextfield:TextField;
    private var fademask:MovieClip;
	
    public function CryListbox(id:String, libobj:String, parent:MovieClip) {
        super(id, libobj, parent);
		
        currentIndex = 0;
        items = [];
    }
	
	 private function createEventHandlers():Void {
		var mouseListener = new Object();
        mouseListener.onMouseWheel = Delegates.create(this, onWheel);
		Mouse.addListener(mouseListener);
	}

    public function initListbox():Void {
        fademask = movieClipChild["fadeMask"];
        listContainer = movieClipChild["listHolder"];
        listContainer.cacheAsBitmap = true;
        fademask.cacheAsBitmap = true;
        listContainer.setMask(fademask);
		scrollArea = new CryScrollArea(listContainer, items);
		scrollArea.updateScrollbar();
        createEventHandlers();
    }

    public function getCurrentValue():String {
        if (selectedItem != undefined) {
            return selectedItem.getValue();
        }
    }
	
	public function getCurrentCaption():String {
		if (selectedItem != undefined) {
            return selectedItem.getCaption();
        }
	}
	
    public function addTitle(titleID:String, text:String):Void {
        captionTextField = movieClipChild[titleID];
        captionTextField.text = text;
    }
  
    public function onInputDown(nav):Void {
        selectNextItem();
    }

    public function onInputUp(nav):Void {
        selectPreviousItem();
    }
	
	public function onInputLeft(nav):Void {
		if (items.length > 0) {
			items[currentIndex].onInputLeft(nav);
		}
	}
	
	public function onInputRight(nav):Void {
		if (items.length > 0) {
			items[currentIndex].onInputRight(nav);
		}
	}

    public function clearList():Void {
		for (var i = 0; i < items.length; i++) {
			items[i].destroy();
		}
		items.splice(0, items.length);
    }
	
	public function select():Void {}
   
    private function onItemSelect(e:CryEvent):Void {
		if(selectedItem != undefined) {
			selectedItem.deselect();
		}
        selectedItem = e.target;
        dispatchEvent(new CryEvent(CryEvent.ON_RELEASE, e.target));
		dispatchEvent(new CryEvent(CryEvent.CHANGE, this));
    }

    private function selectPreviousItem():Void {
		if(items.length > 0) {
			focusControl = true;
			if (currentIndex <= 0) {
				focusControl = false;
			} else {
				currentIndex--;
			}
			items[currentIndex].select();
			selectedItem = items[currentIndex];
			if (selectedItem.mcY < 0) {
				scrollArea.scrollDown(Math.abs(selectedItem.mcY));
			}
			dispatchEvent(new CryEvent(CryEvent.CHANGE, this));
		}
    }

    private function selectNextItem():Void {
		if(items.length > 0) {
			focusControl = true;
			if(currentIndex >= items.length-1) {        
				focusControl = false;
			} else {
				currentIndex++;
			}
			items[currentIndex].select();
			selectedItem = items[currentIndex];
			
			var selectedItemOverflow = selectedItem.mcY + selectedItem.mcHeight - scrollArea.outerHeight;
			
			if (selectedItemOverflow > 0) {
				scrollArea.scrollUp(selectedItemOverflow);
			}
			dispatchEvent(new CryEvent(CryEvent.CHANGE, this));
		}
    }

    public function addItem(newItem: CryListItem):Void {
        if (items.length > 0)
            newItem.mcY = (items[items.length - 1].mcY + items[items.length - 1].mcHeight);
        else
            newItem.mcY = 0;

        newItem.addEventListener(CryEvent.ON_RELEASE, this, "onItemSelect");
		newItem.index = items.length;
		items.push(newItem);
		
		if (items.length == 1) {
			items[0].select();
		}
		
		scrollArea.updateScrollbar();
    }

	public function removeItem(index:Number) {
		if (items[index] != undefined) {
			if (currentIndex > index) {
				currentIndex -= 1;
			}
			
			items[index].destroy();
			items.splice(index, 1);
			for (var i:Number = index; i < items.length; i++) {
				items[i].mcY -= items[i].mcHeight;
			}
		}
		
		items[currentIndex].select();
		selectedItem = items[currentIndex];
		scrollArea.updateScrollbar();
	}
	
    private function onWheel(delta):Void {
        if (delta < 0)
            selectNextItem();
        else
			selectPreviousItem();
    }
}