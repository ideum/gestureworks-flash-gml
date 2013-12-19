////////////////////////////////////////////////////////////////////////////////
//
//  IDEUM
//  Copyright 2011-2012 Ideum
//  All Rights Reserved.
//
//  GestureWorks
//
//  File:    GWSensorEvent.as
//  Authors:  Ideum
//             
//  NOTICE: Ideum permits you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////
package com.gestureworks.events
{
	import com.gestureworks.core.GestureWorks;
	import flash.events.Event;
	import flash.utils.Dictionary;


	public class GWSensorEvent extends Event
	{
		public var value:Object;
		public static const SENSOR_BEGIN : String = "gwSensorBegin";
		public static const SENSOR_END : String = "gwSensorEnd"
		public static const SENSOR_UPDATE : String = "gwSensorUpdate"
	
		public function GWSensorEvent(type:String, data:Object, bubbles:Boolean = true, cancelable:Boolean = false)
		{
			super(type, bubbles, cancelable);
			value = data;
		}
		
		override public function clone():Event
		{
			return new GWInteractionEvent(type, bubbles, cancelable);
		}

	}
}