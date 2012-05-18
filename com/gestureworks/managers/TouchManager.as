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
	IMPORTANT NOTE TO DEVELOPER ********************************
	PlEASE DO NOT ERASE OR DEVALUE ANYTHING WHITHIN THIS CLASS
	IF YOU HAVE ANY QUESTIONS, ANY AT ALL. PLEASE ASK PAUL LACEY
	DO NOT TAKE CODE OUT UNLESS YOUR CHANGES ARE VERIEFIED, 
	TESTED AND CONTINUE TO WORK WITH LEGACY BUILDS !
	************************************************************
	*/
	
	public class TouchManager
	{
		public static var points:Dictionary = new Dictionary();
		
		// initializes touchManager...
		gw_public static function initialize():void
		{
			points = GestureGlobals.gw_public::points;
			if (GestureWorks.supportsTouch) GestureWorks.application.addEventListener(TouchEvent.TOUCH_END, onTouchUp);
			if (GestureWorks.supportsTouch) GestureWorks.application.addEventListener(TouchEvent.TOUCH_MOVE, onTouchMove);
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
		}
		
		// stage on TOUCH_UP.
		public static function onTouchUp(event:TouchEvent):void
		{
			//trace("TouchEnd manager")
			//var pointObject:Object = GestureGlobals.gw_public::points[event.touchPointID];
			var pointObject:Object = points[event.touchPointID];
			
			if (pointObject)
			{
				// LOOP THROUGH ALL CLUSTERS LISTED ON POINT
				for (var j:int = 0; j < pointObject.objectList.length; j++)
				{
					//trace("updating targets");
					var tO:Object = pointObject.objectList[j];
					
					// UPDATE EVENT TIMELINES // push touch up event to touch object timeline
					//if ((tO.tiO.timelineOn) && (tO.tiO.pointEvents)) 
					tO.tiO.frame.pointEventArray.push(event);// pushed touch up events into the timeline object
					//UPDATE DEBUG DISPLAY // clear local debug display
					if ((tO.debug_display) && (tO.cO)) tO.clearDebugDisplay(); // clear display
					
					// analyze for taps
					tO.onTouchEnd(event);
					
					// REMOVE POINT FROM LOCAL LIST
					tO.pointArray.splice(pointObject.id, 1);
					
					// REDUCE LOACAL POINT COUNT
					tO.pointCount--;
					
					// UPDATE POINT ID 
					for (var i:int = 0; i < tO.pointArray.length; i++)
					{
						tO.pointArray[i].id = i;
					}
				}
			}
			// DELETE FROM GLOBAL POINT LIST
			delete points[event.touchPointID];
		}
		
	
		// the Stage TOUCH_MOVE event.	
		public static function onTouchMove(event:TouchEvent):void
		{			
			// update point history
			PointHistories.historyQueue(event);
			
			//  CONSOLODATED UPDATE METHOD FOR POINT POSITION AND TOUC OBJECT CALCULATIONS
			//var pointObject:Object = GestureGlobals.gw_public::points[event.touchPointID];
			var pointObject:Object = points[event.touchPointID];
			
			if (pointObject)
			{
				// UPDATE POINT POSITIONS
				if (!GestureWorks.supportsTouch || GestureWorks.activeTUIO)
				{
					//pointObject.point.x = event.localX;
					//pointObject.point.y = event.localY;
					pointObject.point.y = event.stageY;
					pointObject.point.x = event.stageX;
					//return;
				}
				pointObject.point.y = event.stageY;
				pointObject.point.x = event.stageX;
				
				// UPDATE TOUCH OBJECTS
				for (var j:int = 0; j < pointObject.objectList.length; j++) // NEED TO COME UP WITH METHOD TO REMOVE OBJECTS THAT ARE NO LONGER ON STAGE
				{
					//var tO:Object = pointObject.object;
					var tO:Object = pointObject.objectList[j];
						tO.updateClusterAnalysis();
						tO.updateProcessing();
						tO.updateGestureAnalysis();
						tO.updateTransformation();
						//tO.updateDebugDisplay(); // resource intensive moved to on enter frame
				}
			}	
		}
		
		// EXTERNAL UPDATE METHOD/////////////////////////////////////////////////////////
		public static function updatePointObject(event:TouchEvent):void
		{
			//var pointObject:Object = GestureGlobals.gw_public::points[event.touchPointID];
			var pointObject:Object = points[event.touchPointID];
			
			if (pointObject)
			{
				// UPDATE POINT POSITIONS
				if (!GestureWorks.supportsTouch || GestureWorks.activeTUIO)
				{
					//pointObject.point.x = event.localX;
					//pointObject.point.y = event.localY;
					pointObject.point.y = event.stageY;
					pointObject.point.x = event.stageX;
					//return;
				}
				pointObject.point.y = event.stageY;
				pointObject.point.x = event.stageX;
			}	
		}
		
		//EXTERNAL UPDATE METHOD/////////////////////////////////////////////////////////////
		public static function updateTouchObject(event:TouchEvent):void
		{
			//var pointObject:Object = GestureGlobals.gw_public::points[event.touchPointID];
			var pointObject:Object = points[event.touchPointID];
			
			if (pointObject)
			{
				// UPDATE TOUCH OBJECT
				var tO:Object = pointObject.object;//
					tO.updateClusterAnalysis();
					tO.updateProcessing();
					tO.updateGestureAnalysis();
					tO.updateTransformation();
					//tO.updateDebugDisplay(); // resource intensive moved to on enter frame
			}	
		}

		
	}
}