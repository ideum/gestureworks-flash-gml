package com.gestureworks.server 
{
	import com.gestureworks.core.GestureWorks;
	import com.gestureworks.core.GestureGlobals;
	import com.gestureworks.events.GWMotionEvent;
	import com.gestureworks.objects.InteractionPointObject;
	import com.gestureworks.managers.MotionManager;
	import com.gestureworks.managers.InteractionManager;
	
	import flash.geom.Vector3D;

	/**
	 * The Leap3DSManager handles the parsing of leap type socket frame data from the device server.
	 *
	 * @author Ideum
	 *
	 */
	public class PoseManager
	{
		//private static var frame:XML
		//private static var message:Object
		private static var inputType:String
		private static var frameId:int 
		private static var timestamp:int 
		private static var ipCount:int

		private static var debug:Boolean = false;
		
		private static var pids:Vector.<int> = new Vector.<int>();
		private static var pointList:Vector.<InteractionPointObject> = new Vector.<InteractionPointObject>();
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
		
		public function PoseManager() 
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

		public function processPoseData(poseList:XMLList,ipID:int):void // 
		{
			
			
			
				//trace("hand count",handCount);
				ipCount = poseList.length();// int(message.InputPoint.Values.Hand[j].@FingerCount);  //FIX ME
				
				// CREATE POINT LIST
				pointList = new Vector.<InteractionPointObject>
				pids = new Vector.<int>;
				
				
				//trace("get pose", ipCount);
				
				
				
				for (var j:uint = 0; j < ipCount; j++ )
				{
					
				var p:Object =  poseList//poseList[j].Pose;
				/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
				// CREATE PALM MOTION POINT//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
				/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

					var ptp:InteractionPointObject = new InteractionPointObject();
						ptp.type = p.name;
						ptp.id = ipID///100 + j//5000+j//p.@id;
						
						//ptp.deviceType = device;
						//ptp.handside = p.@handSide;
						//ptp.color = p.@color;
						//ptp.orientation_x = p.@orientation_x;
						//ptp.orientation_y = p.@orientation_y;
						//ptp.orientation_z = p.@orientation_z;
						//ptp.special = p.@special;
						//ptp.status = p.@status;
						ptp.type = p.@type;
						//ptp.type_attribute = p.@type_attribute;
						ptp.position = new Vector3D(p.@x * kx, p.@y * ky, p.@z * -1 * kx);
						ptp.direction = new Vector3D(p.Direction.@x, p.Direction.@y, p.Direction.@z * -1);
						ptp.normal =  new Vector3D(p.Normal.@x, p.Normal.@y, p.Normal.@z * -1); //universal
						
						ptp.screen_position = new Vector3D(p.@image_x * -ka * pk + sw * 1, p.@image_y * kb * pk, p.@image_z * sd);
						ptp.screen_direction = new Vector3D(p.Direction.@x, p.Direction.@y*-1, p.Direction.@z*-1);
						ptp.screen_normal =  new Vector3D(p.Normal.@x, p.Normal.@y * -1, p.Normal.@z * -1);

					pointList.push(ptp);
					//trace("palm", ptp.id, ptp.position, ptp.direction, ptp.normal)
					
					//trace("data palm position:",j,ptp.position,p.@id)
					//PUSH IDS
					pids.push(ipID) ///(100 + j)///int(5000+j)//+p.@id
					
					//trace("push frame point", ipID);
				}
					
				GestureGlobals.motionFrameID += 1;
				addRemoveUpdatePoints();
				
		}
		
		
		
		
		

		private static function getFramePoint(id:int):InteractionPointObject
		{
			var obj:InteractionPointObject;
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
					
					var pt:InteractionPointObject = getFramePoint(aid);
					// remove ref from activePoints list
					activePoints.splice(activePoints.indexOf(aid), 1);
					if (pt)InteractionManager.onInteractionEndPoint(pt);//aid
					//if(debug)
						trace("REMOVED:", aid);
				}
			}
			///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
			//POINT ADDITION AND UPDATE////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
			for each(var pid:int in pids) //Number
			{
					var pt:InteractionPointObject = getFramePoint(pid);
					//trace("getting pid", pid);
					
					if (pt) 
					{
					pt.interactionPointID = pt.id;	
						
					//trace("PT",mp.type,mp.motionPointID,pid, mp.normal);
					if (activePoints.indexOf(pid) == -1) 
					{
						activePoints.push(pid);	
						InteractionManager.onInteractionBeginPoint(pt);
						//if(debug)
							trace("ADDED:",pt.id, pt.interactionPointID, pid);	
					}
					else {
						InteractionManager.onInteractionUpdatePoint(pt);
						//if(debug)
							//trace("UPDATE:",pt.id, pt.interactionPointID, pid);
					}
				}
			}	
		}
		
	}
}
