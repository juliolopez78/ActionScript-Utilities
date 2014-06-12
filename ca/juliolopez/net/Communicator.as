/****************************************************************
TITLE:			Communicator
AUTHOR:			Julio Lopez
LAST UPDATED: 	2010-03-30
DESCRIPTION:	Handles GET and POST communication with a server

****************************************************************/
package lifelearn.net {
	
	import flash.errors.IOError;
	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	
	public class Communicator extends Object {
		/*******************************  Properties  ********************************/
		
		/* Constants: ****************************************************************/
		private const GET:String = "get";
		private const POST:String = "post";
		private const DEFAULT_CONTENT_TYPE:String = "application/x-www-form-urlencoded";
		
		/* Public Properties: ********************************************************/
		public var complete:Function = function (e:Event):void {
			trace(e.target.data);
		};
		
		public var ioError:Function = function (e:IOErrorEvent):void {
			trace(e);
		};
		
		
		/* Private Properties: *******************************************************/

		/* Protected Properties: *****************************************************/
		protected var comm:URLLoader = new URLLoader();
		protected var page:URLRequest = new URLRequest();
		protected var vars:URLVariables = new URLVariables();
		
		/********************************  Methods  **********************************/
		
		/* Constructor: **************************************************************/
		public function Communicator(u:String=null,m:String=null,v:Object=null,df:String=null,ct:String=null) {
			init(u,m,v,df,ct);
		}
		
		// set url()
		// SETTER for page object's url poperty
		// @s		String containing the url
		public function set url(s:String):void {
			page.url = s;
		}
		
		// get url()
		// GETTER for page object's url poperty
		public function get url():String {
			return page.url;
		}
		
		// set method()
		// SETTER for page object's method poperty
		// @s		String either the word 'post' or 'get'
		public function set method(s:String):void {
			if (s.toLowerCase() == POST) {
				page.method = URLRequestMethod.POST;
			} else if (s.toLowerCase() == GET) {
				page.method = URLRequestMethod.GET;
			} else {
				page.method = URLRequestMethod.POST;
			}
		}
		
		// get method()
		// GETTER for page object's method poperty
		public function get method():String {
			return page.method;
		}
		
		// set variables()
		// SETTER. sets adds properties to the vars object to be sent via POST or GET
		// @o		Object containing porperites and values to be set into vars object
		public function set variables(o:*):void {
			if (o is Object) {
				for (var p:String in o) {
					vars[p] = o[p];
				}
			}
		}
		
		// get variables()
		// GETTER. returns vars object as a url encoded string
		public function get variables():String {
			return vars.toString()
		}
		
		// set dataFormat()
		// SETTER for comm object's dataFormat poperty
		// @s		String with either the word 'binary', 'text' or 'variables'
		public function set dataFormat(s:String):void {
			switch (s.toLowerCase()) {
				case "binary":
					comm.dataFormat = URLLoaderDataFormat.BINARY;
					break;
				case "variables":
					comm.dataFormat = URLLoaderDataFormat.VARIABLES;
					break;
				case "text":
				default:
					comm.dataFormat = URLLoaderDataFormat.TEXT;
					break;
			}
		}
		
		// get dataFormat()
		// GETTER for comm object's dataFormat poperty
		public function get dataFormat():String {
			return comm.dataFormat
		}
		
		// set contentType()
		// SETTER for page object's contentType poperty
		// @s		String with a valid contentType
		public function set contentType(s:String):void {
			page.contentType = s;
		}
		
		// get contentType()
		// GETTER for page object's contentType poperty
		public function get contentType():String {
			return page.contentType;
		}
		
		// get data()
		// GETTER for page object's contentType poperty
		public function get data():* {
			return comm.data;
		}
		
		// load(url)
		// Initiates communication with server
		// @url:		String. Contains a URL to connect to (optional)
		// if no url is passed, page.url is used. if page.url is not set IO error is thrown.
		public function load(url:String=null):void {
			//if (url == null && page.url == null) throw new IOError("Load Method requires a URL in order to function");
			if (url != null) page.url = url;
			page.data = vars;
			comm.load(page);
		}
		
		// toString()
		// returns a string representation of the object
		public function toString():String {
			var asString:String = "{";
			asString += "\n\turl: " + url;
			asString += "\n\tmethod: " + method;
			asString += "\n\tcontentType: " + contentType;
			asString += "\n\tvariables: " + variables;
			asString += "\n\tdataFormat: " + dataFormat;
			asString += "\n\tdata: " + data;
			asString += "\n}";
			return asString;
		}
		
		// onComplete(e)
		// Event Handler. Triggered when the Page has received data from the server.
		// This function calls the function stored in the 'complete' property of the object.
		// By default the 'complete' property traces the received data. 'complete' can be rewritten by programmer
		// @e:		Event. COMPLETE event
		public function onComplete(e:Event):void {
			complete.call(null,e);
		}
		
		// ioError(e)
		// Event Handler. Triggered when an IO error is encountered during communication with the server.
		// This function calls the function stored in the 'ioError' property of the object.
		// By default the 'ioError' property traces the error. 'ioError' can be rewritten by programmer
		// @e:		IOErrorEvent. IO_ERROR event.
		public function onIOError(e:IOErrorEvent):void {
			ioError.call(null,e);
		}
	
		/* Public Methods: ***********************************************************/
		
		/* Protected Methods: ********************************************************/
		
		// init()
		// Initialization function called by constructor
		// - Checks to see if a url was passed as a parameter and sets it if it was
		// - Checks to see if a method was passed as a parameter and sets it if it was, otherwise it sets it to POST
		// - Checks to see if variables were passed as a parameter and sets them if there were any
		// - Checks to see if a dataFormat was passed as a parameter and sets it if it was
		// - Checks to see if a contentType was passed as a parameter and sets it if it was, otherwise it sets the default
		// - sets event handlers for comm object
		protected function init(u:String=null,m:String=null,v:Object=null,df:String=null,ct:String=null) {
			if (u != null) url = u;
			if (m != null) {
				method = m;
			} else {
				method = URLRequestMethod.POST;
			}
			if (v != null) variables = v;
			if (df != null) dataFormat = df;
			if (ct != null) {
				contentType = ct;
			} else {
				contentType = DEFAULT_CONTENT_TYPE;
			}
			
			comm.addEventListener(Event.COMPLETE, onComplete);
			comm.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
		}
		/* Private Methods: **********************************************************/
	}
	
}