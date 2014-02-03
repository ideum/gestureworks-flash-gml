/**
 * @author Kyle J. Fitzpatrick
 */
package  {
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	
	public class Stats extends Sprite {
		
		private var _trackFPS:Boolean = true;
		private var _trackRAM:Boolean = true;
		private var _textColor:uint;
		private var _textBackgroundColor:uint;
		private var _textFillBackground:Boolean;
		private var _runningAverageDuration:uint;
		
		private var textFields:Vector.<TextField> = new Vector.<TextField>();
		private var curFpsText:TextField;
		private var avgFpsText:TextField;
		private var minFpsText:TextField;
		private var maxFpsText:TextField;
		private var curRamText:TextField;
		private var avgRamText:TextField;
		private var minRamText:TextField;
		private var maxRamText:TextField;
		
		private var time:int;
		private var prevTime:int = 0;
		private var fps:int;
		
		private var last:uint = getTimer();
		private var ticks:uint = 0;
		
		private var now:uint;
		private var delta:uint;
		
		public function Stats(xPos:int = 0, yPos:int = 0, color:uint = 0xffffff, fillBackground:Boolean = false, backgroundColor:uint = 0x000000, addListener:Boolean = true, runningAverageDuration:uint=60) {
			super();
			super.x = xPos;
			super.y = yPos;
			_textColor = color;
			_textFillBackground = fillBackground;
			_textBackgroundColor = backgroundColor;
			curFpsText = initializeField();
			avgFpsText = initializeField();
			minFpsText = initializeField();
			maxFpsText = initializeField();
			curRamText = initializeField();
			avgRamText = initializeField();
			minRamText = initializeField();
			maxRamText = initializeField();
			
			if (addListener) {
				super.addEventListener(Event.ENTER_FRAME, tick);
			}
		}
		
		private function initializeField():TextField {
			var tf:TextField = new TextField();
			tf.textColor = _textColor;
			tf.background = _textFillBackground;
			tf.backgroundColor = _textBackgroundColor;
			tf.text = '';
			super.addChild(tf);
			textFields.push(tf);
			return tf;
		}
		
		public function tick(e:Event = null):void {
			if (_trackFPS) {
				
			}
			
			if (_trackRAM) {
				
			}
		}
		
		
		public function get trackFPS():Boolean {
			return _trackFPS;
		}
		
		public function set trackFPS(value:Boolean):void {
			_trackFPS = value;
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
		
		public function get runningAverageDuration():uint {
			return _runningAverageDuration;
		}
		
		public function set runningAverageDuration(value:uint):void {
			if(value!=_runningAverageDuration) {
				_runningAverageDuration = value;
				/*TODO: */
			}
		}
		
		
		
	}

}