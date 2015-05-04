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
	import com.gestureworks.managers.PoolManager;
	import flash.display.Sprite;
	import flash.events.TouchEvent;
	import flash.geom.Point;
	
	import com.gestureworks.events.GWEvent;
	import com.gestureworks.events.GWGestureEvent;
	//import com.gestureworks.analysis.GesturePipeline;
	import com.gestureworks.analysis.CoreTemporalMetric;
	
	//import com.gestureworks.managers.TimelineHistories;
	import com.gestureworks.objects.FrameObject; 
	import com.gestureworks.objects.DimensionObject;
	
	import com.gestureworks.objects.ipClusterObject;
	import com.gestureworks.objects.StrokeObject;
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
		//public var gesture_disc:CoreTemporalMetric;
		
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
		
		//private var cO:ipClusterObject
		private var sO:StrokeObject
		private var gO:GestureListObject;
		private var tiO:TimelineObject;
		
		private var sub_cO:ipClusterObject
		/////////////////////////////////////////////////////////
		
		public function TouchGesture(touchObjectID:int):void
		{
			//super();
			id = touchObjectID;
			ts = GestureGlobals.gw_public::touchObjects[id];
			
			sub_cO = new ipClusterObject();
			
			//TODO: POINT TO RELEVANT SUBCLUSTER //cO = GestureGlobals.gw_public::clusters[id]//ts.cO;
			//sO = GestureGlobals.gw_public::clusters[id]//ts.sO;
			gO = GestureGlobals.gw_public::gestures[id]//ts.gO;
			tiO = GestureGlobals.gw_public::timeline//ts.tiO;
			
			initGesture();
         }
		 
		// initializers   
         public function initGesture():void 
         {
			//if(traceDebugMode) trace("create touchsprite gesture");
		}
		
		/**
		* @private
		*/
		public function manageGestureEventDispatch():void 
		{
			//trace("manage dispatch-----------------------------");
			
			//////////////////////////////////////////////////////////////
			// ONLY IF GESTURE EVENTS ARE ACTIVE
			if (ts.gestureEvents)
			{
				//get gn for interaction object
				gn = gO.pOList.length;
				
				dispatchMode();
				dispatchGestures();
				dispatchReset();
			}
		}
		
		
		////////////////////////////////////////////////////////////////////////////////////
		///////////////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////////
		
		public function dispatchMode():void 
		{
			//trace("dispatch mode -- touch gesture------------------------");
		
			for (key=0; key < gn; key++) 
					{	
						var dn:uint = gO.pOList[key].dList.length;
						
						//SET CURRENT N IN GESTURE OBJECT
						gO.pOList[key].n_current = ts.tpn;//N
						
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
								if ((gO.pOList[key].gesture_type == "flick")||(gO.pOList[key].gesture_type == "swipe"))
								{	
									// PULL CACHED N VALUE
									gO.pOList[key].n_current = gO.pOList[key].n_cache;
									
									if (gO.pOList[key].activeEvent)
									{
										for (DIM=0; DIM < dn; DIM++)
										{
											gO.pOList[key].dList[DIM].gestureDelta = gO.pOList[key].dList[DIM].gestureDeltaCache;
											//trace("pull cache",gO.pOList[key].dList[DIM].gestureDeltaCache)
										}
									}
								}
								
								if (gO.pOList[key].gesture_type == "stroke")
								{
									gO.pOList[key].dispatchEvent = false;
									//gO.pOList[key].complete = true;
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
		
		/**
		* @private
		*/
		
		public function dispatchReset():void 
		{
			//trace("dispatch reset ");
			//gn = gO.pOList.length;
			for (key=0; key < gn; key++) 
			//for (key in gO.pOList) 
					{	
						
					//trace("managing reset", key, gO.pOList[key].dispatch_type,gO.pOList[key].dispatch_reset,gO.pOList[key].complete);
					
					////////////////////////////
					//
					//////////////////////////////
					gO.pOList[key].n_cache = ts.tpn;
					
					
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
							if (ts.tpn == 0)//N
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
							if((ts.cO.point_remove)||(sub_cO.point_add)) // point change
							{
								gO.pOList[key].complete = false;
								gO.pOList[key].activeEvent = false;
							}
						}
						
						//when point added reset
						if (gO.pOList[key].dispatch_reset == "point_add") // 
						{
							//trace("--",dN,_N, cO.point_add)
							if(ts.cO.point_add) // point change
							{
								gO.pOList[key].complete = false;
								gO.pOList[key].activeEvent = false;
							}
						}
						
						//when point removed reset
						if (ts.gO.pOList[key].dispatch_reset == "point_remove") // 
						{
							//trace("--",dN,_N, cO.point_remove)
							if(ts.cO.point_remove) // point change
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
			//if (traceDebugMode) trace("continuous gesture event dispatch");
			//trace("touch gesture dispatch--------------------------",gO.release);

			// start OBJECT complete event gesturing
			if ((gO.start)&&(ts.gestureEventStart))
			{
				ts.dispatchEvent(new GWGestureEvent(GWGestureEvent.START, {id:gO.id}));
				//if(tiO.timelineOn && ts.tiO.gestureEvents && tiO.frame.gestureEventArray)	tiO.frame.gestureEventArray.push(new GWGestureEvent(GWGestureEvent.START, {id:gO.id,x:ts.cO.position.x,y:ts.cO.position.y}));
				gO.start = false;
				//trace("start fired",cO.x,cO.y);
			}
			
			//////////////////////////////////////////////
			// custom GML gesture events with active event
			//////////////////////////////////////////////
			
			//trace("gesture dispatch",key, gn)
			
			for (key=0; key < gn; key++) 
				{	
					//trace("dispatchgesture",gO.pOList[key].activeEvent,gO.pOList[key].dispatchEvent, key)
					// IF GESTURE EVENT
					if ((gO.pOList[key].activeEvent) && (gO.pOList[key].dispatchEvent))	constructGestureEvents(key);
					
					
					// IF KEYBOARD EVENT
					// BUILD // CONSTRUCT KEYBOARDEVENTS()
					//dispatchEvent(new KeyboardEvent(KeyboardEvent.KEY_DOWN, true, false, charCodeRef, keyCode, 10));
				}
				
			///////////////////////////////////////////////
			// RELEASE GESTURE SWITCHES OFF RELEASE STATE SO MUST PROCESS ALL RELEASE BASED GESTURES FIRST
			// gesture OBJECT release gesture
			if ((gO.release)&&(ts.gestureEventRelease))
			{
				ts.dispatchEvent(new GWGestureEvent(GWGestureEvent.RELEASE, {id:gO.id}));
				//if (tiO.timelineOn && tiO.gestureEvents && tiO.frame.gestureEventArray)	tiO.frame.gestureEventArray.push(new GWGestureEvent(GWGestureEvent.RELEASE, {id:gO.id,x:ts.cO.position.x,y:ts.cO.position.y}));
				gO.release = false;
				//trace("release fired",cO.x,cO.y);
			}
			
			// gesture OBJECT complete event
			if ((gO.complete)&&(ts.gestureEventComplete))
			{
				ts.dispatchEvent(new GWGestureEvent(GWGestureEvent.COMPLETE,{id:gO.id}));
				//if(tiO.timelineOn && tiO.gestureEvents && tiO.frame.gestureEventArray)	tiO.frame.gestureEventArray.push(new GWGestureEvent(GWGestureEvent.COMPLETE, {id:gO.id,x:ts.cO.position.x,y:ts.cO.position.y}));
				gO.complete = false;
				//trace("complete fired",cO.x,cO.y);
			}
		
			gO.start = false;
			gO.release = false;
			gO.complete = false;	
			
			
			//--manageTimeline();
			//traceTimeline();
		}
		

		/**
		* @private
		*/
		public function constructGestureEvents(key:uint):void 
		{
		
							//trace("dispatch gesture construct",key);
							//////////////////////////////
							// generic custom geture events
							//////////////////////////////
							//trace("testing all attached gestures",gO.pOList[key].activeEvent, key, gO.pOList[key].data.x, gO.pOList[key].data.y, gO.pOList[key].n);
							
							// transform center point
							//var trans_pt:Point = globalToLocal(new Point(cO.x, cO.y)); //local point
							var trans_pt:Point = ts.globalToLocal(new Point(gO.pOList[key].data.x, gO.pOList[key].data.y)); //local point
							// transform vector components
							
							//construct standard properties
							var Data:Object = new Object();
							
								// GESTURE OBJECT ID
								Data["id"] = new Object();
								Data["id"] = gO.pOList[key].gesture_id;//key;
								//Data["id"] = gO.gesture_id;//key;
								
								
								// gestureCount
								// GESTURE EVENT ID
								// gestureID =.. number of times this gesture has dispatched
								
								// MATCHING N VALUE
								Data["n"] = new Object();
								//Data["n"] = gO.pOList[key].n//N; static selection criteria/ FOR SOME REASON N IS BEING ZEROED????? IN GESTURE OBJECT
								//Data["n"] = cO.n // not great for swipe and flick as always zero
								Data["n"] = gO.pOList[key].n_current;
								
								//N; static selection criteria
								
								
								//trace("N...",gO.pOList[key].nMax,gO.pOList[key].nMin,gO.pOList[key].n,gO.pOList[key].gesture_id);
								
								///////////////////////////////////////////
								//NEED DIFFERENT MATCH AND PROPERTY SLOTS
								///////////////////////////////////////////
								//MATCH_N // DIFFERENT FROM CURRENT N OR EVENT COUNT N OR CHACHED_N FOR FLICK OR SWIPE
								//MATCH X MIN MAX
								//MATCH Y MIN MAX
								//MATCH X VELOCITY AND ACCELERATION
								//MATCH (ZONE) CENTER POINT, START AND END POINT
								
								//MATHC ACCELEROMETER VALUE
								//MATCH POINT RADIUS
								//MATCH POINT PRESSURE
								//MATCH GESTURE EVENT LIST
								
								
								
								// location data
								Data["stageX"] = new Object();
								Data["stageX"] = gO.pOList[key].data.x//cO.x;
								
								Data["stageY"] = new Object();
								Data["stageY"] = gO.pOList[key].data.y//cO.y;

								Data["stageZ"] = new Object();
								Data["stageZ"] = gO.pOList[key].data.z//cO.y;								
								
								Data["x"] = new Object();
								Data["x"] = gO.pOList[key].data.x//cO.x;
								
								Data["y"] = new Object();
								Data["y"] = gO.pOList[key].data.y//cO.y;

								Data["z"] = new Object();//3d
								Data["z"] = gO.pOList[key].data.z//cO.y;//3d
							
								
								Data["localX"] = new Object();
								Data["localX"] = trans_pt.x;
								
								Data["localY"] = new Object();
								Data["localY"] = trans_pt.y;
								
								// default stroke data
								Data["path"] = gO.pOList[key].data.path_data;
								Data["prob"] = gO.pOList[key].data.prob;
								Data["stroke_id"] = gO.pOList[key].data.stroke_id;
								Data["x0"] = gO.pOList[key].data.x0//cO.x;
								Data["x1"] = gO.pOList[key].data.x1//cO.x;
								Data["y0"] = gO.pOList[key].data.y0//cO.x;
								Data["y1"] = gO.pOList[key].data.y1//cO.x;
								Data["width"] = gO.pOList[key].data.width//cO.x;
								Data["height"] = gO.pOList[key].data.height//cO.x;
								
								// NEED MORE DYNAMIC VARIABLES
								// GESRTURE VALUE
								// GESTURE VECTOR
								// GESTURE DIM DATA OBJECT ?? ANY NUMBER OF CUSTOM NAMED VALUES FOR EACH DIM
								
								
								// construct gesture object dependant properties
								var dn:uint = gO.pOList[key].dList.length;
								//trace("dn",dn);
								
								for (DIM=0; DIM < dn; DIM++)
								//for (DIM in gO.pOList[key].dList)
								{
									Data[gO.pOList[key].dList[DIM].property_id] = new Object();
									Data[gO.pOList[key].dList[DIM].property_id] = Number(gO.pOList[key].dList[DIM].gestureDelta);	
									//trace(gO.pOList[key].dList[DIM].gestureDeltaCache);
									
									//trace("@touch gesture, data on gesture dims",gO.pOList[key].dList[DIM].property_id, Data[gO.pOList[key].dList[DIM].property_id],gO.pOList[key].dList[DIM].clusterDelta,gO.pOList[key].dList[DIM].gestureDelta);
								}
							
							
							// USES THE DEFINED EVENT TYPE
							//var GWEVENT:GWGestureEvent = new GWGestureEvent(type, Data);
							var GWEVENT:GWGestureEvent = new GWGestureEvent(gO.pOList[key].event_type, Data);
							
						//trace("type-----------", gO.pOList[key].event_type, GWEVENT.type,GWEVENT.value.x,GWEVENT.value.y,GWEVENT.value.z,GWEVENT.value.dx,GWEVENT.value.dy);
							//trace(gO.pOList[key].event_type,gO.pOList[key].gesture_id)
							
							// will need to create temporal event manager and dispatch manager
							//NOTE TAP IS MODAL GENERIC TAP WHICH SHOULD BE TRIGGERED WITH ANY MODAL INPUT TYPE
							//TOUCH_TAP WILL TRIGGER ON ANY TOUCH CLASSIFIED INPUT
							//TOUCH_FINGER_TAP WILL ONLY TRIGGER ON FINGER CLASSIFIED TOUCH INPUT
							//MOTION_TAP WILL TRIGGER ON ANY MOTION INPUT
							if (GWEVENT.type != "tap" && GWEVENT.type != "touch_finger_tap"&& GWEVENT.type != "motion_hold" && GWEVENT.type != "motion_tap") //motion_flick, motion_swipe
							{
								//trace("touch gesture", gO.pOList[key].event_type, gO.pOList[key].activeEvent, gO.pOList[key].dispatchEvent)
								//trace(gO.pOList[key].active, gO.release, gO.passive, gO.complete)
								
								ts.dispatchEvent(GWEVENT);
								//TODO: CHECK THAT GESTURE EVENTS WILL WRITE WHEN SET TO ON
								//if ((tiO.timelineOn) && (tiO.gestureEvents))	
								//----if (ts.tiO.frame.gestureEventArray) ts.tiO.frame.gestureEventArray.push(GWEVENT);
								if (tiO.frame.gestureEventArray) tiO.frame.gestureEventArray.push(GWEVENT);
								//trace("GESTURE EVENT PUSH",tiO.timelineOn,tiO.gestureEvents,gO.pOList[key].event_type,GestureGlobals.frameID)
							}
							
							//NOTE TOUCGH GESTURE EVENTS WERE BEING REACTIVATED BY MOTION INOPUT AND INTERFERING WITH MOTION GESTURE EVENTS
							// FIX WAS TO FILTER CLUSTER PROCESSING SO THAT EVENTACTIVE STATES WERE NOT OVERWRITTEN
						
						// reset dispatch
						gO.pOList[key].dispatchEvent = false;	
						// close event for this dispatch cycle
						gO.pOList[key].activeEvent = false;
						// set gesture event phase logic
						gO.pOList[key].complete = true;
		}
		
	}
}