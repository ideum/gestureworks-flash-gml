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
	
	import com.gestureworks.managers.PointHistories;
	
	/* 
		
		IMPORTANT NOTE TO DEVELOPER **********************************************
		 
		PlEASE DO NOT ERASE OR DEVALUE ANYTHING WHITHIN THIS CLASS IF YOU DO NOT UNDERSTAND IT'S CURRENT VALUE OR PLACE.
		IF YOU HAVE ANY QUESTIONS, ANY AT ALL. PLEASE ASK PAUL LACEY (paul@ideum.com) ABOUT IT'S IMPORTANCE.
		IF PAUL IS UNABLE TO HELP YOU UNDERSTAND, THEN PLEASE LOOK AND READ THE ACTUAL CODE FOR IT'S PATH.
		SOMETHINGS AT FIRST MAY NOT BE CLEAR AS TO WHAT THE ACTUAL PURPOSE IS, BUT IT IS VALUABLE AND IS USED IF IT IS CURRENTLY WRITTTEN HERE.
		DO NOT TAKE CODE OUT UNLESS YOUR CHANGES ARE VERIEFIED, TESTED AND CONTINUE TO WORK WITH LEGACY BUILDS !
		
		*/
	
	public class TouchManager
	{
		public static var points:Dictionary = new Dictionary();
		//public static var count:int;
		//public static var isTouching:Boolean;
		//public static var frameNum:int = 0;
		
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
			
			//count++;
			//isTouching = true;
			
			//////////////////////////////////
			//3.1//event.stopImmediatePropagation(); //previous default
			//////////////////////////////////
		}
		
		// stage on TOUCH_UP.
		public static function onTouchUp(event:TouchEvent):void
		{
			if (points[event.touchPointID])
			{
				// define local touch object
				var tO:Object = GestureGlobals.gw_public::touchObjects[points[event.touchPointID].object.clusterID];
					// push touch up event to touch object timeline
					if((tO.tiO.timelineOn)&&(tO.tiO.pointEvents)) tO.tiO.frame.pointEventArray.push(event);// pushed touch up events into the timeline object
					// clear local debug display
					if ((tO.debug_display) && (tO.cO)) tO.clearDebugDisplay(); // clear display
					
					
					// remove touch point from global list
					removeTouchPoint(event);
			}
			
			//3.1//if (count == 0) isTouching = false;
			//////////////////////////////////
			//3.1//event.stopImmediatePropagation(); previous defualt
			//////////////////////////////////
		}
		
		// removes all touch events.
		private static function removeTouchPoint(event:TouchEvent):void
		{
			//3.1//count--;
			
			ArrangePoints.arrangePointArray(event);
			//3.1//	delete TouchUpdateManager.pointMoveQueue[event.touchPointID]; // delete point from move queue
			delete points[event.touchPointID]; // delete from global points list
			
			//3.1//if (count == 0) isTouching = false;
			
			
			//////////////////////////////////
			//3.1//event.stopImmediatePropagation(); // previous default
			/////////////////////////////////
		}
		
		// the Stage TOUCH_MOVE event.		
		public static function onTouchMove(event:TouchEvent):void
		{			
			//trace("reciving touch points on move");
			//3.1//TouchUpdateManager.pointMoveQueue[event.touchPointID] = event;
			//3.1//TouchUpdateManager.touchFrameHandler();
			
			// update point history
			PointHistories.historyQueue(event);
			// update point position
			updatePointObject(event);
			// update cluster and gesture analysis
			updateTouchObject(event);
		}
		
		
		
		
		public static function updatePointObject(event:TouchEvent):void
		{
			//trace("updating point data in moving", event.touchPointID, event.stageX, event.stageY);
			
			/////////////////////////////////////////////////////////////////////////////////////////////
			// update point object positions
			/////////////////////////////////////////////////////////////////////////////////////////////
			var pointObject:Object = GestureGlobals.gw_public::points[event.touchPointID];
			
			if (pointObject)
			{
				if (!GestureWorks.supportsTouch || GestureWorks.activeTUIO)
				{
					pointObject.point.x = event.localX;
					pointObject.point.y = event.localY;
					return;
				}
				pointObject.point.y = event.stageY;
				pointObject.point.x = event.stageX;
			}
		}
		
		
		public static function updateTouchObject(event:TouchEvent):void
		{
			//if (trace_debug_mode) trace("update Touch Object");
				
			/////////////////////////////////////////////////////////////////////////////////////////////
			// update touch object
			/////////////////////////////////////////////////////////////////////////////////////////////
			if (GestureGlobals.gw_public::points[event.touchPointID]) 
				{
				//curently returns a single object, should return a list of clusters the contain the point
				var clusterID:Object = GestureGlobals.gw_public::points[event.touchPointID].object.clusterID;
				
				
				// should update all touch objects that contain this point
				var tO:Object = GestureGlobals.gw_public::touchObjects[clusterID];//
					tO.updateClusterAnalysis();
					tO.updateProcessing();
					tO.updateGestureAnalysis();
					tO.updateTransformation();
					//tO.updateDebugDisplay(); // resource intensive moved to on enter frame
				}
		}

	}
}