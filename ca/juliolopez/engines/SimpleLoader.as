/****************************************************************
TITLE:			SimpleLoader
AUTHOR:			Julio Lopez
LAST UPDATED: 	2010-03-30
DESCRIPTION:	A simple preloader file to load programs

****************************************************************/
package ca.juliolopez.engines {	
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.system.LoaderContext;
	
	import flash.events.Event;
	import flash.events.ProgressEvent;
	
	import flash.net.URLRequest;
	
	public class SimpleLoader extends MovieClip {
		protected var pgmLoader:Loader = new Loader();

		protected var pbWidth:Number = 150;
		protected var pbHeight:Number = 12;
		protected var pbBorderColor:Number = 0xaaaaaa;
		protected var pbBgColor:Number = 0xcccccc;
		protected var pbBarColor:Number = 0xefefef;
		protected var pbContext:LoaderContext;
		
		protected var s1:Shape = new Shape();
		protected var s2:Shape = new Shape();
		protected var s3:Shape = new Shape();
		
		protected var pBar:Sprite = new Sprite();
		
		protected var progLocation:String;
		
		public function SimpleLoader(w:Number=NaN,h:Number=NaN,brdr:Number=NaN,bg:Number=NaN,bar:Number=NaN,pl:String=null,ctxt:LoaderContext=null):void {
			if (!isNaN(w)) pbWidth = w;
			if (!isNaN(h)) pbHeight = h;
			if (!isNaN(brdr)) pbBorderColor = brdr;
			if (!isNaN(bg)) pbBgColor = bg;
			if (!isNaN(bar)) pbBarColor = bar;
			if (pl != null) progLocation = pl;
			pbContext = ctxt;
			
			stop();
			
			s1.graphics.beginFill(pbBorderColor);
			s1.graphics.drawRect(0,0,pbWidth,pbHeight);
			s1.visible = true;
			
			s2.graphics.beginFill(pbBgColor);
			s2.graphics.drawRect(1,1,pbWidth - 2,pbHeight - 2);
			s2.visible = true;
			
			s3.visible = true;
			
			pBar.addChild(s1);
			pBar.addChild(s2);
			pBar.addChild(s3);
			
			pBar.x = (stage.stageWidth / 2) - (pBar.width / 2);
			pBar.y = (stage.stageHeight / 2) - (pBar.height / 2);
			pBar.visible = true;
			
			addChild(pBar);
			
			root.loaderInfo.addEventListener(Event.INIT,iAmComplete);
		}
		
		public function get program():DisplayObject {
			return pgmLoader.content;
		}
		
		protected function onProgress(e:ProgressEvent):void {
			var pcnt:Number = Math.round(e.bytesLoaded / e.bytesTotal * 100) / 100;
			var fullWidth:Number = pbWidth - 2;
			var fullHeight:Number = pbHeight - 2;
		
			s3.graphics.clear();
			s3.graphics.beginFill(pbBarColor);
			s3.graphics.drawRect(1,1,(fullWidth * pcnt),fullHeight);
		}
		
		protected function iAmComplete(e:Event):void {
			root.loaderInfo.removeEventListener(Event.INIT,iAmComplete);
			if (progLocation != null) loadProgram(progLocation);
		}
		
		protected function programReady(e:Event):void {
			pgmLoader.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS,onProgress);
			pgmLoader.contentLoaderInfo.removeEventListener(Event.INIT,programReady);
			addChild(pgmLoader);
			
			removeChild(pBar);
		}
		
		protected function loadProgram(p:String):void {
			var req:URLRequest = new URLRequest(p);
			pgmLoader.contentLoaderInfo.addEventListener(Event.INIT,programReady);
			pgmLoader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS,onProgress);
			pgmLoader.load(req, pbContext);
		}
	}
}