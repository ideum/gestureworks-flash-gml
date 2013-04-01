package  
{
	import flash.display.InteractiveObject;
	import flash.events.TouchEvent;
	import flash.text.ReturnKeyLabel;
	import flash.utils.*;
	/**
	 * ...
	 * @author 
	 */
	public class TouchEventProxy
	{		
		public var altKey:Boolean;
		public var commandKey:Boolean;
		public var controlKey:Boolean;
		public var ctrlKey:Boolean;
		public var isPrimaryTouchPoint:Boolean;
		public var isRelatedObjectInaccessible:Boolean;
		public var isTouchPointCanceled:Boolean
		public var localX:Number;
		public var localY:Number;
		public var pressure:Number;
		public var relatedObject:InteractiveObject;
		public var shiftKey:Boolean;
		public var sizeX:Number;
		public var sizeY:Number;
		public var timestamp:Number;
		public var timeIntent:String;
		public var touchPointID:int;
		
		public var type:String;
		public var bubbles:Boolean;
		public var cancelable:Boolean;
		public var stageX:int;
		public var stageY:int;
		public var time:uint;
		
		
	
		public function TouchEventProxy (e:TouchEvent=null) {
				
				if (!e) return;
				this.type = e.type;
				this.bubbles = e.bubbles;
				this.cancelable = e.cancelable;
				this.touchPointID = e.touchPointID;
				this.isPrimaryTouchPoint = e.isPrimaryTouchPoint;
				this.localX = e.localX;
				this.localY = e.localY;
				this.sizeX = e.sizeX;
				this.sizeY = e.sizeY;
				this.pressure = e.pressure;
				this.relatedObject = e.relatedObject;
				this.ctrlKey = e.ctrlKey;
				this.altKey = e.altKey;
				this.shiftKey = e.shiftKey;
				this.commandKey = e.commandKey;
				this.controlKey = e.controlKey;
				this.timestamp = e.timestamp;
				//this.touchIntent = e.touchIntent;
				//this.samples = e.samples;
				this.isTouchPointCanceled = e.isTouchPointCanceled;
				this.stageX = e.stageX;
				this.stageY = e.stageY;
				
				//this.time = getTimer();
			}
			
		
			
	}

}