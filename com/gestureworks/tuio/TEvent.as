////////////////////////////////////////////////////////////////////////////////
//
//  IDEUM
//  Copyright 2011-2012 Ideum
//  All Rights Reserved.
//
//  GestureWorks
//
//  File:    TEvent.as
//  Authors:  Ideum
//             
//  NOTICE: Ideum permits you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////
package com.gestureworks.tuio
{
	import flash.events.Event;

	public class TEvent extends Event
	{		
		public static var COMPLETE:String = "complete";
		public static var CHANGE:String = "change";
		
		public var object:Object = new Object();
		public var string:String = "very cool";
		
		public function TEvent(type:String, _object:Object, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			super(type, bubbles, cancelable);
			
			object = _object;
		}

		override public function clone():Event
		{
			return new TEvent(type, object, bubbles, cancelable);
		}
	}
}