/****************************************************************
TITLE:			To Comma Delimited String
AUTHOR:			Julio Lopez
LAST UPDATED: 	2011-01-019
DESCRIPTION:	Returns a comma delimited string like 1,000,000 from 1000000

****************************************************************/
package ca.juliolopez.utils.number {;
	
	public function toCommaDelimited(n:Number):String {
		var nStr:String = n.toString().split(".")[0];	//strip off decimal
		var dec:String = "";							//holder for the decimals
		var len:int = nStr.length;						//count the number of digits
		var commStr:String = "";						//the return string
		var digitCount:int = 0;							//a counter variable
		var strBits:Array;								//a holder for each individual digit
		
		//catch the decimal values if they exist
		if (n.toString().split(".").length > 1) dec = n.toString().split(".")[1];
		
		//if 'n' is longer than 3 digits then add commas
		if (len > 3) {
			//split the number into individual digits
			strBits = nStr.split("");
			//loop through the digits backwards and add them to the return string
			for(var i = (len - 1); i > -1; i--) {
				commStr = strBits[i] + commStr;
				digitCount += 1;	//count one more digit added
				//if the count is a multiple of 3 add a comma
				if (digitCount % 3 == 0) commStr = "," + commStr;
			}
			
			//clear off any leading commas because the function will add a leading comma when the
			//length of the number is a multiple of 3 like: ,250,000,000
			if (commStr.indexOf(",") == 0) {
				commStr = commStr.substr(1);
			}
		} else {
			commStr = nStr;
		}
		
		//add decimals on if they exist
		return commStr + ((dec != "") ? ("." + dec) : "");
	}
	
}