﻿////////////////////////////////////////////////////////////////////////////////
//
//  IDEUM
//  Copyright 2011-2012 Ideum
//  All Rights Reserved.
//
//  GestureWorks
//
//  File:    GestureGlobals.as
//  Authors:  Ideum
//             
//  NOTICE: Ideum permits you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

package com.gestureworks.core
{
	import flash.utils.Dictionary;
	import com.gestureworks.utils.TouchPointID;
	import com.gestureworks.core.gw_public;
	
	import com.gestureworks.objects.TouchPointObject;
	import com.gestureworks.objects.MotionPointObject;
	import com.gestureworks.objects.SensorPointObject;
	import com.gestureworks.objects.InteractionPointObject;
	import com.gestureworks.objects.HandObject;
	import com.gestureworks.objects.TimelineObject;
	
	/**
	 * The GestureGlobals class is the global variables class that can be accessed from all classes within.
	 * You can acess a number of hooks for development.
	 */
	public class GestureGlobals
	{		
		/**
		 * Contains a dictionary of all touch points present to the framework.
		 */
		gw_public static var touchPoints:Dictionary = new Dictionary();
		/**
		 * Contains a dictionary of all motion points present to the framework.
		 */		
		gw_public static var motionPoints:Dictionary = new Dictionary();
		/**
		 * Contains a dictionary of all sensor points present to the framework.
		 */		
		gw_public static var sensorPoints:Dictionary = new Dictionary();
		/**
		 * Contains a dictionary of all interaction points present to the framework.
		 */			
		gw_public static var interactionPoints:Dictionary = new Dictionary();
		/**
		 * Contains a dictionary of all touchObjects available to the framework.
		 */
		gw_public static var core:CoreSprite = new CoreSprite();
		gw_public static var timeline:TimelineObject = new TimelineObject;
		gw_public static var touchArray:Vector.<TouchPointObject> = new Vector.<TouchPointObject>;
		gw_public static var motionArray:Vector.<MotionPointObject> = new Vector.<MotionPointObject>;
		gw_public static var sensorArray:Vector.<SensorPointObject> = new Vector.<SensorPointObject>;
		gw_public static var iPointArray:Vector.<InteractionPointObject> = new Vector.<InteractionPointObject>;
		gw_public static var handList:Vector.<HandObject> = new Vector.<HandObject>;
		
		/**
		 * Contains a dictionary of all touchObjects available to the framework.
		 */
		gw_public static var touchObjects:Dictionary = new Dictionary();
		
		gw_public static var temp_tOList:Array = new Array();
		/**
		 * Contains a dictionary of all clusters present to the framework.
		 */
		gw_public static var clusters:Dictionary = new Dictionary();
		/**
		 * Contains a dictionary of all interaction point clusters present to the framework.
		 */
		gw_public static var iPointClusterLists:Dictionary = new Dictionary();
		/**
		 * Contains a dictionary of all gestures present to the framework.
		 */
		gw_public static var gestures:Dictionary = new Dictionary();
		/**
		 * Contains a dictionary of all transforms present to the framework.
		 */
		gw_public static var transforms:Dictionary = new Dictionary();
		/**
		 * Contains a dictionary of all timelines objects present to the framework.
		 */
		gw_public static var timelines:Dictionary = new Dictionary();
		
		gw_public static var touchPointCount:int;
		gw_public static var sensorPointCount:int;
		gw_public static var motionPointCount:int;
		gw_public static var interactionPointCount:int;
		gw_public static var iPointClusterListCount:int;
		
		/**
		 * frameID frame stamp relative to start of application.
		 */
		public static var frameID:int = 0;//int.MAX_VALUE
		
		/**
		 * frameID frame stamp relative to start of application.
		 */
		public static var motionFrameID:uint = 0;//int.MAX_VALUE
		
		/**
		 * frameID frame stamp relative to start of application.
		 */
		public static var sensorFrameID:uint = 0;//int.MAX_VALUE

		/**
		 * touch frame interval, time between touch processing cycles.
		 */		
		public static var touchFrameInterval:Number = 16;//60fps
		
		/**
		 * max number of tracked touch points.
		 */		
		public static var max_point_count:int = 1000;
		
		/**
		 * point history capture length
		 */		
		public static var pointHistoryCaptureLength:int = 8;//int.MAX_VALUE
		
		/**
		 * cluster history capture length
		 */		
		public static var clusterHistoryCaptureLength:int = 60;//int.MAX_VALUE // SET FOR 3D LEAP MOTION ANALYSIS
		
		/**
		 * motion history capture length
		 */
		public static var motionHistoryCaptureLength:int = 120;//int.MAX_VALUE
		
		/**
		 * motion history capture length
		 */
		public static var sensorHistoryCaptureLength:int = 240;//int.MAX_VALUE
		
		/**
		 * transform history capture length
		 */
		public static var transformHistoryCaptureLength:int = 0;//int.MAX_VALUE
		
		/**
		 * timeline history capture length
		 */
		public static var timelineHistoryCaptureLength:int = 20;//int.MAX_VALUE
		
		/**
		 * current GestureWorks object count
		 */
		public static var objectCount:int;

		//  gwPointID -----------------------------------------------
		/**
		 * Returns a gwPointID.
		 */
		public static function get gwPointID():int
		{
			return TouchPointID.gwPointID;
		}
		/**
		 * Sets a gwPointID.
		 */
		gw_public static function set gwPointID(value:int):void
		{
			TouchPointID.gwPointID=value;
		}
	}
}