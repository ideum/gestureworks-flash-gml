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
	
	public class DeviceManager
	{
		private static var dp:DeviceParser;
			
		
		// initializes deviceManager
		public function initialize():void
		{	
			trace("init device manager");
			//init device parser
			
		}
		
		public static function callDeviceParser():void
		{
			trace("call gloabal device parser ");
			dp = new DeviceParser();
			dp.init();
			dp.parseXML();
			configDevices();
		}
		
		public static function configDevices():void
		{	
		
			// MOTION INIT
			//if (DML.Devices.motion.@active == "true") 
			//{
				//trace(" Motion input devices",DML.Devices.devices.input_globals);
			//}
			
			//SENSOR INIT /////////////////////////////////////
			if (DML.Devices.devices.input_globals.sensor.@active == "true") 
			{
				trace("Sensor input devices active");
				
				// wiimote init
				if (DML.Devices.devices.input_globals.sensor.wiimote.@active == "true")
				{
					GestureWorksCore.wiimote = true;
					trace("wiimote active");
				}
				
				// NATIVE ACCELEROMETER	
				// VOICE INIT
				// KINECT
				// ARDUINO
				
				GestureWorksCore.sensor = true;  // needs to be last
			}
		}

	}
}