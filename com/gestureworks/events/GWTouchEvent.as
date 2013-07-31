﻿////////////////////////////////////////////////////////////////////////////////
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
	import com.gestureworks.cml.utils.LinkedMap;
	import com.gestureworks.core.GestureWorks;
	import com.gestureworks.utils.MousePoint;
	import flash.display.InteractiveObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TouchEvent;
	import flash.utils.*;
	import org.tuio.TuioTouchEvent;

	public class GWTouchEvent extends TouchEvent
	{		
		private var sourceEvent:Event;
		
		public static const TOUCH_BEGIN : String = "gwTouchBegin";
		public static const TOUCH_END : String = "gwTouchEnd"
		public static const TOUCH_MOVE : String = "gwTouchMove"
		public static const TOUCH_OUT : String = "gwTouchOut"
		public static const TOUCH_OVER : String = "gwTouchOver"
		public static const TOUCH_ROLL_OUT : String = "gwTouchRollOut"
		public static const TOUCH_ROLL_OVER : String = "gwTouchRollOver"
		public static const TOUCH_TAP : String = "gwTouchTap";
		
		private static var TOUCH_TYPE_MAP: Dictionary = new Dictionary(); 
		
		TOUCH_TYPE_MAP[TouchEvent] = new LinkedMap();
		TOUCH_TYPE_MAP[TouchEvent].append(TouchEvent.TOUCH_BEGIN,TOUCH_BEGIN);		
		TOUCH_TYPE_MAP[TouchEvent].append(TouchEvent.TOUCH_END,TOUCH_END);		
		TOUCH_TYPE_MAP[TouchEvent].append(TouchEvent.TOUCH_MOVE,TOUCH_MOVE);		
		TOUCH_TYPE_MAP[TouchEvent].append(TouchEvent.TOUCH_OUT,TOUCH_OUT);		
		TOUCH_TYPE_MAP[TouchEvent].append(TouchEvent.TOUCH_OVER,TOUCH_OVER);		
		TOUCH_TYPE_MAP[TouchEvent].append(TouchEvent.TOUCH_ROLL_OUT,TOUCH_ROLL_OUT);		
		TOUCH_TYPE_MAP[TouchEvent].append(TouchEvent.TOUCH_ROLL_OVER,TOUCH_ROLL_OVER);			
		TOUCH_TYPE_MAP[TouchEvent].append(TouchEvent.TOUCH_TAP, TOUCH_TAP);
		
		TOUCH_TYPE_MAP[TuioTouchEvent] = new LinkedMap();
		TOUCH_TYPE_MAP[TuioTouchEvent].append(TuioTouchEvent.TOUCH_DOWN,TOUCH_BEGIN);		
		TOUCH_TYPE_MAP[TuioTouchEvent].append(TuioTouchEvent.TOUCH_UP,TOUCH_END);		
		TOUCH_TYPE_MAP[TuioTouchEvent].append(TuioTouchEvent.TOUCH_MOVE,TOUCH_MOVE);		
		TOUCH_TYPE_MAP[TuioTouchEvent].append(TuioTouchEvent.TOUCH_OUT,TOUCH_OUT);		
		TOUCH_TYPE_MAP[TuioTouchEvent].append(TuioTouchEvent.TOUCH_OVER,TOUCH_OVER);		
		TOUCH_TYPE_MAP[TuioTouchEvent].append(TuioTouchEvent.ROLL_OUT,TOUCH_ROLL_OUT);		
		TOUCH_TYPE_MAP[TuioTouchEvent].append(TuioTouchEvent.ROLL_OVER,TOUCH_ROLL_OVER);		
		TOUCH_TYPE_MAP[TuioTouchEvent].append(TuioTouchEvent.TAP,TOUCH_TAP);		
		
		TOUCH_TYPE_MAP[MouseEvent] = new LinkedMap();
		TOUCH_TYPE_MAP[MouseEvent].append(MouseEvent.MOUSE_DOWN,TOUCH_BEGIN);		
		TOUCH_TYPE_MAP[MouseEvent].append(MouseEvent.MOUSE_UP,TOUCH_END);		
		TOUCH_TYPE_MAP[MouseEvent].append(MouseEvent.MOUSE_MOVE,TOUCH_MOVE);		
		TOUCH_TYPE_MAP[MouseEvent].append(MouseEvent.MOUSE_OUT,TOUCH_OUT);		
		TOUCH_TYPE_MAP[MouseEvent].append(MouseEvent.MOUSE_OVER,TOUCH_OVER);		
		TOUCH_TYPE_MAP[MouseEvent].append(MouseEvent.ROLL_OUT,TOUCH_ROLL_OUT);		
		TOUCH_TYPE_MAP[MouseEvent].append(MouseEvent.ROLL_OVER,TOUCH_ROLL_OVER);				
		TOUCH_TYPE_MAP[MouseEvent].append(MouseEvent.CLICK,TOUCH_TAP);				
		
		/**
		 * Serves as an encompassing touch event for all input types as well as a utility for converting different input events. The <code>GWTouchEvent</code> can 
		 * be used as a proxy for the TouchEvent instances to bypass read-only accessor permissions (e.g. stageX and stageY). 
		 * @param	event  the event to convert 
		 * @param	type  the input event type to be evaluated and converted to a GWTouchEvent 
		 * @param	bubbles  
		 * @param	cancelable
		 * @param	touchPointID
		 * @param	isPrimaryTouchPoint
		 * @param	localX
		 * @param	localY
		 * @param	sizeX
		 * @param	sizeY
		 * @param	pressure
		 * @param	relatedObject
		 * @param	ctrlKey
		 * @param	altKey
		 * @param	shiftKey
		 */
		public function GWTouchEvent(event:Event, type:String = "touchBegin", bubbles:Boolean=true, cancelable:Boolean=false, touchPointID:int=0, isPrimaryTouchPoint:Boolean=false, localX:Number=NaN, localY:Number=NaN, sizeX:Number=NaN, sizeY:Number=NaN, pressure:Number=NaN, relatedObject:InteractiveObject=null, ctrlKey:Boolean=false, altKey:Boolean=false, shiftKey:Boolean=false)
		{
			super(resolveType(type), bubbles, cancelable, touchPointID, isPrimaryTouchPoint, localX, localY, sizeX, sizeY, pressure, relatedObject, ctrlKey, altKey, shiftKey);
			if(event)
				importEvent(event);
		}
		
		private var _bubbles:Boolean;
		public function set bubbles(v:Boolean):void { _bubbles = bubbles; }
		override public function get bubbles():Boolean { return _bubbles; }
		
		private var _cancelable:Boolean;
		public function set cancelable(v:Boolean):void { _cancelable = v; }
		override public function get cancelable():Boolean { return _cancelable; }
		
		private var _currentTarget:Object;
		public function set currentTarget(v:Object):void { _currentTarget = v; }
		override public function get currentTarget():Object { return _currentTarget; }
		
		private var _eventPhase:uint;
		public function set eventPhase(v:uint):void { _eventPhase = v; }
		override public function get eventPhase():uint { return _eventPhase; }
		
		private var _target:Object;
		public function set target(v:Object):void { _target = v; }
		override public function get target():Object { return _target; }
		
		private var _type:String;
		public function set type(v:String):void { _type = v; }
		override public function get type():String { return _type; }
			
		private var _stageX:Number;
		public function set stageX(v:Number):void { _stageX = v;}
		override public function get stageX():Number { return _stageX; }
		
		private var _stageY:Number;
		public function set stageY(v:Number):void { _stageY = v;}
		override public function get stageY():Number { return _stageY; }		

		override public function clone():Event
		{
			return new GWTouchEvent(sourceEvent, type, bubbles, cancelable, touchPointID, isPrimaryTouchPoint, localX, localY, sizeX, sizeY, pressure, relatedObject, ctrlKey, altKey, shiftKey);
		}
		
		/**
		 * Converts the event to a GWTouchEvent by synchronizing the properties
		 * @param	event
		 */
		private function importEvent(event:Event):void
		{ 
			sourceEvent = event;
			var sourceInfo:XML = describeType(event);
			var prop:XML;
			var propName:String;
			var eventType:Class = Class(getDefinitionByName(getQualifiedClassName(event)));
			
			if (eventType == MouseEvent)
				touchPointID = MousePoint.getID();
			else if (eventType == TuioTouchEvent)
				touchPointID = TuioTouchEvent(event).tuioContainer.sessionID;

			for each(prop in sourceInfo.accessor) {
				propName = String(prop.@name);
				
				if (this.hasOwnProperty(propName))
				{
					if (propName == "type") 
						this[propName] = TOUCH_TYPE_MAP[eventType].getKey(event[propName]);
					else
						this[propName] = event[propName];
				}
			}	
		}
		
		/**
		 * Translate touch type to GWTouchEvent type. 
		 * @param	type  TUIO, native touch, mouse, or GWTouchEvent
		 * @return
		 */
		private function resolveType(type:String):String
		{
			var key:Class = TOUCH_TYPE_MAP[TuioTouchEvent].hasKey(type) ? TuioTouchEvent : TOUCH_TYPE_MAP[TouchEvent].hasKey(type) ? TouchEvent : TOUCH_TYPE_MAP[MouseEvent].hasKey(type) ? MouseEvent : null;
			var resolvedType:String = key && TOUCH_TYPE_MAP[key].hasKey(type) ? TOUCH_TYPE_MAP[key].getKey(type): type;
			return resolvedType;
		}
		
		/**
		 * Translate GWTouchEvent to appropriate touch type.
		 * @param	type
		 * @return
		 */
		public static function eventTypes(type:String):Array
		{
			var types:Array = [];
			if (GestureWorks.activeTUIO)
				types.push(TOUCH_TYPE_MAP[TuioTouchEvent].getKeyArray()[TOUCH_TYPE_MAP[TuioTouchEvent].getValueArray().indexOf(type)]);
			if (GestureWorks.activeNativeTouch)
				types.push(TOUCH_TYPE_MAP[TouchEvent].getKeyArray()[TOUCH_TYPE_MAP[TouchEvent].getValueArray().indexOf(type)]);
			if (GestureWorks.activeSim)
				types.push(TOUCH_TYPE_MAP[MouseEvent].getKeyArray()[TOUCH_TYPE_MAP[MouseEvent].getValueArray().indexOf(type)]);
			return types;
		}
		
	}
}