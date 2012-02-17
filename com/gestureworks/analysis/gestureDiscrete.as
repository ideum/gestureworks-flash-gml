////////////////////////////////////////////////////////////////////////////////
//
//  IDEUM
//  Copyright 2011-2012 Ideum
//  All Rights Reserved.
//
//  GestureWorks
//
//  File:    gestureDiscrete.as
//  Authors:  Ideum
//             
//  NOTICE: Ideum permits you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////
package com.gestureworks.analysis 
{
	import flash.events.TouchEvent;
	
	//import com.gestureworks.core.TouchSprite;
	import com.gestureworks.core.GestureGlobals;
	import com.gestureworks.core.GestureWorks;
	import com.gestureworks.core.gw_public;
	import com.gestureworks.core.GML;
	import com.gestureworks.objects.FrameObject;
	import com.gestureworks.events.GWEvent;
	import com.gestureworks.events.GWGestureEvent;
		
	public class gestureDiscrete
	{
		private var touchObjectID:int;
		private var ts:Object;//	private var ts:TouchSprite;
		private var pointEventArray:Array = new Array();
		private var pointList:Array;
		private var N:int = 0;
		
		//private var fps = 60;
		private var rate:Number = 1 / 60;
		
		public function gestureDiscrete(_id:int) {
			
			touchObjectID = _id;
			init();
		}
		
		public function init():void
		{
			ts = GestureGlobals.gw_public::touchObjects[touchObjectID];
			
			if(ts.trace_debug_mode) trace("init gesture discrete analysis");
		}
		
		///////bug bug bug //////////////////////////////////////
		///////////////////////////////////////////////////////////
		// waiting for touch move to trigger analysis
		/////////////////////////////////////////////////
		public function holdMonitor():void
		{
			N = ts.cO.n;
			pointList = ts.cO.pointArray;
			
			//if (ts.trace_debug_mode) trace("find hold---------------------------------------------------------");
				
			if((N)&&(pointList)){
				var hold_dist:int = ts.gO.pOList["hold"].point_translation_threshold;
				var	hold_time:int = Math.ceil(ts.gO.pOList["hold"].point_event_duration_threshold * GestureWorks.application.frameRate * 0.001);
				
				// check point list for hold monitoring
				for (var i:int = 0; i < N; i++) 
					{
						//trace("oef", pointList[i].touchPointID);
						if (pointList[i].holdMonitorOn)
						{
							pointList[i].holdCount++;
							// check monitor count
							if (pointList[i].holdCount >= hold_time) 
							{
								//trace("dispatch");
								ts.dispatchEvent(new GWGestureEvent(GWGestureEvent.HOLD, { x: pointList[i].point.x, y:pointList[i].point.y, touchPointID:pointList[i].point.touchPointID} ));
								if(ts.tiO.pointEvents)ts.tiO.frame.gestureEventArray.push(new GWGestureEvent(GWGestureEvent.HOLD, { x: pointList[i].point.x, y:pointList[i].point.y, touchPointID:pointList[i].point.touchPointID} ));
								pointList[i].holdMonitorOn = false;
								pointList[i].holdCount = 0;
								return;	
							}
							// test for exessive movement
							else {
								if (pointList[i].history[0])
								{
									if ((Math.abs(pointList[i].history[0].dx) > hold_dist) || (Math.abs(pointList[i].history[0].dy) > hold_dist))
									{
										//trace("no");
										pointList[i].holdMonitorOn = false;
										pointList[i].holdCount = 0;
										return;	
									}
								}
							}
						}
				}
			}
		}
		
		public function findTimelineHoldEvent(event:TouchEvent):void
		{
			GestureGlobals.gw_public::points[event.touchPointID].holdMonitorOn = true;
		}
		
		////////////////////////////////////////////////////////////
		// NOTE HISTORY BUG
		// tiO.history[i]
		// USING FRAME FOR HISTORY[0]
		// MAKE MORESPECIFIC 
		// USE TAP_DIST AND TAP_TIME TO CREATER A MORE RIGID TAP GESTURE
		// ALSO USE TO DEFFERENTIATE BETWEEN TWO FINGER DELAYED TAP AND SINGLE FINGER DOUBLE TAP
		public function findTimelineTapEvent(event:TouchEvent):void
		{
			if (ts.trace_debug_mode) trace("find tap---------------------------------------------------------");
			
			//var tap_time:int = 18//gO.pOList["tap"]["tap_x"].point_event_duration_threshold;
			//var tap_dist:int = ts.gO.pOList["tap"].point_translation_threshold;
			
			if (ts.tiO.frame)
				{
				var pointEventArray:Array = ts.tiO.frame.pointEventArray;
				//trace(tiO.frame.pointEventArray);
						
					for (var j:int = 0; j < pointEventArray.length; j++) 
						{
						var touch_event:Object = pointEventArray[j]
						if (touch_event.type =="touchTap")
							{
								//trace("tap",j, touch_event.touchPointID);
								ts.dispatchEvent(new GWGestureEvent(GWGestureEvent.TAP, { x: touch_event.stageX, y:touch_event.stageY, touchPointID:touch_event.touchPointID } ));
								if(ts.tiO.pointEvents)ts.tiO.frame.gestureEventArray.push(new GWGestureEvent(GWGestureEvent.TAP, { x: touch_event.stageX, y:touch_event.stageY, touchPointID:touch_event.touchPointID } ));
							}
						}
				}
		}
		
		
		public function findTimelineDoubleTapEvent(event:TouchEvent):void
		{
			if (ts.trace_debug_mode) trace("find taps---------------------------------------------------------");
				
				var dtap_time:int = Math.ceil(ts.gO.pOList["double_tap"].point_interevent_duration_threshold * GestureWorks.application.frameRate * 0.001);
				var dtap_dist:int = ts.gO.pOList["double_tap"].point_translation_threshold;
				var tap_count:int = 0;
			
				for (var i:int = 1; i < dtap_time; i++) 
					{
					if (ts.tiO.history[i])
					{
						var	pointEventArray:Array = ts.tiO.history[i].pointEventArray;
							
							for (var j:int = 0; j < pointEventArray.length; j++) 
								{
									var touch_event:Object = pointEventArray[j]
									if (touch_event.type =="touchTap")
									{
										var distX:Number = Math.abs(event.stageX - touch_event.stageX);
										var distY:Number = Math.abs(event.stageY - touch_event.stageY);
											
										//if((distX<rad)&&(distY<rad)) trace("double tap", i, j, touch_event.touchPointID, distX, distY);
										//trace("double tap", i, j, touch_event.touchPointID);
										ts.dispatchEvent(new GWGestureEvent(GWGestureEvent.DOUBLE_TAP, { x:touch_event.stageX , y:touch_event.stageY, touchPointID:touch_event.touchPointID } ));
										if(ts.tiO.pointEvents)ts.tiO.frame.gestureEventArray.push(new GWGestureEvent(GWGestureEvent.DOUBLE_TAP, { x:touch_event.stageX, y:touch_event.stageY, touchPointID:touch_event.touchPointID } ));
									}
								}
						}
					}
		}
		
		public function findTimelineTripleTapEvent(event:TouchEvent):void
		{
			if (ts.trace_debug_mode) 	trace("find tripple taps---------------------------------------------------------");
			
				var tap_count:int = 0;
				var ttap_time:int = Math.ceil(ts.gO.pOList["triple_tap"].point_interevent_duration_threshold * GestureWorks.application.frameRate * 0.001);
				var ttap_dist:int = ts.gO.pOList["triple_tap"].point_translation_threshold;
				
				for (var i:int = 1; i < 2*ttap_time; i++) 
					{
					if (ts.tiO.history[i])
					{
						var pointEventArray:Array = ts.tiO.history[i].pointEventArray;
				
							for (var j:int = 0; j < pointEventArray.length; j++) 
								{
									var touch_event:Object = pointEventArray[j]
									if (touch_event.type =="touchTap")
									{
										var distX:Number = Math.abs(event.stageX - touch_event.stageX);
										var distY:Number = Math.abs(event.stageY - touch_event.stageY);
											
										if ((distX < ttap_dist) && (distY < ttap_dist)) tap_count++;
									}
								}
						}
					}
					if (tap_count == 2)
					{ 
						//trace("triple tap", i, j, touch_event.touchPointID, distX, distY);
						ts.dispatchEvent(new GWGestureEvent(GWGestureEvent.TRIPLE_TAP, { x:touch_event.stageX, y:touch_event.stageX, touchPointID:touch_event.touchPointID } ));
						if(ts.tiO.pointEvents)ts.tiO.frame.gestureEventArray.push(new GWGestureEvent(GWGestureEvent.TRIPLE_TAP, { x:touch_event.stageX, y:touch_event.stageY, touchPointID:touch_event.touchPointID } ));
					}
		}
		
		public function findTimelineGestures():void
		{
		 // collects gestures fired in sequence accross the timline
		 
		 // collects gestures across the timline (sequence independant)
		 
		}
		
		
		
	}
}