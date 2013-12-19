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
	import com.gestureworks.events.GWSensorEvent;
	import com.gestureworks.objects.SensorPointObject;
	import flash.geom.Vector3D;
	
	
	public class SensorPointHistories 
	{
		//////////////////////////////////////////////////////
		// based on a cluster move event
		//////////////////////////////////////////////////////
		
		public static function historyQueue(event:GWSensorEvent):void//event:ClusterEvent
		{
			// define cluster to update
			var spo:SensorPointObject = GestureGlobals.gw_public::sensorPoints[event.value.sensorPointID];
			
			
			
			if (spo) 
			{
				// push object into history vector 
				spo.history.unshift(historyObject(spo));
				
				// remove last object if overflows
				if (spo.history.length-1>=GestureGlobals.sensorHistoryCaptureLength)
				{
					spo.history.pop();
				}
			}
		}
		
		
		// loads history object and returns value.
		public static function historyObject(spo:SensorPointObject):Object
		{
			//var FrameID:int = 0;
			
			var object:SensorPointObject = new SensorPointObject();
				//object = spo;
				
				object.type = spo.type;
				object.devicetype = spo.devicetype;
				
				object.position = spo.position;
				object.acceleration = spo.acceleration;
				object.roll = spo.roll;
				object.yaw = spo.yaw;
				object.roll = spo.roll;
				object.phase = "history"
				
			//	trace(ipo.history.length)
				
				// ADVANCED MOTION PROEPRTIES
				if (spo.history.length>1)
				{
					//trace(ipo.position.x,ipo.history[1].position.x,ipo.history[2].position.x)
					object.jolt = new Vector3D(spo.acceleration.x - spo.history[1].acceleration.x, spo.acceleration.y - spo.history[1].acceleration.y, spo.acceleration.z - spo.history[1].acceleration.z);
					object.snap = new Vector3D(spo.jolt.x - spo.history[1].jolt.x, spo.jolt.y - spo.history[1].jolt.y, spo.jolt.z - spo.history[1].jolt.z);
					object.crackle = new Vector3D(spo.snap.x - spo.history[1].snap.x, spo.snap.y - spo.history[1].snap.y, spo.snap.z - spo.history[1].snap.z);
					object.pop = new Vector3D(spo.crackle.x - spo.history[1].crackle.x, spo.crackle.y - spo.history[1].crackle.y,spo.crackle.z - spo.history[1].crackle.z);
				}
				//trace("interaction point history push")

			return object;
		}
		
	}

}