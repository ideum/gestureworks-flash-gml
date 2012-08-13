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
		
		// activeEvent
		private var _activeEvent:Boolean = false;
		public function get activeEvent():Boolean
		{
			return _activeEvent;
		}
		public function set activeEvent(value:Boolean):void
		{
			_activeEvent = value;
		}
		
		// dispatchEvent
		private var _dispatchEvent:Boolean = false;
		public function get dispatchEvent():Boolean
		{
			return _dispatchEvent;
		}
		public function set dispatchEvent(value:Boolean):void
		{
			_dispatchEvent = value;
		}
		
		
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
		
		// algorithm id
		private var _algorithm:String;
		public function get algorithm():String
		{
			return _algorithm;
		}
		public function set algorithm(value:String):void
		{
			_algorithm = value;
		}
		
		// algorithm type
		private var _algorithm_type:String;
		public function get algorithm_type():String
		{
			return _algorithm_type;
		}
		public function set algorithm_type(value:String):void
		{
			_algorithm_type = value;
		}
		
		// algorithm class
		private var _algorithm_class:String;
		public function get algorithm_class():String
		{
			return _algorithm_class;
		}
		public function set algorithm_class(value:String):void
		{
			_algorithm_class = value;
		}
		
		/////////////////////////////
		// global gesture object properties
		/////////////////////////////
		
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
		
		// event dipatch type
		private var _dispatch_type:String;
		public function get dispatch_type():String
		{
			return _dispatch_type;
		}
		public function set dispatch_type(value:String):void
		{
			_dispatch_type = value;
		}
		
		///////////////////////////////////////////////////
		// GESTURE EVENT PHASE LOGIC
		///////////////////////////////////////////////////
		// start
		private var _start:Boolean = false;
		public function get start():Boolean
		{
			return _start;
		}
		public function set start(value:Boolean):void
		{
			_start = value;
		}
		
		// active
		private var _active:Boolean = false;
		public function get active():Boolean
		{
			return _active;
		}
		public function set active(value:Boolean):void
		{
			_active = value;
		}
		
		// release
		private var _release:Boolean = false;
		public function get release():Boolean
		{
			return _release;
		}
		public function set release(value:Boolean):void
		{
			_release = value;
		}
		
		// passive
		private var _passive:Boolean = false;
		public function get passive():Boolean
		{
			return _passive;
		}
		public function set passive(value:Boolean):void
		{
			_passive = value;
		}
		
		// complete
		private var _complete:Boolean = false;
		public function get complete():Boolean
		{
			return _complete;
		}
		public function set complete(value:Boolean):void
		{
			_complete = value;
		}
		
		// data object
		private var _data:Object = new Object();
		public function get data():Object
		{
			return _data;
		}
		public function set data(value:Object):void
		{
			_data = value;
		}
	}
}