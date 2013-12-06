﻿////////////////////////////////////////////////////////////////////////////////
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
	
	import com.gestureworks.utils.ArrangePoints;
	import com.gestureworks.managers.PointHistories;
	import com.gestureworks.events.GWEvent;
	
	import com.gestureworks.objects.PointObject;
	import com.gestureworks.objects.TouchObject;
	import com.gestureworks.managers.PointHistories;
	import com.gestureworks.utils.Simulator;
	
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
		public static var nativeAccelerometerEnabled:Boolean = false;
		public static var wiimoteEnabled:Boolean = false;
		
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
			
			if (nativeAccelerometerEnabled)
			{
				if (Accelerometer.isSupported)
				{
					trace("accelerometer manager init")
					act = new Accelerometer();
					act.addEventListener(AccelerometerEvent.UPDATE, accUpdateHandler);
				}
			}
			
			if (wiimoteEnabled) 
			{	
				// create wii manager
				wiimote = new Wiimote();
				wiimote.addEventListener( Event.CONNECT, onWiimoteConnect );
				wiimote.connect();
				if (wiimote) trace("wiimote init", wiimote.id, wiimote.batteryLevel, wiimote.hasBalanceBoard, wiimote.hasClassicController,wiimote.hasNunchuk)
			}
		
				// create gloabal sensor sprite
				ms = new TouchSprite();
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
            wiimote.addEventListener(ButtonEvent.B_PRESS, b_buttonPressed);       
            wiimote.addEventListener(ButtonEvent.B_RELEASE, b_buttonReleased);  
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
			trace("wii update", wiimote.sensorX, wiimote.sensorY, wiimote.sensorZ, wiimote.roll, wiimote.pitch, wiimote.yaw);

				//if (b_press)
				//{
				  //ts.x += 10 //* wiimote.sensorX;
				 // ts.y += 10 //* wiimote.sensorY;
				  //ts.rotation += wiimote.pitch;//wiimote.sensorZ//
				//}
				
				if (wiimote.hasNunchuk) 
				{
					trace("nc", wiimote.nunchuk.sensorX, wiimote.nunchuk.sensorY, wiimote.nunchuk.sensorZ, wiimote.nunchuk.roll, wiimote.nunchuk.yaw, wiimote.nunchuk.pitch);
					trace("nc", wiimote.nunchuk.stickX, wiimote.nunchuk.stickY)
					trace("nc", wiimote.nunchuk.c, wiimote.nunchuk.z);
				}
				
				if (wiimote.hasBalanceBoard) 
				{
					trace("bb", wiimote.balanceBoard.centerOfGravity,wiimote.balanceBoard.bottomRightKg,wiimote.balanceBoard.bottomLeftKg,wiimote.balanceBoard.topLeftKg,wiimote.balanceBoard.topRightKg,wiimote.balanceBoard.totalKg);
				}
				
        }
         
        public static function b_buttonPressed( pEvent:ButtonEvent ):void
        {
			trace("b button press")
			b_press = true;
        }
         
        public static function b_buttonReleased( pEvent:ButtonEvent ):void
        {
			trace("b button release");
			b_press = false;
        } 
		
		 public static function a_buttonPressed( pEvent:ButtonEvent ):void
        {
			trace("a button press")
			a_press = true;
        }
         
        public static function a_buttonReleased( pEvent:ButtonEvent ):void
        {
			trace("a button release");
			a_press = false;
        } 
		/////////////////////////////////////////////////////////////////////////////////
		/////////////////////////////////////////////////////////////////////////////////
		
		
		public static function accUpdateHandler(event:AccelerometerEvent):void
        {
			//trace("pushing accel data")
			
			var act_vector:Vector.<Number> = new Vector.<Number>
				act_vector[0] = event.timestamp;
				act_vector[1] = event.accelerationX;
				act_vector[2] = event.accelerationY;
				act_vector[3] = event.accelerationZ;
				
			//push sensor data to cluster object
			ms.cO.sensorArray = act_vector	
			// update cluster analysis
			//ms.updateSensorClusterAnalysis()
        }
		
	}
}