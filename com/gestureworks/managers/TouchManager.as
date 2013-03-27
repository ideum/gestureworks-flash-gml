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
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import flash.system.System;
	
	import com.gestureworks.core.GestureWorks;
	import com.gestureworks.core.GestureWorksCore;
	import com.gestureworks.core.GestureGlobals;
	import com.gestureworks.core.gw_public;
	import com.gestureworks.core.GML;
	
	import com.gestureworks.utils.ArrangePoints;
	import com.gestureworks.managers.PointHistories;
	import com.gestureworks.events.GWEvent;
	
	import com.gestureworks.objects.PointObject;
	import com.gestureworks.objects.TouchObject;
	import com.gestureworks.managers.PointHistories;
	import com.gestureworks.utils.Simulator;
	
	import com.gestureworks.objects.FrameObject;
	
	
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
		public static var touchObjects:Dictionary = new Dictionary();
		//public static var globalClock:Timer = new Timer(GestureGlobals.touchFrameInterval, 0);
		//public static var globalClock:Timer = new Timer(8, 0);
		
		// initializes touchManager
		gw_public static function initialize():void
		{	
			//trace("touch frame processing rate:",GestureGlobals.touchFrameInterval);
			
			points = GestureGlobals.gw_public::points;
			touchObjects = GestureGlobals.gw_public::touchObjects;
			
			//DRIVES UPDATES ON POINT LIFETIME
			if (GestureWorks.supportsTouch) GestureWorks.application.addEventListener(TouchEvent.TOUCH_END, onTouchUp);
			
			// DRIVES UPDATES ON TOUCH POINT PATHS
			if (GestureWorks.supportsTouch) GestureWorks.application.addEventListener(TouchEvent.TOUCH_MOVE, onTouchMove);
			
			// SINGLE GLOBAL CLOCK FOR TOUCH PROCESSING
			// COMPILES TOUCH FRAMES
			//globalClock.addEventListener(TimerEvent.TIMER, touchFrameHandler, false,10,false);
			//globalClock.start();
			
			// leave this on for all input types
			GestureWorks.application.addEventListener(GWEvent.ENTER_FRAME, touchFrameHandler);
		}
		
		gw_public static function resetGlobalClock():void
		{
			//globalClock = new Timer(GestureGlobals.touchFrameInterval, 0);
			//globalClock = new Timer(2000, 0);
		}
		
		gw_public static function deInitialize():void
		{
			GestureWorks.application.removeEventListener(TouchEvent.TOUCH_END, onTouchUp);
			GestureWorks.application.removeEventListener(TouchEvent.TOUCH_MOVE, onTouchMove);
		}
		
		
		public static function pointCount():int {
			
			var count:int = 0;
			for each(var point:Object in points)
			//for each(var ts:Object in touchObjects)
				{
				count++;
				//trace("what")
				}
			//trace(count);
			return count;
		} 
		
		// registers touch point via touchSprite
		gw_public static function registerTouchPoint(event:TouchEvent):void
		{
			// CHECK GLOBAL MAX POINT COUNT HERE
			// DO NOT REGISTER IF OVER THRESHOLD
			// 1000 IS DEFAULT MAX
			
			//trace(pointCount())
			
			//if (pointCount()<2){

			//if (!GestureWorks.activeTUIO) points[event.touchPointID].history.unshift(PointHistories.historyObject(event.stageX, event.stageY,GestureGlobals.frameID,0,event,points[event.touchPointID]))
			//else points[event.touchPointID].history.unshift(PointHistories.historyObject(event.localX, event.localY, GestureGlobals.frameID, 0, event, points[event.touchPointID]));
			
			//if (!GestureWorks.activeTUIO) points[event.touchPointID].history.unshift(PointHistories.historyObject(event.stageX, event.stageY,event,GestureGlobals.frameID))
			//else points[event.touchPointID].history.unshift(PointHistories.historyObject(event.localX, event.localY, event, GestureGlobals.frameID));
			
			points[event.touchPointID].history.unshift(PointHistories.historyObject(event))
			
			//}
			//else return
			
			
		}
		
		// stage on TOUCH_UP.
		public static function onTouchUp(event:TouchEvent):void
		{
			//trace("TouchEnd manager")
			//trace("---------------------------------------------------");
			var pointObject:Object = points[event.touchPointID];
			
			if (pointObject)
			{
				//trace("pointID:",event.touchPointID,"length",pointObject.objectList.length,"event",event)
				/////////////////////////////////////////////////////////////////////////////////////
				/////////////////////////////////////////////////////////////////////////////////////
				// LOOP THROUGH ALL CLUSTERS LISTED ON POINT
				for (var j:int = 0; j < pointObject.objectList.length; j++)
				{
					//trace("updating targets");
					var tO:Object = pointObject.objectList[j];
					
					//trace("tsprite:", tO, "frame:", tO.tiO.frame.pointEventArray);
					//trace("tsprite:",tO, "pointlist",tO.N,tO.pointArray.length, tO.pointArray);
					
					// UPDATE EVENT TIMELINES // push touch up event to touch object timeline
					//if ((tO.tiO.timelineOn) && (tO.tiO.pointEvents)) 
					if(tO.tiO) tO.tiO.frame.pointEventArray.push(event);// pushed touch up events into the timeline object
					//UPDATE DEBUG DISPLAY // clear local debug display
					if ((tO.td) && (tO.td.debug_display) && (tO.cO)) 	tO.td.clearDebugDisplay(); // clear display
					
					// analyze for taps
					if (tO.tg) tO.tg.onTouchEnd(event);
					
					// REMOVE POINT FROM LOCAL LIST
					tO.pointArray.splice(pointObject.id, 1);
					
					// REDUCE LOACAL POINT COUNT
					tO.pointCount--;
					
					// UPDATE POINT ID 
					for (var i:int = 0; i < tO.pointArray.length; i++)
					{
						tO.pointArray[i].id = i;
					}
					
					// update broadcast state
					if(tO.N == 0) tO.broadcastTarget = false;
					
					////////////////////////////////////////////////////////
					//FORCES IMMEDIATE UPDATE ON TOUCH UP
					//HELPS ENSURE ACCURATE RELEASE STATE FOR SINGLE FINGER SINGLE TAP CAPTURES
					updateTouchObject(tO);
					////////////////////////////////////////////////////////
					
					//trace("to n", tO.N, "co n", tO.cO.n, "to pointArry length", tO.pointArray.length);
				}
				/////////////////////////////////////////////////////////////////////////////////////
				////////////////////////////////////////////////////////////////////////////////////
				
			// DELETE FROM GLOBAL POINT LIST
			delete points[event.touchPointID];
			}
			//trace("--//--")
		}
		
	
		// the Stage TOUCH_MOVE event.	
		// DRIVES POINT PATH UPDATES
		public static function onTouchMove(event:TouchEvent):void
		{			
			//  CONSOLODATED UPDATE METHOD FOR POINT POSITION AND TOUCH OBJECT CALCULATIONS
			var pointObject:PointObject = points[event.touchPointID];
			
			//trace("touch move event");
			
			if (pointObject)
			{	
				// UPDATE POINT POSITIONS
				if (!GestureWorks.supportsTouch || GestureWorks.activeTUIO)
				{
					pointObject.y = event.localY;
					pointObject.x = event.localX;
				}
				else
				{	
					pointObject.y = event.stageY;
					pointObject.x = event.stageX;
				}
				pointObject.moveCount ++;
				
				// UPDATE POINT HISTORY 
				// PUSHES NEWEST LOCATION DATA TO POINT PATH/HISTORY
				PointHistories.historyQueue(event);
			}	
			
			//touchFrameHandler3(event);
		}
		
		// UPDATE ALL TOUCH OBJECTS IN DISPLAY LIST
		public static function touchFrameHandler(event:GWEvent):void
		{
			//trace("touch frame process ----------------------------------------------");
			
			//INCREMENT TOUCH FRAME id
			GestureGlobals.frameID += 1;
			
			// update all touch objects in display list
			for each(var tO:Object in touchObjects)
			{
				// update touch,cluster and gesture processing
				updateTouchObject(tO);
				
				// move to timeline visualizer
				// CURRENTLY NO GESTURE OR CLUSTER ANALYSIS REQURES
				// DIRECT CLUSTER OR TRANSFROM HISTORY, USED IN DEBUG ONLY
				if ((tO.td)&&(tO.td.debug_display))
				{
					//UPDATE CLUSTER HISTORIES
					//ClusterHistories.historyQueue(tO.touchObjectID);
					
					//UPDATE TRANSFORM HISTORIES
					TransformHistories.historyQueue(tO.touchObjectID);
					
					// update touch object debugger display
					tO.updateDebugDisplay();
				}
				
				
				// clear frame 
				// was just pushing events and never clearing object 
				if(tO.tiO) tO.tiO.frame = new FrameObject();
			}
		}
		
		
		// EXTERNAL UPDATE METHOD/////////////////////////////////////////////////////////
		
		public static function updateTouchObject(tO:Object):void
		{
				//trace("hello", ts, ts.N);
				// THERFOR CLUSTER ANALYSIS IS N SPECICIFC AND SELF MAMANGED SWITCHING
				// PIPELINE PROCESSING IS GESTURE OBJECT STATE DEPENDANT AND NOT N DEPENDANT
				
				//tO.updateClusterAnalysis(); // cluster count is in cluster analysis
				//tO.updateGesturePipeline();
				//tO.updateTransformation();
				
				tO.updateTObjProcessing();
				
				
				// check for erroneous points
				// kill after processing (just in case)
				if (tO.N!=0) {
					for (var i:int = 0; i < tO.N; i++) {
						if (points[tO.pointArray[i].touchPointID] == undefined) {
						
							//trace("kill zombe",tO,tO.cO,tO.cO.pointArray.length,tO.cO.pointArray.length,tO.pointArray[i].touchPointID,i);

								/*
									tO.pointCount = 0;
									tO.cO.n = 0;
									tO.N = 0;
									tO.pointArray[i] = null;
									tO.cO.pointArray[i] = null;
							 
									// REMOVE POINT FROM LOCAL LIST
									tO.pointArray.splice(tO.pointArray[i].touchPointID, 1);
									
									// REDUCE LOACAL POINT COUNT
									tO.pointCount--;
									
									// UPDATE POINT ID 
									for (var k:int = 0; k < tO.pointArray.length; k++)
									{
										tO.pointArray[k].id = k;
									}
								*/
							
							tO.cO.pointArray.length = 0; // best way to kill
							return
						}
					}
				}
		}
		
		
		/*
		public static function updatePointObject(event:TouchEvent):void
		{
			//var pointObject:Object = GestureGlobals.gw_public::points[event.touchPointID];
			var pointObject:Object = points[event.touchPointID];
			
			if (pointObject)
			{
				pointObject.y = event.stageY;
				pointObject.x = event.stageX;
			}	
		}*/
		
	}
}