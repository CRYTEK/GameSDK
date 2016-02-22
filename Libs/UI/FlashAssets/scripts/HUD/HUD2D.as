//---------------------------- Setup ---------------------------------------
_global.gfxExtensions = true;
Crosshair.m_ZoomDistance = 999;
import caurina.transitions.Tweener;
import scripts.HUD.PlayerForScoreboard;
import cryflash.LanguageBar;

//For controller input catching
var eCIE_Up:Number		= 0;
var eCIE_Down:Number	= 1;
var eCIE_Left:Number	= 2;
var eCIE_Right:Number	= 3;
var eCIE_Action:Number	= 4;
var eCIE_Back:Number	= 5;
var eCIE_Start			= 6;
var eCIE_Select			= 7;
var eCIE_ShoulderL1		= 8;
var eCIE_ShoulderL2		= 9;
var eCIE_ShoulderR1		= 10;
var eCIE_ShoulderR2		= 11;
var eCIE_Button3		= 12;
var eCIE_Button4		= 13;

//Chat related variables
var mChatting:Boolean = false;
_root.ChatField._visible = false;
_root.ChatField.ChatInput.background = false;
_root.ChatField.ChatInputShadow.background = false;
_root.ChatField.ChatInputShadow.textColor = 0x000000;
_root.ChatField.ChatInputShadow.border = false;
var frameEnterCallback;
var langBar:LanguageBar = null;

var ChatMessageCount:Number = 0;
var ChatMessages:Array = new Array();

cry_onController = function(iButton:Number, bReleased:Boolean)
{
	if (bReleased)
		return;
		
	switch(iButton)
	{
		case eCIE_Action:
			if (mChatting) 
			{
				endChat(false);
			}
			break;
		case eCIE_Back:
			if (mChatting) 
			{
				endChat(true);
			}
			break;
	}
}

//--------------------------------------------------------------------------
//----------------------------- Ext Functions ------------------------------
//--------------------------------------------------------------------------
// weapon info
var m_CurrWeapon = "-1";
function setWeapon( _strWeaponName:String, _boolZoomed)
{
	Crosshair._visible = false;
	Crosshair.m_Spread = 15;
	Crosshair.m_Zoomed = _boolZoomed;
	
	if (_strWeaponName == "")
		_strWeaponName = "empty";

	if (m_CurrWeapon != _strWeaponName)
	{
		Crosshair.gotoAndStop(_strWeaponName);
		m_CurrWeapon = _strWeaponName;
	}
	Crosshair.updateState();
}

function onShoot()
{
	Crosshair.m_Spread += 2;
	Crosshair.updateState();
}

function setZoomStep(_zoomStep:Number)
{
	Crosshair.m_ZoomStep = _zoomStep;
	Crosshair.updateState();
}

function setZoomDistance(_distance:Number)
{
	Crosshair.m_ZoomDistance = _distance;
	Crosshair.updateState();
}

//--------------------------------------------------------------------------
//----------------------------- Chat functionality -------------------------
//--------------------------------------------------------------------------
function endChat(_cancel:Boolean)
{
	if (langBar != null)
	{
		langBar.destroy();
		langBar = null;
	}
	
	if (_root.ChatField.ChatInput.text != "" && !_cancel)
	{
		var msg:String =  _root.ChatField.ChatInput.text;
		
		//replace all comma with points (else FSCommand will think we are passing multiple arguments)
		var index:Number = msg.indexOf(",", 0);
		while (index > 0)
		{
			msg = msg.split(",").join(".");
			index = msg.indexOf(",", 0);
		}
		
		fscommand("onChatMessageSend", msg);	
	}
	else
	{
		fscommand("onChatMessageCancel");	
	}
		
	mChatting = false; 
	_root.ChatField.ChatInput.text = "";
	_root.ChatField.ChatInputShadow.text = "";
	Selection.setFocus(null);
	_root.ChatField._visible = false;
	delete _root.onEnterFrame;
}

function startChat()
{
	if (langBar == null)
	{
		langBar = new LanguageBar(_root);
	}
	
	_root.ChatField._visible = true;
	Selection.setFocus(_root.ChatField.ChatInput);
	mChatting = true;
	_root.onEnterFrame = function()
	{
		_root.ChatField.ChatInputShadow.text = _root.ChatField.ChatInput.text;
		
	}
}

function displayChatMessage(_player:String, _message:String)
{
	//Remove faded out ones
	var found:Boolean = true;
	while (found)
	{
		found = false;
		for (var i:Number = 0; i < ChatMessages.length; i++) 
		{
			if (ChatMessages[i]._alpha <= 10)
			{
				ChatMessages[i].removeMovieClip();
				ChatMessages.splice(i, 1);
				found = true;
				break;
			}
		}
	}
	
	//moved up
	for (var i:Number = 0; i < ChatMessages.length; i++) 
	{
		ChatMessages[i]._y = i * 21;
	}
	
	//Add new 
	var msgLen:Number = _message.length;
	var remainingMsg:String = _message;
	var maxLen:Number = 20;
	var playerprefix:Boolean = true;
	
	//If message is too long we break it up into multiple lines
	while (msgLen > 0)
	{
		var curMsg:String = remainingMsg.substr(0, maxLen);
		remainingMsg = remainingMsg.substr(maxLen, remainingMsg.length);
		msgLen = remainingMsg.length;
		
		ChatMessageCount++;
		var new_messageShadow = _root.ChatMessageList.attachMovie("MCChatMessage", "ChatMessageShadow" + ChatMessageCount, _root.ChatMessageList.getNextHighestDepth());
		var new_message = new_messageShadow.attachMovie("MCChatMessage", "ChatMessage" + ChatMessageCount, _root.ChatMessageList.getNextHighestDepth());
		new_messageShadow.MessageField.textColor = 0x000000;
		
		if (playerprefix)
		{
			new_messageShadow.MessageField.text = _player + ": " + curMsg;
		}
		else {
			new_messageShadow.MessageField.text = curMsg;
		}
		
		//Add message and tween
		new_message.MessageField.text = new_messageShadow.MessageField.text;
		Tweener.addTween(new_messageShadow, { _alpha:0, time:10, transition:"easeInQuart" } );
		ChatMessages.push(new_messageShadow);
		new_messageShadow._y = (ChatMessages.length - 1) * 21;
		
		//offset message from shadow
		new_message._y -= 1;
		new_message._x -= 0.5;
		playerprefix = false;
	}
}

//--------------------------------------------------------------------------
//-------------------------- Scoreboard functionality ----------------------
//--------------------------------------------------------------------------
var m_Players:Array = new Array();
var m_Clips:Array = new Array();
var m_ScoreboardItemCount:Number = 0;
var m_ScoreboardIndex:Number = 0;
onHideScoreboard();

function updateOrAddScoreboardItem(_id:Number, _playername:String, _kills:Number, _deaths:Number, _team:String)
{
	var lookupId:Number = doesExist(_id);
	
	if (lookupId >= 0)
	{
		m_Players[lookupId].m_Name = _playername;
		m_Players[lookupId].m_Kills = _kills;
		m_Players[lookupId].m_Deaths = _deaths;
		m_Players[lookupId].m_Team = _team;
		m_Players[lookupId].m_Ping = getFPS();
		
		m_Players[lookupId].Update();
		
	}
	else
	{
		addNewitem(_id, _playername, _team, _kills, _deaths);
	}
	sortPlayerOnKills();
}

function doesExist(_id:Number):Number 
{
	for (var i:Number = 0; i < m_Players.length; i++) 
	{
		if (m_Players[i].m_Id == _id)
		{
			return i;
		}
	}
	return -1;
}

function addNewitem(_id:Number, _playername:String, _team:String)
{
	m_ScoreboardIndex++; m_ScoreboardItemCount++;
	var scoreBoardItem = _root.Scoreboard.attachMovie("MCScoreboardItem", "MCScoreboardItem" + m_ScoreboardIndex, _root.Scoreboard.getNextHighestDepth());
	scoreBoardItem._y += m_ScoreboardItemCount * 20;
	m_Clips.push(scoreBoardItem);
	
	var newPlayer = new PlayerForScoreboard(_id, _playername, scoreBoardItem, _team);
	m_Players.push(newPlayer);
	
	newPlayer.m_TextField = scoreBoardItem;
}

function removeItem(_id:Number)
{
	for (var i:Number = 0; i < m_Players.length; i++) 
	{
		if (m_Players[i].m_Id == _id)
		{
			delete m_Players[i];
			m_Players.splice(i, 1);
			m_Clips[i].removeMovieClip();
			m_ScoreboardItemCount--;
			m_Clips.splice(i, 1);
		}
	}
	sortPlayerOnKills();
}
function getFPS():Number
{
	if(signal == true) {

        time = getTimer();

    } else {

        rate = int(1000 / (getTimer() - time));

    }

    signal = !signal;

    return rate;
}

function sortPlayerOnKills()
{
	var swap:Boolean = true;
	while (swap)
	{
		swap = false;
		for (var i:Number = 0; i < m_Players.length-1; i++) 
		{
			if (m_Players[i].m_Kills < m_Players[i+1].m_Kills)
			{
				var temp:PlayerForScoreboard = m_Players[i];
				m_Players[i] = m_Players[i + 1];
				m_Players[i + 1] = temp;
				
				//keep clips and players in sync (visual and data)
				temp = m_Clips[i];
				m_Clips[i] = m_Clips[i + 1];
				m_Clips[i + 1] = temp;
				
				swap = true;
			}
		}
	}
	
	for (var i:Number = 0; i < m_Players.length; i++) 
	{
		m_Players[i].m_InfoField._y = (i+1) * 20;
	}
}

function onShowScoreboard()
{
	_root.Scoreboard._visible = true;
}

function onHideScoreboard()
{
	_root.Scoreboard._visible = false;
}

//--------------------------------------------------------------------------

