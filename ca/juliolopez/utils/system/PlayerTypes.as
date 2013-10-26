package ca.juliolopez.utils.system {
	
	/**
	 * Constants that define the 5 player types
	 * @author Julio Lopez
	 */
	public class PlayerTypes extends Object {
		// Indicates an air application
		public static const AIR:String = "air";
		
		// Indicates a swf in a browser
		public static const BROWSER:String = "browser";
		
		// Indicates a swf in the stand-alone player or as a projector
		public static const STAND_ALONE:String = "standAlone";
		
		// Indicates a movie in test mode
		public static const EXTERNAL:String = "external";
		
		// Indicates a SWF Studio application
		public static const SWF_STUDIO:String = "swfStudio";
		
		public function PlayerTypes() {}
	}
	
}