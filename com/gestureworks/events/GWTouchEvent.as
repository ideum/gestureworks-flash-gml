////////////////////////////////////////////////////////////////////////////////
//
//  IDEUM
//  Copyright 2011-2012 Ideum
//  All Rights Reserved.
//
//  GestureWorks
//
//  File:    GWTouchEvent.as
//  Authors:  Ideum
//             
//  NOTICE: Ideum permits you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////
package com.gestureworks.events
{
	import flash.events.Event;
	import flash.display.InteractiveObject;
	import flash.events.TouchEvent;

	public class GWTouchEvent extends TouchEvent
	{
		public static const TOUCH_BEGIN : String = "touchBegin";
		public static const TOUCH_END : String = "touchEnd"
		public static const TOUCH_MOVE : String = "touchMove"
		public static const TOUCH_OUT : String = "touchOut"
		public static const TOUCH_OVER : String = "touchOver"
		public static const TOUCH_ROLL_OUT : String = "touchRollOut"
		public static const TOUCH_ROLL_OVER : String = "touchRollOver"
		
		public function GWTouchEvent(type:String, bubbles:Boolean = true, cancelable:Boolean = false, touchPointID:int = 0, isPrimaryTouchPoint:Boolean = false, localX:Number = NaN, localY:Number = NaN, sizeX:Number = NaN, sizeY:Number = NaN, pressure:Number = NaN, relatedObject:InteractiveObject = null, ctrlKey:Boolean = false, altKey:Boolean = false, shiftKey:Boolean = false, commandKey:Boolean = false, controlKey:Boolean = false)
		{
			super(type, bubbles, cancelable);
		}

		override public function clone():Event
		{
			return new GWTouchEvent(type, bubbles, cancelable);
		}
		
		/*public function updateAfterEvent():void
		{
			
		}*/

	}
}