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
	
	import com.gestureworks.core.GestureGlobals;
	import com.gestureworks.core.DML;
	import com.gestureworks.core.*;
	import com.gestureworks.managers.DeviceServerManager;
	import com.gestureworks.utils.Simulator;
	import com.gestureworks.utils.DeviceParser;
	
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
			
			trace("config devices mode:", dp.mode);
			
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
			// TOUCH INIT /////////////////////////////////////////////////////////////////////////////
			if (DML.Devices.devices.input_globals.touch.@active == "true") 
			{
				trace("dml activated touch")
				GestureWorks.activeTouch = true;

				//PQ SERVER/////////////////////////////////////////////////////////////
				if (DML.Devices.devices.input_globals.touch.pq.@active == "true")
				{
					if (DML.Devices.devices.input_globals.touch.pq.device[0].attributes.@input_type == "Points2d")
					{
						trace("PQ server touch device dml activated");
					}
				}
				
				//3M SERVER/////////////////////////////////////////////////////////////
				if (DML.Devices.devices.input_globals.touch.mmm.@active == "true")
				{
					if (DML.Devices.devices.input_globals.touch.mmm.device[0].attributes.@input_type == "Points2d")
					{
						trace("3M server touch device dml activated");
					}
				}
				
				//ZYTRONIC SERVER/////////////////////////////////////////////////////////////
				if (DML.Devices.devices.input_globals.touch.zytronic.@active == "true")
				{
					if (DML.Devices.devices.input_globals.touch.zytronic.device[0].attributes.@input_type == "Points2d")
					{
						trace("Zytronic server touch device dml activated");
					}
				}

				//ANDROID/////////////////////////////////////////////////////////////
				if (DML.Devices.devices.input_globals.touch.android.@active == "true")
				{
					if (DML.Devices.devices.input_globals.touch.android.device[0].attributes.@input_type == "Points2d")
					{
						trace("Android/IOS touch device dml activated");
					}
				}

				TouchManager.gw_public::initialize();	
			}
			
			////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
			// MOTION INIT /////////////////////////////////////////////////////////////////////////////////////////////////////////////
			////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
			if (DML.Devices.devices.input_globals.motion.@active == "true") 
			{
				trace("Motion input devices dml init");
				GestureWorks.activeMotion = true;
				
				// LEAP MOTION SENSOR INIT //////////////////////////////////
				if (DML.Devices.devices.input_globals.motion.leap.@active == "true")
				{
					MotionManager.leapEnabled = true;
					if (DML.Devices.devices.input_globals.motion.leap.device[0].attributes.@input_mode == "2d") MotionManager.leapmode = "2d_ds";
					if (DML.Devices.devices.input_globals.motion.leap.device[0].attributes.@input_mode == "3d") MotionManager.leapmode = "3d_ds"; 
					trace("leapmotion device dml activated");
				}
				
				// SOFTKINECTIC /////////////////////////
				if (DML.Devices.devices.input_globals.motion.sofkinetic.@active == "true")
				{
					//MotionManager.softkinecticEnabled = true;
					//if (DML.Devices.devices.input_globals.motion.softkinetic.device[0].@input_mode == "2d") MotionManager.sofkineticmode = "2d"; // no native option
					//if (DML.Devices.devices.input_globals.motion.softkinetic.device[0].@input_mode == "3d") MotionManager.sofkineticmode = "3d"; // no native option
					//trace("softkinectic device  dml activated");
				}
				//CREATIVE///////////////////////////////
				if (DML.Devices.devices.input_globals.motion.creative.@active == "true")
				{
					//MotionManager.creativeEnabled = true;
					//if (DML.Devices.devices.input_globals.motion.creative.device[0].@input_mode == "2d") MotionManager.creativemode = "2d"; // no native option
					//if (DML.Devices.devices.input_globals.motion.creative.device[0].@input_mode == "3d") MotionManager.creativemode = "3d"; // no native option
					//trace("softkinectic device  dml activated");
				}
				// KINECT ///////////////////////////////
				// XITION ///////////////////////////////
				// PMD //////////////////////////////////
				// STRUCTURE ////////////////////////////
				
				//EYETRIBE
				if (DML.Devices.devices.input_globals.motion.eyetribe.@active == "true")
				{
					//MotionManager.eyetribeEnabled = true;
					//if (DML.Devices.devices.input_globals.motion.eyetribe.device[0].attributes.@input_mode == "2d") MotionManager.eyetribemode = "2d";
					//if (DML.Devices.devices.input_globals.motion.eyetribe.device[0].attributes.@input_mode == "3d") MotionManager.eyetribemode = "3d";
					
					trace("Eyetribe device dml activated");
				}
				//TOBII
				if (DML.Devices.devices.input_globals.motion.tobii.@active == "true")
				{
					//MotionManager.tobiiEnabled = true;
					//if (DML.Devices.devices.input_globals.motion.tobii.device[0].attributes.@input_mode == "2d") MotionManager.tobiimode = "2d";
					//if (DML.Devices.devices.input_globals.motion.tobii.device[0].attributes.@input_mode == "3d") MotionManager.tobiimode = "3d";
					
					trace("Eyetribe device dml activated");
				}
				MotionManager.gw_public::initialize();
			}
			
			///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
			// SENSOR INIT ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
			///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
			if (DML.Devices.devices.input_globals.sensor.@active == "true") 
			{
				trace("Sensor input devices dml init");
				GestureWorks.activeSensor = true;
				
				// NATIVE ACCELEROMETER	INIT//////////////////
				if (DML.Devices.devices.input_globals.sensor.android.@active == "true")
				{
					if (DML.Devices.devices.input_globals.sensor.android.device[0].attributes.@input_type == "accelerometer")
					{
						//SensorManager.accelEnabled = true;
						trace("Android/IOS accel device dml activated");
					}
				}
				// WIIMOTE INIT////////////////////////////
				if (DML.Devices.devices.input_globals.sensor.controller.@active == "true")
				{
					SensorManager.controllerEnabled = true;
					trace("Wiimote controller device dml activated");
				}
				// ARDUINO INIT///////////////////////////////
				if (DML.Devices.devices.input_globals.sensor.arduino.@active == "true")
				{
					SensorManager.arduinoEnabled = true;
					trace("Arduino device dml activated");
				}
				// VOICE INIT ////////////////////////////
				if (DML.Devices.devices.input_globals.sensor.voice.@active == "true")
				{
					SensorManager.voiceEnabled = true;
					trace("M$ voice device dml activated");
				}
				// INIT SENSOR MANAGER WITH SENSOR TYPES ACTIVATED
				// NEEDS TO BE LAST
				SensorManager.gw_public::initialize();
			}
		}
		
		
		public static function configNativeDevices():void
		{	
			// NOTE WILL USE DEVICE LIST FOR THIS BUT FOR NOW ACESSING RAW XML STATE
		
			///////////////////////////////////////////////////////////////////////
			//TOUCH INIT //////////////////////////////////////////////////////////
			if (DML.Devices.devices.input_globals.touch.@active == "true") 
			{
				trace("dml init native touch input devices ()");
				//GestureWorks.activeTouch = true;
				
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
				trace("touch manager init via dml")
				//InteractionManager.gw_public::initialize(); when interaction points are created from raw touch
				// still workin on refactor
			}
			
			////////////////////////////////////////////////////////////////////////////////////////////
			// MOTION INIT ////////////////////////////////////
			if (DML.Devices.devices.input_globals.motion.@active == "true") 
			{
				trace("dml init native Motion input devices (leap)");
				
				// LEAP MOTION SENSOR INIT //////////////////////////////////
				if (DML.Devices.devices.input_globals.motion.leap.@active == "true")
				{
					GestureWorks.activeMotion = true;
					MotionManager.leapEnabled = true;
					
					if (DML.Devices.devices.input_globals.motion.leap.device[0].attributes.@input_mode == "2d") MotionManager.leapmode = "2d";
					if (DML.Devices.devices.input_globals.motion.leap.device[0].attributes.@input_mode == "3d") MotionManager.leapmode = "3d";
					
					trace("LeapMotion device dml activated");
				}
				MotionManager.gw_public::initialize();
				trace("motion manager init via dml");
				//InteractionManager.gw_public::initialize();
			}
			
			///////////////////////////////////////////////////////////////////////////////////////////
			//SENSORS INIT ///////////////////////////////////////////////////////////////////////////
			if (DML.Devices.devices.input_globals.sensor.@active == "true") 
			{
				trace("dml init native Sensor input devices (accelerometer)");
				GestureWorks.activeSensor = true;
				
				// NATIVE ACCELEROMETER	INIT//////////////////
				if (DML.Devices.devices.input_globals.sensor.android.@active == "true")
				{
					//trace("android active",DML.Devices.devices.input_globals.sensor.android.device[0].@input_type)
					if (DML.Devices.devices.input_globals.sensor.android.device[0].attributes.@input_type == "native_accelerometer")
					{
						SensorManager.nativeAccelEnabled = true;
						trace("Android/IOS native accel device dml activated");
					}
				}
				// INIT SENSOR MANAGER WITH SENSOR TYPES ACTIVATED
				// NEEDS TO BE LAST
				SensorManager.gw_public::initialize();
			}
		}

	}
}