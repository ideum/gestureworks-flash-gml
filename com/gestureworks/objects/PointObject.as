////////////////////////////////////////////////////////////////////////////////
//
//  IDEUM
//  Copyright 2011-2012 Ideum
//  All Rights Reserved.
//
//  GestureWorks
//
//  File:    PointObject.as
//  Authors:  Ideum
//             
//  NOTICE: Ideum permits you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////
package com.gestureworks.objects 
{
	import flash.display.DisplayObject;
	import flash.events.TouchEvent;
	
	public class PointObject extends Object 
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
		
		// x
		private var _x:Number = 0;
		public function get x():Number
		{
			return _x;
		}
		public function set x(value:Number):void
		{
			_x = value;
		}
		// y
		private var _y:Number = 0;
		public function get y():Number
		{
			return _y;
		}
		public function set y(value:Number):void
		{
			_y = value;
		}
		
		// hold monitor 
		private var _holdMonitorOn:Boolean = false;
		public function get holdMonitorOn():Boolean
		{
			return _holdMonitorOn;
		}
		public function set holdMonitorOn(value:Boolean):void
		{
			_holdMonitorOn = value;
		}
		// hold count
		// number frames passed hold test
		private var _holdCount:int;
		public function get holdCount():int
		{
			return _holdCount;
		}
		public function set holdCount(value:int):void
		{
			_holdCount = value;
		}
		
		// object
		private var _object:DisplayObject;
		public function get object():DisplayObject
		{
			return _object;
		}
		public function set object(value:DisplayObject):void
		{
			_object = value;
		}
		
		// point
		private var _point:*;
		public function get point():*
		{
			return _point;
		}
		public function set point(value:*):void
		{
			_point = value;
		}
	
		// event
		private var _event:TouchEvent;
		public function get event():TouchEvent
		{
			return _event;
		}
		public function set event(value:TouchEvent):void
		{
			_event = value;
		}
		
		// touchPointID
		private var _touchPointID:Number;
		public function get touchPointID():Number
		{
			return _touchPointID;
		}
		public function set touchPointID(value:Number):void
		{
			_touchPointID = value;
		}
		
		
		// history
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