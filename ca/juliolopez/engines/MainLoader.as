/****************************************************************
TITLE:			MainLoader
AUTHOR:			Julio Lopez
LAST UPDATED: 	2010-03-30
DESCRIPTION:	Main Loader file. this file takes care of all the
				loading and unloading of the Modules as well as
				of the Module gallery where the user choses what
				Module they want to do

****************************************************************/
package ca.juliolopez.engines {
	
	import fl.controls.ProgressBar;
	import fl.controls.ProgressBarDirection;
	import fl.controls.ProgressBarMode;
	
	import fl.transitions.Tween;
	import fl.transitions.easing.*;
	import fl.transitions.TweenEvent;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	
	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.events.ProgressEvent;
	
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	
	import flash.system.Capabilities;
	
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import flash.ui.ContextMenu;
	
	import ca.juliolopez.variables.Constants;
	import ca.juliolopez.utils.*;
	import ca.juliolopez.net.*;
	
	dynamic public class MainLoader extends MovieClip{
		/*******************************  Properties  ********************************/
		
		/* Constants: ****************************************************************/
		//Duration of alpha tween
		public const FADE_DURATION:Number = 0.5;		
		public const HOME_COMPLETE:String = "homeComplete";	
		public const SHOW_ERROR:String = "showError";
		public const HIDE_ERROR:String = "hideError";
		
		/* Public Properties: ********************************************************/
		//Context Menu.
		public var cMenu:ContextMenu;					//cMenu is used to disable the menu items from the right-click context menu
		
		//Loaders.
		public var homeLoader:Loader;					//homeLoader loads the Module Gallery
		public var modLoader:Loader;					//modLoader loads the modules
		
		//MovieClips.
		public var home:MovieClip;						//home holds the content of the Module Gallery.
		public var module:MovieClip;					//module holds the content of the selected module
		public var error_mc:MovieClip					//error alert box
		
		//ProgressBar.
		public var progBar_mc:ProgressBar;				//The progress bar for all loading operations
		
		//Tweens.
		public var fadeIn:Tween;						//tweens the target's alpha from 0 to 1
		public var fadeOut:Tween;						//tweens the target's alpha from 1 to 0
		
		//URLRequests. 
		public var homePath:URLRequest;					//path to the Module Gallery swf
		public var modPath:URLRequest;					//path to the Module
		public var modXMLPath:URLRequest;				//path to xml file that contains all the menu and page information for a particular module
		
		/* Protected Properties: *******************************************************/
		//Flags
		protected var countHits:Boolean;				//flag to determine whether or not we need to count hits on this swf
		protected var hasHomePage:Boolean;				//flad to determine if a home page should be loaded of if a module gets loaded.
		
		//Communicator.
		protected var comm:Communicator;				//comm handles all communication between Flash and the server
		
		
		/********************************  Methods  **********************************/
		
		/* Constructor: **************************************************************/
		public function MainLoader(ch:Boolean=false,hhp:Boolean=true) {
			init(ch,hhp);										//initializes the MainLoader object
		}
	
		/* Public Methods: ***********************************************************/
		// loadModule(swf)
		// Begins the Module loading process by setting the path to the module and
		// fading the module gallery out. 
		// @swf:		String. Contains path to module swf
		public function loadModule(swf:String,xml:String):void {
			modPath = new URLRequest(swf);
			modXMLPath = new URLRequest(xml)
			transitionOut(home);
			fadeOut.addEventListener(TweenEvent.MOTION_FINISH, _hideHome);
		}
		
		// unloadModule()
		// Begins the module unloading process by fading the module gallery back in.
		public function unloadModule():void {
			home.alpha = 1;
			home.visible = true;
			transitionOut(modLoader);
			fadeOut.addEventListener(TweenEvent.MOTION_FINISH, _unloadMod);
		}
		
		// transitionIn(o)
		// Sets fadeIn to tween the alpha of the parameter object from 0 to 1. 
		// @o:		Object. The object whose alpha to tween
		public function transitionIn(o:Object):void {
			fadeIn = new Tween(o, "alpha", Strong.easeOut, 0, 1, FADE_DURATION, true);
		}
		
		// transitionOut(o)
		// Sets fadeOut to tween the alpha of the parameter object from 1 to 0. 
		// @o:		Object. The object whose alpha to tween
		public function transitionOut(o:Object):void {
			fadeOut = new Tween(o, "alpha", Strong.easeOut, 1, 0, FADE_DURATION, true);
		}
		
		/* Protected Methods: ********************************************************/
		// init()
		// Startup routine that runs when the object is instantiated.
		protected function init(ch:Boolean=false,hhp:Boolean=true):void {
			// set whether we are counting hits or not
			countHits = ch;
			
			// set if program has home page or not
			hasHomePage = hhp;
			
			// Hide the built in menu items for teh context menu
			cMenu = new ContextMenu();
			cMenu.hideBuiltInItems();
			contextMenu = cMenu;
			
			// Set up error window
			error_mc.visible = false;
			error_mc.b_e.addEventListener(MouseEvent.CLICK,_hideError);
			
			var eTtlFmt:TextFormat = error_mc.errTitle_txt.getTextFormat();
			eTtlFmt.bold = true;
			error_mc.errTitle_txt.defaultTextFormat = eTtlFmt;
			
			var eMsgFmt:TextFormat = error_mc.errorList_txt.getTextFormat();
			error_mc.errorList_txt.defaultTextFormat = eMsgFmt;
			
			// Set up event listener to continue object setup once it is completely loaded 
			root.loaderInfo.addEventListener(Event.COMPLETE, _imLoaded)
			
			// Set up module loader and its event listeners. It will listen for when a
			// module is initialized as well as if there is an IO error.
			modLoader = new Loader();
			modLoader.contentLoaderInfo.addEventListener(Event.INIT, _modLoaded);
			modLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, _modError);
			
			// Set up module gallery loader and its event listeners. It will listen for when the
			// module gallery is initialized as well as if there is an IO error.
			homeLoader = new Loader();
			homeLoader.contentLoaderInfo.addEventListener(Event.INIT, _homeLoaded);
			homeLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, _homeError);
			
			// Set up path to the module gallery swf
			homePath = new URLRequest(Constants.HOME_PATH);
			
			// Set up event listenerS for custom events:
			// This event it triggered when the module gallery is ready to be displayed.
			addEventListener(HOME_COMPLETE, _homeComplete);
			// This event it triggered when an error needs to be displayed.
			addEventListener(SHOW_ERROR, _showError);
			
			// create comm and add event listeners to the comm object if needed
			if (countHits) {
				comm = new Communicator();
				comm.complete = _serverResponse;
				comm.ioError = _ioError;
			}
		}
		
		// Private Methods: **********************************************************/
		// _imLoaded(e)
		// Event Handler. Triggered when the MainLoader has completely loaded.
		// Starts the loading of the Module Gallery and sets up the progress bar to
		// monitor the load progress.
		// @e:		Event. COMPLETE event.
		private function _imLoaded(e:Event):void {
			if (hasHomePage) {
				homeLoader.load(homePath);
				progBar_mc.source = homeLoader.contentLoaderInfo;
			} else {
				modPath = new URLRequest(Constants.MOD_PATH);
				modXMLPath = new URLRequest(Constants.MOD_XML_PATH);
				modLoader.load(modPath);
				progBar_mc.source = modLoader.contentLoaderInfo;
			}
		}
		
		// _homeLoaded(e)
		// Event Handler. Triggered when the Module Gallery has completely loaded.
		// Adds the Module Gallery to the display list, begins loading 'modules.xml'
		// and sets up the progress bar to monitor the xml load progress.
		// @e:		Event. COMPLETE event.
		private function _homeLoaded(e:Event):void {
			addChild(homeLoader);
			home = homeLoader.content as MovieClip;
		}
		
		// _serverResponse(e)
		// Event Handler. Triggered when the Page has received data from the server.
		// @e:		Event. COMPLETE event
		protected function _serverResponse(e:Event):void {
			var json:String = e.target.data;
			var rslt:* = JSON.deserialize(json);
			//Console.log(json);
		}
		
		// _modLoaded(e)
		/* Event Handler. Triggered when the Module has completely loaded and has been initialized.
		   The following actions are executed:
			- Adds the Module to the display list
			- Hides the progress bar
		   	- Creates a reference to the loaded module and saves it in the 'module' property
			- Creates a reference to the MainLoader and saves it in teh module's 'parentLoader' property
			- Tells the Module to begin loading the menu and page data contained in an xml file
		   @e:		Event. INIT event. */
		private function _modLoaded(e:Event):void {
			addChild(modLoader);
			progBar_mc.visible = false;
			module = modLoader.content as MovieClip;
			module.parentLoader = this as MovieClip;
			module.xmlLoader.load(modXMLPath);
		}
		
		// _homeComplete(e)
		/* Event Handler. Triggered when a Module in the Module Gallery is ready to be displayed.
		   The following actions are executed:
			- creates local boolean allLoaded and sets it to true
			- creates local array and populates it with a list of module clips from the gallery
		   	- updates the progress bar to indicate the load progress of the modules
			- checks to see if all modules have been loaded. Sets allLoaded to false if not all loaded
			- if allLoaded is still true the progress bar is hidden, the module gallery interface is
			  displayed and the server is contacted in order to register a hitcount for the home page
		   @e:		Event. homeComplete event (custom event). */
		private function _homeComplete(e:Event):void {
			home.visible = true;
			transitionIn(home);
			progBar_mc.visible = false;
			progBar_mc.reset();
			progBar_mc.mode = ProgressBarMode.EVENT;
			
			if (countHits) {
				if (Capabilities.playerType == "ActiveX" || Capabilities.playerType == "PlugIn") {
					comm.variables = { pId : 1 };
					comm.load("hitcount.php");
				}
			}
		}
		
		// _showError(e)
		/* Event Handler. Triggered when an error alert needs to be displayed.
		   The following actions are executed:
			- error_mc is re-added to display list in order to put it at the top
			- error_mc's visibility is set to true
		   @e:		Event. showError event (custom event). */
		private function _showError(e:Event):void {
			addChild(error_mc);
			error_mc.visible = true;
		}
		
		// _homeError(e)
		// Event Handler. Triggered when the loading of the Module Gallery encounters an IO error.
		// Traces the error message to the output window
		// @e:		IOErrorEvent. IO_ERROR event.
		private function _homeError(e:IOErrorEvent):void {
			//Handle IOError Event
			error_mc.errTitle_txt.text = "File Error";
				
			error_mc.errorList_txt.text = "Unable to load Home Page.";
			
			dispatchEvent(new Event(SHOW_ERROR)); 
		}
		
		// _modError(e)
		// Event Handler. Triggered when the loading of a Module encounters an IO error.
		// Traces the error message to the output window
		// @e:		IOErrorEvent. IO_ERROR event.
		private function _modError(e:IOErrorEvent):void {
			//Handle IOError Event
			error_mc.errTitle_txt.text = "File Error";
				
			error_mc.errorList_txt.text = "Unable to load Module.";
			
			dispatchEvent(new Event(SHOW_ERROR)); 
		}
		
		// _ioError(e)
		// Event Handler. Triggered when communication with the server encounters an IO error.
		// Traces the error message to the output window
		// @e:		IOErrorEvent. IO_ERROR event.
		private function _ioError(e:IOErrorEvent):void {
			//Handle IOError Event
			error_mc.errTitle_txt.text = "File Error";
				
			error_mc.errorList_txt.text = "Unable to communicate with server.";
			
			dispatchEvent(new Event(SHOW_ERROR)); 
		}
		
		// _hideError(e)
		/* Event Handler. Triggered when an error alert needs to be hidden.
		   The following actions are executed:
			- error_mc's visibility is set to false
		   @e:		Event. MouseEvent.CLICK event. */
		private function _hideError(e:MouseEvent):void {
			error_mc.visible = false;
		}
		
		// _hideHome(e)
		/* Event Handler. Triggered when the fadeOut tween has finished tweening the
		   Module Gallery's alpha.
		   The following actions are executed:
			- It removes the event listener from fadeOut
			- Sets the Module Gallery's visible prop to false
			- Begins loading a the selected module
			- Sets up the progress bar to monitor the module's load progress
		   @e:		TweenEvent. MOTION_FINISH event. */
		private function _hideHome(e:TweenEvent):void {
			fadeOut.removeEventListener(TweenEvent.MOTION_FINISH, _hideHome);
			home.visible = false;
			modLoader.alpha = 1;
			modLoader.load(modPath);
			progBar_mc.visible = true;
			progBar_mc.source = modLoader.contentLoaderInfo;
		}
		
		// _unloadMod(e)
		/* Event Handler. Triggered when the fadeOut tween has finished tweening the
		   Module 's alpha.
		   It removes the event listener from fadeOut and unloads the module
		   @e:		TweenEvent. MOTION_FINISH event. */
		private function _unloadMod(e:TweenEvent):void {
			fadeOut.removeEventListener(TweenEvent.MOTION_FINISH, _unloadMod);
			modLoader.unload();
		}
	}
	
}