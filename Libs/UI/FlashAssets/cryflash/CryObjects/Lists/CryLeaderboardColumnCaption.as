/**
 * ...
 * @author manuelb
 */

import cryflash.CryObjects.Lists.CryLeaderboardCell;
import cryflash.CryObjects.Lists.CryLeaderboard;
 
class cryflash.CryObjects.Lists.CryLeaderboardColumnCaption extends CryLeaderboardCell {
	private var TEMPLATE_NAME:String = "TempLeaderboardColumnCaption"; 
	
	public function CryLeaderboardColumnCaption(id:String, text, container) {
		super(id, TEMPLATE_NAME, container);
		setCaption(text);
	}
}