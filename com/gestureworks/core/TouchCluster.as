////////////////////////////////////////////////////////////////////////////////
//
//  IDEUM
//  Copyright 2011-2012 Ideum
//  All Rights Reserved.
//
//  GestureWorks
//
//  File:    TouchSpriteCluster.as
//  Authors:  Ideum
//             
//  NOTICE: Ideum permits you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////
package com.gestureworks.core
{
	import com.gestureworks.events.GWClusterEvent;
	import com.gestureworks.analysis.KineMetric;
	import com.gestureworks.objects.GestureObject;
	import flash.geom.Point;
	import flash.display.DisplayObject;
	//import com.gestureworks.analysis.VectorMetric;
	
	import com.gestureworks.objects.ClusterObject;
	import com.gestureworks.objects.GestureListObject;
	import com.gestureworks.objects.TimelineObject;
	
	import com.gestureworks.objects.DimensionObject;
	
	//use namespace id_internal;
	
	/**
	* @private
	*/
	public class TouchCluster
	{
		/**
		* @private
		*/
		private var cluster_kinemetric:KineMetric;
		//private var cluster_vectormetric:Vectormetric;
		/**
		* @private
		*/
		private var kinemetricsOn:Boolean = true;
		//private var vectoremetricsOn:Boolean = true;
		
		private var gn:uint;
		private var key:uint;
		private var DIM:uint; 
		private var ts:Object;
		private var id:int;
		
		private var gO:GestureListObject;
		private var cO:ClusterObject
		private var tiO:TimelineObject
		
		public function TouchCluster(touchObjectID:int):void
		{
			
			id = touchObjectID;
			ts = GestureGlobals.gw_public::touchObjects[id];
			
			gO = ts.gO;
			cO = ts.cO;
			
			initCluster();
          }
		  
		/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		// initializers
		/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        /**
		 * @private
		 */
        private function initCluster():void 
        {	
				initClusterVars();
				initClusterAnalysis();
				initClusterAnalysisConfig();
		}
		/**
		 * @private
		 */
		private function initClusterVars():void 
		{
				// set constructor logic 
				kinemetricsOn = true;
				//vectormetricsOn = true;	
		}
		/**
		 * @private
		 */
		private function initClusterAnalysis():void
		{
				//trace("init cluster analysis", touchSprite_id);
							
					// analyzes and characterizes multi-point motion
					if(kinemetricsOn)cluster_kinemetric = new KineMetric(id);

					// analyzes and characterizes multi-point paths to match against established strokes
					//if(vectormetricsOn)cluster_kinemetric = new Vectormetric(touchSpriteID);
		}
		/**
		 * @private
		 */
		private function initClusterAnalysisConfig():void
			{
				// analyzes and characterizes multi-point motion
				if (kinemetricsOn)
				{
					// set cluster point numbers
					cluster_kinemetric.init();
				}			
		}
		/**
		 * @private
		 */
		// internal public
		public function updateClusterCount():void 
		{
			//trace("update cluster count");
			
			// FIND CLUSTER COUNT
			cO.n = cO.pointArray.length
			ts.dN = cO.n - ts.N;
			ts.N = cO.n;
			
			
			
			// CLUSTER OBJECT UPDATE
			
			// reset cluster states
			cO.point_remove = false;
			cO.point_add = false;
			cO.remove = false; 
			cO.add = false;
			
			
				if (ts.dN < 0) 
				{
					cO.point_remove = true;
					//cO.point_add = false;
					
					if (ts.N == 0) 
					{
						cO.remove = true; 
						//cO.add = false;
					}
				}
				else if (ts.dN > 0) 
				{
					//cO.point_remove = false;
					cO.point_add = true;
					
					if (ts.N != 0)
					{
					//cO.remove = false; 
					cO.add = true; 
					}
				}
			
			if (ts.dN != 0)
			{
				if (ts.clusterEvents) manageClusterEventDispatch();
			}
			//trace(_dN, _N, cO.point_remove,cO.point_add,cO.remove,cO.add)
			
			
			
			///////////////////////////////////////////////////
			// move to pipeline
			///////////////////////////////////////////////////
			// GESTURE OBJECT UPDATE
			if (ts.dN > 0) ts.gO.start = true;
			
			if (ts.N != 0) 
			{
				gO.active = true;
				gO.complete = false;
				gO.release = false;
			}
			else {
				if (ts.dN < 0) 
				{
					gO.release = true;
					gO.passive = true;
				}
			}
			///////////////////////////////////////////////////
			
			//trace(_dN, _N, cO.point_remove);
		}
		/**
		 * @private
		 */
		// internal public
		public function updateClusterAnalysis():void
			{
				//trace("update cluster analysis")
				updateClusterCount();
				
				if (kinemetricsOn) findCluster()
				//if(vectormetricsOn)cluster_vectormetric.findPath();
				if ((ts.clusterEvents)&&(ts.N)) manageClusterPropertyEventDispatch();
		}
		
		
		public function findCluster():void 
		{
			//trace("TouchSprite findcluster update-----------------------------",GestureGlobals.frameID, _N);
			gn = gO.pOList.length;
			
			
			cluster_kinemetric.findCluster();
			cluster_kinemetric.resetVars();
			cluster_kinemetric.findInstDimention();
			
			//cluster_kinemetric.findMeanInstTransformation();
			
			var dn:uint 
			
			for (key = 0; key < gn; key++) 
			//for (key in gO.pOList) //if(gO.pOList[key] is GesturePropertyObject)
			{
				// set dim length
				dn = gO.pOList[key].dList.length;
				// zero cluster deltas
				for (DIM=0; DIM < dn; DIM++) gO.pOList[key].dList[DIM].clusterDelta = 0;	
				
				// processing algorithms when in touch
				if(ts.N!=0){		// check kinemetric and if continuous analysis
					// check point number requirements
					if((ts.N >= gO.pOList[key].nMin)&&(ts.N <= gO.pOList[key].nMax)||(ts.N == gO.pOList[key].n))
					{
						//trace("call cluster calc",ts.N);
						
						// activate all by default
						gO.pOList[key].activeEvent = true;

							// BASIC DRAG/SCALE/ROTATE CONTROL // ALGORITHM // type manipulate
							if (gO.pOList[key].algorithm == "manipulate") 	cluster_kinemetric.findMeanInstTransformation();
							//if (gO.pOList[key]["manipulate"]) 	cluster_kinemetric.findMeanInstTransformation(); 
							//trace(gO.pOList[key].manipulate)
							
							// BASIC DRAG CONTROL // ALGORITHM // type drag
							if (gO.pOList[key].algorithm == "drag")			cluster_kinemetric.findMeanInstTranslation();

							// BASIC SCALE CONTROL // ALGORITHM // type scale
							if (ts.gO.pOList[key].algorithm == "scale")		cluster_kinemetric.findMeanInstSeparation();
						
							// BASIC ROTATE CONTROL // ALGORITHM // type rotate
							if (gO.pOList[key].algorithm == "rotate")		cluster_kinemetric.findMeanInstRotation();
							
							// BASIC ORIENTATION CONTROL // ALGORITHM
							if (gO.pOList[key].algorithm == "orient")		cluster_kinemetric.findInstOrientation();

							// BASIC PIVOT CONTROL // ALGORITHM
							//if (gO.pOList[key].algorithm == "pivot")		cluster_kinemetric.findInstPivot(gO.pOList[key].cluster_rotation_min);
							if (gO.pOList[key].algorithm == "pivot")		cluster_kinemetric.findInstPivot(0);
							
							
							/*
							//if ((gO.pOList[key].algorithm == "manipulate") || (gO.pOList[key].algorithm == "drag") || (gO.pOList[key].algorithm == "scale") || (gO.pOList[key].algorithm == "rotate") || (gO.pOList[key].algorithm == "orient") || (gO.pOList[key].algorithm == "pivot"))
							//{
							
								for (DIM=0; DIM < dn; DIM++) gO.pOList[key].dList[DIM].clusterDelta = cO[gO.pOList[key].dList[DIM].property_result];
							
								gO.pOList[key].data.x = cO.x;
								gO.pOList[key].data.y = cO.y;
								gO.pOList[key].data.n = cO.n;
							//}*/
							
							
							
							///////////////////////////////////////////////////////////////////////////////////////////////////
							// MOVE TO TEMPORAL METRIC
							// BASIC HOLD CONTROL // ALGORITHM // type hold
							
							if (gO.pOList[key].algorithm == "hold")
							{
								//if (trace_debug_mode) 
								//trace("cluster hold algorithm");
								
								var hold_number:int = gO.pOList[key].n;
								var hold_dist:int = 0//gO.pOList[key]["hold_x"].point_translation_threshold;
								var	hold_time:int = 0//Math.ceil(gO.pOList[key]["hold_x"].point_event_duration_threshold / GestureGlobals.touchFrameInterval);	
								
								//for (DIM in gO.pOList[key].dList)
								for (DIM=0; DIM < dn; DIM++)
								{
									hold_dist = gO.pOList[key].dList[DIM].point_translation_max;
									hold_time = Math.ceil(gO.pOList[key].dList[DIM].point_event_duration_min/ GestureGlobals.touchFrameInterval);
								}
								
								cluster_kinemetric.findLockedPoints(hold_dist, hold_time, hold_number);
								
								/*
								if(cO.hold_n)
									{
									gO.pOList[key].activeEvent = true;
									//for (DIM=0; DIM < dn; DIM++)	gO.pOList[key].dList[DIM].clusterDelta = cO[ts.gO.pOList[key].dList[DIM].property_result];					
									}
								*/	
									
								if(!cO.hold_n)	gO.pOList[key].activeEvent = false;
	
							}
							
							// MOVE TO TEMPROALMETRIC
							///////////////////////////////////////////////////////////////////////////////////////////////////
					
							/*
							///////////////////////////////////////////////////////////////////////////////////////////////////
							// MOVE TO VECTOR METRIC
							// BASIC STROKE LISTENING // ALGORITHM // type STROKE
							if (gO.pOList[key].algorithm == "stroke")
							{
								var path:Object = cluster_kinemetric.findPath();
								luster_kinemetric.c_path_data;
								
								gO.pOList[key]["path"].clusterVector = path["vector"]
							}
							*/
							
							///////////////////////////////////////////////////////////////////////////////////////////////////
							// BASIC FLICK CONTROL // ALGORITHM
							///////////////////////////////////////////////////////////////////////////////////////////////////
							// SHOULD BE DISCRETE ON RELEASE CHECK FOR ACCELERATION
							// IF ABOVE ACCEL THREHOLD RETURN GESTURE
							if (gO.pOList[key].algorithm == "flick")
							{
								//var flick_threshold:Number = gO.pOList[key]["flick_dx"].cluster_acceleration_threshold; //accleration threshold
								//var flick_h:int = 6;
								
								//var flick_etm_accel:Point = cluster_kinemetric.findMeanTemporalAcceleration(flick_h); //ensamble temporal mean acceleration
								//var flick_etmVel:Point = cluster_kinemetric.findMeanTemporalVelocity(flick_h); // ensamble temporal mean velocity
									
								// limits
								//if (Math.abs(flick_etm_accel.x) < flick_threshold) flick_etmVel.x = 0;
								//if (Math.abs(flick_etm_accel.y) < flick_threshold) flick_etmVel.y = 0;;
									
								// TODO ADD DISPATCH CHECK 
								//REQUIRE MIN HISTORY OF 20 FRAMES TO REDUCE INIT TOUCH JERK ACCIDENTAL TRIGGER
								
								//FIX TO GENERIC
								// assign value to property object
								//gO.pOList[key]["flick_dx"].clusterDelta = flick_etm_vel.x;
								//gO.pOList[key]["flick_dy"].clusterDelta = flick_etm_vel.y;
								
								//trace("flick, velocity",flick_etmVel.x,flick_etmVel.y,flick_etm_accel.x,flick_etm_accel.y,flick_threshold)
								
								// MUST EXTERANLIZE TO GML
								//var flick_h:int = 6;
								//var flick_etm_accel:Object = cluster_kinemetric.findMeanTemporalAcceleration(flick_h); //ensamble temporal mean acceleration
								//var flick_etm_vel:Object = cluster_kinemetric.findMeanTemporalVelocity(flick_h); // ensamble temporal mean velocity
								
								
								
								cluster_kinemetric.findMeanTemporalAcceleration(); //ensamble temporal mean acceleration
								cluster_kinemetric.findMeanTemporalVelocity(); // ensamble temporal mean velocity
								
								/*var df:Object = new Object();
									df["etm_dx"] = flick_etm_vel["etm_dx"]
									df["etm_dy"] = flick_etm_vel["etm_dy"]
									df["etm_ddx"] = flick_etm_accel["etm_ddx"]
									df["etm_ddy"] = flick_etm_accel["etm_ddy"]*/
								
								for (DIM=0; DIM < dn; DIM++)
								//for (DIM in gO.pOList[key])
								{
									//if (gO.pOList[key][DIM] is DimensionObject) 
									//{
										//var property_var:String = gO.pOList[key][DIM].property_var;
										//var flick_min:Number = gO.pOList[key][DIM].cluster_acceleration_min;
										
										// min limits
										//if (Math.abs(flick_etm_accel[gO.pOList[key].dList[DIM].property_mvar]) > gO.pOList[key].dList[DIM].cluster_acceleration_min) gO.pOList[key].dList[DIM].clusterDelta = flick_etm_vel[gO.pOList[key][DIM].property_result];
										//else gO.pOList[key].dList[DIM].clusterDelta = 0;
										
										//gO.pOList[key][DIM].clusterDelta = flick_etm_vel[gO.pOList[key][DIM].property_var];
										//trace("flick",gO.pOList[key][DIM].clusterDelta)
									//}
									
									//gO.pOList[key].x = cO.x;
									//gO.pOList[key].y = cO.y;
									//gO.pOList[key].n = cO.n;
									
									///////////////////////////
									//for each var
									// find value in cluster
									// check limits, max or min
									// map return var 
									// else render inactive
									var vn:uint = gO.pOList[key].dList[DIM].property_vars.length;
									for (var v:uint = 0; v <vn; v++)
									{
										//trace("var", v);
										//trace("var", gO.pOList[key].dList[DIM].property_vars[v]["return"]);
										//trace("var", gO.pOList[key].dList[DIM].property_vars[v]["var"]);
										//trace("var", gO.pOList[key].dList[DIM].property_vars[v]["min"]);
										//trace("var", gO.pOList[key].dList[DIM].property_vars[v]["max"]);
										
										if ((gO.pOList[key].dList[DIM].property_vars[v]["min"]) && (cO[gO.pOList[key].dList[DIM].property_vars[v]["var"]] < gO.pOList[key].dList[DIM].property_vars[v]["min"])) 
										{
											//gO.pOList[key].activeEvent = false;
										}
										
										if ((gO.pOList[key].dList[DIM].property_vars[v]["max"]) && (cO[gO.pOList[key].dList[DIM].property_vars[v]["var"]] > cO[gO.pOList[key].dList[DIM].property_vars[v]["max"]]))
										{
											//[gO.pOList[key].dList[DIM].property_vars[v]["return"]] = [gO.pOList[key].dList[DIM].property_vars[v]["var"]]
										}
										
									}
									
									//if (Math.abs(flick_etm_accel[gO.pOList[key].dList[DIM].property_mvar]) < gO.pOList[key].dList[DIM].cluster_acceleration_min)  gO.pOList[key][DIM].property_result = 0;
									
								}
								
								trace(cO["etm_dx"],cO["etm_dy"],cO["etm_ddx"],cO["etm_ddy"] )
							}
				
							
							
							///////////////////////////////////////////////////////////////////////////////////////////////////
							// BASIC SWIPE CONTROL // ALGORITHM
							///////////////////////////////////////////////////////////////////////////////////////////////////
							// SHOULD BE DISCRETE GESTURE ON RELEASE
							// CONST VELOCITY CHECK FOR LARGE CHNAGES IN ACCEL
							// RETURN VELOCITY OF SWIPE IN X AND Y
							
							
							if (gO.pOList[key].algorithm == "swipe")
							{
								//if (trace_debug_mode) trace("cluster swipe algorithm");
								
								/*
								//FIX TO GENERIC
								var swipe_threshold:Number = gO.pOList[key]["swipe_dx"].cluster_acceleration_threshold;// acceleration threshold
								var swipe_h:int = 6;
								
								var swipe_etmVel:Point = cluster_kinemetric.findMeanTemporalVelocity(swipe_h); //ensamble temporal mean velocity
								var swipe_etmAccel:Point = cluster_kinemetric.findMeanTemporalAcceleration(swipe_h); //ensamble temporal mean velocity
									
								if (Math.abs(swipe_etmAccel.x) > swipe_threshold) swipe_etmAccel.x = 0;
								if (Math.abs(swipe_etmAccel.y) > swipe_threshold) swipe_etmAccel.y = 0;
									
								// STRCT CONDITIONS FOR BOTH X AND Y
								// NEEDS TO RETURN ACCELERATION ALSO
								// NEED MULTIPLE FIELDS FOR CLUSTER DELTA
									
								//REQUIRE MIN HISTORY OF 20 FRAMES TO REDUCE INIT TOUCH JERK ACCIDENTAL TRIGGER
								
								//FIX TO GENERIC
								// assign value to property object
								gO.pOList[key]["swipe_dx"].clusterDelta = swipe_etmAccel.x;
								gO.pOList[key]["swipe_dy"].clusterDelta = swipe_etmAccel.y;
								
								//trace("swipe, velocity",swipe_etmVel.x,swipe_etmVel.y,swipe_etmAccel.x,swipe_etmAccel.y,swipe_threshold)
								*/
								
								
								//var swipe_h:int = 6;
								//var swipe_etm_vel:Object = cluster_kinemetric.findMeanTemporalVelocity(swipe_h); //ensamble temporal mean velocity
								//var swipe_etm_accel:Object = cluster_kinemetric.findMeanTemporalAcceleration(swipe_h); //ensamble temporal mean velocity
								
								//var swipe_h:int = 6;
								cluster_kinemetric.findMeanTemporalVelocity(); //ensamble temporal mean velocity
								cluster_kinemetric.findMeanTemporalAcceleration(); //ensamble temporal mean velocity
								
							/*	var d:Object = new Object();
									d["etm_dx"] = swipe_etm_vel["etm_dx"]
									d["etm_dy"] = swipe_etm_vel["etm_dy"]
									d["etm_ddx"] = swipe_etm_accel["etm_ddx"]
									d["etm_ddy"] = swipe_etm_accel["etm_ddy"]*/
								
								for (DIM=0; DIM < dn; DIM++)
								//for (DIM in gO.pOList[key].dList)
								{
									//if (gO.pOList[key].dList[DIM] is DimensionObject) 
									//{
										//trace(DIM,gO.pOList[key][DIM].property_mvar);
										// max limits
										//if (Math.abs(d[gO.pOList[key].dList[DIM].property_mvar]) < gO.pOList[key].dList[DIM].cluster_acceleration_max) gO.pOList[key].dList[DIM].clusterDelta = d[gO.pOList[key].dList[DIM].property_result];
										//else gO.pOList[key].dList[DIM].clusterDelta = 0;
										
										
										//gO.pOList[key][DIM].clusterDelta = d[gO.pOList[key][DIM].property_var];
									//}
								}
								
								//gO.pOList[key].x = cO.x;
								//gO.pOList[key].y = cO.y;
								//gO.pOList[key].n = cO.n;
								
							}
							
							
				
							///////////////////////////////////////////////////////////////////////////////////////////////////
							// BASIC SCROLL CONTROL // ALGORITHM
							///////////////////////////////////////////////////////////////////////////////////////////////////
							
							// CONTINUOUSLY
							// MIN TRANSLATION IN X AND Y
							// RETURN AVERAGE ENSABLE TEMPORAL VELOCITY 
							
							
							if (gO.pOList[key].algorithm == "scroll")
							{
								//if (trace_debug_mode) trace("cluster scroll algorithm");
								
								/*
								//FIX TO GENERIC
								var scroll_threshold:Number = gO.pOList[key]["scroll_dx"].cluster_translation_threshold; // acceleration threshold
								//var scroll_dx:Number = 0; 
								//var scroll_dy:Number = 0;
								
								var scroll_h:int = 6;
								var etmVel:Point = cluster_kinemetric.findMeanTemporalVelocity(scroll_h); //ensamble temporal mean 
									
								// thresholds
								if(Math.abs(etmVel.x) > scroll_threshold) etmVel.y = 0;
								if(Math.abs(etmVel.y) > scroll_threshold) etmVel.x = 0;
								
								//FIX TO GENERIC
								gO.pOList[key]["scroll_dx"].clusterDelta = etmVel.x; 
								gO.pOList[key]["scroll_dy"].clusterDelta = etmVel.y;
									
								//trace("scroll, velocity",etmVel.x,etmVel.y)
								*/
								
								
								
								//var scroll_h:int = 6;
								//var scroll_etm_vel:Object = cluster_kinemetric.findMeanTemporalVelocity(scroll_h); //ensamble temporal mean 
								
								cluster_kinemetric.findMeanTemporalVelocity();
								
								for (DIM=0; DIM < dn; DIM++)
								//for (DIM in gO.pOList[key])
								{
									//if (gO.pOList[key][DIM] is DimensionObject) 
									//{
										// min limits
										//if (Math.abs(scroll_etm_vel[gO.pOList[key].dList[DIM].property_mvar]) < gO.pOList[key].dList[DIM].cluster_acceleration_max) gO.pOList[key].dList[DIM].clusterDelta = scroll_etm_vel[gO.pOList[key].dList[DIM].property_result];
										//else gO.pOList[key].dList[DIM].clusterDelta = 0;
										
										//gO.pOList[key][DIM].clusterDelta = scroll_etm_vel[gO.pOList[key][DIM].property_var];
										
									//}
								}
							}
						
							
							
							///////////////////////////////////////////////////////////////////////////////////////////////////
							// BASIC TILT CONTROL // ALGORITHM
							///////////////////////////////////////////////////////////////////////////////////////////////////
							// LOOK FOR SEPARATION OF CLUSTER IN X AND Y DIRECTION
							// RETURN DX AND DY
							if (gO.pOList[key].algorithm == "tilt")
							{
								//if (trace_debug_mode) trace("cluster tilt algorithm"); 
								
								// LOCKED INTO 3 POINT EXCLUSIVE ACTIVATION
								
								//FIX TO GENERIC
								//var tilt_threshold:Number = gO.pOList[key]["tilt_dx"].cluster_separation_threshold;
								
								//////////////////////////////////////////////////////////////////
								// STANDARD OPERATION	
								///////////////////////////////////////////////////////////////////
								//var pt_tilt:Point = cluster_kinemetric.findMeanInstSeparationXY();
										
								//if (Math.abs(pt_tilt.x) > tilt_threshold) pt_tilt.y = 0;
								//if (Math.abs(pt_tilt.y) > tilt_threshold) pt_tilt.x = 0;
										
								//FIX TO GENERIC
								//gO.pOList[key]["tilt_dx"].clusterDelta = pt_tilt.x; //tilt_dx
								//gO.pOList[key]["tilt_dy"].clusterDelta = pt_tilt.y; //tilt_dy
								//trace("TILT seperation",c_dsx,c_dsy)
								
								cluster_kinemetric.findMeanInstSeparationXY();
								
								for (DIM=0; DIM < dn; DIM++)
								//for (DIM in gO.pOList[key].dList)
								{
									//if (gO.pOList[key].dList[DIM] is DimensionObject) 
									//{
										// min limits
										//if (Math.abs(cO[gO.pOList[key].dList[DIM].property_var]) > gO.pOList[key].dList[DIM].cluster_seperation_min) gO.pOList[key].dList[DIM].clusterDelta = cO[gO.pOList[key].dList[DIM].property_var];
										//else gO.pOList[key].dList[DIM].clusterDelta = 0;
											
									
										
										//gO.pOList[key][DIM].clusterDelta = cO[gO.pOList[key][DIM].property_var];
										
									//}
								}
								
								
							}
							
							
							///////////////////////////////////////////////////////////////////////////////////
							// loop and set cluster delta to result
							/////////////////////////////////////////////////////////////////////////////////////
							//if (gO.pOList[key].activeEvent)
							//{
								for (DIM = 0; DIM < dn; DIM++) {
									gO.pOList[key].dList[DIM].clusterDelta = cO[gO.pOList[key].dList[DIM].property_result];
									trace("cluster delta",gO.pOList[key].dList[DIM].clusterDelta)
								}
								
									gO.pOList[key].data.x = cO.x;
									gO.pOList[key].data.y = cO.y;
									gO.pOList[key].data.n = cO.n;
									
									
							//}
					}
			}
			//else {
				//trace("processing algorithm when NOT touching");
			//}

			}
			
			cluster_kinemetric.pushClusterObjectProperties();
			
		}
		/**
		 * @private
		 */
		private function manageClusterEventDispatch():void 
		{	
				// point added to cluster
				if (cO.point_add)
				{
						ts.dispatchEvent(new GWClusterEvent(GWClusterEvent.C_POINT_ADD, cO.n));
						if((tiO.timelineOn)&&(tiO.clusterEvents)) tiO.frame.clusterEventArray.push(new GWClusterEvent(GWClusterEvent.C_POINT_ADD, cO.n));
						cO.point_add = false;
				}
				// point removed cluster
				if (ts.cO.point_remove) 
				{
						ts.dispatchEvent(new GWClusterEvent(GWClusterEvent.C_POINT_REMOVE, cO.n));
						if((tiO.timelineOn)&&(tiO.clusterEvents)) tiO.frame.clusterEventArray.push(new GWClusterEvent(GWClusterEvent.C_POINT_REMOVE, cO.n));
						ts.cO.point_remove = false;
				}
				// cluster add
				if (ts.cO.remove)
				{
						ts.dispatchEvent(new GWClusterEvent(GWClusterEvent.C_REMOVE, cO.id));
						if((tiO.timelineOn)&&(tiO.clusterEvents))ts.tiO.frame.clusterEventArray.push(new GWClusterEvent(GWClusterEvent.C_REMOVE, cO.id));
						ts.cO.remove = false;
				}
				// cluster remove
				if (ts.cO.add) 
				{
						ts.dispatchEvent(new GWClusterEvent(GWClusterEvent.C_ADD, cO.id));
						if((tiO.timelineOn)&&(tiO.clusterEvents)) tiO.frame.clusterEventArray.push(new GWClusterEvent(GWClusterEvent.C_ADD, cO.id));
						cO.add = false;
				}	
		}
		
		/**
		 * @private
		 */
		private function manageClusterPropertyEventDispatch():void 
		{
				// cluster translate
				if ((cO.dx!=0)||(cO.dy!=0)) 
				{
					ts.dispatchEvent(new GWClusterEvent(GWClusterEvent.C_TRANSLATE, { dx:cO.dx, dy:cO.dy, n:cO.n }));
					if((tiO.timelineOn)&&(tiO.clusterEvents)) tiO.frame.clusterEventArray.push(new GWClusterEvent(GWClusterEvent.C_TRANSLATE, { dx:cO.dx, dy:cO.dy, n:cO.n }));
				}
				// cluster rotate
				if (cO.dtheta!=0)
				{
					ts.dispatchEvent(new GWClusterEvent(GWClusterEvent.C_ROTATE, {dtheta:cO.dtheta, n:cO.n }));
					if((tiO.timelineOn)&&(tiO.clusterEvents)) tiO.frame.clusterEventArray.push(new GWClusterEvent(GWClusterEvent.C_ROTATE, {dtheta:cO.dtheta, n:cO.n}));
				}
				//cluster separate
				if ((cO.dsx!=0)||(cO.dsy!=0)) 
				{
					ts.dispatchEvent(new GWClusterEvent(GWClusterEvent.C_SEPARATE, { dsx:cO.dsx, dsy: cO.dsy, n:cO.n }));
					if((tiO.timelineOn)&&(tiO.clusterEvents)) tiO.frame.clusterEventArray.push(new GWClusterEvent(GWClusterEvent.C_SEPARATE,{ dsx:cO.dsx, dsy:cO.dsy, n:cO.n }));
				}
				// cluster resize
				if ((cO.dw!=0)||(cO.dh!=0)) 
				{
					ts.dispatchEvent(new GWClusterEvent(GWClusterEvent.C_RESIZE, { dw:cO.dw, dh:cO.dh, n:cO.n }));
					if((tiO.timelineOn)&&(tiO.clusterEvents)) tiO.frame.clusterEventArray.push(new GWClusterEvent(GWClusterEvent.C_RESIZE, { dw:cO.dw, dh:cO.dh, n:cO.n }));
				}
				/////////////////////////////////////////////////////////////////////////////
				// cluster accelerate
				if ((cO.ddx!=0)||(cO.ddy!=0))
				{
					ts.dispatchEvent(new GWClusterEvent(GWClusterEvent.C_ACCELERATE, { ddx:cO.ddx, ddy:cO.ddy, n:cO.n }));
					if((tiO.timelineOn)&&(tiO.clusterEvents)) tiO.frame.clusterEventArray.push(new GWClusterEvent(GWClusterEvent.C_ACCELERATE, { ddx:cO.ddx, ddy:cO.ddy, n:cO.n }));
				}
		}	
	}
}