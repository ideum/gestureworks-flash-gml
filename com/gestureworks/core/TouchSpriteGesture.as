﻿////////////////////////////////////////////////////////////////////////////////
//
//  IDEUM
//  Copyright 2011-2012 Ideum
//  All Rights Reserved.
//
//  GestureWorks
//
//  File:    TouchSpriteGesture.as
//  Authors:  Ideum
//             
//  NOTICE: Ideum permits you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////
package com.gestureworks.core
{
	//import com.adobe.utils.IntUtil;
	import flash.events.TouchEvent;
	import flash.geom.Point;
	
	import com.gestureworks.events.GWEvent;
	import com.gestureworks.events.GWGestureEvent;
	import com.gestureworks.analysis.gestureContinuous;
	import com.gestureworks.analysis.gestureDiscrete;
	
	import com.gestureworks.managers.TimelineHistories;
	import com.gestureworks.objects.FrameObject; 
	import com.gestureworks.objects.PropertyObject;
	
	import flash.utils.Timer;
	import flash.system.System;
	import flash.events.*;
	
	public class TouchSpriteGesture extends TouchSpriteProcessor
	{
		/**
		* @private
		*/
		//internal public
		public var gesture_cont:gestureContinuous;
		/**
		* @private
		*/
		public var gesture_disc:gestureDiscrete;
		/**
		* @private
		*/
		private var contGesturemetricsOn:Boolean = true;
		/**
		* @private
		*/
		private var discGesturemetricsOn:Boolean = true;
		/**
		* @private
		*/
		private var key:String;
		
		private var discrete_dispatch_reset:Boolean = false;
		
		private var gesture_start_dispatched:Boolean = false;
		private var gesture_complete_dispatched:Boolean = false;
		private var gesture_release_dispatched:Boolean = false;
		
		private var tapOn:Boolean = false;
		/////////////////////////////////////////////////////////
		
		public function TouchSpriteGesture():void
		{
			super();
			initGesture();
         }
		 
		// initializers   
         public function initGesture():void 
         {
			if(trace_debug_mode) trace("create touchsprite gesture");
			
			initGestureVars();
			initGestureAnalysis();
		}
		
		/**
		* @private
		*/
		public function initGestureVars():void 
		{
			// set constructor logic with GML
			contGesturemetricsOn = true;
			discGesturemetricsOn = true;
		}
		/**
		* @private
		*/
		public function initGestureAnalysis():void //clusterObject:Object
		{
			if (trace_debug_mode) trace("init gesture analysis", touchObjectID);
			
			// configure gesturelist from listener attachment
			//if (hasEventListener(GWGestureEvent.DRAG)) trace("has drag listener");
			//hasEventListener(GWGestureEvent.SCALE, scaleHandeler);
			//hasEventListener(GWGestureEvent.ROTATE, rotateHandeler);
			
			
			

			// analyze for continuous gesturing
			if(contGesturemetricsOn){
				gesture_cont = new gestureContinuous(touchObjectID);
				//gesture_cont.init();
             }
			// analyze for descrete gesture sequence/series
			if(discGesturemetricsOn){
				gesture_disc = new gestureDiscrete(touchObjectID);
				//initTimeline();
			}
			// analyze for gesture conflict/compliment
		}
		
		/**
		* @private
		*/
		public function initTimeline():void
		{
			for (key in gO.pOList)
			{
				
				if (!tiO.timelineOn)
				{
					if ((gO.pOList[key].gesture_type == "stroke")||(gO.pOList[key].gesture_type == "swipe")||(gO.pOList[key].gesture_type == "flick")||(gO.pOList[key].gesture_type == "hold")||(gO.pOList[key].gesture_type == "tap")||(gO.pOList[key].gesture_type == "double_tap")||(gO.pOList[key].gesture_type == "triple_tap"))
					{
						tiO.timelineOn = true;
						tiO.pointEvents = true;
						tiO.timelineInit = true;
						GestureGlobals.timelineHistoryCaptureLength = 80;
					}
					else {
						tiO.timelineOn = false;
						tiO.pointEvents = false;
					}
				}
				
				//MAKE GML PROGRAMMABLE SET GLOBAL POINT HISTORY
				
				if (gO.pOList[key].gesture_type == "stroke")
				{
					if ((gO.pOList[key]) && (gestureList[key])) GestureGlobals.pointHistoryCaptureLength = 150; // define in GML
				}
				//trace("tsgesture, timelineon:",tiO.timelineOn, tiO.timelineInit);
			}	
		}
		
		/**
		* @private
		*/
		//////////////////////////////////////////////////////
		// currently not used
		// intended for non tap gestures that require timeline 
		// analysis like gesture sequencing
		//////////////////////////////////////////////////////
		private function updateTimelineGestureAnalysis():void
		{
			//trace("update timeline gesture analysis");
			//if ((discGesturemetricsOn) && (tiO.timelineOn)) 
			//{
					gesture_disc.findTimelineGestures();
			//}
		}
		/**
		* @private
		*/
		public function updateGestureAnalysis():void
		{	
			if ((N) || (!gO.gestureTweenOn)) 
			{
				if (trace_debug_mode) trace("update gesture analysis");
				if (contGesturemetricsOn)
				{
					gesture_cont.findGestures();
					if (_gestureEvents) manageGestureEventDispatch();
				}
			}
			
			//if (!tiO.timelineInit) initTimeline();
			//else 
			//onGestureEnterTouchFrame();
		}
		/**
		* @private
		*/
		public function updateGestureValues():void
		{
			if (gestureReleaseInertia)
			{
				if(trace_debug_mode) trace("update gesture values");
				if ((gO.gestureTweenOn)&&(gO.gestureRelease))
				{
					if (contGesturemetricsOn)
					{
						
						gesture_cont.processTweenPipeline();
						//gesture_cont.processPipeline();
						//gesture_cont.applyGestureValueTween(); 	
						//gesture_cont.applyGestureValueTween(); 			// decay gesture deltas
						//gesture_cont.limitGestureProperties();			// ensure limits are not exceeded
						
						//////////////////////////////////
						// test
						//--gesture_cont.mapTransformLimits();
						//--gesture_cont.limitGestureValues();
						/////////////////////////////////
						
						//--gesture_cont.mapTransformProperties();
						//gesture_cont.limitTransformProperties();
						if (_gestureEvents) manageGestureEventDispatch();		// dispatch gesture events
					}
				}
			}
		}
		/**
		* @private
		*/
		public function restartGestureTween():void
		{
			gesture_cont.restartGestureTween();
		}
		/**
		* @private
		*/
		public function resetGestureTween():void
		{
			gesture_cont.resetGestureTween();
		}
		/**
		* @private
		*/
		private function manageGestureEventDispatch():void 
		{
				//ONLY FIRES IF TOUCHING OBJECT 
				//--discrete_dispatch_reset = false
				
				
				//gestureContinuousEventDispatch();
				//onGestureEnterTouchFrame();
				
				
				//--if (!tiO.timelineInit) initTimeline();
			//else 
			
			onEnterTouchFrame();
			
		}
		
		
		////////////////////////////////////////////////////////////////////////////////////
		///////////////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////////
		
		/**
		* @private
		*/
		public function onTouchEnd(event:TouchEvent):void
		{
			trace("touch end");
			for (key in gO.pOList)
			{
				if ((gO.pOList[key].gesture_type == "tap")||(gO.pOList[key].gesture_type == "double_tap")||(gO.pOList[key].gesture_type == "triple_tap"))
				{
					if ((gO.pOList[key]) && (gestureList[key])) tapOn = true;
				}
				
				if (gO.pOList[key].gesture_type == "hold")	gO.pOList[key].complete = false;  // resets hold gesture
			}
			
			
			if (tapOn) gesture_disc.findGestureTap(event,key); // tap event pairs
			
		}
		
		
		public function onGestureTap(event:GWGestureEvent):void
		{
			//trace("on gesture tap");
			
			for (key in gO.pOList) 
			{	
				// double taps
				if (gO.pOList[key].gesture_type == "double_tap") 	gesture_disc.findGestureDoubleTap(event, key);
				// triple taps
				if (gO.pOList[key].gesture_type == "triple_tap")	gesture_disc.findGestureTripleTap(event,key);

			}
		}
		
		
	
		//public function onGestureEnterTouchFrame():void
		//{
			//trace("on gesture enter frame");
			
			/*
			
			// MANAGE TIMELINE
			if (tiO.timelineOn)
			{
				if (trace_debug_mode) trace("timeline frame update");
				TimelineHistories.historyQueue(clusterID);			// push histories 
				tiO.frame = new FrameObject();						// create new timeline frame //trace("manage timeline");
			}
			
			
			// MANAGE DICRETE EVENT DISPATCHING
			// when released and if hasnt already fired
			//if (!discrete_dispatch_reset){
				
						// GESTURE OBJECT EVENTS
						// start gesturing
						if ((gO.start)&&(_gestureEventStart)&&(!gesture_start_dispatched))
						{
							dispatchEvent(new GWGestureEvent(GWGestureEvent.START, gO.id));
							if((tiO.timelineOn)&&(tiO.gestureEvents))	tiO.frame.gestureEventArray.push(new GWGestureEvent(GWGestureEvent.START, gO.id));
							gO.start = false;
							gO.release = false;
							gesture_start_dispatched = true;
							//trace("start fired");
						}
				*/
						
				
					///////////////////////////////////////////////////////
					// release event trigger
					///////////////////////////////////////////////////////

					//trace("release",gO.release);
					/*
					
					if (gO.release)
					{	
						for (key in gO.pOList) 
						{	
							
							
							//tap counter
							if (gO.pOList[key].gesture_type == "tap")
							{
								if ((gO.pOList[key]) && (gestureList[key])) gesture_disc.countTapEvents(key);
							}
							// double tap counter
							if (gO.pOList[key].gesture_type == "double_tap")
							{
								if ((gO.pOList[key]) && (gestureList[key])) gesture_disc.countDoubleTapEvents(key);
							}
							// triple tap counter
							if (gO.pOList[key].gesture_type == "triple_tap")
							{
								if ((gO.pOList[key]) && (gestureList[key])) gesture_disc.countTripleTapEvents(key);
							}
							
							
							// gesture flick
							if (gO.pOList[key].gesture_type == "flick")
							{	
								if ((gO.pOList[key])&&(gestureList[key]))
								{
									
									//if(cO.history[0]){
									// CALLS PREVIOUSLY CALCULATED FLICK VALUE FROM LAST FRAME BEFORE RELEASE
									//var flick_dx:Number = cO.history[0].flick_dx//cO.history[0].ddx//gO.pOList[key]["flick_dx"].gestureDelta;
									//var flick_dy:Number = cO.history[0].flick_dy//cO.history[0].ddy//gO.pOList[key]["flick_dy"].gestureDelta;
									//var flick_dx:Number = gO.pOList[key]["flick_dx"].gestureDelta;
									//var flick_dy:Number = gO.pOList[key]["flick_dy"].gestureDelta;
									var flick_dx:Number = gO.pOList[key]["flick_dx"].clusterDelta;
									var flick_dy:Number = gO.pOList[key]["flick_dy"].clusterDelta;
									var flick_pt:Point = globalToLocal(new Point(cO.x, cO.y)); //local point
									
									//trace("flick gesture dispatch",flick_dx,flick_dy);
									
									if ((flick_dx) || (flick_dy))
									{
										//trace("flick",flick_dx,flick_dy);
										dispatchEvent(new GWGestureEvent(GWGestureEvent.FLICK, {dx:flick_dx, dy:flick_dy,ddx:cO.ddx, ddy:cO.ddy, stageX:cO.x, stageY:cO.y, localX:flick_pt.x, localY:flick_pt.y, n:N, id:key}));
										if((tiO.timelineOn)&&(tiO.gestureEvents))	tiO.frame.gestureEventArray.push(new GWGestureEvent(GWGestureEvent.FLICK, {dx:flick_dx, dy:flick_dy, n:N, id:key}));
									}
									//}
								}
							}
							
							// gesture swipe
							if (gO.pOList[key].gesture_type == "swipe")
							{
								if ((gO.pOList[key])&&(gestureList[key]))
								{
									
									//if(cO.history[4]){
										// calls previsouoly calculated swipe value from previous frame
										// looks back before release to reduce release flicker
										//var swipe_dx:Number = cO.history[4].swipe_dx//cO.history[0].ddx//gO.pOList[key]["swipe_dx"].gestureDelta;
										//var swipe_dy:Number = cO.history[4].swipe_dy//cO.history[0].ddx//gO.pOList[key]["swipe_dy"].gestureDelta;
										//var swipe_dx:Number = gO.pOList[key]["swipe_dx"].gestureDelta;
										//var swipe_dy:Number = gO.pOList[key]["swipe_dy"].gestureDelta;
										var swipe_dx:Number = gO.pOList[key]["swipe_dx"].clusterDelta;
										var swipe_dy:Number = gO.pOList[key]["swipe_dy"].clusterDelta;
										var swipe_pt:Point = globalToLocal(new Point(cO.x, cO.y)); //local point
										
										//trace("swipe gesture dispatch",swipe_dx,swipe_dy);
								
										if ((swipe_dx) || (swipe_dy))
										{
											//trace("swipe",swipe_dx,swipe_dy);
											dispatchEvent(new GWGestureEvent(GWGestureEvent.SWIPE, {dx:swipe_dx, dy:swipe_dy,ddx:cO.ddx, ddy:cO.ddy, stageX:cO.x, stageY:cO.y, localX:swipe_pt.x, localY:swipe_pt.y, n:N, id:key}));
											if((tiO.timelineOn)&&(tiO.gestureEvents))tiO.frame.gestureEventArray.push(new GWGestureEvent(GWGestureEvent.SWIPE, {dx:swipe_dx, dy:swipe_dy, n:N, id:key}));
										}
									//}
								}
							}
							
							// gesture stroke
							if (gO.pOList[key].gesture_type == "stroke")
							{
								if ((gO.pOList[key])&&(gestureList[key]))
								{
									 gesture_disc.findStrokeGesture(key);
									
									var stroke_threshold:Number = 0.90;
									var stroke_prob:Number = gO.pOList[key].path_match;
									if (stroke_prob>stroke_threshold)
									{
										//trace("stroke event");
										var Gevent:GWGestureEvent = new GWGestureEvent(GWGestureEvent.STROKE, {n:N, probability:stroke_prob});
										dispatchEvent(Gevent);
										//if((tiO.timelineOn)&&(tiO.gestureEvents))tiO.frame.gestureEventArray.push(Gevent);
									}
								}
							}
							
						}
						
						// release gesture
						if ((gO.release)&&(_gestureEventRelease))//&&(!gesture_release_dispatched))
						{
							dispatchEvent(new GWGestureEvent(GWGestureEvent.RELEASE, gO.id));
							if ((tiO.timelineOn) && (tiO.gestureEvents))	tiO.frame.gestureEventArray.push(new GWGestureEvent(GWGestureEvent.RELEASE, gO.id));
							gO.release = false;
							gO.start = false;
							gesture_start_dispatched = false;
							//gesture_release_dispatched = true;
							//trace("release fired");
						}
					}
				
					//discrete_dispatch_reset = true;
		//	}
			
			// flick check
			*/
		//}
		
		//////////////////////////////////////////////////////////////////////////////////////
		/////////////////////////////////////////////////////////////////////////////////////
		///////////////////////////////////////////////////////////////////////////////////////
		/**
		* @private
		*/
		public function onEnterTouchFrame():void 
		{	
			//if (trace_debug_mode) trace("continuous gesture event dispatch");
			
			//trace("dispatch--------------------------");

			// MANAGE TIMELINE
			if (tiO.timelineOn)
			{
				if (trace_debug_mode) trace("timeline frame update");
				TimelineHistories.historyQueue(clusterID);			// push histories 
				tiO.frame = new FrameObject();						// create new timeline frame //trace("manage timeline");
			}
			
			// start gesturing
			if ((gO.start)&&(_gestureEventStart))
			{
				dispatchEvent(new GWGestureEvent(GWGestureEvent.START, gO.id));
				if((tiO.timelineOn)&&(tiO.gestureEvents))	tiO.frame.gestureEventArray.push(new GWGestureEvent(GWGestureEvent.START, gO.id));
				gO.start = false;
				gO.release = false;
				//trace("start fired");
			}
			
			// gesture OBJECT complete event
			if ((gO.complete)&&(_gestureEventComplete))
			{
				dispatchEvent(new GWGestureEvent(GWGestureEvent.COMPLETE, gO.id));
				if((tiO.timelineOn)&&(tiO.gestureEvents))	tiO.frame.gestureEventArray.push(new GWGestureEvent(GWGestureEvent.COMPLETE, gO.id));
				gO.complete = false;
				//trace("complete fired");
			}
			
			/////////////////////////////////////////////////////////////////////////////////////////////////
			// discrete gestures
			/////////////////////////////////////////////////////////////////////////////////////////////////
			else {
				
			for (key in gO.pOList) 
						{
			
				if (gO.release)
					{
				//	trace("discrete release");
						
							//tap counter
							if (gO.pOList[key].gesture_type == "tap")
							{
								gesture_disc.countTapEvents(key);
							}
							// double tap counter
							if (gO.pOList[key].gesture_type == "double_tap")
							{
								gesture_disc.countDoubleTapEvents(key);
							}
							// triple tap counter
							if (gO.pOList[key].gesture_type == "triple_tap")
							{
								 gesture_disc.countTripleTapEvents(key);
							}
							
							
							// gesture flick
							if (gO.pOList[key].gesture_type == "flick")
							{	
								if ((gO.pOList[key])&&(gestureList[key]))
								{
									
									//if(cO.history[0]){
									// CALLS PREVIOUSLY CALCULATED FLICK VALUE FROM LAST FRAME BEFORE RELEASE
									//var flick_dx:Number = cO.history[0].flick_dx//cO.history[0].ddx//gO.pOList[key]["flick_dx"].gestureDelta;
									//var flick_dy:Number = cO.history[0].flick_dy//cO.history[0].ddy//gO.pOList[key]["flick_dy"].gestureDelta;
									//var flick_dx:Number = gO.pOList[key]["flick_dx"].gestureDelta;
									//var flick_dy:Number = gO.pOList[key]["flick_dy"].gestureDelta;
									var flick_dx:Number = gO.pOList[key]["flick_dx"].clusterDelta;
									var flick_dy:Number = gO.pOList[key]["flick_dy"].clusterDelta;
									var flick_pt:Point = globalToLocal(new Point(cO.x, cO.y)); //local point
									
									//trace("flick gesture dispatch",flick_dx,flick_dy);
									
									if ((flick_dx) || (flick_dy))
									{
										//trace("flick",flick_dx,flick_dy);
										dispatchEvent(new GWGestureEvent(GWGestureEvent.FLICK, {dx:flick_dx, dy:flick_dy,ddx:cO.ddx, ddy:cO.ddy, stageX:cO.x, stageY:cO.y, localX:flick_pt.x, localY:flick_pt.y, n:N, id:key}));
										if((tiO.timelineOn)&&(tiO.gestureEvents))	tiO.frame.gestureEventArray.push(new GWGestureEvent(GWGestureEvent.FLICK, {dx:flick_dx, dy:flick_dy, n:N, id:key}));
									}
									//}
								}
							}
							
							// gesture swipe
							if (gO.pOList[key].gesture_type == "swipe")
							{
								if ((gO.pOList[key])&&(gestureList[key]))
								{
									
									//if(cO.history[4]){
										// calls previsouoly calculated swipe value from previous frame
										// looks back before release to reduce release flicker
										//var swipe_dx:Number = cO.history[4].swipe_dx//cO.history[0].ddx//gO.pOList[key]["swipe_dx"].gestureDelta;
										//var swipe_dy:Number = cO.history[4].swipe_dy//cO.history[0].ddx//gO.pOList[key]["swipe_dy"].gestureDelta;
										//var swipe_dx:Number = gO.pOList[key]["swipe_dx"].gestureDelta;
										//var swipe_dy:Number = gO.pOList[key]["swipe_dy"].gestureDelta;
										var swipe_dx:Number = gO.pOList[key]["swipe_dx"].clusterDelta;
										var swipe_dy:Number = gO.pOList[key]["swipe_dy"].clusterDelta;
										var swipe_pt:Point = globalToLocal(new Point(cO.x, cO.y)); //local point
										
										//trace("swipe gesture dispatch",swipe_dx,swipe_dy);
								
										if ((swipe_dx) || (swipe_dy))
										{
											//trace("swipe",swipe_dx,swipe_dy);
											dispatchEvent(new GWGestureEvent(GWGestureEvent.SWIPE, {dx:swipe_dx, dy:swipe_dy,ddx:cO.ddx, ddy:cO.ddy, stageX:cO.x, stageY:cO.y, localX:swipe_pt.x, localY:swipe_pt.y, n:N, id:key}));
											if((tiO.timelineOn)&&(tiO.gestureEvents))tiO.frame.gestureEventArray.push(new GWGestureEvent(GWGestureEvent.SWIPE, {dx:swipe_dx, dy:swipe_dy, n:N, id:key}));
										}
									//}
								}
							}
							
							// gesture stroke
							if (gO.pOList[key].gesture_type == "stroke")
							{
								if ((gO.pOList[key])&&(gestureList[key]))
								{
									 gesture_disc.findStrokeGesture(key);
									
									var stroke_threshold:Number = 0.90;
									var stroke_prob:Number = gO.pOList[key].path_match;
									if (stroke_prob>stroke_threshold)
									{
										//trace("stroke event");
										var Gevent:GWGestureEvent = new GWGestureEvent(GWGestureEvent.STROKE, {n:N, probability:stroke_prob});
										dispatchEvent(Gevent);
										//if((tiO.timelineOn)&&(tiO.gestureEvents))tiO.frame.gestureEventArray.push(Gevent);
									}
								}
							}
							
						// release gesture
						if ((gO.release)&&(_gestureEventRelease))//&&(!gesture_release_dispatched))
						{
							dispatchEvent(new GWGestureEvent(GWGestureEvent.RELEASE, gO.id));
							if ((tiO.timelineOn) && (tiO.gestureEvents))	tiO.frame.gestureEventArray.push(new GWGestureEvent(GWGestureEvent.RELEASE, gO.id));
							gO.release = false;
							gO.start = false;
							gesture_start_dispatched = false;
						}
							
					}
			
			//////////////////////////////////////////////////////////////////////////////////////////////////
			// continuos gesture events
			//////////////////////////////////////////////////////////////////////////////////////////////////
			
			else {	
				//trace("continuous");
				
				// hold gesture
				if (gO.pOList[key].gesture_type == "hold")
				{
					//if ((gO.pOList[key]) && (gestureList[key]))
					//{	
						var hold_number:int = gO.pOList[key].n;
						var holdLockCount:int = cO.locked;
						var spt:Point //= new Point ();
						var lpt:Point //= new Point ();
						
						
						if (!gO.pOList[key].complete) {
							
							if (hold_number == 0) {
								if (holdLockCount!=0)
								{
								//trace("hold count check n hold", gO.pOList[key].n, holdLockCount, cO.hold_x, cO.hold_y);
								
								gO.pOList[key].complete = true;
								
								spt = new Point (cO.hold_x, cO.hold_y); // stage point
								lpt = globalToLocal(spt); //local point
										
								dispatchEvent(new GWGestureEvent(GWGestureEvent.HOLD, { x:spt.x, y:spt.y, stageX:spt.x, stageY:spt.y, localX:lpt.x, localY:lpt.y, n:holdLockCount, id:key} ));//touchPointID:pointList[i].point.touchPointID
								if(tiO.pointEvents)tiO.frame.gestureEventArray.push(new GWGestureEvent(GWGestureEvent.HOLD, { x: spt.x, y:spt.y, localX:lpt.x, localY:lpt.y, n:hold_number, id:key} ));//touchPointID:pointList[i].point.touchPointID
								}
							}
							
							else {
								if (holdLockCount == hold_number)
								{
								//trace("hold count check hold", gO.pOList[key].n, holdLockCount, cO.hold_x, cO.hold_y);
								
								gO.pOList[key].complete = true;
								
								spt = new Point (cO.hold_x, cO.hold_y); // stage point
								lpt = globalToLocal(spt); //local point
										
								dispatchEvent(new GWGestureEvent(GWGestureEvent.HOLD, { x:spt.x, y:spt.y, stageX:spt.x, stageY:spt.y, localX:lpt.x, localY:lpt.y, n:holdLockCount, id:key} ));//touchPointID:pointList[i].point.touchPointID
								if(tiO.pointEvents)tiO.frame.gestureEventArray.push(new GWGestureEvent(GWGestureEvent.HOLD, { x: spt.x, y:spt.y, localX:lpt.x, localY:lpt.y, n:hold_number, id:key} ));//touchPointID:pointList[i].point.touchPointID
							
								}
							}
						//}
					}
				}
				//////////////////////////////////////////////////////////////////////////////
				// 
				//trace("testing all attached gestures");
					
						if (gO.pOList[key].activeEvent) 
						{
							// transform center point
							var trans_pt:Point = globalToLocal(new Point(cO.x, cO.y)); //local point
							// transform vector components
							// 
							
							var Data:Object = new Object();
							var DIM:String = ""; 
							
								//construct standard properties
								Data["id"] = new Object();
								Data["id"] = key;
								
								Data["n"] = new Object();
								Data["n"] = N;
								
								Data["stageX"] = new Object();
								Data["stageX"] = cO.x;
								
								Data["stageY"] = new Object();
								Data["stageY"] = cO.y;
								
								Data["x"] = new Object();
								Data["x"] = cO.x;
								
								Data["y"] = new Object();
								Data["y"] = cO.y;
								
								Data["localX"] = new Object();
								Data["localX"] = trans_pt.x;
								
								Data["localY"] = new Object();
								Data["localY"] = trans_pt.y;
								
								// construc tgesture object dependant properties
								for (DIM in gO.pOList[key])
								{
									//trace(gO.pOList[key][DIM]);
									if (gO.pOList[key][DIM] is PropertyObject) 
									{
										Data[DIM] = new Object();
										Data[DIM] = Number(gO.pOList[key][DIM].gestureDelta);	
										//trace(DIM,Data[DIM])
									}
								}
							
							var GWEVENT:GWGestureEvent = new GWGestureEvent(gO.pOList[key].gesture_type, Data);
							dispatchEvent(GWEVENT);
							if((tiO.timelineOn)&&(tiO.gestureEvents))	tiO.frame.gestureEventArray.push(GWEVENT);
						}
				///////////////////////////////////////////////////////////////////////
				
				/*
				// manipulate gesture
				if (gO.pOList[key].gesture_type == "manipulate")
				{
					trace("trying");
					if ((gO.pOList[key])&&(gestureList[key]))
					{
						//var m_drag_dx:Number = gO.pOList[key]["drag_dx"].gestureDelta;
						//var m_drag_dy:Number = gO.pOList[key]["drag_dy"].gestureDelta;
						//var m_rotate_dtheta:Number = gO.pOList[key]["rotate_dtheta"].gestureDelta;
						//var m_scale_dsx:Number = gO.pOList[key]["scale_dsx"].gestureDelta;
						//var m_scale_dsy:Number = gO.pOList[key]["scale_dsy"].gestureDelta;
						//var trans_pt:Point = globalToLocal(new Point(cO.x, cO.y)); //local point
						
						if (gO.pOList[key].activeEvent) 
						{
							var trans_pt:Point = globalToLocal(new Point(cO.x, cO.y)); //local point
							var Data:Object = new Object();
							var DIM:String = ""; 
							
								//construct standard properties
								Data["id"] = new Object();
								Data["id"] = key;
								
								Data["n"] = new Object();
								Data["n"] = N;
								
								Data["stageX"] = new Object();
								Data["stageX"] = cO.x;
								
								Data["stageY"] = new Object();
								Data["stageY"] = cO.y;
								
								Data["x"] = new Object();
								Data["x"] = cO.x;
								
								Data["y"] = new Object();
								Data["y"] = cO.y;
								
								Data["localX"] = new Object();
								Data["localX"] = trans_pt.x;
								
								Data["localY"] = new Object();
								Data["lcalY"] = trans_pt.y;
								
								
								
								// construc tgesture object dependant properties
								for (DIM in gO.pOList[key])
								{
									//trace(gO.pOList[key][DIM]);
									if (gO.pOList[key][DIM] is PropertyObject) 
									{
										Data[DIM] = new Object();
										Data[DIM] = Number(gO.pOList[key][DIM].gestureDelta);	
									//	trace(DIM,Data[DIM])
									}
								}
							//trace("data",Data);
							//var test:String = "GWGestureEvent.MANIPULATE";
							//var GWEVENT:GWGestureEvent = new GWGestureEvent("manipulate", { dx: m_drag_dx, dy: m_drag_dy, dtheta: m_rotate_dtheta, dsx: m_scale_dsx, dsy: m_scale_dsy, stageX:cO.x, stageY:cO.y, localX:trans_pt.x, localY:trans_pt.y, n:N, id:key } );
							//var GWEVENT:GWGestureEvent = new GWGestureEvent("manipulate", { data:Data, stageX:cO.x, stageY:cO.y, localX:trans_pt.x, localY:trans_pt.y, n:N, id:key } );
							//var GWEVENT:GWGestureEvent = new GWGestureEvent("manipulate", Data);
							var GWEVENT:GWGestureEvent = new GWGestureEvent(gO.pOList[key].gesture_type, Data);
							
							dispatchEvent(GWEVENT);
							if((tiO.timelineOn)&&(tiO.gestureEvents))	tiO.frame.gestureEventArray.push(GWEVENT);
						}
					}
				}
				
				// drag gesture
				if (gO.pOList[key].gesture_type == "drag")
				{
					if ((gO.pOList[key])&&(gestureList[key]))
					{
						var drag_dx:Number = gO.pOList[key]["drag_dx"].gestureDelta;
						var drag_dy:Number = gO.pOList[key]["drag_dy"].gestureDelta;
						var drag_pt:Point = globalToLocal(new Point(cO.x, cO.y)); //local point
						
						if (trace_debug_mode)trace("drag", drag_dx, drag_dy);

						if ((drag_dx)||(drag_dy)) 
						{
							//if (trace_debug_mode) trace("drag", drag_dx, drag_dy);
							
							dispatchEvent(new GWGestureEvent(GWGestureEvent.DRAG, {dx: drag_dx, dy: drag_dy, stageX:cO.x, stageY:cO.y, localX:drag_pt.x, localY:drag_pt.y, n:N, id:key}));
							if((tiO.timelineOn)&&(tiO.gestureEvents))	tiO.frame.gestureEventArray.push(new GWGestureEvent(GWGestureEvent.DRAG, {dx:drag_dx, dy:drag_dy, n:N, id:key}));
						}
					}
				}

				// rotation gesture
				if (gO.pOList[key].gesture_type == "rotate")
				{
					if ((gO.pOList[key])&&(gestureList[key]))
					{
						var rotate_dtheta:Number = gO.pOList[key]["rotate_dtheta"].gestureDelta;
						var rotate_pt:Point = globalToLocal(new Point(cO.x, cO.y)); //local point
						
						if (trace_debug_mode) trace("rotate_dtheta",rotate_dtheta);
						
						if (rotate_dtheta)
						{
							dispatchEvent(new GWGestureEvent(GWGestureEvent.ROTATE, {dtheta: rotate_dtheta, stageX:cO.x, stageY:cO.y, localX:rotate_pt.x, localY:rotate_pt.y, n:N, id:key}));
							if((tiO.timelineOn)&&(tiO.gestureEvents))	tiO.frame.gestureEventArray.push(new GWGestureEvent(GWGestureEvent.ROTATE, {dtheta:rotate_dtheta, n:N, id:key}));
						}
					}
				}
				// scale gesture
				if (gO.pOList[key].gesture_type == "scale")
				{
					if ((gO.pOList[key])&&(gestureList[key]))
					{
						var scale_dsx:Number = gO.pOList[key]["scale_dsx"].gestureDelta;
						var scale_dsy:Number = gO.pOList[key]["scale_dsy"].gestureDelta;
						var scale_pt:Point = globalToLocal(new Point(cO.x, cO.y)); //local point
						
						if ((scale_dsx)||(scale_dsy)) 
						{
							dispatchEvent(new GWGestureEvent(GWGestureEvent.SCALE, {dsx: scale_dsx, dsy: scale_dsy, stageX:cO.x, stageY:cO.y, localX:scale_pt.x, localY:scale_pt.y, n:N, id:key}));
							if((tiO.timelineOn)&&(tiO.gestureEvents))	tiO.frame.gestureEventArray.push(new GWGestureEvent(GWGestureEvent.SCALE, {dsx:scale_dsx, dsy:scale_dsy, n:N, id:key}));
						}
					}
				}
				
				
				// pivot gesture
				if (gO.pOList[key].gesture_type == "pivot")
				{
					if ((gO.pOList[key])&&(gestureList[key]))
					{
						var pivot_dtheta:Number = gO.pOList[key]["pivot_dtheta"].gestureDelta;
						//MAY NEED CONTEXT UPDATE FOR CENTER OF OBJECT
						var pivot_pt:Point = globalToLocal(new Point(cO.x, cO.y)); //local point  
						
						if (pivot_dtheta)
						{
							dispatchEvent(new GWGestureEvent(GWGestureEvent.PIVOT, {dtheta: pivot_dtheta, stageX:cO.x, stageY:cO.y, localX:pivot_pt.x, localY:pivot_pt.y, n:N, id:key}));
							if((tiO.timelineOn)&&(tiO.gestureEvents))	tiO.frame.gestureEventArray.push(new GWGestureEvent(GWGestureEvent.PIVOT, {pivot_dtheta:pivot_dtheta, n:N, id:key}));
						}
					}
				}
				
				//orient gesture
				if (gO.pOList[key].gesture_type == "orient")
				{
					if ((gO.pOList[key])&&(gestureList[key]))
					{
						//trace("orient")
						var orient_dx:Number = gO.pOList[key]["orient_dx"].gestureDelta;
						var orient_dy:Number = gO.pOList[key]["orient_dy"].gestureDelta;
						// MAY NEED CONTERXT UPDATE FOR CENTER OF HAND SKELETON
						var orient_pt:Point = globalToLocal(new Point(cO.x, cO.y)); //local point
						
						
						
						//WHY NOT CONTINUOUS??
						if ((orient_dx) || (orient_dy)) 
						{
							//trace("orient", orient_dx, orient_dy);
							dispatchEvent(new GWGestureEvent(GWGestureEvent.ORIENT, {dx: orient_dx, dy: orient_dy, stageX:cO.x, stageY:cO.y, localX:orient_pt.x, localY:orient_pt.y, n:N, id:key}));
							if((tiO.timelineOn)&&(tiO.gestureEvents))	tiO.frame.gestureEventArray.push(new GWGestureEvent(GWGestureEvent.ORIENT, {dx:orient_dx, dy:orient_dy, n:N, id:key}));
						}
					}
				}
				
				//scroll gesture
				if (gO.pOList[key].gesture_type == "scroll")
				{
					if ((gO.pOList[key])&&(gestureList[key]))
					{
						//trace("scroll")	
						var scroll_dx:Number = gO.pOList[key]["scroll_dx"].gestureDelta;
						var scroll_dy:Number = gO.pOList[key]["scroll_dy"].gestureDelta;
						var scroll_pt:Point = globalToLocal(new Point(cO.x, cO.y)); //local point

						if ((scroll_dx) || (scroll_dy)) 
						{
							//trace("scroll",scroll_dx,scroll_dy);
							dispatchEvent(new GWGestureEvent(GWGestureEvent.SCROLL, {dx: scroll_dx, dy: scroll_dy, stageX:cO.x, stageY:cO.y, localX:scroll_pt.x, localY:scroll_pt.y, n:N, id:key}));
							if((tiO.timelineOn)&&(tiO.gestureEvents))	tiO.frame.gestureEventArray.push(new GWGestureEvent(GWGestureEvent.SCROLL, {dx:scroll_dx, dy:scroll_dy, n:N, id:key}));
						}
					}
				}
				
				// 3d tilt gesture
				if (gO.pOList[key].gesture_type == "tilt")
				{
					if ((gO.pOList[key])&&(gestureList[key]))
					{
						var tilt_dx:Number = gO.pOList[key]["tilt_dx"].gestureDelta;
						var tilt_dy:Number = gO.pOList[key]["tilt_dy"].gestureDelta;
						var tilt_pt:Point = globalToLocal(new Point(cO.x, cO.y)); //local point
						
						if ((tilt_dx)||(tilt_dy))
						{
							dispatchEvent(new GWGestureEvent(GWGestureEvent.TILT,{dx: tilt_dx, dy: tilt_dy, stageX:cO.x, stageY:cO.y, localX:tilt_pt.x, localY:tilt_pt.y, n:N, id:key}));
							if((tiO.timelineOn)&&(tiO.gestureEvents))	tiO.frame.gestureEventArray.push(new GWGestureEvent(GWGestureEvent.TILT, {dx:tilt_dx, dy:tilt_dy, n:N, id:key}));
						}
					}
				}
				
				*/
			}
		}
		}

				/////// split
				
				/////// anchor
		}	
		
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		//public  read / write
		////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		/**
		* @private
		*/
		//public read write
		private var _gestureEventStart:Boolean = true;
		/**
		* Indicates whether any gestureEvents have been started on the touchSprite.
		*/
		public function get gestureEventStart():Boolean{return _gestureEventStart;}
		public function set gestureEventStart(value:Boolean):void
		{
			_gestureEventStart=value;
		}
		
		
		/**
		* @private
		*/
		private var _gestureEventComplete:Boolean = true;
		/**
		* Indicates weather all gestureEvents have been completed on the touchSprite.
		*/
		public function get gestureEventComplete():Boolean{return _gestureEventComplete;}
		public function set gestureEventComplete(value:Boolean):void
		{
			_gestureEventComplete=value;
		}
		
		/**
		* @private
		*/
		private var _gestureEventRelease:Boolean = true;
		/**
		* Indicates whether all touch points have been released on the touchSprite.
		*/
		public function get gestureEventRelease():Boolean{return _gestureEventRelease;}
		public function set gestureEventRelease(value:Boolean):void
		{
			_gestureEventRelease=value;
		}
		
		/**
		* @private
		*/
		// NOW SET TO TRUE BY DEFAULT
		// TURN OFF TO OPTOMIZE WHEN USING NATIVE
		// TODO, AUTO ON WHEN ATTATCH LISTENERS
		private var _gestureEvents:Boolean = true;
		/**
		* Determins whether gestureEvents are processed and dispatched on the touchSprite.
		*/
		public function get gestureEvents():Boolean{return _gestureEvents;}
		public function set gestureEvents(value:Boolean):void
		{
			_gestureEvents=value;
		}
		
		/**
		* @private
		*/
		public var _gestureReleaseInertia:Boolean = false;	// gesture release inertia switch
		/**
		* Determins whether release inertia is given to gestureEvents on the touchSprite.
		*/
		public function get gestureReleaseInertia():Boolean{return _gestureReleaseInertia;}
		public function set gestureReleaseInertia(value:Boolean):void
		{
			_gestureReleaseInertia=value;
		}
	}
}