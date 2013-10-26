/****************************************************************
TITLE:			isEmpty
AUTHOR:			Julio Lopez
LAST UPDATED: 	2010-06-15
DESCRIPTION:	A function for determining if a variable is empty
				empty = null, "", 0, undefined, false, NaN, or empty array

****************************************************************/
package ca.juliolopez.utils.variables {
	
	public function isEmpty(v:*):Boolean {
		var empty:Boolean = false;
		//check the value of v
		switch(v) {
			case null:
			case undefined:
			case 0:
			case false:
			case "":
				//if it is any of the above values then it is empty
				empty = true;
				break;
			default:
				//check the type and test to see if it is empty
				switch (true) {
					case (v is Number):
						if (isNaN(v)) empty = true;
						break;
					case (v is Array):
						if (v.length == 0) empty = true;
						break;
					case (v is XMLList):
						if (v.length() == 0) empty = true;
						break;
				}
		}
		return empty;
	}
	
}