/**
 * @author Kyle J. Fitzpatrick
 */
package com.gestureworks.utils {
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.system.System;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.utils.getTimer;
	import flash.utils.Timer;
	
	public class Stats extends Sprite {
		
		private var _trackFPS:Boolean = true;
		private var _trackRAM:Boolean = true;
		private var _textColor:uint;
		private var _backgroundColor:uint;
		private var _fillBackground:Boolean;
		private var _resetOnTouch:Boolean;
		
		private var padding:Number = 4;		//pixels to pad.
		private var textFormat:TextFormat = new TextFormat(null, '10', null, null, null, null, null, null, TextFormatAlign.CENTER);
		private var textFields:Vector.<TextField> = new Vector.<TextField>();
		private var fpsLabel:TextField;
		private var ramLabel:TextField;
		private var curFpsText:TextField;
		private var avgFpsText:TextField;
		private var minFpsText:TextField;
		private var maxFpsText:TextField;
		private var curRamText:TextField;
		private var avgRamText:TextField;
		private var minRamText:TextField;
		private var maxRamText:TextField;
		private var textFieldsHeight:Number = 0;
		private var textFieldsWidth:Number = 0;
		
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
				_fillBackground = fillBackground;
				_backgroundColor = backgroundColor;
				this.fpsHistoryLength = fpsHistoryLength;
				this.ramHistoryLength = ramHistoryLength;
				textFieldsHeight = padding;
				textFieldsWidth = padding;
				fpsLabel = initializeField('FPS');
				curFpsText = initializeField('cur: 60.0');
				avgFpsText = initializeField('avg: 60.0');
				minFpsText = initializeField('min: 60.0');
				maxFpsText = initializeField('max: 60.0');
				fpsLabel.width = curFpsText.textWidth;
				textFieldsWidth = curFpsText.textWidth + padding * 2;
				textFieldsHeight = padding;
				ramLabel = initializeField('RAM');
				curRamText = initializeField('cur: 999.9M');
				avgRamText = initializeField('avg: 999.9M');
				minRamText = initializeField('min: 999.9M');
				maxRamText = initializeField('max: 999.9M');
				textFieldsWidth += curRamText.textWidth + padding * 2;
				textFieldsHeight += padding;
				this.fillBackground = fillBackground;
				
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
			tf.selectable = false;
			tf.text = text;
			//position field beneath last initialized field
			tf.x = textFieldsWidth;
			tf.y = textFieldsHeight;
			tf.height = tf.textHeight + padding * 2;
			tf.width = tf.textWidth + padding * 2;
			textFieldsHeight += tf.height - padding;
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
				curRamText.text = 'cur: '+formatMemoryValue(ram);
				//TODO: average ram
				
				avgRamText.text = 'avg: ';
				
				if (ram < minRam) {
					minRam = ram;
					minRamText.text = 'min: '+formatMemoryValue(minRam);
				}
				if (ram > maxRam) {
					maxRam = ram;
					maxRamText.text = 'max: '+formatMemoryValue(maxRam);
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
					curFpsText.text = 'cur: ' + fps;
					
					if (fps > maxFps) {
						maxFps = fps;
						maxFpsText.text = 'max: '+maxFps;
					}
					if (fps < minFps) {
						minFps = fps;
						minFpsText.text = 'min: '+minFps;
					}
					//TODO: average fps
					
					
					avgFpsText.text = 'avg: ';
					ticks = 0;
					lastTime = currentTime;
				}
			}
		}
		
		public function reset():void {
			//TODO: reset all data
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
		
		public function get backgroundColor():uint {
			return _backgroundColor;
		}
		
		public function set backgroundColor(value:uint):void {
			if(value!=_backgroundColor) {
				_backgroundColor = value;
				fillBackground = fillBackground;
			}
			
		}
		
		public function get fillBackground():Boolean {
			return _fillBackground;
		}
		
		public function set fillBackground(value:Boolean):void {
			_fillBackground = value;
			if (_fillBackground) {
				super.graphics.beginFill(_backgroundColor);
				super.graphics.drawRect(0, 0, textFieldsWidth, textFieldsHeight);
				super.graphics.endFill();
			} else {
				super.graphics.clear();
			}
		}
		
		public function get resetOnTouch():Boolean {
			return _resetOnTouch;
		}
		
		public function set resetOnTouch(value:Boolean):void {
			_resetOnTouch = value;
		}
		
	}
}