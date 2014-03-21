package com.gestureworks.server 
{
	import com.gestureworks.objects.TouchPointObject;
	import com.gestureworks.managers.TouchManager;
	/**
	 * The Leap3DSManager handles the parsing of leap type socket frame data from the device server.
	 *
	 * @author Ideum
	 *
	 */
	public class Touch2DSManager
	{
		private static var frame:XML
		private static var message:Object
		private static var inputType:String
		private static var frameId:int 
		private static var timestamp:int 
		private static var count:int
		//private static var objectCount:int
		private static var debug:Boolean = false;
		
		private static var pids:Vector.<int> = new Vector.<int>();
		private static var pointList:Vector.<TouchPointObject> = new Vector.<TouchPointObject>();
		private static var activePoints:Vector.<int> = new Vector.<int>();
		
		private static var _minX:Number;
		private static var _maxX:Number;
		private static var _minY:Number;
		private static var _maxY:Number;
		
		public function Touch2DSManager(minX:Number=0, maxX:Number=0, minY:Number=0, maxY:Number=0) 
		{
			trace("touch 2d server manager constructor");
			activePoints = new Vector.<int>()
			
			//if (minX) this.minX = minX;
		//	if (maxX) this.maxX = maxX;
			//if (minY) this.minY = minY;
			//if (maxY) this.maxY = maxY;
			
			//stage = GestureWorks.application.stage;
		}
	/*
		public function processTouch2DSocketData(message:XML):void 
		{
			//trace(message)
			
				// CREATE POINT LIST
				pointList = new Vector.<TouchPointObject>();
				//fingerCount = int(message.InputPoint.Values.Surface.Point.length());
				count = int(message.InputPoint.Values.Finger.length());
				//penCount = int(message.InputPoint.Values.Surface.Pen.length());
				
				//trace(fingerCount)
				
				// CREATE Touch POINTS
				for (var k:int = 0; k < count; k++ )
				{
					//var f =  message.InputPoint.Values.Surface.Point[k];
					var f =  message.InputPoint.Values.Finger[k];
					var ptf:TouchPointObject = new TouchPointObject();
						ptf.id = f.@id; //TODO: change to id
						ptf.position.x = f.@x; 
						ptf.position.y = f.@y;
						ptf.pressure = f.@pressure;
						ptf.size.x = f.@width;
						ptf.size.y = f.@height;
					pointList.push(ptf);
				}
				// CALL LEAP PROCESSING
				processTouch2DData(message);
		}
		*/
		
		
		public function processTouch2DSocketData(xmlList:XMLList):void 
		{
			//trace(message)
				// CREATE POINT LIST
				pointList = new Vector.<TouchPointObject>();
				count = int(xmlList.length());//int(message.InputPoint.Values.Eye.length());
				pids = new Vector.<int>();
				
				// CREATE Touch POINTS
				for (var k:int = 0; k < count; k++)
				{
					//var f =  message.InputPoint.Values.Surface.Point[k];
					var f =  xmlList[k];//message.InputPoint.Values.Eye[k];
					var ptf:TouchPointObject = new TouchPointObject();
						ptf.id = f.@id; 
						ptf.position.x = f.@x; 
						ptf.position.y = f.@y;
						ptf.pressure = f.@pressure;
						ptf.size.x = f.@width;
						ptf.size.y = f.@height;
					pointList.push(ptf);
					
					//PUSH IDS
					pids.push(int(f.@id));
				}

				addRemoveUpdatePoints();
		}
		
		
		
		
		/**
		 * Process points
		 * @param	event
		 */
		/*
		private static function processTouch2DData(message:XML):void 
		{
			pushids(message);
			addRemoveUpdatePoints();
		}
		
		private static function pushids(message:XML):void 
		{
			//store frame's point ids
			pids = new Vector.<int>();
			
			//var pn:int = int(message.InputPoint.Values.Surface.Point.length());
			var fn:int = int(message.InputPoint.Values.Finger.length());
			
				//push touch point ids
				for (var j:int = 0; j < fn; j++)
				{
					//pids.push(int(message.InputPoint.Values.Surface.Point[j].@id));
					pids.push(int(message.InputPoint.Values.Finger[j].@id));
				}
				
			//trace("pid array length",pids.length);
		}
		*/
		private static function getFramePoint(id:int):TouchPointObject//Object 
		{
			var obj:TouchPointObject//Object;
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
					
					//TouchManager.onTouchUp(new GWTouchEvent(null, GWTouchEvent.TOUCH_END, true, false, aid, false));
					TouchManager.onTouchUpPoint(aid);
					//trace("TOUCH POINT REMOVED:",aid);
				}
				
				//trace("active point aid",aid)
			}

			///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
			//POINT ADDITION AND UPDATE////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
			for each(var pid:int in pids) //number
			{
				var pt:TouchPointObject = getFramePoint(pid);
				
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
						te.touchPointID = pt.id;
						//te.type = "touchBegin";
						te.stageX = pt.position.x,
						te.stageY = pt.position.y;
						te.stageZ = pt.position.z;
						te.sizeX = pt.size.x;
						te.sizeY = pt.size.y;
						te.pressure = pt.pressure;
						*/
						
						pt.touchPointID = pt.id;
						
						
					if (activePoints.indexOf(pid) == -1) 
					{
						activePoints.push(pid);	
						//TouchManager.onTouchDown(te);
						TouchManager.onTouchDownPoint(pt);
						//trace("TOUCH POINT ADDED:", pid);		
					}
					else {
						//TouchManager.onTouchMove(te)
						TouchManager.onTouchMovePoint(pt)		
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