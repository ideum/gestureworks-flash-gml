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
	import com.gestureworks.analysis.clusterKinemetric;
	import flash.geom.Point;
	//import com.gestureworks.analysis.clusterVectormetric;
	
	import com.gestureworks.objects.PropertyObject;
	
	//use namespace id_internal;
	
	/**
	* @private
	*/
	public class TouchSpriteCluster extends TouchSpriteBase
	{
		/**
		* @private
		*/
		private var cluster_kinemetric:clusterKinemetric;
		//private var cluster_vectormetric:Vectormetric;
		/**
		* @private
		*/
		private var kinemetricsOn:Boolean = true;
		//private var vectoremetricsOn:Boolean = true;
		
		private var key:String;
		
		
		public function TouchSpriteCluster():void
		{
			super();
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
				//trace("create touchsprite cluster analysis")
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
					if(kinemetricsOn)cluster_kinemetric = new clusterKinemetric(touchObjectID);

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
			_dN = cO.n - _N;
			_N = cO.n;
			
			
			
			// CLUSTER OBJECT UPDATE
			
			// reset cluster states
			cO.point_remove = false;
			cO.point_add = false;
			cO.remove = false; 
			cO.add = false;
			
			
				if (_dN < 0) 
				{
					cO.point_remove = true;
					//cO.point_add = false;
					
					if (_N == 0) 
					{
						cO.remove = true; 
						//cO.add = false;
					}
				}
				else if (_dN > 0) 
				{
					//cO.point_remove = false;
					cO.point_add = true;
					
					if (_N != 0)
					{
						//cO.remove = false; 
						cO.add = true; 
					}
				}
			
			if (_dN != 0)
			{
				if (_clusterEvents) manageClusterEventDispatch();
			}
			//trace(_dN, _N, cO.point_remove,cO.point_add,cO.remove,cO.add)
			
			
			
			///////////////////////////////////////////////////
			// move to pipeline
			///////////////////////////////////////////////////
			// GESTURE OBJECT UPDATE
			if (_dN > 0) gO.start = true;
			
			if (_N != 0) 
			{
				gO.active = true;
				gO.complete = false;
				gO.release = false;
			}
			else {
				if (_dN < 0) 
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
				if ((_clusterEvents)&&(_N)) manageClusterPropertyEventDispatch();
		}
		
		
		public function findCluster():void 
		{
			//trace("TouchSprite findcluster update-----------------------------",GestureGlobals.frameID, N);
			
			cluster_kinemetric.findCluster();
			cluster_kinemetric.resetVars();
			
			cluster_kinemetric.findInstDimention();
			cluster_kinemetric.findInstSeparation();
			cluster_kinemetric.findInstAngle();
			
			
			for (key in gO.pOList)
			{
				//trace(gO.pOList[key].algorithm, _N, gO.pOList[key].n)
				
				
				// zero cluster deltas
				var DIM:String = ""; 
				for (DIM in gO.pOList[key])
				{
				if (gO.pOList[key][DIM] is PropertyObject) gO.pOList[key][DIM].clusterDelta = 0;		
				}
				
				
				if(_N!=0){		
				// check point number requirements
				if((_N >= gO.pOList[key].nMin)&&(_N <= gO.pOList[key].nMax)||(_N == gO.pOList[key].n))
				{
					//trace("call cluster calc",_N);
					
						// select algorithm 
						
						///////////////////////////////////////////////////////////////////////////////////////////////////
						// BASIC DRAG/SCALE/ROTATE CONTROL // ALGORITHM // type manipulate
						//////////////////////////////////////////////////////////////////////////////////////////////////
						
						if (gO.pOList[key].algorithm == "manipulate")
						{
							// apply algorithm
							cluster_kinemetric.findMeanInstTransformation();
							
							// gml controlled
							// map cluster into gesture object pipeline
							//gO.pOList[key]["dx"].clusterDelta = cluster_kinemetric.c_dx; // drag_dx
							//gO.pOList[key]["dy"].clusterDelta = cluster_kinemetric.c_dy; // drag_dy
							//gO.pOList[key]["dsx"].clusterDelta = cluster_kinemetric.c_ds; //scale_dsx
							//gO.pOList[key]["dsy"].clusterDelta = cluster_kinemetric.c_ds; //scale_dsy
							//gO.pOList[key]["dtheta"].clusterDelta = cluster_kinemetric.c_dtheta; //rotate_dtheta
							
							//GENERIC MAP
							for (DIM in gO.pOList[key])
							{
								if (gO.pOList[key][DIM] is PropertyObject) gO.pOList[key][DIM].clusterDelta = cO[gO.pOList[key][DIM].property_var];
							}
							
						}
						
						

						///////////////////////////////////////////////////////////////////////////////////////////////////
						// BASIC HOLD CONTROL // ALGORITHM // type hold
						//////////////////////////////////////////////////////////////////////////////////////////////////
						if (gO.pOList[key].algorithm == "hold")
						{
							//if (trace_debug_mode) trace("cluster hold algorithm");
							
							var hold_number:int = gO.pOList[key].n;
							var hold_dist:int = 0//gO.pOList[key]["hold_x"].point_translation_threshold;
							var	hold_time:int = 0//Math.ceil(gO.pOList[key]["hold_x"].point_event_duration_threshold / GestureGlobals.touchFrameInterval);	
							
							for (DIM in gO.pOList[key])
							{
								if (gO.pOList[key][DIM] is PropertyObject) {
									hold_dist = gO.pOList[key][DIM].point_translation_threshold;
									hold_time = Math.ceil(gO.pOList[key][DIM].point_event_duration_threshold / GestureGlobals.touchFrameInterval);
								}
							}
							
							cluster_kinemetric.findLockedPoints(hold_dist, hold_time, hold_number);
							

							if(cO.hold_n)
								{
								gO.pOList[key].activeEvent = true;
									
								for (DIM in gO.pOList[key])
								{
									if (gO.pOList[key][DIM] is PropertyObject) gO.pOList[key][DIM].clusterDelta = cO[gO.pOList[key][DIM].property_var];				
								}	
							}
						}
				
						/*
						
						///////////////////////////////////////////////////////////////////////////////////////////////////
						// BASIC STROKE LISTENING // ALGORITHM // type STROKE
						//////////////////////////////////////////////////////////////////////////////////////////////////
						if (gO.pOList[key].algorithm == "stroke")
						{
							var path:Object = cluster_kinemetric.findPath();
							luster_kinemetric.c_path_data;
							
							gO.pOList[key]["path"].clusterVector = path["vector"]
						}
						*/
						
						///////////////////////////////////////////////////////////////////////////////////////////////////
						// BASIC DRAG CONTROL // ALGORITHM // type drag
						//////////////////////////////////////////////////////////////////////////////////////////////////
						if (gO.pOList[key].algorithm == "drag"){
						
							//if (trace_debug_mode)trace("cluster drag algorithm",gO.pOList[key]["drag_dx"].clusterDelta);
							
							cluster_kinemetric.findMeanInstTranslation();
									
							//gO.pOList[key]["drag_dx"].clusterDelta = cluster_kinemetric.c_dx; // drag_dx
							//gO.pOList[key]["drag_dy"].clusterDelta = cluster_kinemetric.c_dy; // drag_dy
							
							//trace("drag calc tscluster", gO.pOList[key]["drag_dx"].clusterDelta,gO.pOList[key]["drag_dy"].clusterDelta);
							
							for (DIM in gO.pOList[key])
							{
								if (gO.pOList[key][DIM] is PropertyObject) gO.pOList[key][DIM].clusterDelta = cO[gO.pOList[key][DIM].property_var];				
							}
							
						}
						
						///////////////////////////////////////////////////////////////////////////////////////////////////
						// BASIC SCALE CONTROL // ALGORITHM // type scale
						//////////////////////////////////////////////////////////////////////////////////////////////////
						if (gO.pOList[key].algorithm == "scale")
						{
							//if (trace_debug_mode) trace("cluster separation algorithm");
							
							cluster_kinemetric.findMeanInstSeparation();
										
							//gO.pOList[key]["scale_dsx"].clusterDelta = cluster_kinemetric.c_ds; //scale_dsx
							//gO.pOList[key]["scale_dsy"].clusterDelta = cluster_kinemetric.c_ds; //scale_dsy
							
							for (DIM in gO.pOList[key])
							{
								if (gO.pOList[key][DIM] is PropertyObject) gO.pOList[key][DIM].clusterDelta = cO[gO.pOList[key][DIM].property_var];
							}
						}
	
						
						///////////////////////////////////////////////////////////////////////////////////////////////////
						// BASIC ROTATE CONTROL // ALGORITHM // type rotate
						//////////////////////////////////////////////////////////////////////////////////////////////////
						if (gO.pOList[key].algorithm == "rotate")
						{
							//if (trace_debug_mode) trace("cluster rotate algorithm");
					
							cluster_kinemetric.findMeanInstRotation();

							for (DIM in gO.pOList[key])
							{
								if (gO.pOList[key][DIM] is PropertyObject) gO.pOList[key][DIM].clusterDelta = cO[gO.pOList[key][DIM].property_var];
							}
						}	
						
						
						
						
						///////////////////////////////////////////////////////////////////////////////////////////////////
						// BASIC ORIENTATION CONTROL // ALGORITHM
						//////////////////////////////////////////////////////////////////////////////////////////////////
						if (gO.pOList[key].algorithm == "orient")
						{
							//if (trace_debug_mode) trace("cluster orientation algorithm");
						
							cluster_kinemetric.findMeanInstPosition();	
							cluster_kinemetric.findInstOrientation();
							
							//NEED TO PUSH OUT ORIENTATION ANGLE // TO CLUSTER ROTATION
							// WILL BE MAPPED TO ROTATION FOR TRANSFROM OBJECT AND THEN TO TOUCHSPRITE NATIVELEY SNAP TO ORIENTATION 
							
							for (DIM in gO.pOList[key])
							{
								if (gO.pOList[key][DIM] is PropertyObject) gO.pOList[key][DIM].clusterDelta = cO[gO.pOList[key][DIM].property_var];
							}
						}
						
						
						///////////////////////////////////////////////////////////////////////////////////////////////////
						// BASIC PIVOT CONTROL // ALGORITHM
						///////////////////////////////////////////////////////////////////////////////////////////////////
			
						if (gO.pOList[key].algorithm == "pivot")
						{
							//if (trace_debug_mode) trace("cluster pivot algorithm");
							
							cluster_kinemetric.findInstPivot(gO.pOList[key].cluster_rotation_min);
							
							for (DIM in gO.pOList[key])
							{
								if (gO.pOList[key][DIM] is PropertyObject) gO.pOList[key][DIM].clusterDelta = cO[gO.pOList[key][DIM].property_var];
							}
						}
						
						
						
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
							var flick_h:int = 6;
							var flick_etm_accel:Object = cluster_kinemetric.findMeanTemporalAcceleration(flick_h); //ensamble temporal mean acceleration
							var flick_etm_vel:Object = cluster_kinemetric.findMeanTemporalVelocity(flick_h); // ensamble temporal mean velocity

							for (DIM in gO.pOList[key])
							{
								if (gO.pOList[key][DIM] is PropertyObject) 
								{
									//var property_var:String = gO.pOList[key][DIM].property_var;
									//var flick_min:Number = gO.pOList[key][DIM].cluster_acceleration_min;
									
									// min limits
									//if (Math.abs(flick_etm_accel[gO.pOList[key][DIM].property_var]) > gO.pOList[key][DIM].cluster_acceleration_min) gO.pOList[key][DIM].clusterDelta = flick_etm_vel[gO.pOList[key][DIM].property_var];
									//else gO.pOList[key][DIM].clusterDelta = 0;
									
									gO.pOList[key][DIM].clusterDelta = flick_etm_vel[gO.pOList[key][DIM].property_var];
								}
							}
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
							
							var swipe_h:int = 6;
							var swipe_etm_vel:Object = cluster_kinemetric.findMeanTemporalVelocity(swipe_h); //ensamble temporal mean velocity
							var swipe_etm_accel:Object = cluster_kinemetric.findMeanTemporalAcceleration(swipe_h); //ensamble temporal mean velocity
							
							for (DIM in gO.pOList[key])
							{
								if (gO.pOList[key][DIM] is PropertyObject) 
								{
									
									// max limits
									//if (Math.abs(swipe_etm_accel[gO.pOList[key][DIM].property_var]) < gO.pOList[key][DIM].cluster_acceleration_max) gO.pOList[key][DIM].clusterDelta = swipe_etm_vel[gO.pOList[key][DIM].property_var];
									//else gO.pOList[key][DIM].clusterDelta = 0;
									
									
									gO.pOList[key][DIM].clusterDelta = swipe_etm_vel[gO.pOList[key][DIM].property_var];
								}
							}
							
							
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
							
							var scroll_h:int = 6;
							var scroll_etm_vel:Object = cluster_kinemetric.findMeanTemporalVelocity(scroll_h); //ensamble temporal mean 
							
							
							for (DIM in gO.pOList[key])
							{
								if (gO.pOList[key][DIM] is PropertyObject) 
								{
									// min limits
									//if (Math.abs(scroll_etm_vel[gO.pOList[key][DIM].property_var]) < gO.pOList[key][DIM].cluster_acceleration_min) gO.pOList[key][DIM].clusterDelta = scroll_etm_vel[gO.pOList[key][DIM].property_var];
									//else gO.pOList[key][DIM].clusterDelta = 0;
									
									gO.pOList[key][DIM].clusterDelta = scroll_etm_vel[gO.pOList[key][DIM].property_var];
									
								}
							}
							
						}
					
						
						
						///////////////////////////////////////////////////////////////////////////////////////////////////
						// BASIC TILT CONTROL // ALGORITHM
						///////////////////////////////////////////////////////////////////////////////////////////////////
						// LOOK FOR SEPARATION OF CLUSTER IN X AND Y DIRECTION
						// RETURN DX AND DY
						if (gO.pOList[key].algorithm == "tilt")
						{
							if (trace_debug_mode) trace("cluster tilt algorithm"); 
							
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
							
							for (DIM in gO.pOList[key])
							{
								if (gO.pOList[key][DIM] is PropertyObject) 
								{
									// min limits
									//if (Math.abs(scroll_etm_vel[gO.pOList[key][DIM].property_var]) < gO.pOList[key][DIM].cluster_seperation_min) gO.pOList[key][DIM].clusterDelta = cO[gO.pOList[key][DIM].property_var];
									//else gO.pOList[key][DIM].clusterDelta = 0;
									
									gO.pOList[key][DIM].clusterDelta = cO[gO.pOList[key][DIM].property_var];
									
								}
							}
							
							
						}	
				}
			}

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
						dispatchEvent(new GWClusterEvent(GWClusterEvent.C_POINT_ADD, cO.n));
						if((tiO.timelineOn)&&(tiO.clusterEvents)) tiO.frame.clusterEventArray.push(new GWClusterEvent(GWClusterEvent.C_POINT_ADD, cO.n));
						cO.point_add = false;
				}
				// point removed cluster
				if (cO.point_remove) 
				{
						dispatchEvent(new GWClusterEvent(GWClusterEvent.C_POINT_REMOVE, cO.n));
						if((tiO.timelineOn)&&(tiO.clusterEvents)) tiO.frame.clusterEventArray.push(new GWClusterEvent(GWClusterEvent.C_POINT_REMOVE, cO.n));
						cO.point_remove = false;
				}
				// cluster add
				if (cO.remove)
				{
						dispatchEvent(new GWClusterEvent(GWClusterEvent.C_REMOVE, cO.id));
						if((tiO.timelineOn)&&(tiO.clusterEvents))tiO.frame.clusterEventArray.push(new GWClusterEvent(GWClusterEvent.C_REMOVE, cO.id));
						cO.remove = false;
				}
				// cluster remove
				if (cO.add) 
				{
						dispatchEvent(new GWClusterEvent(GWClusterEvent.C_ADD, cO.id));
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
					dispatchEvent(new GWClusterEvent(GWClusterEvent.C_TRANSLATE, { dx:cO.dx, dy:cO.dy, n:cO.n }));
					if((tiO.timelineOn)&&(tiO.clusterEvents)) tiO.frame.clusterEventArray.push(new GWClusterEvent(GWClusterEvent.C_TRANSLATE, { dx:cO.dx, dy:cO.dy, n:cO.n }));
				}
				// cluster rotate
				if (cO.dtheta!=0)
				{
					dispatchEvent(new GWClusterEvent(GWClusterEvent.C_ROTATE, {dtheta:cO.dtheta, n:cO.n }));
					if((tiO.timelineOn)&&(tiO.clusterEvents)) tiO.frame.clusterEventArray.push(new GWClusterEvent(GWClusterEvent.C_ROTATE, {dtheta:cO.dtheta, n:cO.n}));
				}
				//cluster separate
				if ((cO.dsx!=0)||(cO.dsy!=0)) 
				{
					dispatchEvent(new GWClusterEvent(GWClusterEvent.C_SEPARATE, { dsx:cO.dsx, dsy: cO.dsy, n:cO.n }));
					if((tiO.timelineOn)&&(tiO.clusterEvents)) tiO.frame.clusterEventArray.push(new GWClusterEvent(GWClusterEvent.C_SEPARATE,{ dsx:cO.dsx, dsy:cO.dsy, n:cO.n }));
				}
				// cluster resize
				if ((cO.dw!=0)||(cO.dh!=0)) 
				{
					dispatchEvent(new GWClusterEvent(GWClusterEvent.C_RESIZE, { dw:cO.dw, dh: cO.dh, n:cO.n }));
					if((tiO.timelineOn)&&(tiO.clusterEvents)) tiO.frame.clusterEventArray.push(new GWClusterEvent(GWClusterEvent.C_RESIZE, { dw: cO.dw, dh: cO.dh, n:cO.n }));
				}
				/////////////////////////////////////////////////////////////////////////////
				// cluster accelerate
				if ((cO.ddx!=0)||(cO.ddy!=0))
				{
					dispatchEvent(new GWClusterEvent(GWClusterEvent.C_ACCELERATE, { ddx:cO.ddx, ddy:cO.ddy, n:cO.n }));
					if((tiO.timelineOn)&&(tiO.clusterEvents)) tiO.frame.clusterEventArray.push(new GWClusterEvent(GWClusterEvent.C_ACCELERATE, { ddx:cO.ddx, ddy:cO.ddy, n:cO.n }));
				}
		}	

		/**
		 * @private
		 */
		private var _clusterEvents:Boolean = false;
		/**
		* Determins whether clusterEvents are processed and dispatched on the touchSprite.
		*/
		public function get clusterEvents():Boolean{return _clusterEvents;}
		public function set clusterEvents(value:Boolean):void
		{
			_clusterEvents=value;
		}
	}
}