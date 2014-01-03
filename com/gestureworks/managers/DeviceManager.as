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
	import com.gestureworks.utils.DeviceParser;
	//import com.gestureworks.core.GestureWorks;
	//import com.gestureworks.core.GestureWorksCore;
	import com.gestureworks.core.GestureGlobals;
	import com.gestureworks.core.DML;
	import com.gestureworks.core.*;
	
	import com.gestureworks.managers.DeviceServerManager;
	import com.gestureworks.utils.Simulator;

	
	import flash.ui.Multitouch;
	import flash.ui.MultitouchInputMode;
	

	
	
	public class DeviceManager
	{
		private static var dp:DeviceParser;
		private static var ds:DeviceServerManager;
		
		// initializes deviceManager
		public function initialize():void
		{	
			trace("init device manager");
			//init device parser
			
		}
		
		public static function callDeviceParser():void
		{
			//trace("call gloabal device parser DML");
			dp = new DeviceParser();
			dp.init();
			dp.parseXML();
			configDevices();
		}
		
		public static function configDevices():void
		{
			
			//trace("config devices mode:", dp.mode);
			
			if (dp.mode == "native")
			{
				trace("configuring natively connected devices using dml specs");
				configNativeDevices();
			}
			else if (dp.mode == "server") 
			{
				
				ds = new DeviceServerManager();
					//ds.host = dp.host;
					//ds.port = dp.port;
					ds.init();
					
				trace("configuring server connected devices using dml specs");
				configServerDevices();
			}
		}
		
		public static function configServerDevices():void
		{
			
			// MOTION INIT ////////////////////////////////////
			if (DML.Devices.devices.input_globals.motion.@active == "true") 
			{
				//trace("Motion input devices dml init");
				//GestureWorks.activeMotion = true;
				
				// LEAP MOTION SENSOR INIT //////////////////////////////////
				if (DML.Devices.devices.input_globals.motion.leap.@active == "true")
				{
					GestureWorks.activeMotion = true;
					MotionManager.leapEnabled = true;
			
					if (DML.Devices.devices.input_globals.motion.leap.device[0].@input_mode == "2d") MotionManager.leapmode = "2d_ds";
					if (DML.Devices.devices.input_globals.motion.leap.device[0].@input_mode == "3d") MotionManager.leapmode = "3d_ds"; 
					trace("leapmotion device dml activated");
				}
				
				// SOFTKINECTIC /////////////////////////
				if (DML.Devices.devices.input_globals.motion.sofkinetic.@active == "true")
				{
					//GestureWorks.activeMotion = true;
					//MotionManager.softkinecticEnabled = true;
			
					//if (DML.Devices.devices.input_globals.motion.softkinetic.device[0].@input_mode == "2d") MotionManager.sofkineticmode = "2d"; // no native option
					//if (DML.Devices.devices.input_globals.motion.softkinetic.device[0].@input_mode == "3d") MotionManager.sofkineticmode = "3d"; // no native option
					
					//trace("softkinectic device  dml activated");
				}
				
				
				// PMD //////////////////////////////////
				// STRUCTURE ////////////////////////////
				// KINECT ///////////////////////////////
				// XITION ///////////////////////////////
				
				MotionManager.gw_public::initialize();
				InteractionManager.gw_public::initialize();
			}
			
		}
		
		
		public static function configNativeDevices():void
		{	
			// NOTE WILL USE DEVICE LIST FOR THIS BUT FOR NOW ACESSING RAW XML STATE
		
			///////////////////////////////////////////////////////////////////////
			//TOUCH INIT //////////////////////////////////////////////////////////
			if (DML.Devices.devices.input_globals.touch.@active == "true") 
			{
				//trace("touch input devices", DML.Devices.devices.input_globals.touch.screen.@active );
				
				if (DML.Devices.devices.input_globals.touch.screen.@active == "true")
				{
					// NATIVE TOUCH DATA
					if (DML.Devices.devices.input_globals.touch.screen.device[0].@input_mode == "native")
					{
						GestureWorks.activeNativeTouch = true;
						Multitouch.inputMode = MultitouchInputMode.TOUCH_POINT;	
						trace("native touch screen dml activated");
					}
					// TUIO TOUCH DATA
					if (DML.Devices.devices.input_globals.touch.screen.device[0].@input_mode == "tuio")
					{
						GestureWorks.activeTUIO = true;
						Multitouch.inputMode = MultitouchInputMode.TOUCH_POINT;	
						trace("tuio touch screen dml activated");
					}
					// SIMULATOR TOUCH DATA
					if (DML.Devices.devices.input_globals.touch.screen.device[0].@input_mode == "sim")
					{
						GestureWorks.activeSim = true;
						//Multitouch.inputMode = MultitouchInputMode.TOUCH_POINT;	
						trace("mouse touch simulator dml activated");
						Simulator.gw_public::initialize();
					}
				}
				TouchManager.gw_public::initialize();
			}
			
			
			
			
			////////////////////////////////////////////////////////////////////////////////////////////
			// MOTION INIT ////////////////////////////////////
			if (DML.Devices.devices.input_globals.motion.@active == "true") 
			{
				//trace("Motion input devices dml init");
				
				// LEAP MOTION SENSOR INIT //////////////////////////////////
				if (DML.Devices.devices.input_globals.motion.leap.@active == "true")
				{
					GestureWorks.activeMotion = true;
					MotionManager.leapEnabled = true;
					if (DML.Devices.devices.input_globals.motion.leap.device[0].@input_mode == "2d") MotionManager.leapmode = "2d";
					if (DML.Devices.devices.input_globals.motion.leap.device[0].@input_mode == "3d") MotionManager.leapmode = "3d";
					trace("LeapMotion device dml activated");
				}
				
				// KINECT ///////////////////////////////
				// SOFTKINECTIC /////////////////////////
				// PMD //////////////////////////////////
				// STRUCTURE ////////////////////////////
				// XITION ///////////////////////////////
				
				MotionManager.gw_public::initialize();
			}
			
			///////////////////////////////////////////////////////////////////////////////////////////
			//SENSORS INIT /////////////////////////////////////
			if (DML.Devices.devices.input_globals.sensor.@active == "true") 
			{
				//trace("Sensor input devices dml init");
				
				// NATIVE ACCELEROMETER	INIT//////////////////
				if (DML.Devices.devices.input_globals.sensor.android.@active == "true")
				{
					//trace("android active",DML.Devices.devices.input_globals.sensor.android.device[0].@input_type)
					if (DML.Devices.devices.input_globals.sensor.android.device[0].@input_type == "native_accelerometer")
					{
						GestureWorks.activeSensor = true;
						SensorManager.nativeAccelEnabled = true;
						trace("Android/IOS native accel device dml activated");
					}
				}
				// WIIMOTE INIT////////////////////////////
				if (DML.Devices.devices.input_globals.sensor.wiimote.@active == "true")
				{
					GestureWorks.activeSensor = true;
					SensorManager.wiimoteEnabled = true;
					trace("Wiimote device dml activated");
				}
				// ARDUINO INIT///////////////////////////////
				if (DML.Devices.devices.input_globals.sensor.arduino.@active == "true")
				{
					GestureWorks.activeSensor = true;
					SensorManager.arduinoEnabled = true;
					trace("Arduino device dml activated");
				}
				// VOICE INIT ////////////////////////////
				if (DML.Devices.devices.input_globals.sensor.voice.@active == "true")
				{
					GestureWorks.activeSensor = true;
					SensorManager.voiceEnabled = true;
					trace("M$ voice device dml activated");
				}
				

				// INIT SENSOR MANAGER WITH SENSOR TYPES ACTIVATED
				// NEEDS TO BE LAST
				SensorManager.gw_public::initialize();
			}
		}

	}
}