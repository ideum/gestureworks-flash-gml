package com.gestureworks.managers 
{
	import com.gestureworks.core.GestureWorks;
	import com.gestureworks.core.TouchSprite;
	import com.gestureworks.events.GWMotionEvent;
	import com.gestureworks.objects.MotionPointObject;
	import flash.geom.Vector3D;
	
	import com.leapmotion.leap.events.LeapEvent;
	import com.leapmotion.leap.Pointable;
	import com.leapmotion.leap.Vector3;
	import com.leapmotion.leap.Hand;
	
	import flash.display.DisplayObject;
	import flash.events.TouchEvent;
	import flash.geom.Point;
	/**
	 * @author
	 */
	public class Leap3DManager extends LeapManager
	{				
		private var activePoints:Array;
		
		//private var motionPointID:int = 0;
		
		public function Leap3DManager() 
		{
			super();
			activePoints = new Array();
			
			if(debug)
				trace("leap 3d manager init");
		}
		
		/**
		 * Process points
		 * @param	event
		 */
		override protected function onFrame(event:LeapEvent):void 
		{
			super.onFrame(event);
			
			//store frame's point ids
			var pids:Array = new Array();
			
			//CREATE HANDS THEN... FINGERS AND TOOLS
			
			//store hand ids
			for each(var hand:Hand in event.frame.hands){
				if(hand) pids.push(hand.id);//if(hand.isValid)
				//trace("handid", hand.id);
			}
			// store poitnables ids
			// is valid does not seem to be effective here
			for each(var pointable:Pointable in event.frame.pointables){
				if (pointable){
					if (pointable.hand) pids.push(pointable.id);
					//trace("pointid", pointable.id);
				}
			}
			
			
			
			//trace("pids",pids.length,"active points", activePoints.length)
			
			//point removal
			var temp:Array = activePoints;  //prevent concurrent mods
			for each(var aid:Number in activePoints) {
				
				if (pids.indexOf(aid) == -1) {
					
					temp.splice(temp.indexOf(aid), 1);
					
					var mp:MotionPointObject = new MotionPointObject();
						//mp.type = "motion";
						mp.motionPointID = aid;
						
						//determin type
						if (event.frame.pointable(aid).isTool) mp.type = "tool";
						if (event.frame.pointable(aid).isFinger) mp.type = "finger";
						else mp.type = "palm";
						//else (mp.type = "unknown")
						
						/////////////////////////////////////////
						//create palm point
						if (mp.type == "palm") 
						{
							for (var i:int = 0; i < event.frame.hands.length; i++) 
							{
								if (aid == event.frame.hands[i].id) 
								{
									//mp.handID = event.frame.hand[i].id;
									
									mp.position.x = map(event.frame.hands[i].palmPosition.x, -180, 180, 0, stage.stageWidth);
									mp.position.y = map(event.frame.hands[i].palmPosition.y, 75, 270, stage.stageHeight, 0);
									mp.position.z = event.frame.hands[i].palmPosition.z;
									
									//mp.direction = new Vector3D(event.frame.hands[i].direction.x, event.frame.hands[i].direction.y, event.frame.hands[i].direction.z);
									mp.direction.x = map(event.frame.hands[i].direction.x, -180, 180, 0, stage.stageWidth)
									mp.direction.y = map(event.frame.hands[i].direction.y,75, 270, stage.stageHeight, 0);
									mp.direction.z = event.frame.hands[i].direction.z;
								
									
									
									
									mp.normal = new Vector3D(event.frame.hands[i].palmNormal.x,event.frame.hands[i].palmNormal.y,event.frame.hands[i].palmNormal.z);
									mp.velocity = new Vector3D(event.frame.hands[i].palmVelocity.x,event.frame.hands[i].palmVelocity.y,event.frame.hands[i].palmVelocity.z);
									
									//mp.sphereCenter = new Vector3D(event.frame.hands[i].sphereCenter.x,event.frame.hands[i].sphereCenter.y,event.frame.hands[i].sphereCenter.z);
									mp.sphereCenter.x = map(event.frame.hands[i].sphereCenter.x, -180, 180, 0, stage.stageWidth);
									mp.sphereCenter.y = map(event.frame.hands[i].sphereCenter.y, 75, 270, stage.stageHeight, 0);
									mp.sphereCenter.z = event.frame.hands[i].sphereCenter.z//map(event.frame.hands[i].sphereCenter.z, 75, 270, stage.stageHeight, 0);
									mp.sphereRadius = event.frame.hands[i].sphereRadius
								}
							}
						}
						//////////////////////////////////////////
						//create finger or tool type
						if ((mp.type == "finger") || (mp.type == "tool"))
						{
							if (event.frame.pointable(aid).hand) {
								mp.handID = event.frame.pointable(aid).hand.id
								//trace("point hand id",mp.handID);
							}
							
							// position
							mp.position.x = map(event.frame.pointable(aid).tipPosition.x, -180, 180, 0, stage.stageWidth);
							mp.position.y = map(event.frame.pointable(aid).tipPosition.y, 75, 270, stage.stageHeight, 0);
							mp.position.z = event.frame.pointable(aid).tipPosition.z;
							
							mp.direction = new Vector3D(event.frame.pointable(aid).direction.x, event.frame.pointable(aid).direction.y, event.frame.pointable(aid).direction.z);
							mp.velocity = new Vector3D(event.frame.pointable(aid).tipVelocity.x,event.frame.pointable(aid).tipVelocity.y,event.frame.pointable(aid).tipVelocity.z);
							
							//size
							mp.width = event.frame.pointable(aid).width;
							mp.length = event.frame.pointable(aid).length;
						}
						
						
						
						
					MotionManager.onMotionEnd(new GWMotionEvent(GWMotionEvent.MOTION_END,mp, true,false));
					if(debug)
						trace("REMOVED:",mp.id, mp.motionPointID, aid, event.frame.pointable(aid));					
				}
			}
			activePoints = temp;

			//point addition and update
			for each(var pid:Number in pids) {
				
				var tip:Vector3 = event.frame.pointable(pid).tipPosition;
				
				var mp:MotionPointObject = new MotionPointObject();
					mp.motionPointID = pid;
					
					if (event.frame.pointable(pid).isTool) mp.type = "tool";
					if (event.frame.pointable(pid).isFinger) mp.type = "finger";
					else mp.type = "palm";
					
					// create palm point
					if (mp.type == "palm") 
					{
							for (var k:int = 0; k < event.frame.hands.length; k++) 
							{
								if (pid == event.frame.hands[k].id) 
								{
								//mp.handID = event.frame.hands[k].id;
								mp.position.x = map(event.frame.hands[k].palmPosition.x, -180, 180, 0, stage.stageWidth)
								mp.position.y = map(event.frame.hands[k].palmPosition.y, 75, 270, stage.stageHeight, 0);
								mp.position.z = event.frame.hands[k].palmPosition.z
								
								//mp.direction = new Vector3D(event.frame.hands[k].direction.x, event.frame.hands[k].direction.y, event.frame.hands[k].direction.z);
								
								mp.direction.x = map(event.frame.hands[k].direction.x, -180, 180, 0, stage.stageWidth)
								mp.direction.y = map(event.frame.hands[k].direction.y,75, 270, stage.stageHeight, 0);
								mp.direction.z = event.frame.hands[k].direction.z;
								
								
								mp.normal = new Vector3D(event.frame.hands[k].palmNormal.x,event.frame.hands[k].palmNormal.y,event.frame.hands[k].palmNormal.z);
								mp.velocity = new Vector3D(event.frame.hands[k].palmVelocity.x,event.frame.hands[k].palmVelocity.y,event.frame.hands[k].palmVelocity.z);
								
								mp.sphereCenter.x = map(event.frame.hands[k].sphereCenter.x, -180, 180, 0, stage.stageWidth);
								mp.sphereCenter.y = map(event.frame.hands[k].sphereCenter.y, 75, 270, stage.stageHeight, 0);
								mp.sphereCenter.z = event.frame.hands[k].sphereCenter.z//map(event.frame.hands[k].sphereCenter.z, 75, 270, stage.stageHeight, 0);
								mp.sphereRadius = event.frame.hands[k].sphereRadius;
								}
							}
					}
					
					
					// create finger or tool point
					if ((mp.type == "finger") || (mp.type == "tool"))
					{
						if (event.frame.pointable(pid).hand) {
							mp.handID = event.frame.pointable(pid).hand.id
							//trace("point hand id",mp.handID);
						}
						
						//mp.handID = event.frame.pointable(pid).hand.id;
						mp.position.x = map(event.frame.pointable(pid).tipPosition.x, -180, 180, 0, stage.stageWidth);
						mp.position.y = map(event.frame.pointable(pid).tipPosition.y, 75, 270, stage.stageHeight, 0);
						mp.position.z = event.frame.pointable(pid).tipPosition.z//map(tip.z, 75, 270, stage.stageHeight, 0);
						
						mp.direction = new Vector3D(event.frame.pointable(pid).direction.x, event.frame.pointable(pid).direction.y, event.frame.pointable(pid).direction.z);
						mp.velocity = new Vector3D(event.frame.pointable(pid).tipVelocity.x,event.frame.pointable(pid).tipVelocity.y,event.frame.pointable(pid).tipVelocity.z);
						
						mp.width = event.frame.pointable(pid).width;
						mp.length = event.frame.pointable(pid).length;
						
						//trace(mp.width,mp.length);
					}
					

					//trace("type manager", mp.type);
					

				if (activePoints.indexOf(pid) == -1) 
				{
					activePoints.push(pid);	
					MotionManager.onMotionBegin(new GWMotionEvent(GWMotionEvent.MOTION_BEGIN, mp, true, false));
						
					if(debug)
						trace("ADDED:",mp.id, mp.motionPointID, pid, event.frame.pointable(pid));	
				}
				else {
					MotionManager.onMotionMove(new GWMotionEvent(GWMotionEvent.MOTION_MOVE,mp, true, false));
					if(debug)
						trace("UPDATE:",mp.id, mp.motionPointID, pid);	
				}
			}	
			
			//trace("leap 3d motion frame processing");
		}

		
		
		
		
	}

}