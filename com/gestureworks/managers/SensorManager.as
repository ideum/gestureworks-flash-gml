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
	import flash.sensors.Accelerometer;
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
	
	// accelerometer
	import flash.events.AccelerometerEvent;
    import flash.sensors.Accelerometer;
	
	public class SensorManager
	{	
		public static var act:Accelerometer; 
		
		// initializes touchManager
		gw_public static function initialize():void
		{	
			
			
			trace("accel init")
			
			
			//if (Accelerometer.isSupported)
            //{
				act = new Accelerometer();
				act.addEventListener(AccelerometerEvent.UPDATE, accUpdateHandler);
			//}
			
		}
		
		public static function accUpdateHandler(event:AccelerometerEvent):void
        {
            trace("ax", event.accelerationX);
            trace("ay", event.accelerationY);
			trace("az", event.accelerationZ);
			trace("timestamp", event.timestamp);
        }
		
		/*
		gw_public static function deInitialize():void
		{
			
			
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
		//	points[event.touchPointID].history.unshift(PointHistories.historyObject(event))
		}
		
		// stage on TOUCH_UP.
		public static function onTouchUp(event:TouchEvent):void
		{
			
			//trace("TouchEnd manager")
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
					if(tO.tiO) tO.tiO.frame.pointEventArray.push(event);// pushed touch up events into the timeline object
					//UPDATE DEBUG DISPLAY // clear local debug display
					if ((tO.td)&&(tO.td.debug_display) && (tO.cO)) tO.td.clearDebugDisplay(); // clear display
					
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
				}
			}
			// DELETE FROM GLOBAL POINT LIST
			delete points[event.touchPointID];
			
			
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
					ClusterHistories.historyQueue(tO.touchObjectID);
					
					//UPDATE TRANSFORM HISTORIES
					TransformHistories.historyQueue(tO.touchObjectID);
					
					// update touch object debugger display
					tO.updateDebugDisplay();
				}
				
			}
		}
		
		
		*/
		
	}
}