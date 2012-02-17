////////////////////////////////////////////////////////////////////////////////
//
//  IDEUM
//  Copyright 2011-2012 Ideum
//  All Rights Reserved.
//
//  GestureWorks
//
//  File:    ProcessHistories.as
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
	import com.gestureworks.objects.ProcessObject;
	
	public class ProcessHistories
	{
		//////////////////////////////////////////////////////
		// based on a cluster move event
		//////////////////////////////////////////////////////
		
		public static function historyQueue(ClusterID:Object):void
		{
			var history:Array = GestureGlobals.gw_public::clusters[ClusterID].history;
			var processObject:ProcessObject = GestureGlobals.gw_public::processes[ClusterID]
		
			history.unshift(historyObject(processObject));
			
			if (history.length-1>=GestureGlobals.pointHistoryCaptureLength)
			{
				history.pop();
			}
		}
		
		// loads history object and returns value.
		public static function historyObject(processObject:Object):Object
		{
			var object:Object = new Object();
			
				// standard cluster properties
				object.n = processObject.n;
				object.x = processObject.x;
				object.y = processObject.y;
				//object.w = filterObject.width;
				//object.h = filterObject.height;
				//object.r = filterObject.radius;
				//object.orientation = filterObject.orientation;
				//object.rotation = filterObject.rotation;
				//object.separation = filterObject.separation;
				//object.thumbID = filterObject.thumbID;


			return object;
		}
		
	}

}