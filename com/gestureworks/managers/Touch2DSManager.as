package com.gestureworks.managers 
{
	import flash.geom.Vector3D;
	//import flash.geom.Matrix;
	//import flash.geom.Point;
	import flash.display.Sprite;
	
	import com.gestureworks.core.GestureGlobals;
	import com.gestureworks.core.GestureWorks;
	//import com.gestureworks.core.TouchSprite;
	import com.gestureworks.events.GWMotionEvent;
	import com.gestureworks.objects.MotionPointObject;
	import com.gestureworks.core.gw_public;
	
	import com.gestureworks.events.GWTouchEvent;
	import com.gestureworks.interfaces.ITouchObject;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.display.DisplayObjectContainer;
	import flash.geom.Point;
	import flash.utils.*;
	import flash.geom.Vector3D;


	/**
	 * The Leap3DSManager handles the parsing of leap type socket frame data from the device server.
	 *
	 * @author Ideum
	 *
	 */
	public class Touch2DSManager extends Sprite
	{
		private static var frame:XML
		private static var message:Object
		private static var inputType:String
		private static var frameId:int 
		private static var timestamp:int 
		private static var handCount:int
		private static var fingerCount:int
		private static var penCount:int
		private static var objectCount:int
		private static var debug:Boolean = false;
		
		private static var pids:Vector.<int> = new Vector.<int>();
		private static var pointList:Vector.<Object> = new Vector.<Object>();//Array = new Array()//
		private static var activePoints:Vector.<int> = new Vector.<int>();//Array= new Array()
		
		
		
		//private static var pids:Array= new Array()
		//private static var activePoints:Array;	
		//private static var pointList:Array = new Array();
		
		private static var _minX:Number = -180;
		private static var _maxX:Number = 180;
		
		private static var _minY:Number = 75;
		private static var _maxY:Number = 270;
		
		private static  var _pressureThreshold:Number = 1;
		private static  var _overlays:Vector.<ITouchObject> = new Vector.<ITouchObject>();
		
		/**
		 * The Leap3DSManager constructor allows arguments for screen and leap device calibration settings.
		 * @param	minX minimum Leap X coordinate
		 * @param	maxX maximum Leap X coordinate
		 * @param	minY minimum Leap Y coordinate
		 * @param	maxY maximum Leap Y coordinate
		 */
		
		//public function Leap3DSManager()
		public function Touch2DSManager(minX:Number=0, maxX:Number=0, minY:Number=0, maxY:Number=0) 
		{
			//trace("touch 2d server manager constructor");
			activePoints = new Vector.<int>()//Array();
			
			if (minX) this.minX = minX;
			if (maxX) this.maxX = maxX;
			if (minY) this.minY = minY;
			if (maxY) this.maxY = maxY;
			
			//stage = GestureWorks.application.stage;
		}

		public function processTouch2DSocketData(message:XML):void 
		{
			//trace(message)
			
				// CREATE POINT LIST
				pointList = new Vector.<Object>();
				fingerCount = int(message.InputPoint.Values.Surface.Point.length());
				penCount = int(message.InputPoint.Values.Surface.Pen.length());
				
				//trace(fingerCount)
				
				// CREATE Touch POINTS
				for (var k:int = 0; k < fingerCount; k++ )
				{
					var f =  message.InputPoint.Values.Surface.Point[k];
					var ptf:Object = new Object();
						ptf.id = f.@id;
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
			pids = new Vector.<int>();
			
			var pn:int = int(message.InputPoint.Values.Surface.Point.length());
				//push touch point ids
				for (var j:int = 0; j < pn; j++)
				{
					pids.push(int(message.InputPoint.Values.Surface.Point[j].@id));
					//trace("point id",int(message.InputPoint.Values.Surface.Point[j].@id));
				}
			//trace("pid array length",pids.length);
		}
		
		private static function getFramePoint(id:int):Object//Object 
		{
			var obj:Object//Object;
			for (var i:int = 0; i < pointList.length; i++)
			{
				if (id == pointList[i].id) obj = pointList[i];
			}
			return obj
		}
		

		private static function addRemoveUpdatePoints():void 
		{
			///////////////////////////////////////////////////////////////////////////
			//point removal
			var temp:Vector.<int> = activePoints;  //prevent concurrent mods

			for each(var aid:int in activePoints) {
				if (pids.indexOf(aid) == -1) {
					temp.splice(temp.indexOf(aid), 1);
					TouchManager.onTouchUp(new GWTouchEvent(null,GWTouchEvent.TOUCH_END, true, false, aid, false));
					trace("TOUCH REMOVED:", aid);					
				}
			}
			activePoints = temp;
			
			////////////////////////////////////////////////////////////////////////////
			//point addition and update
			for each(var pid:int in pids) 
			{
				var pt:Object = getFramePoint(pid);
				//trace("point",pt);
				
				if (pt) 
				{
					var point:Point = new Point();
						point.x = pt.x//map(pt.x, minX, maxX, 0, stage.stageWidth);
						point.y = pt.y//map(pt.y, minY, maxY, stage.stageHeight, 0);
						var pressure:Number = pt.pressure;// map(pt.z, minZ, maxZ, 0, 1);
						//var pressure:Number = pt.Width;
						//var pressure:Number = pt.Height;
						//trace("tip z:", pt.z, pressure);
					
					if (activePoints.indexOf(pid) == -1) 
					{
						var ev:GWTouchEvent;
						//hit test
						var obj:* = getTopDisplayObjectUnderPoint(point);
						
						if (obj || _overlays.length) {
							activePoints.push(pid);	
							ev = new GWTouchEvent(null, GWTouchEvent.TOUCH_BEGIN, true, false, pid, false, point.x, point.y);
								ev.stageX = pt.x;
								ev.stageY = pt.y;
								ev.pressure = pt.pressure;
								ev.source = Touch2DSManager//getDefinitionByName(getQualifiedClassName(this)) as Class; // error
								
								TouchManager.onTouchDown(ev);
								trace("touch down event", ev.target, obj,_overlays.length)//ev
								
								
								if (obj) {
									ev.target = obj;
									TouchManager.onTouchDown(ev);
								}
								
								//global overlays
								if (_overlays.length) {
									//TouchManager.processOverlays(ev, _overlays);
									InteractionManager.processOverlays(ev, _overlays);
								}
						}
						//trace("ADDED:", pid);		
					}
					
					else {
						var ev:GWTouchEvent = new GWTouchEvent(null, GWTouchEvent.TOUCH_MOVE, true, false, pid, false, point.x, point.y);
							ev.stageX = pt.x;
							ev.stageY = pt.y;
							ev.pressure = pt.pressure;
							
							TouchManager.onTouchMove(ev);
							trace("touch move event", ev.target,obj,_overlays.length)
												
						//if (_overlays.length) {
							//TouchManager.processOverlays(ev, _overlays);
						//}												
						//trace("UPDATE:", pid);
					}
				}

			}
		}
		
		/**
		 * Hit test
		 * @param	point
		 * @return
		*/ 
		private static function getTopDisplayObjectUnderPoint(point:Point):DisplayObject {
			var targets:Array =  GestureWorks.application.stage.getObjectsUnderPoint(point);
			var item:DisplayObject = (targets.length > 0) ? targets[targets.length - 1] : GestureWorks.application.stage;
			item = resolveTarget(item);
									
			return item;
		}	
		
		/**
		 * Determines the hit target based on mouseChildren settings of the ancestors
		 * @param	target
		 * @return
		 */
		private static function resolveTarget(target:DisplayObject):DisplayObject {
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
		private static function targetAncestors(target:DisplayObject, ancestors:Array = null):Array {
			
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
		
		
		
		public static function map(num:Number, min1:Number, max1:Number, min2:Number, max2:Number, round:Boolean = false, constrainMin:Boolean = true, constrainMax:Boolean = true):Number
		{
			if (constrainMin && num < min1) return min2;
			if (constrainMax && num > max1) return max2;
		 
			var num1:Number = (num - min1) / (max1 - min1);
			var num2:Number = (num1 * (max2 - min2)) + min2;
			if (round) return Math.round(num2);
			return num2;
		}
		


	}
}
