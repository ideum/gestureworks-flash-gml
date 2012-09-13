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
	
	import com.gestureworks.objects.PointObject;
	import com.gestureworks.objects.DimensionObject;
	import com.gestureworks.objects.ClusterObject;
		
	public class KineMetric
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
		private var cO:ClusterObject;
		//public var pointList:Object;
		//public var pointList:Array;
		
		public var pointList:Vector.<PointObject>;
		
		
		private var gml:XMLList;
		
		private var key:String;
		
		// number in group
		private var N:int = 0;
		private var N1:int = 0;
		private var k0:Number  = 0;
		private var k1:Number  = 0;
		private var i:uint = 0;
		private var j:uint = 0;
		private var mc:int = 0;
		
		// sub cluster vars
		public var LN:int = 0; //locked touch points
		public var hold_x:Number = 0;
		public var hold_y:Number = 0;

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
		public var c_emx:Number = 0; // mean cluster position (used in orientation -thumb)
		public var c_emy:Number = 0; //mean cluster position (used in orientation -thumb)
		
		public var thumbID:int;
		public var orient_dx:Number = 0; // cluster orientation vector
		public var orient_dy:Number = 0; // cluster orientation vector
		private var hand:int = 0; // 0 left, 1 right//
		
		private var pivot_dtheta:Number = 0;
		
		private var path_data:Array;
		
		// velocity // first order change in cluster properties wrt
		public	var c_dx:Number = 0; // cluster position change x
		public	var c_dy:Number = 0; // cluster position change y
		private	var c_dr:Number = 0; // cluster radius change
		private var c_dw:Number = 0; // cluster width change
		private	var c_dh:Number = 0; // cluster height change
		public var c_ds:Number = 0; // cluster scale change
		public var c_dsx:Number = 0;  // custer horiz scale change
		public var c_dsy:Number = 0; //custer vert scale change
		public var c_dtheta:Number = 0; // cluster angle change
		
		// acceleration //second order change in cluster properties wrt time
		public	var c_ddx:Number = 0; 
		public	var c_ddy:Number = 0;
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
		
		public function KineMetric(_id:int) 
		{
			touchObjectID = _id;
			init();
		}
		
		public function init():void
		{
			ts = GestureGlobals.gw_public::touchObjects[touchObjectID]; // need to find center of object for orientation and pivot
			cO = ts.cO;
			//N = ts.cO.n;
			//pointList = cO.pointArray;
			path_data = new Array();
		
			if (ts.trace_debug_mode) trace("init cluster kinemetric");
		}
		
		public function findCluster():void
		{
				//if (ts.trace_debug_mode) trace("find cluster..............................",N);
				
				// get number of points in cluster
				N = ts.cO.n;

				if (N) 
				{
					N1 = N - 1;
					k0 = 1 / N;
					k1 = 1 / N1;
					if (N == 0) k1 = 0;
					pointList = cO.pointArray;
					mc = pointList[0].moveCount;
				}
				
				//else resetVars();
				//return
		}
		
		
		public function resetVars():void {

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
			
			// sub cluster analysis
			hold_x = 0;
			hold_y = 0;
			//c_hold_n = LN;
			
			pivot_dtheta = 0;
			
			path_data = new Array();
			
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
		}
		
		public function pushClusterObjectProperties():void
		{
			///////////////////////////////////////////////////////////////////////////////////
			// puts kenemetric results into cluster object
			///////////////////////////////////////////////////////////////////////////////////
			
			//////////////////////////
			//fundamental properties
			//////////////////////////
			//ts.cO.n = N;
			cO.x = c_px;
			cO.y = c_py;
			cO.width = c_w;
			cO.height = c_h;
			cO.radius = c_r/2;
			cO.separationX = c_sx;
			cO.separationY = c_sy;
			cO.rotation = c_theta;
			cO.orientation =  c_o;
			cO.thumbID = thumbID;
			//ts.cO.hand = hand;
			cO.mx = c_emx;
			cO.my = c_emy;
			
			//////////////////////////////////
			////////////////////////////////////
			cO.orient_dx = orient_dx;
			cO.orient_dy = orient_dy;
			cO.pivot_dtheta = pivot_dtheta;
		
			/////////////////////////
			// first diff
			/////////////////////////
			cO.dtheta = c_dtheta;
			cO.dx = c_dx;
			cO.dy = c_dy;
			//cO.dw = c_dw;	
			//cO.dh = c_dh;
			//cO.dr = c_dr;
			cO.ds = c_ds;
			cO.dsx = c_dsx;
			cO.dsy = c_dsy;
			
			////////////////////////
			// second diff
			////////////////////////
			cO.ddx = c_ddx;
			cO.ddy = c_ddy;
			//cO.ddw = c_ddw;	
			//cO.ddh = c_ddh;
			//cO.ddr = c_ddr;
			//cOdds = c_dds;
			//cO.ddsx = c_ddsx;
			//cO.ddsy = c_ddsy;
			//cO.ddtheta = c_ddtheta;
			
			////////////////////////////
			// sub cluster analysis
			////////////////////////////
			cO.hold_x = hold_x;
			cO.hold_y = hold_y;
			cO.hold_n = LN;
			
			cO.path_data = path_data
			///////////////////////////
			
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
					
					
					if ((N == 1)&&(pointList[0].history[0])) 
					{
						c_px = pointList[0].history[0].x;
						c_py = pointList[0].history[0].y;
						c_emx = pointList[0].history[0].x;
						c_emy = pointList[0].history[0].y;
					}
					
					else if (N > 1)
						{	
						for (i = 1; i < N; i++)
						{
							for (var j1:int = 0; j1 < N; j1++)
							{
								if ((i != j1)&&(pointList[i].history[0]) && (pointList[j1].history[0]))//&&(!pointList[i].holdLock)&&(!pointList[j1].holdLock))//edit
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
										
										// mean point position
										c_emx += pointList[i].history[0].x;
										c_emy += pointList[i].history[0].y;
									}
							}
							
							
							//separation
							if ((pointList[0].history[0]) && (pointList[i].history[0]))//&&(!pointList[i].holdLock)&&(!pointList[j1].holdLock)) //edit
							{
								var dxs:Number = pointList[0].history[0].x - pointList[i].history[0].x;
								var dys:Number = pointList[0].history[0].y - pointList[i].history[0].y;
								//var ds:Number  = Math.sqrt(dx * dx + dy * dy);

								// separation of group
								//c_s += ds;
								c_sx += Math.abs(dxs);
								c_sy += Math.abs(dys);
								
								// rotation of group
								c_theta += (calcAngle(dxs, dys)) || 0
							}
						}
						//c_s *= k0;
						c_sx *= k0;
						c_sy *= k0;
						c_theta *= k0;
						c_emx *= k0;
						c_emy *= k0;
					}
		}
		
		/*
		public function findInstSeparation():void
		{
						c_sx = 0;
						c_sy = 0;
							
							if (N > 1)
							{
								for (var j1:int = 1; j1 < N; j1++)
								{
										if ((pointList[0].history[0]) && (pointList[j1].history[0]))//&&(!pointList[i].holdLock)&&(!pointList[j1].holdLock)) //edit
										{
											var dx:Number = Math.abs(pointList[0].history[0].x - pointList[j1].history[0].x);
											var dy:Number = Math.abs(pointList[0].history[0].y - pointList[j1].history[0].y);
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
		}*/
		/*
		public function findInstAngle():void
		{
							if ((N == 1)&&(pointList[0].history[0])) c_theta = 0
							
							if (N > 1)
							{
								for (var j1:int = 1; j1 < N; j1++)
								{
									if ((pointList[0].history[0]) && (pointList[j1].history[0]))//&&(!pointList[i].holdLock)&&(!pointList[j1].holdLock)) //edit 
										{
										//trace("dim",N);
										var dx:Number = pointList[0].history[0].x - pointList[j1].history[0].x
										var dy:Number = pointList[0].history[0].y - pointList[j1].history[0].y
										// rotation of group
										c_theta += (calcAngle(dx, dy)) || 0
									}
									c_theta *= k0;
								}
							}
							else c_theta = 0;
		}*/
		
		public function findPath():void 
		{
			//trace("hitory length",pointList[0].history.length)
			var path:Array = new Array();
			
			for (i = 0; i < pointList[0].history.length; i++)
				{
				//trace("--",pointList[0].history[i].x, pointList[0].history[i].y)
				path.push(new Point(pointList[0].history[i].x,pointList[0].history[i].y));
				}
			path_data = path; 
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
											hold_x += pointList[i].history[0].x;
											hold_y += pointList[i].history[0].y;
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
							hold_x *= 1/LN//k0;
							hold_y *= 1 / LN//k0;
							}
						}
						else {
							hold_x = 0;
							hold_y = 0;
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
				c_dx = pointList[0].DX;
				c_dy = pointList[0].DY;
				c_ds = 0;
				//c_dsx = 0;
				//c_dsy = 0;
				//c_dtheta = 0;
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
									c_dx += pointList[i].DX;
									c_dy += pointList[i].DY;
							
									
									//c_dx += pointList[i].dx;
									//c_dy += pointList[i].dy;
									
									//trace(pointList[i].moveCount)

									//if ((N > i + 1) && (pointList[0].history[mc]) && (pointList[i + 1].history[mc]))
									if ((N > i + 1) && (pointList[0].history.length >
									mc) && (pointList[i + 1].history.length>mc))
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
										var theta0:Number = calcAngle((pointList[0].history[0].x - pointList[i+1].history[0].x), (pointList[0].history[0].y - pointList[i+1].history[0].y));
										var theta1:Number = calcAngle((pointList[0].history[mc].x - pointList[i+1].history[mc].x), (pointList[0].history[mc].y - pointList[i+1].history[mc].y));
											
										if ((theta0 != 0) && (theta1 != 0)) 
											{
											if (Math.abs(theta0 - theta1) > 180) dtheta = 0
											else dtheta = (theta0 - theta1);
											}
										else dtheta = 0;
													
										c_dtheta += dtheta;
										
										}
								}
								
								// FIND C_DSX AND C_DSY AGGREGATE THEN AS A LAST STEP FIND THE SQUARE OF THE DISTANCE BETWEEN TO GET C_DS
								//c_ds = Math.sqrt(c_dsx*c_dsx + c_dsy*c_dsy)
								
								c_dx *= k0;
								c_dy *= k0;
								c_ds = (Math.sqrt(sx * sx  +  sy * sy) - Math.sqrt(sx_mc * sx_mc  + sy_mc * sy_mc))*k1;
								//c_dsx *= k1;
								//c_dsy *= k1;
								c_dtheta *= k1;
								
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
					
						c_dx = 0;
						c_dy = 0;
					
					if (N == 1) 
						{
							c_dx = pointList[0].DX;
							c_dy = pointList[0].DY;
						}
					else if (N > 1)
					{
						for (i = 0; i < N; i++) 
						{
								if (pointList[i])//&&(!pointList[i].holdLock))// edit
								{
									// SIMPLIFIED DELTA
									c_dx += pointList[i].DX;
									c_dy += pointList[i].DY;
									//c_dx += pointList[i].dx;
									//c_dy += pointList[i].dy;
								}	
						}
						c_dx *= k0;
						c_dy *= k0;
					}
					//	trace("drag calc kine",c_dx,c_dy);
		}
		
		public function findMeanInstSeparation():void
		{
					//////////////////////////////////////////////////////////////////////////////////////////////////////////////
					// cluster separation //OPERATION
					//////////////////////////////////////////////////////////////////////////////////////////////////////////////
					// finds the change in the separation of the cluster between the current frame and a previous frame in history
					

					c_ds = 0;
					//c_dsx = 0;
					//c_dsy = 0;
					
					if (N > 1)
					{	
						for (i = 0; i < N; i++) 
						{
							//if ((N > i + 1) && (pointList[0].history[mc]) && (pointList[i + 1].history[mc]))
							if ((N>i+1)&&(pointList[0].history.length>mc) && (pointList[i + 1].history.length>mc))
							{		
								// SIMPLIFIED DELTA
								c_ds += (Math.sqrt((pointList[0].history[0].x - pointList[i + 1].history[0].x) * (pointList[0].history[0].x - pointList[i + 1].history[0].x) + (pointList[0].history[0].y - pointList[i + 1].history[0].y) * (pointList[0].history[0].y - pointList[i + 1].history[0].y)) - Math.sqrt((pointList[0].history[mc].x - pointList[i + 1].history[mc].x) * (pointList[0].history[mc].x - pointList[i + 1].history[mc].x) + (pointList[0].history[mc].y - pointList[i + 1].history[mc].y) * (pointList[0].history[mc].y - pointList[i + 1].history[mc].y)))
							}
						}
					//c_dsx = c_ds;
					//c_dsy = c_ds;
					//c_dsx = (sx - sx_mc)*k1;
					//c_dsy = (sy - sy_mc)*k1;	
						
					c_ds *= k1;	
					}
		}
		public function findMeanInstSeparationXY():void//Point
		{
					//////////////////////////////////////////////////////////////////////////////////////////////////////////////
					// cluster separation //OPERATION
					//////////////////////////////////////////////////////////////////////////////////////////////////////////////
					// finds the change in the separation of the cluster between the current frame and a previous frame in history
						//var pt_sepXY:Point = new Point();
						
						c_dsx = 0;
						c_dsy = 0;
						
						if (N > 1)
						{		
								for (i = 0; i < N; i++) 
								{
										//if ((N > i + 1) && (pointList[0].history[mc]) && (pointList[i + 1].history[mc]))
										if ((N>i+1)&&(pointList[0].history.length>=mc) && (pointList[i + 1].history.length>=mc))
										{		
										// SIMPLIFIED DELTA 
										//c_dsx += (pointList[0].history[0].x - pointList[i + 1].history[0].x) - (pointList[0].history[h].x - pointList[i + 1].history[h].x)*h0;
										//c_dsy += (pointList[0].history[0].y - pointList[i + 1].history[0].y) - (pointList[0].history[h].y - pointList[i + 1].history[h].y) * h0;
										//c_dsx += (pointList[0].history[0].x - pointList[i + 1].history[0].x) - (pointList[0].history[mc].x - pointList[i + 1].history[mc].x);
										//c_dsy += (pointList[0].history[0].y - pointList[i + 1].history[0].y) - (pointList[0].history[mc].y - pointList[i + 1].history[mc].y);
										}
								}
							
								/*
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
							}*/
						}
						//pt_sepXY.x = c_dsx;
						//pt_sepXY.y = c_dsy;
						//////////////////////////////////////////////////////////////////////////////////////////////////////
			//return pt_sepXY;
		}
		
		/*
		public function findMeanInstPosition():void
		{
			/////////////////////// mean center of cluster // OPERATION /////////////////////////////////////////
			c_emx = 0;
			c_emy = 0;
							
				for (i = 0; i < N; i++) 
				{
					if (pointList[i].history[0])//&&(!pointList[i].holdLock))//edit
					{
						c_emx += pointList[i].history[0].x;
						c_emy += pointList[i].history[0].y;
					}
				}
					
			c_emx *= k0;
			c_emy *= k0;
		}
		*/
		
		
		
		public function findMeanInstRotation():void
		{
					//////////////////////////////////////////////////////////////////////////////////////////////////////////////
					// cluster roation // OPERATION
					//////////////////////////////////////////////////////////////////////////////////////////////////////////////
					// finds the change in the rotation of the cluster between the current frame and a previous frame in history

						c_dtheta = 0;
						
						if(N>1)
						{
						for (i = 0; i < N; i++) 
						{
								//if ((N > i + 1) && (pointList[0].history[mc]) && (pointList[i + 1].history[mc]))
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
											
									c_dtheta += dtheta;
								}
						}
						/*
						////////////// apply delta thresholds for change in rotation///////////////////////////
						if (rotThresholds)
						{
							var deltat:Number = Math.abs(c_dtheta);
									
							if ((deltat > theta_threshold_min) && (deltat < theta_threshold_max)) c_dtheta *= k1;
							else c_dtheta = 0;
						}
						else c_dtheta *= k1;
						////////////////////////////////////////////////////////////////////////////////////////
						*/
						c_dtheta *= k1;
						}
		}
		
		public function findMeanInstAcceleration():void
		{
					//////////////////////////////////////////////////////////////////////////////////////////////////////////////
					// cluster acceleration x y // OPERATION
					//////////////////////////////////////////////////////////////////////////////////////////////////////////////
					
						c_ddx = 0;
						c_ddy = 0;
						
						for (i = 0; i < N; i++) 
						{
							if (pointList[i].history[1])//&&(!pointList[i].holdLock))//edit
							{
								// SIMPLIFIED DELTAS
								// second diff of x anf y wrt t
								c_ddx += pointList[i].history[0].dx - pointList[i].history[1].dx;
								c_ddy += pointList[i].history[0].dy - pointList[i].history[1].dy;
							}
						}
						
						c_ddx *= k0;
						c_ddy *= k0;
					
					/////////////////////////////////////////////////////////////////////////////////////	
		}
		
		
		
		//public function findMeanTemporalVelocity(t:int):Point
		public function findMeanTemporalVelocity(t:int):Object
		{
		/////////////////////// mean velocity of cluster // OPERATION /////////////////////////////////////////
					
			//var c_etm_vel:Point = new Point();
				//c_etm_vel.x = 0;
				//c_etm_vel.y = 0;
				
			var c_etm_vel:Object = new Object();
				c_etm_vel["etm_dx"] = 0;
				c_etm_vel["etm_dy"] = 0;
							
			var t0:Number = 1 /t;
					
			for (i = 0; i < N; i++) 
				{
					if (pointList[i].history[t])//&&(!pointList[i].holdLock))//edit
					{
					for (j = 0; j < t; j++) 
						{
						//c_etm_vel.x += pointList[i].history[j].dx;
						//c_etm_vel.y += pointList[i].history[j].dy;
						
						c_etm_vel["etm_dx"] += pointList[i].history[j].dx;
						c_etm_vel["etm_dy"] += pointList[i].history[j].dy;
						//trace(pointList[i].history[j].dx,pointList[i].history[j].dy)
						}
					}
			}
					
			//trace("mean temp velocity", c_etm_vel.x, c_etm_vel.y);
			
			//c_etm_vel.x *= k0 * t0;
			//c_etm_vel.y *= k0 * t0;
			c_etm_vel["etm_dx"] *= k0 * t0;
			c_etm_vel["etm_dy"] *= k0 * t0;

			return c_etm_vel;
		} 
		
		//public function findMeanTemporalAcceleration(t:int):Point
		public function findMeanTemporalAcceleration(t:int):Object
		{
			//////////////////////////////////////////////////////////////////////////////////////////////////////////////
			// cluster acceleration x y // OPERATION
			//////////////////////////////////////////////////////////////////////////////////////////////////////////////
					
			//var c_etm_accel:Point = new Point();
				//c_etm_accel.x = 0;
				//c_etm_accel.y = 0;
				
			var data:Object = new Object();
				data["etm_ddx"] = 0;
				data["etm_ddy"] = 0;
				
			var t0:Number = 1 /t;
						
				for (i = 0; i < N; i++) 
					{
					if (pointList[i].history[t])//&&(!pointList[i].holdLock))//edit
						{
							// SIMPLIFIED DELTAS
							// second diff of x anf y wrt t
							for (j = 0; j < t; j++) 
							{
								//c_etm_accel.x += pointList[i].history[j].dx - pointList[i].history[j+1].dx;
								//c_etm_accel.y += pointList[i].history[j].dy - pointList[i].history[j + 1].dy;
								data["etm_ddx"] += pointList[i].history[j].dx - pointList[i].history[j+1].dx;
								data["etm_ddy"] += pointList[i].history[j].dy - pointList[i].history[j+1].dy;
							}
						}
					}
						
					//c_etm_accel.x *= k0 * t0;
					//c_etm_accel.y *= k0 * t0;
					data["etm_ddx"] *= k0 * t0;
					data["etm_ddy"] *= k0 * t0;
						
				return data;
		}
		
		public function findInstOrientation():void 
		{
				var handArray:Array = new Array();
				var maxDist:Number = 0;
				var maxAngle:Number = 0;
				var dist:Number = 0;
				var angle:Number = 180;
				
				//var pt_orient:Point = new Point();
						
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
			//return pt_orient;
		}
		
		public function findInstPivot(pivot_threshold:Number):void
		{	
			//var pivot_dtheta:Number = 0;
			var pivot_threshold:Number = 0//ts.gO.pOList[key].cluster_rotation_threshold;	
			var x_c:Number = 0
			var y_c:Number = 0
			
			pivot_dtheta = 0
					
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
									if (Math.abs(theta_diff) > pivot_threshold)
									{	
										// weighted effect
										//pivot_dtheta = theta_diff //* Math.pow(pdist, 2.2);
										pivot_dtheta = theta_diff*Math.pow(pdist, 2);
										
										c_px = pointList[0].history[0].x;
										c_py = pointList[0].history[0].y;
									}
									else pivot_dtheta = 0; 
									
									
									//pivot_dtheta = theta_diff * Math.pow(pdist, 2.2);
								
									//trace("c_dtheta",c_dtheta, dx, dy, ds)
								}
			//trace("pivot", pivot_dtheta)		
			//return pivot_dtheta;			
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