////////////////////////////////////////////////////////////////////////////////
//
//  IDEUM
//  Copyright 2011-2012 Ideum
//  All Rights Reserved.
//
//  GestureWorks
//
//  File:    DeviceParser.as
//  Authors:  Ideum
//             
//  NOTICE: Ideum permits you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////
package com.gestureworks.utils
{
	import flash.geom.Point;
	
	import com.gestureworks.core.GestureWorks;
	import com.gestureworks.core.GestureGlobals;
	import com.gestureworks.core.gw_public;
	import com.gestureworks.core.DML;

	
	import com.gestureworks.objects.DeviceObject;
	//import com.gestureworks.objects.GestureListObject;
	
	public class DeviceParser
	{
		//public var gOList:GestureListObject;
		public static var  deviceList:Vector.<DeviceObject>
		public static var  deviceTypeList:Object; 
		public static var  dml:XMLList;
		
		public var host:String;
		public var port:int;
		public var protocol:String;
		public var mode:String
		
		public function DeviceParser():void
		{
			init();
        }
		
		public function init():void 
         {
		 //ID = touchSpriteID;
		 //trace("init device parser");
		 }
		
		/////////////////////////////////////////////////////////////////////
		// DML
		/////////////////////////////////////////////////////////////////////
		public function parseXML():void 
         {
			//trace("parsing dml");
			dml = new XMLList(DML.Devices);
			trace(dml)
			
			deviceTypeList = { 
							"wiimote":true, 
							"kinect":true, 
							"accelerometer":true, 
							"arduino":true,
							"tobii":true,
							"eyetribe":true,
							"android":true
							};	
							
						deviceList = new Vector.<DeviceObject>();

							var deviceGroupNum:int = dml.devices.input_globals.length();
							
							host = String(dml.devices.@host);
							port = int(dml.devices.@port);
							mode = String (dml.devices.@mode);
							protocol = String(dml.devices.@protcol);
							
							
							//trace("device group num",deviceGroupNum)

							for (var i:int = 0; i < deviceGroupNum; i++) 
							{
								
								var touch_deviceNum:int = dml.devices.input_globals[i].touch.length();
								var motion_deviceNum:int = dml.devices.input_globals[i].motion.length();
								var sensor_deviceNum:int = dml.devices.input_globals[i].sensor.length();
								
								//trace("device type",touch_deviceNum,motion_deviceNum, sensor_deviceNum )
								
								// SENSORS////////////////////////////////////////////////////////////////////////////////
								for (var j:int = 0; j < sensor_deviceNum; j++) 
								{
									var sensor_typeNum:int = dml.devices.input_globals[i].sensor[j].wii.length;
									
									for (var k:int = 0; k < sensor_typeNum; k++) 
										{
				
										var device:DeviceObject = new DeviceObject();
											device.type = "wiimote";
											//device.input_type = "sensor";
											device.active =  dml.devices.input_globals[i].motion[j].wii[k].attribute("active");
											device.id = dml.devices.input_globals[i].motion[j].wii[k].attribute("id");
											//device.controller = dml.devices.input_globals[i].motion[j].wii[k].attribute("controller");
											//device.nunchk = dml.devices.input_globals[i].motion[j].wii[k].attribute("nunchuk");
											//device.balanceboard = dml.devices.input_globals[i].motion[j].wii[k].attribute("balanceboad");
											
										deviceList.push(device);
										}
								}
							}
				
				traceDeviceList();
		}
		////////////////////////////////////////////////////////////////////////////
		
		public static function traceDeviceList():void
		{
			//trace("new display object created in gesture parser util");
			var dn:uint = 0//deviceList.length;
			
			for (var i:uint = 0; i < dn; i++ )
				{
					trace("	new device object:--------------------------------");
						//trace("d xml....."+"\n", gOList.pOList[i].gesture_xml)
						trace(deviceList[i].type);
				}
				//trace("gesture object parsing complete");
		}
	}
}