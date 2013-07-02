package com.gestureworks.managers 
{
	import com.gestureworks.core.GestureWorks;
	import com.gestureworks.core.TouchSprite;
	import com.gestureworks.events.GWInteractionEvent;
	import com.gestureworks.objects.MotionPointObject;
	import flash.geom.Vector3D;
	
	import com.leapmotion.leap.events.LeapEvent;
	import com.leapmotion.leap.Pointable;
	import com.leapmotion.leap.Vector3;
	import com.leapmotion.leap.Hand;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.TouchEvent;
	import flash.geom.Point;
	//import flash.display.StageDisplayState;
	
	
	/**
	 * @author
	 */
	public class InteractionPointTracker
	{				
		private static var activePoints:Array;
		public static var framePoints:Array;
		//private var motionPointID:int = 0;
		private static var _ID:uint = 0;
		private static var i:uint = 0;
		private static var j:uint = 0;
		
		private static var d2:Number = 50;
		private static var d1:Number = 0.5;
		
		
		public static function initialize():void
		{
			activePoints = new Array();
			framePoints = new Array();
			//trace("i manager init");
		}
		
		
		public static function clearFrame():void 
		{
			framePoints = new Array();
			activePoints = new Array();
		}
		
		public static function getFramePoints():void 
		{
			//gms = GestureGlobals.gw_public::touchObjects[GestureGlobals.motionSpriteID];
			//framePoints = ;
		}
		
		
		/**
		 * Process points
		 * @param	event
		 */
		public static function getActivePoints():void 
		{
			
			return; // temp to avoid errors
			
			//copy active list
			var temp_activePoints:Array = activePoints;
			var temp_framePoints:Array = framePoints;
			
			// clear frame allows for immediate new entries
			clearFrame();
						
			
			//////////////////////////////////////////////////////////////////////////////////
			// loop active points 
			for (i = 0; i < temp_activePoints.length; i++)
					{
					var ap = temp_activePoints[i];	
					
					
					if (temp_framePoints.length != 0)
					{
						
					}
					else{
					
						for (j = 0; j < temp_framePoints.length; j++)
							{
							var fp = temp_framePoints[j];
				
							// calc dist
							var dist:Number = Vector3D.distance(ap.position, fp.position);
							//trace("dist",dist) ;
					
								if (dist > d2) // not there
								{
									//remove from active point list
									temp_activePoints.splice(temp_activePoints[i], 1);
									
									InteractionManager.onInteractionEnd(new GWInteractionEvent(GWInteractionEvent.INTERACTION_END,ap, true,false));//push end event
									//if(debug) 
									trace("REMOVED:",ap.id, ap.interactionPointID,ap.type);					
								}
							}
						}
					}
				
					
				////////////////////////////////////////////////////////////////////////////////
				// loop frame data 
				var f_num:int = temp_framePoints.length;
				var a_num:int = temp_activePoints.length
				
					for (j = 0; j < f_num; j++)
						{
						var fp = temp_framePoints[j];
			
						for (i = 0; i < a_num; i++)
							{
							var ap = temp_activePoints[i];	
						
							// calc dist
							var dist:Number = Vector3D.distance(ap.position, fp.position);
							//trace("2dist",dist) ;
							/////must exist already
							if (dist < d2)  ////update
							{
								// update position
								if (dist > d1)
								{
									activePoints[i] = framePoints[j];
									InteractionManager.onInteractionUpdate(new GWInteractionEvent(GWInteractionEvent.INTERACTION_UPDATE,ap, true, false)); //push update event
									//if(debug) 
									trace("UPDATE:",ap.id, ap.interactionPointID,ap.type);	
								}
								// update reasociate point id but not push move event
								else 
								{
									activePoints[i] = framePoints[j];
									//if ((framePoints[j])&&(activePoints[i])) framePoints[j].id = activePoints[i].id;
								}
							}	
							else ////// add point to A
								{
									//hit test
									//var obj:* = getTopDisplayObjectUnderPoint(fp);
									
									fp.id = _ID; // set new ID
									temp_activePoints.push(fp); //add to active point list
									
									//obj.onTouchDown(ev, obj);
									InteractionManager.onInteractionBegin(new GWInteractionEvent(GWInteractionEvent.INTERACTION_BEGIN, fp, true, false)); // push begin event
									//if (debug) 
									trace("ADDED:", fp.id, fp.interactionPointID,fp.type);
									
									//incremt ID
									_ID ++;
								}
							}
						}
						
						//trace("fnum",f_num,a_num);
						//PUSH ALL POINTS IN FRAME INTO ACTIVE LIST///////////////////////////////////////////
						if (a_num == 0) // if no points in active list
						{
							for (j = 0; j < f_num; j++)
							{
								var fp = temp_framePoints[j];
								
								fp.id = _ID;
								temp_activePoints.push(fp);
								InteractionManager.onInteractionBegin(new GWInteractionEvent(GWInteractionEvent.INTERACTION_BEGIN, fp, true, false)); // push begin event
								trace("ADDED:", fp.id, fp.interactionPointID, fp.type);
							}
						}
						
						
						// update active point list 
						activePoints = temp_activePoints;
						
		}

			
		/**
		 * Hit test
		 * @param	point
		 * @return
		*/ 
		private function getTopDisplayObjectUnderPoint(point:Point):DisplayObject {
			var targets:Array = new Array() //=  stage.getObjectsUnderPoint(point);
			var item:DisplayObject //= (targets.length > 0) ? targets[targets.length - 1] : stage;
			item = resolveTarget(item);
									
			return item;
		}	
		
		/**
		 * Determines the hit target based on mouseChildren settings of the ancestors
		 * @param	target
		 * @return
		 */
		private function resolveTarget(target:DisplayObject):DisplayObject {
			var ancestors:Array = targetAncestors(target, new Array(target));			
			var trueTarget:DisplayObject = target;
			
			for each(var t:DisplayObject in ancestors) {
				if (t is DisplayObjectContainer && !DisplayObjectContainer(t).mouseChildren)
				{
					trueTarget = t;
					break;
				}
			}
			
			return trueTarget;
		}
				
		/**
		 * Returns a list of the supplied target's ancestors sorted from highest to lowest
		 * @param	target
		 * @param	ancestors
		 * @return
		 */
		private function targetAncestors(target:DisplayObject, ancestors:Array = null):Array {
			
			if (!ancestors)
				ancestors = new Array();
				
			if (!target.parent || target.parent == target.root)
				return ancestors;
			else {
				ancestors.unshift(target.parent);
				ancestors = targetAncestors(target.parent, ancestors);
			}
			
			return ancestors;
		}
			
			
			
					
			
	}
}