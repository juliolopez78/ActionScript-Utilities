/****************************************************************
TITLE:			Is Air
AUTHOR:			Julio Lopez
LAST UPDATED: 	2010-12-10
DESCRIPTION:	A function for to determine if the flash file is an Air app

****************************************************************/
package ca.juliolopez.utils.system {
	
	import flash.system.Capabilities;
	
	public function isInAir():Boolean {
		return Capabilities.playerType == "Desktop";
	}
	
}