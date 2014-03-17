////////////////////////////////////////////////////////////////////////////////
//
//  IDEUM
//  Copyright 2011-2012 Ideum
//  All Rights Reserved.
//
//  GestureWorks
//
//  File:    FrameObject.as
//  Authors:  Ideum
//             
//  NOTICE: Ideum permits you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////
package com.gestureworks.objects 
{
	import com.gestureworks.events.GWTouchEvent;
	import com.gestureworks.events.GWGestureEvent;
	import com.gestureworks.events.GWTransformEvent;
	
	public class FrameObject extends Object 
	{
		// ID
		public var id:int;
		
		//pointEventArray
		public var pointEventArray:Vector.<GWTouchEvent> //= new Vector.<GWTouchEvent>;

		//gestureEventArray
		public var gestureEventArray:Vector.<GWGestureEvent> //= new Vector.<GWGestureEvent>();

		//transformEventArray
		public var transformEventArray:Vector.<GWTransformEvent> //= new Vector.<GWTransformEvent>();
		
		/**
		 * Resets attributes to initial values
		 */
		public function reset():void {
			id = NaN;
			if(pointEventArray) 	pointEventArray.length = 0;					
			if(gestureEventArray) 	gestureEventArray.length = 0;			
			if(transformEventArray) transformEventArray.length = 0;			
		}
	}
}