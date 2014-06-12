package lifelearn.ui.audiocontrol {
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import flash.geom.Rectangle;
	
	public class AudioControl extends MovieClip {
		
		public var isMute:Boolean;
		public var isOpen:Boolean;
		public var isDragging:Boolean;
		
		protected var main:MovieClip;
		protected var mainLayer:Sprite;
		
		protected var hiddenX:Number;
		protected var hiddenY:Number;
		protected var trackW:Number;
		protected var trackOffset:Number;
		
		protected var constraint:Rectangle;
		
		public function AudioControl() {			
			stop();
			addEventListener(Event.ADDED_TO_STAGE,init);
		}
		
		public function init(e:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE,init);
			configUI();
		}
		
		protected function configUI():void {
			isMute = false;
			isOpen = false;
			isDragging = false;
			
			hiddenX = x;
			trackW = volumeTrack_mc.width;
			trackOffset = volumeTrack_mc.x;
			constraint = new Rectangle(trackOffset,volumeTrack_mc.y,trackW,0.1);
			
			mainLayer = parent as Sprite;
			
			if  (mainLayer != null) main = mainLayer.parent as MovieClip;
			
			if (main != null) close_btn.addEventListener(MouseEvent.CLICK, main.hideAudioControl);
			
			volumeSlider_mc.addEventListener(MouseEvent.MOUSE_DOWN, _sliderDown);
			
			volumeSlider_mc.buttonMode = true;
			volumeSlider_mc.useHandCursor = true;
			
			muteBtn_mc.stop();
			muteBtn_mc.buttonMode = true;
			muteBtn_mc.useHandCursor = true;
			muteBtn_mc.muteButtonIndicator_mc.visible = false;
			muteBtn_mc.mouseChildren = false;
			muteBtn_mc.addEventListener(MouseEvent.CLICK, _mute);
			muteBtn_mc.addEventListener(MouseEvent.MOUSE_OUT, _muteOut);
			muteBtn_mc.addEventListener(MouseEvent.MOUSE_OVER, _muteOver);
		}
		
		private function _mute(e:MouseEvent):void {
			var vol:Number;
			
			if (isMute) {
				vol = _calcVolume();
				if (vol == 0) {
					vol = 1;
					volumeSlider_mc.x = trackW + trackOffset;
				}
				if (main != null ) main.volume = vol;
				isMute = false;
				muteBtn_mc.muteButtonIndicator_mc.visible = false;
			} else {
				isMute = true;
				muteBtn_mc.muteButtonIndicator_mc.visible = true;
				if (main != null ) main.volume = 0;
			}
		}

		private function _muteOver(e:MouseEvent):void {
			if (!isDragging)
				muteBtn_mc.muteButtonIndicator_mc.visible = true;
		}
		
		private function _muteOut(e:MouseEvent):void {
			if (!isMute)
				muteBtn_mc.muteButtonIndicator_mc.visible = false;
		}
		
		private function _sliderDown(e:MouseEvent):void {
			isDragging = true;
			volumeSlider_mc.startDrag(false, constraint);
			stage.addEventListener(MouseEvent.MOUSE_UP,_sliderUp);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, _sliderDrag);
		}
		
		private function _sliderUp(e:MouseEvent):void {
			volumeSlider_mc.stopDrag();
			isDragging = false;
			_cleanUpSliderEvents();
		}
		
		private function _sliderDrag(e:MouseEvent):void {
			if (isDragging) {
				if (main != null) {
					main.volume = _calcVolume();
					if (main.volume > 0) {
						isMute = false;
						muteBtn_mc.muteButtonIndicator_mc.visible = false;
					} else {
						isMute = true;
						muteBtn_mc.muteButtonIndicator_mc.visible = true;
					}
				}
			}
		}
		
		private function _calcVolume():Number {
			var vol:Number;
			vol = (volumeSlider_mc.x - trackOffset) / trackW;
			return vol;
		}
		
		private function _cleanUpSliderEvents():void {
			stage.removeEventListener(MouseEvent.MOUSE_UP,_sliderUp);
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, _sliderDrag);
		}
	}
}