package com.gestureworks.server 
{
	import com.gestureworks.core.GestureWorks;
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
		private static var full_skeleton = true;
		
		private static var pids:Vector.<int> = new Vector.<int>();
		private static var pointList:Vector.<MotionPointObject> = new Vector.<MotionPointObject>();
		private static var activePoints:Vector.<int> = new Vector.<int>();
		
		private var sw:int
		private var sh:int
		private var sd:int
		
		public function Motion3DSManager() 
		{
			trace("leap 3d server manager constructor");
			
			sw = 100//GestureWorks.application.stageWidth
			sh = 100//GestureWorks.application.stageHeight;
			sd = sw; //stage depth
			
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
					var joint_length:int = handList[j].Finger[k].joint.length();
					
					//trace("motion3dmanager:joint length",joint_length);
					
					var ptf:MotionPointObject = new MotionPointObject();// new Object();
						ptf.type = "finger";
						ptf.handID = j;
						ptf.id = f.@id;
						ptf.width = 10//f.@Width;
						ptf.length = 30//f.@Length;
						
						ptf.position = new Vector3D(f.Position.@x*sw, f.Position.@y*sh, f.Position.@z * -1*sd);
						ptf.direction = new Vector3D(f.Direction.@x, f.Direction.@y, f.Direction.@z * -1);
						ptf.fingertype = f.@fingerType;
						
					pointList.push(ptf);
					pids.push(int(f.@id)) 

					//trace("finger",k, ptf.type, ptf.id, ptf.handID,ptf.position, ptf.direction, ptf.width, ptf.length);
				}
				
				// CREATE PALM MOTION POINT
					//var p:Object =  message.InputPoint.Values.Hand[j].Palm;
					var p:Object =  handList[j].Palm;
					
					var ptp:MotionPointObject = new MotionPointObject();//new Object();
						ptp.type = "palm";
						ptp.handID = j;
						ptp.id = 5000+j//p.@id;
						ptp.position = new Vector3D(p.Position.@x*sw, p.Position.@y*sh, p.Position.@z * -1*sd);
						ptp.direction = new Vector3D(p.Direction.@x, p.Direction.@y, p.Direction.@z*-1);
						ptp.normal =  new Vector3D(p.Normal.@x, p.Normal.@y, p.Normal.@z * -1);
						ptp.sphereRadius = p.@length
						ptp.handside = p.@handSide;
						ptp.orientation = p.@palmOrientation;
						
					pointList.push(ptp);
					//trace("palm", ptp.id, ptp.position, ptp.direction, ptp.normal)
					
					//PUSH IDS
					pids.push(int(5000+j)) ////p.@id
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
					//if(debug)
						//trace("REMOVED:", aid);
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
						//if(debug)
							//trace("ADDED:",pt.id, pt.motionPointID, pid);	
					}
					else {
						MotionManager.onMotionMovePoint(pt);
						//if(debug)
							//trace("UPDATE:",pt.id, pt.motionPointID, pid);
					}
				}
			}	
		}
		
	}
}
