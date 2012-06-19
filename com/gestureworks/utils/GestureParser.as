////////////////////////////////////////////////////////////////////////////////
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
	import com.gestureworks.objects.PropertyObject;
	import com.gestureworks.objects.GesturePropertyObject;
	import com.gestureworks.objects.GestureObject;
	import flash.geom.Point;
	
	//import com.gestureworks.utils.Yolotzin;
	import com.gestureworks.core.GML;
	
	import com.gestureworks.events.GWGestureEvent;
	
	public class GestureParser //extends Sprite
	{
		public var gO:GestureObject;
		public var gestureList:Object;
		public var gestureTypeList:Object;
		private var pOList:Object;
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
			
			gO = GestureGlobals.gw_public::gestures[ID];
			gml = new XMLList(GML.Gestures);
			pOList = new Object;
			
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
						if (processing_rate) 
						{
							GestureGlobals.touchFrameInterval = processing_rate;
							TouchManager.gw_public::resetGlobalClock;
						}
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
											
											pOList[gesture_id] = new Object();
											//trace("gesture:", gesture_id);
												//pOList[gesture_id].processing_rate = processing_rate;
												pOList[gesture_id].gesture_id = gesture_id;
												pOList[gesture_id].gesture_type = String(gml.Gesture_set[0].Gesture[i].attribute("type"));
												pOList[gesture_id].algorithm = String(gml.Gesture_set[0].Gesture[i].analysis.algorithm.library.attribute("module"));
												
												// if initial action defined
													if (gml.Gesture_set[0].Gesture[i].match.action.initial)
													{
														// if point action defined
														if (gml.Gesture_set[0].Gesture[i].match.action.initial.point)
														{
															// set point action thresholds
															pOList[gesture_id].point_event_duration_threshold = Number(gml.Gesture_set[0].Gesture[i].match.action.initial.point.attribute("event_duration_threshold"));
															pOList[gesture_id].point_interevent_duration_threshold = Number(gml.Gesture_set[0].Gesture[i].match.action.initial.point.attribute("interevent_duration_threshold"));
															pOList[gesture_id].point_translation_threshold = Number(gml.Gesture_set[0].Gesture[i].match.action.initial.point.attribute("translation_threshold"));
															pOList[gesture_id].point_acceleration_threshold = Number(gml.Gesture_set[0].Gesture[i].match.action.initial.point.attribute("acceleration_threshold"));
															//pOList[gesture_id].point_jolt_threshold = Number(gml.Gesture_set[0].Gesture[i].match.action.initial.point.points.attribute("jolt_threshold"));
															
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
																pOList[gesture_id].path = pathArray
															}
														}
									
														
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
															pOList[gesture_id].n = n
															pOList[gesture_id].nMin = nMax;
															pOList[gesture_id].nMax = nMin;
															
															// set cluster action thresholds
															pOList[gesture_id].cluster_translation_threshold = Number(gml.Gesture_set[0].Gesture[i].match.action.initial.cluster.attribute("translation_threshold"));
															pOList[gesture_id].cluster_rotation_threshold = Number(gml.Gesture_set[0].Gesture[i].match.action.initial.cluster.attribute("rotation_threshold"));
															pOList[gesture_id].cluster_separation_threshold = Number(gml.Gesture_set[0].Gesture[i].match.action.initial.cluster.attribute("separation_threshold"));
															pOList[gesture_id].cluster_acceleration_threshold = Number(gml.Gesture_set[0].Gesture[i].match.action.initial.cluster.attribute("acceleration_threshold"));
															//pOList[gesture_id].cluster_jolt_threshold = gml.Gesture_set[0].Gesture[i].match.action.initial.cluster.attribute("jolt_threshold");
														}
													}
												
											///////////////////////////////////////////////////////////////////////////////
											// properties of each property object of the gesture
											//////////////////////////////////////////////////////////////////////////////
												
											for (var j:int = 0; j < propertyNum; j++) {
												var property_id:String = String(gml.Gesture_set[0].Gesture[i].analysis.algorithm.returns.property[j].attribute("id"));
												
												// create new property object on gesture object
												// note each thread has independent pipeline to display object property
												pOList[gesture_id][property_id] = new PropertyObject();

													pOList[gesture_id][property_id].property_id = property_id;
													//pOList[gesture_id][property_id].property_type = String(gml.Gesture_set[0].Gesture[i].analysis.algorithm.returns.property[j].attribute("type"));
													pOList[gesture_id][property_id].property_type = String(gml.Gesture_set[0].Gesture[i].attribute("type"));
													
													//pOList[gesture_id][property_id].clusterDelta = 0; 
													//pOList[gesture_id][property_id].processDelta = 0; 
													//pOList[gesture_id][property_id].gestureDelta = 0;
													
													//pOList[gesture_id][property_id].clusterValue = 0;
													//pOList[gesture_id][property_id].processValue = 0;
													//pOList[gesture_id][property_id].gestureValue = 0;
													
													// if mapping exists 
													if (gml.Gesture_set[0].Gesture[i].mapping.update.gesture_event.property[j])
													{
														// target translator
														var target:String = String(gml.Gesture_set[0].Gesture[i].mapping.update.gesture_event.property[j].attribute("target"));
															
														if ((target == "dsx") || (target == "dsy") || (target == "dx") || (target == "dy") || (target == "dtheta")|| (target == "dthetaX") || (target == "dthetaY") || (target == "dthetaZ")) pOList[gesture_id][property_id].target_id = target;
														else if ((target == "scaleX")||(target == "scalex")) 		pOList[gesture_id][property_id].target_id = "dsx";
														else if ((target == "scaleY")||(target == "scaley")) 		pOList[gesture_id][property_id].target_id = "dsy";
														else if (target == "scale")									pOList[gesture_id][property_id].target_id = "ds";
														else if ((target == "rotate") || (target == "rotation")) 		pOList[gesture_id][property_id].target_id = "dtheta";
														else if ((target == "rotateX") || (target == "rotationX")) 		pOList[gesture_id][property_id].target_id = "dthetaX";
														else if ((target == "rotateY") || (target == "rotationY")) 		pOList[gesture_id][property_id].target_id = "dthetaY";
														else if ((target == "rotateZ") || (target == "rotationZ")) 		pOList[gesture_id][property_id].target_id = "dthetaZ";
														else if ((target == "x")||(target == "X")) 					pOList[gesture_id][property_id].target_id = "dx";
														else if ((target == "y") || (target == "Y")) 				pOList[gesture_id][property_id].target_id = "dy";
														else  pOList[gesture_id][property_id].target_id = "";
														
														// function map
														pOList[gesture_id][property_id].func = String(gml.Gesture_set[0].Gesture[i].mapping.update.gesture_event.property[j].attribute("func"));
														pOList[gesture_id][property_id].func_factor = Number(gml.Gesture_set[0].Gesture[i].mapping.update.gesture_event.property[j].attribute("factor"));
														
														pOList[gesture_id][property_id].delta_threshold = gml.Gesture_set[0].Gesture[i].mapping.update.gesture_event.property[j].attribute("delta_threshold") == "true" ?true:false;
														pOList[gesture_id][property_id].delta_max = Number(gml.Gesture_set[0].Gesture[i].mapping.update.gesture_event.property[j].attribute("delta_max"));
														pOList[gesture_id][property_id].delta_min = Number(gml.Gesture_set[0].Gesture[i].mapping.update.gesture_event.property[j].attribute("delta_min"));
														
														pOList[gesture_id][property_id].boundaryOn = gml.Gesture_set[0].Gesture[i].mapping.update.gesture_event.property[j].attribute("boundaryOn") == "true" ?true:false;
														pOList[gesture_id][property_id].boundary_max = Number(gml.Gesture_set[0].Gesture[i].mapping.update.gesture_event.property[j].attribute("boundary_max"));
														pOList[gesture_id][property_id].boundary_min = Number(gml.Gesture_set[0].Gesture[i].mapping.update.gesture_event.property[j].attribute("boundary_min"));
													}
													// if processing exists
													if (gml.Gesture_set[0].Gesture[i].processing)
													{
														// noise filtering exists
														if (gml.Gesture_set[0].Gesture[i].processing.noise_filter.property[j])
														{
															pOList[gesture_id][property_id].filterOn = gml.Gesture_set[0].Gesture[i].processing.noise_filter.property[j].attribute("noise_filter") == "true" ?true:false;
															pOList[gesture_id][property_id].noise_filterMatrix;
															pOList[gesture_id][property_id].filter_factor = Number((gml.Gesture_set[0].Gesture[i].processing.noise_filter.property[j].attribute("percent"))*0.01);
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
															pOList[gesture_id][property_id].release_inertia = gml.Gesture_set[0].Gesture[i].processing.inertial_filter.property[j].attribute("release_inertia") == "true" ?true:false;
															pOList[gesture_id][property_id].release_inertiaOn = false; // internal dynamic setting
															pOList[gesture_id][property_id].release_inertia_factor = 1; // internal
															pOList[gesture_id][property_id].release_inertia_base = Number(gml.Gesture_set[0].Gesture[i].processing.inertial_filter.property[j].attribute("friction"));
															pOList[gesture_id][property_id].release_inertia_count = 0; //internal
															pOList[gesture_id][property_id].release_inertia_Maxcount = 120;// internal
														}
													}
													//trace("id	", gesture_id, property_id, pOList[gesture_id][property_id].id);
												}
											}
											}
											//////////////////////////////////////////////////////////////////////////////////
											//////////////////////////////////////////////////////////////////////////////////
									}
								}
							}
							gO.pOList = pOList;
							
							traceGesturePropertyList()
		}
		////////////////////////////////////////////////////////////////////////////
		
		public function traceGesturePropertyList():void
		{
			//trace("new display object created in gesture parser util");
			
			for (var i:String in pOList)
				{
					trace("	new gesture object:");
					for (var j:String in pOList[i])
					{
							trace("		property item:",i,j,"__",pOList[i][j]);
					}
				}
				trace("gesture object parsing complete");
		}
	}
}