﻿////////////////////////////////////////////////////////////////////////////////
//
//  IDEUM
//  Copyright 2011-2012 Ideum
//  All Rights Reserved.
//
//  GestureWorks
//
//  File:    GestureParser.as
//  Authors:  Ideum
//             
//  NOTICE: Ideum permits you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////
package com.gestureworks.utils
{
	import com.gestureworks.core.GestureWorks;
	import com.gestureworks.core.GestureGlobals;
	import com.gestureworks.managers.TouchManager;
	
	import com.gestureworks.core.gw_public;
	import com.gestureworks.objects.DimensionObject;
	import com.gestureworks.objects.GestureObject;
	import com.gestureworks.objects.GestureListObject;
	import flash.geom.Point;
	
	//import com.gestureworks.utils.Yolotzin;
	import com.gestureworks.core.GML;
	
	import com.gestureworks.events.GWGestureEvent;
	
	public class GestureParser //extends Sprite
	{
		public var gOList:GestureListObject;
		public var gestureList:Object;
		public var gestureTypeList:Object;
		private var gList:Vector.<GestureObject>;
		public var gml:XMLList;
		
		public function GestureParser():void
		{
			init();
        }
		
		public function init():void 
         {
		 //ID = touchSpriteID;
		 }
		
		/////////////////////////////////////////////////////////////////////
		// GML
		/////////////////////////////////////////////////////////////////////
         public function parse(ID:int):void 
         {
			//if (trace_debug_mode) trace("local gml parser", ID, "Y:",Y);
			
			// version
			//var Y:int = Yolotzin.mode;
			
			//GWGestureEvent.CUSTOM.NEW_GESTURE = "new-gesture";
			
			gOList = GestureGlobals.gw_public::gestures[ID];
			gml = new XMLList(GML.Gestures);
			gList = new Vector.<GestureObject>;
			
				gestureTypeList = { 
									"drag":true, 
									"scale":true, 
									"rotate":true,
									"pivot":true,
									"orient":true,
									"swipe":true,
									"flick":true,
									"scroll":true, 
									"tilt":true,  
									"hold":true, 
									"tap":true,   
									"double_tap":true,  
									"triple_tap":true,
									"stroke":true,
									"manipulate":true
									};			

						// re-set gesture processing rate
						var processing_rate:Number = gml.attribute("processing_rate");
						var matchDisplayFR:Boolean = gml.attribute("match_display_frame_rate") == "true" ?true:false;
						var max_point_number:int = gml.attribute("max_point_number");
						
						if (max_point_number) GestureGlobals.max_point_count = max_point_number;
						else GestureGlobals.max_point_count = 1000;
						
						//if (processing_rate) 
						//{
							//if (matchDisplayFR)
							//	{
								//GestureGlobals.touchFrameInterval = (1/GestureWorks.application.frameRate)*1000;
							//	}
							//else{
								//GestureGlobals.touchFrameInterval = processing_rate;
							//	}
							//TouchManager.gw_public::resetGlobalClock;
							
							//trace("touch frame interval",GestureGlobals.touchFrameInterval);
						//}
						//else GestureGlobals.touchFrameInterval = (1/GestureWorks.application.frameRate)*1000;
						
						
						var gestureNum:int = gml.Gesture_set[0].Gesture.length();
						
						
							for (var i:int = 0; i < gestureNum; i++) 
							{
								var gesture_id:String = String(gml.Gesture_set[0].Gesture[i].attribute("id"));
								var propertyNum:int = int(gml.Gesture_set[0].Gesture[i].analysis.algorithm.returns.property.length());
								
								///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
								// properties of the gesture 
								///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
								
								// check to see if in the gesture list for this touchsprite
								var key:String;
								var type:String;
								
								// 	for all gestures listed for touchspriteID
								for (key in gestureList)
								{
								// check for key match in gml
								if (gesture_id == key)
								{	
									var gtype:String = String(gml.Gesture_set[0].Gesture[i].attribute("type"));
									
									// for all matches in cml gesturelist and gml 
									for (type in gestureTypeList)
										{
										// check tha type is allowable in accordance with version license number
										if (type == gtype)
										{
											//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
											// create new gesture object for handling gesture data structure
											//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
											
											var gO:GestureObject = new GestureObject();
											
											//pOList[gesture_id] = new GestureObject();
											//pOList[gesture_id] = new GesturePropertyObject();
											
											//trace("gesture:", gesture_id);
												
												gO.gesture_id = gesture_id;
												gO.gesture_type = String(gml.Gesture_set[0].Gesture[i].attribute("type"));

												// MATHICNG CRITERIA
												gO.match_TouchEvent = String(gml.Gesture_set[0].Gesture[i].match.action.initial.event.attribute("touch_event"));
												gO.match_GestureEvent = String(gml.Gesture_set[0].Gesture[i].match.action.initial.event.attribute("gesture_event"));
											
												// EVENT CRITERIA
												gO.event_type = String(gml.Gesture_set[0].Gesture[i].mapping.update.gesture_event.attribute("type"));
												
												// create static var in gesture event object
												if (gO.event_type == "custom") GWGestureEvent.GML[gesture_id.toUpperCase()] = gesture_id;
												
												// DISPATCH CRITERIA
												gO.dispatch_type = String(gml.Gesture_set[0].Gesture[i].mapping.update.attribute("dispatch_type"));
												gO.dispatch_mode = String(gml.Gesture_set[0].Gesture[i].mapping.update.attribute("dispatch_mode"));
												gO.dispatch_reset = String(gml.Gesture_set[0].Gesture[i].mapping.update.attribute("dispatch_reset"));
												
												gO.dispatch_interval = Math.ceil(GestureWorks.application.frameRate * 0.001*int(gml.Gesture_set[0].Gesture[i].mapping.update.attribute("dispatch_interval")));
												
												gO.dispatchEvent = false;
												gO.activeEvent = false;
												gO.complete = false;
												
												gO.timer_count = 0;
												
												// if initial action defined
													if (gml.Gesture_set[0].Gesture[i].match.action.initial)
													{
														// if cluster action defined
														if (gml.Gesture_set[0].Gesture[i].match.action.initial.cluster)
														{
															// set action point number
															var n:int = int(gml.Gesture_set[0].Gesture[i].match.action.initial.cluster.attribute("point_number"));
															var nMax:int = 0;
															var nMin:int = 0;
														
															 if(n!=0){ // denotes a specific
																nMax = n;
																nMin = n;
																}
															if (n==0) { // denotes range of values
																nMax = int(gml.Gesture_set[0].Gesture[i].match.action.initial.cluster.attribute("point_number_min"));
																nMin = int(gml.Gesture_set[0].Gesture[i].match.action.initial.cluster.attribute("point_number_max"));
															}
															gO.n = n
															gO.nMin = nMax;
															gO.nMax = nMin;
														}
													}
												
											
								
											//ALGORITHM SPEC
											gO.algorithm = String(gml.Gesture_set[0].Gesture[i].analysis.algorithm.library.attribute("module"));
											gO.algorithm_class = String(gml.Gesture_set[0].Gesture[i].analysis.algorithm.attribute("class"));
											gO.algorithm_type = String(gml.Gesture_set[0].Gesture[i].analysis.algorithm.attribute("type"));
												
											
											///////////////////////////////////////////////////////////////////////////////
											// properties of each property object of the gesture
											// 
											//////////////////////////////////////////////////////////////////////////////
											for (var j:int = 0; j < propertyNum; j++) {
												var property_id:String = String(gml.Gesture_set[0].Gesture[i].analysis.algorithm.returns.property[j].attribute("id"));
												
												// create new property object on gesture object
												// note each thread has independent pipeline to display object property
												var dO:DimensionObject = new DimensionObject();
												//gO.dList[property_id] = new DimensionObject();

													dO.property_id = property_id;
													//pOList[gesture_id][property_id].property_type = String(gml.Gesture_set[0].Gesture[i].analysis.algorithm.returns.property[j].attribute("type"));
													dO.property_mvar = String(gml.Gesture_set[0].Gesture[i].analysis.algorithm.returns.property[j].attribute("module_var"));
													dO.property_var = String(gml.Gesture_set[0].Gesture[i].analysis.algorithm.returns.property[j].attribute("module_result"));
													dO.property_type = String(gml.Gesture_set[0].Gesture[i].attribute("type"));

														//pOList[gesture_id][property_id].clusterDelta = 0; 
														//pOList[gesture_id][property_id].processDelta = 0; 
														//pOList[gesture_id][property_id].gestureDelta = 0;
														
														//pOList[gesture_id][property_id].clusterValue = 0;
														//pOList[gesture_id][property_id].processValue = 0;
														//pOList[gesture_id][property_id].gestureValue = 0;
														
													
													if (gml.Gesture_set[0].Gesture[i].match.action.initial)
													{
														// if point action defined
														if (gml.Gesture_set[0].Gesture[i].match.action.initial.point)
														{
															///////////////////////////////
															// set point action thresholds
															///////////////////////////////
															//pOList[gesture_id][property_id].point_event_duration_threshold = Number(gml.Gesture_set[0].Gesture[i].match.action.initial.point.attribute("event_duration_threshold"));
															//pOList[gesture_id][property_id].point_interevent_duration_threshold = Number(gml.Gesture_set[0].Gesture[i].match.action.initial.point.attribute("interevent_duration_threshold"));
															//pOList[gesture_id][property_id].point_translation_threshold = Number(gml.Gesture_set[0].Gesture[i].match.action.initial.point.attribute("translation_threshold"));
															//pOList[gesture_id][property_id].point_acceleration_threshold = Number(gml.Gesture_set[0].Gesture[i].match.action.initial.point.attribute("acceleration_threshold"));
															
															dO.point_event_duration_min = Number(gml.Gesture_set[0].Gesture[i].match.action.initial.point.attribute("event_duration_min"));
															dO.point_event_duration_max = Number(gml.Gesture_set[0].Gesture[i].match.action.initial.point.attribute("event_duration_max"));
															dO.point_interevent_duration_min = Number(gml.Gesture_set[0].Gesture[i].match.action.initial.point.attribute("interevent_duration_min"));
															dO.point_interevent_duration_max = Number(gml.Gesture_set[0].Gesture[i].match.action.initial.point.attribute("interevent_duration_max"));
															dO.point_translation_min = Number(gml.Gesture_set[0].Gesture[i].match.action.initial.point.attribute("translation_min"));
															dO.point_translation_max = Number(gml.Gesture_set[0].Gesture[i].match.action.initial.point.attribute("translation_max"));
															dO.point_acceleration_min = Number(gml.Gesture_set[0].Gesture[i].match.action.initial.point.attribute("acceleration_min"));
															dO.point_acceleration_max = Number(gml.Gesture_set[0].Gesture[i].match.action.initial.point.attribute("acceleration_max"));
															
															//pOList[gesture_id].point_jolt_threshold = Number(gml.Gesture_set[0].Gesture[i].match.action.initial.point.points.attribute("jolt_threshold"));
															
															/////////////////////////////////////////
															// set path data
															/////////////////////////////////////////
															//pOList[gesture_id].path = String(gml.Gesture_set[0].Gesture[i].match.action.initial.point.attribute("path"));
															var path_string_svg:String = String(gml.Gesture_set[0].Gesture[i].match.action.initial.point.attribute("path_svg"));
															var path_string_pts:String = String(gml.Gesture_set[0].Gesture[i].match.action.initial.point.attribute("path_pts"));
															
															/*
															if (path_string_svg) 
															{
															//trace("parse svg path");
															var pathArray:Array = new Array();
															var stringArray:Array = path_string_svg.split("L"); 												
																													
																for(var m:int=0; m<stringArray.length;m++)
																{
																	var coordArray:Array = stringArray[m].split(" "); 
																	pathArray[m] = new Point(coordArray[1],coordArray[2]);
																}
																pOList[gesture_id].path = pathArray
															}*/
															
															
															if (path_string_pts) 
															{
															//trace("parse pt path");
															var pathArray:Array = new Array();
															var stringArray:Array = path_string_pts.split(","); 												
															
															for(var m:int=0; m<=stringArray.length/2;m=m+2)
																{
																	var xsp:Array= stringArray[m].split("(x=");
																	var ysp:Array = stringArray[m + 1].split("y=");
																	var ysp_sp:Array = ysp[1].split(")")
																	//trace(xsp[1], ysp_sp[0])
																	var x:Number = 200*xsp[1];
																	var y:Number = 200*ysp_sp[0];

																	pathArray.push(new Point(x,y));
																}
																dO.path = pathArray
															}
														}
														
														//////////////////////////
														// cluster properties
														//////////////////////////
														if (gml.Gesture_set[0].Gesture[i].match.action.initial.cluster)
														{
															// set cluster action thresholds
															//pOList[gesture_id][property_id].cluster_translation_threshold = Number(gml.Gesture_set[0].Gesture[i].match.action.initial.cluster.attribute("translation_threshold"));
															//pOList[gesture_id][property_id].cluster_rotation_threshold = Number(gml.Gesture_set[0].Gesture[i].match.action.initial.cluster.attribute("rotation_threshold"));
															//pOList[gesture_id][property_id].cluster_separation_threshold = Number(gml.Gesture_set[0].Gesture[i].match.action.initial.cluster.attribute("separation_threshold"));
															
															dO.cluster_translation_min = Number(gml.Gesture_set[0].Gesture[i].match.action.initial.cluster.attribute("translation_min"));
															dO.cluster_translation_max = Number(gml.Gesture_set[0].Gesture[i].match.action.initial.cluster.attribute("translation_max"));
															
															dO.cluster_rotation_min = Number(gml.Gesture_set[0].Gesture[i].match.action.initial.cluster.attribute("rotation_min"));
															dO.cluster_rotation_max = Number(gml.Gesture_set[0].Gesture[i].match.action.initial.cluster.attribute("rotation_max"));
															
															dO.cluster_separation_min = Number(gml.Gesture_set[0].Gesture[i].match.action.initial.cluster.attribute("separation_min"));
															dO.cluster_separation_max = Number(gml.Gesture_set[0].Gesture[i].match.action.initial.cluster.attribute("separation_max"));
															
															dO.cluster_acceleration_min = Number(gml.Gesture_set[0].Gesture[i].match.action.initial.cluster.attribute("acceleration_min"));
															dO.cluster_acceleration_max = Number(gml.Gesture_set[0].Gesture[i].match.action.initial.cluster.attribute("acceleration_max"));
														
														}
		
													}
													
													
													
													////////////////////////////////////////////////////////////////////////////////////////////
													// FILTER BLOCK
													/////////////////////////////////////////////////////////////////////////////////////////////
													
													// if processing exists
													if (gml.Gesture_set[0].Gesture[i].processing)
													{
														// noise filtering exists
														if (gml.Gesture_set[0].Gesture[i].processing.noise_filter.property[j])
														{
															dO.noise_filter = gml.Gesture_set[0].Gesture[i].processing.noise_filter.property[j].attribute("noise_filter") == "true" ?true:false;
															dO.noise_filterMatrix;
															dO.filter_factor = Number((gml.Gesture_set[0].Gesture[i].processing.noise_filter.property[j].attribute("percent"))*0.01);
														}
														
														//inertia filter exists
														if (gml.Gesture_set[0].Gesture[i].processing.inertial_filter.property[j])
														{
															// touch inertia
															//pOList[gesture_id][property_id].touch_inertiaOn = gml.Gesture_set[0].Gesture[i].processing.inertial_filter.property[j].attribute("touch_inertia") == "true" ?true:false;
															//pOList[gesture_id][property_id].inertial_filterMatrix;
															//pOList[gesture_id][property_id].touch_inertia_factor = 1//gml.Gesture_set[0].Gesture[i].processing.inertial_filter.property[j].attribute("inertial_mass");
															//pOList[gesture_id][property_id].touch_inertia_mass 
															//pOList[gesture_id][property_id].touch_inertia_spring 
															
															// release inertia
															dO.release_inertia_filter = gml.Gesture_set[0].Gesture[i].processing.inertial_filter.property[j].attribute("release_inertia") == "true" ?true:false;
															dO.release_inertiaOn = false; // internal dynamic setting
															dO.release_inertia_factor = 1; // internal
															dO.release_inertia_base = Number(gml.Gesture_set[0].Gesture[i].processing.inertial_filter.property[j].attribute("friction"));
															dO.release_inertia_count = 0; //internal
															dO.release_inertia_Maxcount = 120;// internal
														}
														
														// multiply filter
														if (gml.Gesture_set[0].Gesture[i].processing.multiply_filter.property[j])
														{
															dO.multiply_filter = gml.Gesture_set[0].Gesture[i].processing.multiply_filter.property[j].attribute("multiply")== "true" ?true:false;
															dO.func = String(gml.Gesture_set[0].Gesture[i].processing.multiply_filter.property[j].attribute("func"));
															dO.func_factor = Number(gml.Gesture_set[0].Gesture[i].processing.multiply_filter.property[j].attribute("factor"));
														}
														// delta filter
														if (gml.Gesture_set[0].Gesture[i].processing.delta_filter.property[j])
														{
															dO.delta_filter = gml.Gesture_set[0].Gesture[i].processing.delta_filter.property[j].attribute("delta_threshold") == "true" ?true:false;
															dO.delta_max = Number(gml.Gesture_set[0].Gesture[i].processing.delta_filter.property[j].attribute("delta_max"));
															dO.delta_min = Number(gml.Gesture_set[0].Gesture[i].processing.delta_filter.property[j].attribute("delta_min"));
														}
														// value boundrary filter
														if (gml.Gesture_set[0].Gesture[i].processing.value_filter.property[j])
														{
															dO.boundary_filter = gml.Gesture_set[0].Gesture[i].processing.value_filter.property[j].attribute("boundary") == "true" ?true:false;
															dO.boundary_max = Number(gml.Gesture_set[0].Gesture[i].processing.value_filter.property[j].attribute("boundary_max"));
															dO.boundary_min = Number(gml.Gesture_set[0].Gesture[i].processing.value_filter.property[j].attribute("boundary_min"));
														}
													}
													
													
													////////////////////////////////////////////////////////////////////////////////////////////
													// MAPPING BLOCK
													/////////////////////////////////////////////////////////////////////////////////////////////
													
													// if mapping exists 
													if (gml.Gesture_set[0].Gesture[i].mapping.update.gesture_event.property[j])
													{
														// target translator
														var target:String = String(gml.Gesture_set[0].Gesture[i].mapping.update.gesture_event.property[j].attribute("target"));
															
														if ((target == "dsx") || (target == "dsy") || (target == "dx") || (target == "dy") || (target == "dtheta")|| (target == "dthetaX") || (target == "dthetaY") || (target == "dthetaZ")) dO.target_id = target;
														else if ((target == "scaleX")||(target == "scalex")) 		dO.target_id = "dsx";
														else if ((target == "scaleY")||(target == "scaley")) 		dO.target_id = "dsy";
														else if (target == "scale")									dO.target_id = "ds";
														else if ((target == "rotate") || (target == "rotation")) 		dO.target_id = "dtheta";
														else if ((target == "rotateX") || (target == "rotationX")) 		dO.target_id = "dthetaX";
														else if ((target == "rotateY") || (target == "rotationY")) 		dO.target_id = "dthetaY";
														else if ((target == "rotateZ") || (target == "rotationZ")) 		dO.target_id = "dthetaZ";
														else if ((target == "x")||(target == "X")) 					dO.target_id = "dx";
														else if ((target == "y") || (target == "Y")) 				dO.target_id = "dy";
														else  dO.target_id = "";	
													}
													
													//trace("id	", gesture_id, property_id, pOList[gesture_id][property_id].id);
													gO.dList.push(dO);
												}
												
												
												// PUSH GESTURE OBJECT INTO GESTURE LIT VECTOR
												gList.push(gO);
											}
											}
											//////////////////////////////////////////////////////////////////////////////////
											//////////////////////////////////////////////////////////////////////////////////
									}
								}
							}
							gOList.pOList = gList;
							
						//traceGesturePropertyList()
		}
		////////////////////////////////////////////////////////////////////////////
		
		public function traceGesturePropertyList():void
		{
			//trace("new display object created in gesture parser util");
			var gn:uint = gOList.pOList.length;
			
			for (var i:uint = 0; i < gn; i++ )
				{
					trace("	new gesture object:");
					var dn:uint = gOList.pOList[i].dList.length;
					
					for (var j:uint = 0; j < dn; j++ )
					{
							trace("		property item:",i,j,"__",gList[i].dList[j]);
					}
				}
				trace("gesture object parsing complete");
		}
	}
}