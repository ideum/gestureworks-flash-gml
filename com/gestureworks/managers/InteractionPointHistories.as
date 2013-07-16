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
	import com.gestureworks.events.GWInteractionEvent;
	import com.gestureworks.objects.InteractionPointObject;
	
	
	public class InteractionPointHistories 
	{
		//////////////////////////////////////////////////////
		// based on a cluster move event
		//////////////////////////////////////////////////////
		
		public static function historyQueue(event:GWInteractionEvent):void//event:ClusterEvent
		{
			// define cluster to update
			var ipo:InteractionPointObject = GestureGlobals.gw_public::interactionPoints[event.value.interactionPointID];
			
			
			
			if (ipo) 
			{
				// push object into history vector 
				ipo.history.unshift(historyObject(ipo));
				
				// remove last object if overflows
				if (ipo.history.length-1>=GestureGlobals.motionHistoryCaptureLength)
				{
					ipo.history.pop();
				}
			}
		}
		
		
		// loads history object and returns value.
		public static function historyObject(ipo:InteractionPointObject):Object
		{
			//var FrameID:int = 0;
			
			var object:InteractionPointObject = new InteractionPointObject();
				//object = ipo;
				
				object.position = ipo.position;
				//trace("interaction point history push")

			return object;
		}
		
	}

}