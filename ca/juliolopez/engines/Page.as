/****************************************************************
TITLE:			Page
AUTHOR:			Julio Lopez
LAST UPDATED: 	2010-04-05
DESCRIPTION:	Ancestor object that defines a lot of the  
				functionality for each of the program's
				individual pages.

****************************************************************/
package ca.juliolopez.engines {
		
	//import fl.core.UIComponent;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Loader;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	
	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.MouseEvent;
	import flash.events.IOErrorEvent;
	
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	
	import ca.juliolopez.ui.scrollbar.Scrollbar;
	import ca.juliolopez.utils.*;
	import ca.juliolopez.net.*;
	
	dynamic public class Page extends MovieClip{
		/*******************************  Properties  ********************************/
		
		/* Constants: ****************************************************************/
		
		/* Public Properties: ********************************************************/
		
		/* Private Properties: *******************************************************/
		
		/* Protected Properties: *****************************************************/
		protected var clickables:Array = new Array();		// Collection of clickable objects that can be enabled or disabled
		
		protected var parentClip:Loader;					// Reference to the Loader object that loaded the page
		protected var module:MovieClip;						// Reference to the module object that the page belongs to
		
		protected var comm:Communicator;
		
		/* UI Elements: **************************************************************/
		
		
		/********************************  Methods  **********************************/
		
		/* Constructor: **************************************************************/
		public function Page() {
			stop();											// Stops main timeline
			addEventListener(Event.ADDED_TO_STAGE,init);	// Set up listener to run init() when page has been added to the stage
		}
	
		/* Public Methods: ***********************************************************/		
		// disable():void
		// Disables all clickable UI elements. Usually used when a popup is shown or 
		// when focus needs to be diverted to a particular page element. Calls private
		// function _disableUI().
		public function disable():void {
			_disableUI();
		}	
		
		// enable():void
		// Enables all clickable UI elements. Usually used when a popup is hidden or 
		// when focus needs to be returned to entire app. Calls private function _disableUI().
		public function enable():void {
			_enableUI();
		}	
		
		// addToClickables(... c):void
		// Adds clickable ui elements to the clickables array. Usually buttons or movieclips
		// @... c	DisplayObject List. One or more objects that are MovieClip, SimpleButton or Sprite
		public function addToClickables(... c):void {
			for (var i:uint = 0; i < c.length; i++) {
				var d:DisplayObject = c[i] as DisplayObject;
				
				if (d is MovieClip) {
					clickables.push(d as MovieClip);
				} else if (d is SimpleButton) {
					clickables.push(d as SimpleButton);
				} else if (d is Sprite) {
					clickables.push(d as Sprite);
				}
			}
		}	
		
		// removeFromClickables(d:DisplayObject):void
		// Removes a clickable ui elements from the clickables array. Usually a button or movieclip
		// @d	DisplayObject. An objects that is either MovieClip, SimpleButton or Sprite
		public function removeFromClickables(d:DisplayObject):void {
			var ndx:Number = clickables.indexOf(d);
			if (ndx > -1) {
				clickables.splice(ndx,1);
			}
		}
		
		/* Protected Methods: ********************************************************/
		// configUI():void 
		// Startup routine that runs when the object is added to the stage.
		protected function configUI():void {
			// Create reference to loader object
			parentClip = parent as Loader;
			
			// Create reference to module object if page has been loaded into a module
			if (parentClip != null) module = parentClip.parent as MovieClip;
			
			// Add event listeners to the comm object in order to handle server communication.
			
			comm = new Communicator();
			comm.complete = serverResponse;
			comm.ioError = ioError;
		}
		
		// removeAllChildren():void 
		// Cleanup routine that removes all chldren from the display list.
		// needed when the page needs to be removed soon after it has been
		// loaded to avoid run-time errors
		protected function removeAllChildren():void {
			var nc:Number = numChildren
			for (var i:int = (nc - 1); i > -1; i--) {
				removeChildAt(i);
			}
		}
		
		// init(e:Event):void
		// Event Handler. Triggered when the Page has been added to the stage.
		// Removes the event listener and calls configUI() to initialize the object
		// @e:		Event. ADDED_TO_STAGE event.
		protected function init(e:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE,init);
			
			configUI();
		}
		
		// serverResponse(e:Event):void
		// Event Handler. Triggered when the Page has received data from the server.
		// This is a template function that will most likely be overridden in a descendant instance
		// @e:		Event. COMPLETE event
		protected function serverResponse(e:Event):void {
		}
		
		// ioError(e:IOErrorEvent):void
		// Event Handler. Triggered when an IO error is encountered during communication with the server.
		// Traces the error message to the output window
		// This is a template function that can be overridden in a descendant instance
		// @e:		IOErrorEvent. IO_ERROR event.
		protected function ioError(e:IOErrorEvent):void {
		}
		
		// openPopup(e:MouseEvent):void
		// Event Handler. Triggered when the a popup movie clip needs to be opened.
		// Disables all applicable UI elements by calling _disableUI();
		// This is a template function that will be overridden in a descendant instance
		// @e:		MouseEvent. CLICK event
		protected function openPopup(e:MouseEvent):void {
			_disableUI();
		}
		
		// closePopup(e:MouseEvent):void
		// Event Handler. Triggered when the a popup movie clip needs to be closed.
		// Enables all applicable UI elements by calling _enableUI();
		// This is a template function that will be overridden in a descendant instance
		// @e:		MouseEvent. CLICK event
		protected function closePopup(e:MouseEvent):void {
			_enableUI();
		}
		
		// Private Methods: **********************************************************/
		// _disableUI():void
		// Disables all clickable UI elements on the page as well as in the Module.
		private function _disableUI():void {
			if (module != null) module.disableButtons();
			
			for (var i:uint = 0; i < clickables.length; i++) {
				clickables[i].enabled = false;
				clickables[i].mouseEnabled = false;
				
				if (clickables[i] is Scrollbar) {
					clickables[i].disable();
				}
			}
		}
		
		// _enableUI():void
		// Enables all clickable UI elements on the page as well as in the Module.
		private function _enableUI():void {
			if (module != null) module.enableButtons();
			
			for (var i:uint = 0; i < clickables.length; i++) {
				clickables[i].enabled = true;
				clickables[i].mouseEnabled = true;
				
				if (clickables[i] is Scrollbar) clickables[i].enable();
			}
		}
		
	}
	
}