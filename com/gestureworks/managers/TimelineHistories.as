////////////////////////////////////////////////////////////////////////////////
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
	
	import com.gestureworks.core.GestureGlobals;
	import com.gestureworks.core.gw_public;
	import com.gestureworks.objects.TimelineObject;
	
	public class TimelineHistories 
	{
		//////////////////////////////////////////////////////
		// based on a cluster move event
		//////////////////////////////////////////////////////
		
		public static function historyQueue(ClusterID:Object):void//event:ClusterEvent
		{
			//trace("capturing timline histories");
			
			var tiO:TimelineObject = GestureGlobals.gw_public::timelines[ClusterID];
			var history:Array = tiO.history;
			
			//GestureGlobals.timelineHistoryCaptureLength = 120;
			
			history.unshift(tiO.frame);
			
			if (history.length-1>=GestureGlobals.timelineHistoryCaptureLength)
			{
				history.pop();
			}
		}
		
		// loads history object and returns value.
		public static function historyObject(frame:Object):Object
		{
			//trace("in hist");
			var object:Object = new Object();
				
				object = frame;
		
			return object;
		}
		
	}

}