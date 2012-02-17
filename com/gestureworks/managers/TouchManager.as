////////////////////////////////////////////////////////////////////////////////
//
//  IDEUM
//  Copyright 2011-2012 Ideum
//  All Rights Reserved.
//
//  GestureWorks
//
//  File:    TouchManager.as
//  Authors:  Ideum
//             
//  NOTICE: Ideum permits you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////
package com.gestureworks.managers
{
	import flash.utils.Dictionary;
	import flash.events.TouchEvent;
	import flash.events.Event;
	import com.gestureworks.core.GestureWorks;
	import com.gestureworks.core.GestureGlobals;
	import com.gestureworks.core.gw_public;
	import com.gestureworks.utils.ArrangePoints;
	import com.gestureworks.managers.TouchUpdateManager;
	import com.gestureworks.managers.PointHistories;
	import com.gestureworks.events.GWEvent;
	
	public class TouchManager
	{
		public static var points:Dictionary = new Dictionary();
		public static var count:int;
		public static var isTouching:Boolean;
		public static var frameNum:int = 0;
		
		// initializes touchManager...
		gw_public static function initialize():void
		{
			points = GestureGlobals.gw_public::points;
			
			if (GestureWorks.supportsTouch) GestureWorks.application.addEventListener(TouchEvent.TOUCH_END, onTouchUp);
			if (GestureWorks.supportsTouch) GestureWorks.application.addEventListener(TouchEvent.TOUCH_MOVE, onTouchMove);
			//if (GestureWorks.supportsTouch) GestureWorks.application.addEventListener(TouchEvent.TOUCH_MOVE, onTouchMove, false, 1, true);
		}
		
		gw_public static function deInitialize():void
		{
			GestureWorks.application.removeEventListener(TouchEvent.TOUCH_END, onTouchUp);
			GestureWorks.application.removeEventListener(TouchEvent.TOUCH_MOVE, onTouchMove);
		}
		
		// registers touch point via touchSprite
		gw_public static function registerTouchPoint(event:TouchEvent):void
		{
			if (!GestureWorks.activeTUIO) points[event.touchPointID].history.unshift(PointHistories.historyObject(event.stageX, event.stageY, event))
			else points[event.touchPointID].history.unshift(PointHistories.historyObject(event.localX, event.localY, event));
			
			count++;
			isTouching = true;
			//////////////////////////////////
			event.stopImmediatePropagation();
			//////////////////////////////////
		}
		
		// stage on TOUCH_UP.
		public static function onTouchUp(event:TouchEvent):void
		{
			if (points[event.touchPointID])
			{
				var tO:Object = GestureGlobals.gw_public::touchObjects[points[event.touchPointID].object.clusterID];
				if((tO.tiO.timelineOn)&&(tO.tiO.pointEvents)) tO.tiO.frame.pointEventArray.push(event);// pushed touch up events into the timeline object
				if ((tO.debug_display) && (tO.cO)) tO.clearDebugDisplay(); // clear display
				
				//trace("Touch up",tO.name, event.target, event.target.name, event.touchPointID);

				removeTouchPoint(event);
			}
			if (count == 0) isTouching = false;
			
			//////////////////////////////////
			event.stopImmediatePropagation();
			//////////////////////////////////
		}
		
		// removes all touch events.
		private static function removeTouchPoint(event:TouchEvent):void
		{
			//var cO:Object = GestureGlobals.gw_public::clusters[points[event.touchPointID].object.clusterID];
			count--;
			
			ArrangePoints.arrangePointArray(event);
			delete TouchUpdateManager.pointMoveQueue[event.touchPointID]; // delete point from move queue
			delete points[event.touchPointID]; // delete from global points list
			if (count == 0) isTouching = false;
			
			//////////////////////////////////
			event.stopImmediatePropagation();
			/////////////////////////////////
		}
		
		// the Stage TOUCH_MOVE event.		
		public static function onTouchMove(event:TouchEvent):void
		{			
			//if (GestureWorks.supportsTouch)	if (event.target.toString() == "[object Stage]") return;
			
			//if (TouchUpdateManager.pointMoveQueue[event.touchPointID]) return;
			
			//trace("reciving touch points on move");
			
			TouchUpdateManager.pointMoveQueue[event.touchPointID] = event;
			
			if (isTouching) 
			{
				//trace("it is going right here");
				
				TouchUpdateManager.touchFrameHandler();
				
				TouchUpdateManager.updateTouchObject(event);
			}
			
			///////////////////////////////////
			// added to test
			///////////////////////////////////
			
			//event.stopPropagation();
			event.stopImmediatePropagation();
			//Event.preventDefault();
			
			//GestureWorks.application.dispatchEvent(new GWEvent(GWEvent.ENTER_FRAME));
		}

	}
}