/****************************************************************
TITLE:			Constants
AUTHOR:			Julio Lopez
LAST UPDATED: 	2010-03-30
DESCRIPTION:	Static object that will contain most of the 
				constants required in the program.

****************************************************************/
package ca.juliolopez.variables {
	
	public final class Constants extends Object {
		/*******************************  Properties  ********************************/
		
		/* Constants: ****************************************************************/
		// Default Asset Paths
		public static const SWF_PATH = "./assets/swfs/";			// Path to swf assets
		public static const XML_PATH = "./assets/xml/";				// Path to xml assets
		public static const JPG_PATH = "./assets/jpgs/";			// Path to jpg assets
		public static const GIF_PATH = "./assets/gifs/";			// Path to gif assets
		public static const PNG_PATH = "./assets/pngs/";			// Path to png assets
		public static const VID_PATH = "assets/video/";				// Path to video assets
		public static const SND_PATH = "./assets/audio/";			// Path to audio assets
		public static const SKN_PATH = "./assets/skins/";			// Path to skin assets
		public static const PDF_PATH = "./assets/pdfs/";			// Path to PDF assets
		
		// Default paths to home and modules
		public static const HOME_PATH = "./assets/swfs/home.swf";	// Path to home swf
		public static const MOD_PATH = "./assets/swfs/main.swf";	// Path to default module swf
		public static const MOD_XML_PATH = "./assets/xml/main.xml";	// Path to default module xml
	
		/********************************  Methods  **********************************/
		
		/* Constructor: **************************************************************/
		public function Constants() { }
	}
	
}