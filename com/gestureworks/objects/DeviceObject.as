////////////////////////////////////////////////////////////////////////////////
//
//  IDEUM
//  Copyright 2011-2012 Ideum
//  All Rights Reserved.
//
//  GestureWorks
//
//  File:    DeviceObject.as
//  Authors:  Ideum
//             
//  NOTICE: Ideum permits you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////
package com.gestureworks.objects 
{
	
	public class DeviceObject extends Object 
	{
		// device id
		public var id:String;
		
		// active
		public var active:Boolean = false;

		// device xml block
		public var xml:XML;
		
		// input device type
		public var type:String;
		
		// device type
		public var device_type:String;
		
		// device mode
		public var mode:String;
		
		// device input mode
		public var input_mode:String;
		
		// resolution
		public var screen_resolution:Number = 0;
		
		// refreshrate
		public var refresh_rate:Number = 0;
		
		// palm_rejection active
		public var palm_rejection:Boolean = false;

		// getblocbdata
		public var blob_data:Boolean = false;
		
		// window min max
		public var window_xmin:Number = 0;
		public var window_xmax:Number = 0;
		public var window_ymin:Number = 0;
		public var window_ymax:Number = 0;
		
		// normalize motion data
		public var normalize:Boolean = false;
		// min max raw data
		public var xmax:Number = 0;
		public var xmin:Number = 0;
		public var ymax:Number = 0;
		public var ymin:Number = 0;
		public var zmax:Number = 0;
		public var zmin:Number = 0;
		
		
		
		

		

		
		// data object
		public var data:Object = new Object();

	}
}