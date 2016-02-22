/**
 * Speedometer demo file
 * @author Simon Bursey
 */

/* Initialise shared variables */
var m_gearSpeedArray:Array = new Array(0.0,3.5,6.5,13,17,27.7,45);
var m_totalGears:Number = m_gearSpeedArray.length;
var g_allowFakeRevsAndGears:Boolean = true;
var m_previousGear:Number = 0;
var REVS_REVERSE_MAX = -60;

/* Array for gear speeds passed in from flowgraph, call SetFakeGearSpeeds to activate it */
var g_newGearSpeedArray = new Array(0.0,4,15,45);

function AllowFakeRevsAndGears( _allowFakeRevsAndGears:Boolean )
{
	/* When this is true, Revs and Gears will be faked when you call UpdateSpeedometer */
	g_allowFakeRevsAndGears = _allowFakeRevsAndGears;
}

function SetFakeRevsAndGears( _currentSpeed )
{
	var m_currentGearInArray:Number = 0;
	var m_DialMinimum:Number = 0;
	var m_DialCurrent:Number = 0;
	var m_DialMaximum:Number = 100;
	
	/* Fake the gear and based on the current speed */
	
	if ( _currentSpeed > m_gearSpeedArray[0])
	{
		for (i:Number = 0; i < m_totalGears; i++)
		{
			if ( _currentSpeed > m_gearSpeedArray[i] )
			{
				m_currentGearInArray = i;
			}
		}
		TF_Gear.text = m_currentGearInArray + 1;
		
			/* Fake the revs and based on the current forward gear and speed */
			m_DialMinimum = m_gearSpeedArray[m_currentGearInArray];
			m_DialMaximum = m_gearSpeedArray[m_currentGearInArray + 1];
	}
	else if ( _currentSpeed < -0.0)
	{
		TF_Gear.text = "R";
		m_DialMinimum = 0.0;
		m_DialMaximum = REVS_REVERSE_MAX;
	}

	UpdateDial(m_DialMinimum, _currentSpeed, m_DialMaximum);
}

function SetFakeGearSpeeds()
{
	/* Pass in an array of the speeds you want the gears to change at */
	/* Must have at least 2 entries as the last entry is used for rev limit */
	trace("New Gear Speed Array: " + g_newGearSpeedArray);
	if (g_newGearSpeedArray.length >= 2)
	{
		m_gearSpeedArray = g_newGearSpeedArray;
		m_gearSpeedArray.sort( Array.NUMERIC );
		m_totalGears= m_gearSpeedArray.length;
	}
}