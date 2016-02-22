//----------------------------- Defaults ------------------------------
_global.gfxExtensions = true;
import caurina.transitions.Tweener;

//--------------------------------------------------------------------------
//----------------------------- Ext Functions ------------------------------
//--------------------------------------------------------------------------
// weapon info
function setWeapon(_weaponName:String, _ammoTypeName:String, _isMelee:Boolean, _poolAmmo:Number, _maxAmmo:Number, lowAmmo:String, outOfAmmo:String)
{
	m_weaponName = _weaponName;
	m_ammoTypeName = _ammoTypeName;
	m_isMelee = _isMelee;
	m_poolAmmo = _poolAmmo;
	m_maxAmmo = _maxAmmo;
	_updateCurrentAmmo(lowAmmo, outOfAmmo);
}

// ammo count
function setAmmo(_currAmmo:Number, lowAmmo: String, outOfAmmo:String)
{
	m_currAmmo = _currAmmo;
	_updateCurrentAmmo(lowAmmo, outOfAmmo);
}

// health info
function setHealth(_intHitpointsPercent:Number)
{
  AmmoHealth.Energy_Bar.energyBarFill.gotoAndStop(_intHitpointsPercent);
  _root.Energy = _intHitpointsPercent * 1;
}

// stamina
function setStamina(_stamina:Number)
{
  AmmoHealth.StaminaBar._xscale = _stamina * 100;
}

// video transmission
function playVideo(_videoFile:String)
{
	//Tweener.addTween(VideoPlayer, {_alpha:100, time:1, transition:"easeOutQuart" } );
	//MoviePath = _videoFile;
	//VideoPlayer.VideoPlayer.SelectAudioChannel(0); // disable sound!
	//VideoPlayer.VideoPlayer._visible = true;
	//VideoPlayer.VideoPlayer.Play();
	trace("VIDEO PLAYER DISABLED!");
	fscommand("onPlay");
}

// radar functions
function setupMiniMap(_strPathToMiniMap:String, _intMapSizeX:Number, _intMapSizeY:Number)
{
	loadMovie("img://"+ _strPathToMiniMap, Root_Radar.MiniMap.MapArea.Map);
	
	m_MapSizeX = _intMapSizeX;
	m_MapSizeY = _intMapSizeY;
	scaleMap(m_MapScale);
}

function scaleMap(_floatScale:Number)
{
	m_MapScale = _floatScale;
	Root_Radar.MiniMap.MapArea.Map._xscale = _floatScale*100;
	Root_Radar.MiniMap.MapArea.Map._yscale = _floatScale*100;
}

function clamp(val:Number, min:Number, max:Number){
    return Math.max(min, Math.min(max, val))
}
 
function setPlayerPos(_floatPosx:Number, _floatPosy:Number, _intRot:Number)
{	
	var shiftX = _floatPosy * m_MapSizeX * m_MapScale; // since map is rotated about -90 degree, switch x and y coordinates
	var shiftY = _floatPosx * m_MapSizeY * m_MapScale;
	
	Root_Radar.MiniMap.MapArea._x = -shiftX;
	Root_Radar.MiniMap.MapArea._y = -shiftY;
	
	Root_Radar.MiniMap._rotation = _intRot;
	
	// Update entities that fell off the radar or came back on
	for(var item in m_MinimapItems)
	{
		if(m_MinimapItems[item] == null || m_MinimapItems[item] == undefined || m_MinimapItems[item].originalX == undefined|| m_MinimapItems[item].originalY == undefined)
		  {
		   continue;
		  }
		
		// transform object's original point into the mask
		var myPoint:Object = {x:m_MinimapItems[item].originalX, y:m_MinimapItems[item].originalY};
		Root_Radar.MiniMap.MapArea.localToGlobal(myPoint);
		Root_Radar.MaskAnim.globalToLocal(myPoint);
		
		// custom mask values to tweak the visibility of radar icons that fell off the radar
		// these are the values for the mask shape inside MaskAnim
		var maskX:Number = 0;
		var maskY:Number = -5;
		var maskW:Number = 207.3;
		var maskH:Number = -140.45;
		
		// visibility check
		if((myPoint.x - m_MinimapItems[item]._width > maskX && myPoint.x + m_MinimapItems[item]._width < maskW) && (myPoint.y + m_MinimapItems[item]._height < maskY && myPoint.y - m_MinimapItems[item]._height > maskH))
		{
			m_MinimapItems[item]._alpha = 100;
		}
		else
		{
			m_MinimapItems[item]._alpha = 25;
		}
		
		// clamp original point and transform back to local icon point
		myPoint.x  = clamp(myPoint.x , maskX + m_MinimapItems[item]._width, maskW  - m_MinimapItems[item]._width);
		myPoint.y  = clamp(myPoint.y, maskH  + m_MinimapItems[item]._height, maskY - m_MinimapItems[item]._height);
		Root_Radar.MaskAnim.localToGlobal(myPoint);
		Root_Radar.MiniMap.MapArea.globalToLocal(myPoint);
		
		// set real pos to clamped
		m_MinimapItems[item]._x = myPoint.x;
		m_MinimapItems[item]._y = myPoint.y;
	}
	
	_setCompass(_intRot);
}

m_MinimapItems = new Array();
function addMiniMapItem(_id, _strType)
{
  if (m_MinimapItems[_id] == null)
	m_MinimapItems[_id] = Root_Radar.MiniMap.MapArea.attachMovie(_strType, "Entity" + _id, Root_Radar.MiniMap.MapArea.getNextHighestDepth() );
  else
    trace("Warning item with " + _id + "already exists!");
}

function updateMiniMapItem(_id, _posx, _posy, _rot)
{
  if (m_MinimapItems[_id] != null)
  {
    m_MinimapItems[_id]._x = _posy * m_MapSizeX * m_MapScale;
    m_MinimapItems[_id]._y = _posx * m_MapSizeY * m_MapScale;
    m_MinimapItems[_id].originalX = _posy * m_MapSizeX * m_MapScale;
    m_MinimapItems[_id].originalY = _posx * m_MapSizeY * m_MapScale;	
    m_MinimapItems[_id]._rotation = -_rot;
  }
 }

function removeMiniMapItem(_id)
{
  if (m_MinimapItems[_id] != null)
  {
    m_MinimapItems[_id].removeMovieClip();
    m_MinimapItems[_id] = null;
  }
}

// message
var missionMessageDetailqueue:Array = [];
var primaryMessage:String = "";
var detailMessage:String = "";
var secondaryMessage:String = "";
var detailQueueActive = false;

function displayMessage(_message:String)
{
	_root.HudMsg = _message;
	Tweener.addTween(Messages, {_alpha:100, time:1, transition:"easeOutQuart" } );
}

function hideMessage()
{
	Tweener.addTween(Messages, { _alpha:0, time:1, transition:"easeOutQuart" } );
}

function showMissionMessagePrimary(_message:String, _typingSpeed:Number) 
{
	_typingSpeed = _typingSpeed? _typingSpeed: 30;
	missionMessage.limiter._yscale = 0;
	missionMessage.textFieldContainer._yscale = 0;
	
	if (primaryMessage == "") {
		missionMessage.textFieldContainer.textField.text = "";
		primaryMessage = _message;
		addTextTypewriterStyle(missionMessage.textFieldContainer.textField, "primary", _typingSpeed, getTimer(), 0);
	}
	
	Tweener.addTween(missionMessage, { _alpha:100, time:1, transition:"easeOutQuart" } );
	Tweener.addTween(missionMessage.limiter, { _height:100, time: 0.2, transition:"easeOutQuart" } );
	Tweener.addTween(missionMessage.textFieldContainer, { _yscale:100, time: 0.5, transition:"easeOutQuart" } );
}

function hideMissionMessagePrimary() 
{
	Tweener.addTween(missionMessage, { _alpha:0, time:1, transition:"easeOutQuart" } );
	Tweener.addTween(missionMessage.limiter, { _yscale:0, time: 0.2, transition:"easeOutQuart" } );
	Tweener.addTween(missionMessage.textFieldContainer, { _yscale:0, time: 0.5, transition:"easeOutQuart" } );
}

function showMissionMessageSecondary(_message:String, _typingSpeed:Number) {
	_typingSpeed? _typingSpeed: 30;
	missionMessageSecondary._yscale = 0;
	
	if(secondaryMessage == "") {	
		missionMessageSecondary.textFieldContainer.textField.text = "";
		secondaryMessage = _message;
		addTextTypewriterStyle(missionMessageSecondary.textFieldContainer.textField, "secondary", _typingSpeed, getTimer(), 0);
	}
	
	Tweener.addTween(missionMessageSecondary, { _alpha:100, time:1, transition:"easeOutQuart" } );
	Tweener.addTween(missionMessageSecondary, { _yscale:100, time: 0.5, transition:"easeOutQuart" } );
}

function hideMissionMessageSecondary() {
	Tweener.addTween(missionMessageSecondary, { _alpha:0, time:1, transition:"easeOutQuart" } );
	Tweener.addTween(missionMessageSecondary, { _yscale:0, time: 0.5, transition:"easeOutQuart" } );
}

function showNextMissionMessageDetail () {
	if (missionMessageDetailqueue.length <= 0) {
		return false;		
	}
	missionMessageDetail._yscale = 0;
	Tweener.addTween(missionMessageDetail, { _alpha:100, time:1, transition:"easeOutQuart" } );
	Tweener.addTween(missionMessageDetail, { _yscale:100, time: 0.5, transition:"easeOutQuart" } );
	
	if (detailMessage == "") {
		missionMessageDetail.textFieldContainer.textField.text = "";
		var msgObj = missionMessageDetailqueue.shift();
		detailMessage = msgObj.message;		
		addTextTypewriterStyle(missionMessageDetail.textFieldContainer.textField, "detail" , msgObj.typingSpeed, getTimer(), 0);
	}
	return true;
}

function queueMissionMessageDetail(_message:String, _typingSpeed: Number) 
{
	missionMessageDetailqueue.push({message: _message, typingSpeed: _typingSpeed? _typingSpeed: 30});
}

function hideMissionMessageDetail() 
{	
	detailQueueActive = false;
	Tweener.addTween(missionMessageDetail, { _alpha:0, time:1, transition:"easeOutQuart" } );
	Tweener.addTween(missionMessageDetail, { _yscale:0, time: 0.5, transition:"easeOutQuart" } );
}

function addTextTypewriterStyle(_textField, _messageType:String, _delay:Number, _lastTime:Number, _residualTime:Number) {
	var message;
	var currentTime = getTimer();
	var totalDelta = (currentTime - _lastTime) + _residualTime;
	
	switch(_messageType) {
		case "primary":
			message = primaryMessage;
			break;
		case "secondary":
			message = secondaryMessage;
			break;
		case "detail":
			message = detailMessage;
			break;
	}
	
	for (; _delay < totalDelta; totalDelta -= _delay) {
		if (_textField.text.charAt(_textField.text.length - 1) === "_") 
		{
			_textField.text = _textField.text.substring(0, _textField.text.length - 1);
		}
		
		if (message.substr(0, 4) === "<br>") 
		{
			_textField.text += newline;
			message = message.substr(4);
		} 
		else 
		{
			_textField.text += message.charAt(0) + "_";
			message = message.substr(1);
		}
		
		if (message.length == 0) {
			break;
		} 
	}
	
	if (message.length >= 0) 
	{		
		switch(_messageType) {
			case "primary":
				primaryMessage = message;
				break;
			case "secondary":
				secondaryMessage = message;
				break;
			case "detail":
				detailMessage = message;
				break;
		}
	}
	
	if (message.length > 0) {
		setTimeout(function() {
			addTextTypewriterStyle(_textField, _messageType, _delay, currentTime, totalDelta);
		}, _delay);
	}
	else 
	{
		return;
	}
}

// mp messages
function addMessageItem(_msgType:String, _str1:String, _str2:String)
{
	_addMessageItem(_msgType, _str1, _str2);
}

//--------------------------------------------------------------------------
//--------------------------- internal functions ---------------------------
//--------------------------------------------------------------------------

//----------------------------- weapon  ------------------------------
var m_weaponName:String;
var m_ammoTypeName:String;
var m_poolAmmo:Number;
var m_maxAmmo:Number;
var m_isMelee:Boolean;
var m_currAmmo:Number;

function _updateCurrentAmmo(lowAmmoString, outOfAmmoString)
{
	_root.Pool = m_poolAmmo;
	_root.AmmoAdd = m_currAmmo > m_maxAmmo ? "+" + (m_currAmmo - m_maxAmmo) : "0";
	_root.Ammo = m_currAmmo > m_maxAmmo ? m_maxAmmo : m_currAmmo;
	
	var ammoPercent = m_maxAmmo > 0 ? m_currAmmo / m_maxAmmo : 1;
	Warning._visible = !m_isMelee && ammoPercent < 0.2 && (m_currAmmo > 0 || m_poolAmmo == 0);
	_root.WarningMsg = m_currAmmo > 0 ? lowAmmoString : outOfAmmoString;
	
	AmmoHealth.AmmoDisplay._visible = !m_isMelee;
	AmmoHealth.AmmoLeftBG_red._visible = !m_isMelee && m_currAmmo == 0;
	AmmoHealth.AmmoRightBG_red._visible = !m_isMelee && m_poolAmmo == 0;
	
	if (!m_isMelee && m_currAmmo == 0 && m_poolAmmo == 0)
		AmmoHealth.AmmoDisplay.gotoAndStop(3);
	else if (!m_isMelee && m_currAmmo == 0)
		AmmoHealth.AmmoDisplay.gotoAndStop(2);
	else if (!m_isMelee && m_poolAmmo == 0)
		AmmoHealth.AmmoDisplay.gotoAndStop(4);
	else
		AmmoHealth.AmmoDisplay.gotoAndStop(1);
	
	var ammotype:String = m_ammoTypeName != "" ? m_ammoTypeName : "empty";
	if (AmmoHealth.FireModeIcon.m_newFireMode != ammotype)
	{
		AmmoHealth.FireModeIcon.m_newFireMode = ammotype;
		AmmoHealth.FireModeIcon.gotoAndPlay(1);
	}
	
	var weaponName:String = m_weaponName != "" ? m_weaponName : "empty";
	if (WeaponSelect.WeaponRoll.m_newWeapon != weaponName)
	{
		WeaponSelect.WeaponRoll.m_newWeapon = weaponName;
		AmmoHealth.WeaponName.text = weaponName;
		WeaponSelect.WeaponRoll.gotoAndPlay("left");
	}

}

//----------------------------- video  ------------------------------
/*
var NetC = new NetConnection();
NetC.connect(null);

var MoviePath:String = "";

_global.eVideoStatus_PrePlaying = 0;
_global.eVideoStatus_Playing = 1;
_global.eVideoStatus_Stopped = 2;
_global.eVideoStatus_Finished = 3;
_global.eVideoStatus_Error = 4;

var m_status:Number = eVideoStatus_PrePlaying;

function HandleStop( bVideoFinished:Boolean )
{
	Tweener.addTween(VideoPlayer, {_alpha:0, time:1, transition:"easeOutQuart" } );
	VideoPlayer.VideoPlayer._visible = false;
	VideoPlayer.VideoPlayer.UnloadVideo();
	fscommand("onVideoStop");
}
VideoPlayer._alpha = 0;
*/

//----------------------------- radar  ------------------------------
var m_MapScale = 0.5;
var m_MapSizeX = 2048;
var m_MapSizeY = 2048;

var RADAR_COMPASS_LOWPIXELRANGE = 17;
var RADAR_COMPASS_HIGHPIXELRANGE = 512;
var RADAR_COMPASS_PIXELRANGE = RADAR_COMPASS_HIGHPIXELRANGE - RADAR_COMPASS_LOWPIXELRANGE;
var PI2 = Math.PI*2;

function _setCompass(_fPlayerRot:Number)
{
	_fPlayerRot = _fPlayerRot * (Math.PI/180);
	var fInterpolatedPercent = 0;
	if (_fPlayerRot < 0) fInterpolatedPercent = _fPlayerRot*(-1)/PI2;
	else                 fInterpolatedPercent = (PI2 - _fPlayerRot) / PI2;
	Root_Radar.radarCompass.Compass._x = (1-fInterpolatedPercent) * RADAR_COMPASS_PIXELRANGE + RADAR_COMPASS_LOWPIXELRANGE;
}

function setThreatLevel (threatLevel:Number) {
	if (threatLevel > 100) {
		threatLevel = 100;
	}
	
	threatLevel = Math.floor(threatLevel / 5) * 5;	
	Root_Radar.ThreatMeter.gotoAndStop(threatLevel);
}


//----------------------------- mp messages  ------------------------------
var MSG_KILL:String = "kill";
var MSG_JOIN:String = "join";
var MSG_LEAVE:String = "left";

var m_activeMessages:Array = new Array();

function _addMessageItem(_msgType:String, _str1:String, _str2:String)
{
	var iconstr = "cross";
	var messagestr = "";
	switch (_msgType)
	{
		case MSG_KILL:
			iconstr = _str1 == _str2 ? "cross" : "kill";
			messagestr = _str1 == _str2 ? _str1 + " @hud_mp_self_killed" : _str1 + " @hud_mp_killed " + _str2;
			break;
		case MSG_JOIN:
			iconstr = "player";
			messagestr = _str1 + " @hud_mp_joined_game";
			break;
		case MSG_LEAVE:
			iconstr = "player";
			messagestr = _str1 + " @hud_mp_left_game";
			break;
	}
	var mc = _root.MPMessages.attachMovie("MP_MessageItem", "MsgItem"+_root.MPMessages.getNextHighestDepth(),_root.MPMessages.getNextHighestDepth());
	mc.iconmc.gotoAndStop(iconstr);
	mc.messagemc.text = messagestr;
	Tweener.addTween(mc, {_alpha:0, time:8, transition:"easeOutQuart" } );
	
	m_activeMessages.push(mc);
	
	var x = 15;
	var y = 0;
	var dy = 32;
	var count = 0;
	
	for (var i:Number = m_activeMessages.length - 1; i >= 0; --i)
	{
		if (m_activeMessages[i]._alpha > 0)
		{
			m_activeMessages[i]._x = x;
			m_activeMessages[i]._y = y;
			y += dy;
			count++;
			if (count > 4)
				m_activeMessages[i]._visible = false;
		}
	}
	
	var found = true;
	while (found)
	{
		found = false;
		for (var i:Number = 0; i < m_activeMessages.length; ++i)
		{
			if (m_activeMessages[i]._alpha == 0)
			{
				found = true;
				m_activeMessages[i].removeMovieClip();
				m_activeMessages.splice(i,1);
				break;
			}
		}
	}
}