/****************************************************************
TITLE:			Is In Browser
AUTHOR:			Julio Lopez
LAST UPDATED: 	2010-12-10
DESCRIPTION:	A function for to determine if the flash file is playing in the browser

****************************************************************/
package ca.juliolopez.utils.system {
	
	import flash.system.Capabilities;
	import flash.utils.getDefinitionByName;
	import lifelearn.utils.variables.isEmpty;
	
	public function isInBrowser():Boolean {
		var inBrowser:Boolean;		//Assume that it is not in the browser
		var ssg:*;
		
		//if playerType is ActiveX or Plugin it could be in the browser, but not necessarily
		if (Capabilities.playerType == "ActiveX" || Capabilities.playerType == "PlugIn") {
			//SwfStudio plays swfs with ActiveX so we look for a swfstudio object
			try {
				ssg = getDefinitionByName('ssGlobals');
			} catch (e:ReferenceError) {
				ssg = null;
			}
			
			//if there is no ssGlobals, then it is playing in a browser
			if (isEmpty(ssg)) {
				inBrowser = true;
			} else {
				//if we do get an object but it does not have the ssFileType set
				//it is also in a browser
				if (!ssg.hasOwnProperty('ssFileType')) inBrowser = true;
			}
		}
		
		return inBrowser;
	}
	
}