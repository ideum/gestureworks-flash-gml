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
	
	public class GestureObject extends Object 
	{
		// gesture id
		private var _gesture_id:String;
		public function get gesture_id():String{return _gesture_id;}
		public function set gesture_id(value:String):void {	_gesture_id = value; }
		
		// gesture xml block
		private var _gesture_xml:XML;
		public function get gesture_xml():XML{return _gesture_xml;}
		public function set gesture_xml(value:XML):void{	_gesture_xml = value;}
		
		// SHOULD MOVE TO GESTURE EVENT OBJECT
		// activeEvent
		private var _activeEvent:Boolean = false;
		public function get activeEvent():Boolean{	return _activeEvent;}
		public function set activeEvent(value:Boolean):void{	_activeEvent = value;}
		// dispatchEvent
		private var _dispatchEvent:Boolean = false;
		public function get dispatchEvent():Boolean{	return _dispatchEvent;}
		public function set dispatchEvent(value:Boolean):void{	_dispatchEvent = value;}
		
		
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		// MOVE TO MATHING CRITERIA SUBOBJECT
		////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
		// gesture type
		private var _gesture_type:String;
		public function get gesture_type():String{	return _gesture_type;}
		public function set gesture_type(value:String):void {	_gesture_type = value; }
		
		// algorithm id
		private var _algorithm:String;
		public function get algorithm():String{	return _algorithm;}
		public function set algorithm(value:String):void{	_algorithm = value;}
		// algorithm type
		private var _algorithm_type:String;
		public function get algorithm_type():String{	return _algorithm_type;}
		public function set algorithm_type(value:String):void{	_algorithm_type = value;}
		// algorithm class
		private var _algorithm_class:String;
		public function get algorithm_class():String{	return _algorithm_class;}
		public function set algorithm_class(value:String):void{	_algorithm_class = value;}
		
		// n_current---------------------
		private var _n_current:int = 0;
		public function get n_current():int{return _n_current;}
		public function set n_current(value:int):void { _n_current = value; }
		// n_cache---------------------
		private var _n_cache:int = 0;
		public function get n_cache():int{return _n_cache;}
		public function set n_cache(value:int):void{_n_cache = value;}
		
		
		//////////////////////////////////////
		// global gesture matching criteria
		//////////////////////////////////////
		
		// n---------------------
		private var _n:int = 0;
		public function get n():int{return _n;}
		public function set n(value:int):void { _n = value; }
		// nMax---------------------
		private var _nMax:int = 100;
		public function get nMax():int{return _nMax;}
		public function set nMax(value:int):void { _nMax = value; }
		// nMin---------------------
		private var _nMin:int = 0;
		public function get nMin():int{return _nMin;}
		public function set nMin(value:int):void{_nMin = value;}
		// hand number---------------------
		private var _hn:int = 0;
		public function get hn():int{return _hn;}
		public function set hn(value:int):void { _hn = value; }
		// finger number---------------------
		private var _fn:int = 0;
		public function get fn():int{return _fn;}
		public function set fn(value:int):void { _fn = value; }
		// CLUSTER TYPE---------------------
		private var _cluster_type:String = "";
		public function get cluster_type():String{return _cluster_type;}
		public function set cluster_type(value:String):void { _cluster_type = value; }
		// CLUSTER INPUT TYPE---------------------
		private var _cluster_input_type:String = "";
		public function get cluster_input_type():String{return _cluster_input_type;}
		public function set cluster_input_type(value:String):void { _cluster_input_type = value; }
		
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		//UPDATE TO LIMITS OBJECT PUSH TO CLUSTER OBJECT
		////////////////////////////////////////////////////////
		// general cluster thresholds
		///////////////////////////////////////////////////////
		//
		private var _cluster_translation_min:Number = 0;
		public function get cluster_translation_min():Number{	return _cluster_translation_min;}
		public function set cluster_translation_min(value:Number):void{	_cluster_translation_min = value;}
		//
		private var _cluster_translation_max:Number = 0;
		public function get cluster_translation_max():Number{	return _cluster_translation_max;}
		public function set cluster_translation_max(value:Number):void{	_cluster_translation_max = value;}
		//
		private var _cluster_separation_min:Number = 0;
		public function get cluster_separation_min():Number{	return _cluster_separation_min;}
		public function set cluster_separation_min(value:Number):void{	_cluster_separation_min = value;}
		//
		private var _cluster_separation_max:Number = 0;
		public function get cluster_separation_max():Number{	return _cluster_separation_max;}
		public function set cluster_separation_max(value:Number):void{	_cluster_separation_max = value;}
		//
		private var _cluster_rotation_min:Number = 0;
		public function get cluster_rotation_min():Number{	return _cluster_rotation_min;}
		public function set cluster_rotation_min(value:Number):void{	_cluster_rotation_min = value;}
		//
		private var _cluster_rotation_max:Number = 0;
		public function get cluster_rotation_max():Number{	return _cluster_rotation_max;}
		public function set cluster_rotation_max(value:Number):void{	_cluster_rotation_max = value;}
		//
		private var _cluster_acceleration_min:Number = 0;
		public function get cluster_acceleration_min():Number{	return _cluster_acceleration_min;}
		public function set cluster_acceleration_min(value:Number):void{	_cluster_acceleration_min = value;}
		//
		private var _cluster_acceleration_max:Number = 0;
		public function get cluster_acceleration_max():Number{	return _cluster_acceleration_max;}
		public function set cluster_acceleration_max(value:Number):void{	_cluster_acceleration_max = value;}
		//
		private var _cluster_event_duration_min:Number = 0;
		public function get cluster_event_duration_min():Number{	return _cluster_event_duration_min;}
		public function set cluster_event_duration_min(value:Number):void{	_cluster_event_duration_min = value;}
		//
		private var _cluster_event_duration_max:Number = 0;
		public function get cluster_event_duration_max():Number{	return _cluster_event_duration_max;}
		public function set cluster_event_duration_max(value:Number):void{	_cluster_event_duration_max = value;}
		//
		private var _cluster_interevent_duration_min:Number = 0;
		public function get cluster_interevent_duration_min():Number{return _cluster_interevent_duration_min;}
		public function set cluster_interevent_duration_min(value:Number):void{	_cluster_interevent_duration_min = value;}	
		//
		private var _cluster_interevent_duration_max:Number = 0;
		public function get cluster_interevent_duration_max():Number{	return _cluster_interevent_duration_max;}
		public function set cluster_interevent_duration_max(value:Number):void{	_cluster_interevent_duration_max = value;}
		
		////////////////////////////////////////////////////////
		// general POINT thresholds
		///////////////////////////////////////////////////////
		private var _point_translation_min:Number = 0;
		public function get point_translation_min():Number{	return _point_translation_min;}
		public function set point_translation_min(value:Number):void{	_point_translation_min = value;}
		//
		private var _point_translation_max:Number = 0;
		public function get point_translation_max():Number{	return _point_translation_max;}
		public function set point_translation_max(value:Number):void{	_point_translation_max = value;}
		//
		private var _point_acceleration_min:Number = 0;
		public function get point_acceleration_min():Number{	return _point_acceleration_min;}
		public function set point_acceleration_min(value:Number):void{	_point_acceleration_min = value;}
		//
		private var _point_acceleration_max:Number = 0;
		public function get point_acceleration_max():Number{	return _point_acceleration_max;}
		public function set point_acceleration_max(value:Number):void{	_point_acceleration_max = value;}
		//
		private var _point_event_duration_min:Number = 0;
		public function get point_event_duration_min():Number{	return _point_event_duration_min;}
		public function set point_event_duration_min(value:Number):void{	_point_event_duration_min = value;}
		//
		private var _point_event_duration_max:Number = 0;
		public function get point_event_duration_max():Number{	return _point_event_duration_max;}
		public function set point_event_duration_max(value:Number):void{	_point_event_duration_max = value;}
		//
		private var _point_interevent_duration_min:Number = 0;
		public function get point_interevent_duration_min():Number{	return _point_interevent_duration_min;}
		public function set point_interevent_duration_min(value:Number):void{	_point_interevent_duration_min = value;}
		//
		private var _point_interevent_duration_max:Number = 0;
		public function get point_interevent_duration_max():Number{	return _point_interevent_duration_max;}
		public function set point_interevent_duration_max(value:Number):void {	_point_interevent_duration_max = value; }
		
		// ACCEL POINT THRESHOLDS..
		// MOTION POINT THRESHOLDS...
		
		// REMOVE
		////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////
		// gesture object vector
		private var _clusterVector:Vector //=  new Vector.<Number>();
		public function get clusterVector():Vector{	return _clusterVector;}
		public function set clusterVector(value:Vector):void{	_clusterVector = value;}
		//
		private var _processVector:Vector //= new Vector.<Number>();;
		public function get processVector():Vector{	return _processVector;}
		public function set processVector(value:Vector):void{	_processVector = value;}
		//
		private var _gestureVector:Vector //= new Vector.<Number>();;
		public function get gestureVector():Vector{	return _gestureVector;}
		public function set gestureVector(value:Vector):void {	_gestureVector = value; }

		
		
		// path-match---------------
		private var _gmlPath:Array = new Array();
		public function get gmlPath():Array{	return _gmlPath;}
		public function set gmlPath(value:Array):void{	_gmlPath = value;}
		// match event
		private var _match_TouchEvent:String;
		public function get match_TouchEvent():String{	return _match_TouchEvent;}
		public function set match_TouchEvent(value:String):void{	_match_TouchEvent = value;}
		// match event
		private var _match_GestureEvent:String;
		public function get match_GestureEvent():String{	return _match_GestureEvent;}
		public function set match_GestureEvent(value:String):void{	_match_GestureEvent = value;}
		
		/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		// end match criteria
		////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
		
		
		
		
		
		// SHOULD MOVE TO GESTURE EVENT OBJECT
		////////////////////////////////////////////////////////////////////////////////////
		// GESTURE EVENT SETTINGS
		////////////////////////////////////////////////////////////////////////////////////
		// event type
		private var _event_type:String;
		public function get event_type():String{	return _event_type;}
		public function set event_type(value:String):void{	_event_type = value;}
		// event dipatch type
		private var _dispatch_type:String;
		public function get dispatch_type():String{	return _dispatch_type;}
		public function set dispatch_type(value:String):void{	_dispatch_type = value;}
		// event dipatch mode
		private var _dispatch_mode:String;
		public function get dispatch_mode():String{	return _dispatch_mode;}
		public function set dispatch_mode(value:String):void{	_dispatch_mode = value;}
		//
		private var _dispatch_reset:String;
		public function get dispatch_reset():String{	return _dispatch_reset;}
		public function set dispatch_reset(value:String):void	{	_dispatch_reset = value;}
		// event dipatch interval
		private var _dispatch_interval:int;
		public function get dispatch_interval():int{	return _dispatch_interval;}
		public function set dispatch_interval(value:int):void{	_dispatch_interval = value;}
		// timer_count
		private var _timer_count:int = 0;
		public function get timer_count():int{	return _timer_count;}
		public function set timer_count(value:int):void {	_timer_count = value; }
		
		
		// SHOULD MOVE TO GESTURE EVENT OBJECT
		///////////////////////////////////////////////////
		// GESTURE EVENT PHASE LOGIC 
		// 0 null
		// 1 start 
		// 2 active 
		// 3 release
		// 4 passive
		// 5 complete
		///////////////////////////////////////////////////
		// start
		private var _start:Boolean = false;
		public function get start():Boolean{	return _start;}
		public function set start(value:Boolean):void{	_start = value;}
		// active
		private var _active:Boolean = false;
		public function get active():Boolean{	return _active;}
		public function set active(value:Boolean):void{	_active = value;}
		// release
		private var _release:Boolean = false;
		public function get release():Boolean{	return _release;}
		public function set release(value:Boolean):void{	_release = value;}
		// passive
		private var _passive:Boolean = false;
		public function get passive():Boolean{	return _passive;}
		public function set passive(value:Boolean):void{	_passive = value;}
		// complete
		private var _complete:Boolean = false;
		public function get complete():Boolean{	return _complete;}
		public function set complete(value:Boolean):void{_complete = value;}
		
		// SHOULD MOVE TO GESTURE EVENT OBJECT
		////////////////////////////////////////////////////////////////////////////
		// data object
		private var _data:Object = new Object();
		public function get data():Object{return _data;}
		public function set data(value:Object):void{_data = value;}
		// DIMENSION LIST
		private var _dList:Vector.<DimensionObject> = new Vector.<DimensionObject>();
		public function get dList():Vector.<DimensionObject>{return _dList;}
		public function set dList(value:Vector.<DimensionObject>):void{_dList = value;}
	
		
	}
}