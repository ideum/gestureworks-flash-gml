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
		private var kx:int;
		private var ky:int;
		private var k2x:Number;
		private var k2y:Number;
		private var k3:Number;
		private var pk:Number; // perspective scalar
		
		private var ka:Number = 192/80;
		private var kb:Number = 108/60;
		
		public function Motion3DSManager() 
		{
			//trace("leap 3d server manager constructor");
			
			sw = 1920//GestureWorks.application.stageWidth;
			sh = 1080//GestureWorks.application.stageHeight;
			sd = sw; //stage depth;
			
			
			kx = 1//200;//1000
			ky = 1//100;//300
			k2x = 1//1000;//1000
			k2y = 1//500;//1000
			
			k3 = 16 / 9;
			
			pk = 1;
			
			//debug = true;
		}

		public function processMotion3DSocketData(handList:XMLList,device:String):void 
		{
			//trace("prcess motion socket data", sw,sh)
				//message = frame.Messages.Message;
				//trace(message)
				
				handCount = int(handList.length());//int(message.InputPoint.Values.Hand.length()); //FIX ME
				//handOrientation = message.InputPoint.Values.Hand.@orientation; //up/down
				//handType = message.InputPoint.Values.Hand.@type; //left/right
				//handSplay
				
				//trace("hand count",handCount);

				// CREATE POINT LIST
				pointList = new Vector.<MotionPointObject>//Array();
				pids = new Vector.<int>;
				
				for (var j:uint = 0; j < handCount; j++ )
				{
				fingerCount = int(handList[j].@FingerCount);// int(message.InputPoint.Values.Hand[j].@FingerCount);  //FIX ME
				objectCount = int(handList[j].@ObjectCount);//int(message.InputPoint.Values.Hand[j].@ObjectCount)  //FIX ME
				//trace("3ds manager",handCount, fingerCount, objectCount);
				
				
				/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
				// CREATE PALM MOTION POINT//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
				/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
					//var p:Object =  message.InputPoint.Values.Hand[j].Palm;
					var p:Object =  handList[j].Palm;
					
					
					
					var ptp:MotionPointObject = new MotionPointObject();//new Object();
						ptp.type = "palm";
						ptp.handID = j;
						ptp.id = 100 + j//5000+j//p.@id;
						ptp.deviceType = device;
						
						ptp.radius = p.@length
						ptp.handside = handList[j].@handSide;//p.@handSide;
						ptp.orientation = p.@palmOrientation;
						ptp.radius = 80;
						
						// perspective scalar
						pk = .01 * p.Position.@z;
						//pk = 5* handList[j].@z;
						
						//trace("-------------------------------------------------------------------------stable???",p.Position.@z );
						//trace("pk-----------------------------------------",pk,p.position);
						//trace("pk-----------------------------------------", pk, handList[j].@handSide);
						//trace("parsing device:",device);
					
						
						ptp.position = new Vector3D(p.Position.@x*kx, p.Position.@y*ky, p.Position.@z * -1*kx);
						ptp.direction = new Vector3D(p.Direction.@x, p.Direction.@y, p.Direction.@z * -1);
						ptp.normal =  new Vector3D(p.Normal.@x, p.Normal.@y, p.Normal.@z * -1); //universal
						
					//	ptp.normal =  new Vector3D(p.Normal.@x*-1, p.Normal.@y*-1, p.Normal.@z * 1); //universal
						
						//NEED FAV POINT 
						//ptp.fingerAvergePosiiton = new Vector3D(p.favPosition.@x,p.favPosition.@y,p.favPosition.@z);
						
						//ptp.screen_position = new Vector3D(p.Position.@x * k2x + sw * 0.5, p.Position.@y * -k2y + 0.5 * sh, p.Position.@z * k2x + sd);
						
						
						if (device == "RealSense")
						{
							ptp.screen_position = new Vector3D(p.Position.@x * k2x * pk + sw * 0.5, p.Position.@y * -k2y * pk + 0.5 * sh, p.Position.@z * k2x + sd);
							//ptp.screen_position = new Vector3D(p.Position.@image_x * -ka * pk + sw * 1, p.Position.@image_y * kb * pk, p.Position.@image_z * sd);
							
							//ptp.screen_position = new Vector3D(handList[j].@image_x * -ka * pk + sw * 1, handList[j].@image_y * kb * pk, handList[j].@image_z * sd);
							
							ptp.screen_direction = new Vector3D(p.Direction.@x, p.Direction.@y*-1, p.Direction.@z*-1);
							ptp.screen_normal =  new Vector3D(p.Normal.@x, p.Normal.@y * -1, p.Normal.@z * -1);
							//trace("palm",ptp.position,ptp.direction,ptp.normal);
						}
						else if (device == "LeapMotion")
						{
							ptp.screen_position = new Vector3D(p.Position.@x*-k2x + sw*0.5, p.Position.@y*k2y + 0.5*sh, p.Position.@z*k2x+sd);
							ptp.screen_direction = new Vector3D(p.Direction.@x, p.Direction.@y*-1, p.Direction.@z*-1);
							ptp.screen_normal =  new Vector3D(p.Normal.@x, p.Normal.@y*-1, p.Normal.@z*-1);
						}
						
						
					pointList.push(ptp);
					//trace("palm", ptp.id, ptp.position, ptp.direction, ptp.normal)
					
					//trace("data palm position:",j,ptp.position,p.@id)
					//PUSH IDS
					pids.push(int(100 +j)) //////int(5000+j)//+p.@id
					
					
					
					
				///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
				// CREATE FINGER TIP MOTION POINTS/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
				///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
			
					for (var k:uint = 0; k < fingerCount; k++ )
					{
						//var f:Object =  message.InputPoint.Values.Hand[j].Finger[k];
						var f:Object =  handList[j].Finger[k];
					//	var joint_length:int = handList[j].Finger[k].joint.length();
						
						//trace("motion3dmanager:joint length",joint_length);
						
						var ptf:MotionPointObject = new MotionPointObject();// new Object();
							ptf.type = "finger";
							ptf.handID = j;
							ptf.id = f.@id;
							ptf.width = 10//f.@Width;
							ptf.length = 30//f.@Length;
							ptf.fingertype = f.@fingerType;
							
						
							//ptf.position = new Vector3D(f.Position.@x * kx * pk, f.Position.@y * ky * pk, f.Position.@z * -50 * kx);
							ptf.position = new Vector3D(f.Position.@x*kx, f.Position.@y*ky, f.Position.@z * -1*kx);
							//ptf.direction = new Vector3D(f.Direction.@x, f.Direction.@y, f.Direction.@z * -1);
							
							//ptf.extension = f.@extension; //	NEED FINGER EXTENSION FOR HAND FLATNESS AND POINTING CHECK FOR SPLAY AND TRIGGER
							
							
							if (device == "RealSense")
							{
								ptf.screen_position = new Vector3D(f.Position.@x * k2x*pk + (sw * 0.5), f.Position.@y *pk* -k2y + 0.5 * sh, f.Position.@z * k2x + sd);
								//ptf.screen_position = new Vector3D(f.Position.@image_x*-ka*pk+ (sw *1), f.Position.@image_y*kb*pk, f.Position.@image_z*sd);
								ptf.screen_direction = new Vector3D(f.Direction.@x, f.Direction.@y*-1, f.Direction.@z*-1);
								ptf.screen_normal =  new Vector3D(f.Normal.@x, f.Normal.@y, f.Normal.@z*-1);;
							}
							else if (device == "LeapMotion")
							{
								
								
								//ptf.screen_position = new Vector3D(f.Position.@x * k2x + (sw * 0.5), f.Position.@y * -k2y + 0.5 * sh, f.Position.@z * k2x + sd);
								ptf.screen_position = new Vector3D(f.Position.@x*-k2x+(sw*0.5), f.Position.@y*k2y + 0.5*sh, f.Position.@z*k2x + sd);
								ptf.screen_direction = new Vector3D(f.Direction.@x,f.Direction.@y*-1, f.Direction.@z*-1);
								ptf.screen_normal =  new Vector3D(f.Normal.@x, f.Normal.@y, f.Normal.@z*-1);;
							}
							
						pointList.push(ptf);
						pids.push(int(f.@id)) 

						//trace("finger",k, ptf.type, ptf.id, ptf.handID,ptf.position, ptf.direction, ptf.width, ptf.length);
						
						//if (k==0) trace("pos",f.Position.@x,f.Position.@y);
					}
				
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
