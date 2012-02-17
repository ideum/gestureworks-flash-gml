////////////////////////////////////////////////////////////////////////////////
//
//  IDEUM
//  Copyright 2011-2012 Ideum
//  All Rights Reserved.
//
//  GestureWorks
//
//  File:    GesturePropertyObject.as
//  Authors:  Ideum
//             
//  NOTICE: Ideum permits you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////
package com.gestureworks.objects 
{
	
	public class GesturePropertyObject extends Object 
	{
		
		// gesture type
		private var _gesture_type:String;
		public function get gesture_type():String
		{
			return _gesture_type;
		}
		public function set gesture_type(value:String):void
		{
			_gesture_type = value;
		}
		
		// gesture id
		private var _gesture_id:String;
		public function get gesture_id():String
		{
			return _gesture_id;
		}
		public function set gesture_id(value:String):void
		{
			_gesture_id = value;
		}
		
		// gesture id
		private var _algorithm:String;
		public function get algorithm():String
		{
			return _algorithm;
		}
		public function set algorithm(value:String):void
		{
			_algorithm = value;
		}
		
		////////////////////////////////////////////////////////
		// general cluster thresholds
		///////////////////////////////////////////////////////
		private var _cluster_translation_threshold:Number = 0;
		public function get cluster_translation_threshold():Number
		{
			return _cluster_translation_threshold;
		}
		public function set cluster_translation_threshold(value:Number):void
		{
			_cluster_translation_threshold = value;
		}
		
		private var _cluster_separation_threshold:Number = 0;
		public function get cluster_separation_threshold():Number
		{
			return _cluster_separation_threshold;
		}
		public function set cluster_separation_threshold(value:Number):void
		{
			_cluster_separation_threshold = value;
		}
		
		private var _cluster_rotation_threshold:Number = 0;
		public function get cluster_rotation_threshold():Number
		{
			return _cluster_rotation_threshold;
		}
		public function set cluster_rotation_threshold(value:Number):void
		{
			_cluster_rotation_threshold = value;
		}
		
		private var _cluster_acceleration_threshold:Number = 0;
		public function get cluster_acceleration_threshold():Number
		{
			return _cluster_acceleration_threshold;
		}
		public function set cluster_acceleration_threshold(value:Number):void
		{
			_cluster_acceleration_threshold = value;
		}
		
		private var _cluster_event_duration_threshold:Number = 0;
		public function get cluster_event_duration_threshold():Number
		{
			return _cluster_event_duration_threshold;
		}
		public function set cluster_event_duration_threshold(value:Number):void
		{
			_cluster_event_duration_threshold = value;
		}
		
		private var _cluster_interevent_duration_threshold:Number = 0;
		public function get cluster_interevent_duration_threshold():Number
		{
			return _cluster_interevent_duration_threshold;
		}
		public function set cluster_interevent_duration_threshold(value:Number):void
		{
			_cluster_interevent_duration_threshold = value;
		}
		
		////////////////////////////////////////////////////////
		// general cluster thresholds
		///////////////////////////////////////////////////////
		private var _point_translation_threshold:Number = 0;
		public function get point_translation_threshold():Number
		{
			return _point_translation_threshold;
		}
		public function set point_translation_threshold(value:Number):void
		{
			_point_translation_threshold = value;
		}
		
		private var _point_acceleration_threshold:Number = 0;
		public function get point_acceleration_threshold():Number
		{
			return _point_acceleration_threshold;
		}
		public function set point_acceleration_threshold(value:Number):void
		{
			_point_acceleration_threshold = value;
		}
		
		private var _point_event_duration_threshold:Number = 0;
		public function get point_event_duration_threshold():Number
		{
			return _point_event_duration_threshold;
		}
		public function set point_event_duration_threshold(value:Number):void
		{
			_point_event_duration_threshold = value;
		}
		
		private var _point_interevent_duration_threshold:Number = 0;
		public function get point_interevent_duration_threshold():Number
		{
			return _point_interevent_duration_threshold;
		}
		public function set point_interevent_duration_threshold(value:Number):void
		{
			_point_interevent_duration_threshold = value;
		}

		// n---------------------
		private var _n:int = 0;
		public function get n():int
		{
			return _n;
		}
		public function set n(value:int):void
		{
			_n = value;
		}
		
		// nMax---------------------
		private var _nMax:int = 100;
		public function get nMax():int
		{
			return _nMax;
		}
		public function set nMax(value:int):void
		{
			_nMax = value;
		}
		// nMin---------------------
		private var _nMin:int = 0;
		public function get nMin():int
		{
			return _nMin;
		}
		public function set nMin(value:int):void
		{
			_nMin = value;
		}
		
	}
}