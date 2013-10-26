/****************************************************************
TITLE:			monthToString
AUTHOR:			Julio Lopez
LAST UPDATED: 	2011-01-318
DESCRIPTION:	A function to see if an array contains a particular value

****************************************************************/
package ca.juliolopez.utils.date {
	
	/**
	 * Takes a number between 0 and 11 and returns a string representation of that month
	 * 
	 * @param m		int. Integer between 0 and 11
	 * @return 		String. Textual representation of the month
	 */
	public function monthToString(m:int):String {
		if (m < 0 || m > 11) return "";
		
		switch(m) {
			case 0:
				return "January";
			case 1:
				return "February";
			case 2:
				return "March";
			case 3:
				return "April";
			case 4:
				return "May";
			case 5:
				return "June";
			case 6:
				return "July";
			case 7:
				return "August";
			case 8:
				return "September";
			case 9:
				return "October";
			case 10:
				return "November";
			default:
				return "December";
		}
	}
	
}