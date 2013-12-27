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
		
		public static var spoints:Dictionary = new Dictionary();
		public static var touchObjects:Dictionary = new Dictionary();
		public static var gss:*
		
		public static var nativeAccelEnabled:Boolean = false;
		public static var arduinoEnabled:Boolean = false;
		public static var voiceEnabled:Boolean = false;
		public static var wiimoteEnabled:Boolean = false;
		
		// native accelerometer//////////////////////
		public static var act:Accelerometer; 
		
		// wiimote////////////////////////////////////
		public static var wiimote:Wiimote;
		public static var b_press:Boolean;
		public static var a_press:Boolean;
		public static var c_press:Boolean;
		public static var btn_press_1:Boolean;
		public static var btn_press_2:Boolean;
		public static var btn_press_up:Boolean;
		public static var btn_press_down:Boolean;
		public static var btn_press_left:Boolean;
		public static var btn_press_right:Boolean;
		 
		//arduino//////////////////////////////////////
		
		public static var hitTest3D:Function;
		
		public static var wii_pt:SensorPointObject;
		public static var na_pt:SensorPointObject;
		
		
		// initializes sensorManager
		gw_public static function initialize():void
		{	
			////////////////////////////////////////////////////////////////////////////////////////
			// ref global motion point list
			spoints = GestureGlobals.gw_public::sensorPoints;
			touchObjects = GestureGlobals.gw_public::touchObjects;
			//sw = GestureWorks.application.stageWidth;
			//sh = GestureWorks.application.stageHeight;
			
			// CREATE GLOBAL SENSOR SPRITE TO HANDLE ALL GLOBAL ANALYSIS OF SENSOR POINTS
			gss = new TouchSprite();
				gss.active = true;
				gss.sensorEnabled = true;
				gss.tc.core = true; // fix for global core analysis
				
			GestureGlobals.sensorSpriteID = gss.touchObjectID;

			trace("init sensor manager");
			//////////////////////////////////////////////////////////////////////////////////////
			
			// CALL INIT SENSORS
			initSensors();
		}
			
		public static function initSensors():void
		{
			//INIT NATIVE ACCELEROMTER CONSTRUCTOR ///////////////////////////////////////////////
			if ((nativeAccelEnabled)&&(Accelerometer.isSupported))
			{	
				// create native accel object 
				// can be only one
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
			if (wiimoteEnabled) 
			{	
				// create wii manager
				// will need more than one
				wiimote = new Wiimote();
				wiimote.addEventListener( Event.CONNECT, onWiimoteConnect );
				wiimote.connect();
				if (wiimote) trace("wiimote init", wiimote.id, wiimote.batteryLevel, wiimote.hasBalanceBoard, wiimote.hasClassicController,wiimote.hasNunchuk)
			}
			
			//INIT ARDUINO CONSTRUCTOR /////////////////////////////////////////////////////////////
			if (arduinoEnabled) 
			{
				trace("arduino constructor");
			}
			
			//INIT VOICE CONSTRUCTOR ///////////////////////////////////////////////////////////////
			if (voiceEnabled) 
			{
				trace("voice constructor");
			}
		}
		
		
		////////////////////////////////////////////////////////////////////////////////////////////
		//
		////////////////////////////////////////////////////////////////////////////////////////////
		
		// registers touch point via touchSprite
		public static function registerSensorPoint(spo:SensorPointObject):void
		{
			//spo.history.unshift(SensorPointHistories.historyObject(spo))
		}
		
		
		public static function onSensorBegin(event:GWSensorEvent):void
		{
			//trace("interaction point begin, interactionManager",event.value.interactionPointID);
			
			//NEED IP COUNT FOR ID
			//for each(var tO:Object in touchObjects)
			//{
				// DUPE CORE IP LIST FOR NOW
				// create new interaction point clone for each interactive display object 
				var spO:SensorPointObject = new SensorPointObject();	//event.value.sensorpoint; //
						
						spO.id = gss.sensorPointCount; 
						spO.sensorPointID = event.value.sensorPointID;
						spO.type = event.value.type;
						spO.devicetype = event.value.devicetype;
						
						spO.position = event.value.position;
						spO.direction = event.value.direction;
						spO.normal = event.value.normal;
						spO.length = event.value.length;
						spO.width = event.value.width;
						spO.yaw = event.value.yaw;
						spO.roll = event.value.roll;
						spO.pitch = event.value.pitch;
						
						spO.velocity = event.value.velocity;
						spO.acceleration = event.value.acceleration;
						spO.jolt = event.value.jolt;
						spO.snap = event.value.snap;
						spO.crackle = event.value.crackle;
						spO.pop = event.value.pop;

						spO.phase = "begin";
						
				trace("sensor point begin", spO.type);
						
						
				////////////////////////////////////////////
				//ADD TO GLOBAL Interaction POINT LIST
				gss.cO.sensorArray.push(spO);
				
				//trace("ip begin",ipO.type)
				
				///////////////////////////////////////////////////////////////////
				// ADD TO LOCAL OBJECT Interaction POINT LIST
				for each(var tO:Object in touchObjects)
				{
					//trace("test", tO.sensorClusterMode,tO.tc.ipSupported(ipO.type), ipO.type);
					//NOTE SUPPORT IP TYPES IS ONLY GLOBAL FOR NOW
					//WILL HAVE TO INIT SUPPORTED TYPES FOR EACH VIO
					
					//trace(spO.type, spO.modal_type, spO.input_type)
					
					if (tO.sensorClusterMode == "local_strong")//&&(tO.tc.ipSupported(ipO.type)))
					{
						//var xh:Number = normalize(spO.position.x, minX, maxX) * sw;//tO.stage.stageWidth;//1920
						//var yh:Number = normalize(spO.position.y, minY, maxY) * sh;//tO.stage.stageHeight; //1080
						
						// 2D HIT TEST FOR 2D OBJECT
						if ((tO is TouchSprite)||(tO is TouchMovieClip))//ITouchObject
						{
							//trace("2d hit test");			
							if (tO.hitTestPoint(spO.position.x, spO.position.y, false)) tO.cO.sensorArray.push(spO);
						}			
						//2D HIT TEST ON 3D OBJECT
						if (tO is ITouchObject3D) //ITouchObject //TouchObject3D
						{
							if (hitTest3D != null) {
								//trace("3d hit test"));
							//trace("3d hit test",hitTest3D(tO as ITouchObject3D, tO.view, xh, yh),tO, tO.vto,tO.name, tO.view, tO as ITouchObject3D)
								if (hitTest3D(tO as ITouchObject3D, spO.position.x, spO.position.y)==true) {
									tO.cO.sensorArray.push(spO);								
								}
							}
							

						}
							
					}
				}
				
				
				
				// update local sensor object point count
				gss.sensorPointCount++;

				///////////////////////////////////////////////////////////////////////////
				// ASSIGN POINT OBJECT WITH GLOBAL POINT LIST DICTIONARY
				GestureGlobals.gw_public::sensorPoints[event.value.sensorPointID] = spO;
					
				////////////////////////////////////////////////////////////////////////////
				// REGISTER SENSOR POINT WITH SENSOR MANAGER
				registerSensorPoint(spO);
			//}
			
			//trace("gss sensorpointArray length",gss.cO.sensorPointArray.length,spO.position )
		}
		
		
		public static function onSensorEnd(event:GWSensorEvent):void
		{
			//trace("sensor point end");
			
			var sPID:int = event.value.sensorPointID;
			var spointObject:SensorPointObject = spoints[sPID];
			//trace("sesnor point End, sensorManager", sPID)
			
			if (spointObject)
			{
				spointObject.phase="end"
				
					// REMOVE POINT FROM GLOBAL LIST
					gss.cO.sensorArray.splice(spointObject.id, 1);
					
					// REMOVE FROM LOCAL OBJECTES
					for each(var tO:Object in touchObjects)
					{
						if (tO.sensorClusterMode=="local_strong") tO.cO.sensorArray.splice(spointObject.id, 1);
					}
					
					
					// REDUCE LOACAL POINT COUNT
					gss.sensorPointCount--;
					
					// UPDATE POINT ID 
					for (var i:int = 0; i < gss.cO.sensorArray.length; i++)
					{
						gss.cO.sensorArray[i].id = i;
					}
				
					// DELETE FROM GLOBAL POINT LIST
					delete spoints[event.value.sensorPointID];
			}
			
			//trace("sensor point end",gss.sensorPointCount)
		}
		
		public static function onSensorUpdate(event:GWSensorEvent):void
		{
			
			//SensorPointHistories.historyQueue(event);
			
			//  CONSOLODATED UPDATE METHOD FOR POINT POSITION AND TOUCH OBJECT CALCULATIONS
			var spO:SensorPointObject = spoints[event.value.sensorPointID];
			
			//trace("interaction move event, interactionsManager", event.value.interactionPointID);
			
				if (spO)
				{	
					//trace("sensor point update",spO.type);
					
					//spO = event.value;
					spO.sensorPointID  = event.value.sensorPointID;
					spO.type = event.value.type;
					spO.devicetype = event.value.devicetype;
					
					spO.position = event.value.position;
					spO.direction = event.value.direction;
					spO.normal = event.value.normal;
					spO.velocity = event.value.velocity;
					spO.length = event.value.length;
					spO.width = event.value.width;
					
					spO.yaw = event.value.yaw;
					spO.roll = event.value.roll;
					spO.pitch = event.value.pitch;
					
					spO.acceleration = event.value.acceleration;
					spO.jolt = event.value.jolt;
					spO.snap = event.value.snap;
					spO.crackle = event.value.crackle;
					spO.pop = event.value.pop;
					
					spO.buttons = event.value.buttons;
					
					spO.phase = "update"
					
					if (spO.history.length>1)
					{
						//trace("historyObject",spo.acceleration.x,spo.history[0].acceleration.x,spo.history[1].acceleration.x,spo.history[2].acceleration.x)
						spO.jolt = new Vector3D(spO.acceleration.x - spO.history[1].acceleration.x, spO.acceleration.y - spO.history[1].acceleration.y, spO.acceleration.z - spO.history[1].acceleration.z);
						spO.snap = new Vector3D(spO.jolt.x - spO.history[1].jolt.x, spO.jolt.y - spO.history[1].jolt.y, spO.jolt.z - spO.history[1].jolt.z);
						spO.crackle = new Vector3D(spO.snap.x - spO.history[1].snap.x, spO.snap.y - spO.history[1].snap.y, spO.snap.z- spO.history[1].snap.z);
						spO.pop = new Vector3D(spO.crackle.x - spO.history[1].crackle.x, spO.crackle.y - spO.history[1].crackle.y,spO.crackle.z - spO.history[1].crackle.z);
					}
					
					
					

					//trace("gss sensorpointArray length",gss.cO.sensorPointArray.length,spO.position )
				}
				
				
			// UPDATE POINT HISTORY 
			SensorPointHistories.historyQueue(event);
		}
		
		//////////////////////////////////////////////////////////////////////////////
		//NATIVE ACCELEROMETER HANDLERS
		//////////////////////////////////////////////////////////////////////////////
		public static function onNativeAccelConnect():void
        {
			//CREATE PAIRED SENSOR POINT ONE PER DEVICE FOR SIMPLE DEVICES
				na_pt = new SensorPointObject();
					na_pt.position.x = 500;
					na_pt.position.y = 500;
			
			//dispatch SENSOR POINT ADD
			onSensorBegin(new GWSensorEvent(GWSensorEvent.SENSOR_BEGIN, na_pt, true, false)); // push begin event
        }
		
		public static function accUpdateHandler(event:AccelerometerEvent):void
        {
			//NOTE NEED TO CREATE GLOBAL POINT REFERNCE FOR NAPT
			
			//GET GLOABLLY CONFIGURED SCALING CONSTS
			
			trace("pushing accel data",event.accelerationX, event.accelerationY, event.accelerationZ, event.timestamp)
			 
				na_pt.type = "nativeAccel";
				na_pt.devicetype = "android"
				
				na_pt.position.x += event.accelerationX * 10;
				na_pt.position.y += event.accelerationY * 10;
				//na_pt.position.z += event.accelerationZ * 10;
			
				//na_pt.roll =  wiimote.roll;
				//na_pt.pitch =  wiimote.pitch;
				//na_pt.yaw =  wiimote.yaw;
				
				//na_pt.rotation.x =  wiimote.roll;
				//na_pt.rotation.y =  wiimote.pitch;
				//na_pt.rotation.z =  wiimote.yaw;
				
				na_pt.acceleration.x =  event.accelerationX;
				na_pt.acceleration.y =  event.accelerationY;
				na_pt.acceleration.z =  event.accelerationZ;
				
				na_pt.phase = "update"

			//gss.cO.sensorArray.push(na_pt);
			
			onSensorUpdate(new GWSensorEvent(GWSensorEvent.SENSOR_UPDATE, na_pt, true, false)); //push update event
		}
		
		//////////////////////////////////////////////////////////////////////////////
		//WIIMOTE HANDLERS
		//////////////////////////////////////////////////////////////////////////////
		
		public static function onWiimoteConnect( pEvent:Event ):void
        {
            wiimote.addEventListener(WiimoteEvent.UPDATE, updateWiimote);
			
			// NEED TO CREATE WII POINT MAAGER
			// ONE WII POINT PER DEVICE
			
			// WII DEVICE COUNT
			
			//CREATE PAIRED SENSOR POINT ONE PER DEVICE FOR SIMPLE DEVICES
				wii_pt = new SensorPointObject();
					wii_pt.position.x = 500;
					wii_pt.position.y = 500;
					
				//wiideviceList.push(wii_pt);
			
			//dispatch SENSOR POINT ADD
			onSensorBegin(new GWSensorEvent(GWSensorEvent.SENSOR_BEGIN, wii_pt, true, false)); // push begin event
        }
		
		public static function wiimoteDisconnect( pEvent:Event ):void
        {
			wiimote.close();
			
			// REMOVE POINT FROM WIIMOTE LIST
			
			//GET ASSOCIATED SENSOR POINT ID;
			
			//dispatch SENSOR POINT REMOVE
			//onSensorEnd(new GWSensorEvent(GWSensorEvent.SENSOR_END, sp, true, false));
		}
		
		public static function updateWiimote( pEvent:WiimoteEvent ):void
        {
			//trace("wii update",wiimote.toString());

			//////////////////////////////////////////////////////////
			/// push updated sensor data to 
			// NOTE NEED TO CACHE SENSOR DATA AS FASTER THAN 60FPS
			
			//GET WIIMOTE/WIIPOINT ID
			// GET WII POINT
			//GET GLOABLLY CONFIGURED SCALING CONSTS
			
			//var wii_pt:SensorPointObject = new SensorPointObject();
			
				wii_pt.type = "wiimote";
				wii_pt.devicetype = "controller"
				
				wii_pt.position.x += 1 * wiimote.roll;
				wii_pt.position.y += 1 * wiimote.pitch;
			
				wii_pt.roll =  wiimote.roll;
				wii_pt.pitch =  wiimote.pitch;
				wii_pt.yaw =  wiimote.yaw;
				
				wii_pt.rotation.x =  wiimote.roll;
				wii_pt.rotation.y =  wiimote.pitch;
				wii_pt.rotation.z =  wiimote.yaw;
				
				wii_pt.acceleration.x =  wiimote.sensorX
				wii_pt.acceleration.y =  wiimote.sensorY
				wii_pt.acceleration.z =  wiimote.sensorZ
				
				wii_pt.buttons.a =  wiimote.a;
				wii_pt.buttons.b =  wiimote.b;
				wii_pt.buttons.one =  wiimote.one;
				wii_pt.buttons.two =  wiimote.two;
				
				wii_pt.buttons.plus =  wiimote.plus;
				wii_pt.buttons.minus =  wiimote.minus;
				wii_pt.buttons.home =  wiimote.home;
				wii_pt.buttons.up =  wiimote.up;
				wii_pt.buttons.down =  wiimote.down;
				wii_pt.buttons.left =  wiimote.left;
				wii_pt.buttons.right =  wiimote.right;
				
				if (wiimote.hasNunchuk) 
				{
					wii_pt.buttons.c =  wiimote.nunchuk.c;
					wii_pt.buttons.z =  wiimote.nunchuk.z;
					wii_pt.buttons.stickX = wiimote.nunchuk.stickX;
					wii_pt.buttons.stickY = wiimote.nunchuk.stickY;
					
					//trace("nc", wiimote.nunchuk.sensorX, wiimote.nunchuk.sensorY, wiimote.nunchuk.sensorZ, wiimote.nunchuk.roll, wiimote.nunchuk.yaw, wiimote.nunchuk.pitch);
					//trace("nc", wiimote.nunchuk.stickX, wiimote.nunchuk.stickY)
					//trace("nc", wiimote.nunchuk.c, wiimote.nunchuk.z);
				}
				if (wiimote.hasBalanceBoard) 
				{
					//wii_pt.balanceboad.
					//trace("bb", wiimote.balanceBoard.centerOfGravity,wiimote.balanceBoard.bottomRightKg,wiimote.balanceBoard.bottomLeftKg,wiimote.balanceBoard.topLeftKg,wiimote.balanceBoard.topRightKg,wiimote.balanceBoard.totalKg);
				}
				
			//gss.cO.sensorArray.push(wii_pt); // now pushed by sensor update event dispatch
			//trace(wii_pt.acceleration.x, gss.cO.sensorArray[0].acceleration.x )
			//DISPATCH SENSOR POINT UPDATE//////////////////////////////////////////////////////////////////////
			onSensorUpdate(new GWSensorEvent(GWSensorEvent.SENSOR_UPDATE, wii_pt, true, false)); //push update event
			
        }
		/////////////////////////////////////////////////////////////////////////////////
		/////////////////////////////////////////////////////////////////////////////////
		
	}
}