/****************************************************************
TITLE:			Console
AUTHOR:			Julio Lopez
LAST UPDATED: 	2010-11-15
DESCRIPTION:	A simple wrapper class that enables access to
				Firebug's, Explorer's and any WebKit Browser's console.
VERSION:		2.0
USAGE:

import lifelearn.utils.logging.Console;
Console.log("hello", "world");

****************************************************************/
package ca.juliolopez.utils.logging {
	
	import flash.external.ExternalInterface;
	import flash.system.Capabilities;
	
	public class Console extends Object {
		/********************************  Methods  **********************************/
		/* Constants: ****************************************************************/
		// JS commands
		private static const LOG:String = "console.log";
		private static const INFO:String = "console.info";
		private static const WARN:String = "console.warn";
		private static const ERROR:String = "console.error";
		private static const ASSERT:String = "console.assert";
		private static const CLEAR:String = "console.clear";
		
		// Output String headers
		private static const INFO_STR:String = "INFO:";
		private static const WARN_STR:String = "WARNING:";
		private static const ERR_STR:String = "ERROR:";
		private static const ASRT_STR:String = "ASSERTION:";
		
		/* Public Variables: *********************************************************/
		public static var sep:String = " ";				// String to use as a separator in Array.join() statements
		
		/********************************  Methods  **********************************/
		/* Constructor: **************************************************************/
		public function Console() { }
		
		/* Public Methods: ***********************************************************/
		
		// available()
		// Uses Capabilities.playerType, ExternalInterface.available, and a call to JS eval()
		// to determine if swf is playing in a browser and the colsole is available.
		// RETURNS: True if Flash is able to communicate with the console, false otherwise.
		public static function get available():Boolean {
			if (Capabilities.playerType == "ActiveX" || Capabilities.playerType == "PlugIn") {
				if (ExternalInterface.available) {
					 if (ExternalInterface.call("eval", "typeof console") != "undefined") return true;
				}
			}
			return false;
		}
		
		// log()
		// Sends message to browser console and also traces the message in the flash output window.
		// @...vars		All arguments supplied are printed to console separated by the separator string.
		public static function log(...vars):void {
			if (available) {
				try {
					_call(LOG, vars.join(sep));
				} catch (e) {
					trace(e);
				}
			}
			
			trace(vars.join(sep));
		}
		
		// info()
		// Sends message to browser console and also traces the message in the flash output window.
		// Console output will be formatted to indicate it is informational.
		// @...vars		All arguments supplied are printed to console separated by the separator string.
		public static function info(...vars):void {
			if (available) {
				try {
					_call(INFO, vars.join(sep));
				} catch (e) {
					trace(e);
				}
			}
			
			trace(INFO_STR, vars.join(sep));
		}
		
		// warn()
		// Sends message to browser console and also traces the message in the flash output window.
		// Console output will be formatted to indicated it is a warning.
		// @...vars		All arguments supplied are printed to console separated by the separator string.
		public static function warn(...vars):void {
			if (available) {
				try {
					_call(WARN, vars.join(sep));
				} catch (e) {
					trace(e);
				}
			}
			
			trace(WARN_STR, vars.join(sep));
		}
		
		// error()
		// Sends message to browser console and also traces the message in the flash output window.
		// Console output will be formatted to indicated it is an error.
		// @...vars		All arguments supplied are printed to console separated by the separator string.
		public static function error(...vars):void {
			if (available) {
				try {
					_call(ERROR, vars.join(sep));
				} catch (e) {
					trace(e);
				}
			}
			
			trace(ERR_STR, vars.join(sep));
		}
		
		// assert()
		// Sends message to browser console and Flash output window if first argument evaluates to false.
		// Console output will be formatted to indicated it is an error.
		// @...vars		All arguments supplied are printed to console separated by the separator string.
		public static function assert(b:Boolean, ...vars):void {
			if (available) {
				try {
					_call(ASSERT, b, vars.join(sep));
				} catch (e) {
					trace(e);
				}
			}
			
			if (!b) trace(ASRT_STR, vars.join(sep));
		}
		
		// clear()
		// Clears the console.
		public static function clear():void {
			if (available) {
				try {
					_call(CLEAR);
				} catch (e) {
					trace(e);
				}
			}
		}
		
		/* Private Methods: ***********************************************************/
		
		// _call()
		// Workhorse function that makes the actual call to ExternalInterface.call()
		// @s			String. JS command to call (see class constants)
		// @...vars		Additional variables to use with call
		private static function _call(s:String, ...vars):void {
			switch (s) {
				case LOG:
				case INFO:
				case WARN:
				case ERROR:
					ExternalInterface.call(s, vars[0]);
					break;
				case ASSERT:
					ExternalInterface.call(s, vars[0], vars[1]);
					break;
				case CLEAR:
					ExternalInterface.call(s);
					break;
			}
		}
	}
}