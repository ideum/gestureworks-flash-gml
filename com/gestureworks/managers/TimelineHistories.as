﻿////////////////////////////////////////////////////////////////////////////////
//
//  IDEUM
//  Copyright 2011-2012 Ideum
//  All Rights Reserved.
//
//  GestureWorks
//
//  File:    TimelineHistories.as
//  Authors:  Ideum
//             
//  NOTICE: Ideum permits you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////
package com.gestureworks.managers 
{
	/**
	 * ...
	 * @author Paul Lacey
	 */
	import com.gestureworks.managers.PoolManager;
	import com.gestureworks.core.GestureGlobals;
	import com.gestureworks.core.gw_public;
	import com.gestureworks.objects.TimelineObject;
	import com.gestureworks.objects.FrameObject;
	
	
	import com.gestureworks.events.GWTouchEvent;
	import com.gestureworks.events.GWClusterEvent;
	import com.gestureworks.events.GWGestureEvent;
	import com.gestureworks.events.GWTransformEvent;
	
	public class TimelineHistories 
	{
		//////////////////////////////////////////////////////
		// based on a cluster move event
		//////////////////////////////////////////////////////
		
		public static function historyQueue(tiO:TimelineObject):void//event:ClusterEvent
		{
			//trace("capturing timline histories");
			
			//history.unshift(tiO.frame);
			tiO.history.unshift(historyObject(tiO.frame));
			
			if (tiO.history.length-1>=GestureGlobals.timelineHistoryCaptureLength)
			{
				tiO.history.pop();
			}
		}
		
		// loads history object and returns value.
		public static function historyObject(frame:FrameObject):Object
		{
			//trace("in hist");
			//var object:Object = new Object();
				//object = frame;
		
			//return object;
			
			//trace("in hist");
			//var object:FrameObject = PoolManager.frameObject;
			var object:FrameObject = new FrameObject;
				
			var ten:int
			var gen:int
			
				if (frame.pointEventArray) ten = frame.pointEventArray.length
				else ten = 0;
				if (frame.gestureEventArray) gen = frame.gestureEventArray.length
				else gen = 0;
				//trace("arrays", ten,gen);
				//object.pointEventArray = frame.pointEventArray;
				//object.gestureEventArray = frame.gestureEventArray;
				
				
				object.pointEventArray = new Vector.<GWTouchEvent>();
				object.gestureEventArray = new Vector.<GWGestureEvent>();
				
				for (var i:uint = 0; i < ten; i++) 
				{
					object.pointEventArray[i] = frame.pointEventArray[i];
				}
				
				for (var j:uint = 0; j < gen; j++) 
				{
					object.gestureEventArray[j] = frame.gestureEventArray[j];
				}
				
				
			return object;
		}
		
	}

}