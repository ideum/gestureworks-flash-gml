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
	import com.gestureworks.objects.SensorPointObject;
	import com.gestureworks.events.GWSensorEvent;
	import com.gestureworks.core.TouchSprite;
	import com.gestureworks.core.TouchMovieClip;
	import com.gestureworks.interfaces.ITouchObject3D;
	import com.gestureworks.core.GestureWorks;
	import com.gestureworks.core.GestureWorksCore;
	import com.gestureworks.core.GestureGlobals;
	import com.gestureworks.core.gw_public;
	import com.gestureworks.core.GML;
	
	
	import flash.utils.Dictionary;
	import flash.events.TouchEvent;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import flash.system.System;
	
	import flash.geom.Vector3D;
	
	
	// accelerometer
	import flash.events.AccelerometerEvent;
    import flash.sensors.Accelerometer;

	//wiimote
	import org.wiiflash.Wiimote;
    import org.wiiflash.events.*;
	
	//myo
	//arduino

	public class SensorManager
	{	
		//public static var ms:TouchSprite;
		
		public static var sensorPoints:Dictionary = new Dictionary();
		public static var touchObjects:Dictionary = new Dictionary();
		public static var gs:TouchSprite
		
		private static var sensor_init:Boolean = false;
		
		public static var nativeAccelEnabled:Boolean = false;
		public static var accelEnabled:Boolean = false;
		public static var arduinoEnabled:Boolean = false;
		public static var voiceEnabled:Boolean = false;
		public static var controllerEnabled:Boolean = false;
		
		// native accelerometer//////////////////////
		public static var act:Accelerometer; 
		
		
		
		// initializes sensorManager
		gw_public static function initialize():void
		{	
			if ((!sensor_init)&&(GestureWorks.activeSensor))
			{
			////////////////////////////////////////////////////////////////////////////////////////
			// ref global motion point list
			sensorPoints = GestureGlobals.gw_public::sensorPoints;
			touchObjects = GestureGlobals.gw_public::touchObjects;
			gs = GestureGlobals.gw_public::core;
			
			if (gs)
			{
				gs.sensorEnabled = true;
				gs.tc.sensor_core = true;
			}
			trace("init sensor manager");
			//////////////////////////////////////////////////////////////////////////////////////
			
			// CALL INIT SENSORS
			initSensors();
			}
		}
			
		public static function initSensors():void
		{
			//INIT NATIVE ACCELEROMTER CONSTRUCTOR ///////////////////////////////////////////////
			if ((nativeAccelEnabled)&&(Accelerometer.isSupported))
			{	
				// create native accel object // can be only one
				trace("native accelerometer manager init")
				act = new Accelerometer();
				
					// GET DEVICE CONFIG DATA FROM DEVICE LIST OBJECT FROM DML
					// if(updateinterval) 
					// else set interval to framerate
					act.setRequestedUpdateInterval((1 / 60) * 1000);// miliseconds
				
				act.addEventListener(AccelerometerEvent.UPDATE, accUpdateHandler);
				
				if (act) trace("native accel init")
				
				// create new sensor point and call sensor point begin
				onNativeAccelConnect();
			}
			

			//INIT WIIMOTE CONSTRUCTOR ////////////////////////////////////////////////////////////
			//if (controllerEnabled) 
			if (controllerEnabled) trace("controller constructor type:");
			
			//INIT ARDUINO CONSTRUCTOR /////////////////////////////////////////////////////////////
			if (arduinoEnabled) trace("arduino constructor");

			//INIT VOICE CONSTRUCTOR ///////////////////////////////////////////////////////////////
			if (voiceEnabled) trace("voice constructor");
		}
		
		
		////////////////////////////////////////////////////////////////////////////////////////////
		//
		////////////////////////////////////////////////////////////////////////////////////////////
		
		// registers touch point via touchSprite
		public static function registerSensorPoint(spo:SensorPointObject):void
		{
			//spo.history.unshift(SensorPointHistories.historyObject(spo))
		}
		
		public static function onSensorBeginPoint(pt:SensorPointObject):void
		{			
			//trace("motion point begin, motionManager",event.value.motionPointID);
			// create new point object
			var spO:SensorPointObject  = new SensorPointObject();
					trace(gs);
						spO.id = gs.sensorPointCount; 
						spO.sensorPointID = pt.sensorPointID;
					 
						spO.type = pt.type;
						spO.devicetype = pt.devicetype;
						
						spO.position = pt.position;
						spO.direction = pt.direction;
						spO.normal = pt.normal;
						
						spO.size = pt.size;
						//spO.length = pt.length;
						//spO.width = pt.width;
						
						spO.orientation = pt.orientation;
						//spO.yaw = pt.yaw;
						//spO.roll = pt.roll;
						//spO.pitch = pt.pitch;
						
						//spO.velocity = pt.velocity;
						spO.acceleration = pt.acceleration;
						//spO.jolt = pt.jolt;
						//spO.snap = pt.snap;
						//spO.crackle = pt.crackle;
						//spO.pop = pt.pop;
						
						spO.phase = "begin";
					
					//ADD TO GLOBAL MOTION SPRITE POINT LIST
					if (!gs.cO.sensorArray) gs.cO.sensorArray = new Vector.<SensorPointObject>
					gs.cO.sensorArray.push(spO);
					gs.sensorPointCount++;
				
				// ASSIGN POINT OBJECT WITH GLOBAL POINT LIST DICTIONARY
				GestureGlobals.gw_public::sensorPoints[pt.sensorPointID] = spO;
				
				//trace("SENSOR POINT BEGIN")
				
				// REGISTER TOUCH POINT WITH TOUCH MANAGER
				//registerMotionPoint(spO);
			
		}
	
		public static function onSensorEndPoint(sensorPointID:int):void
		{
			//trace("Motion point End, motionManager", event.value.motionPointID)
			var spointObject:SensorPointObject = sensorPoints[sensorPointID];
			//trace("ready to remove", pointObject);
			
			if (spointObject)
			{
				spointObject.phase = "end";
				
					// REMOVE POINT FROM LOCAL LIST
					gs.cO.sensorArray.splice(spointObject.id, 1);
					//test motionSprite.cO.motionArray.splice(pointObject.motionPointID, 1);
					
					// REDUCE LOACAL POINT COUNT
					gs.sensorPointCount--;
					
					// UPDATE POINT ID 
					for (var i:int = 0; i < gs.cO.sensorArray.length; i++)
					{
						gs.cO.sensorArray[i].id = i;
					}
					// DELETE FROM GLOBAL POINT LIST
					delete sensorPoints[sensorPointID];
			}
			
			//trace("should be removed",mpoints[motionPointID], motionSprite.motionPointCount, motionSprite.cO.motionArray.length);
			//trace("motion point tot",motionSprite.motionPointCount)
			
			//trace("SENSOR POINT END")
		}
		
		
		public static function onSensorUpdatePoint(pt:SensorPointObject):void
		{			
			//  CONSOLODATED UPDATE METHOD FOR POINT POSITION AND TOUCH OBJECT CALCULATIONS
			//trace("motion move/Update event, motionManager", event.value.motionPointID);
			
			var spO:SensorPointObject = sensorPoints[pt.sensorPointID];
			
				if (spO)
				{	
					//trace(event.value.position.x, event.value.position.y,event.value.position.z)
					//mpO.id  = event.value.id;
					//mpO.motionPointID  = event.value.motionPointID;
					//mpO.handID = pt.handID;
					
					spO.position = pt.position;
					spO.direction = pt.direction;
					spO.normal = pt.normal;
					spO.velocity = pt.velocity;
					spO.size = pt.size;
					//spO.length = pt.length;
					//spO.width = pt.width;
					
					//spO.yaw = pt.yaw;
					//spO.roll = pt.roll;
					//spO.pitch = pt.pitch;
					
					spO.orientation = pt.orientation;
					spO.acceleration = pt.acceleration;
					spO.jolt = pt.jolt;
					spO.snap = pt.snap;
					spO.crackle = pt.crackle;
					spO.pop = pt.pop;
					
					spO.buttons = pt.buttons;
					//nunchcuck
					
					spO.phase = "update"
					
					/*
					if (spO.history.length>1)
					{
						//trace("historyObject",spo.acceleration.x,spo.history[0].acceleration.x,spo.history[1].acceleration.x,spo.history[2].acceleration.x)
						spO.jolt = new Vector3D(spO.acceleration.x - spO.history[1].acceleration.x, spO.acceleration.y - spO.history[1].acceleration.y, spO.acceleration.z - spO.history[1].acceleration.z);
						spO.snap = new Vector3D(spO.jolt.x - spO.history[1].jolt.x, spO.jolt.y - spO.history[1].jolt.y, spO.jolt.z - spO.history[1].jolt.z);
						spO.crackle = new Vector3D(spO.snap.x - spO.history[1].snap.x, spO.snap.y - spO.history[1].snap.y, spO.snap.z- spO.history[1].snap.z);
						spO.pop = new Vector3D(spO.crackle.x - spO.history[1].crackle.x, spO.crackle.y - spO.history[1].crackle.y,spO.crackle.z - spO.history[1].crackle.z);
					}
					*/
					
				}
				
				// UPDATE POINT HISTORY 
				//SensorPointHistories.historyQueue(event);
				//trace("SENSOR POINT UPDATE")
		}	
		
		//////////////////////////////////////////////////////////////////////////////
		//NATIVE ACCELEROMETER HANDLERS
		//////////////////////////////////////////////////////////////////////////////
		public static function onNativeAccelConnect():void
        {
			//CREATE PAIRED SENSOR POINT ONE PER DEVICE FOR SIMPLE DEVICES
				var spt:SensorPointObject = new SensorPointObject();
					spt.id = 0;
					spt.position.x = 500;
					spt.position.y = 500;
					
					if (!gs.cO.sensorArray) gs.cO.sensorArray = new Vector.<SensorPointObject>
					gs.cO.sensorArray.push(spt);
					gs.sensorPointCount++;
				
				// ASSIGN POINT OBJECT WITH GLOBAL POINT LIST DICTIONARY
				GestureGlobals.gw_public::sensorPoints[spt.sensorPointID] = spt;
			
			//dispatch SENSOR POINT ADD
			onSensorBeginPoint(spt); // push begin
			//onSensorBegin(new GWSensorEvent(GWSensorEvent.SENSOR_BEGIN, na_pt, true, false)); // push begin event
        }
		
		public static function accUpdateHandler(event:AccelerometerEvent):void
        {
			//NOTE NEED TO CREATE GLOBAL POINT REFERNCE FOR NAPT
			
			//GET GLOABLLY CONFIGURED SCALING CONSTS
			trace("pushing accel data",event.accelerationX, event.accelerationY, event.accelerationZ, event.timestamp)
			 /*
				var na_pt:SensorPointObject = sensorPoints[nativeSensorID];
				na_pt.id = 
				na_pt.type = "nativeAccel";
				na_pt.devicetype = "android"
				na_pt.acceleration.x =  event.accelerationX;
				na_pt.acceleration.y =  event.accelerationY;
				na_pt.acceleration.z =  event.accelerationZ;
				na_pt.phase = "update"

			gs.cO.sensorArray.push(na_pt);
			onSensorUpdatePoint(na_pt); //push update 
			//onSensorUpdate(new GWSensorEvent(GWSensorEvent.SENSOR_UPDATE, na_pt, true, false)); //push update event
			*/
		}
		

	}
}