/**
 * ...
 * @author RuneRask
 * refactoring/cleanup by ManuelB (April 10 2014)
 **/

import cryflash.baseObjects.CrySprite;
import cryflash.Delegates;
import cryflash.Events.CryDispatcher;
import cryflash.Events.CryEvent

class cryflash.CryObjects.CryBaseObject extends cryflash.CrySprite {
    private var hitbox:MovieClip;
    private var isColumPlace:Boolean;
    public var selectable:Boolean;
    public var overrideActionNav:Boolean;
	public var orderPosition;
	public var focusControl:Boolean = false;
	private var ITEMSEPERATION = 10;
	
	public var suspended = false;
	
    public function CryBaseObject(id:String, libobj:String, parent:MovieClip) {
        super(id, parent);
        overrideActionNav = false;
        selectable = true;
        attachLibObject(libobj);
    }

    public function addHitbox(movieClipId:String) {
        hitbox = movieClipChild[movieClipId];
        createEventHandlers();
    }

    public function createEventHandlers():Void {
        if (hitbox != undefined) {
            hitbox.onRollOver = Delegates.create(this, onRollOver);
            hitbox.onRollOut = hitbox.onReleaseOutside = Delegates.create(this, onRollOut);
            hitbox.onRelease = Delegates.create(this, onRelease);
        }
    }

    public function suspendEvents():Void {
		this.suspended = true;
        movieClipChild.enabled = false;
        hitbox.enabled = false;
        movieClipRoot.enabled = false;
    }

    public function enableEvents():Void {
        this.suspended = false;
		movieClipChild.enabled = true;
        hitbox.enabled = true;
        movieClipRoot.enabled = true;
    }

    private function placeObject(objects:Object, guide:MovieClip):Void {
		var numberSelectableObjects = 0;
		var lastObjectPos = 0;
		
		for (var key in objects) {
			if (objects[key].selectable) {
				numberSelectableObjects++;
			}
			if (objects[key].mcY + objects[key].mcHeight > lastObjectPos) {
				lastObjectPos = objects[key].mcY + objects[key].mcHeight;
			}
		}
		if (selectable) {
			orderPosition = numberSelectableObjects;
		}
		
		mcX = guide._x;
        mcY = lastObjectPos > 0? lastObjectPos + ITEMSEPERATION: guide._y;
        objects[id] = this;
    }

    public function select():Void {
        onRollOver();
    }

    public function deselect():Void {
        onRollOut();
    }

    private function onRollOver():Void {
        dispatchEvent(new CryEvent(CryEvent.ON_ROLLOVER, this));
    }

    private function onRollOut():Void {
        dispatchEvent(new CryEvent(CryEvent.ON_ROLLOUT, this));
    }

    private function onRelease():Void {
        dispatchEvent(new CryEvent(CryEvent.ON_RELEASE, this));
    }

    private function onAction():Void {
        dispatchEvent(new CryEvent(CryEvent.ON_ACTION, this));
    }

    public function onInputAction(sender:Object):Void {
    }

    public function onInputBack(sender:Object):Void {
        dispatchEvent(new CryEvent(CryEvent.CLOSE, this));
    }

    public function onInputUp(sender:Object):Void {
    }

    public function onInputDown(sender:Object):Void {
    }

    public function onInputLeft(sender:Object):Void {
    }

    public function onInputRight(sender:Object):Void {
    }
}