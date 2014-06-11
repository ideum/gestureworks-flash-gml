package com.gestureworks.server 
{
	import com.gestureworks.objects.TouchPointObject;
	import com.gestureworks.managers.TouchManager;
	import com.gestureworks.events.GWTouchEvent;
	import com.gestureworks.managers.InteractionPointTracker;
	import com.gestureworks.objects.InteractionPointObject;
	
	import flash.geom.Vector3D;
	/**
	 * The Touch2DSManager handles the parsing of touch type points socket frame data from the device server.
	 * Generic touch points a split by type into finger, stylus, fiducial and shape.
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
		private static var fingercount:int
		private static var styluscount:int
		private static var fiducialcount:int
		private static var shapecount:int
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
		
		
		public function processTouch2DSocketData(xmlList:XMLList):void //:XML//message:XML
		{
			//trace("inside");
			//trace(message)
				// CREATE POINT LIST
				pointList = new Vector.<TouchPointObject>();
				pids = new Vector.<int>();
				
				fingercount = int(xmlList.Finger.length());
				styluscount = int(xmlList.Stylus.length());
				fiducialcount = int(xmlList.Fiducial.length());
				shapecount = int(xmlList.Shape.length());
				
				
				//FINGER
				if (xmlList.Finger) 
				{
					// CREATE finger Touch POINTS
					for (var k:int = 0; k < fingercount; k++)
					{
						//trace(xmlList.Finger,xmlList.Finger[k], fingercount,xmlList.Finger[k].@id,xmlList.Finger[k].@x)
						//var f =  message.InputPoint.Values.Surface.Point[k];
						var f:Object =  xmlList.Finger[k];//message.InputPoint.Values.Eye[k];
						//var ptf:TouchPointObject = new TouchPointObject();
						var ptf:InteractionPointObject = new InteractionPointObject();
						
							ptf.id = f.@id; 
							if (!ptf.position) ptf.position = new Vector3D(f.@x,f.@y,0);
								//ptf.position.x = f.@x; 
								//ptf.position.y = f.@y;
							//ptf.pressure = f.@pressure;
							//if (!ptf.size) ptf.size= new Vector3D(f.@width,f.@height,0);
								//ptf.size.x = f.@width;
								//ptf.size.y = f.@height;
							//ptf.type = "finger"
							//ptf.theta = f.@theta;
						
						//--pointList.push(ptf);
						
						//trace(f.@id)
						
						//PUSH IDS
						//--pids.push(int(f.@id));
						
						//
						InteractionPointTracker.framePoints.push(ptf)
					}
				}
				/*
				//STYLUS/PEN/BRUSH (position, radius,width,height, name, theta)
				if (xmlList.Stylus) 
				{
					// CREATE finger Touch POINTS
					for (var ks:int = 0; ks < styluscount; ks++)
					{
						//var f =  message.InputPoint.Values.Surface.Point[k];
						var s =  xmlList.Stylus[ks];//message.InputPoint.Values.Eye[k];
						var pts:TouchPointObject = new TouchPointObject();
							pts.id = s.@id; 
							pts.position.x = s.@x; 
							pts.position.y = s.@y;
							pts.pressure = s.@pressure;
							pts.size.x = s.@width;
							pts.size.y = s.@height;
							//ptf.type = "stylus";
							//ptf.theta = f.@theta;
						pointList.push(pts);
						
						//PUSH IDS
						pids.push(int(s.@id));
					}
				}
				
				//OBJECT/FIDUCIAL/TAG (position, point number,width,height,name, theta)
				if (xmlList.Fiducial) 
				{
					// CREATE finger Touch POINTS
					for (var ko:int = 0; ko < fiducialcount; ko++)
					{
						//var f =  message.InputPoint.Values.Surface.Point[k];
						var o =  xmlList.Fiducial[ko];//message.InputPoint.Values.Eye[k];
						var pto:TouchPointObject = new TouchPointObject();
							pto.id = o.@id; 
							pto.position.x = o.@x; 
							pto.position.y = o.@y;
							pto.pressure = o.@pressure;
							pto.size.x = o.@width;
							pto.size.y = o.@height;
							//ptf.type = "fiducial";
							//ptf.name = o.name;// or ref
							//ptf.n = o.n; // point number
							//ptf.theta = f.@theta;
						pointList.push(pto);
						
						//PUSH IDS
						pids.push(int(o.@id));
					}
				}
				
				//SHAPE (position, radius,width,height,name, theta)
				if (xmlList.Shape) 
				{
					// CREATE finger Touch POINTS
					for (var ksh:int = 0; ksh < shapecount; ksh++)
					{
						//var f =  message.InputPoint.Values.Surface.Point[k];
						var shape =  xmlList.Shape[ksh];//message.InputPoint.Values.Eye[k];
						var ptsh:TouchPointObject = new TouchPointObject();
							ptsh.id = shape.@id; 
							ptsh.position.x = shape.@x; 
							ptsh.position.y = shape.@y;
							ptsh.pressure = shape.@pressure;
							ptsh.size.x = shape.@width;
							ptsh.size.y = shape.@height;
							//ptf.type = "shape"
							//ptf.name = o.name;// or ref
							//ptf.theta = f.@theta;
						pointList.push(ptsh);
						
						//PUSH IDS
						pids.push(int(shape.@id));
					}
				}*/
	
				// UPDATE
				addRemoveUpdatePoints();
				
				//trace("active point number",activePoints.length )
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
		

		public function addRemoveUpdatePoints():void 
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
					//--TouchManager.onTouchUpPoint(aid);
					//trace("TOUCH POINT REMOVED:",aid);
				}
				
				//trace("active point aid",aid)
			}
			
			//activePoints.length = 0;

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
						//--TouchManager.onTouchDownPoint(pt);
						//trace("TOUCH POINT ADDED:", pid);		
					}
					else {
						//TouchManager.onTouchMove(te)
						//--TouchManager.onTouchMovePoint(pt)		
						//trace("TOUCH POINT UPDATE:", pid);
					}
					//trace(pt.size.x,pt.size.y, pt.pressure)
				}
				//trace("pids pid",pid)
			}
			
			
			
			trace("active point number",activePoints.length )
			
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
