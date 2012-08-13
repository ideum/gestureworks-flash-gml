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

	public class GWGestureEvent extends Event
	{
		public var value:Object;
		public var data:Object;
		
		public static var GESTURELIST_UPDATE:String = "gesturelist update";
		public static var START:String = "start";
		public static var COMPLETE:String = "complete";
		public static var RELEASE:String = "release";
		
		// kine-metric
		public static var MANIPULATE:String = "manipulate";
		public static var DRAG:String = "drag";
		public static var SWIPE:String = "swipe";
		public static var SCROLL:String = "scroll";
		public static var FLICK:String = "flick";
		public static var ROTATE:String= "rotate";
		public static var SCALE:String = "scale";
		public static var PIVOT:String = "pivot";
		public static var TILT:String = "tilt";
		public static var ORIENT:String = "orient";
		public static var HOLD:String = "hold";
		public static var SPIRAL:String = "spiral";
		public static var SPLIT:String = "split";
		
		// temproal-metric	
		public static var TAP:String = "tap";
		public static var DOUBLE_TAP:String = "double_tap";
		public static var TRIPLE_TAP:String = "triple_tap";
		//public static var PRESURE_TAP:String = "presure_tap";
		//public static var RYTHM_TAP:String = "rythm_tap";
		
		// geo-metric
		// public static var CLUSTER_TRIANGLE:String = "point_triangle";
		// public static var CLUSTER_RECTANGLE:String = "point_rectagle";
		// public static var CLUSTER_LINE:String = "point_line";
		
		// vector-metric
		public static var STROKE:String = "stroke";
		//public static var STROKE_LETTER:String = "letter";
		//public static var STROKE_GREEK:String = "greek";
		//public static var STROKE_SYMBOL:String = "symbol";
		//public static var STROKE_SHAPE:String = "shape";
		//public static var STROKE_NUMBER:String = "number";
		
		////////////////////////////////////////////////////////////
		// serial gestures (anchor)// HOLD + TAP
		////////////////////////////////////////////////////////////
		
		//public static var HOLD_TAP:String = "hold_tap";
		//public static var HOLD_FLICK:String = "hold_drag";
		//public static var HOLD_ROTATE:String = "hold_rotate";
		//public static var HOLD_SCALE:String = "hold_scale";
		//public static var HOLD_FLICK:String = "hold_flick";
		//public static var HOLD_STROKE:String = "hold_stroke";
		
		
		///////////////////////////////////////////////////////////
		// gloabal gestures
		///////////////////////////////////////////////////////////
		
		//public static var PULSE:String = "pulse";
		//public static var FLEX:String = "flex";
		//public static var REPEL:String = "repel";
		//public static var ATTRACT:String = "attract";

		//public static var BROADCAST:String = "broadcast";
		//public static var CUT:String = "cut";
		//public static var PASTE:String = "paste";
		//public static var DELETE:String = "delete";
		//public static var CLOSE:String = "close";
		//public static var SEARCH:String = "search";
				
		//public static var EXIT:String = "exit";
		//public static var HOME:String = "home";
		
	
		public static var GML:Object = 
			{
				SEED_GESTURE:"seed gesture",
				NEW_GESTURE:"new gesture",
				EXAMPLE_GESTURE:"example gesture",
				N_DRAG:"n-drag",
				THREE_FINGER_DRAG:"3-finger-drag"
			};
	
		
		//public static var vars:Object { };
		//trace("test", GestureGlobalVariables.GE.HOLD, GestureGlobalVariables.GE["hold"]);
		//trace(GestureGlobalVariables.GE.NEWGESTURE);

		public function GWGestureEvent(type:String, data:Object, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			//trace(type,CUSTOM.NEW_GESTURE); 
			
			super(type, bubbles, cancelable);
			value = data;
			//data=data;
		}

		override public function clone():Event
		{
			return new GWGestureEvent(type, value, bubbles, cancelable); // add data object
		}

	}
}