////////////////////////////////////////////////////////////////////////////////
//
//  IDEUM
//  Copyright 2011-2012 Ideum
//  All Rights Reserved.
//
//  GestureWorks
//
//  File:   GWGestureEvent.as
//  Authors:  Ideum
//             
//  NOTICE: Ideum permits you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////
package com.gestureworks.events
{
	import flash.events.Event;
	import com.gestureworks.core.GestureGlobals;
	//import com.gestureworks.events.GestureGlobalVariables;

	public class GWGestureEvent extends Event
	{
		public var value:Object;

		include "GestureVariables.as"
		
		
		public static var CUSTOM:Object = 
			{
				GESTURELIST_UPDATE:"gesturelist update",
				START:"start",
				COMPLETE:"comlpete",
				RELEASE:"release",
				DRAG:"drag",
				ROTATE:"rotate",
				SCALE:"scale",
				SCROLL:"scroll",
				FLICK:"flick",
				PIVOT:"pivot",
				TILT:"tilt",
				ORIENT:"orient",
				HOLD:"hold",
				TAP:"tap",
				DOUBLE_TAP:"double_tap",
				TRIPLE_TAP:"triple_tap"
			};
		
		//public static var vars:Object { };
		//trace("test", GestureGlobalVariables.GE.HOLD, GestureGlobalVariables.GE["hold"]);
		//trace(GestureGlobalVariables.GE.NEWGESTURE);

		public function GWGestureEvent(type:String, data:Object, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			trace(type,CUSTOM.NEW_GESTURE); 
			super(type, bubbles, cancelable);
			value=data;
		}

		override public function clone():Event
		{
			return new GWGestureEvent(type, value, bubbles, cancelable);
		}

	}
}