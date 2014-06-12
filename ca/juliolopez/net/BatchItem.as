/****************************************************************
TITLE:			BatchItem
AUTHOR:			Julio Lopez
LAST UPDATED: 	2010-03-30
DESCRIPTION:	Object that represents an item in a BatchLoader List

****************************************************************/
package lifelearn.net {

	import flash.display.Loader;
	
	dynamic public class BatchItem extends Object {
		/*******************************  Properties  ********************************/
		/* Constants: ****************************************************************/
		
		/* Public Properties: ********************************************************/
		public var loader:*;
		
		public var hasInited:Boolean = false;
		public var hasLoaded:Boolean = false;
		public var hasOpened:Boolean = false;
		
		public var loaded:Number = 0;
		public var total:Number = 0;
		
		public var file:String = "";
		
		/* Private Properties: *******************************************************/

		/* Protected Properties: *****************************************************/
		
		
		/********************************  Methods  **********************************/
		/* Constructor: **************************************************************/
		public function BatchItem() {
		}
	
		/* Public Methods: ***********************************************************/
		
		// toString()
		// returns a string representation of the Batch Item
		public function toString():String {
			var meAsString:String = "";
			
			meAsString += "File: " + file;
			meAsString += ", Bytes Loaded: " + loaded;
			meAsString += ", Bytes Total: " + total;
			meAsString += ", Stream Opened: " + hasOpened;
			meAsString += ", Has Loaded: " + hasLoaded;
			if (loader is Loader) meAsString += ", Has Content Initialized: " + hasInited;
			
			return meAsString;
		}
		
		/* Protected Methods: ********************************************************/
		
		/* Private Methods: **********************************************************/
	}
}