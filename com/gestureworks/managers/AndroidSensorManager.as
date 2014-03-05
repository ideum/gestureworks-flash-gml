package com.gestureworks.managers 
{
	import com.gestureworks.core.GestureGlobals;
	import com.gestureworks.core.GestureWorks;
	import com.gestureworks.objects.SensorPointObject;
	import com.gestureworks.core.gw_public;
	
	import flash.geom.Vector3D;


	/**
	 * The Leap3DSManager handles the parsing of leap type socket frame data from the device server.
	 *
	 * @author Ideum
	 *
	 */
	public class AndroidSensorManager 
	{
		private static var frame:XML
		private static var message:Object
		private static var inputType:String
		private static var frameId:int 
		private static var timestamp:int 
		private static var count:int
		private static var objectCount:int
		private static var debug:Boolean = false;
		
		private static var pids:Vector.<int> = new Vector.<int>();
		private static var pointList:Vector.<SensorPointObject> = new Vector.<SensorPointObject>();
		private static var activePoints:Vector.<int> = new Vector.<int>();
		
		private static var _minX:Number;
		private static var _maxX:Number;
		private static var _minY:Number;
		private static var _maxY:Number;
		
		//public static var touchPoints:Dictionary = new Dictionary();
		
		public function AndroidSensorManager(minX:Number=0, maxX:Number=0, minY:Number=0, maxY:Number=0) 
		{
			trace("sensor 6d server manager constructor");
			activePoints = new Vector.<int>()
			
			//if (minX) this.minX = minX;
		//	if (maxX) this.maxX = maxX;
			//if (minY) this.minY = minY;
			//if (maxY) this.maxY = maxY;
			
			//stage = GestureWorks.application.stage;
			
			//touchPoints = GestureGlobals.gw_public::touchPoints;
		}

		public function processAndroidSensorSocketData(xmlList:XMLList):void 
		{
				// CREATE POINT LIST
				pids = new Vector.<int>();
				
				//trace(xmlList);
				
					var p = xmlList.Acceleration[0];
					var pte:SensorPointObject = new SensorPointObject();
						pte.id = 0//p.@id;
						pte.acceleration = new Vector3D (p.@x, p.@y, p.@z);
						//pte.RotationSpeed = new Vector3D (p.@x, p.@y,0);
						pte.type = "accelerometer";
					pointList.push(pte);
					
					//PUSH IDS
					pids.push(int(p.@id));
				
					addRemoveUpdatePoints();
					//trace(pte.position, e.@x, e.@id)
		}
		
		
		/**
		 * Process points
		 * @param	event
		 */

		private static function getFramePoint(id:int):SensorPointObject//Object 
		{
			var obj:SensorPointObject//Object;
			for (var i:int = 0; i < pointList.length; i++)
			{
				if (id == pointList[i].id) obj = pointList[i];
			}
			return obj
		}
		
		private static function addRemoveUpdatePoints():void 
		{
			//trace("touch add remove update----------------------------------------------------", pointList.length, activePoints.length)
			/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
			//POINT REMOVAL//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
			for each(var aid:int in activePoints) 
			{
				//trace("aid", aid, pids.length, pids.indexOf(aid), pids.indexOf(456))
				if (pids.indexOf(aid) == -1) {
					
					// remove ref from activePoints list
					activePoints.splice(activePoints.indexOf(aid), 1);

					//MotionManager.onMotionEnd(new GWMotionEvent(GWMotionEvent.MOTION_END, mp, true, false));
					//TouchManager.onTouchUp(new GWTouchEvent(null, GWTouchEvent.TOUCH_END, true, false, aid, false));
					//TouchManager.onTouchUpPoint(touchPoints[aid]);
					//TouchManager.onTouchUpPoint(aid);
					SensorManager.onSensorEndPoint(aid);
					//trace("TOUCH POINT REMOVED:",aid);
				}
				
				//trace("active point aid",aid)
			}

			///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
			//POINT ADDITION AND UPDATE////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
			for each(var pid:int in pids) //number
			{
				var pt:SensorPointObject = getFramePoint(pid);
				
				//trace("retrived point",pt);
				
				if (pt) 
				{
					//trace("retrived point",pt.id);
					
					/*var tp:TouchPointObject = new TouchPointObject();
						tp.touchPointID = pt.id;
						tp.position = new Vector3D(pt.position.x, pt.position.y, pt.position.z);
						tp.sizeX = pt.size.x;
						tp.sizeY = pt.size.y;
						*/
					/*	
					var te:GWTouchEvent = new GWTouchEvent();
						te.touchPointID = pt.id;////////////////////////////////////????????????
						//te.type = "touchBegin";
						te.stageX = pt.position.x;
						te.stageY = pt.position.y;
						te.stageZ = pt.position.z;
						te.sizeX = 0;
						te.sizeY = 0;
						*/
						
						pt.sensorPointID = pt.id;////???????????????????????
						
						
					if (activePoints.indexOf(pid) == -1) 
					{
						activePoints.push(pid);	
						SensorManager.onSensorBeginPoint(pt);
						//trace("TOUCH POINT ADDED:", pid);		
					}
					else {
						SensorManager.onSensorUpdatePoint(pt)	
						//trace("TOUCH POINT UPDATE:", pid);
					}
					//trace(pt.size.x,pt.size.y, pt.pressure)
				}
				//trace("pids pid",pid)
			}
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
