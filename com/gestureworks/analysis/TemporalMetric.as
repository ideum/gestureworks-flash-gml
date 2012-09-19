﻿////////////////////////////////////////////////////////////////////////////////
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
	import flash.geom.Point;
	
	//import com.gestureworks.core.TouchSprite;
	import com.gestureworks.core.GestureGlobals;
	import com.gestureworks.core.GestureWorks;
	import com.gestureworks.core.gw_public;
	import com.gestureworks.core.GML;
	import com.gestureworks.objects.FrameObject;
	import com.gestureworks.events.GWEvent;
	import com.gestureworks.events.GWGestureEvent;
	
	//import com.gestureworks.analysis.paths.PathCollection;
	//import com.gestureworks.analysis.paths.PathCollectionIterator; PathCollectionIterator;
	//import com.gestureworks.analysis.paths.PathDictionary; PathDictionary;
	//import com.gestureworks.analysis.paths.PathProcessor; PathProcessor;
		
	public class TemporalMetric
	{
		private var touchObjectID:int;
		private var ts:Object;//	private var ts:TouchSprite;
		
		// pause time between gesture event counting cycles
		private var tap_pauseTime:int = 0;
		private var dtap_pauseTime:int = 0;
		private var ttap_pauseTime:int = 0;
		
		// sets gesture id for individual tap events
		private var tapID:int = 0;
		private var dtapID:int = 0;
		private var ttapID:int = 0;
		
		// sets gesture id for tap clusters
		private var ntapID:int = 0;
		private var ndtapID:int = 0;
		private var nttapID:int = 0;
		
		// counts event threads on timeline of touch object
		private var tapEventCount:int = 0;
		private var dtapEventCount:int = 0;
		private var ttapEventCount:int = 0;
		
		private var DIM:uint; 
		
		public function TemporalMetric(_id:int) {
			
			touchObjectID = _id;
			init();
		}
		
		public function init():void
		{
			ts = GestureGlobals.gw_public::touchObjects[touchObjectID];
			
			if (ts.trace_debug_mode) trace("init gesture discrete analysis");
			
			//trace(GestureGlobals.touchFrameInterval)
		}
		
		
		public function findGestureTap(event:TouchEvent, key:int ):void // each time there is a touchEnd
		{
			//if (ts.trace_debug_mode) 
			//trace("find taps---------------------------------------------------------", key, ts.gO.release);
			
			// CHECK GML COMPATABILITY
			var tap_time:int = 10//Math.ceil(ts.gO.pOList[key]["tap_x"].point_event_duration_threshold * GestureWorks.application.frameRate * 0.001);//10
			//var tap_time:int = Math.ceil(ts.gO.pOList[key]["tap_x"].point_event_duration_threshold / GestureGlobals.touchFrameInterval);//10
			var tap_dist:int = 10//ts.gO.pOList[key]["tap_x"].point_translation_threshold;//10
			
			
			
			var pointEventArray:Array = ts.tiO.frame.pointEventArray
				
				for (var p:int = 0; p < pointEventArray.length; p++) 
				{
					//trace("point event array", ts.tiO.frame.pointEventArray[p].type)
					
					////////////////////////////////////////
					// check current frame first
					////////////////////////////////////////
					
					// match type and id
					if ((pointEventArray[p].type =="touchBegin")&&(pointEventArray[p].touchPointID == event.touchPointID))
						{
							var dx:Number = Math.abs(pointEventArray[p].stageX - event.stageX)
							var dy:Number = Math.abs(pointEventArray[p].stageY - event.stageY)
					
							// match dist							
							if ((dx < tap_dist) && (dy < tap_dist))
							{
								// add tap event to gesture timeline 
								// uses touchEnd id and position
								//trace("Current Frame TAP", pointEventArray[p].touchPointID);
								tapID ++;
								var tap_event:GWGestureEvent = new GWGestureEvent(GWGestureEvent.TAP, { x:event.stageX, y:event.stageY, localX:event.localX, localY:event.localY, gestureID:tapID , id:key} );
								ts.tiO.frame.gestureEventArray.push(tap_event);
								//ts.onGestureTap(tap_event);
								return; // must exit if finds as do not want to refind
							}	
						}
					else {
					////////////////////////////////////////
					//look in history
					////////////////////////////////////////
						
							for (var i:int = 0; i < tap_time; i++) // 20 fames
								{
							
								if (ts.tiO.history[i])
								{
								pointEventArray = ts.tiO.history[i].pointEventArray;
							
									for (var j:int = 0; j < pointEventArray.length; j++) 
									{
										if ((pointEventArray[j].type =="touchBegin")&&(pointEventArray[j].touchPointID == event.touchPointID))
										{
											var dx0:Number = Math.abs(pointEventArray[j].stageX - event.stageX)
											var dy0:Number = Math.abs(pointEventArray[j].stageY - event.stageY)
											
											//trace(dx0,dy0)
											
											if ((dx0 < tap_dist) && (dy0 < tap_dist))
											{
												// add tap event to gesture timeline 
												// uses touchEnd id and position
												//trace("History TAP", pointEventArray[j].touchPointID);
												tapID ++;
												var tap_event0:GWGestureEvent = new GWGestureEvent(GWGestureEvent.TAP, { x:event.stageX, y:event.stageY, localX:event.localX, localY:event.localY, gestureID:tapID , id:key} );
												//if (ts.tiO.pointEvents)
												ts.tiO.frame.gestureEventArray.push(tap_event0);
												
												//-- would normally call custom tap count function and double count checks ts.onGestureTap(tap_event0);
												
												//ts.gO.pOList[key].activeEvent = true;
												
												return; //must exit if finds, as need most recent pair
											}	
										}	
									}
								}	
								}	
						}
						/////////////////////////////////////////
				}
		}
		
		
		public function findGestureDoubleTap(event:GWGestureEvent,key:int):void
		{
			//if (ts.trace_debug_mode)
			//trace("find d taps---------------------------------------------------------");
		
				var dtap_time:int = 30//Math.ceil(ts.gO.pOList[key]["double_tap_x"].point_interevent_duration_threshold * GestureWorks.application.frameRate * 0.001); //20frames
				//var dtap_time:int = Math.ceil(ts.gO.pOList[key]["double_tap_x"].point_interevent_duration_threshold / GestureGlobals.touchFrameInterval);//20
				var dtap_dist:int = 30//ts.gO.pOList[key]["double_tap_x"].point_translation_threshold;//20px
				
				var	gestureEventArray:Array = new Array();
				
				//trace(dtap_time);
				
				// find tap pairs 
				// dont need current frame as never double tap in a single frame
				// LOOK IN HISTORY
				for (var i:uint = 0; i < dtap_time; i++) 
					{
					if (ts.tiO.history[i])
					{
					gestureEventArray = ts.tiO.history[i].gestureEventArray;

							for (var j:uint = 0; j < gestureEventArray.length; j++) 
								{
									if ((gestureEventArray[j].type =="tap")&&(event.value.gestureID != gestureEventArray[j].value.gestureID)) // so as no tto count self
									{
										var distX:Number = Math.abs(event.value.x - gestureEventArray[j].value.x);
										var distY:Number = Math.abs(event.value.y - gestureEventArray[j].value.y);
										
										if ((distX < dtap_dist) && (distY < dtap_dist)) 
										{
											//trace("hist DOUBLE TAP",distX,distY);
											var spt:Point = new Point (event.value.x, event.value.y); // stage point
											var lpt:Point = ts.globalToLocal(spt); //local point
											
											dtapID++;
											var dtap_event:GWGestureEvent = new GWGestureEvent(GWGestureEvent.DOUBLE_TAP, { x:spt.x , y:spt.x, stageX:spt.x , stageY:spt.y, localX:lpt.x , localY:lpt.y, gestureID:dtapID, id:key});
											//if (ts.tiO.pointEvents) 
											ts.tiO.frame.gestureEventArray.push(dtap_event);
											//trace("double tap detected", dtap_event.type)
											return; 
										}
									}
								}
						}
					}	
		}
		
		
		public function findGestureTripleTap(event:GWGestureEvent,key:int):void
		{
			if (ts.trace_debug_mode) trace("find t taps---------------------------------------------------------");
		
				var ttap_time:int = 20
				//var ttap_time:int = Math.ceil(ts.gO.pOList[key]["triple_tap_x"].point_interevent_duration_threshold / GestureGlobals.touchFrameInterval);//20
				var ttap_dist:int = 30//ts.gO.pOList[key]["triple_tap_x"].point_translation_threshold;//20
				
				var	gestureEventArray:Array = new Array();
				
					//trace(ttap_time);
				
				// find tap pairs // dont need current frame as never double tap in a single frame
				// LOOK IN HISTORY
				for (var i:uint = 0; i < ttap_time; i++) 
					{
					if (ts.tiO.history[i])
					{
					gestureEventArray = ts.tiO.history[i].gestureEventArray;

							for (var j:uint = 0; j < gestureEventArray.length; j++) 
								{
									//trace(gestureEventArray[j].type,event.value.gestureID,gestureEventArray[j].value.gestureID);
									if ((gestureEventArray[j].type =="tap")&&(event.value.gestureID != gestureEventArray[j].value.gestureID))
									{
										//trace("ID", event.value.tapID, gestureEventArray[j].value.tapID)
										var dx1:Number = Math.abs(event.value.x - gestureEventArray[j].value.x);
										var dy1:Number = Math.abs(event.value.y - gestureEventArray[j].value.y);
										
										if ((dx1 < ttap_dist) && (dy1 < ttap_dist)) 
										{
											//////////////////////////////////////////////////
											//trace("T TAP Pair", dx1,dy1);
											for (var k:uint = i; k < (i+ttap_time); k++) 
												{
													
													
												if (ts.tiO.history[k])
												{
												var gestureEventArray2:Array = ts.tiO.history[k].gestureEventArray;
												
												for (var q:uint = 0; q < gestureEventArray2.length; q++) 
												{
													if ((gestureEventArray2[q].type =="tap")&&(event.value.gestureID!=gestureEventArray2[q].value.gestureID)&&(gestureEventArray[j].value.gestureID != gestureEventArray2[q].value.gestureID))
													{
														
														//trace("ID",event.value.gestureID, gestureEventArray2[q].value.gestureID)
														
														var dx2:Number = Math.abs(event.value.x - gestureEventArray2[q].value.x);//
														var dy2:Number = Math.abs(event.value.y - gestureEventArray2[q].value.y);//
													
														if ((dx2 < ttap_dist) && (dy2 < ttap_dist)) 
														{
															//trace("TAP Triplet",dx1,dy1,dx2,dy2);
															var spt:Point = new Point (event.value.x, event.value.y); // stage point
															var lpt:Point = ts.globalToLocal(spt); //local point
															
															ttapID++;
															var ttap_event:GWGestureEvent = new GWGestureEvent(GWGestureEvent.TRIPLE_TAP, { x:spt.x , y:spt.x, stageX:spt.x , stageY:spt.y, localX:lpt.x , localY:lpt.y,gestureID:ntapID, id:key});
															//if (ts.tiO.pointEvents) 
															ts.tiO.frame.gestureEventArray.push(ttap_event);
															return; 
														}
													}
												}
											}
											}
											//////////////////////////////////////////////////
										}
	
									}
								}
						}
					}	
		}
		

		////////////////////////////////////////////////////////////
		// VISUAL EVENT TIMLINE WOULD HELP
		public function countTapEvents(key:uint):void // count taps each frame
		{
			//if (ts.trace_debug_mode) 
			//trace("find n-taps---------------------------------------------------------",ts.gO.pOList[key].n);
			tapEventCount = 0;
			//var tap_countTime:int = Math.ceil(ts.gO.pOList[key].dispatch_interval * GestureWorks.application.frameRate * 0.001);//10
			var tap_countTime:int = ts.gO.pOList[key].dispatch_interval;//10
			
			//trace(Math.ceil(ts.gO.pOList[key].dispatch_interval * GestureWorks.application.frameRate * 0.001))
			//var buffer:int = 4;
			var tap_number:int = ts.gO.pOList[key].n;
			var tap_x_mean:Number = 0
			var tap_y_mean:Number = 0;
			
			var dn:uint = ts.gO.pOList[key].dList.length;
				
				// count in current frame
				var gestureEventArray:Array = ts.tiO.frame.gestureEventArray
					
					for (var p:uint = 0; p < gestureEventArray.length; p++) 
					{
						//trace("gesture:",gestureEventArray[p].type)
						if (gestureEventArray[j].type =="tap")
							{
								tapEventCount++;
								tap_x_mean += gestureEventArray[j].value.x;
								tap_y_mean += gestureEventArray[j].value.y;
							}
					}
				
					//count history
					for (var i:uint = 0; i < tap_countTime; i++) // 20 fames block for single tap
						{
						if (ts.tiO.history[i])
						{
						//trace("finding taps",tapEventCount);
						gestureEventArray = ts.tiO.history[i].gestureEventArray;
					
								for (var j:int = 0; j < gestureEventArray.length; j++) 
								{
									//trace("gesture:",gestureEventArray[j].type)
									if (gestureEventArray[j].type =="tap")
									{
										tapEventCount++;
										tap_x_mean += gestureEventArray[j].value.x;
										tap_y_mean += gestureEventArray[j].value.y;
									}
								}
							}
					}
					
					
					
					// check totals
					if (tapEventCount != 0) 
					{
						if ((tap_number == 0)||(tapEventCount == tap_number))
						{
							//trace("tap event count for last duration",tapEventCount);
							var spt:Point = new Point (tap_x_mean/tapEventCount, tap_y_mean/tapEventCount); // stage point average
							var lpt:Point = ts.globalToLocal(spt); //local point average
							ntapID++;
							
							//-var ntap_event:GWGestureEvent = new GWGestureEvent(GWGestureEvent.TAP, { x:spt.x, y:spt.y,  stageX:spt.x , stageY:spt.y, localX:lpt.x , localY:lpt.y, gestureID:ntapID, n:tapEventCount , id:key} )
							//-ts.dispatchEvent(ntap_event);
							//if (ts.tiO.pointEvents)ts.tiO.frame.gestureEventArray.push(ntap_event);
							
							ts.gO.pOList[key].activeEvent = true;

							//for (DIM=0; DIM < dn; DIM++)	ts.gO.pOList[key].dList[DIM].gestureDelta = ts.cO[ts.gO.pOList[key].dList[DIM].property_var];
							
							var d:Object = new Object();
								d["x"] = spt.x;
								d["y"] = spt.y;
								d["n"] = tapEventCount;
							
							ts.gO.pOList[key].data.x = spt.x;
							ts.gO.pOList[key].data.y = spt.y;
							
							for (DIM = 0; DIM < dn; DIM++)
							{
								ts.gO.pOList[key].dList[DIM].gestureDelta = d[ts.gO.pOList[key].dList[DIM].property_result];
								
								
								//if(ts.gO.pOList[key].dList[DIM].property_id =="tap_x")	ts.gO.pOList[key].dList[DIM].gestureDelta = spt.x;
								//if(ts.gO.pOList[key].dList[DIM].property_id =="tap_y")	ts.gO.pOList[key].dList[DIM].gestureDelta = spt.y;
								//if(ts.gO.pOList[key].dList[DIM].property_id =="tap_n")	ts.gO.pOList[key].dList[DIM].gestureDelta = tapEventCount;
							}
							//trace("count tap0", spt.x, spt.y, tapEventCount, ts.gO.pOList[key].activeEvent);
							
							//ts.gO.pOList[key].activeEvent = true;
						}
						//trace(tap_number,tapEventCount);
					}
					//trace("count tap",ts.gO.pOList[key].activeEvent)
		}
		
		
		public function countDoubleTapEvents(key:int):void // count taps each frame
		{
			//if (ts.trace_debug_mode)trace("find n-dtaps---------------------------------------------------------",ts.gO.pOList[key].n);
			
			dtapEventCount = 0;
			
			//var dtap_countTime:int = Math.ceil(ts.gO.pOList[key].dispatch_interval * GestureWorks.application.frameRate * 0.001);
			var dtap_countTime:int = ts.gO.pOList[key].dispatch_interval;
			//trace(Math.ceil(ts.gO.pOList[key].dispatch_interval * GestureWorks.application.frameRate * 0.001))
			var dtap_number:int = ts.gO.pOList[key].n;
			var dtap_x_mean:Number = 0
			var dtap_y_mean:Number = 0;
			var ddn = ts.gO.pOList[key].dList.length;
				
				// count in current frame
				var gestureEventArray:Array = ts.tiO.frame.gestureEventArray
					
					for (var p:uint = 0; p < gestureEventArray.length; p++) 
					{
						//trace(gestureEventArray[j].type)
						if (gestureEventArray[j].type =="double_tap")
							{
								dtapEventCount++;
								dtap_x_mean += gestureEventArray[j].value.x;
								dtap_y_mean += gestureEventArray[j].value.y;
							}
					}
				
				//count history
				for (var i:uint = 0; i < dtap_countTime; i++) // 20 fames block for single tap
						{
						if (ts.tiO.history[i])
						{
						//trace("finding taps",tapEventCount);
						gestureEventArray = ts.tiO.history[i].gestureEventArray;
					
								for (var j:uint = 0; j < gestureEventArray.length; j++) 
								{
									//trace("d gesture:",gestureEventArray[j].type)
									if (gestureEventArray[j].type =="double_tap")
									{
										dtapEventCount++;
										dtap_x_mean += gestureEventArray[j].value.x;
										dtap_y_mean += gestureEventArray[j].value.y;
									}
								}
							}
					}
					
					//trace("dtap event count", dtapEventCount)
					if (dtapEventCount != 0) 
					{
						//trace("dtap event count", dtapEventCount)
						
						if ((dtap_number == 0)||(dtapEventCount == dtap_number))
						{
						//trace("double tap event count for last duration", dtapEventCount);
						var spt2:Point = new Point (dtap_x_mean/dtapEventCount, dtap_y_mean/dtapEventCount); // stage point average
						var lpt2:Point = ts.globalToLocal(spt2); //local point average
						ndtapID++;
						
						//-var ndtap_event:GWGestureEvent = new GWGestureEvent(GWGestureEvent.DOUBLE_TAP, { x:spt2.x, y:spt2.y,  stageX:spt2.x , stageY:spt2.y, localX:lpt2.x , localY:lpt2.y, gestureID:ndtapID,n:dtapEventCount, id:key} )
						//-ts.dispatchEvent(ndtap_event);
						// confuses counter // need to move taps to touch event layer
						//if(ts.tiO.pointEvents)ts.tiO.frame.gestureEventArray.push(ndtap_event);
						
						ts.gO.pOList[key].activeEvent = true;
						
						// map to gesture object
						//ts.gO.pOList[key].x = spt2.x;
						//ts.gO.pOList[key].y = spt2.y;
						//ts.gO.pOList[key].n = dtapEventCount;
						
						for (DIM=0; DIM < ddn; DIM++)	ts.gO.pOList[key].dList[DIM].gestureDelta = ts.cO[ts.gO.pOList[key].dList[DIM].property_result];
						
						ts.gO.pOList[key].data.x = spt2.x;
						ts.gO.pOList[key].data.y = spt2.y;
						
						//ts.gO.pOList[key].dList["double_tap_x"].gestureDelta = spt2.x;
						//ts.gO.pOList[key].dList["double_tap_y"].gestureDelta = spt2.y;
						//ts.gO.pOList[key].dList["double_tap_n"].gestureDelta = dtapEventCount
						
						//trace("dtap",spt2.x,spt2.y,dtapEventCount)
						}
					}
		}
		
		public function countTripleTapEvents(key:int):void // count taps each frame
		{
			//if (ts.trace_debug_mode) 	trace("find n-ttaps---------------------------------------------------------",ts.gO.pOList[key].n);
			
			ttapEventCount = 0;
			var ttap_countTime:int = ts.gO.pOList[key].dispatch_interval;		//Math.ceil(ts.gO.pOList[key].dispatch_interval * GestureWorks.application.frameRate * 0.001);
			var ttap_number:int = ts.gO.pOList[key].n;
			var ttap_x_mean:Number = 0
			var ttap_y_mean:Number = 0;
			var tdn = ts.gO.pOList[key].dList.length;
				
				// count in current frame
				var gestureEventArray:Array = ts.tiO.frame.gestureEventArray
					
					for (var p:int = 0; p < gestureEventArray.length; p++) 
					{
						//trace(gestureEventArray[j].type)
						if (gestureEventArray[j].type =="triple_tap")
							{
								ttapEventCount++;
								ttap_x_mean += gestureEventArray[j].value.x;
								ttap_y_mean += gestureEventArray[j].value.y;
							}
					}
				
				//count history
				for (var i:uint = 0; i < ttap_countTime; i++) // 20 fames block for single tap
						{
						if (ts.tiO.history[i])
						{
						//trace("finding taps",tapEventCount);
						gestureEventArray = ts.tiO.history[i].gestureEventArray;
					
								for (var j:int = 0; j < gestureEventArray.length; j++) 
								{
									//trace("t gesture:",gestureEventArray[j].type)
									if (gestureEventArray[j].type =="triple_tap")
									{
										ttapEventCount++;
										ttap_x_mean += gestureEventArray[j].value.x;
										ttap_y_mean += gestureEventArray[j].value.y;
									}
								}
							}
					}
					
					// check totals
					//trace(tapEventCount);
					
					if (ttapEventCount != 0) 
					{
						//trace("ttap event count", dtapEventCount)
						if ((ttap_number == 0)||(ttapEventCount == ttap_number))
						{
						//trace("triple tap event count for last duration", ttapEventCount);
						var spt3:Point = new Point (ttap_x_mean/ttapEventCount, ttap_y_mean/ttapEventCount); // stage point average
						var lpt3:Point = ts.globalToLocal(spt3); //local point average
						nttapID++;
						
						
						//-var nttap_event:GWGestureEvent = new GWGestureEvent(GWGestureEvent.TRIPLE_TAP, { x:spt3.x, y:spt3.y,  stageX:spt3.x , stageY:spt3.y, localX:lpt3.x , localY:lpt3.y, gestureID:nttapID, n:ttapEventCount, id:key} )
							//-ts.dispatchEvent(nttap_event);
							
							//if(ts.tiO.pointEvents)ts.tiO.frame.gestureEventArray.push(nttap_event);
							
						// over write gesture object properties
						//ts.gO.pOList[key].n = ttapEventCount;
						//ts.gO.pOList[key].gestureID = nttapID;
						ts.gO.pOList[key].activeEvent = true;
						
						for (DIM=0; DIM < tdn; DIM++)	ts.gO.pOList[key].dList[DIM].gestureDelta = ts.cO[ts.gO.pOList[key].dList[DIM].property_result];
						
						// map to gesture object
						ts.gO.pOList[key].data.x = spt3.x;
						ts.gO.pOList[key].data.y = spt3.y;
						//ts.gO.pOList[key].n = ttapEventCount;
						
						//ts.gO.pOList[key].dList["triple_tap_x"].gestureDelta = spt3.x;
						//ts.gO.pOList[key].dList["triple_tap_y"].gestureDelta = spt3.y;
						//ts.gO.pOList[key].dList["triple_tap_n"].gestureDelta = ttapEventCount
					}
				}
				
				//trace("gesture block----------------------------------------------------------------")
		}
		
		// stroke analysis
		public function findStrokeGesture(key:int):void
		{
			var path:String = ts.gO.pOList[key].path;
			var path_match:Boolean = ts.gO.pOList[key].path_match;
			var N:int = ts.gO.pOList[key].n;
			
			trace("ref data",key, N, path_match, path);
			///////////////////////////////////
			// compare to captured path
			///////////////////////////////////
			//trace("capturePath", ts.cO.history[0].path_data.length, ts.cO.history[0].path_data)
			//trace("capturePath", ts.cO.history[0].path_data.length, ts.cO.history[0].path_data)
			
			//trace(ts.cO.history[0].path_data)
			trace(ts.cO.path_data)
			
			
			//////////////////////////////////////////////////////////
			// gesture stroke
			//////////////////////////////////////////////////////////
							/*
					if (gO.pOList[key].gesture_type == "stroke")
								{
										gesture_disc.findStrokeGesture(key);
										
										var stroke_threshold:Number = 0.90;
										var stroke_prob:Number = ts.gO.pOList[key].path_match;
										
										if (stroke_prob>stroke_threshold)
										{
											//trace("stroke event");
											//var Gevent:GWGestureEvent = new GWGestureEvent(GWGestureEvent.STROKE, {n:N, probability:stroke_prob});
											//dispatchEvent(Gevent);
											//if((tiO.timelineOn)&&(tiO.gestureEvents))tiO.frame.gestureEventArray.push(Gevent);
											
											ts.gO.pOList[key].activeEvent = true;
										}
								}*/
		
		}
		
		public function findTimelineGestures():void
		{
		 // collects gestures fired in sequence accross the timline
		 
		 // collects gestures across the timline (sequence independant)
		 
		}
		
		
		
	}
}