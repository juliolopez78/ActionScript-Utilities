/****************************************************************
TITLE:			Is SWF Studio App
AUTHOR:			Julio Lopez
LAST UPDATED: 	2010-12-10
DESCRIPTION:	A function for to determine if the flash file is a SWF Studio app

****************************************************************/
package ca.juliolopez.utils.system {
	
	import flash.system.Capabilities;
	import flash.utils.getDefinitionByName;
	import lifelearn.utils.variables.isEmpty;
	
	public function isSWFStudioApp():Boolean {
		var isSWFStudio:Boolean;	//Assume that it is not in SWFStudio
		var ssg:*;
		
		//check to see if playing as an ActiveX object
		if (Capabilities.playerType == "ActiveX") {
			//if so, try to find the SWFStudio ssGlobals object
			try {
				ssg = getDefinitionByName('ssGlobals');
			} catch (e:ReferenceError) {
				ssg = null;
			}
			
			// if we have it
			if (!isEmpty(ssg)) {
				// and the ssFileType is set, then we are in SWFStudio
				if (ssg.hasOwnProperty('ssFileType')) isSWFStudio = true;
			}
		}
		
		return isSWFStudio;
	}
	
}