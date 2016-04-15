import cryflash.CryObjects.CryBaseObject;
import cryflash.Events.CryEvent;

/**
 * ...
 * Edited    on        12-06-2013. By Rune Rask
 */
class cryflash.CryObjects.Various.CryImage extends cryflash.CryObjects.CryBaseObject {
    private var imageHolder:MovieClip;
    private var actImage:MovieClip;
    private var imgX:Number;
    private var imgY:Number;
    private var refWidth:Number;
    private var refHeight:Number;
    private var path:String;
    private var imgLoader:MovieClipLoader;
    private var imgListen:Object;
	private var visible = false;

    public function CryImage(id:String, libObj:String, parent:MovieClip) {
        super(id, libObj, parent)
        imgListen = new Object();
        imgListen.onLoadInit = cryflash.Delegates.create(this, loaded);
        imgLoader = new MovieClipLoader();
    }

    public function setImage(path:String, imgX:Number, imgY:Number, imgWidth:Number, imgHeight:Number, visible:Boolean):Void {
        this.imgX = imgX;
        this.imgY = imgY;
        this.visible = visible;
		this.path = path;
        refHeight = imgHeight;
        refWidth = imgWidth;
		
        imgLoader.addListener(imgListen);
        imgLoader.loadClip("img://" + path, movieClipRoot)
    }

    private function loaded(target:MovieClip):Void {
        actImage = target;
        actImage._x = imgX;
        actImage._y = imgY;
        actImage._width = refWidth;
        actImage._height = refHeight;
		actImage._alpha = this.visible? 100: 0;
		
        dispatchEvent(new CryEvent(CryEvent.COMPLETE, this));
    }

    public function hideImage():Void {
        actImage._alpha = 0;
		this.visible = false;
    }

    public function showImage():Void {
        actImage._alpha = 100;
		this.visible = true;
    }

    public function get isVisible():Boolean {
        return actImage._alpha == 100;
    }

}