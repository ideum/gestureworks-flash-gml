﻿////////////////////////////////////////////////////////////////////////////////
//
//  IDEUM
//  Copyright 2011-2012 Ideum
//  All Rights Reserved.
//
//  GestureWorks
//
//  File:    TouchMovieClipCluster.as
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
	//import com.gestureworks.analysis.clusterVectormetric;
	import flash.geom.Point;
	
	public class TouchMovieClipCluster extends TouchMovieClipBase
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
		
		
		public function TouchMovieClipCluster():void
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
			// FIND CLUSTER COUNT
			cO.n = cO.pointArray.length
			_dN = cO.n - _N;
			_N = cO.n;
			
			// CLUSTER OBJECT UPDATE
			if (_dN < 0) cO.point_remove = true; 
			if (_dN > 0) cO.point_add = true; 
			if ((_dN < 0) && (_N == 0)) cO.remove = true; 
			if ((_dN > 0) && (_N == 1)) cO.add = true; 
			if ((_dN != 0)&&(_clusterEvents)) manageClusterEventDispatch();
			
			// GESTURE OBJECT UPDATE
			if ((_N == 0) && (_dN < 0)) 
			{
				gO.release = true;
			}
			if (_N != 0) 
			{
				gO.start = true;
				gO.complete = false;
				gO.release = false;
			}
		}
		/**
		* @private
		*/
		// internal public
		public function updateClusterAnalysis():void
			{
				//trace("update cluster analysis")
				updateClusterCount();
				if (kinemetricsOn) findCluster();
				//cluster_kinemetric.findCluster();
				//if(vectormetricsOn)cluster_vectormetric.findPath();
				if ((_clusterEvents)&&(_N)) manageClusterPropertyEventDispatch();
		}
		
		public function findCluster():void 
		{
			//trace("TouchSpriteCluster findcluster update-----------------------------",GestureGlobals.frameID, N);
			
			cluster_kinemetric.findCluster();
			cluster_kinemetric.resetVars();
			
			cluster_kinemetric.findInstDimention();
			cluster_kinemetric.findInstSeparation();
			cluster_kinemetric.findInstAngle();
			
			
			for (key in gO.pOList) 
			{
				///////////////////////////////////////////////////////////////////////////////////////////////////
				// BASIC DRAG/SCALE/ROTATE CONTROL // ALGORITHM // type manipulate
				//////////////////////////////////////////////////////////////////////////////////////////////////
				if (gO.pOList[key].gesture_type == "manipulate"){
					
						//if (ts.trace_debug_mode) 
						//trace("cluster manipulate algorithm call in touchsprite cluster");
						
						if ((gO.pOList[key])&&(gestureList[key]))
						{
							//for (prop in ts.gO.pOList[key]) if (ts.gO.pOList[key][prop] is PropertyObject) ts.gO.pOList[key][prop].clusterDelta = 0;
							gO.pOList[key]["drag_dx"].clusterDelta = 0;
							gO.pOList[key]["drag_dy"].clusterDelta = 0;
							gO.pOList[key]["scale_dsx"].clusterDelta = 0; 
							gO.pOList[key]["scale_dsy"].clusterDelta = 0;
							gO.pOList[key]["rotate_dtheta"].clusterDelta = 0;
						
							if((_N >= gO.pOList[key].nMin)&&(_N <= gO.pOList[key].nMax))
							{
								//if (!findMeanInstTransformation_complete) 
								//{
									cluster_kinemetric.findMeanInstTransformation();
									//findMeanInstTransformation_complete = true;
								//}
							//}
								
							gO.pOList[key]["drag_dx"].clusterDelta = cluster_kinemetric.c_dx; // drag_dx
							gO.pOList[key]["drag_dy"].clusterDelta = cluster_kinemetric.c_dy; // drag_dy
							gO.pOList[key]["scale_dsx"].clusterDelta = cluster_kinemetric.c_ds; //scale_dsx
							gO.pOList[key]["scale_dsy"].clusterDelta = cluster_kinemetric.c_ds; //scale_dsy
							gO.pOList[key]["rotate_dtheta"].clusterDelta = cluster_kinemetric.c_dtheta; //rotate_dtheta
							}
						}
				}
				
				///////////////////////////////////////////////////////////////////////////////////////////////////
				// BASIC HOLD CONTROL // ALGORITHM // type hold
				//////////////////////////////////////////////////////////////////////////////////////////////////
				if (gO.pOList[key].gesture_type == "hold"){
					
						if (trace_debug_mode) trace("cluster hold algorithm");
						
						if ((gO.pOList[key])&&(gestureList[key]))
						{
							cluster_kinemetric.findLockedPoints();
						}
				}	
			
				///////////////////////////////////////////////////////////////////////////////////////////////////
				// BASIC STROKE LISTENING // ALGORITHM // type STROKE
				//////////////////////////////////////////////////////////////////////////////////////////////////
				if (gO.pOList[key].gesture_type == "stroke"){

						if ((gO.pOList[key])&&(gestureList[key])&&(N==1))
						{
							cluster_kinemetric.findPath();	
						}
				}
				
				///////////////////////////////////////////////////////////////////////////////////////////////////
				// BASIC DRAG CONTROL // ALGORITHM // type drag
				//////////////////////////////////////////////////////////////////////////////////////////////////
				
				if (gO.pOList[key].gesture_type == "drag"){
				
					if (trace_debug_mode) trace("cluster drag algorithm");
					
					if ((gO.pOList[key])&&(gestureList[key]))
					{
						//for (prop in ts.gO.pOList[key]) if (ts.gO.pOList[key][prop] is PropertyObject) ts.gO.pOList[key][prop].clusterDelta = 0;
						gO.pOList[key]["drag_dx"].clusterDelta = 0;
						gO.pOList[key]["drag_dy"].clusterDelta = 0;
					
						if((_N >= gO.pOList[key].nMin)&&(_N <= gO.pOList[key].nMax))
						{
							/////////////////////////////////////////////////////////////////
							// STANDARD OPERATION	
							/////////////////////////////////////////////////////////////////
						//if (!findMeanInstTranslation_complete) 
						//{
							cluster_kinemetric.findMeanInstTranslation();
							//findMeanInstTranslation_complete = true;
						//}
							/////////////////////////////////////////////////////////////////
							
							gO.pOList[key]["drag_dx"].clusterDelta = cluster_kinemetric.c_dx; // drag_dx
							gO.pOList[key]["drag_dy"].clusterDelta = cluster_kinemetric.c_dy; // drag_dy
						}
					}
				}
				
				///////////////////////////////////////////////////////////////////////////////////////////////////
				// BASIC SCALE CONTROL // ALGORITHM // type scale
				//////////////////////////////////////////////////////////////////////////////////////////////////
				if (gO.pOList[key].gesture_type == "scale")
				{
						if (trace_debug_mode) trace("cluster separation algorithm");
						
						if ((gO.pOList[key])&&(gestureList[key]))
						{
							gO.pOList[key]["scale_dsx"].clusterDelta = 0; 
							gO.pOList[key]["scale_dsy"].clusterDelta = 0;
							
							if((_N >= gO.pOList[key].nMin)&&(_N <= gO.pOList[key].nMax))
							{
								///////////////////////////////////////////////////////////////////
								// STANDARD OPERATION	
								///////////////////////////////////////////////////////////////////
								//if (!findMeanInstSeparation_complete)
								///{
									cluster_kinemetric.findMeanInstSeparation();
									//findMeanInstSeparation_complete = true;
								//}
								///////////////////////////////////////////////////////////////////
								
								gO.pOList[key]["scale_dsx"].clusterDelta = cluster_kinemetric.c_ds; //scale_dsx
								gO.pOList[key]["scale_dsy"].clusterDelta = cluster_kinemetric.c_ds; //scale_dsy
								
							}
					}
				}
			
				///////////////////////////////////////////////////////////////////////////////////////////////////
				// BASIC ROTATE CONTROL // ALGORITHM // type rotate
				//////////////////////////////////////////////////////////////////////////////////////////////////
				if (gO.pOList[key].gesture_type == "rotate")
				{
						if (trace_debug_mode) trace("cluster rotate algorithm");
						
						if ((gO.pOList[key])&&(gestureList[key]))
						{
							gO.pOList[key]["rotate_dtheta"].clusterDelta = 0;
							
							if((_N >= gO.pOList[key].nMin)&&(_N <= gO.pOList[key].nMax))
							{	
								///////////////////////////////////////////////////////////////////
								// STANDARD OPERATION	
								///////////////////////////////////////////////////////////////////
								//if (!findMeanInstRotation_complete) 
								//{
									cluster_kinemetric.findMeanInstRotation();
									//findMeanInstRotation_complete = true;
								//}
								///////////////////////////////////////////////////////////////////
								
								gO.pOList[key]["rotate_dtheta"].clusterDelta = cluster_kinemetric.c_dtheta; //rotate_dtheta
							}
						}
				}	
				
				
				///////////////////////////////////////////////////////////////////////////////////////////////////
			// BASIC ORIENTATION CONTROL // ALGORITHM
			//////////////////////////////////////////////////////////////////////////////////////////////////
			
			if (gO.pOList[key].gesture_type == "orient")
			{
				if (trace_debug_mode) trace("cluster orientation algorithm");
					
				if ((gO.pOList[key])&&(gestureList[key]))
				{
					gO.pOList[key]["orient_dx"].clusterDelta = 0; 
					gO.pOList[key]["orient_dy"].clusterDelta = 0; 
				
				if((_N == gO.pOList[key].n)) //(N >= COrientNMin)&&(N <= COrientNMax)) //n==5
					{
						///////////////////////////////////////////////////////////////////
						// STANDARD OPERATION	
						///////////////////////////////////////////////////////////////////
						//if (!findMeanInstPosition_complete) 
						//{
							cluster_kinemetric.findMeanInstPosition();
							//findMeanInstPosition_complete = true;
						//}
						///////////////////////////////////////////////////////////////////
						
						var pt:Point = cluster_kinemetric.findInstOrientation();
						
						//NEED TO PUSH OUT ORIENTATION ANGLE
						// TO CLUSTER ROTATION
						// WILL BE MAPPED TO ROTATION FOR TRANSFROM OBJECT AND THEN TO TOUCHSPRITE NATIVELEY SNAP TO ORIENTATION 
						gO.pOList[key]["orient_dx"].clusterDelta = pt.x;
						gO.pOList[key]["orient_dy"].clusterDelta = pt.y;
					}
				}
			}
				
			///////////////////////////////////////////////////////////////////////////////////////////////////
			// BASIC PIVOT CONTROL // ALGORITHM
			///////////////////////////////////////////////////////////////////////////////////////////////////
			
			if (gO.pOList[key].gesture_type == "pivot")
			{
				if (trace_debug_mode) trace("cluster pivot algorithm");
				
				if ((gO.pOList[key])&&(gestureList[key]))
				{ 
					gO.pOList[key]["pivot_dtheta"].clusterDelta = 0;
				
					if((_N == gO.pOList[key].n))
					{		
						// assign value to property object
						gO.pOList[key]["pivot_dtheta"].clusterDelta = cluster_kinemetric.findInstPivot(gO.pOList[key].cluster_rotation_threshold);//cluster_kinemetric.pivot_dtheta;
					}
				}
			}
				
	
			
			///////////////////////////////////////////////////////////////////////////////////////////////////
			// BASIC FLICK CONTROL // ALGORITHM
			///////////////////////////////////////////////////////////////////////////////////////////////////
			
			// SHOULD BE DISCRETE ON RELEASE
			// CHECK FOR ACCELERATION
			// IF ABOVE ACCEL THREHOLD RETURN GESTURE
			if (gO.pOList[key].gesture_type == "flick")
			{
				if (trace_debug_mode) trace("cluster flick algorithm");
				
				if ((gO.pOList[key])&&(gestureList[key]))
				{
					gO.pOList[key]["flick_dx"].clusterDelta = 0; 
					gO.pOList[key]["flick_dy"].clusterDelta = 0; 
				
				if((_N >= gO.pOList[key].nMin)&&(_N <= gO.pOList[key].nMax))
				{
					var flick_threshold:Number = gO.pOList[key].cluster_acceleration_threshold; //accleration threshold
					var flick_h:int = 3;
					var flick_etm_accel:Point = cluster_kinemetric.findMeanTemporalAcceleration(flick_h); //ensamble temporal mean acceleration
					var flick_etmVel:Point = cluster_kinemetric.findMeanTemporalVelocity(flick_h); // ensamble temporal mean velocity
					
					//////////////////////////////////////////////////////////////////
					// STANDARD OPERATION	
					///////////////////////////////////////////////////////////////////
					cluster_kinemetric.findMeanInstAcceleration();
					
					// limits
					if (Math.abs(flick_etm_accel.x) < flick_threshold) flick_etmVel.x = 0;
					if (Math.abs(flick_etm_accel.y) < flick_threshold) flick_etmVel.y = 0;;
					
					// TODO ADD DISPATCH CHECK 
					//ONLY ALLOW DISPATCH ONCE PER CLUSTER SESSION, REQUIRE RELEASE BEFORE RESETTING
					//REQUIRE RELEASE BEFORE RE-DISPATCH
					//REQUIRE MIN HISTORY OF 20 FRAMES TO REDUCE INIT TOUCH JERK ACCIDENTAL TRIGGER
					
					// assign value to property object
					gO.pOList[key]["flick_dx"].clusterDelta = flick_etmVel.x;
					gO.pOList[key]["flick_dy"].clusterDelta = flick_etmVel.y;
					//trace("flick, velocity",flick_etmVel.x,flick_etmVel.y,flick_etm_accel.x,flick_etm_accel.y,flick_threshold,flick_dx,flick_dy)
					}
				}
			}
			
			///////////////////////////////////////////////////////////////////////////////////////////////////
			// BASIC SWIPE CONTROL // ALGORITHM
			///////////////////////////////////////////////////////////////////////////////////////////////////
			// SHOULD BE DISCRETE GESTURE ON RELEASE
			// CONST VELOCITY CHECK FOR LARGE CHNAGES IN ACCEL
			// RETURN VELOCITY OF SWIPE IN X AND Y
			if (gO.pOList[key].gesture_type == "swipe")
			{
				if (trace_debug_mode) trace("cluster swipe algorithm");
				
				if ((gO.pOList[key])&&(gestureList[key]))
				{ 
					gO.pOList[key]["swipe_dx"].clusterDelta = 0; 
					gO.pOList[key]["swipe_dy"].clusterDelta = 0;
					
					if((_N >= gO.pOList[key].nMin)&&(_N <= gO.pOList[key].nMax))
					{
					var swipe_threshold:Number = gO.pOList[key].cluster_acceleration_threshold;// acceleration threshold
					var swipe_h:int = 6;
					var swipe_etmVel:Point = cluster_kinemetric.findMeanTemporalVelocity(swipe_h); //ensamble temporal mean velocity
					var swipe_etmAccel:Point = cluster_kinemetric.findMeanTemporalAcceleration(swipe_h); //ensamble temporal mean velocity
					
					//////////////////////////////////////////////////////////////////
					// STANDARD OPERATION	
					///////////////////////////////////////////////////////////////////
					cluster_kinemetric.findMeanInstAcceleration();
					
					if (Math.abs(swipe_etmAccel.x) > swipe_threshold) swipe_etmAccel.x = 0;
					if (Math.abs(swipe_etmAccel.y) > swipe_threshold) swipe_etmAccel.y = 0;
					
					// STRCT CONDITIONS FOR BOTH X AND Y
					// NEEDS TO RETURN ACCELERATION ALSO
					// NEED MULTIPLE FIELDS FOR CLUSTER DELTA
					
					//REQUIRE MIN HISTORY OF 20 FRAMES TO REDUCE INIT TOUCH JERK ACCIDENTAL TRIGGER
					
					// assign value to property object
					gO.pOList[key]["swipe_dx"].clusterDelta = swipe_etmAccel.x;
					gO.pOList[key]["swipe_dy"].clusterDelta = swipe_etmAccel.y;
					
					//trace("swipe, velocity",swipe_etmVel.x,swipe_etmVel.y,swipe_etmAccel.x,swipe_etmAccel.y,swipe_threshold)
					}
				}
			}
			
			
			///////////////////////////////////////////////////////////////////////////////////////////////////
			// BASIC SCROLL CONTROL // ALGORITHM
			///////////////////////////////////////////////////////////////////////////////////////////////////
			
			// CONTINUOUSLY
			// MIN TRANSLATION IN X AND Y
			// RETURN AVERAGE ENSABLE TEMPORAL VELOCITY 
			if (gO.pOList[key].gesture_type == "scroll")
			{
				if (trace_debug_mode) trace("cluster scroll algorithm");
				
				if ((gO.pOList[key])&&(gestureList[key]))
				{
					gO.pOList[key]["scroll_dx"].clusterDelta = 0; 
					gO.pOList[key]["scroll_dy"].clusterDelta = 0;
				
				if((_N >= gO.pOList[key].nMin)&&(_N <= gO.pOList[key].nMax))
				{
					var scroll_dx:Number = 0; 
					var scroll_dy:Number = 0;
					var scroll_threshold:Number = gO.pOList[key].cluster_translation_threshold; // acceleration threshold
					var scroll_h:int = 6;
					var etmVel:Point = cluster_kinemetric.findMeanTemporalVelocity(scroll_h); //ensamble temporal mean 
					
					// thresholds
					if(Math.abs(etmVel.x) > scroll_threshold) etmVel.y = 0;
					if (Math.abs(etmVel.y) > scroll_threshold) etmVel.x = 0;
			
					gO.pOList[key]["scroll_dx"].clusterDelta = etmVel.x; 
					gO.pOList[key]["scroll_dy"].clusterDelta = etmVel.y;
					//trace("scroll, velocity",etmVel.x,etmVel.y)
					}
				}
			}
			///////////////////////////////////////////////////////////////////////////////////////////////////
			// BASIC TILT CONTROL // ALGORITHM
			///////////////////////////////////////////////////////////////////////////////////////////////////
			// LOOK FOR SEPARATION OF CLUSTER IN X AND Y DIRECTION
			// RETURN DX AND DY
			
			if (gO.pOList[key].gesture_type == "tilt")
			{
				if (trace_debug_mode) trace("cluster tilt algorithm");
				
					
				if ((gO.pOList[key])&&(gestureList[key]))
				{
					gO.pOList[key]["tilt_dx"].clusterDelta = 0; 
					gO.pOList[key]["tilt_dy"].clusterDelta = 0; 
				
					if((_N == gO.pOList[key].n)) // LOCKED INTO 3 POINT EXCLUSIVE ACTIVATION
					{
						var tilt_threshold:Number = gO.pOList[key].cluster_separation_threshold;
						
						//////////////////////////////////////////////////////////////////
						// STANDARD OPERATION	
						///////////////////////////////////////////////////////////////////
						var pt_tilt:Point = cluster_kinemetric.findMeanInstSeparationXY();
						
						if (Math.abs(pt_tilt.x) > tilt_threshold) pt_tilt.y = 0;
						if (Math.abs(pt_tilt.y) > tilt_threshold) pt_tilt.x = 0;
						
						gO.pOList[key]["tilt_dx"].clusterDelta = pt_tilt.x; //tilt_dx
						gO.pOList[key]["tilt_dy"].clusterDelta = pt_tilt.y; //tilt_dy
						//trace("TILT seperation",c_dsx,c_dsy)
					}
				}
			}
			
			}
			
			cluster_kinemetric.pushClusterObjectProperties();
		}
		/**
		* @private
		*/
		// internal public
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
		// internal public
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
		* Determins whether clusterEvents are processed and dispatched on the touchMovieClip.
		*/
		
		public function get clusterEvents():Boolean{return _clusterEvents;}
		public function set clusterEvents(value:Boolean):void
		{
			_clusterEvents=value;
		}
	}
}