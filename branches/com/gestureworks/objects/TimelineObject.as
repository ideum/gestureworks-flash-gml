////////////////////////////////////////////////////////////////////////////////
//
//  IDEUM
//  Copyright 2011-2012 Ideum
//  All Rights Reserved.
//
//  GestureWorks
//
//  File:    TimelineObject.as
//  Authors:  Ideum
//             
//  NOTICE: Ideum permits you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////
package com.gestureworks.objects 
{
	import com.gestureworks.objects.FrameObject;
	
	public class TimelineObject extends Object 
	{
		
		// ID
		private var _id:int;
		public function get id():int
		{
			return _id;
		}
		public function set id(value:int):void
		{
			_id = value;
		}
		private var _timelineOn:Boolean = false;
		public function get timelineOn():Boolean
		{
			return _timelineOn;
		}
		public function set timelineOn(value:Boolean):void
		{
			_timelineOn = value;
		}
		
		private var _timelineInit:Boolean = false;
		public function get timelineInit():Boolean
		{
			return _timelineInit;
		}
		public function set timelineInit(value:Boolean):void
		{
			_timelineInit = value;
		}
		
		///////////////////////////////////////////////
		// add touch point events
		private var _pointEvents:Boolean = false;
		public function get pointEvents():Boolean
		{
			return _pointEvents;
		}
		public function set pointEvents(value:Boolean):void
		{
			_pointEvents = value;
		}
		// add touch cluster events
		private var _clusterEvents:Boolean = false;
		public function get clusterEvents():Boolean
		{
			return _clusterEvents;
		}
		public function set clusterEvents(value:Boolean):void
		{
			_clusterEvents = value;
		}
		// add touch point events
		private var _gestureEvents:Boolean = false;
		public function get gestureEvents():Boolean
		{
			return _gestureEvents;
		}
		public function set gestureEvents(value:Boolean):void
		{
			_gestureEvents = value;
		}
		
		// add touch transform events
		private var _transformEvents:Boolean = false;
		public function get transformEvents():Boolean
		{
			return _transformEvents;
		}
		public function set transformEvents(value:Boolean):void
		{
			_transformEvents = value;
		}
		
		//frame object
		private var _frame:FrameObject = new FrameObject();
		public function get frame():FrameObject
		{
			return _frame;
		}
		public function set frame(value:FrameObject):void
		{
			_frame = value;
		}
		
		// timeline history
		private var _history:Array = new Array();
		public function get history():Array
		{
			return _history;
		}
		public function set history(value:Array):void
		{
			_history = value;
		}
	}
}