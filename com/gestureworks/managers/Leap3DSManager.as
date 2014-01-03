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


	/**
	 * The Leap3DSManager handles the parsing of leap type socket frame data from the device server.
	 *
	 * @author Ideum
	 *
	 */
	public class Leap3DSManager extends Sprite
	{
		private static var frame:XML
		private static var message:Object
		private static var inputType:String
		private static var frameId:int 
		private static var timestamp:int 
		private static var handCount:int
		private static var fingerCount:int
		private static var objectCount:int
		
		
		private static var pids:Array= new Array()//Vector.<int> = new Vector.<int>();
		private static var pointList:Array = new Array()//Vector.<MotionPointObject> = new Vector.<MotionPointObject>();
		//private static var pointListOld:Array= new Array()//Vector.<MotionPointObject> = new Vector.<MotionPointObject>();
		private static var activePoints:Array= new Array()//Vector.<int> = new Vector.<int>();
	
		
		public function Leap3DSManager()
		{
			trace("leap 3d server manager constructor");
		}

		
		public function processLeap3DSocketData(frame:XML):void 
		{
				message = frame.Messages.Message;
			//	trace(message)
				
				handCount = int(message.InputPoint.Values.Hand.length());
				//handOrientation = message.InputPoint.Values.Hand.@orientation; //up/down
				//handType = message.InputPoint.Values.Hand.@type; //left/right
				//handSplay

				// CREATE POINT LIST
				pointList = new Array();
				
				for (var j:int = 0; j < handCount; j++ )
				{
				fingerCount = int(message.InputPoint.Values.Hand[j].@FingerCount);
				objectCount = int(message.InputPoint.Values.Hand[j].@ObjectCount);
				//trace(handCount, fingerCount, objectCount);
				
				// CREATE FINGER TIP MOTION POINTS
				for (var k:int = 0; k < fingerCount; k++ )
				{
					var f =  message.InputPoint.Values.Hand[j].Finger[k];
					
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

					//trace("finger",k, ptf.type, ptf.id, ptf.handID,ptf.position, ptf.direction, ptf.width, ptf.length);
				}
				
				// CREATE PALM MOTION POINT
					var p =  message.InputPoint.Values.Hand[j].Palm;
					
					var ptp:MotionPointObject = new MotionPointObject()//new Object();
						ptp.type = "palm";
						ptp.handID = j;
						ptp.id = p.@id;
						ptp.position = new Vector3D(p.Position.@x, p.Position.@y, p.Position.@z * -1);
						ptp.direction = new Vector3D(p.Direction.@x, p.Direction.@y, p.Direction.@z*-1);
						ptp.normal =  new Vector3D(p.Normal.@x, p.Normal.@y, p.Normal.@z*-1);
							
					pointList.push(ptp);
					//trace("palm", ptp.id, ptp.position, ptp.direction, ptp.normal)
				
					
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
					//trace("tool", opt.id, opt.position, opt.direction, opt.normal);
					*/
				}
					
					GestureGlobals.motionFrameID += 1;
					// CALL LEAP PROCESSING
					processLeap3DData(frame);
		}
		
		
		/**
		 * Process points
		 * @param	event
		 */
		private static function processLeap3DData(frame:XML):void 
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
			var on:int;
			
			//trace("pushing pids",hn,fn,on);
			
			//CREATE HANDS THEN... FINGERS AND TOOLS
			for (var i:int = 0; i < hn; i++)
			{
				fn = int(f.Messages.Message.InputPoint.Values.Hand[i].@FingerCount);
				on = 0//int(f.Messages.Message.InputPoint.Values.Hand[0].@ObjectCount)
			
				// palm point
				pids.push(int(f.Messages.Message.InputPoint.Values.Hand[i].Palm.@id)) 
				//trace("PALMID",f.Messages.Message.InputPoint.Values.Hand[i].Palm.@id);
				 
				//finger points
				for (var j:int = 0; j < int(f.Messages.Message.InputPoint.Values.Hand[i].@FingerCount); j++)
				{
					pids.push(int(f.Messages.Message.InputPoint.Values.Hand[i].Finger[j].@id)) 
					//trace("FINGERID",f.Messages.Message.InputPoint.Values.Hand[i].Finger[j].@id);
				}
					
				//object points //tools
				for (var k:int = 0; k < on; k++)
				{
					pids.push(int(f.Messages.Message.InputPoint.Values.Hand[i].Object[k].@id)) 
				}
			}
			
			//trace("pid array length",pids.length);
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
		
		/*
		private static function getLastFramePoint(id:int):Object 
		{
			var obj:Object;

			for (var i:int = 0; i < pointListOld.length; i++)
			{
				trace(id,pointListOld[i].id)
				if (id == pointListOld[i].id) obj = pointListOld[i];
			}
			return obj
		}*/
		
		
		private static function addRemoveUpdatePoints():void 
		{
			//trace("----------------------------------------------");
			//trace("pids",pids.length,"active points", activePoints.length)

			/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
			//POINT REMOVAL//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
			//var temp:Array = activePoints;  //prevent concurrent mods
			
			for each(var aid:int in activePoints) 
			{
				
				//trace("aid", aid, pids.length, pids.indexOf(aid), pids.indexOf(456))
				
				if (pids.indexOf(aid) == -1) {
					
					// remove ref from activePoints list
					activePoints.splice(activePoints.indexOf(aid), 1);
					
					// SHOULD JUST REMOVE POINT FROM REFERENCE 
					// NOT TRY TO FIND AND PUSH PROPERTIES AS MAY HAVE HAPPENED UP TO 10 FRAMES AGO
					
					//var pt = getLastFramePoint(aid);
					//var pt = getFramePoint(aid);
					
					//trace(pt, "remove candidate")
					
					//if (pt) 
					//{
						//SPLCE FROM ACTIVE POINT LIST
						
						//trace("pt",pt.type)
						var mp = new MotionPointObject();
							mp.motionPointID = aid;
							
							//mp.handID = pt.handID;
							//mp.type = pt.type;
							//mp.position = new Vector3D( pt.position.x, pt.position.y, pt.position.z);
							//mp.direction = new Vector3D(pt.direction.x, pt.direction.y, pt.direction.z);
							//mp.normal = new Vector3D(pt.normal.x,pt.normal.y, pt.normal.z);	
						//	mp.width = pt.width;
							//mp.length = pt.length;
					
					//trace("PT remove",mp.type,mp.motionPointID,aid);
					
						
					MotionManager.onMotionEnd(new GWMotionEvent(GWMotionEvent.MOTION_END,mp, true,false));
					//if(debug)
						//trace("REMOVED:",mp.id, mp.motionPointID, aid, event.frame.pointable(aid));
					//trace("REMOVED");
					//}
				}
			}
			//activePoints = temp;
			
			
			///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
			//POINT ADDITION AND UPDATE////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
			for each(var pid:Number in pids) 
			{
					var pt = getFramePoint(pid);
					
					//trace("getting pid", pid);
					
					if (pt) 
					{
						//trace("pt", pt.type);
					
					var mp = new MotionPointObject();
						mp.motionPointID = pt.id;
						mp.handID = pt.handID;
						mp.type = pt.type;
						mp.position = new Vector3D( pt.position.x, pt.position.y, pt.position.z);
						mp.direction = new Vector3D(pt.direction.x, pt.direction.y, pt.direction.z);
						mp.normal = new Vector3D(pt.normal.x,pt.normal.y, pt.normal.z);	
						mp.width = pt.width;
						mp.length = pt.length;
						
					//trace("PT",mp.type,mp.motionPointID,pid, mp.normal);

					if (activePoints.indexOf(pid) == -1) 
					{
						activePoints.push(pid);	
						MotionManager.onMotionBegin(new GWMotionEvent(GWMotionEvent.MOTION_BEGIN, mp, true, false));
							
						//if(debug)
							//trace("ADDED:",mp.id, mp.motionPointID, pid, event.frame.pointable(pid));	
							
						//trace("ADDED");
					}
					else {
						MotionManager.onMotionMove(new GWMotionEvent(GWMotionEvent.MOTION_MOVE,mp, true, false));
						//if(debug)
							//trace("UPDATE:",mp.id, mp.motionPointID, pid);
						//trace("UPDATE");
					}
				}
			}	
			
			//trace("active array", activePoints.length );
			//pointListOld = pointList;
		}
		


	}
}
