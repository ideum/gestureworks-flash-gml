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
	import com.leapmotion.leap.events.LeapEvent;
	import com.leapmotion.leap.LeapMotion;
	
		import com.leapmotion.leap.*;
	import com.leapmotion.leap.events.*;
	import com.leapmotion.leap.util.*;
	
	
	
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
	
	import com.gestureworks.objects.ClusterObject;
	//import com.gestureworks.core.MotionSprite;
	import com.gestureworks.core.TouchSprite;
	
	public class MotionManager
	{	
		public static var leap:LeapMotion;
		public static var ms:TouchSprite;
		
		gw_public static function initialize():void
		{			
			trace("motion manager init")
			
			leap = new LeapMotion(); 
			leap.controller.addEventListener( LeapEvent.LEAPMOTION_INIT, onInit );
			leap.controller.addEventListener( LeapEvent.LEAPMOTION_CONNECTED, onConnect );
			leap.controller.addEventListener( LeapEvent.LEAPMOTION_DISCONNECTED, onDisconnect );
			leap.controller.addEventListener( LeapEvent.LEAPMOTION_EXIT, onExit );
			leap.controller.addEventListener( LeapEvent.LEAPMOTION_FRAME, onFrame );
			
			// create gloabal motion sprite
			ms = new TouchSprite();
		}
		
		public static function onInit( event:LeapEvent ):void
		{
			trace( "Leap Initialized" );
		}

		public static function onConnect( event:LeapEvent ):void
		{
			trace( "Leap Connected" );
		}

		public static function onDisconnect( event:LeapEvent ):void
		{
			trace( "Leap Disconnected" );
		}

		public static function onExit( event:LeapEvent ):void
		{
			trace( "Leap Exited" );
		}
		
		public static function onFrame(event:LeapEvent):void
		{
			// push frame data to global motionsprite
				ms.cO.motionArray = event.frame	
			
			/////////////////////////////////
			// update main gesture pipe
			/////////////////////////////////
				
			if (ms.tc) ms.updateMotionClusterAnalysis()
			if (ms.tp) ms.tp.processPipeline();
			if (ms.tg) ms.tg.manageGestureEventDispatch();
			if (ms.tt){
				ms.tt.transformManager();
				ms.tt.updateLocalProperties();
			}
		}
		
	}
}