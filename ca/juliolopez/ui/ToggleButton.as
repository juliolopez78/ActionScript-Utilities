package ca.juliolopez.ui {
	import flash.display.MovieClip;
	import flash.display.Sprite;
	
	import flash.events.MouseEvent;
	
	import flash.geom.Rectangle;
	/**
	 * ...
	 * @author Julio Lopez
	 */
	public dynamic class ToggleButton extends MovieClip {
		
		private var _toggled:Boolean;
		
		protected var hitAreaSprite:Sprite;
		
		public function ToggleButton() {
			super();
			
			addEventListener(MouseEvent.ROLL_OUT, _rollOut);
			addEventListener(MouseEvent.ROLL_OVER, _rollOver);
			
			buttonMode = true;
			
			hitAreaSprite = drawHitArea(); 
			
			addChild(hitAreaSprite);
			hitArea = hitAreaSprite;
			
			doRollout();
		}
		
		override public function set mouseEnabled(value:Boolean):void {
			if (value) {
				addEventListener(MouseEvent.ROLL_OUT, _rollOut);
				addEventListener(MouseEvent.ROLL_OVER, _rollOver);
				buttonMode = true;
			} else {
				removeEventListener(MouseEvent.ROLL_OUT, _rollOut);
				removeEventListener(MouseEvent.ROLL_OVER, _rollOver);
				buttonMode = false;
			}
			
			super.mouseEnabled = value;
		}
		
		public function get toggled():Boolean {
			return _toggled;
		}
		
		public function set toggled(b:Boolean):void {
			_toggled = b;
			
			if (_toggled) {
				gotoAndStop(3);
			} else {
				gotoAndStop(1)
			}
		}
		
		public function doRollover():void {
			gotoAndStop(2);
		}
		
		public function doRollout():void {
			if (_toggled) {
				gotoAndStop(3);
			} else {
				gotoAndStop(1);
			}
		}
		
		protected function drawHitArea():Sprite {
			var ha:Sprite = new Sprite();
			var bounds:Rectangle;
			
			bounds = getHitAreaBounds();
			
			ha.x = bounds.x;
			ha.y = bounds.y;
			ha.name = 'buttonHitArea';
			
			ha.graphics.clear();
			ha.graphics.beginFill(0x000000, 0);
			ha.graphics.drawRect(0, 0, bounds.width, bounds.height);
			
			ha.visible = false;
			
			return ha;
		}
		
		protected function getHitAreaBounds():Rectangle {
			return getChildAt(0).getBounds(this);
		}
		
		private function _rollOut(e:MouseEvent):void {
			doRollout()
		}
		
		private function _rollOver(e:MouseEvent):void {
			doRollover();
		}
		
	}

}