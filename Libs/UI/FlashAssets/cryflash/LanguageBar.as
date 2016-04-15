// This is the helper that creates the language bar when applicable
// Note: Most of the AS and assets are copies of the ones from the Scaleform GFx IME plugin (slightly modified to not spam trace() and use the HUD_2D font)
// The following information is from the Scaleform documentation, and documents the GFx exposed interfaces (this is no replacement for reading the IME docs from Scaleform)
// With this information it's possible to implement your own LangBar.gfx and StatusWindow.gfx (or understand/edit the Scaleform ones, if you have the source files for that)

// add/remove a listener object
// System.IME.addListener(listener : Object) : Void
// System.IME.removeListener(listener : Object) : Boolean
// listener is an object with members:
// onIMEComposition : function(readingString : String) : Void
// onSwitchLanguage : function(languageString : String) : Void (this is the generic name)
// onSetCurrentInputLanguage : function(languageString : String) : Void (this is the platform specific name)
// onSetSupportedLanguages : function(languageNames : String) : Void
// onSetIMEName : function(imeName : String) : Void
// onSetSupportedIMEs : function(imeNames : String) : Void
// onRemoveStatusWindow : function() : Void
// onDisplayStatusWindow : function() : Void
// onSetConversionMode : function(conversionMode : String) : Void (contains 3 comma-separated values for "InputMode=(Native|AlphaNumeric), ShapeMode=(Half|Full), SymbolMode=(Half|Full)"

// interact with manager
// Note: these events are queued by Scaleform and the events fire in a subsequent execution context
// _global.imecommand("LangBar_OnInit", 0) -> onSetCurrentLanguage and onSetIMEName events will fire
// _global.imecommand("LangBar_GetInstalledLanguages", 0) -> onSetSupportedLanguages event will fire
// _global.imecommand("LangBar_OnSelectInputLang", inputLangName : String) -> change language, will fire onSetCurrentInputLanguage
// _global.imecommand("LangBar_GetIMENames", inputLangName : String) -> fire onSetSupportedIMEs for the specified language
// _global.imecommand("LangBar_OnSelectIME", imeName : String) -> change IME, will fire onSetIMEName
// _global.imecommand("StatusWindow_OnInit", 0) -> onSetConversionMode and onDisplayStatusWindow events will fire
// _global.imecommand("StatusWindow_OnInputMode", isNative : Boolean) -> change input mode, argument is the CURRENT state, not the desired state, fires onSetConversionMode when successful
// _global.imecommand("StatusWindow_OnShapeMode", isFull : Boolean) -> change shape mode, argument is the CURRENT state, not the desired state, fires onSetConversionMode when successful
// _global.imecommand("StatusWindow_OnSymbolMode", isFull : Boolean) -> change symbol mode, argument is the CURRENT state, not the desired state, fires onSetConversionMode when successful
// _global.imecommand("CandidateList_OnItemSelect", index : Number)
// _global.imecommand("CandidateList_OnSetItemDataMap", itemDataNames : String)

// get/set enabled flag
// System.IME.setEnabled(enabled : Boolean) : Boolean
// System.IME.getEnabled() : Boolean
// Note: The behavior of this function is platform and IME specific, probably best not to use it

// get/set the conversion mode
// System.IME.setConversionMode(mode : String) : Boolean
// System.IME.getConversionMode() : String
// mode is one of "ALPHANUMERIC_FULL", "ALPHANUMERIC_FALSE", "CHINESE", "JAPANESE_HIRAGANA", "JAPANESE_KATAKANA_FULL", "JAPANESE_KATAKANA_HALF", "KOREAN" or "UNKNOWN"

// get/set composition string style on a text field
// TextField::setIMECompositionStringStyle(categoryName : String, styleDescriptor : Object) : Number
// TextField::getIMECompositionStringStyle(categoryName : String) : Object
// categoryName is one of "compositionSegment", "clauseSegment", "convertedSegment", "phraseLengthAdj" or "lowConfSegment"
// styleDescriptor is an object with members:
// textColor : Number, 0xRRGGBB
// backgroundColor : Number, 0xRRGGBB
// underlineColor : Number, 0xRRGGBB
// underlineStyle : String, one of "single", "thick", "dotted", "ditheredSingle", "ditheredThick"

// get/set candidate list style globally
// _global.setIMECandidateListStyle(styleDescriptor : Object) : Void
// _global.getIMECandidateListStyle() : Object
// styleDescriptor is an object with members:
// textColor : Number, 0xRRGGBB, default 0x5EADFF
// selectedTextColor : Number, 0xRRGGBB, default 0xFFFFFF
// fontSize : Number, default 20
// backgroundColor : Number, 0xRRGGBB, default 0x001430
// selectedTextBackgroundColor : Number, 0xRRGGBB, default 0x2C5A99
// readingWindowTextColor : Number, 0xRRGGBB, default 0xFFFFFF
// readingWindowBackgroundColor : Number, 0xRRGGBB, default 0x001430
// readingWindowFontSize : Number, default 20

class cryflash.LanguageBar
{
	// state
	private var context : MovieClip = null;
	private var languageBarContainer : MovieClip = null;
	private var statusWindowContainer : MovieClip = null;
	private var languageBarFile : String = "LangBar.gfx";
	private var statusWindowFile : String = "StatusWindow.gfx";
	private var imeListener : Object = null;
	private var languageBarX : Number = 0;
	private var languageBarY : Number = 0;
	private var unfocusedAlpha : Number = 70;
	private var isTextfieldFocused : Boolean = false;
	
	// initListener() -> initialize the listener object
	private function initListener()
	{
		this.imeListener = new Object();
		
		this.imeListener.onIMEComposition = function(readingString : String)
		{
			trace("IME EVENT: onImeComposition: " + readingString);
		}
		
		this.imeListener.onSwitchLanguage = function(languageName : String)
		{
			trace("IME EVENT: onSwitchLanguage: " + languageName);
		}
		
		this.imeListener.onSetCurrentInputLanguage = function(languageName : String)
		{
			trace("IME EVENT: onSetCurrentInputLanguage: " + languageName);
		}
		
		this.imeListener.onSetSupportedLanguages = function(languages : String)
		{
			trace("IME EVENT: onSetSupportedLanguages: " + languages);
		}
		
		this.imeListener.onSetIMEName = function(imeName : String)
		{
			trace("IME EVENT: onSetIMEName: " + imeName);
		}
		
		this.imeListener.onSetSupportedIMEs = function(imeNames : String)
		{
			trace("IME EVENT: onSetSupportedIMEs: " + imeNames);
		}
		
		this.imeListener.onRemoveStatusWindow = function()
		{
			trace("IME EVENT: onRemoveStatusWindow");
		}
		
		this.imeListener.onDisplayStatusWindow = function()
		{
			trace("IME EVENT: onDisplayStatusWindow");
		}
		
		this.imeListener.onSetConversionMode = function(conversionMode : String)
		{
			trace("IME EVENT: onSetConversionMode: " + conversionMode);
		}
		
		System.IME.addListener(this.imeListener);
	}
	
	// getMovieClipFile() -> get the filename of the movieclip
	private function getMovieClipFile(mc : MovieClip) : String
	{
		var file : String = "unknown";
		if (mc == this.languageBarContainer)
		{
			file = this.languageBarFile;
		}
		if (mc == this.statusWindowContainer)
		{
			file = this.statusWindowFile;
		}
		return file;
	}
	
	// initLanguageBar() -> initialize the language bar clips
	private function initLanguageBar()
	{
		if (System.capabilities.hasIME)
		{
			// this causes the SetFocus event to be raised on the current movie instance
			fscommand("cry_imeFocus", 0);
			
			var listener = new Object();
			listener.parent = this;
			listener.onLoadInit = function(mc : MovieClip)
			{
				//var name : String = this.parent.getMovieClipFile(mc);
				//trace("LanguageBar loaded " + name + " at " + mc);
				this.parent.layout();
			}
			listener.onLoadError = function(mc : MovieClip, errorCode : String)
			{
				trace("LanguageBar failed loading " + this.parent.getMovieClipFile(mc) + ", reason: " + errorCode);
			}
			
			var loader = new MovieClipLoader();
			loader.addListener(listener);
			
			this.languageBarContainer = context.createEmptyMovieClip("langbar_container_mc", context.getNextHighestDepth());
			if (!loader.loadClip(this.languageBarFile, this.languageBarContainer)) listener.onLoadError(this.languageBarContainer, "loadClip failed");
			
			this.statusWindowContainer = context.createEmptyMovieClip("statuswindow_container_mc", context.getNextHighestDepth());
			if (!loader.loadClip(this.statusWindowFile, this.statusWindowContainer)) listener.onLoadError(this.statusWindowContainer, "loadClip failed");
		
			// Called by LangBar.gfx implementation, forward to this class instead
			context.__languageBar = this;
			context.onLangBarResize = function(x : Number, y : Number)
			{
				this.__languageBar.onLanguageBarResize(x, y);
			}
			
			// To track textfield and mouse selection
			Selection.addListener(this);
			Mouse.addListener(this);
			
			// This initializes the opacity flags
			onMouseMove();
		}
	}
	
	// constructor
	// pass in the root context on which the language bar shall reside
	public function LanguageBar(context : MovieClip)
	{
		this.context = context;
		//this.initListener(); // For debugging of events
		this.initLanguageBar();
		this.setPosition(0, 0);
	}
	
	// destroy() -> destroys the language bar
	public function destroy()
	{
		// roll-back context modifications
		this.context.__languageBar = undefined;
		this.context.onLangBarResize = undefined;
		this.context = null;
		
		// remove listeners
		Selection.removeListener(this);
		Mouse.removeListener(this);
		System.IME.removeListener(this.imeListener);
		
		// remove movieclips
		// note: the Scaleform flash files were never designed to be destroyed/unloaded
		// therefore, we manually unregister/detach listeners so the IME events no longer get picked up by the 'destroyed' objects
		// since we clean up all listener objects and remove the clips from the stage, they could be garbage collected (not sure if that actually happens)
		// if you were to implement your own flash files for the language bar, you can change/remove/refactor this most likely
		if (this.languageBarContainer != null)
		{
			//var name : String = this.getMovieClipFile(this.languageBarContainer);
			//trace("LanguageBar destroyed " + name);
			
			// destroy the language bar container best we can
			System.IME.removeListener(this.languageBarContainer.IMEListener);
			Mouse.removeListener(this.languageBarContainer.mouseListener);
			this.languageBarContainer.removeMovieClip();
			delete this.languageBarContainer;
		}
		if (this.statusWindowContainer != null)
		{
			//var name : String = this.getMovieClipFile(this.statusWindowContainer);
			//trace("LanguageBar destroyed " + name);
			
			// destroy the status window container best we can
			System.IME.removeListener(this.statusWindowContainer.IMEListener);
			this.statusWindowContainer.removeMovieClip();
			delete this.statusWindowContainer;
		}
	}
	
	// isSupported() : Boolean -> check if language bar is supported in this file
	public function isSupported() : Boolean
	{
		return System.capabilities.hasIME;
	}
	
	// isCandidateListVisible() : Boolean -> check if the IME candidate list is currently visible
	public function isCandidateListOpen() : Boolean
	{
		return System.capabilities.hasIME && _level9999.isCandListOpen; // Note: IME.gfx is always hardcoded at _level9999 by Scaleform
	}
	
	// onSetFocus(oldFocus : Object, newFocus : Object) -> registered with Selection events
	public function onSetFocus(oldFocus : Object, newFocus : Object)
	{
		this.isTextfieldFocused = newFocus != null;
		this.onMouseMove(); // Logic for fade is implemented in onMouseMove
	}
	
	// onMouseMove() -> registered with Mouse events
	public function onMouseMove()
	{
		// find out if the mouse is hovering over the language bar clips (or a textfield is focused)
		var isHovering : Boolean = this.isTextfieldFocused;
		if (this.languageBarContainer != null) isHovering = isHovering || this.languageBarContainer.hitTest(_xmouse, _ymouse, true);
		if (this.statusWindowContainer != null) isHovering = isHovering || this.statusWindowContainer.hitTest(_xmouse, _ymouse, true);
		
		// set alpha value of the language bar clips
		var alpha : Number = isHovering ? 100 : this.unfocusedAlpha;
		if (this.languageBarContainer != null) this.languageBarContainer._alpha = alpha;
		if (this.statusWindowContainer != null) this.statusWindowContainer._alpha = alpha;
	}
	
	// onLanguageBarResize
	// moves the StatusWindow such that it's aligned with the LanguageBar
	public function onLanguageBarResize(x : Number, y : Number)
	{
		var posX = this.languageBarX;
		var posY = this.languageBarY;
		if (this.languageBarContainer != null)
		{
			this.languageBarContainer._x = posX;
			this.languageBarContainer._y = posY;
		}
		
		posX += x;
		if (this.statusWindowContainer != null)
		{
			this.statusWindowContainer._x = posX;
			this.statusWindowContainer._y = posY;
		}
	}
	
	// re-layout the movie clips
	// this should be done after the clips are loaded/reloaded or the position changes
	public function layout()
	{
		if (this.languageBarContainer != null)
		{
			onLanguageBarResize(this.languageBarContainer._width, this.languageBarContainer._height);
		}
	}
	
	// setPosition(x, y) -> set the position of the language bar on the stage
	// the default is at (0,0)
	public function setPosition(x : Number, y : Number)
	{
		languageBarX = x;
		languageBarY = y;
		this.layout();
	}
};
