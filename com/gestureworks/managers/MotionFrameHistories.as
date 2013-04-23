////////////////////////////////////////////////////////////////////////////////
//
//  IDEUM
//  Copyright 2011-2012 Ideum
//  All Rights Reserved.
//
//  GestureWorks
//
//  File:    ClusterHistories.as
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
	import com.leapmotion.leap.Frame;
	
	import com.gestureworks.objects.MotionFrameObject;
	
	
	public class MotionFrameHistories 
	{
		//////////////////////////////////////////////////////
		// based on a cluster move event
		//////////////////////////////////////////////////////
		
		public static function historyQueue(frame:Frame):void//event:ClusterEvent
		{
			// define cluster to update
			// in this case single clobal cluster ref for motion sprite
			var history:Vector.<MotionFrameObject> = GestureGlobals.gw_public::clusters[GestureGlobals.motionSpriteID].motionArray.history;
			
			// push object into history vector 
			history.unshift(historyObject(frame));
			
			GestureGlobals.motionFrameID ++;
			
			// remove last object if overflows
			if (history.length-1>=GestureGlobals.motionFrameHistoryCaptureLength)
			{
				history.pop();
			}
		}
		
		
		// loads history object and returns value.
		public static function historyObject(frame:Frame):Object
		{
			var object:MotionFrameObject = new MotionFrameObject();
				object.frame = frame;
				
				//trace("motion frame history push")

			return object;
		}
		
	}

}