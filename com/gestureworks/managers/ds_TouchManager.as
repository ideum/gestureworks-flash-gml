package com.gestureworks.managers 
{

	import com.gestureworks.events.GWTouchEvent;
	import com.gestureworks.interfaces.ITouchObject;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.display.DisplayObjectContainer;
	import flash.geom.Point;
	import flash.utils.*;
	import flash.geom.Vector3D;
	
	/**
	 * @author
	 */
	public class ds_TouchManager extends Sprite
	{	
		private static var pids:Array= new Array()
		private static var activePoints:Array;	
		private static var pointList:Array = new Array();
		
		private static var frame:XML
		private static var message:Object
		private static var inputType:String 
		private static var handCount:int
		private static var fingerCount:int
		
		
		
		private static var _minX:Number = -180;
		private static var _maxX:Number = 180;
		
		private static var _minY:Number = 75;
		private static var _maxY:Number = 270;
		
		private static var _minZ:Number = -110;
		private static var _maxZ:Number = 200;
		
		private static  var _pressureThreshold:Number = 1;
		private static  var _overlays:Vector.<ITouchObject> = new Vector.<ITouchObject>();		
		
		/**
		 * The Leap2DManager constructor allows arguments for screen and leap device calibration settings. The settings will map x and y Leap coordinate ranges to screen 
		 * coordinates and the Leap z range to pressure. The calibration is only valid as long as the relative position of the Leap device and the monitor remain constant. 
		 * @param	minX minimum Leap X coordinate
		 * @param	maxX maximum Leap X coordinate
		 * @param	minY minimum Leap Y coordinate
		 * @param	maxY maximum Leap Y coordinate
		 * @param	minZ minimum Leap Z coordinate
		 * @param	maxZ maximum Leap Z coordinate
		 */
		public function ds_TouchManager(minX:Number=0, maxX:Number=0, minY:Number=0, maxY:Number=0) 
		{
			trace("touch 2d server manager constructor");
			activePoints = new Array();
			
			if (minX) this.minX = minX;
			if (maxX) this.maxX = maxX;
			if (minY) this.minY = minY;
			if (maxY) this.maxY = maxY;
		}

		public function processTouch2DSocketData(message:XML):void 
		{
				// CREATE POINT LIST
				pointList = new Array();
				fingerCount = int(message.InputPoint.Values.Surface.Point.length());
				
				// CREATE Touch POINTS
				for (var k:int = 0; k < fingerCount; k++ )
				{
					var f =  message.InputPoint.Values.Surface.Point[k];
					var ptf:Object = new Object();
						ptf.x = f.@x; 
						ptf.y = f.@y;
						ptf.pressure = f.@pressure;
						ptf.width = f.@width;
						ptf.height = f.@height;
					pointList.push(ptf);
				}
				// CALL LEAP PROCESSING
				processTouch2DData(message);
		}
		
		
		/**
		 * Process points
		 * @param	event
		 */
		private static function processTouch2DData(message:XML):void 
		{
			pushids(message);
			addRemoveUpdatePoints();
		}
		private static function pushids(message:XML):void 
		{
			//store frame's point ids
			pids = new Array();
			
			var pn:int = int(message.InputPoint.Values.Surface.Point.length());
				//push touch point ids
				for (var j:int = 0; j < pn; j++)
				{
					pids.push(int(message.InputPoint.Values.Surface.Point[j].@Id)) 
				}
			//trace("pid array length",pids.length);
		}
		
		
		private static function addRemoveUpdatePoints():void 
		{
			///////////////////////////////////////////////////////////////////////////
			//point removal
			var temp:Array = activePoints;  //prevent concurrent mods

			for each(var aid:int in activePoints) {
				if (pids.indexOf(aid) == -1) {
					temp.splice(temp.indexOf(aid), 1);
					TouchManager.onTouchUp(new GWTouchEvent(null,GWTouchEvent.TOUCH_END, true, false, aid, false));
					//trace("REMOVED:", aid);					
				}
			}
			activePoints = temp;
			
			////////////////////////////////////////////////////////////////////////////
			//point addition and update
			for each(var pid:Number in pids) 
			{
				var pt = getFramePoint(pid);
				
				var point:Point = new Point();
					point.x = pt.x//map(pt.x, minX, maxX, 0, stage.stageWidth);
					point.y = pt.y//map(pt.y, minY, maxY, stage.stageHeight, 0);
				var pressure:Number = pt.pressure;// map(pt.z, minZ, maxZ, 0, 1);
				//var pressure:Number = pt.Width;
				//var pressure:Number = pt.Height;
				//trace("tip z:", pt.z, pressure);
				
					if (pt) 
					{
					if (activePoints.indexOf(pid) == -1) 
					{
						var ev:GWTouchEvent;
						//hit test
						//var obj:* = getTopDisplayObjectUnderPoint(point);
						
						//if (obj || overlays.length) {
							activePoints.push(pid);	
							ev = new GWTouchEvent(null, GWTouchEvent.TOUCH_BEGIN, true, false, pid, false, point.x, point.y);
								ev.stageX = pt.x;
								ev.stageY = pt.y;
								ev.pressure = pt.pressure;
								//ev.source = getDefinitionByName(getQualifiedClassName(this)) as Class; // error
								
								TouchManager.onTouchDown(ev);
								
								/*
								if (obj) {
									ev.target = obj;
									TouchManager.onTouchDown(ev);
								}
								
								//global overlays
								if (overlays.length) {
									TouchManager.processOverlays(ev, overlays);
								}*/
						//}
						//trace("ADDED:", pid);		
					}
					
					else {
						var ev = new GWTouchEvent(null, GWTouchEvent.TOUCH_MOVE, true, false, pid, false, point.x, point.y);
							ev.stageX = pt.x;
							ev.stageY = pt.y;
							ev.pressure = pt.pressure;
							TouchManager.onTouchMove(ev);
												
						//if (overlays.length) {
							//TouchManager.processOverlays(ev, overlays);
						//}												
						//trace("UPDATE:", pid);
					}
				}

			}
		}
		
		
		private static function getFramePoint(id:int):Object 
		{
			var obj:Object;
			for (var i:int = 0; i < pointList.length; i++)
			{
				if (id == pointList[i].id) obj = pointList[i];
			}
			return obj
		}
			

		/**
		 * Hit test
		 * @param	point
		 * @return
		*/ 
		private function getTopDisplayObjectUnderPoint(point:Point):DisplayObject {
			var targets:Array =  stage.getObjectsUnderPoint(point);
			var item:DisplayObject = (targets.length > 0) ? targets[targets.length - 1] : stage;
			item = resolveTarget(item);
									
			return item;
		}	
		
		/**
		 * Determines the hit target based on mouseChildren settings of the ancestors
		 * @param	target
		 * @return
		 */
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
				
		/**
		 * Returns a list of the supplied target's ancestors sorted from highest to lowest
		 * @param	target
		 * @param	ancestors
		 * @return
		 */
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
		
		/**
		 * The lowest x of the Leap x-coordinate range
		 * @default -180
		 */
		public function get minX():Number { return _minX; }
		public function set minX(x:Number):void {
			_minX = x;
		}
		
		/**
		 * The highest x of the Leap x-coordinate range
		 * @default 180
		 */
		public function get maxX():Number { return _maxX; }
		public function set maxX(x:Number):void {
			_maxX = x;
		}
		
		/**
		 * The lowest y of the Leap y-coordinate range
		 * @default 75
		 */
		public function get minY():Number { return _minY; }
		public function set minY(y:Number):void {
			_minY = y;
		}
		
		/**
		 * The highest y of the Leap y-coordinate range
		 * @default 270
		 */
		public function get maxY():Number { return _maxY; }
		public function set maxY(x:Number):void {
			_maxY = x;
		}
		
		/**
		 * The lowest z of the Leap z-coordinate range. Mapped to touch pressure. 
		 * @default -110
		 */
		public function get minZ():Number { return _minZ; }
		public function set minZ(z:Number):void {
			_minZ = z;
		}
		
		/**
		 * The highest z of the Leap z-coordinate range. Mapped to touch pressure. 
		 * @default 200
		 */
		public function get maxZ():Number { return _maxZ; }
		public function set maxZ(z:Number):void {
			_maxZ = z;
		}	
		
		/**
		 * Defines a point registration threshold, based on pressure(Z coordinate), providing the control to decrease
		 * the entry point of the device's interactive field. 
		 * @default 1
		 */
		public function get pressureThreshold():Number { return _pressureThreshold; }
		public function set pressureThreshold(p:Number):void {
			_pressureThreshold = p;
		}
		
		/**
		 * Registers global overlays to receive point data
		 */
		public function get overlays():Vector.<ITouchObject> { return _overlays; }
		public function set overlays(o:Vector.<ITouchObject>):void {
			_overlays = o;
		}
		

	}

}