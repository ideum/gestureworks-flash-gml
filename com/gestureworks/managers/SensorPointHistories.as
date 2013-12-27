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
		//private static var object:SensorPointObject;
		
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
				spo.history.unshift(historyObject(spo));////event
				
				// remove last object if overflows
				if (spo.history.length-1>=GestureGlobals.sensorHistoryCaptureLength)
				{
					spo.history.pop();
				}
			}
		}
		
		
		// loads history object and returns value.
		public static function historyObject(spo:SensorPointObject):Object////event:GWSensorEvent
		{
			//var spo = event.value;
			// MUST PUSH OBJECT VALUES NOT
			// OBJECTS OR SUBOBJECTS
			
				var object:SensorPointObject = new SensorPointObject();
				object.type = spo.type;
				object.devicetype = spo.devicetype;
				
				object.position.x = spo.position.x;
				object.position.y = spo.position.y;
				object.position.z = spo.position.z;
				
				object.acceleration.x = spo.acceleration.x//spo.acceleration;
				object.acceleration.y = spo.acceleration.y//spo.acceleration;
				object.acceleration.z = spo.acceleration.z//spo.acceleration;
				
				object.jolt.x = spo.jolt.x//spo.acceleration;
				object.jolt.y = spo.jolt.y//spo.acceleration;
				object.jolt.z = spo.jolt.z//spo.acceleration;
				
				object.snap.x = spo.snap.x//spo.acceleration;
				object.snap.y = spo.snap.y//spo.acceleration;
				object.snap.z = spo.snap.z//spo.acceleration;
				
				object.crackle.x = spo.crackle.x//spo.acceleration;
				object.crackle.y = spo.crackle.y//spo.acceleration;
				object.crackle.z = spo.crackle.z//spo.acceleration;
				
				object.pop.x = spo.pop.x//spo.acceleration;
				object.pop.y = spo.pop.y//spo.acceleration;
				object.pop.z = spo.pop.z//spo.acceleration;
				
				object.roll = spo.roll;
				object.yaw = spo.yaw;
				object.roll = spo.roll;
				
				object.phase = "history"
				
			//	trace(ipo.history.length)
				
			/*
				// ADVANCED MOTION PROEPRTIES
				if (spo.history.length>2)
				{
					//trace("historyObject",spo.position.x,spo.history[1].position.x,spo.history[2].position.x)
					trace("historyObject",spo.acceleration.x,spo.history[0].acceleration.x,spo.history[1].acceleration.x,spo.history[2].acceleration.x)
					object.jolt = new Vector3D(spo.acceleration.x - spo.history[1].acceleration.x, spo.acceleration.y - spo.history[1].acceleration.y, spo.acceleration.z - spo.history[1].acceleration.z);
					object.snap = new Vector3D(spo.jolt.x - spo.history[1].jolt.x, spo.jolt.y - spo.history[1].jolt.y, spo.jolt.z - spo.history[1].jolt.z);
					object.crackle = new Vector3D(spo.snap.x - spo.history[1].snap.x, spo.snap.y - spo.history[1].snap.y, spo.snap.z - spo.history[1].snap.z);
					object.pop = new Vector3D(spo.crackle.x - spo.history[1].crackle.x, spo.crackle.y - spo.history[1].crackle.y,spo.crackle.z - spo.history[1].crackle.z);
				}
				//trace("interaction point history push")
			*/
				
			return object;
		}
		
	}

}