package com.gestureworks.managers 
{

	//import com.gestureworks.events.GWTouchEvent;
	import com.gestureworks.interfaces.ITouchObject;
	import com.gestureworks.objects.TouchPointObject;
	
	import flash.display.DisplayObject;
	//import flash.display.Sprite;
	import flash.display.DisplayObjectContainer;
	import flash.geom.Point;
	import flash.utils.*;
	import flash.geom.Vector3D;
	
	/**
	 * @author
	 */
	public class Leap2DSManager extends Sprite
	{	
		private static var pids:Array= new Array()
		private static var activePoints:Array;	
		private static var pointList:Array = new Array();
		
		//private static var pids:Vector.<int> = new Vector.<int>();
		//private static var pointList:Vector.<TouchPointObject> = new Vector.<TouchPointObject>();
		//private static var activePoints:Vector.<int> = new Vector.<int>();
		
		
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
		public function Leap2DSManager(minX:Number=0, maxX:Number=0, minY:Number=0, maxY:Number=0, minZ:Number=0, maxZ:Number=0) 
		{
			trace("leap 2d server manager constructor");
			activePoints = new Array();
			
			if (minX) this.minX = minX;
			if (maxX) this.maxX = maxX;
			if (minY) this.minY = minY;
			if (maxY) this.maxY = maxY;
			if (minZ) this.minZ = minZ;
			if (maxZ) this.maxZ = maxZ;
		}
		
		public static function processLeap2DSocketData(frame:XML):void 
		{
				message = frame.Messages.Message;
			//	trace(message)
				
				handCount = int(message.InputPoint.Values.Hand.length());

				// CREATE POINT LIST
				pointList = new Array();
				
				for (var j:int = 0; j < handCount; j++ )
				{
					fingerCount = int(message.InputPoint.Values.Hand[j].@FingerCount);
					
					// CREATE FINGER TIP MOTION POINTS
					for (var k:int = 0; k < fingerCount; k++ )
					{
						var f =  message.InputPoint.Values.Hand[j].Finger[k];
						
						var ptf:TouchPointObject = new TouchPointObject();
							ptf.id = f.@id; 
							ptf.position.x = f.Position.@x; 
							ptf.position.y = f.Positon.@y;
							ptf.position.z = f.Position.@z*-1; 
							//ptf.pressure = f.@pressure;
							//ptf.size.x = f.@width;
							//ptf.size.y = f.@height;
						pointList.push(ptf);
					}
					
					//PUSH IDS
					pids.push(int(f.Messages.Message.InputPoint.Values.Hand[i].Finger[j].@id)) 
				}
			
				// CALL LEAP PROCESSING
				//processLeap2DData(frame);
				
				addRemoveUpdatePoints();
				
		}
		
		
		/**
		 * Process points
		 * @param	event
		 */
		/*
		private static function processLeap2DData(frame:XML):void 
		{
			pushids(frame);
			addRemoveUpdatePoints();
		}
		private static function pushids(frame:XML):void 
		{
			//store frame's point ids
			pids = new Array();
			
			var f = frame;
			var hn:int = int(f.Messages.Message.InputPoint.Values.length());
			var fn:int;

			//CREATE HANDS THEN... FINGERS AND TOOLS
			for (var i:int = 0; i < hn; i++)
			{
				fn = int(f.Messages.Message.InputPoint.Values.Hand[i].@FingerCount);
	
				//finger points
				for (var j:int = 0; j < int(f.Messages.Message.InputPoint.Values.Hand[i].@FingerCount); j++)
				{
					pids.push(int(f.Messages.Message.InputPoint.Values.Hand[i].Finger[j].@id)) 
					//trace("FINGERID",f.Messages.Message.InputPoint.Values.Hand[i].Finger[j].@id);
				}
			}
			//trace("pid array length",pids.length);
		}
		*/
		
		private static function addRemoveUpdatePoints():void 
		{
			///////////////////////////////////////////////////////////////////////////
			//point removal
			var temp:Array = activePoints;  //prevent concurrent mods
			
			for each(var aid:int in activePoints) {
				if (pids.indexOf(aid) == -1) {
					temp.splice(temp.indexOf(aid), 1);
					TouchManager.onTouchUpPoint(aid);
					//trace("REMOVED:", aid);					
				}
			}
			activePoints = temp;
			
			////////////////////////////////////////////////////////////////////////////
			//point addition and update
			for each(var pid:Number in pids) 
			{
				var pt = getFramePoint(pid);
				
				if (pt) 
				{
				var point:Point = new Point();
					point.x = map(pt.position.x, minX, maxX, 0, stage.stageWidth);
					point.y = map(pt.position.y, minY, maxY, stage.stageHeight, 0);
				
				pt.position.x = point.x
				pt.position.y = point.y;
				pt.position.z = 0
				pt.pressure = map(pt.z, minZ, maxZ, 0, 1);
				
				pt.touchPointID = pt.id;


				if (activePoints.indexOf(pid) == -1)
				{								
					activePoints.push(pid);		
					TouchManager.onTouchDownPoint(pt);
					//trace("ADDED:", pid);		
				}
				else {
					if (activePoints.indexOf(pid) != -1 && pt.pressure > pressureThreshold)
					{
						activePoints.splice(activePoints.indexOf(pid), 1);
						TouchManager.onTouchUpPoint(pt);
						//trace("REMOVED:", pid);					
					}
					else{
						TouchManager.onTouchMovePoint(pt);
						//trace("UPDATE:", pid);							
					}
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
		 * Destructor
		 */
		override public function dispose():void 
		{
			super.dispose();
			activePoints = null;
		}
	}

}