/****************************************************************
TITLE:			inArray
AUTHOR:			Julio Lopez
LAST UPDATED: 	2010-11-30
DESCRIPTION:	A function to see if an array contains a particular value

****************************************************************/
package ca.juliolopez.utils.array {
	
	/**
	 * Determines whether a value exists within an array
	 * 
	 * @param needle		*. Value to look for within the array
	 * @param haystack		Array. Array that will be searched
	 * @return 				Boolean. True if haystack contains needle, false otherwise
	 */
	public function inArray(needle:*, haystack:Array):Boolean {
		// if the index of needle is greater than -1, return true. Return false otherwise.
		return (haystack.indexOf(needle) != -1);
	}
	
}