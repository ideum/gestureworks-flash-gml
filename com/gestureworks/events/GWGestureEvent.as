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
	import flash.utils.describeType
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;

	public class GWGestureEvent extends Event
	{
		public var value:Object;
		public var data:Object;
		
		public static var GESTURELIST_UPDATE:String = "gesturelist update";
		public static var START:String = "start";
		public static var COMPLETE:String = "complete";
		public static var RELEASE:String = "release";
		
		
		
		
		// TOUCH kine-metric
		public static var MANIPULATE:String = "manipulate";
		public static var DRAG:String = "drag";
		public static var SWIPE:String = "swipe";
		public static var SCROLL:String = "scroll";
		public static var FLICK:String = "flick";
		public static var ROTATE:String= "rotate";
		public static var SCALE:String = "scale";
		public static var PIVOT:String = "pivot";
		public static var TILT:String = "tilt";
		//public static var SPIRAL:String = "spiral";
		//public static var SPLIT:String = "split";
		
		// TOUCH temproal-metric
		public static var HOLD:String = "hold";
		public static var TAP:String = "tap";
		public static var DOUBLE_TAP:String = "double_tap";
		public static var TRIPLE_TAP:String = "triple_tap";
		//public static var PRESURE_TAP:String = "presure_tap";
		//public static var RYTHM_TAP:String = "rythm_tap";
		
		// TOUCH geo-metric
		public static var ORIENT:String = "orient";
		
		// TOUCH vector-metric
		public static var STROKE:String = "stroke";
		public static var STROKE_LETTER:String = "stroke_letter";
		public static var STROKE_GREEK:String = "stroke_greek";
		public static var STROKE_SYMBOL:String = "stroke_symbol";
		public static var STROKE_SHAPE:String = "stroke_shape";
		public static var STROKE_NUMBER:String = "stroke_number";
		
		////////////////////////////////////////////////////////////
		// serial TOUCH gestures (anchor)// HOLD + TAP
		////////////////////////////////////////////////////////////
		//public static var HOLD_TAP:String = "hold_tap";
		//public static var HOLD_FLICK:String = "hold_drag";
		//public static var HOLD_ROTATE:String = "hold_rotate";
		//public static var HOLD_SCALE:String = "hold_scale";
		//public static var HOLD_FLICK:String = "hold_flick";
		//public static var HOLD_STROKE:String = "hold_stroke";
		
		///////////////////////////////////////////////////////////
		// gloabal TOUCH gestures
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
		

		////////////////////////////////////////////////////////////
		// FINGER
		////////////////////////////////////////////////////////////
		public static var TOUCH_FINGER_MANIPULATE:String = "touch_finger_manipulate";
		public static var TOUCH_FINGER_DRAG:String = "touch_finger_drag";
		public static var TOUCH_FINGER_SWIPE:String = "touch_finger_swipe";
		public static var TOUCH_FINGER_SCROLL:String = "touch_finger_scroll";
		public static var TOUCH_FINGER_FLICK:String = "touch_finger_flick";
		public static var TOUCH_FINGER_ROTATE:String= "touch_finger_rotate";
		public static var TOUCH_FINGER_SCALE:String = "touch_finger_scale";
		public static var TOUCH_FINGER_PIVOT:String = "touch_finger_pivot";
		public static var TOUCH_FINGER_TILT:String = "touch_finger_tilt";
		public static var TOUCH_FINGER_HOLD:String = "touch_finger_hold";
		public static var TOUCH_FINGER_TAP:String = "touch_finger_tap";
		public static var TOUCH_FINGER_DOUBLE_TAP:String = "touch_finger_double_tap";
		public static var TOUCH_FINGER_ORIENT:String = "touch_finger_orient";
		
		////////////////////////////////////////////////////////////
		// PEN/STYLUS
		////////////////////////////////////////////////////////////
		public static var TOUCH_PEN_MANIPULATE:String = "touch_pen_manipulate";
		public static var TOUCH_PEN_DRAG:String = "touch_pen_drag";
		public static var TOUCH_PEN_SWIPE:String = "touch_pen_swipe";
		public static var TOUCH_PEN_SCROLL:String = "touch_pen_scroll";
		public static var TOUCH_PEN_FLICK:String = "touch_pen_flick";
		public static var TOUCH_PEN_ROTATE:String= "touch_pen_rotate";
		public static var TOUCH_PEN_SCALE:String = "touch_pen_scale";
		public static var TOUCH_PEN_PIVOT:String = "touch_pen_pivot";
		public static var TOUCH_PEN_TILT:String = "touch_pen_tilt";
		public static var TOUCH_PEN_HOLD:String = "touch_pen_hold";
		public static var TOUCH_PEN_TAP:String = "touch_pen_tap";
		public static var TOUCH_PEN_DOUBLE_TAP:String = "touch_pen_double_tap";
		public static var TOUCH_PEN_ORIENT:String = "touch_pen_orient";
		
		////////////////////////////////////////////////////////////
		// TAG/FIDUCIAL/DOMINO
		////////////////////////////////////////////////////////////
		public static var TOUCH_TAG_MANIPULATE:String = "touch_tag_manipulate";
		public static var TOUCH_TAG_DRAG:String = "touch_tag_drag";
		public static var TOUCH_TAG_SWIPE:String = "touch_tag_swipe";
		public static var TOUCH_TAG_SCROLL:String = "touch_tag_scroll";
		public static var TOUCH_TAG_FLICK:String = "touch_tag_flick";
		public static var TOUCH_TAG_ROTATE:String= "touch_tag_rotate";
		public static var TOUCH_TAG_SCALE:String = "touch_tag_scale";
		public static var TOUCH_TAG_PIVOT:String = "touch_tag_pivot";
		public static var TOUCH_TAG_TILT:String = "touch_tag_tilt";
		public static var TOUCH_TAG_HOLD:String = "touch_tag_hold";
		public static var TOUCH_TAG_TAP:String = "touch_tag_tap";
		public static var TOUCH_TAG_DOUBLE_TAP:String = "touch_tag_double_tap";
		public static var TOUCH_TAG_ORIENT:String = "touch_tag_orient";
		
		

		/////////////////////////////////////////////////////////////////////////////
		// GENERIC MOTION GESTURES
		// COULD MAKE CASE THAT ANY BODY PART COULD DRAG/TRANSLATE OR WAVE
		// SO MOTION SHOULD BE IP AGNOSTIC
		public static var MOTION_MANIPULATE:String = "motion_manipulate";
		public static var MOTION_DRAG:String = "motion_drag";
		public static var MOTION_SWIPE:String = "motion_swipe";
		public static var MOTION_SCROLL:String = "motion_scroll";
		public static var MOTION_FLICK:String = "motion_flick";
		public static var MOTION_ROTATE:String= "motion_rotate";
		public static var MOTION_SCALE:String = "motion_scale";
		public static var MOTION_TILT:String = "motion_tilt";
		
		public static var MOTION_HOLD:String = "motion_hold"; 
		public static var MOTION_TAP:String = "motion_tap"; 
		public static var MOTION_DOUBLE_TAP:String = "motion_double_tap"; 
		public static var MOTION_XTAP:String = "motion_xtap"; 
		public static var MOTION_YTAP:String = "motion_ytap"; 
		public static var MOTION_ZTAP:String = "motion_ztap"; 
		
		
		
		/////////////////////////////////////////////////////////////////////////////
		// HAND MOTION GESTURES
		// PINCH/
		public static var MOTION_PINCH_MANIPULATE:String = "motion_pinch_manipulate";
		public static var MOTION_PINCH_DRAG:String = "motion_pinch_drag";
		public static var MOTION_PINCH_SWIPE:String = "motion_pinch_swipe";
		public static var MOTION_PINCH_SCROLL:String = "motion_pinch_scroll";
		public static var MOTION_PINCH_FLICK:String = "motion_pinch_flick";
		public static var MOTION_PINCH_ROTATE:String= "motion_pinch_rotate";
		public static var MOTION_PINCH_SCALE:String = "motion_pinch_scale";
		public static var MOTION_PINCH_TILT:String = "motion_pinch_tilt";
		public static var MOTION_PINCH_HOLD:String = "motion_pinch_hold"; 
		public static var MOTION_PINCH_TAP:String = "motion_pinch_tap"; 
		public static var MOTION_PINCH_DOUBLE_TAP:String = "motion_pinch_double_tap"; 
		public static var MOTION_PINCH_XTAP:String = "motion_pinch_xtap"; 
		public static var MOTION_PINCH_YTAP:String = "motion_pinch_ytap"; 
		public static var MOTION_PINCH_ZTAP:String = "motion_pinch_ztap"; 
	
		// TRIGGER
		public static var MOTION_TRIGGER_MANIPULATE:String = "motion_trigger_manipulate";
		public static var MOTION_TRIGGER_DRAG:String = "motion_trigger_drag";
		public static var MOTION_TRIGGER_SWIPE:String = "motion_trigger_swipe";
		public static var MOTION_TRIGGER_SCROLL:String = "motion_trigger_scroll";
		public static var MOTION_TRIGGER_FLICK:String = "motion_trigger_flick";
		public static var MOTION_TRIGGER_ROTATE:String= "motion_trigger_rotate";
		public static var MOTION_TRIGGER_SCALE:String = "motion_trigger_scale";
		public static var MOTION_TRIGGER_TILT:String = "motion_trigger_tilt";
		public static var MOTION_TRIGGER_HOLD:String = "motion_trigger_hold"; 
		public static var MOTION_TRIGGER_TAP:String = "motion_trigger_tap"; 
		public static var MOTION_TRIGGER_DOUBLE_TAP:String = "motion_trigger_double_tap"; 
		public static var MOTION_TRIGGER_XTAP:String = "motion_trigger_xtap"; 
		public static var MOTION_TRIGGER_YTAP:String = "motion_trigger_ytap"; 
		public static var MOTION_TRIGGER_ZTAP:String = "motion_trigger_ztap"; 
		
		// FINGER// THUMB// PALM/ FRAME
		
	
		////////////////////////////////////////////////////////////////////////////
		// BODY MOTION GESTURES
			//config
				// bent, straight, flat, open, closed
				// crouch, raised, stretch,
				// sit, stand, balance, orientation, front, back, side
			// movement
				// tap, rub, hold, clap, slap, wink, blink, punch, wave, grab
				// periodic, harmonic, complimentary,
				// spin, rotate, tilt
				// spread, splay, split, scale
				// skid, slide, flick
				// push, pull, pan, 
			/*
			public static var MOTION_BODY_ARM_WAVE:String = "motion_boday_arm_wave"; // pivoted periodic motion
			public static var MOTION_BODY_HAND_CLAP:String = "motion_boday_"; //tap variant 
			public static var MOTION_BODY_HAND_HOLD:String = "motion_boday_"; //hold variant
			public static var MOTION_BODY_HAND_TAP:String = "motion_boday_"; //tap variant// could tap body any part
			public static var MOTION_BODY_HAND_RUB:String = "motion_boday_"; //periodic tap variant
			public static var MOTION_BODY_LEG_KICK:String = "motion_boday_"; //foot flick
			public static var MOTION_BODY_HEAD_NOD:String = "motion_boday_"; //heap vtap
			public static var MOTION_BODY_HEAD_SHAKE:String = "motion_boday_"; //head htap
			//FACE //////////////////////////////////////////////////////////////////////
			public static var MOTION_BODY_FACE_SMILE:String = "motion_boday_"; // pattern match
			public static var MOTION_BODY_FACE_FROWN:String = "motion_boday_";  // pattern match
			public static var MOTION_BODY_FACE_MATCH:String = "motion_boday_";  //pattern match
			//EYE //////////////////////////////////////////////////////////////////////
			public static var MOTION_BODY_EYE_WINK:String = "motion_boday_";  //eye tap
			public static var MOTION_BODY_EYE_BLINK:String = "motion_boday_";  // eye tap
		
		
		
		/////////////////////////////////////////////////////////////////////////////////////
		// SENSOR GESTURES
		/////////////////////////////////////////////////////////////////////////////////////
		//public static var SENSOR_ROTATE:String = "sensor_rotate"; //accelerometer rotate
		//public static var SENSOR_SELECT:String = "sensor_select"; //voice select
		
		//public static var SENSOR_PITCH:String = "sensor_pitch"; //accelerometer rotate
		//public static var SENSOR_ROLL:String = "sensor_roll"; //accelerometer rotate
		//public static var SENSOR_YAW:String = "sensor_yaw"; //accelerometer rotate
		//public static var SENSOR_FLICK:String = "sensor_flick"; //accelerometer flick
		//public static var SENSOR_DRAG:String = "sensor_drag"; //accelerometer drag
		//public static var SENSOR_TILTX:String = "sensor_tiltx"; //accelerometer rotate
		
		//VOICE //////////////////////////////////////////////////////////////////////////////
		public static var SENSOR_VOICE_PHRASE_MATCH:String = "sensor_phrase_match"; //voice select
		public static var SENSOR_VOICE_PHRASE_START:String = "sensor_phrase_start"; //voice select
		public static var SENSOR_VOICE_PHRASE_END:String = "sensor_phrase_end"; //voice select
		
		// CONTROLLER ////////////////////////////////////////////////////////////////////////
		public static var SENSOR_CONTROLLER_FLICK:String = "controller_flick"; 
		public static var SENSOR_CONTROLLER_SCROLL:String = "controller_scroll"; 
		public static var SENSOR_CONTROLLER_SCALE:String = "controller_scale";
		public static var SENSOR_CONTROLLER_ROTATE:String = "controller_rotate"; 
		public static var SENSOR_CONTROLLER_TILT:String = "controller_tilt"; 
		
		public static var SENSOR_CONTROLLER_DPAD_UP:String = "controller_dpad_up";
		public static var SENSOR_CONTROLLER_DPAD_DOWN:String = "controller_dpad_down"; 
		public static var SENSOR_CONTROLLER_DPAD_LEFT:String = "controller_dpad_left"; 
		public static var SENSOR_CONTROLLER_DPAD_RIGHT:String = "controller_dpad_right"; 
		public static var SENSOR_CONTROLLER_TRIGGER_LEFT:String = "controller_trigger_left"; 
		public static var SENSOR_CONTROLLER_TRIGGER_RIGHT:String = "controller_trigger_right"; 
		
		public static var SENSOR_CONTROLLER_BUTTON_PRESS:String = "controller_button_press"; //voice select
		public static var SENSOR_CONTROLLER_BUTTON_RELEASE:String = "controller_button_release"; //voice select
		public static var SENSOR_CONTROLLER_BUTTON_SLIDER:String = "controller_button_slider"; //voice select
		public static var SENSOR_CONTROLLER_BUTTON_DIAL:String = "controller_button_dial"; //voice select
		
		*/
		
		
		
		
		
		
		public static var CUSTOM:Object = 
			{
				//SEED_GESTURE:"seed gesture",
			};

		public function GWGestureEvent(type:String, data:Object, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			super(type, bubbles, cancelable);
			value = data;
		}

		override public function clone():Event
		{
			return new GWGestureEvent(type, value, bubbles, cancelable); // add data object
		}

		/**
		 * Determines if the provided type is a GWGestureEvent type
		 * @param	type
		 * @return
		 */		
		public static function isType(type:String):Boolean {
			for each(var prop:XML in describeType(GWGestureEvent).variable) {
				if (GWGestureEvent[prop.@name] == type)
					return true;
			}
			return false;
		}
	}
}