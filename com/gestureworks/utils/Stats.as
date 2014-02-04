/**
 * @author Kyle J. Fitzpatrick
 */
package com.gestureworks.utils {
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.system.System;
	import flash.text.TextField;
	import flash.utils.getTimer;
	import flash.utils.Timer;
	
	public class Stats extends Sprite {
		
		private var _trackFPS:Boolean = true;
		private var _trackRAM:Boolean = true;
		private var _textColor:uint;
		private var _textBackgroundColor:uint;
		private var _textFillBackground:Boolean;
		
		private var textFields:Vector.<TextField> = new Vector.<TextField>();
		private var curFpsText:TextField;
		private var avgFpsText:TextField;
		private var minFpsText:TextField;
		private var maxFpsText:TextField;
		private var curRamText:TextField;
		private var avgRamText:TextField;
		private var minRamText:TextField;
		private var maxRamText:TextField;
		private var textFieldsHeight:Number = 0;
		
		private var fpsHistory:Vector.<int> = new Vector.<int>();
		private var fpsHistoryLength:uint;
		private var minFps:uint = uint.MAX_VALUE;
		private var maxFps:uint = 0;
		private var fps:uint;
		private var frameSum:uint = 0;
		private var ramHistory:Vector.<int>;
		private var ramHistoryLength:uint;
		private var minRam:uint = uint.MAX_VALUE;
		private var maxRam:uint = 0;
		private var ram:uint;
		
		private var lastTime:uint = getTimer();
		private var deltaTime:uint;
		private var currentTime:uint;
		private var ticks:uint = 0;
		
		private var ramTimer:Timer;
		
		
		public function Stats(xPos:int = 0, yPos:int = 0, color:uint = 0xffffff, fillBackground:Boolean = true, backgroundColor:uint = 0x000000, fpsHistoryDuration:uint = 1000, ramHistoryDuration:uint=5000, ramUpdateFrequency:uint=200) {
			super();
			if (CONFIG::debug == true) {
				super.x = xPos;
				super.y = yPos;
				_textColor = color;
				_textFillBackground = fillBackground;
				_textBackgroundColor = backgroundColor;
				this.fpsHistoryLength = fpsHistoryLength;
				this.ramHistoryLength = ramHistoryLength;
				
				//TODO: check for and only enable in dev mode.
				curFpsText = initializeField('cur. FPS: ---');
				avgFpsText = initializeField('avg. FPS: ---');
				minFpsText = initializeField('min. FPS: ---');
				maxFpsText = initializeField('max. FPS: ---');
				curRamText = initializeField();
				avgRamText = initializeField();
				minRamText = initializeField();
				maxRamText = initializeField();
				
				//TODO: conditional add listener
				ramTimer = new Timer(ramUpdateFrequency);
				ramTimer.addEventListener(TimerEvent.TIMER, onRamTick);
				ramTimer.start();
				super.addEventListener(Event.ENTER_FRAME, framerateTick);
			}			
		}
		
		private function initializeField(text:String = ' '):TextField {
			var tf:TextField = new TextField();
			tf.textColor = _textColor;
			tf.background = _textFillBackground;
			tf.backgroundColor = _textBackgroundColor;
			tf.selectable = false;
			tf.text = text;
			//position field beneath last initialized field
			tf.y = textFieldsHeight;
			tf.height = tf.textHeight + 2;
			textFieldsHeight += tf.height;
			super.addChild(tf);
			textFields.push(tf);
			return tf;
		}
		
		private function formatMemoryValue(value:Number):String {
			var unit:String = 'B';
			if (value > 1048576) {
				value /= 1048576;
				unit = 'M';
			} else if (value > 1024) {
				value /= 1024;
				unit = 'K';
			}
			return value.toFixed(1) + unit;
		}
		
		private function onRamTick(e:TimerEvent):void {
			if (_trackRAM) {
				ram = System.totalMemory;
				curRamText.text = 'cur. RAM: '+formatMemoryValue(ram);
				//TODO: average ram
				
				avgRamText.text = 'avg. RAM: ';
				
				
				if (ram < minRam) {
					minRam = ram;
					minRamText.text = 'min. RAM: '+formatMemoryValue(minRam);
				}
				if (ram > maxRam) {
					maxRam = ram;
					maxRamText.text = 'max. RAM: '+formatMemoryValue(maxRam);
				}
				
			}
		}
		
		public function framerateTick(e:Event = null):void {
			if(_trackFPS) {
				ticks++;
				currentTime = getTimer();
				deltaTime = currentTime - lastTime;
				if (deltaTime >= 1000) {
					fps = ticks / deltaTime * 1000;
					curFpsText.text = 'cur. FPS: ' + fps.toFixed(1);
					
					if (fps > maxFps) {
						maxFps = fps;
						maxFpsText.text = 'max. FPS: '+maxFps.toFixed(1);
					}
					if (fps < minFps) {
						minFps = fps;
						minFpsText.text = 'min. FPS: '+minFps.toFixed(1);
					}
					//TODO: average fps
					
					
					avgFpsText.text = 'avg. FPS: ';
					ticks = 0;
					lastTime = currentTime;
				}
			}
		}
		
		
		public function get trackFPS():Boolean {
			return _trackFPS;
		}
		
		public function set trackFPS(value:Boolean):void {
			if(value!=_trackFPS) {
				_trackFPS = value;
				curFpsText.visible = _trackFPS;
				avgFpsText.visible = _trackFPS;
				minFpsText.visible = _trackFPS;
				maxFpsText.visible = _trackFPS;
			}
		}
		
		public function get trackRAM():Boolean {
			return _trackRAM;
		}
		
		public function set trackRAM(value:Boolean):void {
			_trackRAM = value;
		}
		
		public function get textColor():uint {
			return _textColor;
		}
		
		public function set textColor(value:uint):void {
			if(value!=_textColor) {
				_textColor = value;
				for (var i:int = 0; i < textFields.length; i++) {
					textFields[i].textColor = _textColor;
				}
			}
		}
		
		public function get textBackgroundColor():uint {
			return _textBackgroundColor;
		}
		
		public function set textBackgroundColor(value:uint):void {
			if(value!=_textBackgroundColor) {
				_textBackgroundColor = value;
				for (var i:int = 0; i < textFields.length; i++) {
					textFields[i].backgroundColor = _textBackgroundColor;
				}
			}
			
		}
		
		public function get textFillBackground():Boolean {
			return _textFillBackground;
		}
		
		public function set textFillBackground(value:Boolean):void {
			if (value != _textFillBackground) {
				_textFillBackground = value;
				for (var i:int = 0; i < textFields.length; i++) {
					textFields[i].background = _textFillBackground;
				}
			}
		}
		
	}
}