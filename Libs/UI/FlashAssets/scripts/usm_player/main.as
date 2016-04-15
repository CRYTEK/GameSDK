_global.gfxExtensions = true;
setProperty("", _focusrect, false);

var DebugMode:Boolean = false;
var enableAudio = false;
var showSubtitle = true;

_global.eVideoStatus_PrePlaying = 0;
_global.eVideoStatus_Playing = 1;
_global.eVideoStatus_Stopped = 2;
_global.eVideoStatus_Finished = 3;
_global.eVideoStatus_Error = 4;

var m_status:Number = eVideoStatus_PrePlaying;

var NetC = new NetConnection();
NetC.connect(null);

//Videoplayer functions
function vUnloadVideo()
{
	VideoPlayer.UnloadVideo();
}
function vPlay(){
	VideoPlayer._visible = true;
	BlackBG._visible = true;
	Subtitles._visible = true;
	VideoPlayer.Play();
	fscommand("onPlay");
}

function vPause(){
	VideoPlayer.Pause();
	fscommand("onPause");
}

function vResume(){
	VideoPlayer.Resume();
	fscommand("onResume");
}

function vStop(){
	VideoPlayer.Stop();
	_root.m_status = eVideoStatus_Stopped;
	HandleStop( false );
}

function SetLoopMode(Mode){
	VideoPlayer.SetLoopMode(Mode);
}

function setMoviePath(Movie)
{
	MoviePath = Movie;
}

function setBackGroundAlpha(fAlpha)
{
	BlackBG._alpha = fAlpha;
}

var m_bMirrow = false;
function mirrowVideo(_bMirrow:Boolean)
{
	if (m_bMirrow == _bMirrow) return;
	
	VideoPlayer._xscale = -VideoPlayer._xscale;
	m_bMirrow = _bMirrow;
}

function setInvisible()
{
	VideoPlayer._visible = false;
	BlackBG._visible = false;
	Subtitles._visible = false;
}


function vSelectAudioChannel(m_Channel)
{
	VideoPlayer.SelectAudioChannel(m_Channel);
}

function vSelectSubtitleChannel(m_Channel)
{
	VideoPlayer.SelectSubtitleChannel(m_Channel);
}

// callback functions
function HandleStop( bVideoFinished )
{
	fscommand("onStop", bVideoFinished);
}

function HandleLooped()
{
	fscommand("onLooped");
}

function HandleFileNot()
{
	fscommand("onFileNotFound");
}

stop();