package com.gestureworks.managers 
{
	import com.gestureworks.cml.utils.NumberUtils;
	import com.gestureworks.core.TouchSprite;
	import com.leapmotion.leap.events.LeapEvent;
	import com.leapmotion.leap.Pointable;
	import com.leapmotion.leap.Vector3;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.TouchEvent;
	import flash.geom.Point;
	/**
	 * @author
	 */
	public class Leap2DManager extends LeapManager
	{				
		private var activePoints:Array;
		
		public function Leap2DManager() 
		{
			super();
			activePoints = new Array();
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
			for each(var pointable:Pointable in event.frame.pointables){
				pids.push(pointable.id);
			}
				
			//point removal
			var temp:Array = activePoints;  //prevent concurrent mods
			for each(var aid:Number in activePoints) {
				if (pids.indexOf(aid) == -1) {
					temp.splice(temp.indexOf(aid), 1);
					TouchManager.onTouchUp(new TouchEvent(TouchEvent.TOUCH_END, true, false, aid, false, event.frame.pointable(aid).tipPosition.x, event.frame.pointable(aid).tipPosition.y));
					if(debug)
						trace("REMOVED:", aid, event.frame.pointable(aid));					
				}
			}
			activePoints = temp;

			//point addition and update
			for each(var pid:Number in pids) {
				var tip:Vector3 = event.frame.pointable(pid).tipPosition;
				var point:Point = new Point();
				point.x = NumberUtils.map(tip.x, -180, 180, 0, stage.stageWidth);
				point.y = NumberUtils.map(tip.y, 75, 270, stage.stageHeight, 0);

				if (activePoints.indexOf(pid) == -1) {
					activePoints.push(pid);					
					var obj:* = getTopDisplayObjectUnderPoint(point);
					if (obj is TouchSprite)
						obj.onTouchDown( new TouchEvent(TouchEvent.TOUCH_BEGIN, true, false, pid, false, point.x, point.y), obj);
					
					if(debug)
						trace("ADDED:", pid, event.frame.pointable(pid));	
				}
				else {
					TouchManager.onTouchMove(new TouchEvent(TouchEvent.TOUCH_MOVE, true, false, pid, false, point.x, point.y));											
					if(debug)
						trace("UPDATE:", pid, event.frame.pointable(pid));	
				}
			}			
		}

		/**
		 * Hit test
		 * @param	point
		 * @return
		*/ 
		private function getTopDisplayObjectUnderPoint(point:Point):DisplayObject {
			var targets:Array =  stage.getObjectsUnderPoint(point);
			var item:DisplayObject = (targets.length > 0) ? targets[targets.length - 1] : stage;
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