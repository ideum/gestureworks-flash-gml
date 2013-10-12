package com.gestureworks.utils
{
	import com.gestureworks.events.GWTouchEvent;
	import com.gestureworks.managers.TouchManager;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.TouchEvent;
	import flash.geom.Point;
	import flash.media.Sound;
	import flash.net.FileReference;
	import flash.net.registerClassAlias;
	import flash.utils.*;
	import flash.utils.ByteArray;
	
	/*
	 * Recorder.as 
	 * Consult onKey() function for controls. Requres TouchProxyEvent.as
	 */
	public class Recorder extends Sprite {
		private var bytes:ByteArray;
		private var recording:Boolean;		
		private var replaying:Boolean;
		private var fr:FileReference;		
		private var touchEvents:Array;
		private var frameEvents:Array;
		private var touchBeginTime:Number;
		private var frameIndex:uint;
		private var replayIndex:uint;
		private var touchEndMarked:Boolean;

		/**
		 * Constructor
		 */
		public function Recorder():void {
			if (stage)
				init(null, null);
			else
				addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		/**
		 * Init, prepares the class.
		 * @param	e Event the will trigger init
		 * @param	presetGeustures ByteArray if you want to send prerecorded gestures
		 */
		public function init(e:Event=null, presetGeustures:ByteArray = null):void {
			registerClassAlias("TouchEventProxy", TouchEventProxy);  						
			
			if (presetGeustures) {
				binFileLoaded(null, presetGeustures);
			}
			bytes = new ByteArray;
			recording = false;
			replaying = false;
			touchEvents = [];
			frameEvents = [];
			frameIndex = 0;
			touchEndMarked = false;
			
			stage.addEventListener(TouchEvent.TOUCH_BEGIN, onTouch);
			stage.addEventListener(TouchEvent.TOUCH_MOVE,  onTouch);
			stage.addEventListener(TouchEvent.TOUCH_END,   onTouch);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKey);
			stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);			
		}
		
		private function onTouch(e:TouchEvent):void {
			if (replaying) {
				return;
			}
			var proxy:TouchEventProxy = new TouchEventProxy(e);
			switch (proxy.type){
				case TouchEvent.TOUCH_BEGIN:
					touchBeginTime = getTimer();
					recording = true;
					break;			
				case TouchEvent.TOUCH_END:
					trace("sequence duration", getTimer() - touchBeginTime);
					touchEndMarked = true;
					break;
			}	
			touchEvents.push(proxy);			
			drawCircle(proxy);
		}		
		
		// enter frame: recording and replaying 
		private function onEnterFrame(e:Event=null):void {	
			if (!replaying) {
				if (recording || touchEndMarked) {
					if (touchEvents.length) {
						for (var j:int = 0; j < touchEvents.length; j++) {
							touchEvents[j].frame = frameIndex;
						}
						frameEvents.push(touchEvents);				
						touchEvents = [];
					}
					touchEndMarked = false;
				}
			}
			
			else if (replaying && frameEvents.length == 0) {
				replaying = false;
				touchEvents = [];
				return;
			}
			
			else if (replaying) {
				if (frameEvents[replayIndex][0].frame == frameIndex){
					touchEvents = frameEvents[replayIndex];
					for (var i:int = 0; i < touchEvents.length; i++) {
						var proxy:TouchEventProxy = touchEvents[i];
						var event:GWTouchEvent = new GWTouchEvent(null, proxy.type, proxy.bubbles, proxy.cancelable, proxy.touchPointID, proxy.isPrimaryTouchPoint, proxy.localX, proxy.localY);
						event.stageX = proxy.stageX;
						event.stageY = proxy.stageY;
						event.target = getTopDisplayObjectUnderPoint(new Point(event.stageX, event.stageY));
						switch (proxy.type){
							case TouchEvent.TOUCH_BEGIN:
								touchBeginTime = getTimer();
								TouchManager.onTouchDown(event);
								break;
							case TouchEvent.TOUCH_MOVE:
								TouchManager.onTouchMove(event);
								break;
							case TouchEvent.TOUCH_END:
								trace("replay sequence duration", getTimer() - touchBeginTime);
								TouchManager.onTouchUp(event);
								break;
						}
						drawCircle(proxy);
					}
					replayIndex++;
				}
				
				// stop replay
				if (replayIndex == frameEvents.length) {
					replaying = false;
					touchEvents = [];
					return;
				}
			}	
			
			if (recording || replaying) {
				frameIndex++;
			}			
		}
		
		/**
		 * Enable replaying, will begin on the next frame
		 */
		public function replay():void {
			if (replaying) {
				return; 
			}
			replaying = true;
			frameIndex = 0;
			replayIndex = 0;
			clearCanvas();			
		}
		
		//-----
		// Interaction, recording, playback
		//-----
		private function onKey(e:KeyboardEvent):void{	
			if (replaying)
				return;
							
			switch (e.charCode) {
				case 32: //space, anim replay
					trace("\nReplay");
					replay();
					break;
				case 101: // 'e'
					recording = false;
					break;	
				case 108: //'l' load
					readBinFile();
					break;
				case 115: //'s' save
					bytes.position = 0;
					for each (var frame:Array in frameEvents) {
						for each (var touch:TouchEventProxy in frame) {
							bytes.writeObject(touch);
						}
					}
					writeBinFile( bytes );
					bytes.clear();
					break;
				case 99: //'c'
					clearAll();
					break;
				case 118: 
					//validate();	 
					break;
				default:
					break;
			}
		}
		
		//-----
		//Drawing, erasing
		//-----
		private function drawCircle(e:TouchEventProxy):void {
			var s:Sprite = new Sprite;
			var radius:int = 10;
			switch (e.type) {
				case "touchBegin" : 
					this.graphics.beginFill(replaying ? 0x000000 : 0x33ff66);
					this.graphics.drawCircle(e.stageX, e.stageY, radius);
					this.graphics.endFill();
					break;
				case "touchMove" :
					this.graphics.beginFill(replaying ? 0x999999 : 0x6666ff);
					this.graphics.drawCircle(e.stageX,  e.stageY, radius);
					this.graphics.endFill();		
				break;
				case "touchEnd" : 
					this.graphics.beginFill(replaying ? 0xdddddd : 0xff6666);
					this.graphics.drawCircle(e.stageX, e.stageY, radius);
					this.graphics.endFill();
					break;
				default:
					break;
			}
		}
		
		/**
		 * Clears graphics
		 */
		public function clearCanvas():void {
			this.graphics.clear();
			//removeChildren();
		}
		
		/**
		 * Clears graphics and recorded gestures.
		 */
		public function clearAll():void {
			frameEvents = [];
			frameIndex = 0;
			this.graphics.clear();
		}
		
		// -----
		// Touch point handling
		// -----
		private function getTopDisplayObjectUnderPoint(point:Point):DisplayObject {
			var targets:Array =  stage.getObjectsUnderPoint(point);
			var item:DisplayObject = (targets.length > 0) ? targets[targets.length - 1] : stage;
			item = resolveTarget(item);
			return item;
		}
		
		private function resolveTarget(target:DisplayObject):DisplayObject {
			var ancestors:Array = targetAncestors(target, new Array(target));			
			var trueTarget:DisplayObject = target;
			
			for each(var t:DisplayObject in ancestors) {
				if (t is DisplayObjectContainer && !DisplayObjectContainer(t).mouseChildren)
				{
					trueTarget = t;
					break;
				}
			}
			return trueTarget;
		}

		private function targetAncestors(target:DisplayObject, ancestors:Array = null):Array {
			if (!ancestors)
				ancestors = new Array();
				
			if (!target.parent || target.parent == target.root)
				return ancestors;
			else {
				ancestors.unshift(target.parent);
				ancestors = targetAncestors(target.parent, ancestors);
			}
			return ancestors;
		}
		
		private function deserializeForReplay(b:ByteArray):Array {
			var arr:Array = new Array;
			var obj:TouchEventProxy;
			var pos1:uint;
			
			return arr;
		}
		
		//-----
		//File writing - reading
		//-----
		//private function writeGMLFile(gml:XML):void{
			//var ba:ByteArray = new ByteArray();
			//ba.writeUTFBytes(gml);
			//fr = new FileReference();
			//fr.addEventListener(Event.SELECT, _onRefSelect);
			//fr.addEventListener(Event.CANCEL, _onRefCancel);
			//fr.save(ba, "mygesture.gml");
		//}
		
		public function writeBinFile(ba:ByteArray):void{
			fr = new FileReference();
			fr.addEventListener(Event.SELECT, _onRefSelect);
			fr.addEventListener(Event.CANCEL, _onRefCancel);
			
			fr.save(ba, "mygesture.gwb");
			
			fr.removeEventListener(Event.SELECT, _onRefSelect);
			fr.removeEventListener(Event.CANCEL, _onRefCancel);
		}
		
		/**
		 * Create new file reference to load file, will trigger explorer dialog
		 */
		public function readBinFile():void {
			fr = new FileReference();
			fr.addEventListener(Event.SELECT, binFileSelected);
			fr.addEventListener(Event.COMPLETE, binFileLoaded);
			fr.browse();
		}
		
		private function binFileSelected (e:Event):void {
			fr.load();
		}
		
		/**
		 * File selected and loaded, file parsed here.
		 * @param	e Event which triggers funciton, usually Event.Complete.
		 * @param	preloadedBytes ByteArray with prerecorded gestures.
		 */
		public function binFileLoaded(e:Event=null, preloadedBytes:ByteArray=null):void {
			var tmpBytes:ByteArray;
			
			if (!preloadedBytes)
				tmpBytes = fr.data;
			else
				tmpBytes = preloadedBytes;
			
			var obj:TouchEventProxy;
			var pos1:uint;
			
			while (tmpBytes.bytesAvailable) {
				pos1 = tmpBytes.position;
				obj = tmpBytes.readObject() as TouchEventProxy;
				bytes.writeObject(obj);
			}
			
			bytesToFrames();
			
			//trace("Gesture recording loaded");
			fr.removeEventListener(Event.SELECT, binFileSelected);
			fr.removeEventListener(Event.COMPLETE, binFileLoaded);
		}
		
		private function bytesToFrames():void {
			var tmpFrames:Array = new Array;
			bytes.position = 0;
			while (bytes.bytesAvailable) {
				tmpFrames.push(bytes.readObject() as TouchEventProxy);
			}
			
			var tmpTouches:Array = new Array;
			var frameNum:uint = 0;
			for (var i:uint; i < tmpFrames.length; i++){
				if (frameNum != tmpFrames[i].frame) {
					frameEvents.push(tmpTouches);
					tmpTouches = [];
					frameNum = tmpFrames[i].frame
				}
				tmpTouches.push(tmpFrames[i]);
			}
			frameEvents.push(tmpTouches);
		}
		
		private function _onRefSelect(e:Event):void{
			trace('select');
		}
		
		private function _onRefCancel(e:Event):void{
			trace('cancel');
		}
		
		private function map(v:Number, a:Number, b:Number, x:Number=0, y:Number=1):Number {
			return (v == a) ? x : (v - a) * (y - x) / (b - a) + x;
		}		
		
	}
}