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
	import flash.sensors.Accelerometer;
	import flash.utils.Dictionary;
	import flash.events.TouchEvent;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import flash.system.System;
	
	import com.gestureworks.core.GestureWorks;
	import com.gestureworks.core.GestureWorksCore;
	import com.gestureworks.core.GestureGlobals;
	import com.gestureworks.core.gw_public;
	import com.gestureworks.core.GML;
	
	//import com.gestureworks.utils.ArrangePoints;
	//import com.gestureworks.managers.PointHistories;
	//import com.gestureworks.events.GWEvent;
	
	//import com.gestureworks.objects.PointObject;
	//import com.gestureworks.objects.TouchObject;
	//import com.gestureworks.managers.PointHistories;
	//import com.gestureworks.utils.Simulator;
	
	// accelerometer
	import flash.events.AccelerometerEvent;
    import flash.sensors.Accelerometer;
	
	//wiimote
	import org.wiiflash.Wiimote;
    import org.wiiflash.events.*;
	
	//myo
	
	
	
	import com.gestureworks.core.TouchSprite;
	
	public class SensorManager
	{	
		public static var ms:TouchSprite;
		public static var nativeAccelEnabled:Boolean = false;
		public static var arduinoEnabled:Boolean = false;
		public static var voiceEnabled:Boolean = false;
		public static var wiimoteEnabled:Boolean = false;
		
		public static var wii_pt:SensorPointObject;
		public static var na_pt:SensorPointObject;
		
		public static var spoints:Dictionary = new Dictionary();
		public static var touchObjects:Dictionary = new Dictionary();
		public static var gss:*
		
		
		public static var act:Accelerometer; 
		
		
		
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
		 
		
		// initializes sensorManager
		gw_public static function initialize():void
		{	
			trace("init sensor manager");
			
			//INIT NATIVE ACCELEROMTER CONSTRUCTOR
			if (nativeAccelEnabled)
			{
				if (Accelerometer.isSupported)
				{
					// create native accel object // can be only one
					trace("native accelerometer manager init")
					act = new Accelerometer();
					// GET DEVICE CONFIG DATA FROM DEVICE LIST OBJECT FROM DML
					// if(updateinterval) 
					// else set interval to framerate
					act.setRequestedUpdateInterval((1/60)*1000);// miliseconds
					act.addEventListener(AccelerometerEvent.UPDATE, accUpdateHandler);
					if (act) trace("native accel init")
					
					
					na_pt = new SensorPointObject();
						na_pt.position.x = 500;
						na_pt.position.y = 500;
				}
			}
			
			//INIT WIIMOTE CONSTRUCTOR
			if (wiimoteEnabled) 
			{	
				// create wii manager
				wiimote = new Wiimote();
				wiimote.addEventListener( Event.CONNECT, onWiimoteConnect );
				wiimote.connect();
				if (wiimote) trace("wiimote init", wiimote.id, wiimote.batteryLevel, wiimote.hasBalanceBoard, wiimote.hasClassicController,wiimote.hasNunchuk)
			
				//CREATE PAIRED SENSOR POINT ONE PER DEVICE FOR SIMPLE DEVICES
				wii_pt = new SensorPointObject();
					wii_pt.position.x = 500;
					wii_pt.position.y = 500;
					
			
			}
			//INIT ARDUINO CONSTRUCTOR
			if (arduinoEnabled) 
			{
				trace("arduino constructor")
			}
			
			//INIT VOICE CONSTRUCTOR
			if (voiceEnabled) 
			{
				trace("voice constructor")
			}
				
			///////////////////////////////////////////////////////////////////////////////////////
			// ref global motion point list
			spoints = GestureGlobals.gw_public::sensorPoints;
			touchObjects = GestureGlobals.gw_public::touchObjects;
			
			// CREATE GLOBAL SENSOR SPRITE TO HANDLE ALL GLOBAL ANALYSIS OF SENSOR POINTS
			gss = new TouchSprite();
				gss.active = true;
				gss.sensorEnabled = true;
				gss.tc.core = true; // fix for global core analysis
				
			GestureGlobals.sensorSpriteID = gss.touchObjectID;
		}
		
		//////////////////////////////////////////////////////////////////////////////
		//
		//////////////////////////////////////////////////////////////////////////////
		public static function accUpdateHandler(event:AccelerometerEvent):void
        {
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

			gss.cO.sensorArray[1] = na_pt;
            
		}
		
		//////////////////////////////////////////////////////////////////////////////
		//
		//////////////////////////////////////////////////////////////////////////////
		
		public static function onWiimoteConnect( pEvent:Event ):void
        {
            wiimote.addEventListener(WiimoteEvent.UPDATE, updateWiimote);  
			
			// buttons
			//wiimote.addEventListener(ButtonEvent.C_PRESS, c_buttonPressed);       
            //wiimote.addEventListener(ButtonEvent.C_RELEASE, c_buttonReleased);  
           // wiimote.addEventListener(ButtonEvent.B_PRESS, b_buttonPressed);       
           // wiimote.addEventListener(ButtonEvent.B_RELEASE, b_buttonReleased);  
			//wiimote.addEventListener(ButtonEvent.A_PRESS, a_buttonPressed);       
            //wiimote.addEventListener(ButtonEvent.A_RELEASE, a_buttonReleased); 
			
			//wiimote.addEventListener(ButtonEvent.ONE_PRESS, one_buttonPressed); 
			//wiimote.addEventListener(ButtonEvent.ONE_PRESS, one_buttonReleased); 
			//wiimote.addEventListener(ButtonEvent.TWO_PRESS, two_buttonPressed); 
			//wiimote.addEventListener(ButtonEvent.TWO_PRESS, two_buttonReleased);
			
			//wiimote.addEventListener(ButtonEvent.PLUS_PRESS, plus_buttonPressed); 
			//wiimote.addEventListener(ButtonEvent.PLUS_PRESS, plus_buttonReleased);
			//wiimote.addEventListener(ButtonEvent.MINUS_PRESS, minus_buttonPressed); 
			//wiimote.addEventListener(ButtonEvent.MINUS_PRESS, minus_buttonReleased);
			
			//wiimote.addEventListener(ButtonEvent.UP_PRESS, up_buttonPressed); 
			//wiimote.addEventListener(ButtonEvent.UP_PRESS, up_buttonReleased); 
			//wiimote.addEventListener(ButtonEvent.DOWN_PRESS, down_buttonPressed); 
			//wiimote.addEventListener(ButtonEvent.DOWN_PRESS, down_buttonReleased);
			//wiimote.addEventListener(ButtonEvent.LEFT_PRESS, left_buttonPressed); 
			//wiimote.addEventListener(ButtonEvent.LEFT_PRESS, left_buttonReleased);
			//wiimote.addEventListener(ButtonEvent.RIGHT_PRESS, right_buttonPressed); 
			//wiimote.addEventListener(ButtonEvent.RIGHT_PRESS, right_buttonReleased);
			
			///////////////////////////////////////////////////////////////////////////
			// nunchuck
			if (wiimote.hasNunchuk) 
			{
				trace(wiimote.balanceBoard)
				//wiimote.addEventListener( WiimoteEvent.NUNCHUK_CONNECT, onNunchukConnected ); 
				//wiimote.addEventListener( WiimoteEvent.NUNCHUK_DISCONNECT, onNunchukDisconnected );
			}
			
			
			///////////////////////////////////////////////////////////////////////////
			//balance board
			if (wiimote.hasBalanceBoard) 
			{
				trace(wiimote.balanceBoard);
				//wiimote.addEventListener( WiimoteEvent.BalanceBoard_CONNECT, onBalanceBoardConnected );
				//wiimote.addEventListener( WiimoteEvent.BalanceBoard_DISCONNECT, onBalanceBoardDisconnected );
			}
			
			////////////////////////////////////////////////////////////////////////////
			//classic controller
			if (wiimote.hasClassicController) 
			{
				trace(wiimote.classicController);
				//wiimote.addEventListener( WiimoteEvent.CONTROLLER_CONNECT, onClassicControllerConnected );
				//wiimote.addEventListener( WiimoteEvent.CONTROLLER_DISCONNECT, onClassicControllerDisconnected );
			}
			
        }
		
		public static function wiimoteDisconnect( pEvent:Event ):void
        {
				wiimote.close();
		}
		
		public static function updateWiimote( pEvent:WiimoteEvent ):void
        {
			//trace("wii update",wiimote.toString());
			//trace("wii update", wiimote.sensorX, wiimote.sensorY, wiimote.sensorZ, wiimote.roll, wiimote.pitch, wiimote.yaw);

				//if (b_press)
				//{
				  //ts.x += 10 //* wiimote.sensorX;
				 // ts.y += 10 //* wiimote.sensorY;
				  //ts.rotation += wiimote.pitch;//wiimote.sensorZ//
				//}
				
				if (wiimote.hasNunchuk) 
				{
					//trace("nc", wiimote.nunchuk.sensorX, wiimote.nunchuk.sensorY, wiimote.nunchuk.sensorZ, wiimote.nunchuk.roll, wiimote.nunchuk.yaw, wiimote.nunchuk.pitch);
					//trace("nc", wiimote.nunchuk.stickX, wiimote.nunchuk.stickY)
					//trace("nc", wiimote.nunchuk.c, wiimote.nunchuk.z);
				}
				
				if (wiimote.hasBalanceBoard) 
				{
					//trace("bb", wiimote.balanceBoard.centerOfGravity,wiimote.balanceBoard.bottomRightKg,wiimote.balanceBoard.bottomLeftKg,wiimote.balanceBoard.topLeftKg,wiimote.balanceBoard.topRightKg,wiimote.balanceBoard.totalKg);
				}
				
			//////////////////////////////////////////////////////////
			/// push updated sensor data to 
			// NOTE NEED TO CACHE SENSOR DATA AS FASTER THAN 60FPS
			
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
				}
				
			gss.cO.sensorArray[0] = wii_pt;
			
			//trace(wii_pt.acceleration.x, gss.cO.sensorArray[0].acceleration.x )
        }
         
        public static function b_buttonPressed( pEvent:ButtonEvent ):void
        {
			//trace("b button press")
			b_press = true;
        }
         
        public static function b_buttonReleased( pEvent:ButtonEvent ):void
        {
			//trace("b button release");
			b_press = false;
        } 
		
		 public static function a_buttonPressed( pEvent:ButtonEvent ):void
        {
			//trace("a button press")
			a_press = true;
        }
         
        public static function a_buttonReleased( pEvent:ButtonEvent ):void
        {
			//trace("a button release");
			a_press = false;
        } 
		/////////////////////////////////////////////////////////////////////////////////
		/////////////////////////////////////////////////////////////////////////////////
		
	}
}