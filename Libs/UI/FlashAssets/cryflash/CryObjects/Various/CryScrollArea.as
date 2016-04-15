/**
 * ...
 * @author Manuelb
 */

import cryflash.Delegates;
import cryflash.Events.CryEvent

class cryflash.CryObjects.Various.CryScrollArea
{
	public var contentHeight:Number;
	public var outerHeight:Number;
	private var innerContainer:MovieClip;
	private var scrollItems:Array;
	private var mouseListener:Object;
	private var scrollHeightRatio:Number = 0;
	private var oldY:Number;
	private var mouseDownScrollBar:Boolean;
    private var outerScrollbar:MovieClip;
	private var innerScrollbar:MovieClip;
    private var X_OFFSET:Number = -25;
	
	public function CryScrollArea(container:MovieClip, scrollItems:Array) 
	{
		var scrollBarMC = container.attachMovie("TempScrollbar", "scrollbar", container.getNextHighestDepth(), {_x: X_OFFSET, _y: 0} );
	
		this.innerContainer = container;
		this.scrollItems = scrollItems;
		
		outerHeight = container._height;
		innerScrollbar = scrollBarMC.innerScrollbar;
        outerScrollbar = scrollBarMC.outerScrollbar;
		
		innerScrollbar._visible = false;
		outerScrollbar._height = outerHeight;
		
		createEventHandlers();
		mouseDownScrollBar = false;
	}
	 
    private function createEventHandlers():Void {
		mouseListener = new Object();
		mouseListener.onMouseMove = Delegates.create(this, onMouseMove);
		Mouse.addListener(mouseListener); 
        outerScrollbar.onRelease = Delegates.create(this, onScrollAreaClick);
		innerScrollbar.onPress = Delegates.create(this, onScrollbarPress);
		innerScrollbar.onRelease = innerScrollbar.onReleaseOutside = Delegates.create(this, onScrollbarRelease);
    }

	private function onScrollbarPress():Void {
		mouseDownScrollBar = true;
		oldY = _ymouse;
	}
	
	private function onScrollbarRelease():Void {
		mouseDownScrollBar = false;
	}
	
	private function onMouseMove():Void {
		if (mouseDownScrollBar) {
			var scrollAmount = (_ymouse - oldY) * scrollHeightRatio;
			if (scrollAmount > 0) {
				scrollUp(Math.abs(scrollAmount));
			} else {
				scrollDown(Math.abs(scrollAmount));
			}
			oldY = _ymouse;
		}
	}
	
	private function onScrollAreaClick():Void {
		var mouseY = innerContainer._ymouse;
		if (mouseY < innerScrollbar._y) {
		    scrollDown((innerScrollbar._y - mouseY) * scrollHeightRatio);
        } else if (mouseY > (innerScrollbar._y + innerScrollbar._height)) {			
			scrollUp((mouseY - (innerScrollbar._y + innerScrollbar._height)) * scrollHeightRatio);
        }
	}
	
	public function updateScrollbar():Void {
		contentHeight = innerContainer._height;
	    scrollHeightRatio = contentHeight / outerScrollbar._height;
		
        if (!scrollHeightRatio || scrollHeightRatio <= 1) {
            innerScrollbar._visible = false;
        } else {
            innerScrollbar._visible = true;
            innerScrollbar._height = outerScrollbar._height / this.scrollHeightRatio;
        }
	}
	
	public function scrollDown(value):Void {
		if (scrollItems[0].mcY < 0) {
			if (scrollItems[0].mcY + value > 0) {
				value -= value + scrollItems[0].mcY; //since items[0].mcY is negative, this is actually a subtraction
			}
			for (var i = 0; i < scrollItems.length; i++) {
				scrollItems[i].mcY += value;
			}
			innerScrollbar._y = -scrollItems[0].mcY / scrollHeightRatio;	
		}
	}
	
	public function scrollUp(value):Void {	
		var bottomMostPos = 0;
		for (var i = 0; i < scrollItems.length; i++) {
			var itemBottom = scrollItems[i].mcY + scrollItems[i].mcHeight;
			if (itemBottom > bottomMostPos) {
				bottomMostPos = itemBottom;
			}
		}
		
		if (bottomMostPos > outerScrollbar._height) {
			if (bottomMostPos - value < outerScrollbar._height) {
				value -= outerScrollbar._height - (bottomMostPos - value);
			}
			for (var i = 0; i < scrollItems.length; i++) {
				scrollItems[i].mcY -= value;
			}
		    innerScrollbar._y = -scrollItems[0].mcY / scrollHeightRatio;	
		}
	}
}