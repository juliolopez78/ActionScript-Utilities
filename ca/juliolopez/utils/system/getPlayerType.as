/****************************************************************
TITLE:			Get Player Type
AUTHOR:			Julio Lopez
LAST UPDATED: 	2010-12-10
DESCRIPTION:	A function that returns the player type

****************************************************************/
package ca.juliolopez.utils.system {
	import ca.juliolopez.utils.system.*;
	
	public function getPlayerType():String {
		//uses the other ca.juliolopez.utils.system functions to figure 
		//out what player type is playing the current swf
		switch(true) {
			case isInAir():
				return PlayerTypes.AIR;
				break;
			case isInBrowser():
				return PlayerTypes.BROWSER;
				break;
			case isInExternalPlayer():
				return PlayerTypes.EXTERNAL;
				break;
			case isInStandAlonePlayer():
				return PlayerTypes.STAND_ALONE;
				break;
			case isSWFStudioApp():
				return PlayerTypes.SWF_STUDIO;
				break;
			default:
				return "";
				break;
		}
	}
	
}