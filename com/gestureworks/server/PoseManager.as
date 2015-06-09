package com.gestureworks.server 
{
	import com.gestureworks.core.GestureWorks;
	import com.gestureworks.core.GestureGlobals;
	import com.gestureworks.core.gw_public;
	
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
		private static var activePoints:Vector.<int> = new Vector.<int>();
		private static var framepointList:Vector.<InteractionPointObject> = new Vector.<InteractionPointObject>();
		private static var activepointList:Vector.<InteractionPointObject> = new Vector.<InteractionPointObject>();
		
		private static var iPointArray:Vector.<InteractionPointObject>
		
		
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
			
			iPointArray = GestureGlobals.gw_public::iPointArray;
		}

		public function processPoseData(poseList:XMLList,ipID:int):void // 
		{
			
			
			
				//trace("hand count",handCount);
				ipCount = poseList.length();// int(message.InputPoint.Values.Hand[j].@FingerCount);  //FIX ME
				
				// CREATE POINT LIST FOR POINTS IN MESSAGE FRAME
				framepointList = new Vector.<InteractionPointObject>
				
				// CREATE ACTIVE POINT LIST// FOR POINTS THAT SHOULD EXIST
				activepointList = new Vector.<InteractionPointObject>
				pids = new Vector.<int>;
				
				
				//trace("get pose", ipCount);
				//iPointArray = new Vector.<InteractionPointObject>;
				
				
				for (var j:uint = 0; j < ipCount; j++ )
				{
					
				var p:Object =  poseList[j];//poseList[j].Pose;
				/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
				// CREATE PALM MOTION POINT//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
				/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

				var pk = 1//.01 * p.@position_z;
				
					var ptp:InteractionPointObject = new InteractionPointObject();
						ptp.name =  p.@name;
						ptp.type =  p.@type;//p.@name;
						ptp.type_attribute = p.@type_attribute;
						ptp.deviceType = p.@device;
						ptp.id = ipID///100 + j//5000+j//p.@id;
						ptp.handside = p.@handSide;
						//ptp.age = 0;
						//ptp.status = p.@status;
						//ptp.special = p.@special;
						//ptp.color = p.@color;
						
						////////////////////////////////////////////////////////////////////
						// 3D position and orientation data
						ptp.position = new Vector3D(p.@x * kx, p.@y * ky, p.@z * -1 * kx);
						ptp.direction = new Vector3D(p.@direction_x, p.@direction_y, p.@direction_z * -1);
						ptp.normal =  new Vector3D(p.@normal_x, p.@normal_y * -1, p.@normal_z * -1);
						
						////////////////////////////////////////////////////////////////////
						// screen 2D position and orientation data
						//ptp.screen_position = new Vector3D(p.@image_x, p.@image_y, p.@image_z);
						//ptp.screen_position = new Vector3D(p.@image_x * -ka * pk + sw * 1, p.@image_y * kb * pk, p.@image_z * sd);
						//ptp.screen_position = new Vector3D(p.@image_x * -ka + sw * 1, p.@image_y * kb, p.@image_z * sd);
						//ptp.screen_position = new Vector3D(p.@x*-1*5 + (sw*0.5) , p.@y*-1*5/k3 + (sh*0.5) , p.@z);
						//ptp.screen_position = new Vector3D(p.@position_x * k2x * pk + sw * 0.5, p.@position_y * -k2y * pk + 0.5 * sh, p.@position_z * k2x + sd);
						
						
						//LEAP PERFECT// RS IS OFF
						ptp.screen_position = new Vector3D( -1 * p.@screen_x * pk + (0.5 * sw), p.@screen_y * pk + (0.5 * sh), p.@screen_z); 
						
						//ptp.screen_position = new Vector3D(p.@x *pk + (sw * 0.5), p.@y *pk + 0.5 * sh, p.@z + sd);
						
						ptp.screen_direction = new Vector3D(p.@direction_x, p.@direction_y*-1, p.@direction_z*-1);
						ptp.screen_normal =  new Vector3D(p.@normal_x, p.@normal_y * -1, p.@normal_z * -1);
						
						
					//trace("pose type:",p.@name,p.@type,p.@deviceType);
						
						
					//iPointArray.push(ptp);
					framepointList.push(ptp);
					//trace("pose", "type:",ptp.type, "ID:",ptp.id,"pos:", ptp.position, "screen pos:", ptp.screen_position, ptp.direction, ptp.normal)
					
					//trace("data palm position:",j,ptp.position,p.@id)
					//PUSH IDS
					pids.push(ipID) ///(100 + j)///int(5000+j)//+p.@id
					
					//trace("push frame point", ipID);
					
					//trace("raw screen pos:",p.@image_x, p.@image_y,p.@image_z)
					
					//trace("pose manager screen pos:",ptp.screen_position)
				}
					
				//GestureGlobals.motionFrameID += 1;
				addRemoveUpdatePoints();
				
				//getActivePointList();
				
				//trace("ip length:", iPointArray.length);
				
				//if (iPointArray.length == 1) trace(iPointArray[0].position);
			
		}
		
		
		
		
		

		private static function getFramePoint(id:int):InteractionPointObject
		{
			var obj:InteractionPointObject;
			for (var i:uint = 0; i < framepointList.length; i++)
			{
				if (id == framepointList[i].id) obj = framepointList[i];
			}
			return obj
		}
		
		/*
		private static function getActivePoint(id:int):InteractionPointObject
		{
			var obj:InteractionPointObject;
			for (var i:uint = 0; i < activepoints.length; i++)
			{
				if (id == activepointList[i].id) obj = activepoints[i];
			}
			return obj
		}
		
		private static function getActivePointList():Vector.<InteractionPointObject>
		{
			for each(var aid:int in activePoints) 
			{
				
			ativePointList.push(getActivePoint(aid));
			
			}
			
			trace("aplist length:",activePointList.length)
		}*/
		

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
					//if (pt) {
					InteractionManager.onInteractionEndPoint(aid);//aid
					//if(debug)
						trace("REMOVED:", aid);
					//}
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
								trace("UPDATE:",pt.type, pt.age,pt.id, pt.interactionPointID, pid, pt.position,pt.phase);
						}
					}
			}	
		}
		
	}
}
