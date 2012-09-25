////////////////////////////////////////////////////////////////////////////////
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
	import flash.display.Sprite;
	import flash.events.TouchEvent;
	import flash.geom.Point;
	
	import com.gestureworks.events.GWEvent;
	import com.gestureworks.events.GWGestureEvent;
	//import com.gestureworks.analysis.GesturePipeline;
	import com.gestureworks.analysis.TemporalMetric;;
	
	import com.gestureworks.managers.TimelineHistories;
	import com.gestureworks.objects.FrameObject; 
	import com.gestureworks.objects.DimensionObject;
	
	import com.gestureworks.objects.ClusterObject;
	import com.gestureworks.objects.GestureListObject;
	import com.gestureworks.objects.TimelineObject;
	
	public class TouchGesture extends Sprite
	{
		/**
		* @private
		*/
		//internal public
		//public var gesture_cont:GesturePipeline;
		/**
		* @private
		*/
		public var gesture_disc:TemporalMetric;
		
		/**
		* @private
		*/
		private var gn:uint;
		private var key:uint;
		private var DIM:uint; 
		private var tapOn:Boolean = false;
		
		private var timerCount:int = 0;
		
		private var ts:Object;
		private var id:uint;
		
		private var cO:ClusterObject
		private var gO:GestureListObject;
		private var tiO:TimelineObject;
		/////////////////////////////////////////////////////////
		
		public function TouchGesture(touchObjectID:int):void
		{
			//super();
			id = touchObjectID;
			ts = GestureGlobals.gw_public::touchObjects[id];
			cO = ts.cO;
			gO = ts.gO;
			tiO = ts.tiO;
			
			initGesture();
         }
		 
		// initializers   
         public function initGesture():void 
         {
			//if(trace_debug_mode) trace("create touchsprite gesture");

			initGestureAnalysis();
		}
		
		/**
		* @private
		*/
		public function initGestureAnalysis():void //clusterObject:Object
		{
			//if (trace_debug_mode) trace("init gesture analysis", touchObjectID);
			
			// configure gesturelist from listener attachment
			//if (hasEventListener(GWGestureEvent.DRAG)) trace("has drag listener");
			//hasEventListener(GWGestureEvent.SCALE, scaleHandeler);
			//hasEventListener(GWGestureEvent.ROTATE, rotateHandeler);
			
			// analyze for descrete gesture sequence/series
			gesture_disc = new TemporalMetric(id);
			
			
			//initTimeline(); // must init after parsing
			// analyze for gesture conflict/compliment
		}
		
		/**
		* @private
		*/
		public function initTimeline():void
		{
			gn = gO.pOList.length;
			for (key=0; key < gn; key++) 
			//for (key in gO.pOList)
			{
				
				if (!tiO.timelineOn)
				{
					//if ((gO.pOList[key].gesture_type == "stroke") || (gO.pOList[key].gesture_type == "swipe") || (gO.pOList[key].gesture_type == "flick") || (gO.pOList[key].gesture_type == "hold") || (gO.pOList[key].gesture_type == "tap") || (gO.pOList[key].gesture_type == "double_tap") || (gO.pOList[key].gesture_type == "triple_tap"))
					if ((gO.pOList[key].gesture_type == "tap")||(gO.pOList[key].gesture_type == "double_tap")||(gO.pOList[key].gesture_type == "triple_tap"))
					{
						tiO.timelineOn = true;
						tiO.pointEvents = true;
						tiO.timelineInit = true;
						GestureGlobals.timelineHistoryCaptureLength = 80;
						tapOn = true;
					}
				}
				
				
				//MAKE GML PROGRAMMABLE SET GLOBAL POINT HISTORY
				if (gO.pOList[key].gesture_type == "stroke") GestureGlobals.pointHistoryCaptureLength = 150; // define in GML

				//trace("tsgesture, timelineon:",tiO.timelineOn, tiO.timelineInit);
			}	
			//trace("init timeline",tapOn,tiO.timelineOn);
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
		public function manageGestureEventDispatch():void 
		{
			//trace("manage dispatch-----------------------------");
			gn = gO.pOList.length;
			
			dispatchMode();
			
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
			
			// place touchEnd events on timline
			// then search when asked
			/*
			// move to dispatch check
			var tapCalled:Boolean = false;
			
			// if touchEnd is in match criteria
			for (key in gO.pOList) 
			{	
				if ((gO.pOList[key].gesture_type == "tap"))//||(gO.pOList[key].gesture_type == "double_tap")
				{
					
					if ((tapOn) && (!tapCalled)) 
					{	
					gesture_disc.findGestureTap(event, key) ; // tap event pairs
					tapCalled = true; // if called by another gesture using tap do not call again
					//trace("trace find tap", key);
					}
				}
				
				//if (gO.pOList[key].gesture_type == "double_tap") {
									//gesture_disc.countDoubleTapEvents(key);
									//trace("count double tap");
								//}
			}
			
			gO.release = true;
			*/
			
			//trace("touch end");
		}
		
		/**
		* @private
		*/
		// if gesture tap is in match criteris
		/*
		public function onGestureTap(event:GWGestureEvent):void
		{
			//PUT TAP EVENTS ON TIMLINE THEN SEARCH WHEN REQUIRED AT END OF INTERVAL
			/*
			
			// move into dispatch check
			//trace("on gesture tap");
			var dtapCalled:Boolean = false;
			var ttapCalled:Boolean = false;
			
			// if gesture TAP is in the match criteria
			for (key in gO.pOList) 
			{	
				
				//if(){ gestureevent tap
				
					// double taps
					if ((gO.pOList[key].gesture_type == "double_tap") && (!dtapCalled))	
					{
						gesture_disc.findGestureDoubleTap(event, key);
						dtapCalled = true;
						gesture_disc.countDoubleTapEvents(key);
					}
					// triple taps
					if ((gO.pOList[key].gesture_type == "triple_tap")&& (!ttapCalled))
					{
						gesture_disc.findGestureTripleTap(event, key);
						ttapCalled = true;
					}
				}
			//}
			*/
		//}
		
		public function dispatchMode():void 
		{
			//trace("dispatch mode");
			//gn = gO.pOList.length;
			for (key=0; key < gn; key++) 
			//for (key in gO.pOList) 
					{	
						var dn:uint = gO.pOList[key].dList.length;
						
						///////////////////////////////////
						// set dispatch mode
						////////////////////////////////////
						if (gO.pOList[key].dispatch_type =="discrete")
						{
							//trace(gO.pOList[key].dispatch_mode,gO.pOList[key].dispatch_type,key)
							if (gO.pOList[key].dispatch_mode =="cluster_remove")
							{
								if ((ts.gO.release) && (!gO.pOList[key].complete)) gO.pOList[key].dispatchEvent = true;//gO.release
					
					

								////////////////////////////////////////////////////////////////////////////////////////
								// must make generic
								/////////////////////////////////////////////////////////////////////////////////////////
								
								// COPY CACHE INTO GESTURE DELTA
								if (gO.pOList[key].gesture_type == "flick")
								{	
									for (DIM=0; DIM < dn; DIM++)
									//for (DIM in gO.pOList[key])
									{
										
										gO.pOList[key].dList[DIM].gestureDelta = gO.pOList[key].dList[DIM].gestureDeltaCache;
										//gO.pOList[key].dList[DIM].gestureDelta = gO.pOList[key].dList[DIM].gestureDeltaCache;
										//trace(gO.pOList[key].dList[DIM].gestureDeltaCache)
									}
								}
								
								// COPY CACHE INTO GESTURE DELTA
								if (gO.pOList[key].gesture_type == "swipe")
								{	
									for (DIM=0; DIM < dn; DIM++)
									//for (DIM in gO.pOList[key])
									{
										
										gO.pOList[key].dList[DIM].gestureDelta = gO.pOList[key].dList[DIM].gestureDeltaCache;
										//gO.pOList[key].dList[DIM].gestureDelta = gO.pOList[key].dList[DIM].gestureDeltaCache;
										
									}
								}
								///////////////////////////////////////////////////////////////////////////////////////////
							}
							
							// NEEDS DEVELOPMENT
							// NEED TO ELIMINATE SLOW MOVING POINTS IN FLICK ALGORITHM
							if (gO.pOList[key].dispatch_mode =="point_remove")
							{
								//if ((!gO.release) && (cO.point_remove) && (!gO.pOList[key].complete)) gO.pOList[key].dispatchEvent = true;
								if ((ts.cO.point_remove) && (!gO.pOList[key].complete)) gO.pOList[key].dispatchEvent = true;
								//else if ((gO.release) && (cO.point_remove) && (!gO.pOList[key].complete)) gO.pOList[key].dispatchEvent = true;
								
								// just pulls from pipeline as normal as points are touching
								//trace("point remove",gO.pOList[key].dispatchEvent)
							}
							
							else if (gO.pOList[key].dispatch_mode =="batch")
							{
								// prime for dispatch
								if (!gO.pOList[key].complete) gO.pOList[key].dispatchEvent = true;
							}
							
							else if (gO.pOList[key].dispatch_mode =="")
							{
								// prime for dispatch
								if (!gO.pOList[key].complete) gO.pOList[key].dispatchEvent = true;
								//trace("nothing",gO.pOList[key].dispatchEvent)
							}
						}
						
						// continuous gesture events always dispatch each processing frame
						else if (gO.pOList[key].dispatch_type =="continuous")
						{
							// prime for dispatch
							gO.pOList[key].dispatchEvent = true;
						}
						
						
				}
		}
		
		// needs to move to touchsprite cluster
		public function processTemoralMetric():void {
			
			var tapCalled:Boolean = false; // prevents multi gesture search
			var dtapCalled:Boolean = false;
			var ttapCalled:Boolean = false;
			
			//gn = gO.pOList.length;
			for (key=0; key < gn; key++) 
			//for (key in gO.pOList)
					{
					
					
					if ((gO.pOList[key].algorithm_class == "temporalmetric")&&(gO.pOList[key].algorithm_type == "discrete")){	
					
					//trace("TEMPROAL METRIC");
					// SEARCH FOR EVENT MATCH LIST	
					
					// AVOIDS THE NEED TO HAVE MORE EVENTS AND LISTENERS IN THE DISPLAY LIST
					// DO NOT LISTEN INSTEAD LOOK FOR EVIDENCE ON TIMELINE
					
					//search for touch end events on timeline
					if ((gO.pOList[key].match_TouchEvent == "touchEnd")|| (gO.pOList[key].match_GestureEvent == "tap") )
					{
						if ((tiO.timelineOn) && (tiO.pointEvents) && (tiO.frame.pointEventArray))
						{
						
						// in current frame
						for (var j:int = 0; j < ts.tiO.frame.pointEventArray.length; j++) 
								{
								if (tiO.frame.pointEventArray[j].type == "touchEnd" ) 
								{
									//trace("touch end")
								
									//FIND TOUCHBEGIN/TOUCHEND PAIRS
									if ((tapOn) && (!tapCalled))
									if((gO.pOList[key].gesture_type == "tap")||(gO.pOList[key].gesture_type == "double_tap")||(gO.pOList[key].gesture_type == "triple_tap")){
									{	
										//gesture_disc.findGestureTap(tiO.frame.pointEventArray[j], gO.pOList[key].gesture_id) ; // tap event pairs
										gesture_disc.findGestureTap(tiO.frame.pointEventArray[j], key) ; // tap event pairs
										tapCalled = true; // if called by another gesture using tap do not call again
										//trace("trace find tap",gO.pOList[key].gesture_id);
									}
									}
								}
								}
						}
					}
					

					if (gO.pOList[key].match_GestureEvent == "tap") 
					{
							if (tiO.history[0])
							{
							for (var k:int = 0; k < tiO.history[0].gestureEventArray.length; k++) 
								{
									if (tiO.history[0].gestureEventArray[k].type == "tap" ) {
										
										// FIND TAP EVENT PAIRS
										if ((gO.pOList[key].gesture_type == "double_tap") && (!dtapCalled))	
										{
											//gesture_disc.findGestureDoubleTap(tiO.history[0].gestureEventArray[k], gO.pOList[key].gesture_id);
											gesture_disc.findGestureDoubleTap(tiO.history[0].gestureEventArray[k], key);
											dtapCalled = true;
										}
										
										// FIND TAP EVENT TRIPLETS
										if ((gO.pOList[key].gesture_type == "triple_tap")&& (!ttapCalled))
										{
											//gesture_disc.findGestureTripleTap(tiO.history[0].gestureEventArray[k], gO.pOList[key].gesture_id);
											gesture_disc.findGestureTripleTap(tiO.history[0].gestureEventArray[k], key);
											ttapCalled = true;
										}
										
										//???????????????????????????????????????????
										// find hold and tap event pairs??
										//if ((gO.pOList[key].gesture_type == "hold_tap")&& (!htapCalled))
										//{
											//gesture_disc.findGestureHoldTap(tiO.history[0].gestureEventArray[k], key);
											//htapCalled = true;
										//}
									}
								}
							}
					}	
					
					///////////////////////////////////////////////////////////////////////////
					// generic event pair search
					
					// IF EVENT B OCCURES
					// GO BACK AND LOOK FOR EVENT A
					//????????????????????????????????????????????????
					//if (gO.pOList[key].match_gestureEvent == "hold") 
					//{
						
					//}
					///////////////////////////////////////////////////////////////////////////	
					
					
					/////////////////////////////////////////////////////////////////////////////////////////////
					/////////////////////////////////////////////////////////////////////////////////////////////
				
					/////////////////////////////////////////////////////////////////////////////////////////////////
					// process discrete gestures batches for dispatch
					/////////////////////////////////////////////////////////////////////////////////////////////////
					if ((gO.pOList[key].dispatch_mode == "batch"))
						{
								//tap counter
								if (gO.pOList[key].gesture_type == "tap") 
								{
									//if (gO.pOList[key].timer_count > Math.ceil(gO.pOList[key].dispatch_interval * GestureWorks.application.frameRate * 0.001)) gO.pOList[key].timer_count = 0;
									if (gO.pOList[key].timer_count > gO.pOList[key].dispatch_interval ) gO.pOList[key].timer_count = 0;
									
									if (gO.pOList[key].timer_count == 0) {
										//gesture_disc.countTapEvents(gO.pOList[key].gesture_id);
										gesture_disc.countTapEvents(key);
										//trace("count tap",gO.pOList[key].timer_count);
										//trace("d mode", gO.pOList[key].dispatchEvent);
										//
										//DIPATCH EVENT LOCKES AND IS NOT ACTIVATED IN COUNT TAP EVENTS??
										//
								
									}
									gO.pOList[key].timer_count++
								}
								// double tap counter
								if (gO.pOList[key].gesture_type == "double_tap") 
								{
									//if (gO.pOList[key].timer_count > Math.ceil(gO.pOList[key].dispatch_interval * GestureWorks.application.frameRate * 0.001)) gO.pOList[key].timer_count = 0;
									if (gO.pOList[key].timer_count > gO.pOList[key].dispatch_interval) gO.pOList[key].timer_count = 0;
									
									if (gO.pOList[key].timer_count == 0) {
										//gesture_disc.countDoubleTapEvents(gO.pOList[key].gesture_id);
										gesture_disc.countDoubleTapEvents(key);
										//trace("count dtap",gO.pOList[key].timer_count);
									}
									gO.pOList[key].timer_count++
								}
												
								// triple tap counter
								if (gO.pOList[key].gesture_type == "triple_tap") 
								{
									if (gO.pOList[key].timer_count > gO.pOList[key].dispatch_interval) gO.pOList[key].timer_count = 0;
									
									if (gO.pOList[key].timer_count == 0) {
										//gesture_disc.countTripleTapEvents(gO.pOList[key].gesture_id);
										gesture_disc.countTripleTapEvents(key);
										//trace("count dtap",gO.pOList[key].timer_count);
									}
									gO.pOList[key].timer_count++
								}
								
								//trace("d mode",gO.pOList[key].dispatchEvent);
						}
						
						///////////////////////////
						// goes through current frame and dispatched current tap double tap and triple tap events direct from timeline.
						/*
						if ((gO.pOList[key].dispatch_mode == "stream"))
						{
							var gestureEventArray:Array = tiO.frame.gestureEventArray
							
							for (var p:int = 0; p < gestureEventArray.length; p++)
								{
								if((gO.pOList[key].gesture_type=="tap")||(gO.pOList[key].gesture_type=="double_tap")||(gO.pOList[key].gesture_type=="triple_tap")){
								if (gO.pOList[key].gesture_type == gestureEventArray[p].type) dispatchEvent(gestureEventArray[p]);	
								}
								}
						}
						*/
						
						
						
						
						
					}
				}
		}
		
		
		
		public function dispatchReset():void 
		{
			//trace("dispatch reset ");
			//gn = gO.pOList.length;
			for (key=0; key < gn; key++) 
			//for (key in gO.pOList) 
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
							if (ts.N == 0)
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
						if (ts.gO.pOList[key].dispatch_reset == "point_remove") // 
						{
							//trace("--",dN,_N, cO.point_remove)
							if(cO.point_remove) // point change
							{
								gO.pOList[key].complete = false;
								gO.pOList[key].activeEvent = false;
							}
						}
						
						// AUTO RESET DISCRETE GESTURE
						else if (ts.gO.pOList[key].dispatch_reset == "") 
						{
							//trace(key, "auto reset");
							// auto reset each frame
							gO.pOList[key].complete = false;
							gO.pOList[key].activeEvent = false;
						}	
					}
					//trace(key,gO.pOList[key].complete,gO.pOList[key].dispatchEvent,gO.pOList[key].activeEvent,gO.pOList[key] );
			}
		}
		
		/**
		* @private
		*/
		public function dispatchGestures():void 
		{	
			//if (trace_debug_mode) trace("continuous gesture event dispatch");//trace("dispatch--------------------------",gO.release);
		
			
			
			// MANAGE TIMELINE
			if (tiO.timelineOn)
			{
				//if (trace_debug_mode) trace("timeline frame update");
				TimelineHistories.historyQueue(ts.clusterID);			// push histories 
				tiO.frame = new FrameObject();						// create new timeline frame //trace("manage timeline");
			}
			
			// start OBJECT complete event gesturing
			if ((gO.start)&&(ts.gestureEventStart))
			{
				ts.dispatchEvent(new GWGestureEvent(GWGestureEvent.START, gO.id));
				if((tiO.timelineOn)&&(ts.tiO.gestureEvents))	tiO.frame.gestureEventArray.push(new GWGestureEvent(GWGestureEvent.START, gO.id));
				gO.start = false;
				//trace("start fired");
			}
			
			//////////////////////////////////////////////
			// custom GML gesture events with active event
			//////////////////////////////////////////////
			//gn = gO.pOList.length;
			for (key=0; key < gn; key++) 
			//for (key in gO.pOList) 
				{	
					//ts.gO.pOList[key].dispatchEvent = true;
					//trace("dispatchgesture",gO.pOList[key].activeEvent,gO.pOList[key].dispatchEvent)
					if ((gO.pOList[key].activeEvent) && (gO.pOList[key].dispatchEvent))	constructGestureEvents(key);
				}
				
			///////////////////////////////////////////////
			// RELEASE GESTURE SWITCHES OFF RELEASE STATE SO MUST PROCESS ALL RELEASE BASED GESTURES FIRST
			// gesture OBJECT release gesture
			if ((gO.release)&&(ts.gestureEventRelease))
			{
				ts.dispatchEvent(new GWGestureEvent(GWGestureEvent.RELEASE, gO.id));
				if ((tiO.timelineOn) && (tiO.gestureEvents))	tiO.frame.gestureEventArray.push(new GWGestureEvent(GWGestureEvent.RELEASE, gO.id));
				gO.release = false;
				//trace("release fired");
			}
			
			// gesture OBJECT complete event
			if ((gO.complete)&&(ts.gestureEventComplete))
			{
				ts.dispatchEvent(new GWGestureEvent(GWGestureEvent.COMPLETE, gO.id));
				if((tiO.timelineOn)&&(tiO.gestureEvents))	tiO.frame.gestureEventArray.push(new GWGestureEvent(GWGestureEvent.COMPLETE, gO.id));
				gO.complete = false;
				//trace("complete fired");
			}
		
			gO.start = false;
			gO.release = false;
			gO.complete = false;			
		}
		
		public function constructGestureEvents(key:uint):void 
		{
		
							//trace("dispatch gesture construct",key);
							//////////////////////////////
							// generic custom geture events
							//////////////////////////////
							//trace("testing all attached gestures",gO.pOList[key].activeEvent, key, gO.pOList[key].x, gO.pOList[key].y, gO.pOList[key].n);
							
							// transform center point
							//var trans_pt:Point = globalToLocal(new Point(cO.x, cO.y)); //local point
							var trans_pt:Point = ts.globalToLocal(new Point(gO.pOList[key].data.x, gO.pOList[key].data.y)); //local point
							// transform vector components
							
							//construct standard properties
							var Data:Object = new Object();
							
								// GESTURE OBJECT ID
								Data["id"] = new Object();
								Data["id"] = gO.pOList[key].gesture_id;//key;
								
								// gestureCount
								// GESTURE EVENT ID
								// gestureID =.. number of times this gesture has dispatched
								
								// MATCHING N VALUE
								Data["n"] = new Object();
								Data["n"] = gO.pOList[key].n//N; static selection criteria
								
								///////////////////////////////////////////
								//NEED DIFFERENT MATCH AND PROPERTY SLOTS
								///////////////////////////////////////////
								//MATCH_N // DIFFERENT FROM CURRENT N OR EVENT COUNT N
								//MATCH X MIN MAX
								//MATCH Y MIN MAX
								//MATCH X VELOCITY AND ACCELERATION
								//MATCH POINT RADIUS
								//MATCH POINT PRESSURE
								//MATCH GESTURE EVENT LIST
								
								
								// location data
								Data["stageX"] = new Object();
								Data["stageX"] = gO.pOList[key].data.x//cO.x;
								
								Data["stageY"] = new Object();
								Data["stageY"] = gO.pOList[key].data.y//cO.y;
								
								Data["x"] = new Object();
								Data["x"] = gO.pOList[key].data.x//cO.x;
								
								Data["y"] = new Object();
								Data["y"] = gO.pOList[key].data.y//cO.y;
								
								Data["localX"] = new Object();
								Data["localX"] = trans_pt.x;
								
								Data["localY"] = new Object();
								Data["localY"] = trans_pt.y;
								
								// for stroke
								//gO.pOList[key].path_match;
								
								// NEED MORE DYNAMIC VARIABLES
								// GESRTURE VALUE
								// GESTURE VECTOR
								// GESTURE DIM DATA OBJECT ?? ANY NUMBER OF CUSTOM NAMED VALUES FOR EACH DIM
								
								// construc tgesture object dependant properties
								var dn:uint = gO.pOList[key].dList.length;
								
								//trace("dn",dn);
								
								for (DIM=0; DIM < dn; DIM++)
								//for (DIM in gO.pOList[key].dList)
								{
									Data[gO.pOList[key].dList[DIM].property_id] = new Object();
									Data[gO.pOList[key].dList[DIM].property_id] = Number(gO.pOList[key].dList[DIM].gestureDelta);	
									//trace(gO.pOList[key].dList[DIM].gestureDeltaCache);
								}
							//trace(gO.pOList[key].gesture_type,gO.pOList[key].gesture_id)
								
							var GWEVENT:GWGestureEvent = new GWGestureEvent(gO.pOList[key].gesture_type, Data);
							ts.dispatchEvent(GWEVENT);

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
		
	}
}