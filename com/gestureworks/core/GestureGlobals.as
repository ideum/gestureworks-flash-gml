////////////////////////////////////////////////////////////////////////////////
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
	
	/**
		 * The GestureGlobals class is the global variables class that can be accessed from all classes within.
		 *
		 * You can acess a number of hooks for development.
		 * We have very near future plans to build this out a be more available for the developer.
		 * 
		 */

	public class GestureGlobals
	{		
		/**
		 * Contains a dictionary of all touchObjects available to the framework.
		 */
		gw_public static var touchObjects:Dictionary = new Dictionary();
		/**
		 * Contains a dictionary of all touch points present to the framework.
		 */
		gw_public static var points:Dictionary = new Dictionary();
		/**
		 * Contains a dictionary of all point histories present to the framework.
		 */
		//gw_public static var pointHistory:Dictionary = new Dictionary();
		/**
		 * Contains a dictionary of all clusters present to the framework.
		 */
		gw_public static var clusters:Dictionary = new Dictionary();
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
		
		
		
		
		
		
		
		
		// frameID frame stamp relative to start of application ------------
		private static var _frameID:int = 0;//int.MAX_VALUE
		/**
		 * frameID frame stamp relative to start of application.
		 */
		public static function get frameID():int
		{
			return _frameID;
		}
		/**
		 * frameID frame stamp relative to start of application.
		 */
		public static function set frameID(value:int):void
		{
			_frameID=value;
		}
		
		private static var _touchFrameInterval:Number = 16;//60fps
		/**
		 * returns touch frame interval, time between touch processing cycles.
		 */
		public static function get touchFrameInterval():Number
		{
			return _touchFrameInterval;
		}
		/**
		 * sets touch frame interval, time between touch processing cycles
		 */
		public static function set touchFrameInterval(value:Number):void
		{
			_touchFrameInterval=value;
		}
		
		private static var _max_point_count:int = 1000;
		/**
		 * returns max number of tracked touch points.
		 */
		public static function get max_point_count():int
		{
			return _max_point_count;
		}
		/**
		 * sets max number of tracked touch points.
		 */
		public static function set max_point_count(value:int):void
		{
			_max_point_count=value;
		}
		
		
		//  pointHistoryCaptureLength -------------------------------------
		private static var _pointHistoryCaptureLength:int = 8;//int.MAX_VALUE
		/**
		 * Returns the pointHistoryCaptureLength.
		 */
		public static function get pointHistoryCaptureLength():int
		{
			return _pointHistoryCaptureLength;
		}
		/**
		 * Sets the pointHistoryCaptureLength.
		 */
		public static function set pointHistoryCaptureLength(value:int):void
		{
			_pointHistoryCaptureLength=value;
		}
		
		//  clusterHistoryCaptureLength -------------------------------------
		private static var _clusterHistoryCaptureLength:int = 0;//int.MAX_VALUE
		/**
		 * Returns the current clusterHistoryCaptureLength.
		 */
		public static function get clusterHistoryCaptureLength():int
		{
			return _clusterHistoryCaptureLength;
		}
		/**
		 * Sets the current clusterHistoryCaptureLength.
		 */
		public static function set clusterHistoryCaptureLength(value:int):void
		{
			_clusterHistoryCaptureLength=value;
		}
		
		//  transformHistoryCaptureLength -------------------------------------
		private static var _transformHistoryCaptureLength:int = 0;//int.MAX_VALUE
		/**
		 * Returns the current transformHistoryCaptureLength.
		 */
		public static function get transformHistoryCaptureLength():int
		{
			return _transformHistoryCaptureLength;
		}
		/**
		 * Sets the current transformHistoryCaptureLength.
		 */
		public static function set transformHistoryCaptureLength(value:int):void
		{
			_transformHistoryCaptureLength=value;
		}
		
		//  timleineHistoryCaptureLength -------------------------------------
		private static var _timelineHistoryCaptureLength:int = 20;//int.MAX_VALUE
		/**
		 * Returns the current timelineHistoryCaptureLength.
		 */
		public static function get timelineHistoryCaptureLength():int
		{
			return _timelineHistoryCaptureLength;
		}
		/**
		 *Sets the current timelineHistoryCaptureLength.
		 */
		public static function set timelineHistoryCaptureLength(value:int):void
		{
			_timelineHistoryCaptureLength=value;
		}
		
		
		//  objectCount -------------------------------------
		private static var _objectCount:int;
		/**
		 * Returns the current objectCount of GestureWorks.
		 */
		public static function get objectCount():int
		{
			return _objectCount;
		}
		/**
		 * Sets the current objectCount of GestureWorks.
		 */
		gw_public static function set objectCount(value:int):void
		{
			_objectCount=value;
		}


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