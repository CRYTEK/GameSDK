/**
 * Speedometer demo file
 * @author Simon Bursey
 */

 #include "Demo_Speedo_FakeRevsAndGears.as"
 
/* Set the range of angles the dial can cover */
var DIAL_ZERO_ANGLE:Number = -180;
var DIAL_MAXIMUM_ANGLE:Number = 50;
var DIAL_RANGE:Number = -DIAL_ZERO_ANGLE + DIAL_MAXIMUM_ANGLE;

var MPS_MULTIPLIER = 1;
var MPH_MULTIPLIER =  2.23694;
var KMH_MULTIPLIER = 3.6;
var KN_MULTIPLIER = 1.94384;

var m_speedUnitMultiplier = KMH_MULTIPLIER;

function SetSpeedUnits( _speedUnits:String )
{
	if ( _speedUnits.toLowerCase() == "mps" )
	{
		m_speedUnitMultiplier = MPS_MULTIPLIER;
		MC_SpeedUnits.text = "mps";
	}
	if ( _speedUnits.toLowerCase() == "kmh" )
	{
		m_speedUnitMultiplier = KMH_MULTIPLIER;
		MC_SpeedUnits.text = "KMH";
	}
	if ( _speedUnits.toLowerCase() == "mph" )
	{
		m_speedUnitMultiplier = MPH_MULTIPLIER;
		MC_SpeedUnits.text = "MPH";
	}
	if ( ( _speedUnits.toLowerCase() == "knots") || ( _speedUnits.toLowerCase() == "kn")  )
	{
		m_speedUnitMultiplier = KN_MULTIPLIER;
		MC_SpeedUnits.text = "KN";
	}
}

function UpdateSpeedometer( _speed:Number)
{
	if (g_allowFakeRevsAndGears == true)
	{
		SetFakeRevsAndGears(_speed);
	}
	
	TF_Speed.text = Math.abs( Math.round( _speed * m_speedUnitMultiplier ) );
}

function UpdateDial( _minimum:Number, _current:Number, _maximum:Number)
{
	var m_dialScalar:Number = ( (_current - _minimum) / (_maximum - _minimum) );
	var m_dialAngle:Number = DIAL_RANGE * m_dialScalar;
	
	MC_Dial._rotation = DIAL_ZERO_ANGLE + m_dialAngle;
}

function UpdateGear( _gear:String )
{
	TF_Gear.text = _gear;
}