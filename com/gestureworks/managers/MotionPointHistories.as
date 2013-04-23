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
	import com.gestureworks.events.GWMotionEvent;
	
	import com.gestureworks.objects.MotionPointObject;
	
	
	public class MotionPointHistories 
	{
		//////////////////////////////////////////////////////
		// based on a cluster move event
		//////////////////////////////////////////////////////
		
		public static function historyQueue(event:GWMotionEvent):void//event:ClusterEvent
		{
			// define cluster to update
			var mpo:MotionPointObject = GestureGlobals.gw_public::motionPoints[event.value.motionPointID];
			
			if (mpo) {
				//var history:Vector.<MotionPointObject> = mpo.history;
				
				// push object into history vector 
				mpo.history.unshift(historyObject(mpo));
				
				// remove last object if overflows
				if (mpo.history.length-1>=GestureGlobals.motionHistoryCaptureLength)
				{
					mpo.history.pop();
				}
			}
		}
		
		
		// loads history object and returns value.
		public static function historyObject(mpo:MotionPointObject):Object
		{
			
			
			var object:MotionPointObject = new MotionPointObject();
				object = mpo;
				
				//trace("motion frame history push")

			return object;
		}
		
	}

}