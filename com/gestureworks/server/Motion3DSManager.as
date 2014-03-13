package com.gestureworks.server 
{
	import com.gestureworks.core.GestureGlobals;
	import com.gestureworks.events.GWMotionEvent;
	import com.gestureworks.objects.MotionPointObject;
	import com.gestureworks.managers.MotionManager;
	
	import flash.geom.Vector3D;

	/**
	 * The Leap3DSManager handles the parsing of leap type socket frame data from the device server.
	 *
	 * @author Ideum
	 *
	 */
	public class Motion3DSManager
	{
		//private static var frame:XML
		//private static var message:Object
		private static var inputType:String
		private static var frameId:int 
		private static var timestamp:int 
		private static var handCount:int
		private static var fingerCount:int
		private static var objectCount:int
		private static var debug:Boolean = false;
		
		private static var pids:Vector.<int> = new Vector.<int>();
		private static var pointList:Vector.<MotionPointObject> = new Vector.<MotionPointObject>();
		private static var activePoints:Vector.<int> = new Vector.<int>();
		
		private static var _minX:Number = -180;
		private static var _maxX:Number = 180;
		private static var _minY:Number = 75;
		private static var _maxY:Number = 270;
		private static var _minZ:Number = -110;
		private static var _maxZ:Number = 200;
		
		/**
		 * The Leap3DSManager constructor allows arguments for screen and leap device calibration settings.
		 * @param	minX minimum Leap X coordinate
		 * @param	maxX maximum Leap X coordinate
		 * @param	minY minimum Leap Y coordinate
		 * @param	maxY maximum Leap Y coordinate
		 * @param	minZ minimum Leap Z coordinate
		 * @param	maxZ maximum Leap Z coordinate
		 */
		
		public function Motion3DSManager(minX:Number=0, maxX:Number=0, minY:Number=0, maxY:Number=0, minZ:Number=0, maxZ:Number=0) 
		{
			trace("leap 3d server manager constructor");
			
			if (minX) this.minX = minX;
			if (maxX) this.maxX = maxX;
			if (minY) this.minY = minY;
			if (maxY) this.maxY = maxY;
			if (minZ) this.minZ = minZ;
			if (maxZ) this.maxZ = maxZ;
			
			//debug = true;
		}

		public function processMotion3DSocketData(handList:XMLList):void 
		{
			//trace("prcess motion socket data")
				//message = frame.Messages.Message;
				//trace(message)
				
				handCount = int(handList.length());//int(message.InputPoint.Values.Hand.length());
				//handOrientation = message.InputPoint.Values.Hand.@orientation; //up/down
				//handType = message.InputPoint.Values.Hand.@type; //left/right
				//handSplay
				
				//trace("hand count",handCount);

				// CREATE POINT LIST
				pointList = new Vector.<MotionPointObject>//Array();
				pids = new Vector.<int>;
				
				for (var j:uint = 0; j < handCount; j++ )
				{
				fingerCount = int(handList[j].@FingerCount);// int(message.InputPoint.Values.Hand[j].@FingerCount);
				objectCount = int(handList[j].@ObjectCount);//int(message.InputPoint.Values.Hand[j].@ObjectCount)
				//trace("3ds manager",handCount, fingerCount, objectCount);
				
				
				// CREATE FINGER TIP MOTION POINTS
				for (var k:uint = 0; k < fingerCount; k++ )
				{
					//var f:Object =  message.InputPoint.Values.Hand[j].Finger[k];
					var f:Object =  handList[j].Finger[k];
					
					var ptf:MotionPointObject = new MotionPointObject();// new Object();
						ptf.type = "finger";
						//ptf.fingerID = f.@fingerType
						//ptf.extension
						ptf.handID = j;
						ptf.id = f.@id;
						ptf.position = new Vector3D(f.Position.@x, f.Position.@y, f.Position.@z * -1);
						ptf.direction = new Vector3D(f.Direction.@x, f.Direction.@y, f.Direction.@z * -1);
						//ptf.velocity = new Vector3D(f.Velocity.@x, f.Velocity.@y, f.Velocity.@z*-1);
						ptf.width = f.@Width;
						ptf.length = f.@Length;
						
					pointList.push(ptf);
					
					pids.push(int(f.@id)) 

					//trace("finger",k, ptf.type, ptf.id, ptf.handID,ptf.position, ptf.direction, ptf.width, ptf.length);
				}
				
				// CREATE PALM MOTION POINT
					//var p:Object =  message.InputPoint.Values.Hand[j].Palm;
					var p:Object =  handList[j].Palm;
					
					var ptp:Object = new MotionPointObject();//new Object();
						ptp.type = "palm";
						ptp.handID = j;
						ptp.id = j//p.@Id;
						ptp.position = new Vector3D(p.Position.@x, p.Position.@y, p.Position.@z * -1);
						ptp.direction = new Vector3D(p.Direction.@x, p.Direction.@y, p.Direction.@z*-1);
						ptp.normal =  new Vector3D(p.Normal.@x, p.Normal.@y, p.Normal.@z*-1);
							
					pointList.push(ptp);
					//trace("palm", ptp.id, ptp.position, ptp.direction, ptp.normal)
					
					//PUSH IDS
					pids.push(int(p.@id)) 
					
				/*
				// CREATE TOOL MOTION POINT
					var o =  message.InputPoint.Values.Hand[j].Object;
				
					var opt:MotionPointObject = new MotionPointObject()
						opt.type = "tool";
						opt.handID = j;
						opt.id = o.@id;
						opt.position = new Vector3D(o.Position.@x, o.Position.@y, o.Position.@z * -1);
						opt.direction = new Vector3D(o.Direction.@x, o.Direction.@y, o.Direction.@z*-1);
						opt.normal = new Vector3D(o.Normal.@x, o.Normal.@y, o.Normal.@z);
					
					pointList.push(opt);
					
					pids.push(int(handList[i].Object[k].@id)) 
					//trace("tool", opt.id, opt.position, opt.direction, opt.normal);
					*/
				}
					
					GestureGlobals.motionFrameID += 1;
					// CALL LEAP PROCESSING
					//processMotion3DData(message);
					
					addRemoveUpdatePoints();
		}

		private static function getFramePoint(id:int):MotionPointObject
		{
			var obj:MotionPointObject;
			for (var i:uint = 0; i < pointList.length; i++)
			{
				if (id == pointList[i].id) obj = pointList[i];
			}
			return obj
		}

		private static function addRemoveUpdatePoints():void 
		{
			//trace("motion----------------------------------------------", activePoints.length, pointList.length);
			/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
			//POINT REMOVAL//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
			for each(var aid:int in activePoints) 
			{
				//trace("aid", aid, pids.length, pids.indexOf(aid), pids.indexOf(456))
				if (pids.indexOf(aid) == -1) 
				{
					// remove ref from activePoints list
					activePoints.splice(activePoints.indexOf(aid), 1);
					MotionManager.onMotionEndPoint(aid);
					if(debug)
						trace("REMOVED:", aid);
				}
			}
			///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
			//POINT ADDITION AND UPDATE////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
			for each(var pid:int in pids) //Number
			{
					var pt = getFramePoint(pid);
					//trace("getting pid", pid);
					
					if (pt) 
					{
					pt.motionPointID = pt.id;	
						
					//trace("PT",mp.type,mp.motionPointID,pid, mp.normal);
					if (activePoints.indexOf(pid) == -1) 
					{
						activePoints.push(pid);	
						MotionManager.onMotionBeginPoint(pt);
						if(debug)
							trace("ADDED:",pt.id, pt.motionPointID, pid);	
					}
					else {
						MotionManager.onMotionMovePoint(pt);
						if(debug)
							trace("UPDATE:",pt.id, pt.motionPointID, pid);
					}
				}
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
