////////////////////////////////////////////////////////////////////////////////
//
//  IDEUM
//  Copyright 2011-2012 Ideum
//  All Rights Reserved.
//
//  GestureWorks
//
//  File:    BinaryEvent.as
//  Authors:  Ideum
//             
//  NOTICE: Ideum permits you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////
package com.gestureworks.events
{
	import flash.events.Event;

	public class BinaryEvent extends Event
	{		
		public static var COMPLETE:String = "complete";
		
		public var object:Object;
		
		public function BinaryEvent(type:String, _object:Object=null, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			super(type, bubbles, cancelable);
			
			object= _object;
		}

		override public function clone():Event
		{
			return new BinaryEvent(type, object, bubbles, cancelable);
		}
	}
}