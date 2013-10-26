/****************************************************************
TITLE:			trim
AUTHOR:			Julio Lopez
LAST UPDATED: 	2010-06-15
DESCRIPTION:	A function that you think ActionScript would have,
				but doesn't. it trims off whitespace from the
				beginning and end of a string

****************************************************************/
package ca.juliolopez.utils.string {
	
	public function trim(str:String):String {
		//use a reg ex to look for and replace all whitespace with an empty string
		return str.replace(/^\s+|\s+$/g, "");
	}
	
}