//Container for scoreboard

class scripts.HUD.PlayerForScoreboard
{
	var m_Name:String;
	var m_KD:String;
	var m_Team:String;
	var m_Ping:Number;
	var m_Id:Number;
	var m_Kills:Number;
	var m_Deaths:Number;
	var m_InfoField:MovieClip;
	
	
	public function PlayerForScoreboard(_id:Number, _playername:String, _infoField:MovieClip, _team:String)
	{
		m_InfoField = _infoField;
		m_Name = _playername;
		m_Team = _team; 
		m_Id = _id;
		m_Kills = 0; m_Deaths = 0;m_Ping = 0;
		m_InfoField.NameField.text = m_Name;
		m_InfoField.KillField.text = m_Kills;
		m_InfoField.DeathField.text = m_Deaths; 
		m_InfoField.TeamField.text = m_Team;
	}
	private function KDratio(D:Number, K:Number):String
	{
		var ratio:Number;
		if(D === 0 ||  K === 0)
		{
			ratio = 1;
		}
		else
		{
			ratio = (K / D);
		}
		return(String(ratio));
	}
	public function Update()
	{
		m_InfoField.NameField.text = m_Name;
		m_InfoField.KillField.text = m_Kills;
		m_InfoField.DeathField.text = m_Deaths;
		m_InfoField.PingField.text = String(m_Ping);
		m_InfoField.TeamField.text = m_Team;
		m_InfoField.KDField.text = KDratio(m_Deaths, m_Kills);
	
		
	}
}