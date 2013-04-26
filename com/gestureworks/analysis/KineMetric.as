﻿////////////////////////////////////////////////////////////////////////////////
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
	import com.gestureworks.core.GestureGlobals;
	import com.gestureworks.core.gw_public;
	import com.gestureworks.objects.PointObject;
	import com.gestureworks.objects.MotionPointObject;
	import com.gestureworks.objects.ClusterObject;
	import com.gestureworks.objects.PointPairObject;
	import com.gestureworks.managers.PointPairHistories;
	
	import com.leapmotion.leap.Frame 
	import com.leapmotion.leap.Finger 
	import com.leapmotion.leap.Hand
	//import com.leapmotion.leap.util.LeapMath;
	import com.leapmotion.leap.Vector3;
	
	import flash.geom.Vector3D;
	import flash.geom.Utils3D;
	import flash.geom.Point;
		
	public class KineMetric
	{
		//////////////////////////////////////
		// ARITHMETIC CONSTANTS
		//////////////////////////////////////
		private static const RAD_DEG:Number = 180 / Math.PI;
		private static const DEG_RAD:Number = Math.PI / 180 ;
		
		private var touchObjectID:int;
		private var ts:Object;//private var ts:TouchSprite;
		private var cO:ClusterObject;
		
		public var pointList:Vector.<PointObject>; // should operate directly on cluster
		public var pointPairList:Vector.<PointPairObject>;// should operate directly on cluster
		
		// number in group
		private var N:uint = 0;
		public var LN:uint = 0; //locked touch points
		
		private var N1:uint = 0;
		private var k0:Number  = 0;
		private var k1:Number  = 0;
		private var i:uint = 0;
		private var j:uint = 0;
		private var mc:uint = 0;
		
		// separate base scale const
		private var sck:Number = 0.0044;
		//pivot base const
		private var pvk:Number = 0.00004;
		
		// motion point totals
		private var hn:uint = 0;
		private var fn:uint = 0;
		private var rhfn:uint = 0;
		private var lhfn:uint = 0;
		private var fn1:Number = 0;
		private var fk0:Number = 0;
		private var fk1:Number = 0;
		
		private var prob_array:Array = new Array();
		
		//////////////////////////////
		// derived interaction point totals
		private var ipn:uint = 0;
		
		public function KineMetric(_id:int) 
		{
			touchObjectID = _id;
			init();
		}
		
		public function init():void
		{
			ts = GestureGlobals.gw_public::touchObjects[touchObjectID]; // need to find center of object for orientation and pivot
			cO = ts.cO;
		
			if (ts.trace_debug_mode) trace("init cluster kinemetric");
		}
		
		public function findClusterConstants():void
		{
				//if (ts.trace_debug_mode) trace("find cluster..............................",N);
				
				///////////////////////////////////////////////
				// get number of touch points in cluster
				N = ts.cO.n;
				LN = ts.cO.hold_n // will need to move to interaction point structure
				
				// derived point totals
				if (N) 
				{
					N1 = N - 1;
					k0 = 1 / N;
					k1 = 1 / N1;
					if (N == 0) k1 = 0;
					pointList = cO.pointArray; // copy most recent point array data
					mc = pointList[0].moveCount; // get sample move count value
					
					//trace("move count:",mc);
					
					//for (i = 0; i < cO.pointPairArray.length; i++) 
					//{
						//PointPairHistories.historyQueue(cO.pointPairArray[i]);
						//trace(cO.pointPairArray[i].idA,cO.pointPairArray[i].idB)
					//}
				}
				
				/////////////////////////////////////////
				// get motion points in frame
				hn = ts.cO.hn
				fn = ts.cO.fn
				rhfn = ts.cO.rhfn
				lhfn = ts.cO.lhfn
				
				
				
				// gest derived motion point totals
				if (fn)
				{
					fn1 = fn - 1;
					fk0 = 1 / fn;
					fk1 = 1 / fn1;
					if (fn == 0) fk1 = 0;
					//motionList = cO.motionArray;
					//mc = pointList[0].moveCount;
				}
				
				/////////////////////////////////////////
				// get derived interaction points in cluster
				ipn = ts.cO.ipn;
				
				if (ipn) {
					// do somethinng
				}
				
				
		}
		
		public function resetCluster():void {

			cO.x = 0;
			cO.y = 0;
			cO.z = 0;//-3D
			cO.width = 0;
			cO.height = 0;
			cO.length = 0;//-3D
			cO.radius = 0;
			
			//cO.separation
			cO.separationX = 0;
			cO.separationY = 0;
			cO.separationZ = 0;//-3D
			
			cO.rotation = 0;
			cO.rotationX = 0;//-3D
			cO.rotationY = 0;//-3D
			cO.rotationZ = 0;//-3D
			
			cO.orientation =  0;
			cO.thumbID = 0;
			//cO.hand_normal = 0;
			//cO.hand_radius = 0;
			
			cO.mx = 0;
			cO.my = 0;
			cO.mz = 0;//-
			
			//////////////////////////////////
			////////////////////////////////////
			cO.orient_dx = 0;
			cO.orient_dy = 0;
			//cO.orient_dz = 0;//-3D
			cO.pivot_dtheta = 0;
		
			/////////////////////////
			// first diff
			/////////////////////////
			cO.dtheta = 0;
			cO.dthetaX = 0;
			cO.dthetaY = 0;
			cO.dthetaZ = 0;
			cO.dtheta = 0;
			cO.dx = 0;
			cO.dy = 0;
			cO.dz = 0;//-3D
			cO.ds = 0;
			cO.dsx = 0;
			cO.dsy = 0;
			cO.dsz = 0;//-
			cO.etm_dx = 0;
			cO.etm_dy = 0;
			cO.etm_dz = 0;//-3D
			
			////////////////////////
			// second diff
			////////////////////////
			cO.ddx = 0;
			cO.ddy = 0;
			cO.ddz = 0;//-
			
			cO.etm_ddx = 0;
			cO.etm_ddy = 0;
			cO.etm_ddz = 0;//-3D
			
			////////////////////////////
			// sub cluster analysis
			// NEED TO MOVE INTO IPOINTARRAY
			////////////////////////////
			cO.hold_x = 0;
			cO.hold_y = 0;
			cO.hold_z = 0;//-3D
			cO.hold_n = 0;
			
			//accelerometer
			//SENSOR
			//cO.ax =0
			//cO.ay =0
			//cO.az =0
			//cO.atheta =0
			//cO.dax =0
			//cO.day =0
			//cO.daz =0
			//cO.datheta =0
			
			//////////////////////////////////////
			// SUBCLUSTER STRUCTURE
			// CAN BE USED FOR BI-MANUAL GESTURES
			// CAN BE USED FOR CONCURRENT GESTURE PAIRS
			/////////////////////////////////////
			//clear interactive point list
			cO.iPointArray = new Vector.<Object>();
			
			prob_array = new Array();
		}
		
		////////////////////////////////////////////////////////////
		// Methods: Private
		////////////////////////////////////////////////////////////
		
		public function findInstDimention():void
		{
			///////////////////////////////////////////////////////////////////////////////////////////////////////////
			// cluster width, height and radius // OPERATION
			///////////////////////////////////////////////////////////////////////////////////////////////////////////
			// basic cluster property values 
			// uses the current position of the points in the cluster to find the spread of the cluster and its current dims
					/*
					c_px = 0; 
					c_py = 0;
					c_r = 0;
					c_w = 0;
					c_h = 0;
					
					c_sx = 0;
					c_sy = 0;
					c_theta = 0;
					c_emx = 0;
					c_emy = 0;
					*/
					
					cO.x = 0; 
					cO.y = 0;
					cO.radius = 0;
					cO.width = 0;
					cO.height = 0;
					
					cO.separationX = 0;
					cO.separationY = 0;
					cO.rotation = 0;
					cO.mx = 0;
					cO.my = 0;
					
					
					
					if ((N == 1)&& (pointList.length && pointList[0].history.length && pointList[0].history[0])) 
					{
						/*
						c_px = pointList[0].history[0].x;
						c_py = pointList[0].history[0].y;
						c_emx = pointList[0].history[0].x;
						c_emy = pointList[0].history[0].y;
						*/
						cO.x = pointList[0].history[0].x;
						cO.y = pointList[0].history[0].y;
						cO.mx = pointList[0].history[0].x;
						cO.my = pointList[0].history[0].y;
					}
					
					else if (N > 1)
						{	
						for (i = 1; i < N; i++)
						{
							for (var j1:uint = 0; j1 < N; j1++)
							{
								if ((i != j1)&& pointList.length && (pointList[i].history.length) && (pointList[i].history[0]) && (pointList[j1].history.length && pointList[j1].history[0]))//&&(!pointList[i].holdLock)&&(!pointList[j1].holdLock))//edit
									{
										//trace("dim",N);
										var dx:Number = pointList[i].history[0].x - pointList[j1].history[0].x
										var dy:Number = pointList[i].history[0].y - pointList[j1].history[0].y
										var ds:Number  = Math.sqrt(dx * dx + dy * dy);
											
										// diameter, radius of group
										if(ds>cO.radius){
											//c_r = ds
											cO.radius = ds *0.5;
										}
										// width of group
										var abs_dx:Number = Math.abs(dx);
										if(abs_dx>cO.width){
											//c_w = abs_dx;
											//c_px = pointList[i].history[0].x -dx / 2;
											cO.width = abs_dx;
											cO.x = pointList[i].history[0].x -(dx*0.5);
										}
										// height of group
										var abs_dy:Number = Math.abs(dy);
										if(abs_dy>cO.height){
											//c_h = abs_dy;
											//c_py = pointList[i].history[0].y -dy / 2
											cO.height = abs_dy;
											cO.y = pointList[i].history[0].y -(dy* 0.5);
										} 
										
										// mean point position
										//c_emx += pointList[i].history[0].x;
										//c_emy += pointList[i].history[0].y;
										cO.mx += pointList[i].history[0].x;
										cO.my += pointList[i].history[0].y;
									}
							}
							
							
							// inst separation and rotation
							if ( (pointList[i].history.length) && (pointList[0].history.length && pointList[0].history[0]) && (pointList[i].history[0]))//&&(!pointList[i].holdLock)&&(!pointList[j1].holdLock)) //edit
							{
								var dxs:Number = pointList[0].history[0].x - pointList[i].history[0].x;
								var dys:Number = pointList[0].history[0].y - pointList[i].history[0].y;
								//var ds:Number  = Math.sqrt(dx * dx + dy * dy);

								// separation of group
								//c_s += ds;
								//c_sx += Math.abs(dxs);
								//c_sy += Math.abs(dys);
								cO.separationX += Math.abs(dxs);
								cO.separationY += Math.abs(dys);
								
								// rotation of group
								//c_theta += (calcAngle(dxs, dys)) || 0
								cO.rotation += (calcAngle(dxs, dys)) || 0
							}
						}
						/*
						//c_s *= k0;
						c_sx *= k0;
						c_sy *= k0;
						c_theta *= k0;
						c_emx *= k0;
						c_emy *= k0;
						*/
						cO.separationX *= k0;
						cO.separationY *= k0;
						cO.rotation *= k0;
						cO.mx *= k0;
						cO.my *= k0;
					}
		}
		
		public function findLockedPoints(hold_dist:Number, hold_time:Number, hold_number:Number):void
		{
			
				///////////////////////////////
				// check for locked points
				///////////////////////////////
							for (i = 0; i < N; i++)
								{
								//trace("hold count",i,pointList[i].holdCount, hold_time,hold_dist,hold_number);
								if ((Math.abs(pointList[i].dx) < hold_dist) && (Math.abs(pointList[i].dy) < hold_dist))
									{
									if (pointList[i].holdCount < hold_time) {
									
										pointList[i].holdCount++;
															
										if (pointList[i].holdCount >= hold_time) 
											{
											pointList[i].holdLock = true; 
											cO.hold_x += pointList[i].history[0].x;
											cO.hold_y += pointList[i].history[0].y;
											}	
										}
										else {
											pointList[i].holdCount = 0; // reset count
											pointList[i].holdLock = false; // add this feature here
											}
									}
								}
								
					///////////////////////
					// count locked points
					//////////////////////
						LN = 0;
						for (i = 0; i < N; i++)
						{
							if (pointList[i].holdLock) LN++;
						}
					//trace("LOCKED",LN)
					//////////////////////			
								

						if (LN) {
						if (((LN == hold_number)) || (hold_number == 0)) 
							{
							cO.hold_x *= 1/LN//k0;
							cO.hold_y *= 1/LN//k0;
							}
						}
						else {
							cO.hold_x = 0;
							cO.hold_y = 0;
						}
						//trace("cluster",hold_x,hold_y,LN,N)
		}
		
		public function findMeanInstTransformation():void
		{
		//////////////////////////////////////////////////////////////////////////////////////////////////////////////
		// cluster tranformation // OPERATION
		//////////////////////////////////////////////////////////////////////////////////////////////////////////////
			if (N == 1) 
			{
				// DO NOT SET OTHER DELTAS TO ZERO IN OPERATOR
				cO.dx = cO.pointArray[0].DX;
				cO.dy = cO.pointArray[0].DY;
				//trace("cluster- porcessing", c_dx,c_dy);
			}
				else if (N > 1)
							{
							//cO.ds = 0;	
							//cO.dsx = 0;	
							//cO.dsy = 0;	
							
							var sx:Number = 0;
							var sy:Number = 0;
							var sx_mc:Number = 0;
							var sy_mc:Number = 0;
						//	var ds:Number = 0;
								
								for (i = 0; i < N; i++) 
								{	
									/////////////////////////////////////////////
									// translate
									//c_dx += pointList[i].DX;
									//c_dy += pointList[i].DY;
									
									cO.dx += cO.pointArray[i].DX;
									cO.dy += cO.pointArray[i].DY;

									if ((N > i + 1) && (cO.pointArray[0].history.length > mc) && (cO.pointArray[i + 1].history.length > mc))
										{
										////////////////////////////////////////
										// scale 
										sx += cO.pointArray[0].history[0].x - cO.pointArray[i + 1].history[0].x;
										sy += cO.pointArray[0].history[0].y - cO.pointArray[i + 1].history[0].y;
										sx_mc += cO.pointArray[0].history[mc].x - cO.pointArray[i + 1].history[mc].x;// could eliminate in point pair
										sy_mc += cO.pointArray[0].history[mc].y - cO.pointArray[i + 1].history[mc].y;// could eliminate in point pair
										
										//////////////////
										// point pair method
										///////////////
										//trace(cO.pointPairArray.length)
										// cannot assume point pair order need better point ref in pair list
										// relative positon in point array or direct point ref by ID
										// if use point list index it may get out of sync
										// if use touch point id it may slow ref process
										/*
										if (cO.pointPairArray.length != 0) {
											cO.pointPairArray[i].dsx = pointList[0].history[0].x - pointList[i + 1].history[0].x;
											cO.pointPairArray[i].dsy = pointList[0].history[0].y - pointList[i + 1].history[0].y;
											//cO.pointPairArray[i].ds = Math.sqrt(cO.pointPairArray[i].dsx * cO.pointPairArray[i].dsx  + cO.pointPairArray[i].dsy * cO.pointPairArray[i].dsy);
											
											cO.dsx += cO.pointPairArray[i].dsx
											cO.dsy += cO.pointPairArray[i].dsy
											}
										*/
										////////////////////////////////////////////
										// rotate
										var dtheta:Number = 0;
										var theta0:Number = calcAngle(sx, sy);
										var theta1:Number = calcAngle(sx_mc, sy_mc); // could eliminate in point pair
										
										/*
											 * NO NEGATIVE DTHETA
											var v1:Vector3D = new Vector3D(sx, sy, 0);
											var v2:Vector3D = new Vector3D(sx_mc, sy_mc, 0);
											
											dtheta = Vector3D.angleBetween(v1,v2)*RAD_DEG;
											if (isNaN(dtheta)) dtheta = 0;
										*/
										
										//var theta0:Number = calcAngle(pointPairList[i].sx, pointPairList[i].sy);
										//var theta1:Number = calcAngle(pointPairList[i].history[h].sx, pointPairList[i].history[h].sy); // could eliminate in point pair
										
										
										if ((theta0 != 0) && (theta1 != 0)) 
											{
											if (Math.abs(theta0 - theta1) > 180) dtheta = 0
											else dtheta = (theta0 - theta1);
											}
										else dtheta = 0;
										
										
										//c_dtheta += dtheta;
										cO.dtheta += dtheta;
										////////////////////////////////////////////
									
										}	
								}
								
								// FIND C_DSX AND C_DSY AGGREGATE THEN AS A LAST STEP FIND THE SQUARE OF THE DISTANCE BETWEEN TO GET C_DS
								//c_ds = Math.sqrt(c_dsx*c_dsx + c_dsy*c_dsy)
								
								cO.dx *= k0;
								cO.dy *= k0;
								cO.ds = (Math.sqrt(sx * sx  +  sy * sy) - Math.sqrt(sx_mc * sx_mc  + sy_mc * sy_mc)) * k1 * sck;
								/*
								if ((cO.history.length != 0)&&(cO.history[1])) {
									//trace("hello");
									// jumpy
									cO.ds = (Math.sqrt(cO.dsx * cO.dsx  +  cO.dsy * cO.dsy) - Math.sqrt(cO.history[1].dsx * cO.history[1].dsx  + cO.history[1].dsy * cO.history[1].dsy)) * k1 * sck;
								}*/
								//cO.ds = ds*k1*sck;
								//c_dsx *= k1;
								//c_dsy *= k1;
								cO.dtheta *= k1;
								
				}
		//trace("transfromation",c_dx,c_dy, c_ds,c_dtheta)
		}
		
		// NEED TO REMOVE HO AND HISTORY COMPONENET
		// NEED TO MAKE STANDARD AND ALWAYS ON
		public function findMeanInstTranslation():void
		{
					//////////////////////////////////////////////////////////////////////////////////////////////////////////////
					// cluster translation // OPERATION
					//////////////////////////////////////////////////////////////////////////////////////////////////////////////
					// translation values 
					// finds how far the cluster has moved between the current frame and a frame in history
						cO.dx = 0;
						cO.dy = 0;
					
					if (N == 1) 
						{
							cO.dx = pointList[0].DX;
							cO.dy = pointList[0].DY;
						}
					else if (N > 1)
					{
						for (i = 0; i < N; i++) 
						{
								if (pointList[i])//&&(!pointList[i].holdLock))// edit
								{
									// SIMPLIFIED DELTa
									cO.dx += pointList[i].DX;
									cO.dy += pointList[i].DY;
								}	
						}
						cO.dx *= k0;
						cO.dy *= k0;
					}
					//	trace("drag calc kine",c_dx,c_dy);
		}
		
		public function findMeanInstSeparation():void
		{
			
					//////////////////////////////////////////////////////////////////////////////////////////////////////////////
					// cluster separation //OPERATION
					//////////////////////////////////////////////////////////////////////////////////////////////////////////////
					// finds the change in the separation of the cluster between the current frame and a previous frame in history
					cO.ds = 0;
					cO.dsx = 0;
					cO.dsy = 0;
					
					if (N > 1)
					{	
						var sx:Number = 0;
						var sy:Number = 0;
						var sx_mc:Number = 0;
						var sy_mc:Number = 0;
						
						for (i = 0; i < N; i++) 
						{
							//if ((N > i + 1) && (pointList[0].history[mc]) && (pointList[i + 1].history[mc]))
							if ((N>i+1)&&(pointList[0].history.length>mc) && (pointList[i + 1].history.length>mc))
							{		
								sx = Math.abs(pointList[0].history[0].x - pointList[i + 1].history[0].x);
								sy = Math.abs(pointList[0].history[0].y - pointList[i + 1].history[0].y);
								sx_mc = Math.abs(pointList[0].history[mc].x - pointList[i + 1].history[mc].x);
								sy_mc = Math.abs(pointList[0].history[mc].y - pointList[i + 1].history[mc].y);
								
								//c_ds += (Math.sqrt((pointList[0].history[0].x - pointList[i + 1].history[0].x) * (pointList[0].history[0].x - pointList[i + 1].history[0].x) + (pointList[0].history[0].y - pointList[i + 1].history[0].y) * (pointList[0].history[0].y - pointList[i + 1].history[0].y)) - Math.sqrt((pointList[0].history[mc].x - pointList[i + 1].history[mc].x) * (pointList[0].history[mc].x - pointList[i + 1].history[mc].x) + (pointList[0].history[mc].y - pointList[i + 1].history[mc].y) * (pointList[0].history[mc].y - pointList[i + 1].history[mc].y)))
								cO.ds += (Math.sqrt(sx * sx + sy * sy) - Math.sqrt(sx_mc * sx_mc + sy_mc * sy_mc));
								cO.dsx += (sx - sx_mc)//Math.sqrt(sx * sx - sx_mc * sx_mc);
								cO.dsy += (sy - sy_mc)//Math.sqrt(sy * sy - sy_mc * sy_mc);
							}
						}
					
					//c_dsx = (sx - sx_mc)*k1;
					//c_dsy = (sy - sy_mc)*k1;	
						
					//c_ds *= k1;	
					cO.ds *= k1 * sck;//(Math.sqrt(sx * sx + sy * sy) - Math.sqrt(sx_mc * sx_mc + sy_mc * sy_mc))*k1 * sck;
					cO.dsx *= k1 * sck; //(sx - sx_mc)*k1 * sck;//(Math.sqrt((sx * sx) - (sx_mc * sx_mc)))*k1 * sck;//cO.ds;
					cO.dsy *= k1 * sck; //(sy - sy_mc)*k1 * sck;//(Math.sqrt((sy * sy) - (sy_mc * sy_mc)))*k1 * sck;//cO.ds;
					//trace("mean inst separation");
					}
					
					
		}	
		
		public function findMeanInstRotation():void
		{
					//////////////////////////////////////////////////////////////////////////////////////////////////////////////
					// cluster roation // OPERATION
					//////////////////////////////////////////////////////////////////////////////////////////////////////////////
					// finds the change in the rotation of the cluster between the current frame and a previous frame in history

						cO.dtheta = 0;
						
						if(N>1)
						{
						for (i = 0; i < N; i++) 
						{
								if ((N > i + 1)&&(pointList.length>i)&&(pointList[0].history.length>mc) && (pointList[i + 1].history.length>mc))
								{		
									// SIMPLIFIED DELTA 
									var dtheta:Number = 0;
									var theta0:Number = calcAngle((pointList[0].history[0].x - pointList[i+1].history[0].x), (pointList[0].history[0].y - pointList[i+1].history[0].y));
									//var theta1:Number = calcAngle((pointList[0].history[h].x - pointList[i + 1].history[h].x), (pointList[0].history[h].y - pointList[i + 1].history[h].y));
									var theta1:Number = calcAngle((pointList[0].history[mc].x - pointList[i+1].history[mc].x), (pointList[0].history[mc].y - pointList[i+1].history[mc].y));
									
									if ((theta0 != 0) && (theta1 != 0)) 
										{
										if (Math.abs(theta0 - theta1) > 180) dtheta = 0
										else dtheta = (theta0 - theta1);
										}
									else dtheta = 0;

									cO.dtheta += dtheta;
								}
						}
						cO.dtheta *= k1;
						}
						//trace(cO.dtheta);
		}
		
		public function findMeanInstAcceleration():void
		{
					//////////////////////////////////////////////////////////////////////////////////////////////////////////////
					// cluster acceleration x y // OPERATION
					//////////////////////////////////////////////////////////////////////////////////////////////////////////////

						cO.ddx = 0;
						cO.ddy = 0;
						
						for (i = 0; i < N; i++) 
						{
							if (pointList[i].history[1])//&&(!pointList[i].holdLock))//edit
							{
								// SIMPLIFIED DELTAS
								// second diff of x anf y wrt t
								cO.ddx += pointList[i].history[0].dx - pointList[i].history[1].dx;
								cO.ddy += pointList[i].history[0].dy - pointList[i].history[1].dy;
							}
						}
						cO.ddx *= k0;
						cO.ddy *= k0;
					
					/////////////////////////////////////////////////////////////////////////////////////	
		}
		
		public function findMeanTemporalVelocity():void
		{
		/////////////////////// mean velocity of cluster // OPERATION ////////////////////////////////////////
			cO.etm_dx = 0;
			cO.etm_dy = 0;
			
			var t:Number = 2;
			var t0:Number = 1 /t;
					
			for (i = 0; i < N; i++) 
				{
					if(pointList[i].history.length>t)
					{
					for (j = 0; j < t; j++) 
						{
						cO.etm_dx += pointList[i].history[j].dx;
						cO.etm_dy += pointList[i].history[j].dy;
						}
					}
			}
			//cO.etm_dx *= k0 * t0;
			//cO.etm_dy *= k0 * t0;

		} 
		
		public function findMeanTemporalAcceleration():void
		{
			//////////////////////////////////////////////////////////////////////////////////////////////////////////////
			// cluster acceleration x y // OPERATION
			//////////////////////////////////////////////////////////////////////////////////////////////////////////////
			cO.etm_ddx = 0;
			cO.etm_ddy = 0;
			
			
				
			var t:Number = 2;
			var t0:Number = 1 /t;
						
				for (i = 0; i < N; i++) 
					{
					if(pointList[i].history.length>t)
						{
							// SIMPLIFIED DELTAS
							// second diff of x anf y wrt t
							for (j = 0; j < t; j++) 
							{
								cO.etm_ddx += pointList[i].history[j+1].dx- pointList[i].history[j].dx;
								cO.etm_ddy += pointList[i].history[j + 1].dy -pointList[i].history[j].dy ;
								//cO.etm_ddx += pointList[i].history[0].dx - pointList[i].history[1].dx;
								//cO.etm_ddy += pointList[i].history[0].dy - pointList[i].history[1].dy;
							}
						}
					}
					trace(k0, t0);
			//cO.etm_ddx *= k0 * t0;
			//cO.etm_ddy *= k0 * t0;
		}
		
		public function findInstOrientation():void 
		{
				var handArray:Array = new Array();
				var maxDist:Number = 0;
				var maxAngle:Number = 0;
				var dist:Number = 0;
				var angle:Number = 180;
				
				cO.orient_dx = 0;
				cO.orient_dy = 0;	
						
							for (i = 0; i < N; i++) 
								{
									if (pointList[i].history[0])
									//if(pointList.length>i)
									{
										handArray[i] = new Array();
										handArray[i].id = pointList[i].id; // set point id
									
										// find distance between center of cluster and finger tip
										var dxe:Number = (pointList[i].history[0].x - cO.x);
										var dye:Number = (pointList[i].history[0].y - cO.y);
										
										// find diatance between mean center of cluster and finger tip
										var dxf:Number = (pointList[i].history[0].x - cO.mx);
										var dyf:Number = (pointList[i].history[0].y - cO.my);
										var ds1:Number = Math.sqrt(dxf * dxf + dyf * dyf)
										
										handArray[i].dist = ds1; // set distance from mean
										handArray[i].angle = 180; // init angle between vectors to radial center

										for (var q:int = 0; q < N; q++) 
										{
											if ((i != q)&&(pointList[q].history[0]))
												{
												var dxq:Number = (pointList[q].history[0].x - cO.x);
												var dyq:Number = (pointList[q].history[0].y - cO.y);
												angle = dotProduct(dxe, dye, dxq, dyq)*RAD_DEG;
												
												if (angle < handArray[i].angle) handArray[i].angle = angle;
												}
										}
									//trace("finger", handArray[i].id, handArray[i].dist, handArray[i].angle) // point list
									
									// find max angle
									if (maxAngle < handArray[i].angle) 		maxAngle = handArray[i].angle;
									// find min dist
									if (maxDist < handArray[i].dist) 	maxDist = handArray[i].dist;
								}
							}
							
							
							// calculate thumb probaility value
							for (i = 0; i < N; i++) 
								{
									handArray[i].prob = (handArray[i].angle/maxAngle + handArray[i].dist/maxDist)*0.5
								}
							handArray.sortOn("prob",Array.DESCENDING);
							cO.thumbID = handArray[0].id;
							
							
						
							// calc orientation vector // FIND ORIENTATION USING CLUSTER RADIAL CENTER
							for (i = 0; i < N; i++) 
								{
									if (pointList[i].id != handArray[0].id) 
									{	
										cO.orient_dx += (pointList[i].history[0].x - cO.x);
										cO.orient_dy += (pointList[i].history[0].y - cO.y);
									}
								}
							cO.orient_dx *= k1;
							cO.orient_dy *= k1;	
						
		}
		
		public function findInstPivot():void
		{	
					if(N==1)
					{
						var x_c:Number = 0
						var y_c:Number = 0
			
							cO.pivot_dtheta = 0
					
			
								if (ts.trO.transAffinePoints) 
								{
									//trace("test", tO.transAffinePoints[4])
									x_c = ts.trO.transAffinePoints[4].x
									y_c = ts.trO.transAffinePoints[4].y
								}
					
								//if ((pointList[0].history[0]) && (pointList[0].history[1])) 
								if (pointList[0].history.length>1) 
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
									//if (Math.abs(theta_diff) > pivot_threshold)
									//{	
										// weighted effect
										cO.pivot_dtheta = theta_diff*Math.pow(pdist, 2)*pvk;
										cO.x = pointList[0].history[0].x;
										cO.y = pointList[0].history[0].y;
									//}
									//else cO.pivot_dtheta = 0; 
								}
						}
		} 
		
		
		///////////////////////////////////////////////////////////////////////////////////
		///////////////////////////////////////////////////////////////////////////////////
		///////////////////////////////////////////////////////////////////////////////////
		// sensor analysis
		///////////////////////////////////////////////////////////////////////////////////
		///////////////////////////////////////////////////////////////////////////////////
		///////////////////////////////////////////////////////////////////////////////////
		
		public function findSensorJolt():void
		{
			trace("accelerometer kinemetric");
			
			var snr:Vector.<Number> = cO.sensorArray;
			
			trace("timestamp", snr[0]);
			/*	
            trace("ax", event.accelerationX);
            trace("ay", event.accelerationY);
			trace("az", event.accelerationZ);
			trace("timestamp", event.timestamp);
			*/
		}
		
		///////////////////////////////////////////////////////////////////////////////////
		///////////////////////////////////////////////////////////////////////////////////
		///////////////////////////////////////////////////////////////////////////////////
		// 3d motion analysis
		///////////////////////////////////////////////////////////////////////////////////
		///////////////////////////////////////////////////////////////////////////////////
		///////////////////////////////////////////////////////////////////////////////////
		public function find3DPointPairList():void
		{
		// SIMPLE PAIR LIST FOR DRAWING
						
						cO.pairList = new Array();
						
						//if (fn > 3)
						//{
							for (var i:int = 0; i < fn; i++)
									{
									if (cO.motionArray[i].type == "finger")
									{
										var palm_mpoint:MotionPointObject = GestureGlobals.gw_public::motionPoints[cO.motionArray[i].handID];
											// find all pairs
											for (var q:int = 0; q < fn; q++) //20
											//for (var q:int = 0; q < i+1; q++) //10
												{
													if ((i != q) && (cO.motionArray[q].type == "finger"))
													//if (cO.motionArray[q].type == "finger")
													{
														//find angle dist for each pair	
														var dq:Vector3D  = cO.motionArray[q].position.subtract(palm_mpoint.position);
														var di:Vector3D  = cO.motionArray[i].position.subtract(palm_mpoint.position);
														
														//trace(i,q);
														var data:Array = new Array();
															data.pointA = GestureGlobals.gw_public::motionPoints[cO.motionArray[i].motionPointID];
															data.pointB = GestureGlobals.gw_public::motionPoints[cO.motionArray[q].motionPointID];
															data.distance =  Vector3D.distance(cO.motionArray[i].position, cO.motionArray[q].position);  
															data.dAngle = Vector3D.angleBetween(cO.motionArray[i].direction, cO.motionArray[q].direction);
															data.pAngle =  Vector3D.angleBetween(di, dq);
															data.length = data.pointA.length;
															data.width = data.pointA.width;
															data.p = data.distance + data.dAngle + data.pAngle + data.length;
														
														cO.pairList.push(data);
														
														//trace("push data",i,q);
														//trace("width",data.width)
													}
													
													
												}
						
									}
							}
						//}
						
						// SORT SERIALIZED PAIR LIST
						//cO.pairList.sortOn("distance", Array.DESCENDING);
						//cO.pairList.sortOn("dAngle", Array.DESCENDING); // great indicator of thumb!!
						//cO.pairList.sortOn("pAngle", Array.DESCENDING); ///good indeicator of thumb
						//cO.pairList.reverse();
						
						cO.pairList.sortOn("p", Array.DESCENDING);
			
						//trace("pair list n", cO.pairList.length);
						
						// POINT SORTED PIARS HAVE LARGEST DIST AND ANGLE 3 OUT OF 5 TIMES PAIR WITH THUMB
						// ADD UP PROB VALUES FROM EACH THUMB PAIR
						// CUMULATIVE PROB PUSHES THUMB PROB UP ABOVE 95%
						
						if (cO.motionArray.length < cO.pairList.length)
						{
							// hack 
							// GET FIRST FOUR PAIRS 
							// SEE DEBUGER
							for (var pn:int = 0; pn < cO.motionArray.length-2; pn++)//4 //6
							{
								//trace("hack");
								cO.pairList[pn].pointA.thumb_prob += cO.pairList[pn].p;
								cO.pairList[pn].pointB.thumb_prob += cO.pairList[pn].p;
							}
						}
						
						/*
						// find temporal average thumb prob
						for (var pn:int = 0; pn < cO.motionArray.length; pn++)
						{
							trace("---",cO.motionArray[pn].history.length);
							for (var h:int = 0; h < cO.motionArray[pn].history.length; h++)
							{
								//cO.motionArray[pn].mean_thumb_prob += cO.motionArray[pn].history[h].thumb_prob
							}
							//cO.motionArray[pn].mean_thumb_prob / cO.motionArray[pn].history.length;
							//trace("mtp",cO.motionArray[pn].mean_thumb_prob)
						}
						*/
						
						// get largest thumb prob
						var thumb_list:Array = new Array()
						
						for (var pn:int = 0; pn < cO.motionArray.length; pn++)
						{
							thumb_list[pn] = cO.motionArray[pn].thumb_prob
							//thumb_list[pn] = cO.motionArray[pn].mean_thumb_prob
							 
							 // reset thum alloc
							 if(cO.motionArray[pn].type != "palm") cO.motionArray[pn].fingertype = "finger";
						}
						
						// SET FINGER TO THUMB
						var max_tp:Number = Math.max.apply(null, thumb_list);
						//var max_tp:Number = Math.max.apply(null, cO.motionArray.thumb_prob);
						
						var max_index:int = thumb_list.indexOf(max_tp);
						
						if(( cO.motionArray[max_index])&&(cO.motionArray[max_index].type == "finger")) cO.motionArray[max_index].fingertype = "thumb";
						
				//trace("find thumb")
		}
		
		public function normalizeFingerSize():void {
			
			var temp_length_array:Array = new Array();
			var temp_width_array:Array = new Array();
			var min_length:Number
			var max_length:Number
			var min_width:Number
			var max_width:Number
			
			
			
			// get values
			for (i = 0; i < fn; i++)
				{	
					if (cO.motionArray[i].type == "finger")
					{				
						temp_length_array.push(cO.motionArray[i]);
						//emp_width_array.push(cO.motionArray[i]);					
						//trace("width",cO.motionArray[i].width)
					}
				}
			
			var  tn:int = temp_length_array.length;
			temp_width_array = temp_length_array;
				
			
			trace("fingers", fn, tn)
			
			// get normalized length
				
				//sort
				temp_length_array.sortOn("length", Array.DESCENDING);
				//temp_width_array.sortOn("width", Array.DESCENDING)
						
				// get max and min
				if (temp_length_array[tn - 1]) 	min_length = temp_length_array[tn - 1].length;	
				if (temp_length_array[0]) 		max_length = temp_length_array[0].length;
				
				//if (temp_width_array[tn - 1]) min_width = temp_length_array[tn - 1].width;	
				//if (temp_width_array[0]) max_width = temp_length_array[0].width;
						
						for (i = 0; i < tn; i++)
							{
						if (temp_length_array[i].type == "finger")
								{	
									var pt:MotionPointObject = GestureGlobals.gw_public::motionPoints[temp_length_array[i].motionPointID];
									
									pt.normalized_length = normalize(temp_length_array[i].length, min_length, max_length);
									//cO.motionArray[i].normalized_length = normalize(temp_length_array[i].length, max_length, min_length);
									
									trace("norm length",cO.motionArray[i].motionPointID, max_length, min_length,cO.motionArray[i].length,cO.motionArray[i].normalized_length)
								}
							}
			
		}
		
		
		public function find3DBestPointPairs():void
		{
			var ma = cO.motionArray;
			var pair_table:Array = new Array();
			
			
			
			// CALC PAIR VALUES FOR UNIQUE POINT PAIRS
			// COPY FROM ONE SIDE OF MATRIX TO THE OTHER TO HALVE CALCS
			//trace("---------------");
						for (i = 0; i < fn; i++)
									{
									//trace("-" );
									if (cO.motionArray[i].type == "finger")
									{

									// reset thumb probs
									cO.motionArray[i].thumb_prob = 0;
									cO.motionArray[i].mean_thumb_prob = 0
									
									//var pair_array:Array = new Array();
									var palm_mpoint:MotionPointObject = GestureGlobals.gw_public::motionPoints[cO.motionArray[i].handID];
									var pair_array:Array = new Array();

											// find all 20 //unique pairs (10 for 5 points) 
											for (var q:int = 0; q < fn; q++) //i+1
												{
													if ((i != q) && (cO.motionArray[q].type == "finger"))//(N > i + 1
													{
														//find separation dist for each pair	
														var dist:Number = Vector3D.distance(cO.motionArray[i].position, cO.motionArray[q].position);
														
														//find angle dist for each pair	
														var dq:Vector3D  = cO.motionArray[q].position.subtract(palm_mpoint.position);
														var di:Vector3D  = cO.motionArray[i].position.subtract(palm_mpoint.position);
														
														var dAngle:Number = Math.abs(Vector3D.angleBetween(cO.motionArray[i].direction, cO.motionArray[q].direction));
														var pAngle:Number = Math.abs(Vector3D.angleBetween(di, dq));
														
														
														var pair_data:Array = new Array()
															pair_data.pointID = cO.motionArray[i].motionPointID; // ROOT POINT ID
															pair_data.pair_pointID = cO.motionArray[q].motionPointID; // PAIRED POINT ID
															pair_data.distance = dist;	//DISTANCE BETWEEEN PAIRS
															pair_data.directionAngle = dAngle;	//DIRECTION ANGLE BETWEEN PAIRS
															pair_data.positionAngle = pAngle; //POSITION ANGLE BETWEEN PAIRS
															
															pair_data.max_distance = 0;
															pair_data.min_distance = 0;
															pair_data.normalized_distance = 0;
															pair_data.max_directionAngle = 0;
															pair_data.min_directionAngle = 0;
															pair_data.normalized_directionAngle = 0;
															pair_data.max_positionAngle = 0;
															pair_data.min_positionAngle = 0;
															pair_data.normalized_positionAngle = 0;
															
															pair_data.pair_prob = 0;
															
															
															//trace("finger pair", i,"list", q, pair_data,cO.motionArray[q].motionPointID,dist,dAngle)
													
													pair_array.push(pair_data);
													
													}
												}		
													
													
													
										// push to motion point
										pair_table.push(pair_array);	
									}
							}


						// SORT PAIR PROB ARRAYS
							// COPY COLUMN ELEMENTS INTO AN ARRAY
							// SORT ARRAY
							// GET MAX AND MIN DIST VALUES
							// CALC NORMALIZED VALUE (BETWEEN 0 AND 1)
							// PUSH RESULTS TO PAIR TABLE
						
						// get table size
						var tn:int = pair_table.length;
						for (i = 0; i < tn; i++)
									{		
										// create temp array
										var min_dist:Number = null;
										var max_dist:Number = null;
										var min_dang:Number = null;
										var max_dang:Number = null;
										var min_pang:Number = null;
										var max_pang:Number = null;
										var temp_column_arrayA:Array = new Array();
										var temp_column_arrayB:Array = new Array();
										var temp_column_arrayC:Array = new Array();
										
										
										var tnn:int = pair_table[i].length;
										/// copy data from table
											for (q = 0; q < tnn; q++)
												{	
													temp_column_arrayA.push(pair_table[i][q]);
													//temp_column_arrayB.push(pair_table[i][q]);
													//temp_column_arrayC.push(pair_table[i][q]);
												}
												
											temp_column_arrayB = temp_column_arrayA
											temp_column_arrayC = temp_column_arrayA
												
												
										/// sort data	
											temp_column_arrayA.sortOn("distance", Array.DESCENDING);
											temp_column_arrayB.sortOn("positionAngle", Array.DESCENDING)
											temp_column_arrayC.sortOn("directionAngle", Array.DESCENDING);
											
										/// find max and min values
		
											if (temp_column_arrayA[tnn - 1]) min_dist = temp_column_arrayA[tnn - 1].distance;
											if (temp_column_arrayB[tnn - 1]) min_pang = temp_column_arrayB[tnn - 1].positionAngle;
											if (temp_column_arrayC[tnn - 1]) min_dang = temp_column_arrayC[tnn - 1].directionAngle;

											if (temp_column_arrayA[0]) max_dist = temp_column_arrayA[0].distance;
											if (temp_column_arrayB[0]) max_pang = temp_column_arrayB[0].positionAngle;
											if (temp_column_arrayC[0]) max_dang = temp_column_arrayC[0].directionAngle;
											//else max_ang = null;
											
										
										
										
											
										/// find normalized values
										/// write into table
										for (q = 0; q < tnn; q++)
										{
											pair_table[i][q].max_distance = max_dist
											pair_table[i][q].min_distance = min_dist
											pair_table[i][q].normalized_distance = normalize(temp_column_arrayA[q].distance, min_dist, max_dist);
											
											pair_table[i][q].max_positionAngle = max_pang
											pair_table[i][q].min_positionAngle = min_pang
											pair_table[i][q].normalized_positionAngle = normalize(temp_column_arrayB[q].positionAngle, min_pang, max_pang);
											
											pair_table[i][q].max_directionAngle = max_dang
											pair_table[i][q].min_directionAngle = min_dang
											pair_table[i][q].normalized_directionAngle = normalize(temp_column_arrayC[q].directionAngle, min_dang, max_dang);
											
											// best pair prob	// min distnace in set // min angle in set // gives max prob of 1
											//pair_table[i][q].pair_prob = (1 - pair_table[i][q].normalized_distance) * (1 - pair_table[i][q].normalized_positionAngle)*(1-pair_table[i][q].normalized_directionAngle);
											
											
											pair_table[i][q].pair_prob = (pair_table[i][q].normalized_distance)// * (pair_table[i][q].normalized_positionAngle)*(pair_table[i][q].normalized_directionAngle);
											
											/*
											trace("");
											trace("ID", pair_table[i][q].pointID,"pairedID",pair_table[i][q].pair_pointID);
											trace("norm dist", pair_table[i][q].distance, min_dist, max_dist, pair_table[i][q].normalized_distance);
											trace("norm ang",  pair_table[i][q].directionAngle, min_ang, max_ang,  pair_table[i][q].normalized_directionAngle);
											trace("pair prob", pair_table[i][q].pair_prob);
											*/
											
											//if(pair_table[i][q].normalized_directionAngle==0){
												//trace("ID", pair_table[i][q].pointID,"pairedID",pair_table[i][q].pair_pointID);
												//trace("norm ang",  pair_table[i][q].directionAngle, min_dang, max_dang,  pair_table[i][q].normalized_directionAngle);
											//}
											
											// accumulate based on paired sets
											if (pair_table[i][q].pair_prob == 1) {
												//trace("ID", pair_table[i][q].pointID, "pairedID", pair_table[i][q].pair_pointID);
												GestureGlobals.gw_public::motionPoints[pair_table[i][q].pointID].thumb_prob += 1;
												GestureGlobals.gw_public::motionPoints[pair_table[i][q].pair_pointID].thumb_prob += 1;
											}
										}	
								}
								

						
						/*
						// find temporal average thumb prob
						for (var pn:int = 0; pn < cO.motionArray.length; pn++)
						{
							trace("---",cO.motionArray[pn].history.length);
							for (var h:int = 0; h < cO.motionArray[pn].history.length; h++)
							{
								cO.motionArray[pn].mean_thumb_prob += cO.motionArray[pn].history[h].thumb_prob
							}
							//cO.motionArray[pn].mean_thumb_prob // cO.motionArray[pn].history.length;
							trace("mtp",cO.motionArray[pn].motionPointID ,cO.motionArray[pn].mean_thumb_prob)
						}
						*/
						
						
						
						///////////////////////////////////////////////////////////////////////////////////
						// MOD THUMB PROB WITH FINGER LENGTH AND WIDTH

						for (i = 0; i < fn; i++)
							{
								if (cO.motionArray[i].type == "finger") 
								{
									cO.motionArray[i].thumb_prob *= (1-cO.motionArray[i].normalized_length)*(1)
								}
							}
									
						///////////////////////////////////////////////////////////////////////////////////
						
						
						// get largest thumb prob
						var thumb_list:Array = new Array()
						
						for (var pn:int = 0; pn < cO.motionArray.length; pn++)
						{
							thumb_list[pn] = cO.motionArray[pn].thumb_prob
							//thumb_list[pn] = cO.motionArray[pn].mean_thumb_prob
							 
							 // reset thum alloc
							 if(cO.motionArray[pn].type != "palm") cO.motionArray[pn].fingertype = "finger";
						}
						
						// SET FINGER TO THUMB
						var max_tp:Number = Math.max.apply(null, thumb_list);
						var max_index:int = thumb_list.indexOf(max_tp);
						
						if((max_index!=-1)&&( cO.motionArray[max_index])&&(cO.motionArray[max_index].type == "finger")) cO.motionArray[max_index].fingertype = "thumb";	
						trace("-----------------------------------------------------------------------------------------------");
		}
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		/*
		public function find3DNearestPoint():void
		{
			if (fn)
				{
						for (i = 0; i < fn; i++)
									{
									var dist_array = new Array();
										
											// find all finger point  pairs
											for (var q:int = 0; q < fn; q++) 
												{
													if ((i != q) && (cO.motionArray[i].type == "finger") && (cO.motionArray[q].type == "finger"))
													{
													var dist:Number = Vector3D.distance(cO.motionArray[i].position,cO.motionArray[q].position);
													dist_array[q] = new Array();
														dist_array[q].pointID = q;
														dist_array[q].distance = dist;
													}
												}
									//find smallest distance
									dist_array.sort("dist", Array.DESCENDING);
									// psuh nearest neighbour id
									cO.motionArray[i].nnID = cO.motionArray[dist_array[fn-1].pointID].motionPointID;
									}
				}
				// test in visualizer
		}
		*/
		
		
		
		
		
		// Pinch Points
		
		public function find3DPinchPoints():void
		{
			var pinchThreshold:Number = 200;
			
			
			if (fn)
				{
					// pinch
							//////////////////////////////////////////////////////////////////
							
								for (i = 0; i < fn; i++)
									{
										
									//trace("type kinemetric",cO.motionArray[i].type);
									
									for (var j3:uint = 0; j3 <fn; j3++)
										{
										if ((i != j3)&&(cO.motionArray[i].type=="finger")&&(cO.motionArray[j3].type=="finger")){
									
												var fv0:Vector3D = cO.motionArray[i].position;
												var fv1:Vector3D = cO.motionArray[j3].position;
												
												///pinch distance
												//CAN DIFF THUMB AS SHORTEST FINGER IN SET (40-60PX)
												var pinch_dist:Number = Vector3D.distance(fv0,fv1) ;
												//trace(pinch_dist)
												
												if (pinch_dist <= pinchThreshold){
													// find midpoint between fingertips
													var pmp:MotionPointObject = new MotionPointObject();
														pmp.position.x = fv0.x - (fv0.x - fv1.x) * 0.5;
														pmp.position.y = fv0.y - (fv0.y - fv1.y) * 0.5;
														pmp.position.z = fv0.z - (fv0.z - fv1.z) * 0.5;
														pmp.type = "pinch";
														//pmp.handID = hand.id;
														
														////////////////////////////
														// perform hit test
														var ht:Boolean = ts.hitTestPoint(pmp.position.x,pmp.position.y);
														//trace("httttt", ht)
														
														//PUSH POINT TO TOUCH OBJECT INTERACTIVEPOINT LIST
														//TREAT AS LOCAL CLUSTER PROCESS ACCORDINGLY
														
														
														if (ht)
														{
															//CREATE SUBCLUSTER	
															//add to pinch point list
															//cO.clusterArray[0].iPointArray.push(pmp);
															cO.iPointArray.push(pmp);
															
															//COULD CALL CLUSTER TYPE PINCH RATHER THAN LABELING POINTS 
															//cO.clusterArray[0].type = "pinch";
															cO.type = "pinch";
														}
												}
									}
								}
							}
							
							// GET LOCAL LIST OF CLOSE FINGER TIPS
							
							// FIND CLOSEST TO PALM POINT
							
							// PUSH CLOSESR TO IPA
							// PUSH PINCH POINT MOTION POINT EVENT
							
							
							
				}
		}
		
		
		
		
		
		// Trigger Points
		public function find3DTriggerPoints():void
		{
			//find3DThumbPoints();
			
			var triggerThreshold:Number = 45;
			var tempList:Array = new Array();
			//trace("--frame----------------------------------");
				if (fn)
				{
					//only works for 2 fingers
								for (i = 0; i < fn; i++)
									{
									for (var j3:uint = 0; j3 <fn; j3++)
										{
										if ((i != j3)&&(cO.motionArray[i].type=="finger")&&(cO.motionArray[j3].type=="finger")){
				
										
										// need to also make non repeateable
												
												//NOTE WILL NEED TO FIND BEST PAIR AND LOCK OUT OTHER FINGER PAIRS
												// FINGER AND THUMB
												// FIND THUM 
												// GET CLOSEST FINGER
												// CHECK ANGLE
												// PERFORM HIT TEST
												// RETURN FINGER VECTOR
											
											
												var fv0:Vector3D = cO.motionArray[i].direction//position;
												var fv1:Vector3D = cO.motionArray[j3].direction//position;
												var tfv:MotionPointObject = new MotionPointObject();
												
												///pinch distance
												//CAN DIFF THUMB AS SHORTEST FINGER IN SET (40-60PX)
												var angle:Number = (Vector3D.angleBetween(fv0, fv1))*RAD_DEG//*RAD_DEG// mind max
												var dist:Number = Vector3D.distance(fv0, fv1) // find min
												var length:Number// find min
												
												//trace("angle",angle);
												//trace("width",fingers[i].width, fingers[j3].width);
												//trace("length",fingers[i].length, fingers[j3].length);
												
												if (angle > triggerThreshold) 
												{
													
													var array:Array = new Array()
														array[0] = new Array();
															array[0].point = cO.motionArray[i];
															array[0].length = cO.motionArray[i].length;
														array[1] = new Array();
															array[1].point = cO.motionArray[j3];	
															array[1].length = cO.motionArray[j3].length;
														
														array.sortOn("length", Array.DESCENDING);
														tfv = array[0].point
														
														
														
													//trace("point", )
													//push to temp list
													//tempList.push(tfv);
													
													
													
													
														//create trigger point
														var tp:MotionPointObject = new MotionPointObject();
														
															tp.position = tfv.position;
															tp.direction = tfv.direction;
															tp.length = tfv.length;
															tp.id = tfv.id;
															tp.motionPointID = tfv.motionPointID;
															tp.handID = tfv.handID;
															tp.type = "trigger";
														
														var tpht:Boolean = ts.hitTestPoint(tp.position.x , tp.position.y);
														
														//var tpht2:Boolean = ts.hitTestPoint(array[0].point.position.x , array[0].point.position.y);
														
														
														if (tpht){
															//add to pinch point list
															cO.iPointArray.push(tp);
															
															trace("finger", i,j3, tp.id, "angle", angle, tp.motionPointID,tpht,cO.motionArray[i].length,cO.motionArray[j3].length)
															// when found trigger pair return out of loop
															return 
														}
														
														
													
													
													
													
													
												}
				
											}
									}
								}
					
					
														// sort array
					
					
														/*
														//create trigger point
														var tp:MotionPointObject = new MotionPointObject();
															tp.position = tfv.position;
															tp.direction = tfv.direction;
															tp.length = tfv.length;
															tp.id = tfv.id;
															tp.motionPointID = tfv.motionPointID;
															tp.handID = tfv.handID;
															tp.type = "trigger";
														
														//var tpht:Boolean = ts.hitTestPoint(tp.position.x ,tp.position.y);
														
														//add to pinch point list
														cO.iPointArray.push(tp);
														
														trace("finger", i,j3, tp.id, "angle", angle, tp.motionPointID )
														
														// when found trigger pair return out of loop
														//return
														*/
					
					
			}
		}
		
		// 3D MANIPULATE GENERIC 
		public function findMeanInst3DMotionTransformationIPA():void
		{
			//trace("motion local pinch kinemetric",cO.iPointArray.length);
	
				if (ipn!= 0)
				{		
					if (cO.iPointArray.length == 1)
						{
							cO.x = cO.iPointArray[0].position.x;
							cO.y = cO.iPointArray[0].position.y;
							cO.z = cO.iPointArray[0].position.z;
						}
					
					if (cO.iPointArray.length == 2)
						{
							cO.x = cO.iPointArray[0].position.x - ( cO.iPointArray[0].position.x - cO.iPointArray[1].position.x) * 0.5;
							cO.y = cO.iPointArray[0].position.y - ( cO.iPointArray[0].position.y - cO.iPointArray[1].position.y) * 0.5;
							cO.z = cO.iPointArray[0].position.z - (cO.iPointArray[0].position.z - cO.iPointArray[1].position.z) * 0.5;
						}	
						
						//Leap hist	based velocity
							//trace("motion frame count", GestureGlobals.motionFrameID)
							//trace("test",GestureWorks.application.stage.leap);
							//trace(cO.motionArray.history[0].frame);
							
							/////////////////////////////////////////////////////////
							//frame hist based velocity
							var h:uint = 1;
							var hk:Number = 1/h;
							if(cO.history){	
							if (cO.history[h]){
									//var hframe:Frame = cO.history[h].motionArray.frame;
									cO.dx = (cO.x - cO.history[h].x) * hk; 
									cO.dy = (cO.y - cO.history[h].y) * hk;
									cO.dz = (cO.z - cO.history[h].z) * hk;
							
							//trace("velocity", cO.dx,cO.dy,cO.dz)
							/////////////////////////////////////////////////////////
							
							var sx:Number = 0;
							var sy:Number = 0;
							var sx_mc:Number = 0;
							var sy_mc:Number = 0;
							
							/*
							if (cO.iPointArray.length == 2){
								if ((cO.iPointArray[0]) && (cO.iPointArray[1])) {
									if ((cO.iPointArray[0].history[h]) && (cO.iPointArray[1].history[h])) {
									// scale 
									sx += cO.iPointArray[0].x - cO.iPointArray[1].x;
									sy += cO.iPointArray[0].y - cO.iPointArray[1].y;
									sx_mc += cO.iPointArray[0].history[h].x - cO.iPointArray[1].history[h].x;
									sy_mc += cO.iPointArray[0].history[h].y - cO.iPointArray[1].history[h].y;

									// rotate
									var dtheta:Number = 0;
									var theta0:Number = calcAngle(sx, sy);
									var theta1:Number = calcAngle(sx_mc, sy_mc);
											
										if ((theta0 != 0) && (theta1 != 0)) 
											{
											if (Math.abs(theta0 - theta1) > 180) dtheta = 0
											else dtheta = (theta0 - theta1);
											}
										else dtheta = 0;
													
										cO.dtheta += dtheta;
										cO.ds = (Math.sqrt(sx * sx  +  sy * sy) - Math.sqrt(sx_mc * sx_mc  + sy_mc * sy_mc))*sck;
								}
								}
							}
							*/	
								}
							}
							// stops erroneous slipping
							if (Math.abs(cO.dx) > 50) cO.dx = 0;
							if (Math.abs(cO.dy) > 50) cO.dy = 0;
							if (Math.abs(cO.dz) > 50) cO.dz = 0;
													
						}

				//trace("biman manip",cO.dx,cO.dy)
		}
			
		

		
		/*
		public function findMeanInst3DMotionTransformation():void
		{
			
		//trace("motion kinemetric");
		var frame:Frame = cO.motionArray.frame;
		
		//trace("total hands", cO.hn);
		//trace("total fingers", cO.fn);
		
				//trace("--frame----------------------------------");
				
				//trace("id: ",	frame.id); 
				//trace("timestamp: ",	frame.timestamp); 
				//trace("hands: ",	frame.hands.length); 
				//trace("finger: ",	frame.fingers.length);
				
				//trace("tools: ",	frame.tools.length);
				//trace("gestures: ",	frame.gestures().length);
				
				//frame.rotationAxis();
				//frame.rotationAngle();
				//frame.rotationMatrix()
				//frame.scaleFactor();
				//frame.translation();
				//frame.isValid();
			
				if (hn!= 0)
				{
					for each ( var hand:Hand in frame.hands)
						{
					//trace("--hand--");
					// Get the first hand
					//var hand:Hand = frame.hands[ 0 ];
					
					//// update h cluster shpere rad
					//hand.sphereRadius
					//hand.palmPosition
					//hand.direction
					
					//// Get the hand's normal vector and direction
					//LeapMath.toDegrees(hand.direction.pitch)
					//LeapMath.toDegrees(hand.palmNormal.roll)
					//LeapMath.toDegrees(hand.direction.yaw)

					// Check if the hand has any fingers
					var fingers:Vector.<Finger> = hand.fingers;

					
					// push fingers to points list
					if ( fingers.length != 0 )
					{
						cO.x *= fk0;
						cO.y *= fk0;
						cO.z *= fk0;
						
						cO.mx *= fk0;
						cO.my *= fk0;
						
						//cO.z *= fk0;
						//cO.length *=fk0 
						
						
							///////////////////////////////////////////
							// velocity
							//////////////////////////////////////////
							
							if (cO.history) {
								
								//trace("cluster history length:", cO.history.length)	
								var h:uint = 6;
								var hk:Number = 1/h;
								
								
								
								if (cO.history[h]) {
									var hframe:Frame = cO.history[h].motionArray.frame;
									cO.dx = (cO.x - cO.history[h].x) * hk; 
									cO.dy = (cO.y - cO.history[h].y) * hk;
									cO.dz = (cO.z - cO.history[h].z) * hk;
									
									
									//cO.dtheta =   LeapMath.toDegrees(frame.rotationAngle(frame) - frame.rotationAngle(hframe)); 
									//cO.dsx =     -(frame.scaleFactor(frame) - frame.scaleFactor(hframe))*0.04; 
									//cO.dsy =     -(frame.scaleFactor(frame) - frame.scaleFactor(hframe))*0.04; 
									//cO.rotation = (frame.rotationAngle(hframe) * hk); 
									//cO.dthetaX = LeapMath.toDegrees((frame.rotationAngle(hframe))*hk); 
									//cO.dsy = (cO.history[h].scale - cO.history[h].scale)*hk;
								}
								
								//trace("dtheta",cO.dtheta)
								
								// stops erroneous slipping
								if (Math.abs(cO.dx) > 10) cO.dx = 0;
								if (Math.abs(cO.dy) > 10) cO.dy = 0;
								if (Math.abs(cO.dz) > 10) cO.dz = 0;
								//else {
									
								//}
							}	
							/////////////////////////////////////////

					}
					else {
						cO.mx =0;
						cO.my = 0;
						cO.x =0;
						cO.y = 0;
						cO.z = 0;
						
						cO.dtheta = 0
						//cO.dx = 0;
						//cO.dy = 0;
					}
					
				}
				
				//cO.dx =0;
				//cO.dy = 0;
				//cO.dz = 0;	
				//cO.dtheta = 0
				//cO.dx = 0;
				//cO.dy = 0;
				
				
				
				/////////////////////////////////////
				// frame motion 
				/////////////////////////////////////
				
				//if (cO.history[6]) {
					//var since:Frame = cO.history[6].motionArray;
					//trace("frame motion:",frame.translation(since));
				//}
				
				// Calculate the hand's pitch, roll, and yaw angles
				//trace( "Hand pitch: " + LeapMath.toDegrees( direction.pitch ) + " degrees, " + "roll: " + LeapMath.toDegrees( normal.roll ) + " degrees, " + "yaw: " + LeapMath.toDegrees( direction.yaw ) + " degrees\n" );
				
				//trace("motion data:",GestureGlobals.motionframeID,fn,fk0,fk1,"pos:",cO.x,cO.y,"vel:",cO.dx,cO.dy);
			}
		}
		
		
		*/
		
		
		////////////////////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////////////
		// helper functions
		////////////////////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////////////
		
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
				if (adjacent == 0) return opposite < 0 ? 270 : 90 ;
				if (opposite == 0) return adjacent < 0 ? 180 : 0 ;
				0
				if(opposite > 0) return adjacent > 0 ? 360 + Math.atan(opposite / adjacent) * RAD_DEG : 180 - Math.atan(opposite / -adjacent) * RAD_DEG ;
				else return adjacent > 0 ? 360 - Math.atan( -opposite / adjacent) * RAD_DEG : 180 + Math.atan( opposite / adjacent) * RAD_DEG ;
				
				return 0;
		}
		
		private static function normalize(value : Number, minimum : Number, maximum : Number) : Number {

                        return Math.abs((value - minimum) / (maximum - minimum));
         }

        private static function limit(value : Number, min : Number, max : Number) : Number {
                        return Math.min(Math.max(min, value), max);
        }
	}
}