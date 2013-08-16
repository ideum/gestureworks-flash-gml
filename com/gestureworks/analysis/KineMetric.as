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
	//import org.openzoom.flash.viewport.controllers.ViewportControllerBase;
	
	import com.gestureworks.objects.ClusterObject;
	import com.gestureworks.objects.ipClusterObject;
	//import com.gestureworks.objects.PointPairObject;
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
		
		//private var pinch_cO:ipClusterObject;
		//private var trigger_cO:ipClusterObject;
		//private var finger_cO:ipClusterObject;
		
		//private var ipmatrix:Vector.<ipClusterObject> = new Vector.<ipClusterObject>
		
		// TOUCH POINT TOTALS
		public var N:uint = 0;
		public var LN:uint = 0; //locked touch points
		private var N1:uint = 0;
		private var k0:Number  = 0;
		private var k1:Number  = 0;
		private var i:uint = 0;
		private var j:uint = 0;
		private var mc:uint = 0; //MOVE COUNT
		
		private var rk:Number = 0.4; // rotation const
		// separate base scale const
		private var sck:Number = 0.0044;
		//pivot base const
		private var pvk:Number = 0.00004;
		
		// motion point totals
		private var hn:uint = 0;
		private var fn:uint = 0;
		
		// INTERACTION POINT TOTALS
		private var ipn:uint = 0;
		private var dipn:int = 0;
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
			
				//pinch_cO = cO.pinch_cO;
				//trigger_cO = cO.trigger_cO;
				//finger_cO = cO.finger_cO;
			
			
			if (ts.trace_debug_mode) trace("init cluster kinemetric");
			
			
			cO.subClusterArray[0] = new ipClusterObject();// finger
			cO.subClusterArray[0].type = "finger"		
			cO.subClusterArray[1] = new ipClusterObject();// palm
			cO.subClusterArray[1].type = "palm"		
			cO.subClusterArray[2] = new ipClusterObject();// thumb
			cO.subClusterArray[2].type = "thumb"		
			cO.subClusterArray[3] = new ipClusterObject();// finger avergae
			cO.subClusterArray[3].type = "finger_average"
			
			cO.subClusterArray[4] = new ipClusterObject(); // trigger
			cO.subClusterArray[4].type = "trigger"		
			cO.subClusterArray[5] = new ipClusterObject(); // pinch
			cO.subClusterArray[5].type = "pinch"
			cO.subClusterArray[6] = new ipClusterObject(); // push
			cO.subClusterArray[6].type = "push"
			cO.subClusterArray[7] = new ipClusterObject(); // hook
			cO.subClusterArray[7].type = "hook"
			cO.subClusterArray[8] = new ipClusterObject(); //frame
			cO.subClusterArray[8].type = "frame"
			
			
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
										
										////////////////////////////////////////////
										// rotate
										var dtheta:Number = 0;
										var theta0:Number = calcAngle(sx, sy);
										var theta1:Number = calcAngle(sx_mc, sy_mc); // could eliminate in point pair

										if ((theta0 != 0) && (theta1 != 0)) 
											{
											if (Math.abs(theta0 - theta1) > 180) dtheta = 0
											else dtheta = (theta0 - theta1);
											}
										else dtheta = 0;
		
										cO.dtheta += dtheta;
										////////////////////////////////////////////
									
										}	
								}
								
								// FIND C_DSX AND C_DSY AGGREGATE THEN AS A LAST STEP FIND THE SQUARE OF THE DISTANCE BETWEEN TO GET C_DS
								//c_ds = Math.sqrt(c_dsx*c_dsx + c_dsy*c_dsy)
								
								cO.dx *= k0;
								cO.dy *= k0;
								
								cO.dtheta *= k1;
								cO.ds = (Math.sqrt(sx * sx  +  sy * sy) - Math.sqrt(sx_mc * sx_mc  + sy_mc * sy_mc)) * k1 * sck;
								
								
								
								
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
				//trace("map cluster data 3d to 2d")
				
			if ((!ts.transform3d)&&(ts.motion3d)) 
				{
				cO.motionArray2D = new Vector.<MotionPointObject>();
				cO.iPointArray2D = new Vector.<InteractionPointObject>();
				
				
				// NORMALIZE MOTION POINT DATA TO 2D
				for (i = 0; i < cO.motionArray.length; i++) 
						{
							var pt:MotionPointObject = cO.motionArray[i];
							var pt2d:MotionPointObject = new MotionPointObject();
							
							pt2d.position.x = normalize(pt.position.x, -180, 180) * 1920;//stage.stageWidth;
							pt2d.position.y = normalize(pt.position.y, 270, -75) * 1080;// stage.stageHeight;
							pt2d.position.z = pt.position.z
							pt2d.type = pt.type;
							pt2d.fingertype = pt.fingertype;
							
						cO.motionArray2D.push(pt2d);
						}
						
				// NORMALIZE INTERACTION POINT DATA TO 2D	
				for (i = 0; i < cO.iPointArray.length; i++)
						{
							var ipt:InteractionPointObject = cO.iPointArray[i];
							var ipt2d:InteractionPointObject = new InteractionPointObject();
							
							ipt2d.position.x = normalize(ipt.position.x, -180, 180) * 1920;//stage.stageWidth;
							ipt2d.position.y = normalize(ipt.position.y, 270, -75) * 1080;// stage.stageHeight;
							ipt2d.position.z = ipt.position.z
							ipt2d.type = ipt.type;
							
						cO.iPointArray2D.push(ipt2d);
						}
				}
	}
	
	public function getSubClusters():void
			{
				//trace("map cluster data 3d to 2d")
			var temp_ipointArray:Vector.<InteractionPointObject>;
				
			if ((!ts.transform3d)&&(ts.motion3d)) temp_ipointArray = cO.iPointArray2D;
			else temp_ipointArray = cO.iPointArray;
			
				//zero subcluster data //////////////////////////////
				for (j = 0; j < cO.subClusterArray.length; j++) 
				{
					cO.subClusterArray[j].iPointArray.length=0;
				}
			
				//update subcluster point arrays //////////////////////////////
				for (i = 0; i < temp_ipointArray.length; i++) 
				{
					var ipt:InteractionPointObject = temp_ipointArray[i];
						
					for (j = 0; j < cO.subClusterArray.length; j++) 
					{
						if (ipt.type==cO.subClusterArray[j].type) cO.subClusterArray[j].iPointArray.push(ipt);
					}
						//trace(ipt.type)
				}
	}
		
		
		
		// GET IP CLUSTER CONSTS
		public function find3DGlobalIPConstants():void//type:String
		{
			// GET INTERACTION POINT NUMBER
			cO.ipn = cO.iPointArray.length;
			ipn = cO.ipn;
			
			//CHANGE IN INTERACTION POINT NUMBER
			if (cO.history.length>3) dipn = cO.ipn - cO.history[1].ipn;
			else dipn = 1;
			cO.dipn = dipn;

			// GET IP BASED CONSTANTS
			if (ipn == 1) ipnk = 1;
			else ipnk = 1 / ipn;
			
			if (ipn == 1) ipnk0 = 1;
			else ipnk0 = 1 / (ipn - 1);
			
			//trace("dipn",cO.dipn, cO.ipnk, cO.ipnk0);
		}
		
		public function find3DIPConstants(index:int):void//type:String
		{
			var sdipn:int = 0;
			var sipn:int = 0;
			var sipnk:Number = 0;
			var sipnk0:Number = 0;
			
			// GET INTERACTION POINT NUMBER
			cO.subClusterArray[index].ipn = cO.subClusterArray[index].iPointArray.length;
			sipn = cO.subClusterArray[index].ipn;
			
			//CHANGE IN INTERACTION POINT NUMBER
			if (cO.history.length>3) sdipn = sipn - cO.history[2].subClusterArray[index].ipn;
			else sdipn = 1;
			
			// GET IP BASED CONSTANTS
			if (sipn == 1) sipnk = 1;
			else sipnk = 1 / sipn;
			
			if (sipn == 1) sipnk0 = 1;
			else sipnk0 = 1 / (sipn - 1);
			
			cO.subClusterArray[index].ipn = sipn;
			cO.subClusterArray[index].dipn = sdipn;
			cO.subClusterArray[index].ipnk = sipnk;
			cO.subClusterArray[index].ipnk0 = sipnk0;
		
			//trace("const ipn",cO.subClusterArray[index].ipn,cO.subClusterArray[index].dipn, cO.subClusterArray[index].ipnk, cO.subClusterArray[index].ipnk0);
		}
		
	
		
		// IP CLUSTER DIMENSIONS
		public function find3DIPDimension(index:int):void
		{
			// GET TYPED SUB CLUSTER from cluster matrix //////////////////////////
			var sub_cO:ipClusterObject = cO.subClusterArray[index];

			// GET TRANSFORMED INTERACTION POINT LIST
			var ptArray:Vector.<InteractionPointObject> = sub_cO.iPointArray;
			
			var sipn:int = sub_cO.ipn
			var sipnk:Number = sub_cO.ipnk;
			var sipnk0:Number = sub_cO.ipnk0

			sub_cO.x = 0;
			sub_cO.y = 0;
			sub_cO.z = 0;
			
			sub_cO.radius = 0
			sub_cO.width = 0;
			sub_cO.height = 0;
			sub_cO.length = 0;
			
			sub_cO.separationX = 1;
			sub_cO.separationY = 1;
			sub_cO.separationZ = 1;
			
			// rotation of group
			sub_cO.rotation = 0
			sub_cO.rotationX = 0; 
			sub_cO.rotationY = 0; 
			sub_cO.rotationZ = 0;
			
			
			
			
			//APPLY DIMENTIONAL ANALYSIS
			if ((sipn!=0))
			{
			//trace("sub dims",sipn)
					if (sipn > 1)
					{
						for (i = 0; i < sipn; i++) 
								{
									//trace("add points")
									var ipt:InteractionPointObject = ptArray[i];
									var pt:InteractionPointObject = ptArray[0];
									
									sub_cO.x += ipt.position.x;
									sub_cO.y += ipt.position.y;
									sub_cO.z += ipt.position.z;
									
									/* //ONLY FOR ONE HAND
									if (pt.type == "palm")
									{
										cO.rotationX = RAD_DEG * Math.asin(pt.normal.x);
										cO.rotationY = RAD_DEG * Math.asin(pt.normal.y);
										cO.rotationZ = RAD_DEG * Math.asin(pt.normal.z);
									}*/
									
									//SIZE WIDTH HIEGHT DEPTH
									for (var q:uint = 0; q < i+1; q++) 
									{
									 if (i != q) 
									 { 
										var dx:Number = ipt.position.x - ptArray[q].position.x
										var dy:Number = ipt.position.y - ptArray[q].position.y
										var dz:Number = ipt.position.z - ptArray[q].position.z
										
										var abs_dx:Number = Math.abs(dx);
										var abs_dy:Number = Math.abs(dy);
										var abs_dz:Number = Math.abs(dz);
										
										// MAX SEPERATION BETWEEN A PAIR OF POINTS IN THE CLUSTER
										if (abs_dx > sub_cO.width) sub_cO.width = abs_dx;
										if (abs_dy > sub_cO.height) sub_cO.height = abs_dy;
										if (abs_dz > sub_cO.length) sub_cO.length = abs_dz;
									 }
									}
								 
								 
								 if ((pt) && (ipt))//&&(!pointList[i].holdLock)&&(!pointList[j1].holdLock)) //edit
									{
										var dxs:Number = pt.position.x - ipt.position.x;
										var dys:Number = pt.position.y - ipt.position.y;
										var dzs:Number = pt.position.z - ipt.position.z;

										// separation of group
										sub_cO.separationX += Math.abs(dxs);
										sub_cO.separationY += Math.abs(dys);
										sub_cO.separationZ += Math.abs(dzs);
										
										// rotation of group
										sub_cO.rotation += (calcAngle(dxs, dys)) //|| 0
										sub_cO.rotationX += (calcAngle(dzs, dys)); 
										sub_cO.rotationY += (calcAngle(dxs, dzs)); 
										sub_cO.rotationZ += (calcAngle(dxs, dys));
									}
							}
							// divide by subcluster pair count sipnk0 
							sub_cO.separationX *= sipnk0;
							sub_cO.separationY *= sipnk0;
							sub_cO.separationZ *= sipnk0;
							
							// divide by subcluster pair count sipnk0 
							sub_cO.rotation *= sipnk0;
							sub_cO.rotationX *= sipnk0;
							sub_cO.rotationY *= sipnk0;
							sub_cO.rotationZ *= sipnk0;
							
							sub_cO.radius = 0.5*Math.sqrt(sub_cO.width * sub_cO.width + sub_cO.height * sub_cO.height + sub_cO.length * sub_cO.length);//
							//divide by subcluster ip number sipnk 
							
							sub_cO.x *= sipnk;
							sub_cO.y *= sipnk; 
							sub_cO.z *= sipnk;
							
							//trace("sub cluster properties",sipnk)
							//trace("dim",sub_cO.ipn,sub_cO.ipnk,sub_cO.ipnk0, sub_cO.x,sub_cO.y,sub_cO.z)
					}
						
					else if (sipn == 1) 
					{
						sub_cO.x = ptArray[0].position.x;
						sub_cO.y = ptArray[0].position.y;
						sub_cO.z = ptArray[0].position.z;
						
						sub_cO.width = 15;
						sub_cO.height = 15;
						sub_cO.length = 15;
						sub_cO.radius = 50;
						
						sub_cO.separationX = 1;
						sub_cO.separationY = 1;
						sub_cO.separationZ = 1;
						
						// ONLY FOR ONE HAND
						if (ptArray[0].type == "palm")
						{
							sub_cO.rotationX = RAD_DEG * Math.asin(ptArray[0].normal.x);
							sub_cO.rotationY = RAD_DEG * Math.asin(ptArray[0].normal.y);
							sub_cO.rotationZ = RAD_DEG * Math.asin(ptArray[0].normal.z);
							sub_cO.rotation = sub_cO.rotationZ;
						}
						else 
						{
							sub_cO.rotationX = 0;
							sub_cO.rotationY = 0;
							sub_cO.rotationZ = 0;
							sub_cO.rotation = 0;
						}
						
						//trace("dim",sub_cO.ipn, sub_cO.x,sub_cO.y,sub_cO.z)
					}
				//trace(cO.width,cO.height,cO.length)
				
			}
			//trace("get ip dims");
				
		}
		
		// TAP POINTS
		public function find3DIPTapPoints():void
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
					var pt:InteractionPointObject = cO.iPointArray[i];

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
									
									for (var h:uint = 2; h < hist; h++) 
										{	
											if (Math.abs(pt.history[h].jolt.y) > tapThreshold) test = false;
										}
									if (test) {
										
										var gpt:GesturePointObject = new GesturePointObject();
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
									var test0:Boolean = true;
									
									for (var h0:uint = 2; h0 < hist; h0++) 
										{	
											if (Math.abs(pt.history[h0].jolt.x) > tapThreshold) test = false;
										}
									if (test0) {
										
										var gpt0:GesturePointObject = new GesturePointObject();
											gpt0.position = pt.position;
											gpt0.type = "x tap";
										cO.gPointArray.push(gpt0);
										
										trace("x tap-----scan clean", pt.history[0].jolt.x,pt.interactionPointID)
									}
								}
								
								if (Math.abs(pt.history[1].jolt.z) > tapThreshold) 
								{
									// CHECK PAST MAKE SURE HAVE NOT SET STATE FOR 10 FRAMES
									//STOP AMBULANCE CHASERS //start after hist 1
									var test1:Boolean = true;
									
									for (var h1:uint = 2; h1 < hist; h1++) 
										{	
											if (Math.abs(pt.history[h1].jolt.z) > tapThreshold) test = false;
										}
									if (test0) {
										
											var gpt1:GesturePointObject = new GesturePointObject();
												gpt1.position = pt.position;
												gpt1.type = "z tap";
											cO.gPointArray.push(gpt1);
											
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
		public function find3DIPHoldPoints():void
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
									var gpt:GesturePointObject = new GesturePointObject();
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
		public function find3DIPTransformation(index:int):void////type:String
		{
			//trace("motion transform kinemetric", cO.iPointArray.length, ipn,cO.ipn);
			var hist:int = 8;
			var hk:Number = 1 / hist;
		
			// GET SUBCLUSTER OBJECT
			var sub_cO:ipClusterObject = cO.subClusterArray[index];
			
			//GET TRANSFORMED IP ARRAY
			var ptArray:Vector.<InteractionPointObject> = cO.subClusterArray[index].iPointArray;
			
			// GET CONSTS
			var sipn:uint = sub_cO.ipn;
			var dipn:int = sub_cO.dipn;
			
			//trace("ip dim",sipn);
			
			// reset deltas
			sub_cO.dx = 0;
			sub_cO.dy = 0;
			sub_cO.dz = 0;	
				
			sub_cO.dtheta = 0;
			sub_cO.dthetaX = 0;
			sub_cO.dthetaY = 0;
			sub_cO.dthetaZ = 0;
									
			sub_cO.ds = 0;
			sub_cO.dsx = 0;
			sub_cO.dsy = 0;
			sub_cO.dsz = 0;
			
			//if(cO.history.length>8)trace("waht",sipn,cO.dipn,cO.history[hist].subClusterArray[index])
			
			var delta_ipn:int = 0;
			
			if ((cO.history.length > 5)&&(sub_cO.ipn!=0)) {//hist
				
				delta_ipn = Math.abs(sub_cO.dipn) + Math.abs(cO.history[1].subClusterArray[index].dipn) + Math.abs(cO.history[2].subClusterArray[index].dipn) + Math.abs(cO.history[3].subClusterArray[index].dipn) + Math.abs(cO.history[4].subClusterArray[index].dipn) ;
				//trace("---", sub_cO.dipn, cO.history[1].subClusterArray[index].dipn, cO.history[2].subClusterArray[index].dipn,cO.history[3].subClusterArray[index].dipn, cO.history[4].subClusterArray[index].dipn, "tot",delta_ipn)
				
				} else delta_ipn = 1;
			
			
			
			// dipn ==0 when no changes in inpn between frames
			if ((sipn!= 0)&&(cO.history[hist].subClusterArray[index]))//finger_cO&&(cO.dipn==0)&&(delta_ipn==0)
				{		
					
					//trace("t",ptArray[0].position.x,ptArray[0].history.length, cO.iPointArray2D[0].history.length,cO.iPointArray[0].history.length );
					var c_0:ipClusterObject = cO.history[0].subClusterArray[index];//finger_cO
					var c_1:ipClusterObject = cO.history[hist].subClusterArray[index];//finger_cO
						
					//trace("hist x---------------------------------------------",cO.subClusterArray[index].x,cO.history[0].subClusterArray[index].x, cO.history[6].subClusterArray[index].x)
					
							//trace("hist x",cO.finger_cO.x,cO.history[0].finger_cO.x, cO.history[6].finger_cO.x)
							//trace("hist rot",cO.finger_cO.rotation,cO.history[0].finger_cO.rotation, cO.history[2].finger_cO.rotation)
								
							//////////////////////////////////////////////////////////
							//CHANGE IN CLUSTER POSITION
							if ((c_1.x!= 0) && (c_0.x != 0)) 	sub_cO.dx = (c_0.x - c_1.x)*hk;
							if ((c_1.y != 0) && (c_0.y != 0)) 	sub_cO.dy = (c_0.y - c_1.y)*hk;
							if ((c_1.z != 0) && (c_0.z != 0)) 	sub_cO.dz = (c_0.z - c_1.z)*hk;
							//trace(cO.dx,cO.dy,cO.dz);
								
						
						if (sipn == 1)
							{
								// ROTATE //////////////////////////////////////////////////////////////////
								if (ptArray[0].type == "palm")
								{
									if ((c_1.rotation != 0) && (c_0.rotation != 0)) 	sub_cO.dtheta = (c_0.rotation- c_1.rotation) * hk;
									if ((c_1.rotationX != 0) && (c_0.rotationX != 0))	sub_cO.dthetaX = (c_0.rotationX- c_1.rotationX) * hk;
									if ((c_1.rotationY != 0) && (c_0.rotationY != 0))	sub_cO.dthetaY = (c_0.rotationY- c_1.rotationY) * hk;
									if ((c_1.rotationZ != 0) && (c_0.rotationZ != 0))	sub_cO.dthetaZ = (c_0.rotationZ - c_1.rotationZ) * hk;
								}
								else {
									sub_cO.dtheta = 0;
									sub_cO.dthetaX = 0;
									sub_cO.dthetaY = 0;
									sub_cO.dthetaZ = 0;
								}
								//trace(cO.dthetaX,pt.normal.x,pt.history[hist].normal.x);
							}
							
							else if (sipn > 1)
							{
								//////////////////////////////////////////////////////////
								// CHANGE IN SEPARATION
								if ((c_1.radius != 0) && (c_0.radius != 0)) 			sub_cO.ds = (c_0.radius - c_1.radius) * sck*hk;
								if ((c_1.separationX != 0) && (c_0.separationX != 0)) 	sub_cO.dsx = (c_0.separationX - c_1.separationX) * sck*hk;
								if ((c_1.separationY != 0) && (c_0.separationY != 0)) 	sub_cO.dsy = (c_0.separationY - c_1.separationY) * sck*hk;
								if ((c_1.separationZ != 0) && (c_0.separationZ != 0)) 	sub_cO.dsz = (c_0.separationZ - c_1.separationZ) * sck*hk;
								//trace("radius",c_0.radius, c_1.radius);
									
								//////////////////////////////////////////////////////////
								// CHANGE IN ROTATION
								if ((c_1.rotation != 0) && (c_0.rotation != 0))		sub_cO.dtheta = (c_0.rotation- c_1.rotation) * hk;
								if ((c_1.rotationX != 0) && (c_0.rotationX != 0)) 	sub_cO.dthetaX = (c_0.rotationX- c_1.rotationX) * hk;
								if ((c_1.rotationY != 0) && (c_0.rotationY != 0))	sub_cO.dthetaY = (c_0.rotationY- c_1.rotationY) * hk;
								if ((c_1.rotationZ != 0) && (c_0.rotationZ != 0))	sub_cO.dthetaZ = (c_0.rotationZ - c_1.rotationZ) * hk;
								//trace("roation",c_0.rotation, c_1.rotation, c_0.dtheta);
							}
							
							
									//NEED LIMITS FOR CLUSTER N CHANGE
									/*
									//LIMIT TRANLATE
									var trans_max_delta:Number = 30;
									
									if (Math.abs(sub_cO.dx) > trans_max_delta) 
									{
										if (sub_cO.dx < 0) sub_cO.dx = -trans_max_delta;
										if (sub_cO.dx > 0) sub_cO.dx = trans_max_delta;
									}
									if (Math.abs(sub_cO.dy) > trans_max_delta) 
									{
										if (sub_cO.dy < 0) sub_cO.dy = -trans_max_delta;
										if (sub_cO.dy > 0) sub_cO.dy = trans_max_delta;
									}
									if (Math.abs(sub_cO.dz) > trans_max_delta) 
									{
										if (sub_cO.dz < 0) sub_cO.dz = -trans_max_delta;
										if (sub_cO.dz > 0) sub_cO.dz = trans_max_delta;
									}
									
									
									//LMIT SCALE
									var sc_max_delta:Number = 0.02
									
									if (Math.abs(sub_cO.ds) > sc_max_delta)
									{
										if (sub_cO.ds < 0) sub_cO.ds = -sc_max_delta;
										if (sub_cO.ds > 0) sub_cO.ds = sc_max_delta;
									}
									if (Math.abs(sub_cO.dsx) > sc_max_delta)
									{
										if (sub_cO.dsx < 0) sub_cO.dsx= -sc_max_delta;
										if (sub_cO.dsx > 0) sub_cO.dsx = sc_max_delta;
									}
									if (Math.abs(sub_cO.dsy) > sc_max_delta)
									{
										if (sub_cO.dsy < 0) sub_cO.dsy = -sc_max_delta;
										if (sub_cO.dsy > 0) sub_cO.dsy = sc_max_delta;
									}
									if (Math.abs(sub_cO.dsz) > sc_max_delta)
									{
										if (sub_cO.dsz < 0) sub_cO.dsz = -sc_max_delta;
										if (sub_cO.dsz > 0) sub_cO.dsz = sc_max_delta;
									}
									
									//trace(sub_cO.dsx,sub_cO.dsy)
									
									// LIMIT ROTATE
									var rot_max_delta:Number = 50
									if (Math.abs(sub_cO.dtheta) > rot_max_delta)
									{
										if (sub_cO.dtheta < 0) sub_cO.dtheta = -rot_max_delta;
										if (sub_cO.dtheta > 0) sub_cO.dtheta = rot_max_delta;
									}
									if (Math.abs(sub_cO.dthetaX) > rot_max_delta)
									{
										if (sub_cO.dthetaX < 0) sub_cO.dthetaX = -rot_max_delta;
										if (sub_cO.dthetaX > 0) sub_cO.dthetaX = rot_max_delta;
									}
									if (Math.abs(sub_cO.dthetaY) > rot_max_delta)
									{
										if (sub_cO.dthetaY < 0) sub_cO.dthetaY = -rot_max_delta;
										if (sub_cO.dthetaY > 0) sub_cO.dthetaY = rot_max_delta;
									}
									if (Math.abs(sub_cO.dthetaZ) > rot_max_delta)
									{
										if (sub_cO.dthetaZ < 0) sub_cO.dthetaZ = -rot_max_delta;
										if (sub_cO.dthetaZ > 0) sub_cO.dthetaZ = rot_max_delta;
									}
									//trace("get diff");	
									*/
			}
		}
		
		
		public function find3DIPTranslate(index:int):void//type:String
		{
			//trace("motion transform kinemetric", cO.iPointArray.length, ipn,cO.ipn);
			var hist:int = 8;
			var hk:Number = 1 / hist;
			
			// Get subcluster
			var sub_cO:ipClusterObject = cO.subClusterArray[index];

			//GET TRANSFORMED IP ARRAY
			var ptArray:Vector.<InteractionPointObject> = sub_cO.iPointArray;
			
			var sipn:uint = sub_cO.ipn;
			var sdipn:uint = sub_cO.dipn;
			
			// reset deltas
			sub_cO.dx = 0;
			sub_cO.dy = 0;
			sub_cO.dz = 0;
				
			// dipn ==0 when no changes in inpn between frames
			if ((sipn!= 0)&&(cO.history[hist].finger_cO)&&(cO.dipn==0))//
				{
					//trace("t",ptArray[0].position.x,ptArray[0].history.length, cO.iPointArray2D[0].history.length,cO.iPointArray[0].history.length );
					var c_0:ipClusterObject = cO.history[0].finger_cO;
					var c_1:ipClusterObject = cO.history[hist].finger_cO;
						
							//trace("hist x",cO.finger_cO.x,cO.history[0].finger_cO.x, cO.history[6].finger_cO.x)
							//trace("hist rot",cO.finger_cO.rotation,cO.history[0].finger_cO.rotation, cO.history[2].finger_cO.rotation)
								
							//////////////////////////////////////////////////////////
							//CHANGE IN CLUSTER POSITION
							if ((c_1.x!= 0) && (c_0.x != 0)) 	sub_cO.dx = (c_0.x - c_1.x)*hk;
							if ((c_1.y != 0) && (c_0.y != 0)) 	sub_cO.dy = (c_0.y - c_1.y)*hk;
							if ((c_1.z != 0) && (c_0.z != 0)) 	sub_cO.dz = (c_0.z - c_1.z)*hk;
							//trace(cO.dx,cO.dy,cO.dz);
								
							//NEED LIMITS FOR CLUSTER N CHANGE
							//LIMIT TRANLATE
							var trans_max_delta:Number = 30;
									
							if (Math.abs(sub_cO.dx) > trans_max_delta) 
							{
								if (sub_cO.dx < 0) sub_cO.dx = -trans_max_delta;
								if (sub_cO.dx > 0) sub_cO.dx = trans_max_delta;
							}
							if (Math.abs(sub_cO.dy) > trans_max_delta) 
							{
								if (sub_cO.dy < 0) sub_cO.dy = -trans_max_delta;
								if (sub_cO.dy > 0) sub_cO.dy = trans_max_delta;
							}
							if (Math.abs(sub_cO.dz) > trans_max_delta) 
							{
								if (sub_cO.dz < 0) sub_cO.dz = -trans_max_delta;
								if (sub_cO.dz > 0) sub_cO.dz = trans_max_delta;
							}
							//trace("get diff");	
			}
		}
		
		
		public function Weave3DIPClusterData():void
		{
			var asc:int = 0;
			var asck:Number = 0;
			
			
			//BLEND INTO SINGLE CLUSTER
			/////////////////////////////////////////////////////////////////////////////////////////
			// loop for all sub clusters/////////////////////////////////////////////////////////////
			
			for (i = 0; i < cO.subClusterArray.length; i++) 
				{		
					// GET CLUSTER ANALYSIS FROM EACH SUBCLUSTER
					var sub_cO:ipClusterObject = cO.subClusterArray[i];

						// each dimension / property must be merged independently
						if (sub_cO.ipn>0)
						{
							asc++;
							//trace("weave ipcos",sub_cO.ipn);
									
							// recalculate cluster center
							// average over all ip subcluster subclusters 
							cO.x += sub_cO.x  
							cO.y += sub_cO.y
							cO.z += sub_cO.z
						
							// recalculate based on ip subcluster totals
							cO.width = sub_cO.width; // get max
							cO.height = sub_cO.height;// get max
							cO.length = sub_cO.length;// get max
							cO.radius = sub_cO.radius;// get max
										
							// recalculate based on ip subcluster totals
							cO.separation = sub_cO.separation;// get max
							cO.separationX = sub_cO.separationX;// get max
							cO.separationY = sub_cO.separationY;// get max
							cO.separationZ = sub_cO.separationZ;// get max
									
							// recalculate based on ip subcluster totals
							cO.rotation = sub_cO.rotation;// get max
							cO.rotationX = sub_cO.rotationX;// get max
							cO.rotationY = sub_cO.rotationY;// get max
							cO.rotationZ = sub_cO.rotationZ;// get max
							
							// map non zero deltas // accumulate 
							// perhaps find average 
							cO.dx += sub_cO.dx;
							cO.dy += sub_cO.dy;
							cO.dz += sub_cO.dz;	
								
							cO.dtheta += sub_cO.dtheta;
							cO.dthetaX += sub_cO.dthetaX;
							cO.dthetaY += sub_cO.dthetaY;
							cO.dthetaZ += sub_cO.dthetaZ;
													
							cO.ds += sub_cO.ds; // must not be affected by cluster chnage in radius
							cO.dsx += sub_cO.dsx;
							cO.dsy += sub_cO.dsy;
							cO.dsz += sub_cO.dsz;
							///////////////////////////////////////////////////////////////////////////////////////
							///////////////////////////////////////////////////////////////////////////////////////
						}
				}
				
				asck = 1 / asc;
				if (asc == 0) asck = 0; //DERR
				
				// AVERAGE CLUSTER POSITION
				//cO.x *= asck;  
				//cO.y *= asck;
				//cO.z *= asck;
				
				
				//trace("weave",cO.x,cO.y,cO.z, cO.width,cO.height)
				
				
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