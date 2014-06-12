/****************************************************************
TITLE:			DynamicSoundEvent
AUTHOR:			Julio Lopez
LAST UPDATED: 	2010-06-04
DESCRIPTION:	DynamicSoundEvent Class

****************************************************************/
package lifelearn.events {

	import flash.events.Event;
	
	public class DynamicSoundEvent extends Event {
		/*******************************  Properties  ********************************/
		
		/* Constants: ****************************************************************/
		public static const PLAY:String = 'play';
		public static const STOP:String = 'stop';
		public static const PAUSE:String = 'pause';
		public static const FADE_COMPLETE:String = 'fadeComplete';
		public static const SOUND_COMPLETE:String = 'soundComplete';
		public static const LOOP:String = 'loop';
		
		public var position:Number;
		
		/* Public Properties: ********************************************************/
		
		/* Private Properties: *******************************************************/
		
		/* Protected Properties: *****************************************************/
		
		/* UI Elements: **************************************************************/
		
		
		/********************************  Methods  **********************************/
		
		/* Constructor: **************************************************************/
		public function DynamicSoundEvent(t:String,b:Boolean=false,c:Boolean=false,p:Number=NaN) {
			super(t, b, c);
			position = p;
		}
	
		/* Public Methods: ***********************************************************/
		override public function clone():Event {
			return new DynamicSoundEvent(type,bubbles,cancelable);
		}
		
		override public function toString():String {
			var base:String = super.toString();
			var retStr:String;
			
			retStr = "[DynamicSound" + base.substr(1) + " position=" + position + "]";
			
			return retStr;
		}
		/* Protected Methods: ********************************************************/
		
		/* Private Methods: **********************************************************/
		
	}
	
}