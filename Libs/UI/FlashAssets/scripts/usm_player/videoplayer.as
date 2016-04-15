ns = new NetStream(_root.NetC);
video.attachVideo(ns);

var AudioTracks;
var loop = false;

var selectedAudio:Number = 1;
var selectedSubtitle:Number = 1;

function Play()
{
    ns.play(_root.MoviePath);
}
function Pause()
{
    ns.pause(true);
}
function Resume()
{
    ns.pause(false);
}
function Stop()
{
 	ns.seek(0); 
	ns.close();
}

function UnloadVideo()
{
	ns.close();
}

function SetLoopMode(mode)
{
    loop = mode;
}

function SelectAudioChannel(m_Channel:Number)
{
	if(_root.DebugMode == true)
	{
		trace("SelectAudioChannel: ns.audioTrack = "+AudioTracks[m_Channel].trackIndex);
	}
	selectedAudio = m_Channel;
}

function SelectSubtitleChannel(m_Channel:Number)
{
	if(_root.DebugMode == true)
	{
		trace("SelectSubtitleChannel: ns.subtitleTrack = "+m_Channel);
	}
	selectedSubtitle = m_Channel;
}

ns.onStatus = function (infoObject)
{
   var VideoAction = infoObject.level;
   var VideoStatus = infoObject.code;
      
   if (VideoAction == "status")
    {
		if(VideoStatus == "NetStream.Play.Start")
		{
			_root.m_status = eVideoStatus_Playing;
		}
		else if (VideoStatus == "NetStream.Play.Stop")
        {
            if (loop == true)
            {
                ns.seek(0);
                _root.HandleLooped();
            }
            else
            {
				_root.m_status = eVideoStatus_Finished;
                _root.HandleStop(true);
            }
        }
    }
    else if (VideoAction == "error")
    {
		_root.m_status = eVideoStatus_Error;
		
        if (VideoStatus == "NetStream.Play.StreamNotFound")
        {
			_root.HandleFileNot();
        }
    }
};

ns.onMetaData = function(info:Object)
{
	AudioTracks 		= info.audioTracks;
	subtitlesNumber 	= info.subtitleTracksNumber;
	
	if(_root.DebugMode == true)
	{
		trace("VIDEO FILE LOADED...");
		trace("------------------------------------");
		trace("Audio Tracks included: " + AudioTracks.length);
		trace("Subtitles included: " + subtitlesNumber);
		trace("------------------------------------");
		trace("selectedSubtitle='" + selectedSubtitle + "'");
		trace("selectedAudio='" + selectedAudio + "'");
		trace("------------------------------------");
		for(var i:Number = 0; i<AudioTracks.length; ++i)
		{
			trace("  AudioTracks["+i+"].trackIndex="+AudioTracks[i].trackIndex);
		}
		trace("------------------------------------");
	}
	
	ns.audioTrack = AudioTracks[ selectedAudio - 1 ].trackIndex;
	ns.subtitleTrack = selectedSubtitle;
}

if (AudioTracks != undefined && AudioTracks.length > 0)
{
	selectedAudio = AudioTracks[0].trackIndex;
}

ns.onSubtitle = function(msg:String)
{
	if(_root.showSubtitle == true)
	{
		_root.Subtitles.Subtitles_text.text = msg;
		
		var Zeilen = _root.Subtitles.Subtitles_text.bottomScroll;
		 _root.Subtitles._y = 650 - (Zeilen * 30)
	}
}