package com.gestureworks.managers 
{
	import com.gestureworks.core.GestureWorks;
	import com.gestureworks.core.TouchSprite;
	import com.gestureworks.events.GWMotionEvent;
	import com.gestureworks.objects.MotionPointObject;
	import flash.geom.Vector3D;
	import flash.geom.Matrix;
	
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
						
						//trace("mp type",mp.type);
						
						/////////////////////////////////////////
						//create palm point
						if (mp.type == "palm") 
						{
							for (var i:int = 0; i < event.frame.hands.length; i++) 
							{
								if (aid == event.frame.hands[i].id) 
								{
									mp.handID = event.frame.hand[i].id;
									mp.position = new Vector3D( event.frame.hands[i].palmPosition.x, event.frame.hands[i].palmPosition.y, event.frame.hands[i].palmPosition.z*-1);
									mp.direction = new Vector3D(event.frame.hands[i].direction.x, event.frame.hands[i].direction.y, event.frame.hands[i].direction.z*-1);
									mp.normal = new Vector3D(event.frame.hands[i].palmNormal.x, event.frame.hands[i].palmNormal.y, event.frame.hands[i].palmNormal.z*-1);
									mp.velocity = new Vector3D(event.frame.hands[i].palmVelocity.x, event.frame.hands[i].palmVelocity.y, event.frame.hands[i].palmVelocity.z*-1);
									
									mp.sphereCenter = new Vector3D(event.frame.hands[i].sphereCenter.x, event.frame.hands[i].sphereCenter.y, event.frame.hands[i].sphereCenter.z*-1);
									mp.sphereRadius = event.frame.hands[i].sphereRadius
									
									// cutom leap matrix
									//mp.rotation = event.frame.hands[i].rotation;
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
							mp.position = new Vector3D(event.frame.pointable(aid).tipPosition.x, mp.position.y = event.frame.pointable(aid).tipPosition.y, mp.position.z = event.frame.pointable(aid).tipPosition.z*-1);
							mp.direction = new Vector3D(event.frame.pointable(aid).direction.x, event.frame.pointable(aid).direction.y, event.frame.pointable(aid).direction.z*-1);
							mp.velocity = new Vector3D(event.frame.pointable(aid).tipVelocity.x, event.frame.pointable(aid).tipVelocity.y, event.frame.pointable(aid).tipVelocity.z*-1);
							
							//size
							//mp.width = event.frame.pointable(aid).width;
							//mp.length = event.frame.pointable(aid).length;
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
				
				mp = new MotionPointObject();
					mp.motionPointID = pid;
					
					if (event.frame.pointable(pid).isTool) {
						mp.type = "tool";
						trace("mp type",mp.type);
					}
					if (event.frame.pointable(pid).isFinger) mp.type = "finger";
					else mp.type = "palm";
					
					
					// create palm point
					if (mp.type == "palm") 
					{
							for (var k:int = 0; k < event.frame.hands.length; k++) 
							{
								if (pid == event.frame.hands[k].id) 
								{
								mp.handID = event.frame.hands[k].id;
								mp.position = new Vector3D( event.frame.hands[k].palmPosition.x, event.frame.hands[k].palmPosition.y, event.frame.hands[k].palmPosition.z*-1);
								mp.direction = new Vector3D(event.frame.hands[k].direction.x, event.frame.hands[k].direction.y, event.frame.hands[k].direction.z*-1);
								mp.normal = new Vector3D(event.frame.hands[k].palmNormal.x, event.frame.hands[k].palmNormal.y, event.frame.hands[k].palmNormal.z*-1);
								mp.velocity = new Vector3D(event.frame.hands[k].palmVelocity.x, event.frame.hands[k].palmVelocity.y, event.frame.hands[k].palmVelocity.z*-1);
			
								mp.sphereCenter = new Vector3D(event.frame.hands[k].sphereCenter.x, event.frame.hands[k].sphereCenter.y, event.frame.hands[k].sphereCenter.z*-1);
								mp.sphereRadius = event.frame.hands[k].sphereRadius;
								
								// custom leap matrix
								//mp.rotation = event.frame.hands[k].rotation;
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
						mp.position = new Vector3D( event.frame.pointable(pid).tipPosition.x, event.frame.pointable(pid).tipPosition.y, event.frame.pointable(pid).tipPosition.z*-1);
						mp.direction = new Vector3D(event.frame.pointable(pid).direction.x, event.frame.pointable(pid).direction.y, event.frame.pointable(pid).direction.z*-1);
						mp.velocity = new Vector3D(event.frame.pointable(pid).tipVelocity.x, event.frame.pointable(pid).tipVelocity.y, event.frame.pointable(pid).tipVelocity.z*-1);

						//mp.width = event.frame.pointable(pid).width;
						//mp.length = event.frame.pointable(pid).length;
						
						//trace("width",mp.width,mp.length);
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