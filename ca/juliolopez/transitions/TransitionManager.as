/****************************************************************
TITLE:			TransitionManager
AUTHOR:			Julio Lopez
LAST UPDATED: 	2010-06-01
DESCRIPTION:	A custom Transition Manager

****************************************************************/
package ca.juliolopez.transitions {
	
	import fl.transitions.*;
	import fl.transitions.easing.*;
	
	import flash.display.DisplayObject;
	
	import flash.geom.Point;
	
	public class TransitionManager extends Object {
		/*******************************  Properties  ********************************/
		
		/* Constants: ****************************************************************/
		public static const IN:Boolean = true;
		public static const OUT:Boolean = false;
		
		/* Public Properties: ********************************************************/
		
		/* Private Properties: *******************************************************/
		
		/* Protected Properties: *****************************************************/
		protected var tweenList:Array = new Array();
		
		/********************************  Methods  **********************************/
		
		/* Constructor: **************************************************************/
		public function TransitionManager() { }
	
		/* Public Methods: ***********************************************************/
		
		
		public function fade(o:DisplayObject,dslvIn:Boolean=true,dur:Number=1,evt:String=null,hndlr:Function=null):Tween {
			var twnStart:Number;
			var twnEnd:Number;
			var twn:Tween;

			if (dslvIn) {
				twnStart = 0;
				twnEnd = 1;
			} else {
				twnStart = 1;
				twnEnd = 0;
			}
			
			twn = new Tween(o,"alpha",Strong.easeOut,twnStart,twnEnd,dur,true);
			twn.stop();
			twn.rewind();
			
			twn.addEventListener(TweenEvent.MOTION_START,_addToTweenList);
			twn.addEventListener(TweenEvent.MOTION_FINISH,_removeFromTweenList);
			
			if (evt != null && hndlr != null) {
				twn.addEventListener(evt,hndlr);
			}
			
			twn.start();
			
			return twn;
		}
		
		public function fly(o:DisplayObject, startPoint:Point, endPoint:Point, func:Function = null, dur:Number = 1, evt:String = null, hndlr:Function = null):Object {
			var twnStartX:Number = startPoint.x;
			var twnEndX:Number = endPoint.x;
			var twnStartY:Number = startPoint.y;
			var twnEndY:Number = endPoint.y;
			var twnX:Tween;
			var twnY:Tween;
			
			if (func == null) func = Strong.easeOut;
			
			twnX = new Tween(o,"x",func,twnStartX,twnEndX,dur,true);
			twnX.stop();
			twnX.rewind();
			
			twnX.addEventListener(TweenEvent.MOTION_START,_addToTweenList);
			twnX.addEventListener(TweenEvent.MOTION_FINISH,_removeFromTweenList);
			
			twnY = new Tween(o,"y",func,twnStartY,twnEndY,dur,true);
			twnY.stop();
			twnY.rewind();
			
			twnY.addEventListener(TweenEvent.MOTION_START,_addToTweenList);
			twnY.addEventListener(TweenEvent.MOTION_FINISH,_removeFromTweenList);
			
			if (evt != null && hndlr != null) {
				twnX.addEventListener(evt,hndlr);
			}
			
			twnX.start();
			twnY.start();
			
			return { xTween : twnX, yTween : twnY };
		}
		
		public function zoom(o:DisplayObject,zoomIn:Boolean=true,targetScale:Number=1,func:Function=null,dur:Number=1,evt:String=null,hndlr:Function=null):Object {
			var twnX:Tween;
			var twnY:Tween;
			var twnStart:Number;
			var twnEnd:Number;

			if (zoomIn) {
				twnStart = 0;
				twnEnd = targetScale;
			} else {
				twnStart = targetScale;
				twnEnd = 0;
			}
			
			if (func == null) func = Strong.easeOut;
			
			twnX = new Tween(o,"scaleX",func,twnStart,twnEnd,dur,true);
			twnX.stop();
			twnX.rewind();
			
			twnX.addEventListener(TweenEvent.MOTION_START,_addToTweenList);
			twnX.addEventListener(TweenEvent.MOTION_FINISH,_removeFromTweenList);
			
			twnY = new Tween(o,"scaleY",func,twnStart,twnEnd,dur,true);
			twnY.stop();
			twnY.rewind();
			
			twnY.addEventListener(TweenEvent.MOTION_START,_addToTweenList);
			twnY.addEventListener(TweenEvent.MOTION_FINISH,_removeFromTweenList);
			
			if (evt != null && hndlr != null) {
				twnX.addEventListener(evt,hndlr);
			}
			
			twnX.start();
			twnY.start();
			
			return { xTween : twnX, yTween : twnY };
		}
		
		/* Protected Methods: ********************************************************/
		
		/* Private Methods: **********************************************************/
		private function _addToTweenList(e:TweenEvent):void {
			e.target.removeEventListener(TweenEvent.MOTION_START,_addToTweenList);
			tweenList.push(e.target);
		}
		
		private function _removeFromTweenList(e:TweenEvent):void {
			e.target.removeEventListener(TweenEvent.MOTION_FINISH,_removeFromTweenList);
			
			var ndx:Number;
			
			for (var i:uint = 0; i < tweenList.length; i++) {
				if (tweenList[i] == e.target) {
					ndx = i;
					break;
				}
			}
			
			tweenList.splice(ndx,1);
		}
	}
	
}