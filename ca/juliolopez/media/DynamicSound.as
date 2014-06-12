package ca.juliolopez.media {
	
	import fl.transitions.Tween;
	import fl.transitions.TweenEvent;
	import fl.transitions.easing.*;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	
	import ca.juliolopez.events.DynamicSoundEvent;
	
	/**
	 * ...
	 * @author Julio Lopez
	 */
	public class DynamicSound extends EventDispatcher{
		
		public var mySound:Sound
		
		private var _loop:Boolean = false;
		private var _isPlaying:Boolean = false;
		private var _isPaused:Boolean = false;
		private var _isStopped:Boolean = true;
		
		private var _playFrom:Number = 0;
		
		private var _channel:SoundChannel;
		private var _transform:SoundTransform;
		
		private var _volTween:Tween;
		
		public function DynamicSound(s:Sound,l:Boolean=false,v:Number=1) {
			mySound = s;
			loop = l;
			_transform = new SoundTransform(v);
		}
		
		public function get loop():Boolean {
			return _loop;
		}
		
		public function set loop(b:Boolean):void {
			_loop = b;
			
			if (_channel != null) {
				if (_loop) {
					_channel.addEventListener(Event.SOUND_COMPLETE, _loopSound);
				} else {
					_channel.removeEventListener(Event.SOUND_COMPLETE, _loopSound);
				}
			}
		}
		
		public function get volume():Number {
			return _transform.volume;
		}
		
		public function set volume(v:Number):void {
			_transform.volume = v;
			if (_channel != null) _channel.soundTransform = _transform;
		}
		
		public function get isPlaying():Boolean {
			return _isPlaying;
		}
		
		public function get isPaused():Boolean {
			return _isPaused;
		}
		
		public function get isStopped():Boolean {
			return _isStopped;
		}
		
		public function fade(fromVol:Number, toVol:Number, dur:Number = 1):void {
			_volTween = new Tween(this, 'volume', Strong.easeOut, fromVol, toVol, dur, true);
			dispatchEvent(new DynamicSoundEvent(DynamicSoundEvent.FADE_COMPLETE));
		}
		
		public function play():void {
			_channel = mySound.play(_playFrom, 0, _transform);
			_channel.addEventListener(Event.SOUND_COMPLETE, _soundDone);
			if (loop) _channel.addEventListener(Event.SOUND_COMPLETE, _loopSound);
			dispatchEvent(new DynamicSoundEvent(DynamicSoundEvent.PLAY, false, false, _playFrom));
			_isPlaying = true;
			_isStopped = false;
			_isPaused = false;
		}
		
		public function stop():void {
			if (_channel != null) _channel.stop();
			_isPlaying = false;
			_isStopped = true;
			_isPaused = false;
			_playFrom = 0;
			dispatchEvent(new DynamicSoundEvent(DynamicSoundEvent.STOP));
		}
		
		public function pause():void {
			if (_channel != null) {
				_playFrom = _channel.position;
				_channel.stop();
				_isPaused = true;
				_isPlaying = false;
				_isStopped = false;
				dispatchEvent(new DynamicSoundEvent(DynamicSoundEvent.PAUSE));
			}
		}
		
		private function _loopSound(e:Event):void {
			_channel.removeEventListener(Event.SOUND_COMPLETE, _loopSound);
			dispatchEvent(new DynamicSoundEvent(DynamicSoundEvent.LOOP));
			play();
		}
		
		private function _soundDone(e:Event):void {
			_channel.removeEventListener(Event.SOUND_COMPLETE, _soundDone);
			dispatchEvent(new DynamicSoundEvent(DynamicSoundEvent.SOUND_COMPLETE));
		}
		
	}

}