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
	import flash.events.TouchEvent;
	import flash.geom.Point;
	
	import com.gestureworks.events.GWEvent;
	import com.gestureworks.events.GWGestureEvent;
	import com.gestureworks.analysis.gestureContinuous;
	import com.gestureworks.analysis.gestureDiscrete;
	
	import com.gestureworks.managers.TimelineHistories;
	import com.gestureworks.objects.FrameObject; 
	import com.gestureworks.objects.PropertyObject;
	
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
		private var key:String;
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

			initGestureAnalysis();
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
			
			gesture_cont = new gestureContinuous(touchObjectID);

			// analyze for descrete gesture sequence/series
			gesture_disc = new gestureDiscrete(touchObjectID);
			//initTimeline();
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
					
					
				}
				
				if ((gO.pOList[key].gesture_type == "tap")||(gO.pOList[key].gesture_type == "double_tap")||(gO.pOList[key].gesture_type == "triple_tap"))
				{
				tapOn = true;
				}
				
				//MAKE GML PROGRAMMABLE SET GLOBAL POINT HISTORY
				if (gO.pOList[key].gesture_type == "stroke") GestureGlobals.pointHistoryCaptureLength = 150; // define in GML

				//trace("tsgesture, timelineon:",tiO.timelineOn, tiO.timelineInit);
			}	
			trace("init timeline",tapOn,tiO.timelineOn);
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
			gesture_disc.findTimelineGestures();
		}
		
		public function updateGesturePipeline():void
		{
			gesture_cont.processPipeline();
			if (_gestureEvents) manageGestureEventDispatch();	
		}
		
		/**
		* @private
		*/
		public function restartGestureTween():void
		{
			//gesture_cont.restartGestureTween();
		}
		/**
		* @private
		*/
		public function resetGestureTween():void
		{
			//gesture_cont.resetGestureTween();
		}
		/**
		* @private
		*/
		private function manageGestureEventDispatch():void 
		{
			processTemoralMetric();
			dispatchGestures();
			dispatchReset();
		}
		
		
		////////////////////////////////////////////////////////////////////////////////////
		///////////////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////////
		
		/**
		* @private
		*/
		public function onTouchEnd(event:TouchEvent):void
		{
			var tapCalled:Boolean = false;
			
			// if touchEnd is in match criteria
			
			for (key in gO.pOList) 
			{	
			if ((gO.pOList[key].gesture_type == "tap") && (tapOn) && (!tapCalled)) 
			{	
				gesture_disc.findGestureTap(event, key) ; // tap event pairs
				tapCalled = true; // if called by another gesture using tap do not call again
				//trace("trace find tap");
			}
			
			//fix
			//if (gO.pOList[key].gesture_type == "hold")				gO.pOList[key].complete = false;  // resets hold gesture
			}
			
			gO.release = true;
			
			
			//trace("touch end");
		}
		
		/**
		* @private
		*/
		// if gesture tap is in match criteris
		public function onGestureTap(event:GWGestureEvent):void
		{
			//trace("on gesture tap");
			var dtapCalled:Boolean = false;
			var ttapCalled:Boolean = false;
			
			// if gesture TAP is in the match criteria
			for (key in gO.pOList) 
			{	
				// double taps
				if ((gO.pOList[key].gesture_type == "double_tap") && (!dtapCalled))	
				{
					gesture_disc.findGestureDoubleTap(event, key);
					dtapCalled = true;
				}
				// triple taps
				if ((gO.pOList[key].gesture_type == "triple_tap")&& (!ttapCalled))
				{
					gesture_disc.findGestureTripleTap(event, key);
					ttapCalled = true;
				}
			}
		}
		
		public function processTemoralMetric():void {
			
			for (key in gO.pOList) 
					{	
					
					//trace(gO.pOList[key].algorithm_class, gO.pOList[key].algorithm_type);
				
					/////////////////////////////////////////////////////////////////////////////////////////////////
					// process discrete gestures
					/////////////////////////////////////////////////////////////////////////////////////////////////
					if ((gO.pOList[key].algorithm_class == "temporalmetric")&&(gO.pOList[key].algorithm_type == "discrete"))
						{
						
							// need to endcode "process on release" into gml
							if (gO.release)//if (gO[key].release,gO.release)
							{
								//trace(key, "calling temoral metric",gO.release);
								
								///////////////////////////////////////////////////////////
								// process and count tap  and double events 
								// ONCE PER FRAME 
								//////////////////////////////////////////////////////////
								
								//tap counter
								if (gO.pOList[key].gesture_type == "tap")	gesture_disc.countTapEvents(key);
												
								// double tap counter
								if (gO.pOList[key].gesture_type == "double_tap") 	gesture_disc.countDoubleTapEvents(key);
												
								// triple tap counter
								//	if (gO.pOList[key].gesture_type == "triple_tap") 	gesture_disc.countTripleTapEvents(key);
							}
						}
				}
			
		}
		
		
		public function dispatchReset():void 
		{
			//trace(gO.release);
			
		for (key in gO.pOList) 
					{	
						
					//trace("managing reset", key, gO.pOList[key].dispatch_type,gO.pOList[key].dispatch_reset,gO.pOList[key].complete);
					
					/////////////////////////////////////////
					//RESET EVENT DISPATCH
					/////////////////////////////////////////
					// discrete dispatch gesture events
					// if descrete check for reset conditions
					if (gO.pOList[key].dispatch_type =="discrete")
					{
						
						// when cluster has been removed
						if (gO.pOList[key].dispatch_reset == "cluster_remove") 
						{
							if (N == 0)
							{
								//trace("cluster remove reset")
								gO.pOList[key].complete = false;
								gO.pOList[key].activeEvent = false;
								//trace(key, "release reset ",gO.pOList[key].complete,gO.release,N )
							}
						}
						
						//when point added or removed reset
						if (gO.pOList[key].dispatch_reset == "point_change") // 
						{
							//trace("--",dN,_N, cO.point_remove,cO.point_add)
							if((cO.point_remove)||(cO.point_add)) // point change
							{
								gO.pOList[key].complete = false;
								gO.pOList[key].activeEvent = false;
							}
						}
						
						//when point added reset
						if (gO.pOList[key].dispatch_reset == "point_add") // 
						{
							//trace("--",dN,_N, cO.point_add)
							if(cO.point_add) // point change
							{
								gO.pOList[key].complete = false;
								gO.pOList[key].activeEvent = false;
							}
						}
						
						//when point removed reset
						if (gO.pOList[key].dispatch_reset == "point_remove") // 
						{
							//trace("--",dN,_N, cO.point_remove)
							if(cO.point_remove) // point change
							{
								gO.pOList[key].complete = false;
								gO.pOList[key].activeEvent = false;
							}
						}
						
						// AUTO RESET DISCRETE GESTURE
						else if (gO.pOList[key].dispatch_reset == "") 
						{
							//trace(key, "auto reset");
							// auto reset each frame
							gO.pOList[key].complete = false;
							gO.pOList[key].activeEvent = false;
						}
						
						if (!gO.pOList[key].complete) gO.pOList[key].dispatchEvent = true;
						
					}
					// continuous gesture events always dispatch each processing frame
					else if (gO.pOList[key].dispatch_type == "continuous")
					{
						gO.pOList[key].dispatchEvent = true;
					}

					//trace(key,gO.pOList[key].complete,gO.pOList[key].dispatchEvent,gO.pOList[key].activeEvent,gO.pOList[key] );
			}
		}
		
		/**
		* @private
		*/
		public function dispatchGestures():void 
		{	
			//if (trace_debug_mode) trace("continuous gesture event dispatch");
			
			//trace("dispatch--------------------------",gO.release);
			
		
			// MANAGE TIMELINE
			if (tiO.timelineOn)
			{
				if (trace_debug_mode) trace("timeline frame update");
				TimelineHistories.historyQueue(clusterID);			// push histories 
				tiO.frame = new FrameObject();						// create new timeline frame //trace("manage timeline");
			}
			
			// start OBJECT complete event gesturing
			if ((gO.start)&&(_gestureEventStart))
			{
				dispatchEvent(new GWGestureEvent(GWGestureEvent.START, gO.id));
				if((tiO.timelineOn)&&(tiO.gestureEvents))	tiO.frame.gestureEventArray.push(new GWGestureEvent(GWGestureEvent.START, gO.id));
				gO.start = false;
				//trace("start fired");
			}
			
			//////////////////////////////////////////////
			// custom GML gesture events with active event
			//////////////////////////////////////////////
			for (key in gO.pOList) 
				{	
					//trace(gO.pOList[key].activeEvent,gO.pOList[key].dispatchEvent)
					if ((gO.pOList[key].activeEvent) && (gO.pOList[key].dispatchEvent))	constructGestureEvents(key);
				}
				
			///////////////////////////////////////////////
			// RELEASE GESTURE SWITCHES OFF RELEASE STATE SO MUST PROCESS ALL RELEASE BASED GESTURES FIRST
			// gesture OBJECT release gesture
			if ((gO.release)&&(_gestureEventRelease))
			{
				dispatchEvent(new GWGestureEvent(GWGestureEvent.RELEASE, gO.id));
				if ((tiO.timelineOn) && (tiO.gestureEvents))	tiO.frame.gestureEventArray.push(new GWGestureEvent(GWGestureEvent.RELEASE, gO.id));
				gO.release = false;
				//trace("release fired");
			}
			
			// gesture OBJECT complete event
			if ((gO.complete)&&(_gestureEventComplete))
			{
				dispatchEvent(new GWGestureEvent(GWGestureEvent.COMPLETE, gO.id));
				if((tiO.timelineOn)&&(tiO.gestureEvents))	tiO.frame.gestureEventArray.push(new GWGestureEvent(GWGestureEvent.COMPLETE, gO.id));
				gO.complete = false;
				//trace("complete fired");
			}
		
		
		
			// so release is only sent once and other gestures dependent on it only get dispatched once
			// NEED TO BREAK OUT RELEASE INTO GESTURE OBJECT SPECIFIC RELEASES (N MATCH BREAKING)
			// AND HAVE GENERAL TOUCH RELEASE AND A GENERAL DISTCRETE DISPATCH COMPLETE WITHOUT FORCING RELEASE
			// ALSO NEED A WAY TO TAP WHEN STILL TOUCHING (HOLD+TAP OR DRAG+TAP)
			
			// TAP DISPATCH MUST BE TRIGGERED ON GESTURE STATE NOT GLOABAL RELEASE STATE
			gO.start = false;
			gO.release = false;
			gO.complete = false;			
		}
		
		public function constructGestureEvents(key:String):void 
		{
		
							//trace(key);
							//////////////////////////////
							// generic custom geture events
							//////////////////////////////
							//trace("testing all attached gestures",gO.pOList[key].activeEvent, key, gO.pOList[key].x, gO.pOList[key].y, gO.pOList[key].n);
							
							// transform center point
							//var trans_pt:Point = globalToLocal(new Point(cO.x, cO.y)); //local point
							var trans_pt:Point = globalToLocal(new Point(gO.pOList[key].x, gO.pOList[key].y)); //local point
							// transform vector components
							// 
							
							var Data:Object = new Object();
							var DIM:String = ""; 
							
								//construct standard properties
								Data["id"] = new Object();
								Data["id"] = key;
								
								// gestureCount
								// gestureID =.. number of times this gesture has dispatched
								
								Data["n"] = new Object();
								Data["n"] = gO.pOList[key].n//N;
								
								// location data
								Data["stageX"] = new Object();
								Data["stageX"] = gO.pOList[key].x//cO.x;
								
								Data["stageY"] = new Object();
								Data["stageY"] = gO.pOList[key].y//cO.y;
								
								Data["x"] = new Object();
								Data["x"] = gO.pOList[key].x//cO.x;
								
								Data["y"] = new Object();
								Data["y"] = gO.pOList[key].y//cO.y;
								
								Data["localX"] = new Object();
								Data["localX"] = trans_pt.x;
								
								Data["localY"] = new Object();
								Data["localY"] = trans_pt.y;
								
								// for stroke
								//gO.pOList[key].path_match;
								
								
								// construc tgesture object dependant properties
								for (DIM in gO.pOList[key])
								{
									//trace(gO.pOList[key][DIM]);
									if (gO.pOList[key][DIM] is PropertyObject) 
									{
										Data[DIM] = new Object();
										Data[DIM] = Number(gO.pOList[key][DIM].gestureDelta);	
										//Data[DIM] = Number(gO.pOList[key][DIM].gestureValue);	
										//trace(DIM,Data[DIM])
									}
								}
							
							var GWEVENT:GWGestureEvent = new GWGestureEvent(gO.pOList[key].gesture_type, Data);
							dispatchEvent(GWEVENT);
							if ((tiO.timelineOn) && (tiO.gestureEvents))	tiO.frame.gestureEventArray.push(GWEVENT);
							
							/////// split
						
							/////// anchor
						
						// reset dispatch
						gO.pOList[key].dispatchEvent = false;	
						// close event for this dispatch cycle
						gO.pOList[key].activeEvent = false;
						// set gesture event phase logic
						gO.pOList[key].complete = true;
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
			_gestureEventRelease = value;
			
			
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
		
		//gestures tweening
		public var _gestureTweenOn:Boolean = false;
		public function get gestureTweenOn():Boolean
		{
			return _gestureTweenOn;
		}
		public function set gestureTweenOn(value:Boolean):void
		{
			_gestureTweenOn = value;
		}
	}
}