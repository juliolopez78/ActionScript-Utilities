/****************************************************************
TITLE:			Is in External Player
AUTHOR:			Julio Lopez
LAST UPDATED: 	2010-12-10
DESCRIPTION:	A function for to determine if the flash file is playing in the flash test mode

****************************************************************/
package ca.juliolopez.utils.system {
	
	import flash.system.Capabilities;
	
	public function isInExternalPlayer():Boolean {
		return Capabilities.playerType == "External";
	}
	
}