/****************************************************************
TITLE:			BatchLoader
AUTHOR:			Julio Lopez
LAST UPDATED: 	2010-03-30
DESCRIPTION:	Object that can batch load swfs, jpgs, and other data

****************************************************************/
package lifelearn.net {
	
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.system.LoaderContext;
	import lifelearn.utils.variables.isEmpty;
	
	import flash.errors.IOError;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	
	import flash.media.Sound;
	
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	import lifelearn.net.BatchItem;
	import lifelearn.utils.*;
	
	dynamic public class BatchLoader extends EventDispatcher {
		/*******************************  Properties  ********************************/
		
		/* Constants: ****************************************************************/
		
		/* Public Properties: ********************************************************/
		public var context:LoaderContext;
		
		/* Private Properties: *******************************************************/

		/* Protected Properties: *****************************************************/
		protected var batch:Array = new Array();
		protected var loading:Boolean = false;
		protected var batchList:Object = new Object();
		
		/********************************  Methods  **********************************/
		
		/* Constructor: **************************************************************/
		public function BatchLoader() {
		}
	
		/* Public Methods: ***********************************************************/
		
		// get bytesLoaded():Number
		// returns the number of bytes loaded
		public function get bytesLoaded():Number {
			var batchLoaded:Number = 0;
			
			if (isLoading) {
				for (var i:uint = 0; i < batch.length; i++) {
					batchLoaded += batchList[batch[i]].loaded;
				}
			}
			
			return batchLoaded;
		}
		
		// get bytesTotal():Number
		// returns the total number of bytes to be loaded
		public function get bytesTotal():Number {
			var batchTotal:Number = 0;
			
			if (isLoading && _areAllTotalsSet()) {
				for (var i:uint = 0; i < batch.length; i++) {
					batchTotal += batchList[batch[i]].total;
				}
			}
			
			return batchTotal;
		}
		
		// get batchFileList():String
		// returns a list of files being loaded
		public function get batchFileList():String {
			var bList:String;
			var bListing:String;
			var bListArr:Array = new Array();
			
			for (var i:uint = 0; i < batch.length; i++) {
				bListing = batchList[batch[i]].file;
				bListArr.push(bListing);
			}
			
			bList = bListArr.toString();
			
			return bList;
		}
		
		// get batchItems():Array
		// returns a list of batch item names
		public function get batchItems():Array {
			var list:Array = new Array();
			
			for (var i:uint = 0; i < batch.length; i++) {
				list[i] = batch[i];
			}
			
			return list;
		}
		
		// get isLoading():Boolean
		// tests to see if a load operation is in progress
		public function get isLoading():Boolean {
			return loading;
		}
		
		// get complete():Boolean
		// tests to see if a load operation has completed
		public function get complete():Boolean {
			var isComplete:Boolean = true;
			
			for (var i:uint = 0; i < batch.length; i++) {
				if (!batchList[batch[i]].hasLoaded) {
					isComplete = false;
					break;
				}
			}
			
			return isComplete;
		}
		
		// addToBatch(item:String,file:String):void
		// adds an item to the batch list
		// @item:String			Name for the entry in the list
		// @file:String			File path to the file to be loaded
		public function addToBatch(item:String,file:String):void {
			var extDot:Number = file.lastIndexOf(".");
			var ext:String = file.substr(extDot+1);
			var isData:Boolean = true;
			var ldr:*;
			
			switch(ext.toLowerCase()) {
				case "swf":
				case "jpg":
				case "png":
				case "gif":
				case "mp3":
					isData = false;
					break;
			}
			
			batchList[item] = new BatchItem();
			
			batch.push(item);
			
			if (isData) {
				ldr = new URLLoader();
				ldr.addEventListener(Event.OPEN,_onOpen);
				ldr.addEventListener(Event.COMPLETE,_onComplete);
				ldr.addEventListener(ProgressEvent.PROGRESS, _onProgress);
				ldr.addEventListener(IOErrorEvent.IO_ERROR, _onIOError);
				batchList[item].loader = ldr;
				batchList[item].file = file;
			} else {
				if (ext.toLowerCase() == "mp3") {
					ldr = new Sound();
					ldr.addEventListener(Event.OPEN,_onOpen);
					ldr.addEventListener(Event.COMPLETE,_onComplete);
					ldr.addEventListener(ProgressEvent.PROGRESS, _onProgress);
					ldr.addEventListener(IOErrorEvent.IO_ERROR, _onIOError);
					batchList[item].loader = ldr;
					batchList[item].file = file;
				} else {
					ldr = new Loader();
					ldr.contentLoaderInfo.addEventListener(Event.OPEN,_onOpen);
					ldr.contentLoaderInfo.addEventListener(Event.COMPLETE,_onComplete);
					ldr.contentLoaderInfo.addEventListener(Event.INIT, _onInit);
					ldr.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, _onProgress);
					ldr.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, _onIOError);
					batchList[item].loader = ldr;
					batchList[item].file = file;
					batchList[item].hasInited = false;
				}
			}
		}
		
		// load():void
		// Initiates the batch load operation
		public function load():void {
			if (!complete && !isLoading) {
				for (var i:uint = 0; i < batch.length; i++) {
					if (batchList[batch[i]].loader is URLLoader) {
						batchList[batch[i]].loader.load(new URLRequest(batchList[batch[i]].file));
					} else {
						batchList[batch[i]].loader.load(new URLRequest(batchList[batch[i]].file), context);
					}
					
				}
			} else {
				Console.warn("Cannot load a Batch that has already been loaded.");
			}
		}
		
		// getBatchItemContent(item:String):*
		// returns the loaded content for the batch item specified by @item
		// @item:String				Item name.
		public function getBatchItemContent(item:String):* {
			var content:* = null;
			var ldr:* = batchList[item].loader;
			
			if (ldr is Loader) {
				if (batchList[item].hasInited) {
					content = ldr.content;
				}
			} else if (ldr is URLLoader) {
				if (batchList[item].hasLoaded) {
					content = ldr.data;
				}
			} else if (ldr is Sound) {
				if (batchList[item].hasLoaded) {
					content = ldr;
				}
			}
			
			return content;
		}
		
		// unloadBatchItem(item:String):void
		// unloades the loaded content from the batch item specified by @item
		// @item:String				Item name.
		public function unloadBatchItem(item:String):* {
			var content:* = null;
			var ldr:* = batchList[item].loader;
			
			if (ldr is Loader) {
				try {
					ldr.unload();
				} catch(e) {
				}
			} else if (ldr is URLLoader) {
				try {
					ldr.close();
					ldr.data = null;
				} catch (e) {
				}
			} else if (ldr is Sound) {
				try {
					ldr.close();
					ldr = null;
				} catch (e:IOError) {
				}
			}
			
			return content;
		}
		
		// toString():String
		// returns a string representation of the batch list
		override public function toString():String {
			var strArray:Array = new Array();
			var meAsString:String;
			var itemAsString:String;
			
			for (var i:uint = 0; i < batch.length; i++) {
				itemAsString = "Batch Item: " + batch[i] + ", " + batchList[batch[i]].toString();
				strArray.push(itemAsString);
			}
			
			meAsString = strArray.join("\n");
			
			return meAsString;
		}
		
		/* Protected Methods: ********************************************************/
		
		/* Private Methods: **********************************************************/
		// _onOpen(e:Event):void
		// Event Handler. Triggered when an item in the batch list has dispatched an OPEN event.
		// This function dispatches a new OPEN event if all items in the batch list have been opened.
		// @e:		Event. OPEN event
		private function _onOpen(e:Event):void {
			var ldr:*;
			var item:String;
			
			for (var i:uint = 0;i < batch.length; i++) {
				if ((batchList[batch[i]].loader is URLLoader) || (batchList[batch[i]].loader is Sound)) {
					ldr = batchList[batch[i]].loader;
				} else if (batchList[batch[i]].loader is Loader) {
					ldr = batchList[batch[i]].loader.contentLoaderInfo;
				}
				
				if (ldr == e.target) {
					item = batch[i];
					break;
				}
			}
			
			batchList[item].hasOpened = true;
			
			if (_hasBatchOpened()) {
				loading = true;
				dispatchEvent(new Event(Event.OPEN));
			}
		}
		
		// _onInit(e:Event):void
		// Event Handler. Triggered when an item in the batch list has dispatched an INIT event.
		// This function dispatches a new INIT event if all items that cand dispatch an INIT event
		// have been initialized
		// @e:		Event. INIT event
		private function _onInit(e:Event):void {
			var ldr:LoaderInfo;
			var item:String;
			
			for (var i:uint = 0;i < batch.length; i++) {
				if (batchList[batch[i]].loader is Loader) {
					ldr = batchList[batch[i]].loader.contentLoaderInfo;
				}
				
				if (ldr == e.target) {
					item = batch[i];
					break;
				}
			}
			
			batchList[item].hasInited = true;
			
			if (_hasBatchInitialized()) {
				dispatchEvent(new Event(Event.INIT));
			}
		}
		
		// _onInit(e:Event):void
		// Event Handler. Triggered when an item in the batch list has dispatched an COMPLETE event.
		// This function dispatches a new COMPLETE event when all items have been loaded
		// @e:		Event. COMPLETE event
		private function _onComplete(e:Event):void {
			var ldr:*;
			var item:String;
			
			for (var i:uint = 0;i < batch.length; i++) {
				if ((batchList[batch[i]].loader is URLLoader) || (batchList[batch[i]].loader is Sound)) {
					ldr = batchList[batch[i]].loader;
				} else if (batchList[batch[i]].loader is Loader) {
					ldr = batchList[batch[i]].loader.contentLoaderInfo;
				}
				
				if (ldr == e.target) {
					item = batch[i];
					break;
				}
			}
			
			batchList[item].hasLoaded = true;
			
			if (_hasBatchLoaded()) {
				loading = false;
				dispatchEvent(new Event(Event.COMPLETE));
			}
		}
		
		// _onProgress(e:ProgressEvent):void
		// Event Handler. Triggered when an item in the batch list has dispatched an PROGRESS event.
		// This function collects the total number of bytes for the batch list and then
		// dispatches a new PROGRESS event with the total number of bytes loaded and the total number
		// of bytes to be loaded.
		// @e:		Event. PROGRESS event
		private function _onProgress(e:ProgressEvent):void {
			var ldr:*;
			var item:String;
			
			for (var i:uint = 0;i < batch.length; i++) {
				if ((batchList[batch[i]].loader is URLLoader) || (batchList[batch[i]].loader is Sound)) {
					ldr = batchList[batch[i]].loader;
				} else if (batchList[batch[i]].loader is Loader) {
					ldr = batchList[batch[i]].loader.contentLoaderInfo;
				}
				
				if (ldr == e.target) {
					item = batch[i];
					break;
				}
			}
			
			if (batchList[item].total == 0) {
				batchList[item].total = e.bytesTotal;
			}
			
			batchList[item].loaded = e.bytesLoaded;
			
			if (_areAllTotalsSet()) {
				dispatchEvent(new ProgressEvent(ProgressEvent.PROGRESS,false,false,bytesLoaded,bytesTotal));				
			}
		}
		
		// _onProgress(e:IOErrorEvent):void
		// Event Handler. Triggered when an item in the batch list has encountered an IO_ERROR event.
		// This function re-disptaches the error
		// @e:		Event. IO_ERROR event
		private function _onIOError(e:IOErrorEvent):void {
			dispatchEvent(e);
		}
		
		// _hasBatchLoaded():Boolean
		// Tests to see if the entire batch has completed loading
		private function _hasBatchLoaded():Boolean {
			var hasLoaded:Boolean = true;
			
			for (var i:uint = 0; i < batch.length; i++) {
				if (!batchList[batch[i]].hasLoaded) {
					hasLoaded = false;
					break;
				}
			}
			
			return hasLoaded;
		}
		
		// _hasBatchOpened():Boolean
		// Tests to see if the entire batch has begun loading
		private function _hasBatchOpened():Boolean {
			var hasOpened:Boolean = true;
			
			for (var i:uint = 0; i < batch.length; i++) {
				if (!batchList[batch[i]].hasOpened) {
					hasOpened = false;
					break;
				}
			}
			
			return hasOpened;
		}
		
		// _hasBatchInitialized():Boolean
		// Tests to see if the all initializable items in the batch
		// have been initialized
		private function _hasBatchInitialized():Boolean {
			var hasInited:Boolean = true;
			
			for (var i:uint = 0; i < batch.length; i++) {
				if (batchList[batch[i]].loader is Loader) {
					if (!batchList[batch[i]].hasInited) {
						hasInited = false;
						break;
					}
				}
			}
			
			return hasInited;
		}
		
		// _areAllTotalsSet():Boolean
		// Tests to see if the all the totalBytes information has been
		// collected from each item that will be loaded.
		private function _areAllTotalsSet():Boolean {
			var totalsSet:Boolean = true;
			
			for (var i:uint = 0; i < batch.length; i++) {
				if (batchList[batch[i]].total == 0) {
					totalsSet = false;
					break;
				}
			}
			
			return totalsSet;
		}
	}
}