﻿////////////////////////////////////////////////////////////////////////////////
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
	//import com.gestureworks.utils.NoiseFilter;
	//import com.gestureworks.utils.InertialFilter;
	
	public class DimensionObject extends Object 
	{
		
		// property name key
		private var _id:String;
		public function get id():String{	return _id;}
		public function set id(value:String):void{	_id = value;}
		// target property key
		private var _target_id:String;
		public function get target_id():String{	return _target_id;}
		public function set target_id(value:String):void{	_target_id = value;}
		//
		private var _activeDim:Boolean = true;
		public function get activeDim():Boolean{	return _activeDim;}
		public function set activeDim(value:Boolean):void{	_activeDim = value;}
		// property result name
		private var _property_result:String;
		public function get property_result():String{	return _property_result;}
		public function set property_result(value:String):void{	_property_result = value;}
		
		/////////////////////////////////////////////////////////////////////////////////////
		// VECTOR
		// property var array
		private var _property_vars:Array = new Array();
		public function get property_vars():Array{	return _property_vars;}
		public function set property_vars(value:Array):void{	_property_vars = value;}
		// property type
		private var _property_type:String;
		public function get property_type():String{	return _property_type;}
		public function set property_type(value:String):void{	_property_type = value;}
		// property id
		private var _property_id:String;
		public function get property_id():String{	return _property_id;}
		public function set property_id(value:String):void {	_property_id = value; }
		
		
		//USED IN BOUNDARY EVAL
		private var _gestureValue:Number = 0;
		public function get gestureValue():Number{	return _gestureValue;}
		public function set gestureValue(value:Number):void {	_gestureValue = value; }
		
		///////////////////////////////////////////////////////////////////////////////////////
		//CURRENT RAW CLUSTER DELTA
		private var _clusterDelta:Number = 0;
		public function get clusterDelta():Number{	return _clusterDelta;}
		public function set clusterDelta(value:Number):void{	_clusterDelta = value;}
		//CURRENT PROCESS DELTA
		private var _processDelta:Number = 0;
		public function get processDelta():Number{	return _processDelta;}
		public function set processDelta(value:Number):void{	_processDelta = value;}
		//CURRENT GESTURE DETLA
		private var _gestureDelta:Number = 0;
		public function get gestureDelta():Number{	return _gestureDelta;}
		public function set gestureDelta(value:Number):void{	_gestureDelta = value;}
		//LAST DELTA FOR DIM
		private var _gestureDeltaCache:Number = 0;
		public function get gestureDeltaCache():Number{	return _gestureDeltaCache;}
		public function set gestureDeltaCache(value:Number):void{	_gestureDeltaCache = value;}
		
		// CACHED GESTURE DELTAS
		//USED IN MEAN FILTERING
		private var _gestureDeltaArray:Array = new Array();
		public function get gestureDeltaArray():Array{	return _gestureDeltaArray;}
		public function set gestureDeltaArray(value:Array):void{	_gestureDeltaArray = value;}
		
		
		// CREATE GENERIC FILTER OBJECT
		// ADD FILTERS ON REQUEST TO KEEP LITE
		// CREATE GENERIC FILTER LIST AND ITERATE
		//////////////////////////////////////////////////////
		// multiply filter
		//////////////////////////////////////////////////////
		// constant of proportionality ---------------------
		private var _multiply_filter:Boolean = false;
		public function get multiply_filter():Boolean{	return _multiply_filter;}
		public function set multiply_filter(value:Boolean):void{	_multiply_filter = value;}
		// functional relationship between raw value and gesture value
		private var _func:String = "linear";
		public function get func():String{	return _func;}
		public function set func(value:String):void{	_func = value;}
		// constant of proportionality ---------------------
		private var _func_factor:Number = 1;
		public function get func_factor():Number{	return _func_factor;}
		public function set func_factor(value:Number):void{	_func_factor = value;}
		
		////////////////////////////////////////////////////////////////
		// delta filter
		////////////////////////////////////////////////////////////////
		// delta_threshold---------------------
		private var _delta_filter:Boolean = false;
		public function get delta_filter():Boolean{	return _delta_filter;}
		public function set delta_filter(value:Boolean):void{	_delta_filter = value;}
		// delta_max ---------------------
		private var _delta_max:Number = 100;
		public function get delta_max():Number{	return _delta_max;}
		public function set delta_max(value:Number):void{	_delta_max = value;}
		// delta_min ---------------------
		private var _delta_min:Number = 0;
		public function get delta_min():Number{	return _delta_min;}
		public function set delta_min(value:Number):void{	_delta_min = value;}
		
		/////////////////////////////////////////////////////////
		// value filter
		//////////////////////////////////////////////////////////
		// boundaryOn---------------------
		private var _boundary_filter:Boolean = false;
		public function get boundary_filter():Boolean{	return _boundary_filter;}
		public function set boundary_filter(value:Boolean):void{	_boundary_filter = value;}
		// boundary_max ---------------------
		private var _boundary_max:Number = 100;
		public function get boundary_max():Number{	return _boundary_max;}
		public function set boundary_max(value:Number):void{	_boundary_max = value;}
		// boundary_min ---------------------
		private var _boundary_min:Number = 0;
		public function get boundary_min():Number{	return _boundary_min;}
		public function set boundary_min(value:Number):void{	_boundary_min = value;}
		
		////////////////////////////////////////////////////////
		// mean filter
		////////////////////////////////////////////////////////
		// mean filter---------------------
		private var _mean_filter:Boolean = false;
		public function get mean_filter():Boolean{	return _mean_filter;}
		public function set mean_filter(value:Boolean):void{	_mean_filter = value;}
		// filter_factor---------------------
		private var _mean_filter_frames:uint = 0;
		public function get mean_filter_frames():uint{	return _mean_filter_frames;}
		public function set mean_filter_frames(value:uint):void{	_mean_filter_frames = value;}
		
		/////////////////////////////////////////////////////////
		// release inertia filter
		/////////////////////////////////////////////////////////
		// release_inertiaOn---------------------
		private var _release_inertia_filter:Boolean = false;
		public function get release_inertia_filter():Boolean{	return _release_inertia_filter;}
		public function set release_inertia_filter(value:Boolean):void{	_release_inertia_filter = value;}
		// release_inertia---------------------
		private var _release_inertiaOn:Boolean = false;
		public function get release_inertiaOn():Boolean{	return _release_inertiaOn;}
		public function set release_inertiaOn(value:Boolean):void{	_release_inertiaOn = value;}
		// r_inertia_factor---------------------
		private var _release_inertia_factor:Number = 1;
		public function get release_inertia_factor():Number{	return _release_inertia_factor;}
		public function set release_inertia_factor(value:Number):void{	_release_inertia_factor = value;}
		// r_inertia_base---------------------
		private var _release_inertia_base:Number = 0.98;
		public function get release_inertia_base():Number{	return _release_inertia_base;}
		public function set release_inertia_base(value:Number):void{	_release_inertia_base = value;}
		// r_inertia_factor count---------------------
		private var _release_inertia_count:int = 0;
		public function get release_inertia_count():int{	return _release_inertia_count;}
		public function set release_inertia_count(value:int):void{	_release_inertia_count = value;}
		// r_inertia_factor count-Max--------------------
		private var _release_inertia_Maxcount:int = 60;
		public function get release_inertia_Maxcount():int{	return _release_inertia_Maxcount;}
		public function set release_inertia_Maxcount(value:int):void{	_release_inertia_Maxcount = value;}
		
		
	}
}