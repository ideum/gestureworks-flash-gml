////////////////////////////////////////////////////////////////////////////////
//
//  IDEUM
//  Copyright 2011-2012 Ideum
//  All Rights Reserved.
//
//  GestureWorks
//
//  File:    clusterKinemetric.as
//  Authors:  Ideum
//             
//  NOTICE: Ideum permits you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////
package com.gestureworks.analysis 
{
	/**
 * @private
 */
	
	import flash.geom.Point;
	
	//import com.gestureworks.core.TouchSprite;
	import com.gestureworks.core.GestureGlobals;
	import com.gestureworks.core.GestureWorks;
	import com.gestureworks.core.gw_public;
	import com.gestureworks.core.GML;
	import com.gestureworks.objects.PropertyObject;
		
	public class clusterKinemetric
	{
		////////////////////////////////////////////////////////////
		// Properties: Public
		////////////////////////////////////////////////////////////
		
		//////////////////////////////////////
		// ARITHMETIC CONSTANTS
		//////////////////////////////////////
		private static const RAD_DEG:Number = 180 / Math.PI;
		private static const DEG_RAD:Number = Math.PI / 180 ;
		
		private var touchObjectID:int;
		private var ts:Object;//private var ts:TouchSprite;
		private var pointList:Object;
		private var gml:XMLList;
		
		private var key:String;
		private var prop:String;
		
		// number in group
		private var N:int = 0;
		private var N1:Number = 0;
		private var k0:Number  = 0;
		private var k1:Number  = 0;
		private var i:int = 0;
		private var j:int = 0;
		private var h:int = 0;
		private var h0:Number = 0;

		////////////////////////////////////////////////////////////////////////////////////////
		// cluster property variables
		////////////////////////////////////////////////////////////////////////////////////////
		// basic cluster properties
		private var c_px:Number = 0; // cluster position x
		private	var c_py:Number = 0; // cluster position y
		private var c_r:Number = 0; // cluster radius
		private	var c_w:Number = 0; // cluster width
		private	var c_h:Number = 0; // cluster height
		private	var c_o:Number = 0; // cluster orientation with respect to hand
		private	var c_theta:Number = 0; // cluster rotation
		private var c_s:Number = 0; // cluster seperation
		private var c_sx:Number = 0; // cluster seperation
		private var c_sy:Number = 0; // cluster seperation
		private var c_emx:Number = 0; // mean cluster position (used in orientation -thumb)
		private var c_emy:Number = 0; //mean cluster position (used in orientation -thumb)
		private var thumbID:int;
		private var orient_dx:Number = 0; // cluster orientation vector
		private var orient_dy:Number = 0; // cluster orientation vector
		//private var hand:String = "left";
		
		// velocity // first order change in cluster properties wrt
		private	var c_dx:Number = 0; // cluster position change x
		private	var c_dy:Number = 0; // cluster position change y
		private	var c_dr:Number = 0; // cluster radius change
		private var c_dw:Number = 0; // cluster width change
		private	var c_dh:Number = 0; // cluster height change
		private	var c_ds:Number = 0; // cluster scale change
		private	var c_dsx:Number = 0;  // custer horiz scale change
		private var c_dsy:Number = 0; //custer vert scale change
		private var c_dtheta:Number = 0; // cluster angle change
		
		// acceleration //second order change in cluster properties wrt time
		private	var c_ddx:Number = 0; 
		private	var c_ddy:Number = 0;
		//private	var c_ddw:Number = 0; 
		//private	var c_ddh:Number = 0; 
		//private	var c_ddr:Number = 0; 
		//private	var c_dds:Number = 0; 
		//private var c_ddsx:Number = 0; 
		//private	var c_ddsy:Number = 0; 
		//private var c_ddtheta:Number = 0; 
		
		// jerk or jolt  // third order change in cluster properties wrt time
		//private	var c_dddx:Number = 0;  
		//private	var c_dddy:Number = 0;
		//private	var c_ddds:Number = 0; 
		//private	var c_dddtheta:Number = 0;
		
		//////////////////////////////////////////////////////////////////////////////////////////////////////
		// locked property delta thresholds
		//////////////////////////////////////////////////////////////////////////////////////////////////////
		private	var transThresholds:Boolean = true;
		private	var sepThresholds:Boolean = true;
		private	var rotThresholds:Boolean = true;
		private	var accelThresholds:Boolean = true;
		//private	var joltThresholds:Boolean = true;
		/////translation ////////////////////
		private	var x_threshold_min:Number = 0.01;
		private	var x_threshold_max:Number = 200;
		private	var y_threshold_min:Number = 0.01;
		private	var y_threshold_max:Number = 200;
		/////separation ////////////////////
		private var sep_threshold_min:Number = 0.001;
		private	var sep_threshold_max:Number = 0.15;
		private	var sepx_threshold_min:Number = 0.001;
		private var sepx_threshold_max:Number = 0.15;
		private	var sepy_threshold_min:Number = 0.001;
		private	var sepy_threshold_max:Number = 0.15;
		///////// rotation //////////////////
		private	var theta_threshold_min:Number = 0.01;
		private var theta_threshold_max:Number = 15;
		///////// acceleration //////////////////
		private	var ddx_threshold_min:Number = 0.001;
		private	var ddx_threshold_max:Number = 30;
		private	var ddy_threshold_min:Number = 0.001;
		private	var ddy_threshold_max:Number = 30;
		///////// jolt //////////////////
		//private var dddx_threshold_min:Number = 0.1;
		//private	var dddx_threshold_max:Number = 15;
		//private	var dddy_threshold_min:Number = 0.1;
		//private	var dddy_threshold_max:Number = 15;
		//////////////////////////////////////////////////
		
		// operations check list
		private	var findInstDimention_complete:Boolean = false;
		private	var	findInstSeparation_complete:Boolean = false;
		private	var	findInstAngle_complete:Boolean = false;
		private	var	findMeanInstPosition_complete:Boolean = false;
		private	var	findMeanInstTranslation_complete:Boolean = false;
		private	var	findMeanInstSeparation_complete:Boolean = false;
		private	var	findMeanInstSeparationXY_complete:Boolean = false;
		private	var	findMeanInstRotation_complete:Boolean = false;
		private	var	findMeanInstAcceleration_comlpete:Boolean = false;
		
		
		public function clusterKinemetric(_id:int) 
		{
			touchObjectID = _id;
			init();
		}
		
		public function init():void
		{
			ts = GestureGlobals.gw_public::touchObjects[touchObjectID]; // need to find center of object for orientation and pivot
			
			if (ts.trace_debug_mode) trace("init cluster kinemetric");
			
			////////////////////////////////////////////
			// internal variables only
			////////////////////////////////////////////
			transThresholds = true;
			sepThresholds = true;
			rotThresholds = true;
			accelThresholds = true;
			//joltThresholds = true;
			//translation 
			x_threshold_min = 0;
			x_threshold_max = 200;
			y_threshold_min = 0;
			y_threshold_max = 200;
			//separation 
			sep_threshold_min = 0//0.001/0.0012
			sep_threshold_max = 125//0.15/0.0012
			sepx_threshold_min = 0//0.001/0.0012
			sepx_threshold_max = 125//0.15/0.0012
			sepy_threshold_min = 0//0.001/0.0012
			sepy_threshold_max= 125//0.15/0.0012
			//rotation 
			theta_threshold_min= 0;
			theta_threshold_max = 90;
			//acceleration 
			ddx_threshold_min = 0.001;
			ddx_threshold_max = 30;
			ddy_threshold_min = 0.001;
			ddy_threshold_max = 30;
			//jolt
			///dddx_threshold_min = 0;
			//dddx_threshold_max = 15;
			//dddy_threshold_min = 0.001;
			//dddy_threshold_max = 15;
			
			//ADD FOR CLUSTER PRESURE CHANGE
			//dp 
			//ddp 
			//ADD FOR CLUSTER AVERAGE POINT SIZE CHANGE
			//dw 
			//ddw
			//dh 
			//ddh
		}
		
		public function findCluster():void
		{
				// get number of points in cluster
				N = ts.cO.n;
				
				//if (ts.trace_debug_mode) trace("find cluster..............................",N);
				
				/////////////////////////////////////////////////////
				// controls marhsaling of touchmove events in cluster
				/////////////////////////////////////////////////////
				h = 1;
				if (GestureGlobals.touchMoveMarshallOn) h0 = 1;
				else h0 = 1 / N;
				/////////////////////////////////////////////////////

				if (N) 
				{
					N1 = N - 1;
					k0 = 1 / N;
					k1 = 1/N1;
					pointList = ts.cO.pointArray
					clusterProperties();
					
					if (N == 0) k1 = 0;
				}

			else resetVars();
			return
		}
		
		
		private function resetVars():void {

			c_px = 0; 
			c_py = 0;
			c_r = 0;
			c_w = 0;
			c_h = 0; 
			c_o = 0;
			c_theta = 0; 
			c_s = 0; 
			c_sx = 0; 
			c_sy = 0; 
			
			c_emx = 0;
			c_emy = 0;
			orient_dx = 0;
			orient_dy = 0;
			
			//first diff
			c_dx = 0;
			c_dy = 0;
			c_ds = 0;
			c_dsx = 0;
			c_dsy = 0;
			c_dtheta = 0;
			
			// second diff
			c_ddx = 0;
			c_ddy = 0;
			
			// reset operations check list
			findInstDimention_complete = false;
			findInstSeparation_complete = false;
			findInstAngle_complete = false;
			findMeanInstPosition_complete = false;
			findMeanInstTranslation_complete = false;
			findMeanInstSeparation_complete = false;
			findMeanInstSeparationXY_complete = false;
			findMeanInstRotation_complete = false;
			findMeanInstAcceleration_comlpete = false;
		}
		
		private function clusterProperties():void
		{
			// initiate calculation vars
			resetVars();
			
			if (!findInstDimention_complete) 
			{
				findInstDimention();
				findInstDimention_complete = true;
			}
			
			if (!findInstSeparation_complete) 
			{
				findInstSeparation();
				findInstSeparation_complete = true;
			}
			
			if (!findInstAngle_complete) 
			{
				findInstAngle();
				findInstAngle_complete = true;
			}
		
			
			for (key in ts.gO.pOList) 
			{	
				
				///////////////////////////////////////////////////////////////////////////////////////////////////
				// BASIC DRAG CONTROL // ALGORITHM // type drag
				//////////////////////////////////////////////////////////////////////////////////////////////////
				if (ts.gO.pOList[key].gesture_type == "drag"){
				
					if (ts.trace_debug_mode) trace("cluster drag algorithm");
					
					if ((ts.gO.pOList[key])&&(ts.gestureList[key]))
					{
						//for (prop in ts.gO.pOList[key]) if (ts.gO.pOList[key][prop] is PropertyObject) ts.gO.pOList[key][prop].clusterDelta = 0;
						ts.gO.pOList[key]["drag_dx"].clusterDelta = 0;
						ts.gO.pOList[key]["drag_dy"].clusterDelta = 0;
					
						if((N >= ts.gO.pOList[key].nMin)&&(N <= ts.gO.pOList[key].nMax))
						{
							/////////////////////////////////////////////////////////////////
							// STANDARD OPERATION	
							/////////////////////////////////////////////////////////////////
						if (!findMeanInstTranslation_complete) 
						{
							findMeanInstTranslation();
							findMeanInstTranslation_complete = true;
						}
							/////////////////////////////////////////////////////////////////
							
							ts.gO.pOList[key]["drag_dx"].clusterDelta = c_dx; // drag_dx
							ts.gO.pOList[key]["drag_dy"].clusterDelta = c_dy; // drag_dy
						}
					}
				}
				
			///////////////////////////////////////////////////////////////////////////////////////////////////
			// BASIC SCALE CONTROL // ALGORITHM // type scale
			//////////////////////////////////////////////////////////////////////////////////////////////////
			if (ts.gO.pOList[key].gesture_type == "scale")
			{
					if (ts.trace_debug_mode) trace("cluster separation algorithm");
					
					if ((ts.gO.pOList[key])&&(ts.gestureList[key]))
					{
						ts.gO.pOList[key]["scale_dsx"].clusterDelta = 0; 
						ts.gO.pOList[key]["scale_dsy"].clusterDelta = 0;
						
						if((N >= ts.gO.pOList[key].nMin)&&(N <= ts.gO.pOList[key].nMax))
						{
							///////////////////////////////////////////////////////////////////
							// STANDARD OPERATION	
							///////////////////////////////////////////////////////////////////
							if (!findMeanInstSeparation_complete)
							{
								findMeanInstSeparation();
								findMeanInstSeparation_complete = true;
							}
							///////////////////////////////////////////////////////////////////
							
							ts.gO.pOList[key]["scale_dsx"].clusterDelta = c_ds; //scale_dsx
							ts.gO.pOList[key]["scale_dsy"].clusterDelta = c_ds; //scale_dsy
							
						}
				}
			}
				///////////////////////////////////////////////////////////////////////////////////////////////////
				// BASIC ROTATE CONTROL // ALGORITHM // type rotate
				//////////////////////////////////////////////////////////////////////////////////////////////////
				if (ts.gO.pOList[key].gesture_type == "rotate")
				{
						if (ts.trace_debug_mode) trace("cluster rotate algorithm");
						
						if ((ts.gO.pOList[key])&&(ts.gestureList[key]))
						{
							ts.gO.pOList[key]["rotate_dtheta"].clusterDelta = 0;
							
							if((N >= ts.gO.pOList[key].nMin)&&(N <= ts.gO.pOList[key].nMax))
							{	
								///////////////////////////////////////////////////////////////////
								// STANDARD OPERATION	
								///////////////////////////////////////////////////////////////////
								if (!findMeanInstRotation_complete) 
								{
									findMeanInstRotation();
									findMeanInstRotation_complete = true;
								}
								///////////////////////////////////////////////////////////////////
								
								ts.gO.pOList[key]["rotate_dtheta"].clusterDelta = c_dtheta; //rotate_dtheta
							}
						}
				}	
			
			///////////////////////////////////////////////////////////////////////////////////////////////////
			// BASIC ORIENTATION CONTROL // ALGORITHM
			//////////////////////////////////////////////////////////////////////////////////////////////////
			
			if (ts.gO.pOList[key].gesture_type == "orient")
			{
				if (ts.trace_debug_mode) trace("cluster orientation algorithm");
					
				if ((ts.gO.pOList[key])&&(ts.gestureList[key]))
				{
					ts.gO.pOList[key]["orient_dx"].clusterDelta = 0; 
					ts.gO.pOList[key]["orient_dy"].clusterDelta = 0; 
				
				if((N == ts.gO.pOList[key].n)) //(N >= COrientNMin)&&(N <= COrientNMax)) //n==5
					{
						///////////////////////////////////////////////////////////////////
						// STANDARD OPERATION	
						///////////////////////////////////////////////////////////////////
						if (!findMeanInstPosition_complete) 
						{
							findMeanInstPosition();
							findMeanInstPosition_complete = true;
						}
						///////////////////////////////////////////////////////////////////
						
						var handArray:Array = new Array();
						var maxDist:Number = 0;
						var maxAngle:Number = 0;
						var dist:Number = 0;
						var angle:Number = 180;
						
							for (i = 0; i < N; i++) 
								{
									if (pointList[i].history[0]) 
									{
										handArray[i] = new Array();
										handArray[i].id = pointList[i].id; // set point id
									
										
										// find distance between center of cluster and finger tip
										var dxe:Number = (pointList[i].history[0].x - c_px);
										var dye:Number = (pointList[i].history[0].y - c_py);
										
										// find diatance between mean center of cluster and finger tip
										var dxf:Number = (pointList[i].history[0].x - c_emx);
										var dyf:Number = (pointList[i].history[0].y - c_emy);
										var ds1:Number = Math.sqrt(dxf * dxf + dyf * dyf)
										
										handArray[i].dist = ds1; // set distance from mean
										handArray[i].angle = 180; // init angle between vectors to radial center

										for (var q:int = 0; q < N; q++) 
										{
											if (i != q)
											{
												if (pointList[q].history[0])
												{
												var dxq:Number = (pointList[q].history[0].x - c_px);
												var dyq:Number = (pointList[q].history[0].y - c_py);
												angle = dotProduct(dxe, dye, dxq, dyq)*RAD_DEG;
												
												if (angle < handArray[i].angle)
												{
													handArray[i].angle = angle;
												}
											}
										}
										}
									//trace("finger", handArray[i].id, handArray[i].dist, handArray[i].angle) // point list
									
									// find max angle
									if (maxAngle < handArray[i].angle) 	maxAngle = handArray[i].angle;
									// find min dist
									if (maxDist < handArray[i].dist)	maxDist = handArray[i].dist;
								}
						}
						// calculate thumb probaility value
						for (i = 0; i < N; i++) 
							{
								handArray[i].prob = (handArray[i].angle/maxAngle + handArray[i].dist/maxDist)*0.5
							}
						handArray.sortOn("prob",Array.DESCENDING);
						thumbID = handArray[0].id;
						
					
						// calc orientation vector // FIND ORIENTATION USING CLUSTER RADIAL CENTER
						for (i = 0; i < N; i++) 
							{
								if (pointList[i].id != handArray[0].id) 
								{	
									orient_dx += (pointList[i].history[0].x - c_px) * k1;
									orient_dy += (pointList[i].history[0].y - c_py) * k1;
								}
						}
						//NEED TO PUSH OUT ORIENTATION ANGLE
						// TO CLUSTER ROTATION
						// WILL BE MAPPED TO ROTATION FOR TRANSFROM OBJECT AND THEN TO TOUCHSPRITE NATIVELEY SNAP TO ORIENTATION 
						ts.gO.pOList[key]["orient_dx"].clusterDelta = orient_dx;
						ts.gO.pOList[key]["orient_dy"].clusterDelta = orient_dy;
					}
				}
			}
			///////////////////////////////////////////////////////////////////////////////////////////////////
			// BASIC PIVOT CONTROL // ALGORITHM
			///////////////////////////////////////////////////////////////////////////////////////////////////
			
			if (ts.gO.pOList[key].gesture_type == "pivot")
			{
				if (ts.trace_debug_mode) trace("cluster pivot algorithm");
				
				if ((ts.gO.pOList[key])&&(ts.gestureList[key]))
				{ 
					ts.gO.pOList[key]["pivot_dtheta"].clusterDelta = 0;
				
				if((N == ts.gO.pOList[key].n))
				{		
					var pivot_dtheta:Number = 0;
					var pivot_threshold:Number = ts.gO.pOList[key].cluster_rotation_threshold;
					
					var x_c:Number = 0
					var y_c:Number = 0
					
					if (ts.trO.transAffinePoints) 
					{
						//trace("test", tO.transAffinePoints[4])
						x_c = ts.trO.transAffinePoints[4].x
						y_c = ts.trO.transAffinePoints[4].y
					}
					
								if ((pointList[0].history[0]) && (pointList[0].history[1])) 
								{		
									// find touch point translation vector
									var dxh:Number = pointList[0].history[1].x - x_c;
									var dyh:Number = pointList[0].history[1].y - y_c;
											
									// find vector that connects the center of the object and the touch point
									var dxi:Number = pointList[0].history[0].x - x_c;
									var dyi:Number = pointList[0].history[0].y - y_c;
									var pdist:Number = Math.sqrt(dxi * dxi + dyi * dyi);
											
									var t0:Number = calcAngle(dxh, dyh);
									var t1:Number = calcAngle(dxi, dyi);
									if (t1 > 360) t1 = t1 - 360;
									if (t0 > 360) t0 = t0 - 360;
									var theta_diff:Number = t1 - t0
									if (theta_diff>300) theta_diff = theta_diff -360; //trace("Flicker +ve")
									if (theta_diff<-300) theta_diff = 360 + theta_diff; //trace("Flicker -ve");
									
									//pivot thresholds
									if (Math.abs(theta_diff) > pivot_threshold)
									{	
										// weighted effect
										pivot_dtheta = theta_diff * Math.pow(pdist, 2.2);
										
										c_px = pointList[0].history[0].x;
										c_py = pointList[0].history[0].y;
									}
									else pivot_dtheta = 0; 
									//trace("c_dtheta",c_dtheta, dx, dy, ds)
								}
							// assign value to property object
							ts.gO.pOList[key]["pivot_dtheta"].clusterDelta = pivot_dtheta;
					}
				}
			}
			
			///////////////////////////////////////////////////////////////////////////////////////////////////
			// BASIC FLICK CONTROL // ALGORITHM
			///////////////////////////////////////////////////////////////////////////////////////////////////
			// CHECK FOR ACCELERATION
			
			// IF ABOVE ACCEL THREHOLD RETURN 
			if (ts.gO.pOList[key].gesture_type == "flick")
			{
				if (ts.trace_debug_mode) trace("cluster flick algorithm");
				
				if ((ts.gO.pOList["flick"])&&(ts.gestureList[key]))
				{
					ts.gO.pOList[key]["flick_dx"].clusterDelta = 0; 
					ts.gO.pOList[key]["flick_dy"].clusterDelta = 0; 
				
				if((N >= ts.gO.pOList[key].nMin)&&(N <= ts.gO.pOList[key].nMax))
				{
					var flick_dx:Number = 0;
					var flick_dy:Number = 0;
					var flick_threshold:Number = ts.gO.pOList[key].cluster_acceleration_threshold; //accleration threshold
					
					////////////////////////////////////////////////////////////////////////////////////////////////////////
					var flick_h:int = 3;
					var flick_etm_accel:Point = findMeanTemporalAcceleration(flick_h); //ensamble temporal mean acceleration
					var flick_etmVel:Point = findMeanTemporalVelocity(flick_h); // ensamble temporal mean velocity
					////////////////////////////////////////////////////////////////////////////////////////////////////////
					
					//////////////////////////////////////////////////////////////////
					// STANDARD OPERATION	
					///////////////////////////////////////////////////////////////////
					if (!findMeanInstAcceleration_comlpete) 
					{
						findMeanInstAcceleration();
						findMeanInstAcceleration_comlpete = true;
					}
					////////////////////////////////////////////////////////////////////
					
					if ((Math.abs(flick_etm_accel.x) > flick_threshold) && (Math.abs(flick_etm_accel.y) > flick_threshold))
					{
						flick_dx = flick_etmVel.x;
						flick_dy = flick_etmVel.y;
					}
					else if (Math.abs(flick_etm_accel.x) > flick_threshold) 
					{
						flick_dx = flick_etmVel.x;
						flick_dy = 0;
					}
					else if (Math.abs(flick_etm_accel.y) > flick_threshold)
					{
						flick_dy = flick_etmVel.y;
						flick_dx = 0;
					}
					
					// TODO ADD DISPATCH CHECK 
					//ONLY ALLOW DISPATCH ONCE PER CLUSTER SESSION, REQUIRE RELEASE BEFORE RESETTING
					//REQUIRE RELEASE BEFORE RE-DISPATCH
					//REQUIRE MIN HISTORY OF 20 FRAMES TO REDUCE INIT TOUCH JERK ACCIDENTAL TRIGGER
					
					
					// assign value to property object
					ts.gO.pOList[key]["flick_dx"].clusterDelta = flick_dx;
					ts.gO.pOList[key]["flick_dy"].clusterDelta = flick_dy;
					//trace("flick, velocity",flick_etmVel.x,flick_etmVel.y,flick_etm_accel.x,flick_etm_accel.y,flick_threshold,flick_dx,flick_dy)
					}
				}
			}
			///////////////////////////////////////////////////////////////////////////////////////////////////
			// BASIC SWIPE CONTROL // ALGORITHM
			///////////////////////////////////////////////////////////////////////////////////////////////////
			// CONST VELOCITY CHECK FOR LARGE CHNAGES IN ACCEL
			// RETURN VELOCITY OF SWIPE IN X AND Y
			if (ts.gO.pOList[key].gesture_type == "swipe")
			{
				if (ts.trace_debug_mode) trace("cluster swipe algorithm");
				
				if ((ts.gO.pOList[key])&&(ts.gestureList[key]))
				{ 
					ts.gO.pOList[key]["swipe_dx"].clusterDelta = 0; 
					ts.gO.pOList[key]["swipe_dy"].clusterDelta = 0;
					
					if((N >= ts.gO.pOList[key].nMin)&&(N <= ts.gO.pOList[key].nMax))
					{
				
					var swipe_dx:Number = 0; 
					var swipe_dy:Number = 0;
					var swipe_threshold:Number = ts.gO.pOList[key].cluster_acceleration_threshold;// acceleration threshold
					
					////////////////////////////////////////////////////////////////////////////////////////////////////
					var swipe_h:int = 6;
					var swipe_etmVel:Point = findMeanTemporalVelocity(swipe_h); //ensamble temporal mean velocity
					var swipe_etmAccel:Point = findMeanTemporalAcceleration(swipe_h); //ensamble temporal mean velocity
					////////////////////////////////////////////////////////////////////////////////////////////////////
					
					//////////////////////////////////////////////////////////////////
					// STANDARD OPERATION	
					///////////////////////////////////////////////////////////////////
					if (!findMeanInstAcceleration_comlpete) 
					{
						findMeanInstAcceleration();
						findMeanInstAcceleration_comlpete = true;
					}
					////////////////////////////////////////////////////////////////////
					
					//swipe_dx = swipe_etmVel.x;
					//swipe_dy = swipe_etmVel.y;
						
					
					if ((Math.abs(swipe_etmAccel.x) < swipe_threshold) && (Math.abs(swipe_etmAccel.y) < swipe_threshold))
					{
						swipe_dx = swipe_etmVel.x;
						swipe_dy = swipe_etmVel.y;
					}
					//else if (Math.abs(swipe_etmAccel.x) < swipe_threshold) 
					//{
						//swipe_dx = swipe_etmVel.x;
						//swipe_dy = 0;
					//}
					//else if (Math.abs(swipe_etmAccel.y) < swipe_threshold) 
					//{
						//swipe_dy = swipe_etmVel.y;
						//swipe_dx = 0;
					//}
					
					// STRCT CONDITIONS FOR BOTH X AND Y
					// NEEDS TO RETURN ACCELERATION ALSO
					// NEED MULTIPLE FIELDS FOR CLUSTER DELTA
					
					// assign value to property object
					ts.gO.pOList[key]["swipe_dx"].clusterDelta = swipe_dx;
					ts.gO.pOList[key]["swipe_dy"].clusterDelta = swipe_dy;
					//trace("swipe, velocity",swipe_etmVel.x,swipe_etmVel.y,swipe_etmAccel.x,swipe_etmAccel.y,swipe_threshold)
					}
				}
			}
			///////////////////////////////////////////////////////////////////////////////////////////////////
			// BASIC SCROLL CONTROL // ALGORITHM
			///////////////////////////////////////////////////////////////////////////////////////////////////
			// MIN TRANSLATION IN X AND Y
			// RETURN AVERAGE ENSABLE TEMPORAL VELOCITY
			if (ts.gO.pOList[key].gesture_type == "scroll")
			{
				if (ts.trace_debug_mode) trace("cluster scroll algorithm");
				
				if ((ts.gO.pOList[key])&&(ts.gestureList[key]))
				{
					ts.gO.pOList[key]["scroll_dx"].clusterDelta = 0; 
					ts.gO.pOList[key]["scroll_dy"].clusterDelta = 0;
				
				if((N >= ts.gO.pOList[key].nMin)&&(N <= ts.gO.pOList[key].nMax))
				{
					var scroll_dx:Number = 0; 
					var scroll_dy:Number = 0;
					var scroll_threshold:Number = ts.gO.pOList[key].cluster_translation_threshold; // acceleration threshold
					
					////////////////////////////////////////////////////////////////////////////////////////////
					var scroll_h:int = 6;
					var etmVel:Point = findMeanTemporalVelocity(scroll_h); //ensamble temporal mean 
					////////////////////////////////////////////////////////////////////////////////////////////
					
					if ((Math.abs(etmVel.x) > scroll_threshold) && (Math.abs(etmVel.y) > scroll_threshold))
					{
						scroll_dx = etmVel.x;
						scroll_dy = etmVel.y;
					}
					else if (Math.abs(etmVel.x) > scroll_threshold) 
					{
						scroll_dx = etmVel.x;
						scroll_dy = 0;
					}
					else if (Math.abs(etmVel.y) > scroll_threshold) 
					{
						scroll_dx = 0;
						scroll_dy = etmVel.y;
					}	
					
					ts.gO.pOList[key]["scroll_dx"].clusterDelta = scroll_dx; 
					ts.gO.pOList[key]["scroll_dy"].clusterDelta = scroll_dy;
					//trace("scroll, velocity",etmVel.x,etmVel.y)
					}
				}
			}
			///////////////////////////////////////////////////////////////////////////////////////////////////
			// BASIC TILT CONTROL // ALGORITHM
			///////////////////////////////////////////////////////////////////////////////////////////////////
			// LOOK FOR SEPARATION OF CLUSTER IN X AND Y DIRECTION
			// RETURN DX AND DY
			
			if (ts.gO.pOList[key].gesture_type == "tilt")
			{
				if (ts.trace_debug_mode) trace("cluster tilt algorithm");
				
					
				if ((ts.gO.pOList[key])&&(ts.gestureList[key]))
				{
					ts.gO.pOList[key]["tilt_dx"].clusterDelta = 0; 
					ts.gO.pOList[key]["tilt_dy"].clusterDelta = 0; 
				
					if((N == ts.gO.pOList[key].n)) // LOCKED INTO 3 POINT EXCLUSIVE ACTIVATION
					//if((N >= ts.gO.pOList[key].nMin)&&(N <= ts.gO.pOList[key].nMax))
					{
						var tilt_dx:Number = 0;
						var tilt_dy:Number = 0;
						var tilt_threshold:Number = ts.gO.pOList[key].cluster_separation_threshold;
						
						//////////////////////////////////////////////////////////////////
						// STANDARD OPERATION	
						///////////////////////////////////////////////////////////////////
						if (!findMeanInstSeparationXY_complete) 
						{
							findMeanInstSeparationXY();
							findMeanInstSeparationXY_complete = true;
						}
						////////////////////////////////////////////////////////////////////
						
						if ((Math.abs(c_dsx) > tilt_threshold) && (Math.abs(c_dsy) > tilt_threshold))
						{
							tilt_dx = c_dsx;
							tilt_dy = c_dsy;
						}
						else if (Math.abs(c_dsx) > tilt_threshold) 
						{
							tilt_dx = c_dsx;
							tilt_dy = 0;
						}
						else if (Math.abs(c_dsy) > tilt_threshold) 
						{
							tilt_dx = 0;
							tilt_dy = c_dsy;
						}	
						
						ts.gO.pOList[key]["tilt_dx"].clusterDelta = tilt_dx; //tilt_dx
						ts.gO.pOList[key]["tilt_dy"].clusterDelta = tilt_dy; //tilt_dy
						//trace("TILT seperation",c_dsx,c_dsy)
					}
				}
			}
			
			}
			/////////////////////////////////////////////////////////////////////////////////////
			// update cluster properties
			/////////////////////////////////////////////////////////////////////////////////////
			//if (N == 0) resetVars();
			pushClusterObjectProperties();
		}
		
		private function pushClusterObjectProperties():void
		{
			///////////////////////////////////////////////////////////////////////////////////
			// puts kenemetric results into cluster object
			///////////////////////////////////////////////////////////////////////////////////
			
			//////////////////////////
			//fundamental properties
			//////////////////////////
			ts.cO.n = N;
			ts.cO.x = c_px;
			ts.cO.y = c_py;
			ts.cO.width = c_w;
			ts.cO.height = c_h;
			ts.cO.radius = c_r/2;
			ts.cO.separationX = c_sx;
			ts.cO.separationY = c_sy;
			ts.cO.rotation = c_theta;
			ts.cO.orientation =  c_o;
			ts.cO.thumbID = thumbID;
			//cO.hand = hand;
			ts.cO.mx = c_emx;
			ts.cO.my = c_emy;
			ts.cO.orient_dx = orient_dx;
			ts.cO.orient_dy = orient_dy;
		
			/////////////////////////
			// first diff
			/////////////////////////
			ts.cO.dtheta = c_dtheta;
			ts.cO.dx = c_dx;
			ts.cO.dy = c_dy;
			//cO.dw = c_dw;	
			//cO.dh = c_dh;
			//cO.dr = c_dr;
			ts.cO.ds = c_ds;
			ts.cO.dsx = c_ds;//c_dsx;
			ts.cO.dsy = c_ds;//c_dsy;
			
			////////////////////////
			// second diff
			////////////////////////
			ts.cO.ddx = c_ddx;
			ts.cO.ddy = c_ddy;
			//cO.ddw = c_ddw;	
			//cO.ddh = c_ddh;
			//cO.ddr = c_ddr;
			//cOdds = c_dds;
			//cO.ddsx = c_ddsx;
			//cO.ddsy = c_ddsy;
			//cO.ddtheta = c_ddtheta;
		}
		
		////////////////////////////////////////////////////////////
		// Methods: Private
		////////////////////////////////////////////////////////////
		
		private function findInstDimention():void
		{
					///////////////////////////////////////////////////////////////////////////////////////////////////////////
					// cluster width, height and radius // OPERATION
					///////////////////////////////////////////////////////////////////////////////////////////////////////////
					// basic cluster property values 
					// uses the current position of the points in the cluster to find the spread of the cluster and its current dims
					
					c_px = 0; 
					c_py = 0;
					c_r = 0;
					c_w = 0;
					c_h = 0;
					
						for (i = 0; i < N; i++)
						{
							if ((N == 1)&&(pointList[0].history[0])) 
							{
								c_r = 0
								c_w = 0;
								c_h = 0;
								c_px = pointList[0].history[0].x;
								c_py = pointList[0].history[0].y;
							}
							else if (N > 1)
							{
								for (var j1:int = 0; j1 < N; j1++)
								{
									if ((i != j1)&&(pointList[i].history[0]) && (pointList[j1].history[0]))
										{
											//trace("dim",N);
											var dx:Number = pointList[i].history[0].x - pointList[j1].history[0].x
											var dy:Number = pointList[i].history[0].y - pointList[j1].history[0].y
											var ds:Number  = Math.sqrt(dx * dx + dy * dy);
											
											// diameter, radius of group
											if(ds>c_r){
												c_r = ds
											}
											// width of group
											var abs_dx:Number = Math.abs(dx);
											if(abs_dx>c_w){
												c_w = abs_dx;
												c_px = pointList[i].history[0].x -dx/2;
											}
											// height of group
											var abs_dy:Number = Math.abs(dy);
											if(abs_dy>c_h){
												c_h = abs_dy;
												c_py = pointList[i].history[0].y -dy/2
											} 
										}
								}
							}
							else {
							c_r = 0;
							c_w = 0;
							c_h = 0;
							c_px = 0;
							c_py = 0;	
							}
						}
		}
		
		private function findInstSeparation():void
		{
						c_sx = 0;
						c_sy = 0;
					
						for (i = 0; i < N; i++)
						{
							if ((N == 1)&&(pointList[0].history[0])) 
								{
									c_sx = 0
									c_sy = 0
								} 
							else if (N > 1)
							{
								for (var j1:int = 0; j1 < N; j1++)
								{
									if (i != j1)
									{
										if ((pointList[i].history[0]) && (pointList[j1].history[0])) 
										{
											var dx:Number = Math.abs(pointList[i].history[0].x - pointList[j1].history[0].x);
											var dy:Number = Math.abs(pointList[i].history[0].y - pointList[j1].history[0].y);
											//var ds:Number  = Math.sqrt(dx * dx + dy * dy);
											// separation of group
											//c_s += ds;
											c_sx += dx;
											c_sy += dy;
										}
									}
									//c_s *= k0;
									c_sx *= k0;
									c_sy *= k0;
								}
							}
							else {
								//c_s = 0;
								c_sx = 0;
								c_sy = 0;
							}
						}
		}
		
		private function findInstAngle():void
		{
						c_s = 0;
						
						if ((N == 1)&&(pointList[0].history[0])) c_theta = 0
							
						for (i = 0; i < N; i++)
						{
							
							if (N > 1)
							{
								for (var j1:int = 0; j1 < N; j1++)
								{
									if ((i != j1)&&(pointList[i].history[0]) && (pointList[j1].history[0])) 
										{
										//trace("dim",N);
										var dx:Number = pointList[i].history[0].x - pointList[j1].history[0].x
										var dy:Number = pointList[i].history[0].y - pointList[j1].history[0].y
										// rotation of group
										c_theta += (calcAngle(dx, dy)) || 0
									}
									c_theta *= k0;
								}
							}
							else c_theta = 0;
						}
		}
		
		private function findMeanInstTranslation():void
		{
					//////////////////////////////////////////////////////////////////////////////////////////////////////////////
					// cluster translation // OPERATION
					//////////////////////////////////////////////////////////////////////////////////////////////////////////////
					// translation values 
					// finds how far the cluster has moved between the current frame and a frame in history
					
						c_dx = 0;
						c_dy = 0;
						
						for (i = 0; i < N; i++) 
						{
							if (pointList[i].history[h])
							{
								for (j = 0; j < h; j++) 
								{
									// SIMPLIFIED DELTA
									c_dx += pointList[i].history[j].dx * h0;
									c_dy += pointList[i].history[j].dy * h0;
								}
							}
						}
						
						//////////// apply delta thresholds for change in x and y ////////////////////////////////////////////
						
						if (transThresholds) 
						{
							var deltax:Number = Math.abs(c_dx);
							var deltay:Number = Math.abs(c_dy);
							
							if ((deltax > x_threshold_min) && (deltax < x_threshold_max)) c_dx *= k0;
							else c_dx = 0;
							
							if ((deltay > y_threshold_min) && (deltay < y_threshold_max)) c_dy *= k0;
							else c_dy = 0
						}
						else {
							c_dx *= k0;
							c_dy *= k0;
						}
						////////////////////////////////////////////////////////////////////////////////////////////	
		}
		
		private function findMeanInstSeparation():void
		{
					//////////////////////////////////////////////////////////////////////////////////////////////////////////////
					// cluster separation //OPERATION
					//////////////////////////////////////////////////////////////////////////////////////////////////////////////
					// finds the change in the separation of the cluster between the current frame and a previous frame in history
						c_ds = 0;
						
						for (i = 0; i < N; i++) 
						{
							if ((N > i + 1)&&(N > 1))
							{
								if ((pointList[0].history[h]) && (pointList[i + 1].history[h]))
								{		
								// SIMPLIFIED DELTA 
								c_ds += (Math.sqrt((pointList[0].history[0].x - pointList[i + 1].history[0].x) * (pointList[0].history[0].x - pointList[i + 1].history[0].x) + (pointList[0].history[0].y - pointList[i + 1].history[0].y) * (pointList[0].history[0].y - pointList[i + 1].history[0].y)) - Math.sqrt((pointList[0].history[h].x - pointList[i + 1].history[h].x) * (pointList[0].history[h].x - pointList[i + 1].history[h].x) + (pointList[0].history[h].y - pointList[i + 1].history[h].y) * (pointList[0].history[h].y - pointList[i + 1].history[h].y)))*h0;
								}
							}
						}
						
						////////////////////// apply delta thresholds for change in separation /////////////////////////////////
						if (sepThresholds)
						{
							var deltas:Number = Math.abs(c_ds);
							
							if ((deltas > sep_threshold_min) && (deltas < sep_threshold_max)) c_ds *= k1;
							else c_ds = 0;
						}
						else {
							c_ds *= k1;
						}
						//trace("ds", c_ds);
						//////////////////////////////////////////////////////////////////////////////////////////////////////	
		}
		private function findMeanInstSeparationXY():void
		{
					//////////////////////////////////////////////////////////////////////////////////////////////////////////////
					// cluster separation //OPERATION
					//////////////////////////////////////////////////////////////////////////////////////////////////////////////
					// finds the change in the separation of the cluster between the current frame and a previous frame in history
					
						c_dsx = 0;
						c_dsy = 0;
							
						for (i = 0; i < N; i++) 
						{
							if ((N > i + 1)&&(N > 1))
							{
								if ((pointList[0].history[h]) && (pointList[i + 1].history[h]))
								{		
								// SIMPLIFIED DELTA 
								c_dsx += (pointList[0].history[0].x - pointList[i + 1].history[0].x) - (pointList[0].history[h].x - pointList[i + 1].history[h].x)*h0;
								c_dsy += (pointList[0].history[0].y - pointList[i + 1].history[0].y) - (pointList[0].history[h].y - pointList[i + 1].history[h].y)*h0;	
								}
							}
						}
						
						////////////////////// apply delta thresholds for change in separation in x and y direction /////////////////////////////////
						if (sepThresholds)
						{
							var deltasx:Number = Math.abs(c_dsx);
							var deltasy:Number = Math.abs(c_dsy);

							if ((deltasx > sepx_threshold_min) && (deltasx < sepx_threshold_max)) c_dsx *= k1;
							else c_dsx = 0;
							
							if ((deltasy > sepy_threshold_min) && (deltasy < sepy_threshold_max)) c_dsy *= k1;
							else c_dsy = 0;
						}
						else {
							c_dsx *= k1;
							c_dsy *= k1;
						}
						//////////////////////////////////////////////////////////////////////////////////////////////////////	
		}
		
		private function findMeanInstPosition():void
		{
			/////////////////////// mean center of cluster // OPERATION /////////////////////////////////////////
			c_emx = 0;
			c_emy = 0;
							
				for (i = 0; i < N; i++) 
				{
					if (pointList[i].history[0])
					{
						c_emx += pointList[i].history[0].x;
						c_emy += pointList[i].history[0].y;
					}
				}
					
				c_emx *= k0;
				c_emy *= k0;
		}
		
		//REDUNDANT TO MEAN TRANSLATION
		/*
		private function findClusterMeanInstVelocity():Point
		{
			/////////////////////// mean velocity of cluster // OPERATION /////////////////////////////////////////
			var c_em_vel:Point = new Point;
				c_em_vel.x = 0;
				c_em_vel.y = 0;
							
				for (i = 0; i < N; i++) 
				{
					if (pointList[i].history[0])
					{
						c_em_vel.x += pointList[i].history[0].dx;
						c_em_vel.y += pointList[i].history[0].dy;
					}
				}
					
				c_em_vel.x *= k0;
				c_em_vel.y *= k0;
				
			return c_em_vel;
		}
		*/
		private function findMeanTemporalVelocity(t:int):Point
		{
		/////////////////////// mean velocity of cluster // OPERATION /////////////////////////////////////////
					
			var c_etm_vel:Point = new Point();
				c_etm_vel.x = 0;
				c_etm_vel.y = 0;
							
			var t0:Number = 1 / t;
					
			for (i = 0; i < N; i++) 
				{
					if (pointList[i].history[t])
					{
					for (j = 0; j < t; j++) 
						{
						c_etm_vel.x += pointList[i].history[j].dx;
						c_etm_vel.y += pointList[i].history[j].dy;
						}
					}
			}
					
			c_etm_vel.x *= k0*t0;
			c_etm_vel.y *= k0*t0;
		
			return c_etm_vel;
		} 
		
		private function findMeanInstRotation():void
		{
					//////////////////////////////////////////////////////////////////////////////////////////////////////////////
					// cluster roation // OPERATION
					//////////////////////////////////////////////////////////////////////////////////////////////////////////////
					// finds the change in the rotation of the cluster between the current frame and a previous frame in history
					
						c_dtheta = 0;
						
						for (i = 0; i < N; i++) 
						{
							if ((N > i + 1)&&(N > 1))
							{
								if ((pointList[0].history[h]) && (pointList[i + 1].history[h]))
								{		
									// SIMPLIFIED DELTA 
									var dtheta:Number = 0;
									var theta0:Number = calcAngle((pointList[0].history[0].x - pointList[i+1].history[0].x), (pointList[0].history[0].y - pointList[i+1].history[0].y));
									var theta1:Number = calcAngle((pointList[0].history[h].x - pointList[i+1].history[h].x), (pointList[0].history[h].y - pointList[i+1].history[h].y));
									
									if ((theta0 != 0) && (theta1 != 0)) 
										{
										if (Math.abs(theta0 - theta1) > 180) dtheta = 0
										else dtheta = (theta0 - theta1);
										}
									else dtheta = 0;
											
									c_dtheta += dtheta * h0;
								}
							}
						}
						
						////////////// apply delta thresholds for change in rotation///////////////////////////
						if (rotThresholds)
						{
							var deltat:Number = Math.abs(c_dtheta);
									
							if ((deltat > theta_threshold_min) && (deltat < theta_threshold_max)) c_dtheta *= k1;
							else c_dtheta = 0;
						}
						else c_dtheta *= k1;
						////////////////////////////////////////////////////////////////////////////////////////
		}
		
		private function findMeanInstAcceleration():void
		{
					//////////////////////////////////////////////////////////////////////////////////////////////////////////////
					// cluster acceleration x y // OPERATION
					//////////////////////////////////////////////////////////////////////////////////////////////////////////////
					
						c_ddx = 0;
						c_ddy = 0;
						
						for (i = 0; i < N; i++) 
						{
							if (pointList[i].history[1])
							{
								// SIMPLIFIED DELTAS
								// second diff of x anf y wrt t
								c_ddx += pointList[i].history[0].dx - pointList[i].history[1].dx;
								c_ddy += pointList[i].history[0].dy - pointList[i].history[1].dy;
							}
						}
						
						/////////// Apply delta thresholds to accelerations ///////////////////////////////
						if (accelThresholds)
						{
							var adeltax:Number = Math.abs(c_ddx);
							var adeltay:Number = Math.abs(c_ddy);
							
							if((adeltax > ddx_threshold_min)&&(adeltax < ddx_threshold_max)) c_ddx *= k0;
							else c_ddx = 0;
							
							if((adeltay > ddy_threshold_min)&&(adeltay < ddy_threshold_max)) c_ddy *= k0;
							else c_ddy = 0;
						}
						else {
							c_ddx *= k0;
							c_ddy *= k0;
						}
						/////////////////////////////////////////////////////////////////////////////////////	
		}
		private function findMeanTemporalAcceleration(t:int):Point
		{
			//////////////////////////////////////////////////////////////////////////////////////////////////////////////
			// cluster acceleration x y // OPERATION
			//////////////////////////////////////////////////////////////////////////////////////////////////////////////
					
			var c_etm_accel:Point = new Point();
				c_etm_accel.x = 0;
				c_etm_accel.y = 0;
			var t0:Number = 1 / t;
						
				for (i = 0; i < N; i++) 
					{
					if (pointList[i].history[t])
						{
							// SIMPLIFIED DELTAS
							// second diff of x anf y wrt t
							for (j = 0; j < t; j++) 
							{
								c_etm_accel.x += pointList[i].history[j].dx - pointList[i].history[j+1].dx;
								c_etm_accel.y += pointList[i].history[j].dy - pointList[i].history[j+1].dy;
							}
						}
					}
						
					c_etm_accel.x *= k0 * t0;
					c_etm_accel.y *= k0 * t0;
						
				return c_etm_accel;
		}
		/////////////////////////////////////////////////////////////////////////////////////////
		// FINDS THE ANGLE BETWEEN TWO VECTORS 
		/////////////////////////////////////////////////////////////////////////////////////////
		
		private static function dotProduct(x0:Number, y0:Number,x1:Number, y1:Number):Number
			{	
				if ((x0!=0)&&(y0!=0)&&(x1!=0)&&(y1!=0)) return Math.acos((x0 * x1 + y0 * y1) / (Math.sqrt(x1 * x1 + y1 * y1) * Math.sqrt(x0 * x0 + y0 * y0)));
				else return 0;
		}	
			
		/////////////////////////////////////////////////////////////////////////////////////////
		// tan function with adjustments for angle wrapping
		/////////////////////////////////////////////////////////////////////////////////////////
		// NOTE NEED TO CLEAN LOGIC TO PREVENT ROTATIONS ABOVE 360 AND PREVENT ANY NEGATIVE ROTATIONS
		
		private static function calcAngle(adjacent:Number, opposite:Number):Number
			{
				if (adjacent == 0)return opposite < 0 ? 270 : 90 ;
				if (opposite == 0) return adjacent < 0 ? 180 : 0 ;
				
				if(opposite > 0)
					return adjacent > 0 ?
						360 + Math.atan(opposite / adjacent) * RAD_DEG :
						180 - Math.atan(opposite / -adjacent) * RAD_DEG ;
				else
					return adjacent > 0 ?
						360 - Math.atan( -opposite / adjacent) * RAD_DEG :
						180 + Math.atan( opposite / adjacent) * RAD_DEG ;
					
				return 0;
		}
	}
}