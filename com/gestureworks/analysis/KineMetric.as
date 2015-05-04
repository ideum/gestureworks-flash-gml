////////////////////////////////////////////////////////////////////////////////
//
//  IDEUM
//  Copyright 2011-2015 Ideum
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
	import com.gestureworks.core.GestureWorks;
	import com.gestureworks.core.gw_public;
	import com.gestureworks.interfaces.ITouchObject3D;
	import com.gestureworks.interfaces.ITouchObject;
	import com.gestureworks.managers.InteractionPointHistories;
	import com.gestureworks.objects.TouchPointObject;
	import com.gestureworks.objects.MotionPointObject;
	import com.gestureworks.objects.InteractionPointObject;
	import com.gestureworks.objects.GesturePointObject;
	
	import com.gestureworks.objects.ClusterObject;
	import com.gestureworks.objects.ipClusterObject;
	import com.gestureworks.managers.InteractionPointTracker;
	
	//import com.gestureworks.events.GWEvent;
	import com.gestureworks.events.GWGestureEvent;
	import com.gestureworks.core.CoreSprite; 
	import com.gestureworks.core.TouchSprite; 
	import com.gestureworks.core.TouchMovieClip; 
	
	import flash.geom.Vector3D;
	import flash.geom.Utils3D;
	import flash.geom.Point;
	import flash.utils.*;
		
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
		private var mcO:ipClusterObject //= new ipClusterObject(); 	//MOTION SUPER
		private var tcO:ipClusterObject //= new ipClusterObject(); 	//TOUCH SUPER
		private var scO:ipClusterObject //= new ipClusterObject(); 	//SENSOR SUPER
		
		private var iPointClusterList:Dictionary;
		
		private var i:uint = 0;
		private var j:uint = 0;
		
		///////////////////////////////////////////////////////////
		//SUPER CLUSTER POINT TOTALS
		public var N:uint = 0;
		private var N1:uint = 0;
		private var k0:Number  = 0;
		private var k1:Number  = 0;
		
		
		//////////////////
		//SENSOR point total
		public var spn:uint = 0;
		
		
		////////////////////////////////////////////////////////////
		// TOUCH POINT TOTALS
		public var tpn:uint = 0;
						//public var LN:uint = 0; //locked touch points
		private var tpn1:uint = 0;
		private var tpnk0:Number  = 0;
		private var tpnk1:Number  = 0;
		private var mc:uint = 0; //MOVE COUNT
		
		private var rk:Number = 0.4; // rotation const
		private var sck:Number = 0.0044;// separate base scale const
		private var pvk:Number = 0.00004;//pivot base const
		
		///////////////////////////////////////////////////////
		// INTERACTION POINT TOTALS
		private var ipn:uint = 0;
		private var dipn:int = 0;
		private var ipnk:Number = 0;
		private var ipnk0:Number = 0;
		
		//TAP COUNTS TO BE MOVED
		private var mxTapID:uint = 0;
		private var myTapID:uint = 0;
		private var mzTapID:uint = 0;
		
		private var mHoldID:uint = 0;
		
		private var gs:CoreSprite;
		
		private var sw:int
		private var sh:int
		
		//hand config object
		private var handConfig:Object = new Object();
		
		
		// min max leap raw values
		// NOTE MOTION POINT SENSITIVITY TO PINCH/TRIGGER/ CONSTS AS SHOULD BE RELATIVE??????
		// AND HIT TEST
		private var minX:Number //=-220//180 
		private var maxX:Number //=220//180
		private var minY:Number //=350//270 
		private var maxY:Number //=120//50//-75
		private var minZ:Number //=350//270 
		private var maxZ:Number //=120//50//-75
		
		public static var hitTest3D:Function;	
		
		public function KineMetric(_id:int) 
		{
			//trace("KineMetric::constructor");
			
			touchObjectID = _id;
			init();
		}
		
		public function init():void
		{
			//trace("KineMetric::init");
			gs = GestureGlobals.gw_public::core;
			ts = GestureGlobals.gw_public::touchObjects[touchObjectID]; // need to find center of object for orientation and pivot
			cO = GestureGlobals.gw_public::clusters[touchObjectID];
			iPointClusterList = GestureGlobals.gw_public::iPointClusterLists[touchObjectID];
			
			sw = GestureWorks.application.stageWidth
			sh = GestureWorks.application.stageHeight;
			
			//remove as will be on device server
			minX = GestureGlobals.gw_public::leapMinX;
			maxX = GestureGlobals.gw_public::leapMaxX;
			minY = GestureGlobals.gw_public::leapMinY;
			maxY = GestureGlobals.gw_public::leapMaxY;
			minZ = GestureGlobals.gw_public::leapMinZ;
			maxZ = GestureGlobals.gw_public::leapMaxZ;
			
			if (ts.traceDebugMode) trace("init cluster kinemetric");
		}
		
		public function findRootClusterConstants():void
		{
			//trace("KineMetric::findRootClusterConstants");
			
				//if (ts.traceDebugMode) trace("find cluster..............................",N);
				
				///////////////////////////////////////////////
				// get number of touch points in cluster
				//N = ts.cO.tpn + ts.cO.ipn; //TODO: REMOVE TOUCH POINT EXPLICIT NOW ROLLED INTO IP
				N = ts.cO.ipn;
				cO.n = N;
				
				if (N) 
				{
					N1 = N - 1;
					k0 = 1 / N;
					k1 = 1 / N1;
					if (N == 0) N1 = 0;
				}
		}
		
		public function resetRootClusterValues():void 
		{
			//trace("KineMetric::resetRootCluster");
			
			if (cO.position) cO.position.setTo(0, 0, 0);
			if (cO.size) cO.size.setTo(0,0,0);
			cO.radius = 0;
			cO.gPointArray = new Vector.<GesturePointObject>;
		}
		
		//NEEDS WORK
		public function findRootInstDimention():void
		{
			//trace("KineMetric::findRootInstDimention");
			
			
			///////////////////////////////////////////////////////////////////////////////////////////////////////////
			// multi modal cluster width, height and radius // OPERATION
			///////////////////////////////////////////////////////////////////////////////////////////////////////////
					
					if (!cO.position) cO.position = new Vector3D();
					if (!cO.size) cO.size = new Vector3D();
					
					if (cO.position) cO.position.setTo(0, 0, 0);
					if (cO.size) cO.size.setTo(0,0,0);
					cO.radius = 0;
					
	
					if (N == 1)
					{
						var pt0:InteractionPointObject = cO.iPointArray[0];

						if (!ts.transform3d && pt0.mode=="motion" && pt0.screen_position) cO.position = pt0.screen_position;
						else cO.position = pt0.position;
						
						cO.radius = 15;
						cO.size.setTo(30,30,30);
					}
					
					else if (N > 1)
						{	
						for (i = 0; i < N; i++)
						{
						var pt:InteractionPointObject = cO.iPointArray[i];
						
						if (!ts.transform3d && pt.mode == "motion") pt.position = pt.screen_position;

						cO.position.x += pt.position.x;
						cO.position.y += pt.position.y;
						cO.position.z += pt.position.z;
						
						
							for (var j1:uint = 0; j1 < N; j1++)
							{
								
							//var pt2:* = cO.mmPointArray[j1];
							var pt2:InteractionPointObject = cO.iPointArray[j1];
							
								if ((i != j1) && (pt) && (pt2))
									{
									var dx:Number;
									var dy:Number;
									var dz:Number;
									
									//trace(pt,pt2)
										dx = pt.position.x - pt2.position.x;
										dy = pt.position.y - pt2.position.y;
										dz = pt.position.z - pt2.position.z;

										var abs_dx:Number = Math.abs(dx);
										var abs_dy:Number = Math.abs(dy);
										var abs_dz:Number = Math.abs(dz);
										
										// MAX SEPERATION BETWEEN A PAIR OF POINTS IN THE CLUSTER
										if (abs_dx > cO.size.x) cO.size.x = abs_dx;
										if (abs_dy > cO.size.y) cO.size.y = abs_dy;
										if (abs_dz > cO.size.z) cO.size.z = abs_dz;
									}
							}
						}
						
						cO.radius = 0.5*Math.sqrt(cO.size.x * cO.size.x + cO.size.y * cO.size.y + cO.size.z * cO.size.z);//
						//divide by subcluster ip number sipnk 
							
						cO.position.x *= k0;
						cO.position.y *= k0; 
						cO.position.z *= k0;
					}
					
				//trace("kinemetric inst dims", cO.x,cO.y, cO.z, cO.width, cO.height,cO.length, cO.radius);
		}
		
		
		/////////////////////////////////////////////////////////////////////////////////////////////////////
		/////////////////////////////////////////////////////////////////////////////////////////////////////
		// TOUCH CLUSTER ANALYSIS
		/////////////////////////////////////////////////////////////////////////////////////////////////////
		/////////////////////////////////////////////////////////////////////////////////////////////////////
		
	/*
		public function findInstOrientation():void 
		{
				//trace("KineMetric::findInstOrientation");			
			
				var handArray:Array = new Array();
				var maxDist:Number = 0;
				var maxAngle:Number = 0;
				var dist:Number = 0;
				var angle:Number = 180;
				
				tcO.orient_dx = 0;
				tcO.orient_dy = 0;	
						
							for (i = 0; i < tpn; i++) 
								{
									if (cO.touchArray[i].history[0])
									//if(pointList.length>i)
									{
										handArray[i] = new Array();
										handArray[i].id = cO.touchArray[i].id; // set point id
										handArray[i].touchPointID = cO.touchArray[i].touchPointID; // set point id
									
										// find distance between center of cluster and finger tip
										var dxe:Number = (cO.touchArray[i].history[0].position.x - cO.position.x);
										var dye:Number = (cO.touchArray[i].history[0].position.y - cO.position.y);
										
										// find diatance between mean center of cluster and finger tip
										var dxf:Number = (cO.touchArray[i].history[0].position.x - cO.mx);
										var dyf:Number = (cO.touchArray[i].history[0].position.y - cO.my);
										var ds1:Number = Math.sqrt(dxf * dxf + dyf * dyf)
										
										handArray[i].dist = ds1; // set distance from mean
										handArray[i].angle = 180; // init angle between vectors to radial center

										for (var q:int = 0; q < tpn; q++) 
										{
											if ((i != q)&&(cO.touchArray[q].history[0]))
												{
												var dxq:Number = (cO.touchArray[q].history[0].position.x - tcO.position.x);
												var dyq:Number = (cO.touchArray[q].history[0].position.y - tcO.position.y);
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
							for (i = 0; i < tpn; i++) 
								{
									handArray[i].prob = (handArray[i].angle/maxAngle + handArray[i].dist/maxDist)*0.5
								}
							handArray.sortOn("prob",Array.DESCENDING);
							
							///////////////////////////////////////////////////
							//NOW CORRECT UNIQUE ID
							tcO.thumbID = handArray[0].touchPointID;
							//tcO.thumbID = handArray[0].id;
							
							// BUT NEED TO FIX
							// RIGHT HAND RETURNS PINKY AS THUMB AS ANGLE INCORRECTLY CALCUKATED
							// NEED TO ALSO DETERMIN LEFT HAND AND RIGHT HAND
							//trace("hand angle",handArray[0].angle)
							
							//trace("ID", tcO.thumbID,handArray[0].id, handArray[0].touchPointID)
						
							// calc orientation vector // FIND ORIENTATION USING CLUSTER RADIAL CENTER
							for (i = 0; i < tpn; i++) 
								{
									if (cO.touchArray[i].id != handArray[0].id) 
									{	
										tcO.orient_dx += (cO.touchArray[i].history[0].position.x - tcO.position.x);
										tcO.orient_dy += (cO.touchArray[i].history[0].position.y - tcO.position.y);
									}
								}
							tcO.orient_dx *= tpnk1;
							tcO.orient_dy *= tpnk1;	
							
							
						
		}
		
		public function findInstPivot():void
		{
			//trace("KineMetric::findInstPivot");			
			
					//if (tpn == 1)
					if(tpn)
					{
						var x_c:Number = 0
						var y_c:Number = 0
						
						var dxh:Number = 0
						var dyh:Number = 0
						var dxi:Number = 0;
						var dyi:Number = 0;
						var pdist:Number = 0;
						var t0:Number = 0;
						var t1:Number = 0;
						var theta_diff:Number = 0
			
						tcO.pivot_dtheta = 0
					
						// CENTER OF DISPLAY OBJECT
						if (ts.trO.transAffinePoints) 
						{
							//trace("test", tO.transAffinePoints[4])
							x_c = ts.trO.transAffinePoints[4].x
							y_c = ts.trO.transAffinePoints[4].y
						}
						
								if (cO.touchArray.length==1)
								{
								if(cO.touchArray[0].history.length > 1 ) {
								//if (cO.touchArray[0].history.length>1) 
									
									// find touch point translation vector
									dxh = cO.touchArray[0].history[1].position.x - x_c;
									dyh = cO.touchArray[0].history[1].position.y - y_c;
											
									// find vector that connects the center of the object and the touch point
									dxi = cO.touchArray[0].position.x - x_c;
									dyi = cO.touchArray[0].position.y - y_c;
									pdist = Math.sqrt(dxi * dxi + dyi * dyi);
											
									t0 = calcAngle(dxh, dyh);
									t1 = calcAngle(dxi, dyi);
									if (t1 > 360) t1 = t1 - 360;
									if (t0 > 360) t0 = t0 - 360;
									
									theta_diff = t1 - t0
									
									if (theta_diff>300) theta_diff = theta_diff -360; //trace("Flicker +ve")
									if (theta_diff<-300) theta_diff = 360 + theta_diff; //trace("Flicker -ve");
									
									
									//pivot thresholds
									//if (Math.abs(theta_diff) > pivot_threshold)
									//{	
										// weighted effect
										tcO.pivot_dtheta = theta_diff*Math.pow(pdist, 2)*pvk;
										tcO.position.x = cO.touchArray[0].position.x;
										tcO.position.y = cO.touchArray[0].position.y;
									//}
									//else cO.pivot_dtheta = 0; 
									}
								}

								if (cO.touchArray.length>1) 
									{		
									//trace("hist",cO.touchArray[0].history.length,cO.touchArray[1].history.length)
									var cx1:Number = 0;
									var cy1:Number = 0;
									var cx0:Number = 0;
									var cy0:Number = 0;
									
										for (i = 0; i < cO.touchArray.length; i++) 
										{
											if (cO.touchArray[i].history.length > 1)
											{
												//trace("pivot")
												cx1 += cO.touchArray[i].history[1].position.x; 
												cy1 += cO.touchArray[i].history[1].position.y; 
												cx0 += cO.touchArray[i].history[0].position.x; 
												cy0 += cO.touchArray[i].history[0].position.y;
											}
										}
										
									cx1 *= tpnk0;
									cy1 *= tpnk0; 
									cx0 *= tpnk0; 
									cy0 *= tpnk0;	
									
									//trace(tpn, tpnk0,cx1,cy1,cx0,cy0)
									
									// find touch point translation vector
									dxh = cx1 - x_c;
									dyh = cy1 - y_c;
											
									// find vector that connects the center of the object and the touch point
									dxi = cx0 - x_c;
									dyi = cy0 - y_c;
									pdist = Math.sqrt(dxi * dxi + dyi * dyi);
											
									t0 = calcAngle(dxh, dyh);
									t1 = calcAngle(dxi, dyi);
									if (t1 > 360) t1 = t1 - 360;
									if (t0 > 360) t0 = t0 - 360;
									
									theta_diff = t1 - t0
									
									if (theta_diff>300) theta_diff = theta_diff -360; //trace("Flicker +ve")
									if (theta_diff<-300) theta_diff = 360 + theta_diff; //trace("Flicker -ve");
									
									
									//pivot thresholds
									//if (Math.abs(theta_diff) > pivot_threshold)
									//{	
										// weighted effect
										tcO.pivot_dtheta = theta_diff*Math.pow(pdist, 2)*pvk;
										tcO.position.x = cx0;
										tcO.position.y = cy0;
									//}
									//else cO.pivot_dtheta = 0; 
								}	
								
			}
		} 
		*/
		
		
		
		
		public function find2DIPConstants(iPointCluster:ipClusterObject):void//type:String
		{
			var sdipn:int = 0;
			var sipn:int = 0;
			var sipnk:Number = 0;
			var sipnk0:Number = 0;
			var index = iPointCluster.type;
			
			//trace("get 2d ip consts",iPointCluster.iPointArray)
			
			if (iPointCluster.iPointArray)
			{
			// GET SUBCLUSTER INTERACTION POINT NUMBER
			iPointCluster.ipn = iPointCluster.iPointArray.length;
			sipn = iPointCluster.ipn;
			}
			else sipn = 0;
			
			//CHANGE IN SUBCLUSTER INTERACTION POINT NUMBER
			//if (cO.history.length > 3) sdipn = sipn - cO.history[1].iPointClusterList[type].ipn;
			if (cO.history.length > 3) sdipn = sipn - cO.history[1].iPointClusterList.index.ipn //TODO: CHNAGE TO HISTORY 0
			else sdipn = 1;
			
			// GET IP BASED CONSTANTS
			if (sipn == 0) sipnk = 0;
			else sipnk = 1 / sipn;
			
			if (sipn == 1) sipnk0 = 1;
			else if (sipn == 0) sipnk0 = 0;
			else sipnk0 = 1 / (sipn - 1);
			
			iPointCluster.ipn = sipn;
			iPointCluster.dipn = sdipn;
			iPointCluster.ipnk = sipnk;
			iPointCluster.ipnk0 = sipnk0;
		
			//trace("get touch ip consts",cO.tSubClusterArray[index].type,cO.tSubClusterArray[index].ipn,cO.tSubClusterArray[index].dipn, cO.tSubClusterArray[index].ipnk, cO.tSubClusterArray[index].ipnk0);
			
		}
		
		public function find2DIPDimension(iPointCluster:ipClusterObject):void
		{
			//trace("km, find3dipdim");
			// GET TYPED SUB CLUSTER from cluster matrix //////////////////////////
			var sub_cO:ipClusterObject = iPointCluster;

			// GET TRANSFORMED INTERACTION POINT LIST
			var ptArray:Vector.<InteractionPointObject> = sub_cO.iPointArray;
			
			var sipn:int = sub_cO.ipn
			var sipnk:Number = sub_cO.ipnk;
			var sipnk0:Number = sub_cO.ipnk0
			//trace("get ip dims 2d ", sipn, sipnk, sipnk0);
			
			sub_cO.position.setTo(0,0,0);
			sub_cO.radius = 0;
			sub_cO.size.setTo(0, 0, 0);	
			sub_cO.separation = 1;
			sub_cO.separation3D.setTo(1,1,1);
			sub_cO.rotation = 0;
			sub_cO.rotation3D.setTo(0,0,0);
			
			
			//trace("dim",sipn)
			
			//APPLY DIMENTIONAL ANALYSIS
			if ((sipn!=0))
			{
			//trace("sub dims",sipn)
					//if (sipn > 1)
					//{
						for (i = 0; i < sipn; i++) 
								{
									//POSITION, CLUSTER CENTER
									var ipt:InteractionPointObject = ptArray[i];
									var pt:InteractionPointObject = ptArray[0];
									
									//trace(ipt.position, pt.position)
									
									sub_cO.position.x += ipt.position.x;
									sub_cO.position.y += ipt.position.y;
									sub_cO.position.z += ipt.position.z;
									
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
										// set size.x......
										//if (abs_dx > sub_cO.width) sub_cO.width = abs_dx;
										//if (abs_dy > sub_cO.height) sub_cO.height = abs_dy;
										//if (abs_dz > sub_cO.length) sub_cO.length = abs_dz;
										if (abs_dx > sub_cO.size.x) sub_cO.size.x = abs_dx;
										if (abs_dy > sub_cO.size.y) sub_cO.size.y = abs_dy;
										if (abs_dz > sub_cO.size.z) sub_cO.size.z = abs_dz;
									 }
									}
								 
									//GET DISTANCE TO CENTER
/*
								 if ((pt) && (ipt))//&&(!pointList[i].holdLock)&&(!pointList[j1].holdLock)) //edit
									{
										var dxs:Number = pt.position.x - ipt.position.x;
										var dys:Number = pt.position.y - ipt.position.y;
										var dzs:Number = pt.position.z - ipt.position.z;

										// separation of group
										sub_cO.separation.x += Math.abs(dxs);
										sub_cO.separation.y += Math.abs(dys);
										sub_cO.separation.z += Math.abs(dzs);
									}
									*/
							}
							// divide by subcluster pair count sipnk0 
						//	sub_cO.separation.x *= sipnk0;
							//sub_cO.separation.y *= sipnk0;
							//sub_cO.separation.z *= sipnk0;
							
							// size.x....
							
							//var diameter:Number = 0;
							//if (sub_cO.width > sub_cO.height) diameter = sub_cO.width;
							//else diameter = sub_cO.height;
							
							//sub_cO.radius = 0.5*diameter//Math.sqrt(sub_cO.width * sub_cO.width + sub_cO.height * sub_cO.height + sub_cO.length * sub_cO.length);//
							//divide by subcluster ip number sipnk 
							
							sub_cO.position.x *= sipnk;
							sub_cO.position.y *= sipnk; 
							sub_cO.position.z *= sipnk;
							
							var center_dist:Number
							var max_dist:Number = 0;
							//GET DISTANCE TO CENTER
							for (i = 0; i < sipn; i++) 
							{
							center_dist = Vector3D.distance(sub_cO.position, ipt.position);
							if (center_dist > max_dist) max_dist = center_dist;
							}
							sub_cO.radius = max_dist;
							
			}
			//trace("get 2D ip dims", sub_cO.position, sub_cO.width,sub_cO.height);//sub_cO.size //sub_cO.separation, sub_cO.rotation
		}

		
		
		
		///////////////////////////////////////////////////////////////////////////////////
		///////////////////////////////////////////////////////////////////////////////////
		// sensor IP analysis
		///////////////////////////////////////////////////////////////////////////////////
		///////////////////////////////////////////////////////////////////////////////////
		/*
		public function findSensorClusterConstants():void
		{
				if (ts.cO.sensorArray) spn = ts.cO.sensorArray.length;
				else spn = 0;
				
				ts.spn = spn;
				ts.cO.spn = spn;
				//ts.cO.scO.spn = spn;
		}
		*/
		
		public function resetSensorClusterConsts():void{}
		public function findSensorClusterDimensions():void{}
		public function findSensorVelocity():void{}
		
		public function findSensorJolt():void
		{
			//trace("accelerometer kinemetric");
			
			//var snr:Vector.<Number> = cO.sensorArray;
			
			//trace("timestamp", snr[0]);
			/*	
            trace("ax", event.accelerationX);
            trace("ay", event.accelerationY);
			trace("az", event.accelerationZ);
			trace("timestamp", event.timestamp);
			*/
		}
		
		public function findSensorSubClusters():void{}
		//public function weaveSensorCluster():void{}
		
		/// /////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////
		
		public function initFilterIPCluster():void
			{
				///////////////////////////////////////////////////////
				//palm ip config
				handConfig.palm = new Object();
				handConfig.palm.fist = false; // hand open closed state
				handConfig.palm.orientation = undefined; //up/down
				handConfig.palm.type = undefined; // left right
				handConfig.palm.fn = undefined;//digits on the hand
				handConfig.palm.flatness_min = undefined; //degree of flatness of fingers relative to plane of palm
				handConfig.palm.flatness_max = undefined; //degree of flatness of fingers relative to plane of palm
				handConfig.palm.splay_min = undefined; // finger separation
				handConfig.palm.splay_max = undefined; // finger separation
				
				//fist ip config
				handConfig.fist = new Object();
				handConfig.fist.fist = true; // hand open closed state
				handConfig.fist.orientation = undefined; //up/down
				handConfig.fist.type = undefined; // left right
				handConfig.fist.fn = undefined;//digits on the hand
				handConfig.fist.flatness_min = undefined; //degree of flatness of fingers relative to plane of palm
				handConfig.fist.flatness_max = undefined; //degree of flatness of fingers relative to plane of palm
				handConfig.fist.splay_min = undefined; // finger separation
				handConfig.fist.splay_max = undefined; // finger separation
				
				//pinch config
				handConfig.pinch = new Object();
				handConfig.pinch.distance_max = undefined;
				handConfig.pinch.fn = undefined;
			
				//trigger config
				handConfig.trigger = new Object();
				handConfig.trigger.extension_min
				handConfig.trigger.fn = undefined;
			
			}
		
		
		
		public function filterIPCluster():void
			{
				// TODO: PULL FROM LOCAL GESTURE LIST
				//OBJECT LEVEL GML DEFINED IP FILTERING
					
				trace("kinemetric filtering ip points");
				
				if (ts.cO.iPointArray)
					{
					//var temp_iPointArray = new Vector.<InteractionPointObject>();
						//temp_iPointArray = ts.cO.iPointArray;
						
						//ts.cO.iPointArray.length = 0;
						
					for (i = 0; i < ts.cO.iPointArray.length; i++)
							{
								var ipt:InteractionPointObject = ts.cO.iPointArray[i];
								////////////////////////////////////////////////////////////////////
								//check exists and check if ip type supported on display object
								//trace("supported", ipt.type,ts.tc.ipSupported(ipt.type));
								if (ipt)
								{
									
									if((ipt.type=="palm")&&(handConfig.palm))
									{
										//trace("fist filter ip", ipt.fist, ts.cO.iPointArray[i].fist);
										// NOTE CAN ONLY SPLICE AN IP ONCE
										if (handConfig.palm.fist != undefined) if (ipt.fist != handConfig.palm.fist) 
										{
										trace("removed as not in fist")
										ts.cO.iPointArray.splice(ipt.id, 1);
										}
										//if (handConfig.palm.orientation != undefined) if (ipt.orientation != handConfig.palm.orientation) ts.cO.iPointArray.splice(ipt.id, 1);
										//if (handConfig.palm.fn != undefined) if (ipt.fn != handConfig.palm.fn) ts.cO.iPointArray.splice(ipt.id, 1);
										//if (handconfig.palm.fist != undefined) if (ipt.fist!=handconfig.palm.fist) ts.cO.iPointArray.splice(ipt.id, 1);
									}
							}
						}
					
					
					
					
					
				}
			}
		
		
		public function mapCluster3Dto2D():void
			{
				//trace("map cluster data 3d to 2d",cO.motionArray.length,cO.iPointArray.length)
				
				
				// CLEARS OUT LOCAL POINT ARRAYS
				//cO.motionArray2D = new Vector.<MotionPointObject>();
				//cO.iPointArray2D = new Vector.<InteractionPointObject>();
				
				/*
				if (ts.motionEnabled)
				{
					trace("converting from 3d ip to 2d motion");
				// NORMALIZE MOTION POINT DATA TO 2D
				for (i = 0; i < cO.motionArray.length; i++) 
						{
							var pt:MotionPointObject = cO.motionArray[i];
							var pt2d:MotionPointObject = new MotionPointObject();
							
							//pt2d.motionPointID = pt.motionPointID;
							
							pt2d.position.x = normalize(pt.position.x, minX, maxX) * sw//1920;//stage.stageWidth;
							pt2d.position.y = normalize(pt.position.y, minY, maxY) * sh//1080;// stage.stageHeight;
							pt2d.position.z = pt.position.z
							
							//normalized vector
							pt2d.direction.x = -pt.direction.x;
							pt2d.direction.y = pt.direction.y;
							pt2d.direction.z = pt.direction.z;
							
							//normalized vector
							pt2d.normal.x = -pt.normal.x;
							pt2d.normal.y = pt.normal.y;
							pt2d.normal.z = pt.normal.z;
							
							pt2d.type = pt.type;
							pt2d.fingertype = pt.fingertype;
							//pt2d.history = pt.history;
							
						cO.motionArray2D.push(pt2d);
						}
				}*/	
						
				//trace("mapping3d to 2d", cO.iPointArray.length);
				
				// NORMALIZE INTERACTION POINT DATA TO 2D	
				for (i = 0; i < cO.iPointArray.length; i++)
						{
							var ipt:InteractionPointObject = cO.iPointArray[i];
							
							if (ipt)
							{
								//MOTION
								if (ts.motionEnabled)
								{
									if (ipt.mode == "motion")
									{
										//var ipt2d:InteractionPointObject = new InteractionPointObject();
										
										
										// stores root ip id
										//trace("interaction point id",ipt.interactionPointID, ipt.type)
										//ipt2d.id = ipt.interactionPointID;
										
										ipt.screen_position.x = normalize(ipt.position.x, minX, maxX) * sw//1920;//stage.stageWidth;
										ipt.screen_position.y = normalize(ipt.position.y, minY, maxY) * sh//1080;// stage.stageHeight;
										ipt.screen_position.z = ipt.position.z
										
										//normalized vector
										ipt.screen_direction.x = -ipt.direction.x;
										ipt.screen_direction.y = ipt.direction.y;
										ipt.screen_direction.z = ipt.direction.z;
										
										//normalized vector
										ipt.screen_normal.x = -ipt.normal.x;
										ipt.screen_normal.y = ipt.normal.y;
										ipt.screen_normal.z = ipt.normal.z;
										
										//ipt2d.type = ipt.type;
										//ipt2d.history = ipt.history;
										
										// pass ip properties
										//ipt2d.fist = ipt.fist;
										
										
									//cO.iPointArray2D.push(ipt2d);
									//cO.iPointArray2D.push(ipt);
									}
								}
								//TOUCH
								if (ts.touchEnabled) { 
									if (ipt.mode == "touch")
									{
									//cO.iPointArray.push(ipt);
									
									ipt.screen_position.x = ipt.position.x,
									ipt.screen_position.y = ipt.position.y
									ipt.screen_position.z = ipt.position.z
									
									}
								}
								//SENSOR
								if (ts.sensorEnabled) {
									//if (ipt.mode == "sensor") //cO.iPointArray.push(ipt);
								}
							
							//if(ipt2d.type=="palm")trace("fist 3d to 2d", ipt.fist)
							}
						}
		}
	
		//motion subcluster
	  /*  public function getSubClusters():void
			{
			//trace("get sub clusters")
			var temp_ipointArray:Vector.<InteractionPointObject>;
			temp_ipointArray = cO.iPointArray;
			
			//if (!ts.transform3d) 
			//{
				//temp_ipointArray = cO.iPointArray2D;
				//temp_ipointArray.position = cO.iPointArray.screen_position;
			//}

			
				//zero subcluster data //////////////////////////////
				//MOTION
				if(ts.motionEnabled){
				for (j = 0; j < cO.mSubClusterArray.length; j++) 
				{
					if(cO.mSubClusterArray[j].iPointArray) cO.mSubClusterArray[j].iPointArray.length = 0;
				}
				}
				//TOUCH
				if(ts.touchEnabled){
				for (j = 0; j < cO.tSubClusterArray.length; j++) 
				{
					if(cO.tSubClusterArray[j].iPointArray) cO.tSubClusterArray[j].iPointArray.length = 0;
				}
				}
				//SENSOR
				if(ts.sensorEnabled){
				for (j = 0; j < cO.sSubClusterArray.length; j++) 
				{
					if(cO.sSubClusterArray[j].iPointArray) cO.sSubClusterArray[j].iPointArray.length = 0;
				}
				}
			
				//update subcluster point arrays //////////////////////////////
				for (i = 0; i < temp_ipointArray.length; i++) 
				{
					var ipt:InteractionPointObject = temp_ipointArray[i];
					
					//SORT INTERACTION POINTS INTO SUBCLUSTERS
					//TODO: REMOVE LOOPS
					
					//MOTION
					if (ts.motionEnabled) {
					
					
					for (j = 0; j < cO.mSubClusterArray.length; j++) 
					{
						if (!cO.mSubClusterArray[j].iPointArray) cO.mSubClusterArray[j].iPointArray = new Vector.<InteractionPointObject>()
						//trace("moving motion typed interation points into motion subclusters",ipt.type,cO.mSubClusterArray[j].type)
						if (ipt.type==cO.mSubClusterArray[j].type) cO.mSubClusterArray[j].iPointArray.push(ipt);
					}
					}
					//TOUCH
					if (ts.touchEnabled) {
						
					for (j = 0; j < cO.tSubClusterArray.length; j++) 
					{
						if (!cO.tSubClusterArray[j].iPointArray) cO.tSubClusterArray[j].iPointArray = new Vector.<InteractionPointObject>()
						//trace("moving touch typed interation points into touch subclusters",ipt.type,cO.tSubClusterArray[j].type)
						if (ipt.type==cO.tSubClusterArray[j].type) cO.tSubClusterArray[j].iPointArray.push(ipt);
					}
					}
					//SENSOR
					if (ts.sensorEnabled) {
						
					for (j = 0; j < cO.sSubClusterArray.length; j++) 
					{
						if (!cO.sSubClusterArray[j].iPointArray) cO.sSubClusterArray[j].iPointArray = new Vector.<InteractionPointObject>()
						//trace("creating sensor subclusters",ipt.type,cO.sSubClusterArray[j].type);
						if (ipt.type==cO.sSubClusterArray[j].type) cO.sSubClusterArray[j].iPointArray.push(ipt);
					}
					}
						//trace(ipt.type)
					//if(ipt.type=="fist")trace("fist subcluster", ipt.fist)
				}
				//trace("modal subclusters formed","touch:",cO.touchArray.length,"motion:",cO.motionArray.length,"fusion:",cO.iPointArray.length,cO.iPointArray2D.length,"touch:",cO.tSubClusterArray.length,"motion:",cO.mSubClusterArray.length,"sensor:",cO.sSubClusterArray.length );
	
				
	
				
				
	}*/
	
	
	public function getSubClusterConstants():void 
	{
			// FOR EACH SUBCLUSTER IN MOTION MATRIX ////////////////////////////////////
			for each (var iPointCluster:ipClusterObject in iPointClusterList) 
			{	
				//trace("kinemetric",key,iPointClusterList[key], key.active, key.mode)
				//if (iPointCluster){
				if (iPointCluster.active)
					{
						
						if (iPointCluster.mode=="touch" && ts.touchEnabled) 
						{
							// FIND CLUSTER DIMS
							//find2DIPConstants(iPointCluster);
							//find2DIPDimension(iPointCluster);
							
							find3DMotionIPConstants(iPointCluster);
							find3DIPDimension(iPointCluster);	
						}
						else if (iPointCluster.mode == "motion" && ts.motionEnabled)
						{
						// FIND CLUSTER DIMS
							find3DMotionIPConstants(iPointCluster);
							find3DIPDimension(iPointCluster);	
						}
						else if (iPointCluster.mode == "sensor" && ts.sensorEnabled)
						{
						// FIND CLUSTER DIMS
							//find3DMotionIPConstants(iPointCluster);
							//find3DIPDimension(iPointCluster);
							
						}
					}
				//}
			}		
	}
		
		
		// motiion subcluster
		// GET IP CLUSTER CONSTS
		public function find3DGlobalIPConstants():void//type:String
		{
			// GET INTERACTION POINT NUMBER
			ipn = cO.iPointArray.length;
			ts.ipn = ipn;
			ts.cO.ipn = ipn;
			
			//ts.cO.mcO.ipn = ipn; //MUST BE MODALLY COMPLIANT
			
			//CHANGE IN INTERACTION POINT NUMBER
			//if (cO.history.length > 3) dipn = mcO.ipn - cO.history[1].ipn; //MUST BE MODALLY COMPLIANT
			if (cO.history.length > 3) dipn = cO.ipn - cO.history[1].ipn;
			
			else dipn = 1;
			cO.dipn = dipn;

			// GET IP BASED CONSTANTS
			if (ipn == 1) ipnk = 1;
			else ipnk = 1 / ipn;
			
			if (ipn == 1) ipnk0 = 1;
			else ipnk0 = 1 / (ipn - 1);
			
			//trace("dipn",cO.dipn, cO.ipnk, cO.ipnk0);
		}
		
		// motion subcluster
		public function find3DMotionIPConstants(iPointCluster:ipClusterObject):void//type:String
		{
			var sdipn:int = 0;
			var sipn:int = 0;
			var sipnk:Number = 0;
			var sipnk0:Number = 0;
			var index = iPointCluster.type;
			
			
			if (iPointCluster.iPointArray)
			{
			// GET INTERACTION POINT NUMBER
			iPointCluster.ipn = iPointCluster.iPointArray.length;
			sipn = iPointCluster.ipn;
			
			//CHANGE IN INTERACTION POINT NUMBER
			//if (cO.history.length > 3) sdipn = sipn - cO.history[1].iPointClusterList[index].ipn;
			if (cO.history.length > 3) sdipn = sipn - cO.history[1].iPointClusterList.index.ipn
			else sdipn = 1;
			
			// GET IP BASED CONSTANTS
			if (sipn == 1) sipnk = 1;
			else sipnk = 1 / sipn;
			
			if (sipn == 1) sipnk0 = 1;
			else sipnk0 = 1 / (sipn - 1);
			
			iPointCluster.ipn = sipn;
			iPointCluster.dipn = sdipn;
			iPointCluster.ipnk = sipnk;
			iPointCluster.ipnk0 = sipnk0;
		
			//trace("const ipn",cO.subClusterArray[index].type,cO.subClusterArray[index].ipn,cO.subClusterArray[index].dipn, cO.subClusterArray[index].ipnk, cO.subClusterArray[index].ipnk0);
			}
		}
		
	
		//Motion subcluster
		// IP CLUSTER DIMENSIONS
		public function find3DIPDimension(iPointCluster:ipClusterObject):void
		{
			// GET TYPED SUB CLUSTER from cluster matrix //////////////////////////
			var sub_cO:ipClusterObject = iPointCluster;

			// GET TRANSFORMED INTERACTION POINT LIST
			var ptArray:Vector.<InteractionPointObject> = sub_cO.iPointArray;
			
			var sipn:int = sub_cO.ipn
			var sipnk:Number = sub_cO.ipnk;
			var sipnk0:Number = sub_cO.ipnk0
			
			if (!sub_cO.position) sub_cO.position = new Vector3D();
			if (!sub_cO.size) sub_cO.size = new Vector3D();
			if (!sub_cO.separation3D) sub_cO.separation3D = new Vector3D();
			if (!sub_cO.rotation3D) sub_cO.rotation3D = new Vector3D();
			
			sub_cO.position.setTo(0,0,0);
			sub_cO.radius = 0
			sub_cO.size.setTo(0, 0, 0);
			sub_cO.separation = 1
			sub_cO.separation3D.setTo(1,1,1);
			sub_cO.rotation = 0
			sub_cO.rotation3D.setTo(0,0,0);
			
			
			//trace("dim",sipn)
			
			//APPLY DIMENTIONAL ANALYSIS
			if ((sipn!=0))
			{
			//trace("sub dims",sipn)
					//if (sipn > 1)
					//{
						for (i = 0; i < sipn; i++) 
								{
									//trace("add points")
									var ipt:InteractionPointObject = ptArray[i];
									var pt:InteractionPointObject = ptArray[0];
									
									//if (!ts.transform3d) 
									//{
										//ipt.position = ipt.screen_position;
										//pt.position = pt.screen_position;
									//}
									if (ts.transform3d) 
									{
									sub_cO.position.x += ipt.position.x;
									sub_cO.position.y += ipt.position.y;
									sub_cO.position.z += ipt.position.z;
									}
									else {
										sub_cO.position.x += ipt.screen_position.x;
										sub_cO.position.y += ipt.screen_position.y;
										sub_cO.position.z += ipt.screen_position.z;
									}
								
									
									/* //ONLY FOR ONE HAND
									if (pt.type == "palm")
									{
										cO.rotation3D.x = RAD_DEG * Math.asin(pt.normal.x);
										cO.rotation3D.y = RAD_DEG * Math.asin(pt.normal.y);
										cO.rotation3D.z = RAD_DEG * Math.asin(pt.normal.z);
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
										if (abs_dx > sub_cO.size.x) sub_cO.size.x = abs_dx;
										if (abs_dy > sub_cO.size.y) sub_cO.size.y = abs_dy;
										if (abs_dz > sub_cO.size.z) sub_cO.size.z = abs_dz;
									 }
									}
								 
								 
								 if ((pt) && (ipt))//&&(!pointList[i].holdLock)&&(!pointList[j1].holdLock)) //edit
									{
										var dxs:Number = pt.position.x - ipt.position.x;
										var dys:Number = pt.position.y - ipt.position.y;
										var dzs:Number = pt.position.z - ipt.position.z;

										// separation of group
										sub_cO.separation3D.x += Math.abs(dxs);
										sub_cO.separation3D.y += Math.abs(dys);
										sub_cO.separation3D.z+= Math.abs(dzs);
										
										// rotation of group
										//sub_cO.rotation += (calcAngle(dxs, dys)) //|| 0
										//sub_cO.rotation3D.x += (calcAngle(dys, dzs)); 
										//sub_cO.rotation3D.y += (calcAngle(dzs, dxs)); 
										//sub_cO.rotation3D.z += (calcAngle(dxs, dys));
										
										sub_cO.rotation = 0;
										sub_cO.rotation3D.x = 0; 
										sub_cO.rotation3D.y = 0; 
										sub_cO.rotation3D.z = 0;
									}
							}
							// divide by subcluster pair count sipnk0 
							sub_cO.separation3D.x *= sipnk0;
							sub_cO.separation3D.y *= sipnk0;
							sub_cO.separation3D.z *= sipnk0;
							
							
							sub_cO.radius = 0.5*Math.sqrt(sub_cO.size.x * sub_cO.size.x + sub_cO.size.y * sub_cO.size.y + sub_cO.size.z * sub_cO.size.z);//
							//divide by subcluster ip number sipnk 
							
							sub_cO.position.x *= sipnk;
							sub_cO.position.y *= sipnk; 
							sub_cO.position.z *= sipnk;
							
							//trace("sub cluster properties",sipnk)
							//trace("dim",sub_cO.ipn,sub_cO.ipnk,sub_cO.ipnk0, sub_cO.x,sub_cO.y,sub_cO.z)
							
							sub_cO.rotationList = new Vector.<Vector3D>
							
							for (i = 0; i < sipn; i++) 
								{
									//trace("add points")
									ipt = ptArray[i];
							
									if (ipt)
									{
										var dxc:Number = sub_cO.position.x - ipt.position.x;
										var dyc:Number = sub_cO.position.y - ipt.position.y;
										var dzc:Number = sub_cO.position.z - ipt.position.z;
										
										var tz:Number = (dyc / dxc); //yes
										var ty:Number = -(dzc / dxc);// reversed
										var tx:Number = -(dyc / dzc); // reversed
										
										var rx:Number = Math.atan(tx) * RAD_DEG;
										var ry:Number = Math.atan(ty) * RAD_DEG;
										var rz:Number = Math.atan(tz) * RAD_DEG;
										
										
										var rot:Vector3D = new Vector3D();
											rot.x = (isNaN(rx)) ? 0 : rx;
											rot.y = (isNaN(ry)) ? 0 : ry;
											rot.z = (isNaN(rz)) ? 0 : rz;
										sub_cO.rotationList.push(rot);
										
										
										//sub_cO.rotation += Math.atan(tz) * RAD_DEG;
										//sub_cO.rotation3D.x += Math.atan(tx) * RAD_DEG; 
										//sub_cO.rotation3D.y += Math.atan(ty) * RAD_DEG; 
										//sub_cO.rotation3D.z += Math.atan(tz) * RAD_DEG;
										
										//sub_cO.rotation += Math.atan2(dyc , dxc) * RAD_DEG;
										//sub_cO.rotation3D.x += Math.atan2(dyc , dzc) * RAD_DEG; 
										//sub_cO.rotation3D.y += Math.atan2(dyc , dzc) * RAD_DEG; 
										//sub_cO.rotation3D.z += Math.atan2(dyc , dxc) * RAD_DEG;
										
										//sub_cO.rotation += calcAngle(dyc , dxc);
										//sub_cO.rotation3D.x += calcAngle(dyc , dzc); 
										//sub_cO.rotation3D.y += calcAngle(dyc , dzc); 
										//sub_cO.rotation3D.z += calcAngle(dyc , dxc);
										
										//sub_cO.rotation += calcAngle2(dyc , dxc);
										//sub_cO.rotation3D.x += calcAngle2(dyc , dzc); 
										//sub_cO.rotation3D.y += calcAngle2(dyc , dzc); 
										//sub_cO.rotation3D.z += calcAngle2(dyc , dxc);
										
										//sub_cO.rotation += calcAngle3(dyc , dxc);
										//sub_cO.rotation3D.x += calcAngle3(dyc , dzc); 
										//sub_cO.rotation3D.y += calcAngle3(dyc , dzc); 
										//sub_cO.rotation3D.z += calcAngle3(dyc , dxc);
										
										//trace("----",i, rx, ry, rz);
									}
								}
								
								// divide by subcluster pair count sipnk0 
								sub_cO.rotation *= sipnk0;
								sub_cO.rotation3D.x *= sipnk0;
								sub_cO.rotation3D.y *= sipnk0;
								sub_cO.rotation3D.z *= sipnk0;
					//}
					/*
					else if (sipn == 1) 
					{
						sub_cO.x = ptArray[0].position.x;
						sub_cO.y = ptArray[0].position.y;
						sub_cO.z = ptArray[0].position.z;
						
						sub_cO.width = 15;
						sub_cO.height = 15;
						sub_cO.length = 15;
						sub_cO.radius = 50;
						
						sub_cO.separation3D.x = 1;
						sub_cO.separation3D.y = 1;
						sub_cO.separation3D.z = 1;
						
						// ONLY FOR ONE HAND
						if (ptArray[0].type == "palm")
						{
							sub_cO.rotation3D.x = -RAD_DEG * Math.asin(ptArray[0].normal.z);
							sub_cO.rotation3D.y = RAD_DEG * Math.asin(ptArray[0].direction.x); // otherwise zero?
							sub_cO.rotation3D.z = RAD_DEG * Math.asin(ptArray[0].normal.x);
							sub_cO.rotation = sub_cO.rotation3D.z;
							//trace("palm direction", ptArray[0].direction.x, ptArray[0].direction.y, ptArray[0].direction.z);
							//trace("palm norm", ptArray[0].normal.x,ptArray[0].normal.y,ptArray[0].normal.z);
							//trace("palm rotate",sub_cO.rotation3D.x,sub_cO.rotation3D.y,sub_cO.rotation3D.z,sub_cO.rotation );
						}
						else 
						{
							sub_cO.rotation3D.x = 0;
							sub_cO.rotation3D.y = 0;
							sub_cO.rotation3D.z = 0;
							sub_cO.rotation = 0;
						}
						
						//sub_cO.rotationList = new Vector.<Vector3D>
						//sub_cO.rotationList.push(new Vector3D(0,0 ,0));
						
						//trace("dim",sub_cO.ipn, sub_cO.x,sub_cO.y,sub_cO.z)
						
						trace("ip cluster dims",sub_cO.ipn,sub_cO.x,sub_cO.y,sub_cO.z,ptArray[0].position.x,ptArray[0].position.y,ptArray[0].position.z, sub_cO.iPointArray[0].position.x,sub_cO.iPointArray[0].id);
					}
					*/
					
				//trace("sub dims",sub_cO.width,sub_cO.height,sub_cO.length,"motion",mcO.width,mcO.height,mcO.length,"root",cO.width,cO.height,cO.length)
				//trace(sub_cO.rotation3D.z,sub_cO.rotation, sipn)
			}
			//trace("get ip dims");
				
		}
		
		// TAP POINTS
		public function find3DIPTapPoints(iPointCluster:ipClusterObject):void
		{
			//trace("---------------------tap kinemetric");
			// LOOK FOR 
				//VELOCITY SIGN CHANGE
				//ACCLERATION SIGN CHANGE 
				//JOLT MAGNITUDE MIN

			var hist:int = 10;//15
			var tapThreshold:Number = 10; // SMALLER MAKES EASIER//15
			
			// GET SUBCLUSTER OBJECT
			var sub_cO:ipClusterObject = iPointCluster;
			
			//GET TRANSFORMED IP ARRAY
			var ptArray:Vector.<InteractionPointObject> = sub_cO.iPointArray;
			
			// GET CONSTS
			var sipn:uint = sub_cO.ipn;
			var sipnk:Number = sub_cO.ipnk;
			//var dipn:int = sub_cO.dipn;
			
			var gpt:GesturePointObject = new GesturePointObject();
			var gpt0:GesturePointObject = new GesturePointObject();
			var gpt1:GesturePointObject = new GesturePointObject();
			
			//trace("tap testing--", sipn);
	
			for (i = 0; i < sipn; i++) 
					{	
					var pt:InteractionPointObject = ptArray[i];

					if (pt)
						{
							//trace("tap hist check",pt.history.length)
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
									if (test) 
									{
										// WILL KILL FOR GESTURE EVENT
										gpt = new GesturePointObject();
											gpt.position = pt.position;
											gpt.jolt = pt.history[0].jolt;
											gpt.type = "y tap";
											//gpt.ipn = sipn;
											
										//trace("kinemetric 3d y tap-----scan clean", pt.jolt.y, pt.history[0].jolt.y, pt.history[1].jolt.y, pt.interactionPointID, pt.id);
										cO.gPointArray.push(gpt);
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
										
										gpt0 = new GesturePointObject();
											gpt0.position = pt.position;
											gpt0.jolt = pt.history[0].jolt;
											gpt0.type = "x tap";

										//trace("kinemetric 3d x tap-----scan clean", pt.history[0].jolt.x, pt.interactionPointID, pt.id)
										cO.gPointArray.push(gpt0);
									}
									//trace("x tap test")
								}
								
								if (Math.abs(pt.history[1].jolt.z) > tapThreshold) 
								{
									var test1:Boolean = true;
									
									for (var h1:uint = 2; h1 < hist; h1++) 
										{	
											if (Math.abs(pt.history[h1].jolt.z) > tapThreshold) test = false;
										}
									if (test0) {
											gpt1 = new GesturePointObject();
												gpt1.position = pt.position;
												gpt1.jolt = pt.history[0].jolt;
												gpt1.type = "z tap";
										
										//trace("kinemetric 3d z tap-----scan clean", pt.history[0].jolt.z, pt.interactionPointID, pt.id);
										cO.gPointArray.push(gpt1);
									}
									//trace("z tap test")
								}
								
							}
						}
					}
					
					// TODO: MOVE TO TEMPORAL METRIC
					// MOVE GESTURE POINT LIST TO TIMELINE GESTURE POINT LAYER (SIMPLIFIY CLUSTER HISTORIES)
					//////////////////////////////////////////////////////////////
					// check if gppoint is cleared for sufficient time
					var tap_period:int = 30// 120;
					var ytap_clear:Boolean = true;
					var xtap_clear:Boolean = true;
					var ztap_clear:Boolean = true;
					//trace("3d motion hold gesture events qualifier",gpn,ts.cO.history.length)
					
					
					if (ts.cO.history.length >= tap_period)
					{
						for (var h3:uint = 0; h3 < tap_period; h3++) 
						{
							//trace("hist",h)
							if (this.cO.history[h3])
							{
							var gpn:uint = this.cO.history[h3].gPointArray.length
							
							//trace("3d motion gesture events visualizer", gpn)
						
								//gesture points
								for (var i:int = 0; i < gpn; i++) 
								{	
									if (cO.history[h3].gPointArray[i].type == "y tap") ytap_clear = false;
									if (cO.history[h3].gPointArray[i].type == "x tap") xtap_clear = false;
									if (cO.history[h3].gPointArray[i].type == "z tap") ztap_clear = false;
								}
							}
						}
					}
					
					//////////////////////////////////////////////////////////////////////////////////
					// SIMPLE TAP DISPLATCH CONTROL // USES SIMPLE PAUSE TIME
					//////////////////////////////////////////////////////////////////////////////////
					if ((ytap_clear)&&(gpt.type == "y tap"))
					{
						//trace("------------ytap--CLEAR");
						myTapID++;
						var myTap_event:GWGestureEvent = new GWGestureEvent(GWGestureEvent.MOTION_YTAP, {x:gpt.position.x , y:gpt.position.y, z:gpt.position.z, n:sipn, gestureID:myTapID});
						ts.dispatchEvent(myTap_event);
						ytap_clear = false;
						ts.tiO.frame.gestureEventArray.push(myTap_event);
					}
					if ((xtap_clear)&&(gpt0.type == "x tap"))
					{
						//trace("------------xtap--CLEAR");
						mxTapID++;
						var mxTap_event:GWGestureEvent = new GWGestureEvent(GWGestureEvent.MOTION_XTAP, {x:gpt0.position.x , y:gpt0.position.y, z:gpt0.position.z, n:sipn, gestureID:mxTapID});
						ts.dispatchEvent(mxTap_event);
						xtap_clear = false;
						ts.tiO.frame.gestureEventArray.push(mxTap_event);
					}
					if ((ztap_clear)&&(gpt1.type == "z tap"))
					{
						//trace("----------ztap----CLEAR");
						mzTapID++;
						var mzTap_event:GWGestureEvent = new GWGestureEvent(GWGestureEvent.MOTION_ZTAP, {x:gpt1.position.x , y:gpt1.position.y, z:gpt1.position.z, n:sipn, gestureID:mzTapID});
						ts.dispatchEvent(mzTap_event);
						ztap_clear = false;
						ts.tiO.frame.gestureEventArray.push(mzTap_event);
					}
					/////////////////////////////////////////////////////////////////////////////////////
		}
		
		//HOLD POINTS
		public function find3DIPHoldPoints(iPointCluster:ipClusterObject):void
		{
			//trace("-----------------------hold kinemetric");
			// GET SUBCLUSTER OBJECT
			var sub_cO:ipClusterObject = iPointCluster;
			
			//GET TRANSFORMED IP ARRAY
			var ptArray:Vector.<InteractionPointObject> = sub_cO.iPointArray;
			
			// GET CONSTS
			var sipn:uint = sub_cO.ipn;
			
			//HOLD 
				// SCAN HIST 20
				// LOW VELOCITY
				// LOWER ACCEL
			
			var hist:int = 20;
			var holdThreshold:Number = 3; 
			var gpt3:GesturePointObject = new GesturePointObject();
			
			//trace("--");

			for (i = 0; i < sipn; i++) 
					{	
					var pt:InteractionPointObject = ptArray[i];

						if ((pt)&&(pt.history.length > hist))
							{
							if ((pt.history[hist].velocity.length < holdThreshold) && (pt.history[hist].acceleration.length < (holdThreshold*0.1-0.1))) 
								{
									gpt3 = new GesturePointObject();
										gpt3.position = pt.history[hist].position;// PREVENTS HOLD DRIFT
										gpt3.type = "hold";
										
									cO.gPointArray.push(gpt3);
									
									//trace("kinemetric 3d hold...", pt.interactionPointID, pt.id);
								}
								//trace("v: ",v,"a: ",a)
							}
					}
					
					
			//TODO: MOVE TO TEMPROAL METRIC 
			// MOVE GESTURE POINT LIST OBJECY INTO TIMELINE OBJECT LAYER (SIMPLIFY CLUSTER HISTORIES)
			//IMPLEMENT SCANNING OF GESTURELIST FOR RECENT HOLD EVENTS FROM SAME AREA
			// LIMIT EVENTS CREATE MANDITORY PAUSE BETWEEN HOLD EVENT CHIPRS
			// ADD OPTION TO REQUIRE MOVEMENT THEN REHOLD TO ALLOW NEXT CHRIP
			
			
			
			var hold_period:int = 45//120//45// 120;
			var hold_clear:Boolean = true;
			//trace("3d motion hold gesture events qualifier",gpn,ts.cO.history.length)
			
			
			if (ts.cO.history.length >= hold_period)
			{
				for (var h:int = 0; h < hold_period; h++) 
				{
					//trace("hist",h)
					if (this.cO.history[h])
					{
					var gpn:uint = this.cO.history[h].gPointArray.length
					
					//trace("3d motion gesture events visualizer", gpn)
				
						//gesture points
						for (var i:int = 0; i < gpn; i++) 
						{	
							// SIDE TAP // YELLOW
							if (cO.history[h].gPointArray[i].type == "hold") hold_clear = false;
							//trace("not clear",cO.history[h].gPointArray[i].type);
						}
					}
					//else hold_clear = false;
				}
			}
			//else hold_clear = false;
			
			// NO HIT TEST HERE AS HANDLED AT LOWER LEVEL
			// IP MUST MATCH VIA HITTEST BEFORE HERE
			if (hold_clear)
			{
				//trace(gpt)
				if (gpt3.type == "hold")
					{
						//trace("--------------CLEAR",gpt3.type);
						mHoldID++;
						
						var mHold_event:GWGestureEvent = new GWGestureEvent(GWGestureEvent.MOTION_HOLD, {x:gpt3.position.x , y:gpt3.position.y, z:gpt3.position.z, n:sipn, gestureID:mHoldID});
						ts.dispatchEvent(mHold_event);
						
						hold_clear = false;
						ts.tiO.frame.gestureEventArray.push(mHold_event);
					}
			}	
			
			
		}
		
		
		// 3D MANIPULATE GENERIC 
		public function find3DIPTransformation(iPointCluster:ipClusterObject):void////type:String
		{			
			//trace("MD transform kinemetric", cO.iPointArray.length, ipn,cO.ipn);
			var hist:int = 1; //CREATES DELAY 
			var hk:Number = 1 / hist;
			var index = iPointCluster.type;
		
			//trace("km dinfd3diptrans",index, iPointCluster);
			
			// GET SUBCLUSTER OBJECT
			var sub_cO:ipClusterObject = iPointCluster
			
			//GET TRANSFORMED IP ARRAY
			var ptArray:Vector.<InteractionPointObject> = sub_cO.iPointArray;
			
			// GET CONSTS
			var sipn:uint = sub_cO.ipn;
			var sipnk:Number = sub_cO.ipnk;
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
			
			if ((cO.history.length > 3)&&(sub_cO.ipn!=0)) {//hist
				
				for (i = 0; i < 3; i++) 
				{	
					if (cO.history[i].iPointClusterList.index)
					{
					delta_ipn += Math.abs(cO.history[i].iPointClusterList.index.dipn);
					//trace("---", sub_cO.dipn, cO.history[1].subClusterArray[index].dipn, cO.history[2].subClusterArray[index].dipn,cO.history[3].subClusterArray[index].dipn, cO.history[4].subClusterArray[index].dipn, "tot",delta_ipn)
					}
				}
			} 
			else {delta_ipn = 1};
			
			
			
			//trace("kn 3d manipulate",sipn,cO.history[hist].iPointClusterList.index, dipn);
			

			// dipn ==0 when no changes in inpn between frames
			if ((sipn!= 0)&&(cO.history[hist].iPointClusterList.index)&&(dipn==0))		
				{
					//trace("t",ptArray[0].position.x,ptArray[0].history.length, cO.iPointArray2D[0].history.length,cO.iPointArray[0].history.length );
					var c_0:ipClusterObject = cO.history[0].iPointClusterList.index;//finger_cO
					var c_1:ipClusterObject = cO.history[hist].iPointClusterList.index;//finger_cO
					
					//trace("timelinked clusters",c_0,c_1)
						
					//trace("hist x---------------------------------------------",cO.history[0].iPointClusterList.index.x,cO.history[hist].iPointClusterList.index.x, cO.history[1].iPointClusterList.index.x)
					
							//trace("hist x",cO.finger_cO.x,cO.history[0].finger_cO.x, cO.history[6].finger_cO.x)
							//trace("hist rot",cO.finger_cO.rotation,cO.history[0].finger_cO.rotation, cO.history[2].finger_cO.rotation)
					
							//if (ts.transform3d)
							//{
							if (c_1.position && c_0.position){
							//////////////////////////////////////////////////////////
							//CHANGE IN CLUSTER POSITION
							if ((c_1.position.x!= 0) && (c_0.position.x != 0)) 	sub_cO.dx = (c_0.position.x - c_1.position.x)*hk;
							if ((c_1.position.y != 0) && (c_0.position.y != 0)) 	sub_cO.dy = (c_0.position.y - c_1.position.y)*hk;
							if ((c_1.position.z != 0) && (c_0.position.z != 0)) 	sub_cO.dz = (c_0.position.z - c_1.position.z)*hk;
							
							//trace(c_0.position.x,c_1.position.x);
							//trace(cO.dx,cO.dy,cO.dz);
							//}
							//else {
								//if ((c_1.screen_position.x!= 0) && (c_0.screen_position.x != 0)) 	sub_cO.dx = (c_0.screen_position.x - c_1.screen_position.x)*hk;
								//if ((c_1.screen_position.y != 0) && (c_0.screen_position.y != 0)) 	sub_cO.dy = (c_0.position.y - c_1.screen_position.y)*hk;
								//if ((c_1.screen_position.z != 0) && (c_0.screen_position.z != 0)) 	sub_cO.dz = (c_0.screen_position.z - c_1.screen_position.z)*hk;
							//trace(c_0.screen_position.x,c_1.screen_position.x);
							//}
							//trace(" dx",sub_cO.dx, sub_cO.dy, sub_cO.dz);
						
						if (sipn == 1)
							{
								// ROTATE //////////////////////////////////////////////////////////////////
								if (ptArray[0].type == "palm")
								{
									if ((c_1.rotation != 0) && (c_0.rotation != 0)) 	sub_cO.dtheta = (c_0.rotation- c_1.rotation) * hk;
									if ((c_1.rotation3D.x != 0) && (c_0.rotation3D.x != 0))	sub_cO.dthetaX = (c_0.rotation3D.x- c_1.rotation3D.x) * hk;
									if ((c_1.rotation3D.y != 0) && (c_0.rotation3D.y != 0))	sub_cO.dthetaY = (c_0.rotation3D.y- c_1.rotation3D.y) * hk;
									if ((c_1.rotation3D.z != 0) && (c_0.rotation3D.z != 0))	sub_cO.dthetaZ = (c_0.rotation3D.z - c_1.rotation3D.z) * hk;
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
								if ((c_1.separation3D.x != 0) && (c_0.separation3D.x != 0)) 	sub_cO.dsx = (c_0.separation3D.x - c_1.separation3D.x) * sck*hk;
								if ((c_1.separation3D.y != 0) && (c_0.separation3D.y != 0)) 	sub_cO.dsy = (c_0.separation3D.y - c_1.separation3D.y) * sck*hk;
								if ((c_1.separation3D.z != 0) && (c_0.separation3D.z != 0)) 	sub_cO.dsz = (c_0.separation3D.z - c_1.separation3D.z) * sck*hk;
								//trace("radius",c_0.radius, c_1.radius);
								
								if(delta_ipn==0) // ROTATION IS MOST SENSITIVE TO DELTA_IPN 
								{
									//////////////////////////////////////////////////////////
									// CHANGE IN ROTATION
									//if ((c_1.rotation != 0) && (c_0.rotation != 0))		sub_cO.dtheta = (c_0.rotation- c_1.rotation) * hk;
									//if ((c_1.rotation3D.x != 0) && (c_0.rotation3D.x != 0)) 	sub_cO.dthetaX = (c_0.rotation3D.x- c_1.rotation3D.x) * hk;
									//if ((c_1.rotation3D.y != 0) && (c_0.rotation3D.y != 0))	sub_cO.dthetaY = (c_0.rotation3D.y- c_1.rotation3D.y) * hk;
									//if ((c_1.rotation3D.z != 0) && (c_0.rotation3D.z != 0))	sub_cO.dthetaZ = (c_0.rotation3D.z - c_1.rotation3D.z) * hk;
									//trace("roation",c_0.rotation, c_1.rotation, c_0.dtheta);
									
									//if () 
									var c_0n:int = c_0.rotationList.length;
									var c_1n:int = c_1.rotationList.length;
									
									//trace("rot",c_0n,c_1n);
									
									if (c_1n == c_0n)
									{
										for (var k:uint = 0; k <c_0n; k++) 
										{	
											if (c_0.rotationList[k] && c_1.rotationList[k]) 
											{
												var dtx:Number = 0;
												var dty:Number = 0;
												var dtz:Number = 0;
												
												if ((c_1.rotationList[k].x != 0) && (c_0.rotationList[k].x != 0)) dtx = c_0.rotationList[k].x - c_1.rotationList[k].x;
												if ((c_1.rotationList[k].y != 0) && (c_0.rotationList[k].y != 0)) dty = c_0.rotationList[k].y - c_1.rotationList[k].y;
												if ((c_1.rotationList[k].z != 0) && (c_0.rotationList[k].z != 0)) dtz = c_0.rotationList[k].z - c_1.rotationList[k].z;
												//trace("rotpair----------", dtz,c_0.rotationList[k].z,c_1.rotationList[k].z);

												if (Math.abs(dtx) > 90)
												{
													if (dtx > 0) dtx = 180 - dtx;
													else dtx = 180 + dtx;
												}
												if (Math.abs(dty) > 90)
												{
													if (dty > 0) dty = 180 - dty;
													else dty = 180 + dty;
												}
												if (Math.abs(dtz) > 90)
												{
													if (dtz > 0) dtz = 180 - dtz;
													else dtz = 180 + dtz;
												}
												
												//if (Math.abs(dtz) > 90) trace("--------------------------------------------------------------->90")
												
												//trace("subpair----------", dtz);
												
												sub_cO.dthetaX += dtx * hk * sipnk;
												sub_cO.dthetaY += dty * hk* sipnk;
												sub_cO.dthetaZ += dtz * hk * sipnk;
												sub_cO.dtheta +=  dtz * hk * sipnk;
												
												//trace("rot",k, hk, sipnk,sub_cO.dthetaX,sub_cO.dthetaY,sub_cO.dthetaZ,sub_cO.dtheta)
											}
										}
									}
									//trace("rot",sub_cO.dthetaX,sub_cO.dthetaY,sub_cO.dthetaZ,sub_cO.dtheta)
									
								}
							}
							
							/*
									//NEED LIMITS FOR CLUSTER N CHANGE
									
									//LIMIT TRANLATE
									var trans_max_delta:Number = 100;
									
									//trace("pos--------------------------------------------------",sub_cO.dx, sub_cO.dy, sub_cO.dz,dipn);
									
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
									var sc_max_delta:Number = 0.02 // spikes upto 0.148, 0.08
									
									//trace("scale",sub_cO.ds,sub_cO.dsx,sub_cO.dsy,sub_cO.dsz)
									
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
									*/
									
									//trace("--------------------------------------------------------",sub_cO.dtheta);
									
									
									
									
									//trace("rot", sub_cO.dtheta, sub_cO.dthetaX, sub_cO.dthetaY, sub_cO.dthetaZ, dipn, delta_ipn)
									
									/*
									// LIMIT ROTATE
									var rot_max_delta:Number = 20//20//45
									
									
									
									
									
									
									if (Math.abs(sub_cO.dtheta) > rot_max_delta)
									{
										if (sub_cO.dtheta < 0) sub_cO.dtheta = -rot_max_delta;
										if (sub_cO.dtheta > 0) sub_cO.dtheta = rot_max_delta;
										if ( isNaN(sub_cO.dtheta)) sub_cO.dtheta = 0;
									}
									if (Math.abs(sub_cO.dthetaX) > rot_max_delta)
									{
										if (sub_cO.dthetaX < 0) sub_cO.dthetaX = -rot_max_delta;
										if (sub_cO.dthetaX > 0) sub_cO.dthetaX = rot_max_delta;
										if ( isNaN(sub_cO.dthetaX)) sub_cO.dthetaX = 0;
									}
									if (Math.abs(sub_cO.dthetaY) > rot_max_delta)
									{
										if (sub_cO.dthetaY < 0) sub_cO.dthetaY = -rot_max_delta;
										if (sub_cO.dthetaY > 0) sub_cO.dthetaY = rot_max_delta;
										if ( isNaN(sub_cO.dthetaY)) sub_cO.dthetaY = 0;
									}
									if (Math.abs(sub_cO.dthetaZ) > rot_max_delta)
									{
										if (sub_cO.dthetaZ < 0) sub_cO.dthetaZ = -rot_max_delta;
										if (sub_cO.dthetaZ > 0) sub_cO.dthetaZ = rot_max_delta;
										if ( isNaN(sub_cO.dthetaZ)) sub_cO.dthetaZ = 0;
									}
									//trace("get diff");	
									//trace("lim rot",sub_cO.dtheta,sub_cO.dthetaX,sub_cO.dthetaY,sub_cO.dthetaZ,dipn,delta_ipn)
									*/
			}
			}
		}
		
		// 3D MANIPULATE GENERIC 
		public function find3DIPRotation(iPointCluster:ipClusterObject):void////type:String
		{
			//trace("motion rotation kinemetric", cO.iPointArray.length, ipn,cO.ipn);
			var hist:int = 1; //CREATES DELAY 
			var hk:Number = 1 / hist;
		
			// GET SUBCLUSTER OBJECT
			var sub_cO:ipClusterObject = iPointCluster;
			var index = iPointCluster.type;
			
			//GET TRANSFORMED IP ARRAY
			var ptArray:Vector.<InteractionPointObject> = sub_cO.iPointArray;
			
			// GET CONSTS
			var sipn:uint = sub_cO.ipn;
			var sipnk:Number = sub_cO.ipnk;
			var dipn:int = sub_cO.dipn;
			
			//trace("ip dim",sipn);
			
			// reset deltas
			sub_cO.dtheta = 0;
			sub_cO.dthetaX = 0;
			sub_cO.dthetaY = 0;
			sub_cO.dthetaZ = 0;
			
			//if(cO.history.length>8)trace("waht",sipn,cO.dipn,cO.history[hist].subClusterArray[index])
			
			var delta_ipn:int = 0;
			/*
			if ((cO.history.length > 3)&&(sub_cO.ipn!=0)) {//hist
				
				for (var i:uint = 0; i < 3; i++) 
				{	
					if (cO.history[i].iPointClusterList[index]) delta_ipn += Math.abs(cO.history[i].iPointClusterList[index].dipn);
					//else 
					//trace("---", sub_cO.dipn, cO.history[1].subClusterArray[index].dipn, cO.history[2].subClusterArray[index].dipn,cO.history[3].subClusterArray[index].dipn, cO.history[4].subClusterArray[index].dipn, "tot",delta_ipn)
				}
			} 
			//else delta_ipn = 1;
			*/
			
			
			// dipn ==0 when no changes in inpn between frames
			if ((sipn!= 0)&&(cO.history[hist].iPointClusterList[index])&&(dipn==0))//
				{		
					
					//trace("t",ptArray[0].position.x,ptArray[0].history.length, cO.iPointArray2D[0].history.length,cO.iPointArray[0].history.length );
					var c_0:ipClusterObject = cO.history[0].iPointClusterList[index];//finger_cO
					var c_1:ipClusterObject = cO.history[hist].iPointClusterList[index];//finger_cO	
						
						if (sipn == 1)
							{
								// ROTATE //////////////////////////////////////////////////////////////////
								if (ptArray[0].type == "palm")
								{
									if ((c_1.rotation != 0) && (c_0.rotation != 0)) 	sub_cO.dtheta = (c_0.rotation- c_1.rotation) * hk;
									if ((c_1.rotation3D.x != 0) && (c_0.rotation3D.x != 0))	sub_cO.dthetaX = (c_0.rotation3D.x- c_1.rotation3D.x) * hk;
									if ((c_1.rotation3D.y != 0) && (c_0.rotation3D.y != 0))	sub_cO.dthetaY = (c_0.rotation3D.y- c_1.rotation3D.y) * hk;
									if ((c_1.rotation3D.z != 0) && (c_0.rotation3D.z != 0))	sub_cO.dthetaZ = (c_0.rotation3D.z - c_1.rotation3D.z) * hk;
								}
								else if (ptArray[0].type == "tag" || ptArray[0].type == "shape") 
								{
									sub_cO.dtheta = c_0.dtheta;
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
								if(delta_ipn==0) // ROTATION IS MOST SENSITIVE TO DELTA_IPN 
								{
									var c_0n:int = c_0.rotationList.length;
									var c_1n:int = c_1.rotationList.length;
									
									if (c_1n == c_0n)
									{
										for (var k:uint = 0; k <c_0n; k++) 
										{	
											if (c_0.rotationList[k] && c_1.rotationList[k]) 
											{
												if ((c_1.rotationList[k].x != 0) && (c_0.rotationList[k].x != 0)) sub_cO.dthetaX += (c_0.rotationList[k].x - c_1.rotationList[k].x) * hk * sipnk;
												if ((c_1.rotationList[k].y != 0) && (c_0.rotationList[k].y != 0)) sub_cO.dthetaY += (c_0.rotationList[k].y - c_1.rotationList[k].y) * hk* sipnk;
												if ((c_1.rotationList[k].z != 0) && (c_0.rotationList[k].z != 0)) sub_cO.dthetaZ += (c_0.rotationList[k].z - c_1.rotationList[k].z) * hk * sipnk;
												if ((c_1.rotationList[k].z != 0) && (c_0.rotationList[k].z != 0)) sub_cO.dtheta +=  (c_0.rotationList[k].z - c_1.rotationList[k].z) * hk * sipnk;
												
												//trace("rot",k,sub_cO.dthetaX,sub_cO.dthetaY,sub_cO.dthetaZ,sub_cO.dtheta)
											}
										}
									}
									//trace("rot",sub_cO.dthetaX,sub_cO.dthetaY,sub_cO.dthetaZ,sub_cO.dtheta)
									
								}
							}

								// LIMIT ROTATE
								var rot_max_delta:Number = 20//20//45
									
									//trace("rot",sub_cO.dtheta,sub_cO.dthetaX,sub_cO.dthetaY,sub_cO.dthetaZ,dipn,delta_ipn)
									
									if (Math.abs(sub_cO.dtheta) > rot_max_delta)
									{
										if (sub_cO.dtheta < 0) sub_cO.dtheta = -rot_max_delta;
										if (sub_cO.dtheta > 0) sub_cO.dtheta = rot_max_delta;
										if ( isNaN(sub_cO.dtheta)) sub_cO.dtheta = 0;
									}
									if (Math.abs(sub_cO.dthetaX) > rot_max_delta)
									{
										if (sub_cO.dthetaX < 0) sub_cO.dthetaX = -rot_max_delta;
										if (sub_cO.dthetaX > 0) sub_cO.dthetaX = rot_max_delta;
										if ( isNaN(sub_cO.dthetaX)) sub_cO.dthetaX = 0;
									}
									if (Math.abs(sub_cO.dthetaY) > rot_max_delta)
									{
										if (sub_cO.dthetaY < 0) sub_cO.dthetaY = -rot_max_delta;
										if (sub_cO.dthetaY > 0) sub_cO.dthetaY = rot_max_delta;
										if ( isNaN(sub_cO.dthetaY)) sub_cO.dthetaY = 0;
									}
									if (Math.abs(sub_cO.dthetaZ) > rot_max_delta)
									{
										if (sub_cO.dthetaZ < 0) sub_cO.dthetaZ = -rot_max_delta;
										if (sub_cO.dthetaZ > 0) sub_cO.dthetaZ = rot_max_delta;
										if ( isNaN(sub_cO.dthetaZ)) sub_cO.dthetaZ = 0;
									}
									//trace("get diff");	
									//trace("lim rot",sub_cO.dtheta,sub_cO.dthetaX,sub_cO.dthetaY,sub_cO.dthetaZ,dipn,delta_ipn)
			}
		}
		
		// 3D MANIPULATE GENERIC 
		public function find3DIPSeparation(iPointCluster:ipClusterObject):void
		{
			//trace("motion transform kinemetric", cO.iPointArray.length, ipn,cO.ipn);
			var hist:int = 1; //CREATES DELAY 
			var hk:Number = 1 / hist;
		
			// GET SUBCLUSTER OBJECT
			var sub_cO:ipClusterObject = iPointCluster;
			var index = iPointCluster.type;
			
			//GET TRANSFORMED IP ARRAY
			var ptArray:Vector.<InteractionPointObject> = sub_cO.iPointArray;
			
			// GET CONSTS
			var sipn:uint = sub_cO.ipn;
			var sipnk:Number = sub_cO.ipnk;
			var dipn:int = sub_cO.dipn;
			
			// reset deltas						
			sub_cO.ds = 0;
			sub_cO.dsx = 0;
			sub_cO.dsy = 0;
			sub_cO.dsz = 0;
			
			//trace("kn", sipn, cO.history[hist].iPointClusterList.index, dipn);
			
			// dipn ==0 when no changes in inpn between frames
			if ((sipn!= 0)&&(cO.history[hist].iPointClusterList.index)&&(dipn==0))//
				{		
					
					//trace("t",ptArray[0].position.x,ptArray[0].history.length, cO.iPointArray2D[0].history.length,cO.iPointArray[0].history.length );
					var c_0:ipClusterObject = cO.history[0].iPointClusterList.index;//finger_cO
					var c_1:ipClusterObject = cO.history[hist].iPointClusterList.index;//finger_cO
							
							if (sipn > 1)
							{
								//////////////////////////////////////////////////////////
								// CHANGE IN SEPARATION
								if ((c_1.radius != 0) && (c_0.radius != 0)) 			sub_cO.ds = (c_0.radius - c_1.radius) * sck*hk;
								if ((c_1.separation3D.x != 0) && (c_0.separation3D.x != 0)) 	sub_cO.dsx = (c_0.separation3D.x - c_1.separation3D.x) * sck*hk;
								if ((c_1.separation3D.y != 0) && (c_0.separation3D.y != 0)) 	sub_cO.dsy = (c_0.separation3D.y - c_1.separation3D.y) * sck*hk;
								if ((c_1.separation3D.z != 0) && (c_0.separation3D.z != 0)) 	sub_cO.dsz = (c_0.separation3D.z - c_1.separation3D.z) * sck*hk;
								//trace("radius",c_0.radius, c_1.radius);
							}
									/*
									//LMIT SCALE
									var sc_max_delta:Number = 0.02 // spikes upto 0.148, 0.08
									
									//trace("scale",sub_cO.ds,sub_cO.dsx,sub_cO.dsy,sub_cO.dsz)
									
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
									*/
									//trace(sub_cO.dsx,sub_cO.dsy)
			}
		}
		
		
		public function find3DIPTranslation(iPointCluster:ipClusterObject):void//type:String
		{
			//trace("-------------------------ip translate kinemetric", cO.iPointArray.length, ipn,cO.ipn);
			var hist:int = 1;
			var hk:Number = 1 / hist;
			
			// Get subcluster
			var sub_cO:ipClusterObject = iPointCluster;
			var index =  iPointCluster.type;

			//GET TRANSFORMED IP ARRAY
			var ptArray:Vector.<InteractionPointObject> = sub_cO.iPointArray;
			
			var sipn:uint = sub_cO.ipn;
			var sdipn:uint = sub_cO.dipn;
			
			// reset deltas
			sub_cO.dx = 0;
			sub_cO.dy = 0;
			sub_cO.dz = 0;
				
			//trace("km", sipn,cO.history[hist].iPointClusterList.index, sdipn);
			
			// dipn ==0 when no changes in inpn between frames
			if ((sipn!= 0)&&(cO.history[0].iPointClusterList.index)&&(cO.dipn==0))//cO.history[hist].iPointClusterList.index
				{
					//trace("t",ptArray[0].position.x,ptArray[0].history.length, cO.iPointArray2D[0].history.length,cO.iPointArray[0].history.length );
					var c_0:ipClusterObject = iPointCluster;//cO.history[0].iPointClusterList.index;
					var c_1:ipClusterObject = cO.history[0].iPointClusterList.index//cO.history[hist].iPointClusterList.index;
						
					//if (!c_0.position)c_0.position = new Vector3D();
					//if (!c_1.position) c_1.position = new Vector3D();
					
					
					if (c_0.position && c_1.position)
					{
							//trace("hist x",cO.finger_cO.x,cO.history[0].finger_cO.x, cO.history[6].finger_cO.x)
							//trace("hist rot",cO.finger_cO.rotation,cO.history[0].finger_cO.rotation, cO.history[2].finger_cO.rotation)
								
							//////////////////////////////////////////////////////////
							//CHANGE IN CLUSTER POSITION
							if ((c_1.position.x!= 0) && (c_0.position.x != 0)) 	sub_cO.dx = (c_0.position.x - c_1.position.x)*hk;
							if ((c_1.position.y != 0) && (c_0.position.y != 0)) 	sub_cO.dy = (c_0.position.y - c_1.position.y)*hk;
							if ((c_1.position.z != 0) && (c_0.position.z != 0)) 	sub_cO.dz = (c_0.position.z - c_1.position.z)*hk;
							
						//	trace("ipcluster",c_0.type,iPointCluster.position, c_0.position, c_1.position);
							//trace(cO.dx,cO.dy,cO.dz);
								
							//NEED LIMITS FOR CLUSTER N CHANGE
							//LIMIT TRANLATE
							var trans_max_delta:Number = 200;//please remove before i drive myself crazy!!!!!!!
							
							/*
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
							}*/
							//trace("get diff");
					}
			}
			//trace("@kinemetric, ip translate ",sub_cO.type, sub_cO.dx,sub_cO.dy,sub_cO.dz);
		}
		
		public function find3DIPAcceleration(iPointCluster:ipClusterObject):void//type:String
		{
			//trace("motion transform kinemetric", cO.iPointArray.length, ipn,cO.ipn);
			var hist:int = 8;
			var hk:Number = 1 / hist;
			
			// Get subcluster
			var sub_cO:ipClusterObject = iPointCluster;
			var index =  iPointCluster.type;

			//GET TRANSFORMED IP ARRAY
			var ptArray:Vector.<InteractionPointObject> = sub_cO.iPointArray;
			
			var sipn:uint = sub_cO.ipn;
			var sdipn:uint = sub_cO.dipn;
			var sipnk:* = sub_cO.ipnk;
			
			// reset deltas
			sub_cO.dx = 0;
			sub_cO.dy = 0;
			sub_cO.dz = 0;
				
			// dipn ==0 when no changes in inpn between frames
			if ((sipn!= 0)&&(cO.history[hist].iPointClusterList[index])&&(sdipn==0))//
				{
					//trace("t",ptArray[0].position.x,ptArray[0].history.length, cO.iPointArray2D[0].history.length,cO.iPointArray[0].history.length );
					//var c_0:ipClusterObject = cO.history[0].sub_cO;
					//var c_1:ipClusterObject = cO.history[hist].sub_cO;
						
							//trace("hist x",cO.finger_cO.x,cO.history[0].finger_cO.x, cO.history[6].finger_cO.x)
							//trace("hist rot",cO.finger_cO.rotation,cO.history[0].finger_cO.rotation, cO.history[2].finger_cO.rotation)
							
							
							//////////////////////////////////////////////////////////
							//CLUSTER MOTION
							for (i = 0; i < sipn; i++) 
							{	
								//AGREGATE VELOCITY
								sub_cO.velocity.x += sub_cO.iPointArray[i].velocity.x;
								sub_cO.velocity.y += sub_cO.iPointArray[i].velocity.y;
								sub_cO.velocity.z += sub_cO.iPointArray[i].velocity.z;
									
								//AGREGATE ACCELERATION
								sub_cO.acceleration.x += sub_cO.iPointArray[i].acceleration.x;
								sub_cO.acceleration.y += sub_cO.iPointArray[i].acceleration.y;
								sub_cO.acceleration.z += sub_cO.iPointArray[i].acceleration.z;
								
								//AGREGATE JOLT
								sub_cO.jolt.x += sub_cO.iPointArray[i].jolt.x;
								sub_cO.jolt.y += sub_cO.iPointArray[i].jolt.y;
								sub_cO.jolt.z += sub_cO.iPointArray[i].jolt.z;
							}
							
							
							//AGREGATE VELOCITY
							sub_cO.velocity.x *= sipnk;
							sub_cO.velocity.y *= sipnk;
							sub_cO.velocity.z *= sipnk;
									
							//AGREGATE ACCELERATION
							sub_cO.acceleration.x *= sipnk;
							sub_cO.acceleration.y *= sipnk;
							sub_cO.acceleration.z *= sipnk;
								
							//AGREGATE JOLT
							sub_cO.jolt.x *= sipnk;
							sub_cO.jolt.y *= sipnk;
							sub_cO.jolt.z *= sipnk;
							
							//trace(sub_cO.velocity,sub_cO.acceleration,sub_cO.jolt);
			}
		}
	
		////////////////////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////////////
		// helper functions
		////////////////////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////////////
		
		/////////////////////////////////////////////////////////////////////////////////////////
		// FINDS THE ANGLE BETWEEN TWO VECTORS 
		/////////////////////////////////////////////////////////////////////////////////////////
		/*
		private static function dotProduct(x0:Number, y0:Number,x1:Number, y1:Number):Number
			{	
				if ((x0!=0)&&(y0!=0)&&(x1!=0)&&(y1!=0)) return Math.acos((x0 * x1 + y0 * y1) / (Math.sqrt(x1 * x1 + y1 * y1) * Math.sqrt(x0 * x0 + y0 * y0)));
				else return 0;
				
				
		}	
			*/
		/////////////////////////////////////////////////////////////////////////////////////////
		// tan function with adjustments for angle wrapping
		/////////////////////////////////////////////////////////////////////////////////////////
		// NOTE NEED TO CLEAN LOGIC TO PREVENT ROTATIONS ABOVE 360 AND PREVENT ANY NEGATIVE ROTATIONS
		
		/*
		private static function calcAngle(adjacent:Number, opposite:Number):Number
			{
				if (adjacent == 0) return opposite < 0 ? 270 : 90 ;
				if (opposite == 0) return adjacent < 0 ? 180 : 0 ;
				
				if (opposite > 0) 
				{
					return adjacent > 0 ? 360 + Math.atan(opposite / adjacent) * RAD_DEG : 180 - Math.atan(opposite / -adjacent) * RAD_DEG ;
				}
				else {
					return adjacent > 0 ? 360 - Math.atan( -opposite / adjacent) * RAD_DEG : 180 + Math.atan( opposite / adjacent) * RAD_DEG ;
				}
				
				return 0;
		}
		
		private static function calcAngle2(opposite:Number, adjacent:Number):Number
		{
			if (adjacent > 0) return (180 + Math.atan(opposite / adjacent) * RAD_DEG);
			if ((adjacent >= 0) && (opposite < 0)) return (360 + Math.atan( opposite / adjacent) * RAD_DEG);
			else return (Math.atan( opposite / adjacent) * RAD_DEG);	
		}
		
		private static function calcAngle3(y:Number, x:Number):Number
		{
			var theta_rad:Number  = Math.atan2( y , x)
			return (theta_rad/Math.PI*180) + (theta_rad > 0 ? 0 : 360);	
		}
		*/
		
		private static function normalize(value : Number, minimum : Number, maximum : Number) : Number {

                        return (value - minimum) / (maximum - minimum);
         }

        private static function limit(value : Number, min : Number, max : Number) : Number {
                        return Math.min(Math.max(min, value), max);
        }
	}
}