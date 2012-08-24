////////////////////////////////////////////////////////////////////////////////
//
//  IDEUM
//  Copyright 2011-2012 Ideum
//  All Rights Reserved.
//
//  GestureWorks
//
//  File:    PropertyObject.as
//  Authors:  Ideum
//             
//  NOTICE: Ideum permits you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////
package com.gestureworks.objects 
{
	import com.gestureworks.utils.NoiseFilter;
	import com.gestureworks.utils.InertialFilter;
	
	public class PropertyObject extends Object 
	{
		
		// property name key
		private var _id:String;
		public function get id():String
		{
			return _id;
		}
		public function set id(value:String):void
		{
			_id = value;
		}
		// target property key
		private var _target_id:String;
		public function get target_id():String
		{
			return _target_id;
		}
		public function set target_id(value:String):void
		{
			_target_id = value;
		}
		
		////////////////////////////////////////////////////////
		// property var
		private var _property_var:String;
		
		public function get property_var():String
		{
			return _property_var;
		}
		public function set property_var(value:String):void
		{
			_property_var = value;
		}
		
		////////////////////////////////////////////////////////
		// property var
		private var _property_mvar:String;
		
		public function get property_mvar():String
		{
			return _property_mvar;
		}
		public function set property_mvar(value:String):void
		{
			_property_mvar = value;
		}
		
		
		// property type
		private var _property_type:String;
		public function get property_type():String
		{
			return _property_type;
		}
		public function set property_type(value:String):void
		{
			_property_type = value;
		}
		
		
		// property id
		private var _property_id:String;
		public function get property_id():String
		{
			return _property_id;
		}
		public function set property_id(value:String):void
		{
			_property_id = value;
		}
		
		
		
		////////////////////////////////////////////////////////
		// general cluster thresholds
		///////////////////////////////////////////////////////
		
		private var _cluster_translation_min:Number = 0;
		public function get cluster_translation_min():Number
		{
			return _cluster_translation_min;
		}
		public function set cluster_translation_min(value:Number):void
		{
			_cluster_translation_min = value;
		}
		private var _cluster_translation_max:Number = 0;
		public function get cluster_translation_max():Number
		{
			return _cluster_translation_max;
		}
		public function set cluster_translation_max(value:Number):void
		{
			_cluster_translation_max = value;
		}
		
		private var _cluster_separation_min:Number = 0;
		public function get cluster_separation_min():Number
		{
			return _cluster_separation_min;
		}
		public function set cluster_separation_min(value:Number):void
		{
			_cluster_separation_min = value;
		}
		private var _cluster_separation_max:Number = 0;
		public function get cluster_separation_max():Number
		{
			return _cluster_separation_max;
		}
		public function set cluster_separation_max(value:Number):void
		{
			_cluster_separation_max = value;
		}
		
		private var _cluster_rotation_min:Number = 0;
		public function get cluster_rotation_min():Number
		{
			return _cluster_rotation_min;
		}
		public function set cluster_rotation_min(value:Number):void
		{
			_cluster_rotation_min = value;
		}
		private var _cluster_rotation_max:Number = 0;
		public function get cluster_rotation_max():Number
		{
			return _cluster_rotation_max;
		}
		public function set cluster_rotation_max(value:Number):void
		{
			_cluster_rotation_max = value;
		}
		
		private var _cluster_acceleration_min:Number = 0;
		public function get cluster_acceleration_min():Number
		{
			return _cluster_acceleration_min;
		}
		public function set cluster_acceleration_min(value:Number):void
		{
			_cluster_acceleration_min = value;
		}
		
		private var _cluster_acceleration_max:Number = 0;
		public function get cluster_acceleration_max():Number
		{
			return _cluster_acceleration_max;
		}
		public function set cluster_acceleration_max(value:Number):void
		{
			_cluster_acceleration_max = value;
		}
		
		
		
		
		
		private var _cluster_event_duration_min:Number = 0;
		public function get cluster_event_duration_min():Number
		{
			return _cluster_event_duration_min;
		}
		public function set cluster_event_duration_min(value:Number):void
		{
			_cluster_event_duration_min = value;
		}
		
		private var _cluster_event_duration_max:Number = 0;
		public function get cluster_event_duration_max():Number
		{
			return _cluster_event_duration_max;
		}
		public function set cluster_event_duration_max(value:Number):void
		{
			_cluster_event_duration_max = value;
		}
		
		
		private var _cluster_interevent_duration_min:Number = 0;
		public function get cluster_interevent_duration_min():Number
		{
			return _cluster_interevent_duration_min;
		}
		public function set cluster_interevent_duration_min(value:Number):void
		{
			_cluster_interevent_duration_min = value;
		
		}	
		private var _cluster_interevent_duration_max:Number = 0;
		public function get cluster_interevent_duration_max():Number
		{
			return _cluster_interevent_duration_max;
		}
		public function set cluster_interevent_duration_max(value:Number):void
		{
			_cluster_interevent_duration_max = value;
		}
		
		////////////////////////////////////////////////////////
		// general cluster thresholds
		///////////////////////////////////////////////////////
		private var _point_translation_min:Number = 0;
		public function get point_translation_min():Number
		{
			return _point_translation_min;
		}
		public function set point_translation_min(value:Number):void
		{
			_point_translation_min = value;
		}
		private var _point_translation_max:Number = 0;
		public function get point_translation_max():Number
		{
			return _point_translation_max;
		}
		public function set point_translation_max(value:Number):void
		{
			_point_translation_max = value;
		}
		
		
		private var _point_acceleration_min:Number = 0;
		public function get point_acceleration_min():Number
		{
			return _point_acceleration_min;
		}
		public function set point_acceleration_min(value:Number):void
		{
			_point_acceleration_min = value;
		}
		private var _point_acceleration_max:Number = 0;
		public function get point_acceleration_max():Number
		{
			return _point_acceleration_max;
		}
		public function set point_acceleration_max(value:Number):void
		{
			_point_acceleration_max = value;
		}
		
		
		private var _point_event_duration_min:Number = 0;
		public function get point_event_duration_min():Number
		{
			return _point_event_duration_min;
		}
		public function set point_event_duration_min(value:Number):void
		{
			_point_event_duration_min = value;
		}
		private var _point_event_duration_max:Number = 0;
		public function get point_event_duration_max():Number
		{
			return _point_event_duration_max;
		}
		public function set point_event_duration_max(value:Number):void
		{
			_point_event_duration_max = value;
		}
		
		private var _point_interevent_duration_min:Number = 0;
		public function get point_interevent_duration_min():Number
		{
			return _point_interevent_duration_min;
		}
		public function set point_interevent_duration_min(value:Number):void
		{
			_point_interevent_duration_min = value;
		}
		private var _point_interevent_duration_max:Number = 0;
		public function get point_interevent_duration_max():Number
		{
			return _point_interevent_duration_max;
		}
		public function set point_interevent_duration_max(value:Number):void
		{
			_point_interevent_duration_max = value;
		}
		
		////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////
		// gesture object vector
		private var _clusterVector:Vector //=  new Vector.<Number>();
		public function get clusterVector():Vector
		{
			return _clusterVector;
		}
		public function set clusterVector(value:Vector):void
		{
			_clusterVector = value;
		}
		private var _processVector:Vector //= new Vector.<Number>();;
		public function get processVector():Vector
		{
			return _processVector;
		}
		public function set processVector(value:Vector):void
		{
			_processVector = value;
		}
		private var _gestureVector:Vector //= new Vector.<Number>();;
		public function get gestureVector():Vector
		{
			return _gestureVector;
		}
		public function set gestureVector(value:Vector):void
		{
			_gestureVector = value;
		}
		
		
		//dimention values
		private var _clusterValue:Number = 0;
		public function get clusterValue():Number
		{
			return _clusterValue;
		}
		public function set clusterValue(value:Number):void
		{
			_clusterValue = value;
		}
		private var _processValue:Number = 0;
		public function get processValue():Number
		{
			return _processValue;
		}
		public function set processValue(value:Number):void
		{
			_processValue = value;
		}
		private var _gestureValue:Number = 0;
		public function get gestureValue():Number
		{
			return _gestureValue;
		}
		public function set gestureValue(value:Number):void
		{
			_gestureValue = value;
		}
		
		//dimention deltas
		private var _clusterDelta:Number = 0;
		public function get clusterDelta():Number
		{
			return _clusterDelta;
		}
		public function set clusterDelta(value:Number):void
		{
			_clusterDelta = value;
		}
		private var _processDelta:Number = 0;
		public function get processDelta():Number
		{
			return _processDelta;
		}
		public function set processDelta(value:Number):void
		{
			_processDelta = value;
		}
		private var _gestureDelta:Number = 0;
		public function get gestureDelta():Number
		{
			return _gestureDelta;
		}
		public function set gestureDelta(value:Number):void
		{
			_gestureDelta = value;
		}
		
		private var _gestureDeltaCache:Number = 0;
		public function get gestureDeltaCache():Number
		{
			return _gestureDeltaCache;
		}
		public function set gestureDeltaCache(value:Number):void
		{
			_gestureDeltaCache = value;
		}
		
		//////////////////////////////////////////////////////
		// multiply filter
		//////////////////////////////////////////////////////
		// constant of proportionality ---------------------
		private var _multiplyOn:Boolean = false;
		public function get multiplyOn():Boolean
		{
			return _multiplyOn;
		}
		public function set multiplyOn(value:Boolean):void
		{
			_multiplyOn = value;
		}
		// functional relationship between raw value and gesture value
		private var _func:String = "linear";
		public function get func():String
		{
			return _func;
		}
		public function set func(value:String):void
		{
			_func = value;
		}
		// constant of proportionality ---------------------
		private var _func_factor:Number = 1;
		public function get func_factor():Number
		{
			return _func_factor;
		}
		public function set func_factor(value:Number):void
		{
			_func_factor = value;
		}
		
		
		////////////////////////////////////////////////////////////////
		// delta filter
		////////////////////////////////////////////////////////////////
		// delta_threshold---------------------
		private var _delta_threshold:Boolean = false;
		public function get delta_threshold():Boolean
		{
			return _delta_threshold;
		}
		public function set delta_threshold(value:Boolean):void
		{
			_delta_threshold = value;
		}
		// delta_max ---------------------
		private var _delta_max:Number = 100;
		public function get delta_max():Number
		{
			return _delta_max;
		}
		public function set delta_max(value:Number):void
		{
			_delta_max = value;
		}
		// delta_min ---------------------
		private var _delta_min:Number = 0;
		public function get delta_min():Number
		{
			return _delta_min;
		}
		public function set delta_min(value:Number):void
		{
			_delta_min = value;
		}
		
		/////////////////////////////////////////////////////////
		// value filter
		//////////////////////////////////////////////////////////
		// boundaryOn---------------------
		private var _boundaryOn:Boolean = false;
		public function get boundaryOn():Boolean
		{
			return _boundaryOn;
		}
		public function set boundaryOn(value:Boolean):void
		{
			_boundaryOn = value;
		}
		// boundary_max ---------------------
		private var _boundary_max:Number = 100;
		public function get boundary_max():Number
		{
			return _boundary_max;
		}
		public function set boundary_max(value:Number):void
		{
			_boundary_max = value;
		}
		// boundary_min ---------------------
		private var _boundary_min:Number = 0;
		public function get boundary_min():Number
		{
			return _boundary_min;
		}
		public function set boundary_min(value:Number):void
		{
			_boundary_min = value;
		}
		
		
		
		////////////////////////////////////////////////////////
		// noise filter
		////////////////////////////////////////////////////////
		// filterOn---------------------
		private var _filterOn:Boolean = false;
		public function get filterOn():Boolean
		{
			return _filterOn;
		}
		public function set filterOn(value:Boolean):void
		{
			_filterOn = value;
		}
		// filter_factor---------------------
		private var _filter_factor:Number = 0;
		public function get filter_factor():Number
		{
			return _filter_factor;
		}
		public function set filter_factor(value:Number):void
		{
			_filter_factor = value;
		}
		
		// noise_filter_matrix---------------------
		private var _noise_filterMatrix:NoiseFilter;
		public function get noise_filterMatrix():NoiseFilter
		{
			return _noise_filterMatrix;
		}
		public function set noise_filterMatrix(value:NoiseFilter):void
		{
			_noise_filterMatrix = value;
		}
		
		//////////////////////////////////////////////////////////////
		// touch inertia filter
		//////////////////////////////////////////////////////////////
		// touch_inertia---------------------
		private var _touch_inertia:Boolean = false;
		public function get touch_inertia():Boolean
		{
			return _touch_inertia;
		}
		public function set touch_inertia(value:Boolean):void
		{
			_touch_inertia = value;
		}
		// touch_inertiaOn---------------------
		private var _touch_inertiaOn:Boolean = false;
		public function get touch_inertiaOn():Boolean
		{
			return _touch_inertiaOn;
		}
		public function set touch_inertiaOn(value:Boolean):void
		{
			_touch_inertiaOn = value;
		}
		
		// inertial_filter_matrix---------------------
		private var _inertial_filterMatrix:InertialFilter;
		public function get inertial_filterMatrix():InertialFilter
		{
			return _inertial_filterMatrix;
		}
		public function set inertial_filterMatrix(value:InertialFilter):void
		{
			_inertial_filterMatrix = value;
		}
		
		// touch_inertia_mass---------------------
		private var _touch_inertia_mass:Number = 1;
		public function get touch_inertia_mass():Number
		{
			return _touch_inertia_mass;
		}
		public function set touch_inertia_mass(value:Number):void
		{
			_touch_inertia_mass = value;
		}
		
		// touch_inertia_spring---------------------
		private var _touch_inertia_spring:Number = 1;
		public function get touch_inertia_spring():Number
		{
			return _touch_inertia_spring;
		}
		public function set touch_inertia_spring(value:Number):void
		{
			_touch_inertia_spring = value;
		}
		
		/////////////////////////////////////////////////////////
		// release inertia filter
		/////////////////////////////////////////////////////////
		
		// release_inertiaOn---------------------
		private var _release_inertiaOn:Boolean = false;
		public function get release_inertiaOn():Boolean
		{
			return _release_inertiaOn;
		}
		public function set release_inertiaOn(value:Boolean):void
		{
			_release_inertiaOn = value;
		}
		// release_inertia---------------------
		private var _release_inertia:Boolean = false;
		public function get release_inertia():Boolean
		{
			return _release_inertia;
		}
		public function set release_inertia(value:Boolean):void
		{
			_release_inertia = value;
		}
		// r_inertia_factor---------------------
		private var _release_inertia_factor:Number = 1;
		public function get release_inertia_factor():Number
		{
			return _release_inertia_factor;
		}
		public function set release_inertia_factor(value:Number):void
		{
			_release_inertia_factor = value;
		}
		// r_inertia_base---------------------
		private var _release_inertia_base:Number = 0.98;
		public function get release_inertia_base():Number
		{
			return _release_inertia_base;
		}
		public function set release_inertia_base(value:Number):void
		{
			_release_inertia_base = value;
		}
		// r_inertia_factor count---------------------
		private var _release_inertia_count:int = 0;
		public function get release_inertia_count():int
		{
			return _release_inertia_count;
		}
		public function set release_inertia_count(value:int):void
		{
			_release_inertia_count = value;
		}
		// r_inertia_factor count-Max--------------------
		private var _release_inertia_Maxcount:int = 60;
		public function get release_inertia_Maxcount():int
		{
			return _release_inertia_Maxcount;
		}
		public function set release_inertia_Maxcount(value:int):void
		{
			_release_inertia_Maxcount = value;
		}
		
		
		// path_match---------------------
		private var _path_match:Boolean = false;
		public function get path_match():Boolean
		{
			return _path_match;
		}
		public function set path_match(value:Boolean):void
		{
			_path_match = value;
		}

		// path---------------------
		private var _path:Array = new Array();
		public function get path():Array
		{
			return _path;
		}
		public function set path(value:Array):void
		{
			_path = value;
		}
		
	}
}