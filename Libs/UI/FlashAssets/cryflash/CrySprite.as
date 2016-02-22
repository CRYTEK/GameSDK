/**
 * ...
 * @author RuneRask
 * refactoring/cleanup by ManuelB (April 10 2014)
 **/

import cryflash.Events.CryDispatcher;
import cryflash.Events.CryEvent;

class cryflash.CrySprite extends cryflash.Events.CryDispatcher {
    public var id:String;
    private var movieClipRoot:MovieClip;
    private var movieClipParent:MovieClip;
    private var movieClipChild:MovieClip;
	private static var genericId:Number = 0;

    public function CrySprite(_id:String, parent:MovieClip) {
        super();
        if (parent == undefined) {
            trace("ERROR[CrySprite]: You must define a parent for a CrySprite.");
            return;
        }

		if (_id == undefined || _id == "" ) {
			id = "_generic" + genericId;
			genericId++;
		} else {
			id = _id;
		}
		
        movieClipParent = parent;
        movieClipRoot = parent.createEmptyMovieClip("CrySprite[" + id + "]", movieClipParent.getNextHighestDepth());
    }

    public function attachLibObject(name:String):Void {
        movieClipChild = movieClipRoot.attachMovie(name, "CrySprite[" + id + "]FIRSTBORN", movieClipRoot.getNextHighestDepth());
        mcWidth = movieClipChild._width;
        mcHeight = movieClipChild._height;
    }

    public function destroy():Void {
        removeAllEventListeners(CryEvent.ON_ACTION);
        removeAllEventListeners(CryEvent.ON_RELEASE);
        removeAllEventListeners(CryEvent.ON_ROLLOUT);
        removeAllEventListeners(CryEvent.ON_ROLLOVER);

        if (movieClipChild) {
            removeMovieClip(movieClipChild);
        }
        if (movieClipRoot) {
            removeMovieClip(movieClipRoot);
        }
        delete this;
    }

    public function set mcX(x:Number):Void {
        movieClipRoot._x = x;
    }

    public function get mcX():Number {
        return movieClipRoot._x;
    }

    public function set mcY(y:Number):Void {
        movieClipRoot._y = y;
    }

    public function get mcY():Number {
        return movieClipRoot._y;
		trace("return " + movieClipRoot._y);
    }

    public function set mcAlpha(alpha:Number):Void {
        movieClipRoot._alpha = alpha;
    }

    public function get mcAlpha():Number {
        return movieClipRoot._alpha;
    }

    public function set mcParent(parent:MovieClip):Void {
        movieClipParent = parent;
    }

    public function get mcParent():MovieClip {
		return movieClipParent;
    }

    public function set mcHeight(height:Number):Void {
        movieClipRoot._height = height;
    }

    public function get mcHeight():Number {
        return  movieClipRoot._height;
    }

    public function set mcWidth(width:Number):Void {
        movieClipRoot._width = width;
    }

    public function get mcWidth():Number {
        return movieClipRoot._width;
    }
}