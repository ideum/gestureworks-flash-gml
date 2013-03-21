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
	import com.gestureworks.objects.ClusterObject;
	
	import com.leapmotion.leap.events.LeapEvent;
	import com.leapmotion.leap.LeapMotion;
	
	import com.leapmotion.leap.*;
	import com.leapmotion.leap.events.*;
	import com.leapmotion.leap.util.*;
	
	
		
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
		public var pointList:Vector.<PointObject>;
		
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
		
		
		private var fn:uint = 0;
		private var rhfn:uint = 0;
		private var lhfn:uint = 0;
		
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
				
				// get number of points in cluster
				N = ts.cO.n;
				LN = ts.cO.hold_n

				if (N) 
				{
					N1 = N - 1;
					k0 = 1 / N;
					k1 = 1 / N1;
					if (N == 0) k1 = 0;
					pointList = cO.pointArray;
					mc = pointList[0].moveCount;
				}
				
				// motion points
				fn = ts.cO.fn
				
				//trace("total fingers", fn)
		}
		
		public function resetCluster():void {

			cO.x = 0;
			cO.y = 0;
			cO.z = 0;//-
			cO.width = 0;
			cO.height = 0;
			cO.length = 0;//-
			cO.radius = 0;
			cO.separationX = 0;
			cO.separationY = 0;
			cO.separationZ = 0;//-
			cO.rotation = 0;
			cO.rotationX = 0;//-
			cO.rotationY = 0;//-
			cO.rotationZ = 0;//-
			
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
			cO.orient_dz = 0;//-
			cO.pivot_dtheta = 0;
		
			/////////////////////////
			// first diff
			/////////////////////////
			cO.dtheta = 0;
			cO.dx = 0;
			cO.dy = 0;
			cO.dz = 0;//-
			cO.ds = 0;
			cO.dsx = 0;
			cO.dsy = 0;
			cO.dsz = 0;//-
			cO.etm_dx = 0;
			cO.etm_dy = 0;
			cO.etm_dz = 0;//-
			
			////////////////////////
			// second diff
			////////////////////////
			cO.ddx = 0;
			cO.ddy = 0;
			cO.ddz = 0;//-
			
			cO.etm_ddx = 0;
			cO.etm_ddy = 0;
			cO.etm_ddz = 0;//-
			
			////////////////////////////
			// sub cluster analysis
			////////////////////////////
			cO.hold_x = 0;
			cO.hold_y = 0;
			cO.hold_z = 0;//-
			cO.hold_n = 0;
			
			//accelerometer
			//cO.ax =0
			//cO.ay =0
			//cO.az =0
			//cO.atheta =0
			//cO.dax =0
			//cO.day =0
			//cO.daz =0
			//cO.datheta =0
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
					
					
					
					if ((N == 1)&&(pointList[0].history[0])) 
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
								if ((i != j1)&&(pointList[i].history[0]) && (pointList[j1].history[0]))//&&(!pointList[i].holdLock)&&(!pointList[j1].holdLock))//edit
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
							if ((pointList[0].history[0]) && (pointList[i].history[0]))//&&(!pointList[i].holdLock)&&(!pointList[j1].holdLock)) //edit
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
				/*
				c_dx = pointList[0].DX;
				c_dy = pointList[0].DY;
				c_ds = 0;
				*/
				cO.dx = pointList[0].DX;
				cO.dy = pointList[0].DY;
				//cO.ds = 0;
				//cO.dsx = 0;
				///cO.dsy = 0;
				//cO.dtheta = 0;
				//trace("cluster- porcessing", c_dx,c_dy);
			}
				else if (N > 1)
							{
							
							var sx:Number = 0;
							var sy:Number = 0;
							var sx_mc:Number = 0;
							var sy_mc:Number = 0;
								
								for (i = 0; i < N; i++) 
								{	
									// translate
									//c_dx += pointList[i].DX;
									//c_dy += pointList[i].DY;
									
									cO.dx += pointList[i].DX;
									cO.dy += pointList[i].DY;


									//if ((N > i + 1) && (pointList[0].history[mc]) && (pointList[i + 1].history[mc]))
									if ((N > i + 1) && (pointList[0].history.length > mc) && (pointList[i + 1].history.length>mc))
										{		
										// scale 
										sx += pointList[0].history[0].x - pointList[i + 1].history[0].x;
										sy += pointList[0].history[0].y - pointList[i + 1].history[0].y;
										sx_mc += pointList[0].history[mc].x - pointList[i + 1].history[mc].x;
										sy_mc += pointList[0].history[mc].y - pointList[i + 1].history[mc].y;
								
										//c_ds +=  (Math.sqrt(sx * sx  +  sy * sy) - Math.sqrt(sx_mc * sx_mc  + sy_mc * sy_mc))
										//c_dsx += sx - sx_mc;
										//c_dsy += sy - sy_mc;
										//c_ds += (c_dsx  + c_dsy );
										//c_ds += Math.sqrt((c_dsx * c_dsx) + (c_dsy * c_dsy));
										
										//c_ds += (Math.sqrt((pointList[0].history[0].x - pointList[i + 1].history[0].x) * (pointList[0].history[0].x - pointList[i + 1].history[0].x) + (pointList[0].history[0].y - pointList[i + 1].history[0].y) * (pointList[0].history[0].y - pointList[i + 1].history[0].y)) - Math.sqrt((pointList[0].history[mc].x - pointList[i + 1].history[mc].x) * (pointList[0].history[mc].x - pointList[i + 1].history[mc].x) + (pointList[0].history[mc].y - pointList[i + 1].history[mc].y) * (pointList[0].history[mc].y - pointList[i + 1].history[mc].y)))
										//c_dsx += (pointList[0].history[0].x - pointList[i + 1].history[0].x) - (pointList[0].history[h].x - pointList[i + 1].history[h].x);
										//c_dsy += (pointList[0].history[0].y - pointList[i + 1].history[0].y) - (pointList[0].history[h].y - pointList[i + 1].history[h].y);
					
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
													
										//c_dtheta += dtheta;
										cO.dtheta += dtheta;
										
										}
								}
								
								// FIND C_DSX AND C_DSY AGGREGATE THEN AS A LAST STEP FIND THE SQUARE OF THE DISTANCE BETWEEN TO GET C_DS
								//c_ds = Math.sqrt(c_dsx*c_dsx + c_dsy*c_dsy)
								
								/*
								c_dx *= k0;
								c_dy *= k0;
								c_ds = (Math.sqrt(sx * sx  +  sy * sy) - Math.sqrt(sx_mc * sx_mc  + sy_mc * sy_mc))*k1;
								//c_dsx *= k1;
								//c_dsy *= k1;
								c_dtheta *= k1;
								*/
								cO.dx *= k0;
								cO.dy *= k0;
								cO.ds = (Math.sqrt(sx * sx  +  sy * sy) - Math.sqrt(sx_mc * sx_mc  + sy_mc * sy_mc))*k1*sck;
								//c_dsx *= k1;
								//c_dsy *= k1;
								cO.dtheta *= k1;
								
				}
							//trace("transfromation",c_dx,c_dy, c_ds,c_dtheta)
		}
		
		
		
		/////////////////////////////////
		// sensor motion analysis
		/////////////////////////////////
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
		/////////////////////////////////
		// 3d motion analysis
		/////////////////////////////////
		public function findMeanInst3DMotionTransformation():void
		{
			
		//trace("motion kinemetric");
		var frame:Frame = cO.motionArray;
		
		trace("total hands", cO.hn);
		trace("total fingers", cO.fn);
		
				trace("--frame----------------------------------");
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
			
				if ( frame.hands.length != 0 )
				{
					
					trace("--hand--");
					// Get the first hand
					var hand:Hand = frame.hands[ 0 ];
					
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
						// Calculate the hand's average finger tip position
						for each ( var finger:Finger in fingers )
						{
							
						trace("----finger--");	
							// update motion points in cluster
							trace("xyz", finger.tipPosition );
							trace("length", finger.length);
							trace("width", finger.width);
							
						}	
					}
					
					
				}
			
		}
		
		//////////////////////////////////////////////////////////////////////////////
		/////////////////////////////////////////////////////////////////////////////
		
		
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
		
		//public function findMeanTemporalAcceleration(t:int):Point
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
				
				if(opposite > 0) return adjacent > 0 ? 360 + Math.atan(opposite / adjacent) * RAD_DEG : 180 - Math.atan(opposite / -adjacent) * RAD_DEG ;
				else return adjacent > 0 ? 360 - Math.atan( -opposite / adjacent) * RAD_DEG : 180 + Math.atan( opposite / adjacent) * RAD_DEG ;
				
				return 0;
		}
	}
}