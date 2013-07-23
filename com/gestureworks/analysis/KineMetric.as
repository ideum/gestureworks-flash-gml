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
	import com.gestureworks.core.GestureGlobals;
	import com.gestureworks.core.gw_public;
	import com.gestureworks.objects.PointObject;
	import com.gestureworks.objects.MotionPointObject;
	import com.gestureworks.objects.InteractionPointObject;
	import com.gestureworks.objects.GesturePointObject;
	
	import com.gestureworks.objects.ClusterObject;
	import com.gestureworks.objects.PointPairObject;
	import com.gestureworks.managers.PointPairHistories;
	import com.gestureworks.managers.InteractionPointTracker;
	
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
		
		//public var pointList:Vector.<PointObject>; // should operate directly on cluster
		//public var pointPairList:Vector.<PointPairObject>;// should operate directly on cluster
		
		// TOUCH POINT TOTALS
		public var N:uint = 0;
		public var LN:uint = 0; //locked touch points
		private var N1:uint = 0;
		private var k0:Number  = 0;
		private var k1:Number  = 0;
		private var i:uint = 0;
		private var j:uint = 0;
		private var mc:uint = 0; //MOVE COUNT
		
		// separate base scale const
		private var sck:Number = 0.0044;
		//pivot base const
		private var pvk:Number = 0.00004;
		
		// motion point totals
		private var hn:uint = 0;
		private var fn:uint = 0;
		
		// INTERACTION POINT TOTALS
		private var ipn:uint = 0;
		private var ipnk:Number = 0;
		private var ipnk0:Number = 0;
	
		
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
				LN = ts.cO.hold_n // will need to move to interaction point structure or temporal metric mgmt
				
				// derived point totals
				if (N) 
				{
					N1 = N - 1;
					k0 = 1 / N;
					k1 = 1 / N1;
					if (N == 0) k1 = 0;
					//pointList = cO.pointArray; // copy most recent point array data
					mc = cO.pointArray[0].moveCount; // get sample move count value
					
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
			//cO.thumbID = 0;
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
			
			cO.gPointArray = new Vector.<GesturePointObject>;
		}
		
		public function findInstDimention():void
		{
			///////////////////////////////////////////////////////////////////////////////////////////////////////////
			// cluster width, height and radius // OPERATION
			///////////////////////////////////////////////////////////////////////////////////////////////////////////
			// basic cluster property values 
			// uses the current position of the points in the cluster to find the spread of the cluster and its current dims
					
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
					
					
					
					if (N == 1)
					{
						cO.x = cO.pointArray[0].x;
						cO.y = cO.pointArray[0].y;
						cO.mx = cO.pointArray[0].x;
						cO.my = cO.pointArray[0].y;
					}
					
					else if (N > 1)
						{	
						for (i = 1; i < N; i++)
						{
							for (var j1:uint = 0; j1 < N; j1++)
							{
								if ((i != j1) && (cO.pointArray[i]) && (cO.pointArray[j1]))//&&(!pointList[i].holdLock)&&(!pointList[j1].holdLock))//edit
									{
										//trace("dim",N);
										var dx:Number = cO.pointArray[i].x - cO.pointArray[j1].x
										var dy:Number = cO.pointArray[i].y - cO.pointArray[j1].y
										var ds:Number  = Math.sqrt(dx * dx + dy * dy);
											
										// diameter, radius of group
										if (ds > cO.radius)
										{
											cO.radius = ds *0.5;
										}
										// width of group
										var abs_dx:Number = Math.abs(dx);
										if (abs_dx > cO.width)
										{
											cO.width = abs_dx;
											cO.x = cO.pointArray[i].x -(dx*0.5);
										}
										// height of group
										var abs_dy:Number = Math.abs(dy);
										if (abs_dy > cO.height)
										{
											cO.height = abs_dy;
											cO.y = cO.pointArray[i].y -(dy* 0.5);
										} 
										
										// NOTE NEED TO FIX AS CO.X CAN BE SAME AS CO.MX
										
										
										// mean point position
										cO.mx += cO.pointArray[i].x;
										cO.my += cO.pointArray[i].y;
									}
							}
							
							
							// inst separation and rotation
							if ((cO.pointArray[0]) && (cO.pointArray[i]))//&&(!pointList[i].holdLock)&&(!pointList[j1].holdLock)) //edit
							{
								var dxs:Number = cO.pointArray[0].x - cO.pointArray[i].x;
								var dys:Number = cO.pointArray[0].y - cO.pointArray[i].y;
								//var ds:Number  = Math.sqrt(dx * dx + dy * dy);

								// separation of group
								cO.separationX += Math.abs(dxs);
								cO.separationY += Math.abs(dys);
								
								// rotation of group
								cO.rotation += (calcAngle(dxs, dys)) //|| 0
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
		
		public function findSimpleMeanInstTransformation():void
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
					for (i = 0; i < N; i++) 
						{	
							// translate	
							cO.dx += cO.pointArray[i].DX;
							cO.dy += cO.pointArray[i].DY;
						}
						//var theta0:Number = calcAngle(sx, sy);
						//var theta1:Number = calcAngle(sx_mc, sy_mc); // could eliminate in point pair

						cO.dx *= k0;
						cO.dy *= k0;
								
						if (cO.history[1])
								{
									//////////////////////////////////////////////////////////
									// CHANGE IN SEPARATION
									if ((cO.history[1].radius != 0) && (cO.rotation != 0)) 
									{
										cO.ds = (cO.radius - cO.history[1].radius) * sck;
									}
									//trace(cO.radius, cO.history[mc].radius);
									
									//////////////////////////////////////////////////////////
									// CHANGE IN ROTATION
									if ((cO.history[1].rotation != 0) && (cO.rotation != 0)) 
									{
										if (Math.abs(cO.rotation - cO.history[1].rotation) > 90) cO.dtheta = 0
										else cO.dtheta = (cO.rotation - cO.history[1].rotation);	
									}
									//trace(cO.rotation, cO.history[1].rotation, cO.dtheta);
								}
				}
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
										sx += cO.pointArray[0].x - cO.pointArray[i + 1].x;
										sy += cO.pointArray[0].y - cO.pointArray[i + 1].y;
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
							if (cO.pointArray[0])
								{
								cO.dx = cO.pointArray[0].DX;
								cO.dy = cO.pointArray[0].DY;
								}
						}
					else if (N > 1)
					{
						for (i = 0; i < N; i++) 
						{
								if (cO.pointArray[i])//&&(!pointList[i].holdLock))// edit
								{
									// SIMPLIFIED DELTa
									cO.dx += cO.pointArray[i].DX;
									cO.dy += cO.pointArray[i].DY;
								}	
						}
						cO.dx *= k0;
						cO.dy *= k0;
					}
					//	trace("drag calc kine",c_dx,c_dy);
		}
		
		public function findSimpleMeanInstSeparation():void
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
						if (cO.history[1])
						{
							if (cO.history[1].radius != 0) cO.ds = (cO.radius - cO.history[1].radius) * sck;
							if (cO.history[1].width != 0) cO.dsx = (cO.width - cO.history[1].width) * sck;
							if (cO.history[1].height != 0) cO.dsy = (cO.height - cO.history[1].height) * sck;
						} 
					}
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
							if ((N>i+1)&&(cO.pointArray[0].history.length>mc) && (cO.pointArray[i + 1].history.length>mc))
							{		
								sx = Math.abs(cO.pointArray[0].x - cO.pointArray[i + 1].x);
								sy = Math.abs(cO.pointArray[0].y - cO.pointArray[i + 1].y);
								sx_mc = Math.abs(cO.pointArray[0].history[mc].x - cO.pointArray[i + 1].history[mc].x);
								sy_mc = Math.abs(cO.pointArray[0].history[mc].y - cO.pointArray[i + 1].history[mc].y);
								
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
		
		public function findSimpleMeanInstRotation():void
		{
			//////////////////////////////////////////////////////////////////////////////////////////////////////////////
			// cluster roation // OPERATION
			//////////////////////////////////////////////////////////////////////////////////////////////////////////////
			// finds the change in the rotation of the cluster between the current frame and a previous frame in history
			cO.dtheta = 0;
						
			if(N>1)
				{	
				if (cO.history[1])
					{
						if (cO.history[1].rotation!=0) cO.dtheta =(cO.rotation - cO.history[1].rotation)	 
					}					
				}
			//trace(cO.dtheta);
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
								if ((N > i + 1)&&(cO.pointArray[0].history.length>mc) && (cO.pointArray[i + 1].history.length>mc))
								{		
									// SIMPLIFIED DELTA 
									var dtheta:Number = 0;
									var theta0:Number = calcAngle((cO.pointArray[0].x - cO.pointArray[i+1].x), (cO.pointArray[0].y - cO.pointArray[i+1].y));
									//var theta1:Number = calcAngle((pointList[0].history[h].x - pointList[i + 1].history[h].x), (pointList[0].history[h].y - pointList[i + 1].history[h].y));
									var theta1:Number = calcAngle((cO.pointArray[0].history[mc].x - cO.pointArray[i+1].history[mc].x), (cO.pointArray[0].history[mc].y - cO.pointArray[i+1].history[mc].y));
									
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
							if (cO.pointArray[i].history[1])//&&(!pointList[i].holdLock))//edit
							{
								// SIMPLIFIED DELTAS
								// second diff of x anf y wrt t
								cO.ddx += cO.pointArray[i].dx - cO.pointArray[i].history[1].dx;
								cO.ddy += cO.pointArray[i].dy - cO.pointArray[i].history[1].dy;
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
					if(cO.pointArray[i].history.length>t)
					{
					for (j = 0; j < t; j++) 
						{
						cO.etm_dx += cO.pointArray[i].history[j].dx;
						cO.etm_dy += cO.pointArray[i].history[j].dy;
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
					if(cO.pointArray[i].history.length>t)
						{
							// SIMPLIFIED DELTAS
							// second diff of x anf y wrt t
							for (j = 0; j < t; j++) 
							{
								cO.etm_ddx += cO.pointArray[i].history[j+1].dx- cO.pointArray[i].history[j].dx;
								cO.etm_ddy += cO.pointArray[i].history[j + 1].dy -cO.pointArray[i].history[j].dy ;
								//cO.etm_ddx += pointList[i].history[0].dx - pointList[i].history[1].dx;
								//cO.etm_ddy += pointList[i].history[0].dy - pointList[i].history[1].dy;
							}
						}
					}
					//trace(k0, t0);
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
									if (cO.pointArray[i].history[0])
									//if(pointList.length>i)
									{
										handArray[i] = new Array();
										handArray[i].id = cO.pointArray[i].id; // set point id
									
										// find distance between center of cluster and finger tip
										var dxe:Number = (cO.pointArray[i].history[0].x - cO.x);
										var dye:Number = (cO.pointArray[i].history[0].y - cO.y);
										
										// find diatance between mean center of cluster and finger tip
										var dxf:Number = (cO.pointArray[i].history[0].x - cO.mx);
										var dyf:Number = (cO.pointArray[i].history[0].y - cO.my);
										var ds1:Number = Math.sqrt(dxf * dxf + dyf * dyf)
										
										handArray[i].dist = ds1; // set distance from mean
										handArray[i].angle = 180; // init angle between vectors to radial center

										for (var q:int = 0; q < N; q++) 
										{
											if ((i != q)&&(cO.pointArray[q].history[0]))
												{
												var dxq:Number = (cO.pointArray[q].history[0].x - cO.x);
												var dyq:Number = (cO.pointArray[q].history[0].y - cO.y);
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
									if (cO.pointArray[i].id != handArray[0].id) 
									{	
										cO.orient_dx += (cO.pointArray[i].history[0].x - cO.x);
										cO.orient_dy += (cO.pointArray[i].history[0].y - cO.y);
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
								if (cO.pointArray[0].history.length>1) 
								{		
									// find touch point translation vector
									var dxh:Number = cO.pointArray[0].history[1].x - x_c;
									var dyh:Number = cO.pointArray[0].history[1].y - y_c;
											
									// find vector that connects the center of the object and the touch point
									var dxi:Number = cO.pointArray[0].x - x_c;
									var dyi:Number = cO.pointArray[0].y - y_c;
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
										cO.x = cO.pointArray[0].x;
										cO.y = cO.pointArray[0].y;
									//}
									//else cO.pivot_dtheta = 0; 
								}
						}
		} 
		
		

		///////////////////////////////////////////////////////////////////////////////////
		///////////////////////////////////////////////////////////////////////////////////
		// sensor analysis
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
		// 3d IP motion analysis
		///////////////////////////////////////////////////////////////////////////////////
		///////////////////////////////////////////////////////////////////////////////////
		public function mapCluster3Dto2D():void
			{
				trace("map cluster data 3d to 2d")
				
				//POSITION
				cO.x = normalize(cO.x, -180, 180) * 1920;//stage.stageWidth;
				cO.y = normalize(cO.y, 270, -75) * 1080;// stage.stageHeight;
				cO.z = cO.z;
				
				trace(cO.width,cO.height,cO.radius)
				
				cO.width = cO.width;
				cO.height = cO.height;
				cO.radius = cO.radius;
				
				// TRANSLATION
				cO.dx = cO.dx
				cO.dy = 1 * cO.dy;
				cO.dz = cO.dy
			}
		
		
		// GET IP CLUSTER CONSTS
		public function find3DIPConstants():void
		{
			cO.ipn = cO.iPointArray.length;
			ipn = cO.ipn;
			
			ipnk = 1 / ipn;
			if (ipn == 1) ipnk = 1;
			
			ipnk0 = 1 / (ipn - 1);
			if (ipn == 1) ipnk0 = 1;
		}
		
		// IP CLUSTER DIMENSIONS
		public function find3DDimension():void
		{
			for (i = 0; i < ipn; i++) 
						{
						var ipt = cO.iPointArray[i];
						
						for (var q:uint = 0; q < i+1; q++) 
						{
						 if (i != q) {
							 
							var dx:Number = cO.iPointArray[i].position.x - cO.iPointArray[q].position.x
							var dy:Number = cO.iPointArray[i].position.y - cO.iPointArray[q].position.y
							var dz:Number = cO.iPointArray[i].position.z - cO.iPointArray[q].position.z
							var ds:Number  = Math.sqrt(dx * dx + dy * dy + dz*dz);
							 
							 
							var abs_dx:Number = Math.abs(dx);
							var abs_dy:Number = Math.abs(dy);
							var abs_dz:Number = Math.abs(dz);
						
						
							if (abs_dx > cO.width) cO.width = abs_dx;
							if (abs_dy > cO.height) cO.height = abs_dy;
							if (abs_dz > cO.length) cO.length = abs_dz;
							if (ds > cO.radius) cO.radius = ds;
						 }
						 }
						}
						
					//trace(cO.width,cO.height,cO.length)
		}
		
		// TAP POINTS
		public function find3DTapPoints():void
		{
			// LOOK FOR 
				//VELOCITY SIGN CHANGE
				//ACCLERATION SIGN CHANGE 
				//JOLT MAGNITUDE MIN

			var hist:int = 15;
			var tapThreshold:Number = 15; // SMALLER MAKES EASIER
			
			//trace("--");
	
			for (i = 0; i < ipn; i++) 
					{	
					var pt = cO.iPointArray[i];

					if (pt)
						{
							if (pt.history.length > hist)
							{
								//trace("jolt:",cO.iPointArray[0].history[1].jolt.x,cO.iPointArray[0].history[1].jolt.y,cO.iPointArray[0].history[1].jolt.z);
								if (Math.abs(pt.history[1].jolt.y) > tapThreshold) 
								{
									// CHECK PAST MAKE SURE HAVE NOT SET STATE FOR 10 FRAMES
									//STOP AMBULANCE CHASERS //start after hist 1
									var test:Boolean = true;
									
									for (var h = 2; h < hist; h++) 
										{	
											if (Math.abs(pt.history[h].jolt.y) > tapThreshold) test = false;
										}
									if (test) {
										
										var gpt = new GesturePointObject();
											gpt.position = pt.position;
											gpt.type = "y tap";
										cO.gPointArray.push(gpt);
										
										trace("y tap-----scan clean", pt.history[0].jolt.y, pt.history[1].jolt.y, pt.interactionPointID);
										}
								}
								
								if (Math.abs(pt.history[1].jolt.x) > tapThreshold) 
								{
									// CHECK PAST MAKE SURE HAVE NOT SET STATE FOR 10 FRAMES
									//STOP AMBULANCE CHASERS //start after hist 1
									var test:Boolean = true;
									
									for (var h = 2; h < hist; h++) 
										{	
											if (Math.abs(pt.history[h].jolt.x) > tapThreshold) test = false;
										}
									if (test) {
										
										var gpt = new GesturePointObject();
											gpt.position = pt.position;
											gpt.type = "x tap";
										cO.gPointArray.push(gpt);
										
										trace("x tap-----scan clean", pt.history[0].jolt.x,pt.interactionPointID)
									}
								}
								
								if (Math.abs(pt.history[1].jolt.z) > tapThreshold) 
								{
									// CHECK PAST MAKE SURE HAVE NOT SET STATE FOR 10 FRAMES
									//STOP AMBULANCE CHASERS //start after hist 1
									var test:Boolean = true;
									
									for (var h = 2; h < hist; h++) 
										{	
											if (Math.abs(pt.history[h].jolt.z) > tapThreshold) test = false;
										}
									if (test) {
										
											var gpt = new GesturePointObject();
												gpt.position = pt.position;
												gpt.type = "z tap";
											cO.gPointArray.push(gpt);
											
										trace("z tap-----scan clean", pt.history[0].jolt.z, pt.interactionPointID);
									}
								}
								
								
								//if (Math.abs(pt.history[1].jolt.x) > tapThreshold) trace("x tap-----------", pt.interactionPointID);
								//if (Math.abs(pt.history[1].jolt.z) > tapThreshold) trace("z tap-----------", pt.interactionPointID);
								
								
								
							}
						}
					}
		}
		
		//HOLD POINTS
		public function find3DHoldPoints():void
		{
			//HOLD 
				// SCAN HIST 20
				// LOW VELOCITY
				// LOWER ACCEL
			
			var hist:int = 20;
			var holdThreshold:Number = 3; 
			
			//trace("--");

			for (i = 0; i < ipn; i++) 
					{	
					var pt:InteractionPointObject = cO.iPointArray[i];

						if ((pt)&&(pt.history.length > hist))
							{
							if ((pt.history[hist].velocity.length < holdThreshold) && (pt.history[hist].acceleration.length < (holdThreshold*0.1-0.1))) 
								{
									var gpt = new GesturePointObject();
												gpt.position = pt.history[hist].position;// PREVENTS HOLD DRIFT
												gpt.type = "hold";
											cO.gPointArray.push(gpt);
									
									trace("hold...", pt.interactionPointID);
								}
								//trace("v: ",v,"a: ",a)
							}
					}
		}
		
		// 3D MANIPULATE GENERIC 
		public function findMeanInst3DMotionTransformation():void
		{
			var hist:int = 3;
			var hk:Number = 1 / hist;
			
			//trace("motion transform kinemetric", cO.iPointArray.length, ipn,cO.ipn);
			
			if (ipn!= 0)
				{		
						if ((ipn == 1)&&(cO.iPointArray[0].history.length>(hist+1)))
							{
								var pt = cO.iPointArray[0];
								
								cO.x = pt.position.x;
								cO.y = pt.position.y;
								cO.z = pt.position.z;
								
								cO.dx = (pt.position.x - pt.history[hist].position.x)*hk;
								cO.dy = (pt.position.y - pt.history[hist].position.y)*hk;
								cO.dz = (pt.position.z - pt.history[hist].position.z)*hk;
								
								
								if (pt.type == "palm")
								{
									cO.rotationX = RAD_DEG * Math.asin(pt.normal.x);
									cO.rotationY = RAD_DEG * Math.asin(pt.normal.y);
									cO.rotationZ = RAD_DEG * Math.asin(pt.normal.z);
									
									cO.dthetaX = RAD_DEG * (Math.asin(pt.normal.x - pt.history[hist].normal.x))*hk;
									cO.dthetaY = RAD_DEG * (Math.asin(pt.normal.y - pt.history[hist].normal.y))*hk;
									cO.dthetaZ = RAD_DEG * (Math.asin(pt.normal.z - pt.history[hist].normal.z))*hk;
								}
								//trace(cO.dthetaX,pt.normal.x,pt.history[hist].normal.x);
							}
							
						
						if (ipn > 1)
						{
						for (i = 0; i < ipn; i++) 
						{	
							
						if (cO.iPointArray[i])
						{
							var pt0 = cO.iPointArray[i];
							// pos
							cO.x += pt0.position.x;
							cO.y += pt0.position.y;
							cO.z += pt0.position.z;
							
						
						
						if (ipn > i + 1)
						{
							if (cO.iPointArray[i + 1])
							{
							var pt1 = cO.iPointArray[i+1];
							
							if ((pt0.history.length>(hist+1))&&(pt1.history.length>(hist+1))){
							//if ((ipn >= 2)&&(cO.iPointArray[0].history.length>(hist+1))&&(cO.iPointArray[1].history.length>(hist+1)))
							//{
			
								// drag
								//cO.dx += (pt0.position.x - pt0.history[hist].position.x);
								//cO.dy += (pt0.position.y - pt0.history[hist].position.y);
								//cO.dz += (pt0.position.z - pt0.history[hist].position.z);
								
								//scale
								var sx:Number = (pt0.position.x - pt1.position.x);
								var sy:Number = (pt0.position.y - pt1.position.y);
								var sz:Number = (pt0.position.z - pt1.position.z);
								var sx_mc:Number = (pt0.history[hist].position.x - pt1.history[hist].position.x);
								var sy_mc:Number = (pt0.history[hist].position.y - pt1.history[hist].position.y);
								var sz_mc:Number = (pt0.history[hist].position.z - pt1.history[hist].position.z);

								// rotate
								var dthetaZ:Number = 0;
								var theta0Z:Number = calcAngle(sx, sy);
								var theta1Z:Number = calcAngle(sx_mc, sy_mc);
																
										if ((theta0Z != 0) && (theta1Z != 0)) 
										{
											if (Math.abs(theta0Z - theta1Z) > 180) dthetaZ = 0
											else dthetaZ = (theta0Z - theta1Z);
										}
										else dthetaZ = 0;
										
								var dthetaX:Number = 0;
								var theta0X:Number = calcAngle(sy, sz);
								var theta1X:Number = calcAngle(sy_mc, sz_mc);
																
										if ((theta0X != 0) && (theta1X != 0)) 
										{
											if (Math.abs(theta0X - theta1X) > 180) dthetaX = 0
											else dthetaX = (theta0X - theta1X);
										}
										else dthetaX = 0;
										
										
								var dthetaY:Number = 0;
								var theta0Y:Number = calcAngle(sz, sx);
								var theta1Y:Number = calcAngle(sz_mc, sx_mc);
																
										if ((theta0Y != 0) && (theta1Y != 0)) 
										{
											if (Math.abs(theta0Y - theta1Y) > 180) dthetaY = 0
											else dthetaY = (theta0Y - theta1Y);
										}
										else dthetaY = 0;
										
								var rk:Number = 0.4;
																		
								cO.dthetaZ = dthetaZ*rk;
								cO.dthetaX = dthetaX*rk;
								cO.dthetaY = dthetaY*rk;
								
								//cO.ds = (Math.sqrt(sx * sx  +  sy * sy) - Math.sqrt(sx_mc * sx_mc  + sy_mc * sy_mc)) * sck;
								cO.ds = (Math.sqrt(sx * sx  +  sy * sy  + sz * sz) - Math.sqrt(sx_mc * sx_mc  + sy_mc * sy_mc + sz_mc * sz_mc)) * sck;
								
								cO.dtheta = dthetaZ*rk;
								//trace("rotate and scale", sx_mc, sy_mc, sx, sy, cO.dtheta, cO.ds);
								
							}
							
							
				cO.dx *= ipnk;
				cO.dy *= ipnk; 
				cO.dz *= ipnk;	
				
				//cO.dsx = ipk0*cO.dsx;
				//cO.dsy = ipk0*cO.dsy; 
				//cO.ds = ipk0*cO.ds;
				//cO.dtheta = ipk0*cO.dtheta;
				}
				}
				}
				}
				
				cO.x *= ipnk;
				cO.y *= ipnk; 
				cO.z *= ipnk;
				
				}
			}
			//trace("test",cO.x,cO.y,cO.z, cO.dx,cO.dy,cO.dz);
		}
		
		
		
		
		
		
		
		
		
		
		
		
		
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

                        return (value - minimum) / (maximum - minimum);
         }

        private static function limit(value : Number, min : Number, max : Number) : Number {
                        return Math.min(Math.max(min, value), max);
        }
	}
}