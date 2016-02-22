import cryflash.CryObjects.Various.CryImage;
import cryflash.Events.CryEvent;

import flash.filters.GlowFilter;

import cryflash.Registry;
import cryflash.Definitions;

/**
 * ...
 * @author RuneRask
 * refactoring/cleanup by ManuelB (April 10 2014)
 */
class cryflash.Examples.Image extends CryImage {
    private var outline:GlowFilter;

    public function Image(id:String, path:String, imgWidth:Number, imgHeight:Number, imgX:Number, imgY:Number, visible) {
        super(id, "ImageHolder", _root.imageContainer);
        setImage(path, imgX, imgY, imgWidth, imgHeight, visible);
        outline = new GlowFilter(0x000000, 10, 12, 12, 150, 1, false, false);
        this.addEventListener(CryEvent.COMPLETE, this, "onComplete");
    }
	
    private function onComplete():Void {
        actImage.filters = [outline];
    }
}