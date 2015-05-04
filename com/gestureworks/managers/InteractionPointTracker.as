package com.gestureworks.managers 
{
	import com.gestureworks.core.GestureWorks;
	import com.gestureworks.core.TouchSprite;
	import com.gestureworks.events.GWInteractionEvent;
	import com.gestureworks.objects.GesturePointObject;
	import com.gestureworks.objects.MotionPointObject;
	import com.gestureworks.objects.InteractionPointObject;
	
	import com.gestureworks.core.GestureWorksCore;
	import com.gestureworks.core.GestureGlobals;
	import com.gestureworks.core.gw_public;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.TouchEvent;
	import flash.geom.Point;
	import flash.geom.Vector3D;
	
	
	/**
	 * @author
	 */
	public class InteractionPointTracker
	{				
		public static var activePoints:Vector.<InteractionPointObject>;
		public static var framePoints:Vector.<InteractionPointObject>;
		private static var temp_framePoints:Vector.<InteractionPointObject>;
		
		private static var ap:InteractionPointObject;
		private static var fp:InteractionPointObject;
		private static var _ID:uint = 0;
		
		private static var d2:Number = 100//40//200//40//200//200;//40 //DEFINES TOLERENCE TRACK POINT
		private static var d1:Number = 0;
		private static var debug:Boolean = false;
		private static var tiO;
		private static var tapID = 0;
		
		public static function initialize():void
		{
			activePoints = new Vector.<InteractionPointObject>;
			framePoints = new Vector.<InteractionPointObject>;
			temp_framePoints = new Vector.<InteractionPointObject>;
			
			tiO = GestureGlobals.gw_public::timeline
			//trace("interaction point tracker init");
		}
		
		
		public static function clearFrame():void 
		{
			framePoints = new Vector.<InteractionPointObject>();
		}
		
		public static function getFramePoints():void 
		{
			temp_framePoints = framePoints;
		}
		
		
		/**
		 * Process points
		 * @param event
		 */
		public static function getActivePoints():void 
		{
			//trace("get active ip points",activePoints.length,framePoints.length,temp_framePoints.length);
			// copy active list
			getFramePoints();
			
			//refresh frame ready to fill
			clearFrame();

			
				//trace("interaction active points",activePoints.length,temp_framePoints.length, framePoints.length, activePoints.length);

				//////////////////////////////////////////////////////////////////////
				// REMOVE from ap if not in fp
				// WILL REMOVE ALL IF NO POINTS IN FRAME
				for each(ap in activePoints) 
				{
					var found:Boolean = false;
					
						for each(fp in temp_framePoints)
						{
							if (fp.source == "native" ) //||fp.source == "server" 
							{
							//trace(ap.type)
							
							var dist:Number = Math.abs(Vector3D.distance(ap.position, fp.position));
							if (ap.type == fp.type && ap.rootPointID == fp.rootPointID) found = true;
							
							
							else if (ap.type == fp.type) 
							{
								if (ap.type == "finger" )//||ap.type == "finger"
								{
									if (dist < 10) found = true; //FINGER SEP
								}
								else if (dist < d2) found = true;
							}
							
							//trace(ap.id, fp.id, ap.interactionPointID, fp.interactionPointID,ap.type,fp.type,dist);
							//trace("roooooot",ap.rootPointID, fp.rootPointID);
							}
						}
						
						
						//trace("-------------------------------------------",found,activePoints.length,temp_framePoints.length)
						
						if (!found) 
						{
							activePoints.splice(activePoints.indexOf(ap), 1);
							ap.phase = "end";
							
							//trace(ap.position, ap.init_position)
							var dr:Vector3D = ap.position.subtract(ap.init_position);
							var dist:Number = dr.length;
							
							
							
							
							//InteractionManager.onInteractionEnd(new GWInteractionEvent(GWInteractionEvent.INTERACTION_END, ap, true, false)); //push update event
							//InteractionManager.onInteractionEndPoint(ap.interactionPointID); 
							
							InteractionManager.onInteractionEndPoint(ap); 
							
							//trace("ended with this:",dist)
							//if (debug) 
							//trace("an!=0 REMOVED:-------------------------------------------", ap.id, ap.interactionPointID, ap.type, ap.position);
							
							if (ap.age < 30 && dist < 10) 
							{
								//trace("@ ip tracker TAP begin + end pair", ap.age, dist, tiO.frame.gesturePointArray.length);
							
								// create tap gesture point and place in global timeline frame
								var gpt:GesturePointObject = new GesturePointObject();
									gpt.gesturePointID = tapID;
									gpt.position = ap.position;
									//gpt.type = "tap";
									gpt.type = "touch_finger_tap";
									gpt.mode = "touch"
									gpt.n = 1;
									tapID += 1;
									
								tiO.frame.gesturePointArray.push(gpt);

							}
						}
				}
					//////////////////////////////////////////////////////////////////
					// UPDATE ap if in fp
					for each(ap in activePoints)
						{
						for each(fp in temp_framePoints)
							{
							if (fp.source == "native") 
							{
								if (ap.type == fp.type)
								{
									
								//var dist0:Number = Math.abs(Vector3D.distance(ap.position, fp.position));
								
								//trace(ap.position.z,fp.position.z)
								//trace("dist",dist,dist0,ap.type,fp.type, ap.interactionPointID, fp.interactionPointID,_ID, ap.rootPointID, fp.rootPointID)

									if(ap.rootPointID == fp.rootPointID) 
									{
										//ap.rootPointID = fp.rootPointID;
										ap.age += 1;
										ap.phase = "update";
											
											//ap.init_position = fp.init_position;
											ap.position = fp.position;
											ap.direction = fp.direction;
											ap.normal = fp.normal;
											
											ap.screen_position = fp.screen_position;
											ap.screen_direction = fp.screen_direction;
											ap.screen_normal = fp.screen_normal;
											
											// advanced ip features
											ap.fist = fp.fist;
											ap.splay = fp.splay;
											ap.orientation = fp.orientation;
											ap.radius = fp.radius;
											ap.flatness = fp.flatness;
											ap.fn = fp.fn;
											
											//sensors
											ap.acceleration = fp.acceleration;
											ap.buttons = fp.buttons;
											
											ap.handID = fp.handID;
											ap.type = fp.type;
											ap.mode = fp.mode;
											
											
											temp_framePoints.splice(temp_framePoints.indexOf(fp), 1);
												
											//InteractionManager.onInteractionUpdate(new GWInteractionEvent(GWInteractionEvent.INTERACTION_UPDATE, ap, true, false)); //push update event
											InteractionManager.onInteractionUpdatePoint(ap);
											//if (debug)
											//trace("UPDATE:",ap.id, ap.interactionPointID,ap.type, ap.position, ap.acceleration, ap.position);	
										}
								
									}
							}
						}	
					}
					
					///////////////////////////////////////////////////////////////////
					// ADD NEW POINTS TO ACTIVE will add (WHEN an!=0)
					for each(fp in temp_framePoints)
					{
						if (fp.source == "native") 
						{
						_ID++;
						fp.interactionPointID = _ID;
						fp.age = 0;
						fp.phase = "begin";
						fp.init_position = new Vector3D(fp.position.x, fp.position.y, 0);
						//trace(fp.position)
						
						//fp.rootPointID = fp.rootPointID;
						//trace(fp)
						//trace(activePoints);
						activePoints.push(fp);
						//InteractionManager.onInteractionBegin(new GWInteractionEvent(GWInteractionEvent.INTERACTION_BEGIN, fp, true, false)); // push begin event
						InteractionManager.onInteractionBeginPoint(fp);
						//if (debug) trace("an!=0 ADDED:", fp.id, fp.interactionPointID, fp.type, fp.position);
						//trace("ip begin",fp.interactionPointID,temp_framePoints.length)
						}
					}
					
					/*
					// check for duplicates (paulis exclusion principle)
					for (var i:int = 0; i < activePoints.length; i++)
					{
						for (var j:int = 0; j < activePoints.length; j++)
						{
							if ((i != j) && (activePoints[i].position == activePoints[j].position) && (activePoints[i].type == activePoints[j].type)) 
							{
								trace("duplicate");
							}
						}
					}
					*/
		}
		
			
	}
}