/****************************************************************
TITLE:			Is in Stand-Alone Player
AUTHOR:			Julio Lopez
LAST UPDATED: 	2010-12-10
DESCRIPTION:	A function for to determine if the flash file is in the Stand-alone player

****************************************************************/
package ca.juliolopez.utils.system {
	
	import flash.system.Capabilities;
	
	public function isInStandAlonePlayer():Boolean {
		return Capabilities.playerType == "StandAlone";
	}
	
}