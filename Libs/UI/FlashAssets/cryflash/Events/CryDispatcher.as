/**
 * ...
 * @author RuneRask
 * refactoring/cleanup by ManuelB (April 10 2014)
 */

import gfx.events.EventDispatcher

class cryflash.Events.CryDispatcher {

    public function CryDispatcher() {
        EventDispatcher.initialize(this);
    }

    private function dispatchEvent(event:Object):Void {}
    public function addEventListener(event:String, scope:Object, callBack:String):Void {}
    public function removeEventListener(event:String, scope:Object, callBack:String):Void {}
    public function removeAllEventListeners(event:String):Void {}
}