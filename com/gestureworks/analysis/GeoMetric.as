////////////////////////////////////////////////////////////////////////////////
//
//  IDEUM
//  Copyright 2011-2013 Ideum
//  All Rights Reserved.
//
//  GestureWorks
//
//  File:    GeoMetric.as
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
	import com.gestureworks.managers.MotionPointHistories;
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	import flash.geom.Utils3D;
	import flash.geom.Point;
	
	import com.gestureworks.core.GestureGlobals;
	import com.gestureworks.core.gw_public;
	
	import com.gestureworks.objects.HandObject;
	import com.gestureworks.objects.PointObject;
	import com.gestureworks.objects.MotionPointObject;
	import com.gestureworks.objects.InteractionPointObject;
	import com.gestureworks.objects.ClusterObject;
	import com.gestureworks.objects.ipClusterObject;
	import com.gestureworks.managers.InteractionPointTracker;
		
	public class GeoMetric
	{
		//////////////////////////////////////
		// ARITHMETIC CONSTANTS
		//////////////////////////////////////
		private static const RAD_DEG:Number = 180 / Math.PI;
		private static const DEG_RAD:Number = Math.PI / 180 ;
		
		private var touchObjectID:int;
		private var ts:Object;//private var ts:TouchSprite;
		private var cO:ClusterObject;
		private var tcO:ipClusterObject;
		private var i:uint = 0;
		private var j:uint = 0;
		
		private var std_radius:int = 30;
		
		
		private var mpn:uint = 0;
		
		public var tag_match:Boolean = false;
		
		public function GeoMetric(_id:int) 
		{
			touchObjectID = _id;
			init();
		}
		
		public function init():void
		{
			ts = GestureGlobals.gw_public::touchObjects[touchObjectID]; // need to find center of object for orientation and pivot
			cO = ts.cO; // get motion data
			tcO = ts.cO.tcO; 
			
			if (ts.traceDebugMode) trace("init cluster geometric");
		}
		
		
		public function resetGeoCluster():void
		{
			//////////////////////////////////////
			// SUBCLUSTER STRUCTURE
			// CAN BE USED FOR BI-MANUAL GESTURES
			// CAN BE USED FOR CONCURRENT GESTURE PAIRS
			/////////////////////////////////////
		}

		
		public function findMotionClusterConstants():void
		{
			mpn = cO.motionArray.length;
			
			ts.mpn = mpn;
			ts.cO.mpn = mpn;
			ts.cO.mcO.mpn = mpn;
		}
		
		///////////////////////////////////////////////////////////////////////////////////
		///////////////////////////////////////////////////////////////////////////////////
		// 2d touch config analysis
		///////////////////////////////////////////////////////////////////////////////////
		///////////////////////////////////////////////////////////////////////////////////
		
		public function find2DTagPoints():void
		{
			
		//NEED TO FIND SINGNATURE CLUSTER WEB 
			
			
			
		if (ts.tpn) 
		{
			//trace("find 2d tag points")
			
			var count:int = 0;
			var error:int = 8;
			
				for (i = 0; i < ts.cO.tpn; i++) 
				{
				//var pt:PointObject = cO.pointArray[i]
				
				var distx:Number = cO.tcO.x - cO.pointArray[i].x;
				var disty:Number = cO.tcO.y - cO.pointArray[i].y;
				
				cO.pointArray[i].dist = Math.sqrt(distx * distx + disty * disty)
				cO.pointArray[i].match = false;
				//trace("tpoints",i,cO.pointArray[i].dist,cO.tcO.x,cO.tcO.y)
				}
				trace("--")
				
				for (i = 0; i < cO.objectArray.length; i++) 
				{
					for (j = 0; j < cO.objectArray[i].length; j++) 
					{
						// number of points in object tag structure
						//cO.objectArray[i].object[j].length
						
						
						for (var k:int = 0; k < ts.cO.tpn; k++) 
						{
							//var drx = cO.x - cO.objectArray[i][j].x;
							//var dry = cO.y - cO.objectArray[i][j].y;
							//var rdist =  Math.sqrt(drx * drx + dry * dry)
							var rdist:Number = cO.objectArray[i][j].dist;
							var diff:Number = Math.abs(cO.objectArray[i][j].dist -cO.pointArray[k].dist)
							//var min:Number = rdist - error; 
							//var max:Number = rdist + error; 
							
							
							
							//if (( min < cO.pointArray[k].dist < max ) && (!cO.pointArray[k].match))
							//trace("rad diff",diff,cO.objectArray[i][j].dist,cO.pointArray[k].dist)
							
							//NEED DECENDING POINT MATCH TO CREATE BEST MATCH
							// NEED ANGULAR 
							if((!cO.pointArray[k].match)&&(diff < error))
								{
									cO.pointArray[k].match = true;
									count++;
									//trace(" touch gemetric rad diff",diff,cO.objectArray[i][j].dist,cO.pointArray[k].dist,k)
								}
						}
					}
				}
				
				// note reduce accuracey
				if (count >= 4) {
					//trace("tag feature match")
					tag_match = true;
				}
				else tag_match =false
				
			}
		}
		
		
		
		///////////////////////////////////////////////////////////////////////////////////
		///////////////////////////////////////////////////////////////////////////////////
		// 3d config analysis
		///////////////////////////////////////////////////////////////////////////////////
		///////////////////////////////////////////////////////////////////////////////////
		
		// clear derived point and cluster motion data
		public function clearHandData():void
		{
			var clear_fingers:Boolean = false;
			var clear_palm:Boolean = false;
			
			
			
			for (i = 0; i < cO.motionArray.length; i++)//mpn
				{	
					if (cO.motionArray[i]) {
						
						if ((cO.motionArray[i].type == "finger")&&(clear_fingers))
						{	
							// reset thum alloc// move to cluster
							cO.motionArray[i].fingertype = "finger";	 
							
							// reset thumb probs // move to cluster
							cO.motionArray[i].thumb_prob = 0;
							cO.motionArray[i].mean_thumb_prob = 0
							// normalized data
							cO.motionArray[i].normalized_length = 0;
							cO.motionArray[i].normalized_width = 0;
							cO.motionArray[i].normalized_palmAngle = 0;
							cO.motionArray[i].normalized_favdist = 0;
						}
						
						if ((cO.motionArray[i].type == "palm")&&(clear_palm))
						{	
							// reset thum alloc// move to cluster
							cO.motionArray[i].fingertype = null;	 
							
							// reset thumb probs // move to cluster
							cO.motionArray[i].thumb_prob = 0;
							cO.motionArray[i].mean_thumb_prob = 0
							// normalized data
							cO.motionArray[i].normalized_length = 0;
							cO.motionArray[i].normalized_width = 0;
							cO.motionArray[i].normalized_palmAngle = 0;
							cO.motionArray[i].normalized_favdist = 0;
						}
					}
				}
				
				// reset motion points in list
				//cO.handList.length = 0;
			
				// reset hands
				//cO.hn = 0;
				//cO.fn = 0;
		}
		
		
		// get normalized finger length and palm angle
		// create basic hand
		public function updateMotionPoints():void 
		{
				for (i = 0; i < mpn; i++)//mpn
					{
						//////////////////////////////////////////////////////
						/// create hand
						if (cO.motionArray[i].type == "palm") 
						{
										if (cO.hn != 0)
										{
										for (j = 0; j < cO.handList.length; j++)
										{
											if ((cO.handList[j].handID != cO.motionArray[i].handID)&&(cO.handList.length < 2))
											{
												//trace("create another hand");
												//create hand
												var hand:HandObject = new HandObject();	
													hand.position = cO.motionArray[i].position //palmID
													hand.direction = cO.motionArray[i].direction
													hand.normal = cO.motionArray[i].normal
													hand.handID = cO.motionArray[i].handID;
													hand.palm = cO.motionArray[i]; // link palm point
								
												cO.handList.push(hand);
												//trace("p",cO.motionArray[i].handID)
											}
											else {
												//trace("update hand",j);
												//update hand
												//cO.handList[j] = cO.motionArray[i];
												cO.handList[j].position = cO.motionArray[i].position;
												cO.handList[j].direction = cO.motionArray[i].direction
												cO.handList[j].normal = cO.motionArray[i].normal
												cO.handList[j].palm = cO.motionArray[i];
												}	
											}
										}
										else {
											//trace("zero create hand");
											//create hand
											var hand:HandObject = new HandObject();	
													hand.position = cO.motionArray[i].position //palmID
													hand.direction = cO.motionArray[i].direction
													hand.normal = cO.motionArray[i].normal
													hand.handID = cO.motionArray[i].handID;
													hand.palm = cO.motionArray[i]; // link palm point
								
											cO.handList.push(hand);
										}
							}
					}
					///////////////////////////////////////////////
					// GET HAND NUM TOTAL
					cO.hn = cO.handList.length;
					
					
					
					///////////////////////////////////////////////
					// PUSH FINGERS
					var fn:int = 0;
					
					for (j = 0; j < cO.hn; j++)
					{
						//clear previos motion points
						cO.handList[j].fingerList.length = 0;
						
						//trace("-------");
						
						for (i = 0; i <mpn; i++)//mpn
							{	
							var mp:MotionPointObject = cO.motionArray[i];

							if ((cO.handList[j].handID == mp.handID))
							{
								if (mp.type == "finger")
									{
										//trace("CREATE NEW FINGER ZERO", mp.motionPointID, mp.id ,mp.position,cO.handList[j].fingerList.length)
										//mp.fingertype = "finger"; // KILLING THUMB
										// push fingers into finger list
										cO.handList[j].fingerList.push(mp);
									}
								if (mp.type == "tool")
									{
										//trace("tool..........................................");
										// push tool into interaction point list
										var tpt:InteractionPointObject = new InteractionPointObject();
											tpt.position = mp.position;
											tpt.direction = mp.direction;
											tpt.length = mp.length;
											tpt.width = mp.width;
											tpt.handID = mp.handID;
											tpt.type = mp.type;
																								
											//add to pinch point list
											InteractionPointTracker.framePoints.push(tpt)				
									}
								}
							}
								//BUILD FINGER NUM TOTAL
								fn += cO.handList[j].fingerList.length;
								// push local finger list total
								//cO.handList[j].hfn = cO.handList[j].fingerList.length;
							}
					/////////////////////////////////////////////
					//GET FINGER NUM TOTAL
					cO.fn = fn;
		}
		
		public function lockHandType():void 
		{
			
			for (j = 0; j < cO.hn; j++)
				{
					if ((cO.handList[j].type)&&(cO.handList[j].fingerList.length==5))
						{
						
						//trace("hand type",cO.handList[j].type);
						if (cO.handList[j].type == "right") cO.handList[j].typeCache ++;
						else if (cO.handList[j].type == "left") cO.handList[j].typeCache --;
						
						cO.handList[j].scanCount ++;
							
						//test if can be locked 
						 if ((cO.handList[j].scanCount > 20) &&(!cO.handList[j].handLock))
						 {
							
							 cO.handList[j].handLock = true;
							 cO.handList[j].scanCount = 0;
							 
							 if (cO.handList[j].typeCache > 0) cO.handList[j].lockedType = "right";
							 if (cO.handList[j].typeCache < 0) cO.handList[j].lockedType = "left";
							 
							// trace("lockedtype",cO.handList[j].lockedType);
						}
						}
				}
		}
		
		public function dynamicSkeletonUpdate():void 
		{
			for (j = 0; j < cO.hn; j++)
				{
					if (cO.handList[j].handLock) 
					{	
						if ((cO.handList[j].type) && (cO.handList[j].fingerList.length == 5) && (cO.handList[j].seedList.length == 0)) 
							{
								//trace("create new hand skeleton", cO.handList[j].type, cO.handList[j].lockedType);
								createSkeleton(true);
								matchFingers(true);
								positionTips();
								positionJoints();
							}
						// SHOULD ADD NEW CONDITION TO CHECK TO FOR ORIENTATION FLIPS 
						// UPDATE KNUCKELES BUT PRESERVE CACHED STATES AND
						else if ((cO.handList[j].type) && (cO.handList[j].fingerList.length == 5) &&(cO.handList[j].splay> 0.8))
							{
								//trace("reset hand skeleton");
								//reset hand type
									cO.handList[j].handLock = false;
									lockHandType()
								// reset skeleton
								createSkeleton(true);
								matchFingers(true);
								positionTips();
								positionJoints();
							}
						else{
								//trace("update skeleton")
								createSkeleton(false);
								matchFingers(false);
								positionTips();
								positionJoints();
						}
					}
					
				}
		}
		
		//NEED TO INCLUDE ORIENATION
		public function pushSeeds():void 
		{
			//RESET SEED LIST
			cO.handList[j].seedList.length = 0 ;
			cO.handList[j].seedList = new Vector.<Vector3D>();
			
			var align:Number = -(Math.PI / 24);
			var t3:Number = (Math.PI / 3);
			var t6:Number = (Math.PI / 6);
			var t12:Number = (Math.PI / 12);
			var x0:Number;
			var y0:Number;		
			var x1:Number;
			var y1:Number;		
			var x2:Number;
			var y2:Number;		
			var x3:Number;
			var y3:Number;		
			var x4:Number;
			var y4:Number;
									
									
									
									if (cO.handList[j].lockedType == "right")
									{
											 x0 = std_radius* Math.cos(7*t6);
											 y0 = std_radius* Math.sin(7*t6);
												
											 x1 = std_radius* Math.cos(2*t3);
											 y1 = std_radius * Math.sin(2*t3);
												
											 x2 = std_radius * Math.cos(3*t6);
											 y2 = std_radius * Math.sin(3*t6);
												
											 x3 = std_radius * Math.cos(t3);
											 y3 = std_radius * Math.sin(t3);
												
											 x4 = std_radius * Math.cos(t6);
											 y4 = std_radius * Math.sin(t6);
												
												cO.handList[j].seedList[0] = new Vector3D(x0, 0,y0);
												cO.handList[j].seedList[1]= new Vector3D(x1,0, y1);
												cO.handList[j].seedList[2]= new Vector3D(x2,0, y2);
												cO.handList[j].seedList[3] = new Vector3D(x3,0, y3);
												cO.handList[j].seedList[4] = new Vector3D(x4,0, y4);
									}
									
									else if (cO.handList[j].lockedType == "left")
									{
										 x0 = std_radius*1.2 * Math.cos(-t6+align); //
										 y0 = std_radius*1.2 * Math.sin(-t6+align); //
										
										 x1 = std_radius * Math.cos(t3-t12-align);
										 y1 = std_radius * Math.sin(t3-t12-align);
										
										 x2 = std_radius * Math.cos(3*t6-align);
										 y2 = std_radius * Math.sin(3*t6-align);
												
										 x3 = std_radius*1.0 * Math.cos(2*t3 + t12-align);
										 y3 = std_radius*1.0 * Math.sin(2*t3 + t12- align);
												
										 x4 = std_radius*1.4 * Math.cos(6*t6-align);
										 y4 = std_radius*1.4 * Math.sin(6*t6-align);

											cO.handList[j].seedList[0] = new Vector3D(x0, 0,y0);
											cO.handList[j].seedList[1] = new Vector3D(x1,0, y1);
											cO.handList[j].seedList[2] = new Vector3D(x2,0, y2);
											cO.handList[j].seedList[3] = new Vector3D(x3,0, y3);
											cO.handList[j].seedList[4] = new Vector3D(x4,0, y4);
									}
									else {
										cO.handList[j].seedList[0] = new Vector3D();
										cO.handList[j].seedList[1]= new Vector3D();
										cO.handList[j].seedList[2]= new Vector3D();
										cO.handList[j].seedList[3] = new Vector3D();
										cO.handList[j].seedList[4] = new Vector3D();
									}
		}
		
		public function createSkeleton(force_update:Boolean):void 
		{
			//trace("create hand")

			for (j = 0; j < cO.hn; j++)
				{
					// SEED SKELTON GEOMETRY
					if (cO.handList[j].seedList.length==0) pushSeeds()
					
						var s:int = 30;
						var p:Vector3D = cO.handList[j].position;
							var rotX:Number = RAD_DEG * Math.asin(cO.handList[j].normal.x);
							var rotY:Number = RAD_DEG * Math.asin(cO.handList[j].direction.x);
							var rotZ:Number = RAD_DEG * Math.asin(cO.handList[j].normal.z);
							
							// roate in 3d space
							var m:Matrix3D = new Matrix3D ()//(1,0,0,1,0,1,0,1,0,0,1,1,0,0,0,1);
								m.appendRotation(rotX, new Vector3D(0, 0, 1));
								m.appendRotation(rotZ, new Vector3D(-1, 0, 0));
								m.appendRotation(rotY, new Vector3D(0, 1, 0)); //direction
					
							var sn:int = cO.handList[j].seedList.length;
					
						//trace("sn",sn);
	
								if (force_update)
								{
								//trace("skeleton rebuilt");
								
								// CLEAR OUT LISTS
								cO.handList[j].knuckleList.length = 0;
								cO.handList[j].tipList.length = 0;
								cO.handList[j].dipList.length = 0;
								cO.handList[j].pipList.length = 0;
								
								//CLEAR FINGER REFERENCES TO FORCE ID CYCLE
								//cO.handList[j].thumb = null; // MUST RESET IN THUMB ID FUNCTION
								cO.handList[j].index = new MotionPointObject();
								cO.handList[j].middle = new MotionPointObject()//null;
								cO.handList[j].ring = new MotionPointObject()//null;
								cO.handList[j].pinky = new MotionPointObject()//null;
								
								//CLEAR FINGER IDS
								for (i = 0; i <cO.handList[j].fingerList.length; i++)
									{	
									if (cO.handList[j].fingerList[i].fingertype!="thumb") cO.handList[j].fingerList[i].fingertype = "";
									}
								
								//trace("create knuckle", sn)
								////////////////////////////////////////////////
								// CREATE SKELTAL KNUCLE, JOINTS AND TIPS SEEDS
								////////////////////////////////////////////////
									for (i = 0; i <sn; i++)//mpn
									{	
										//cO.handList[j].seedList.push(vArray[i]);
										
										// create static number of knuckles
										var kp:MotionPointObject = new MotionPointObject();
											kp.handID = cO.handList[j].handID;	
											kp.type = "mcp" + (i+1);
											
											var v:Vector3D = cO.handList[j].seedList[i];
											var pv:Vector3D = Utils3D.projectVector(m, v);			
											// translate
											var rv:Vector3D = p.add(pv);
								
											kp.position = rv;
											
										cO.handList[j].knuckleList.push(kp);
										
										//exclude thumb
										if (i != 0)
										{
											//create joints PIPS
											var j_pip:MotionPointObject = new MotionPointObject();
												j_pip.handID = cO.handList[j].handID;	
												j_pip.type = "pip" + (i);
												
												var ds:Vector3D = new Vector3D(cO.handList[j].direction.x * s, cO.handList[j].direction.y * s, cO.handList[j].direction.z * s);
												var vd:Vector3D = kp.position.add(ds);
												
												j_pip.position = vd;
											cO.handList[j].pipList.push(j_pip);
										}
										
										//create joints DIPS
										var j_dip:MotionPointObject = new MotionPointObject();
											j_dip.handID = cO.handList[j].handID;	
											j_dip.type = "dip" + (i+1);
											
											var ds2:Vector3D = new Vector3D(cO.handList[j].direction.x * s*1.3, cO.handList[j].direction.y * s*1.3, cO.handList[j].direction.z * s*1.3);
											var vd2:Vector3D = kp.position.add(ds2);
											j_dip.position = vd2;
										cO.handList[j].dipList.push(j_dip);
										
										// create TIPS
										var j_tip:MotionPointObject = new MotionPointObject();
											j_tip.handID = cO.handList[j].handID;	
											j_tip.type = "tip" + (i+1);
											
											var ds3:Vector3D = new Vector3D(cO.handList[j].direction.x * s*1.6, cO.handList[j].direction.y * s*1.6, cO.handList[j].direction.z * s*1.6);
											var vd3:Vector3D = kp.position.add(ds3);
											j_tip.position = vd3;
										cO.handList[j].tipList.push(j_tip);
										
									}
							
									//trace("build",cO.handList[j].knuckleList.length)
							}
							else
							{
								var kn:int = cO.handList[j].knuckleList.length;
								var dn:int = cO.handList[j].dipList.length
								var pn:int = cO.handList[j].pipList.length
								var tn:int = cO.handList[j].tipList.length;
								
								//trace("update joints",kn, dn,pn,tn, sn)
								
								//update knuckles
								for (i = 0; i <kn; i++)//mpn
									{	
										var v:Vector3D = cO.handList[j].seedList[i];
										var pv:Vector3D = Utils3D.projectVector(m, v);			
											
										// translate
										var rv:Vector3D = p.add(pv);
										cO.handList[j].knuckleList[i].position = rv;
									}
								
								//////////////////////////////////////////////////////////////////
								//CACHED POSITONS
								//update tips to cached values
								//TODO: MUST INCLUDE PALM ROATION IN PLANE
								for (i = 0; i <tn; i++)//mpn
									{		
										var v2:Vector3D = cO.handList[j].positionCached;
										var palm_vel:Vector3D = cO.handList[j].palm.position.subtract(v2);
										
										//GET POSITION CACHE
										if (cO.handList[j].tipList[i].positionCached)
										{
											var normal:Vector3D = cO.handList[j].palm.normal;
											var v0:Vector3D = cO.handList[j].tipList[i].positionCached;
												
											// FIND RELATIVE POSITON TO PALM
											var v:Vector3D = v0.subtract(cO.handList[j].palm.position);
											
											// PROJECT INTO THE PALM PLANE
											var dist:Number = (v.x * normal.x) + (v.y * normal.y) + (v.z * normal.z);
											var palm_plane_chachedtip:Vector3D = new Vector3D((v0.x - dist * normal.x), (v0.y -dist*normal.y), (v0.z - dist*normal.z));
											
											
											
											cO.handList[j].tipList[i].position = palm_plane_chachedtip.add(palm_vel);
										}
										//GET DIRECTION CACHE
										if (cO.handList[j].tipList[i].directionCached)
										{
											// get direction vector
											var v0:Vector3D = cO.handList[j].tipList[i].directionCached;
											
											//TRANSFORM VECTOR WITH PALM
											////project direction vecotr into the aplm plane 
											//var normal:Vector3D = cO.handList[j].palm.normal;
											//var dist:Number = v0.length; //(v0.x * normal.x) + (v0.y * normal.y) + (v0.z * normal.z);
											//var pp_ctip:Vector3D = new Vector3D((v0.x - dist * normal.x), (v0.y -dist*normal.y), (v0.z - dist*normal.z));
											//var pv:Vector3D = Utils3D.projectVector(m,  pp_ctip);//v0

											cO.handList[j].tipList[i].direction = v0;
										}
										
									}	
							}
						
						
							//trace(cO.handList[j].knuckleList.length);
							
					}
		}
		

		// UNIQUE FINGER IDS
		public function matchFingers(force_update:Boolean):void 
		{
			//force_update = true;
			
					for (j = 0; j < cO.hn; j++)
					{	
						
						// FIND MATCHING FINGER TIPS
						var fn = cO.handList[j].fingerList.length;
						var kn = cO.handList[j].knuckleList.length // ONLY WHEN KNUCKLES EXIST
						
						if (fn &&kn)
						{	

							var dist:Number;
							var hplane_pk:Vector3D
							var hplane_kf:Vector3D 
							var ang_hor:Number;
							var ang_palmdir:Number;
							
							//var k_value;
							//var type = cO.handList[j].knuckleList[i].type;
							var knuckle
							var palm = cO.handList[j].palm
							var projectedFAV = cO.handList[j].projectedFingerAveragePosition
							
							var minDist 
							var maxDist
							var maxAngleVert
							var maxAngleHor
							var maxAnglePalmDir
							
							
							//trace("t",cO.handList[j].thumb.motionPointID,cO.handList[j].thumb);
							
							//var tmpo:MotionPointObject = GestureGlobals.gw_public::motionPoints[cO.handList[j].thumb.motionPointID];
							if (cO.handList[j].thumb)
							{
							if (cO.handList[j].thumb.motionPointID) 
									{
										//test to see if middle finger motion poin still being tracked
										var mpo:MotionPointObject = GestureGlobals.gw_public::motionPoints[cO.handList[j].thumb.motionPointID];
										if (!mpo) {
											cO.handList[j].thumb.id = null;
											//trace("thumb nullified")
										}
										
									}
							}
							
							
							
							// make sure thumb eXists
							if (cO.handList[j].thumb)// tmpo
							{		
								
								//MIDDLE FINGER
								knuckle = cO.handList[j].knuckleList[2];
								maxDist = 80;
								minDist = 0//40;
								maxAngleHor = Math.PI / 30;
								maxAnglePalmDir = Math.PI / 40;
							
								for (var k:int = 0; k <fn; k++)// fingertips
								{
									//trace(cO.handList[j].fingerList[k].type, cO.handList[j].fingerList[k].fingertype);
									
									var finger = cO.handList[j].fingerList[k];
									
									//trace("middle",cO.handList[j].middle.id,cO.handList[j].middle.motionPointID)
									
									if ((finger.fingertype != "thumb")&&(finger.fingertype == "")&&(finger.fingertype != "middle")&&(!cO.handList[j].middle.id))
									{
										//GET FINGER KNUCKLE DISTANCE
										dist = Vector3D.distance(knuckle.position, finger.position);
										//GET PALM TO KNUCKLE VECTOR IN horizontal PLANE
										hplane_pk = knuckle.position.subtract(palm.position);
										//GET FINGER TO KNUCKLE VECTOR IN Horizontal PLANE
										hplane_kf = finger.palmplane_position.subtract(knuckle.position);
										
										//get angle btween in horizontal
										ang_hor = Vector3D.angleBetween(hplane_pk, hplane_kf);
										
										//get angle btween in horizontal
										//ang_ver = Vector3D.angleBetween(vplane_pk, vplane_kf);
										
										//GET ANGLE BETWEEN FINGER AND PLAM DIRECTION
										ang_palmdir = Vector3D.angleBetween( palm.direction, hplane_kf);
										
										//trace("finger assignment", dist, ang_hor, ang_palmdir)

										if ((dist < maxDist)&&((dist > minDist))&&(ang_hor<maxAngleHor)&&(ang_hor<maxAnglePalmDir))
										{
											//trace("middle finger assignment", dist, ang_hor,maxAngleHor,ang_palmdir,   cO.handList[j].fingerList[k].fingertype,cO.handList[j].middle.id)
											cO.handList[j].fingerList[k].fingertype = "middle";
											cO.handList[j].middle = cO.handList[j].fingerList[k];
										}
									}
									else if (cO.handList[j].middle) 
									{
										//test to see if middle finger motion poin still being tracked
										var mpo:MotionPointObject = GestureGlobals.gw_public::motionPoints[cO.handList[j].middle.motionPointID];
										if (!mpo) {
											cO.handList[j].middle.id = null;
											//trace("middle nullified")
										}
										
									}
								}
								
								
								//PINKY FINGER
								// USE HANDEDNESS TO STRENGTHERN ID
								knuckle = cO.handList[j].knuckleList[4];
								maxDist = 70;
								minDist = 0//30;
								maxAngleHor = Math.PI / 2//30;
								maxAnglePalmDir = Math.PI/3;
							
								for (var k:int = 0; k <fn; k++)// fingertips
								{
									//trace(cO.handList[j].fingerList[k].type, cO.handList[j].fingerList[k].fingertype);
									
									var finger = cO.handList[j].fingerList[k];
									
									//trace("pinky",cO.handList[j].pinky.id,cO.handList[j].pinky.motionPointID)
									
									if ((finger.fingertype != "thumb")&&(finger.fingertype == "")&&(finger.fingertype != "pinky")&&(!cO.handList[j].pinky.id))
									{
										//GET FINGER KNUCKLE DISTANCE
										dist = Vector3D.distance(knuckle.position, finger.position);
										//GET PALM TO KNUCKLE VECTOR IN horizontal PLANE
										hplane_pk = knuckle.position.subtract(palm.position);
										//GET FINGER TO KNUCKLE VECTOR IN Horizontal PLANE
										hplane_kf = finger.palmplane_position.subtract(knuckle.position);
										
										//get angle between finger and knuckle in horizontal palm plane
										ang_hor = Vector3D.angleBetween( hplane_kf,hplane_pk);
										
										//get angle btween in horizontal
										//ang_ver = Vector3D.angleBetween(vplane_pk, vplane_kf);
										
										//GET ANGLE BETWEEN FINGER AND PLAM DIRECTION
										ang_palmdir = Vector3D.angleBetween( palm.direction, hplane_kf);
										
										//trace("pinky finger assignment", dist, ang_hor)

										if ((dist < maxDist)&&(dist > minDist)&&(ang_hor<maxAngleHor)&&(ang_palmdir<maxAnglePalmDir))
										{
											//trace("finger",k, dist, ang_hor,maxAngleHor, ang_palmdir)
											cO.handList[j].fingerList[k].fingertype = "pinky";
											cO.handList[j].pinky = cO.handList[j].fingerList[k];
										}
									}
									else if (cO.handList[j].pinky) 
									{
										//test to see if middle finger motion poin still being tracked
										var mpo:MotionPointObject = GestureGlobals.gw_public::motionPoints[cO.handList[j].pinky.motionPointID];
										if (!mpo){
											cO.handList[j].pinky.id = null;
											//trace("pinky nullified")
										}
									}
								}
								
								
								
								//INDEX FINGER
								// WANTS TO CONFUSE WITH MIDDLE AND THUMB
								// USE HANDEDNESS TO STRENGTHERN ID
								knuckle = cO.handList[j].knuckleList[1];
								maxDist = 70;
								minDist = 0//35;
								maxAngleHor = Math.PI / 5;
								maxAnglePalmDir = Math.PI/5;
							
								for (var k:int = 0; k <fn; k++)// fingertips
								{
									//trace(cO.handList[j].fingerList[k].type, cO.handList[j].fingerList[k].fingertype);
									
									var finger = cO.handList[j].fingerList[k];
									
									//trace("pinky",cO.handList[j].pinky.id,cO.handList[j].pinky.motionPointID)
									
									if ((finger.fingertype != "thumb")&&(finger.fingertype == "")&&(finger.fingertype != "index")&&(!cO.handList[j].index.id))
									{
										//GET FINGER KNUCKLE DISTANCE
										dist = Vector3D.distance(knuckle.position, finger.position);
										//GET PALM TO KNUCKLE VECTOR IN horizontal PLANE
										hplane_pk = knuckle.position.subtract(palm.position);
										//GET FINGER TO KNUCKLE VECTOR IN Horizontal PLANE
										//hplane_kf = finger.palmplane_position.subtract(knuckle.position);
										hplane_kf = finger.position.subtract(knuckle.position);
										
										//get angle between finger and knuckle in horizontal palm plane
										ang_hor = Vector3D.angleBetween( hplane_kf,hplane_pk);
										
										//get angle btween in horizontal
										//ang_ver = Vector3D.angleBetween(vplane_pk, vplane_kf);
										
										//GET ANGLE BETWEEN FINGER AND PLAM DIRECTION
										ang_palmdir = Vector3D.angleBetween( palm.direction, hplane_kf);
										
										//trace("pinky finger assignment", dist, ang_hor)

										if ((dist < maxDist)&&(dist > minDist)&&(ang_hor<maxAngleHor)&&(ang_palmdir<maxAnglePalmDir))
										{
											//trace("finger",k,knuckle.type, dist, ang_hor, maxAngleHor, ang_palmdir,maxAnglePalmDir)
											cO.handList[j].fingerList[k].fingertype = "index";
											cO.handList[j].index = cO.handList[j].fingerList[k];
										}
									}
									else if (cO.handList[j].index) 
									{
										//test to see if middle finger motion poin still being tracked
										var mpo:MotionPointObject = GestureGlobals.gw_public::motionPoints[cO.handList[j].index.motionPointID];
										if (!mpo) {
											cO.handList[j].index.id = null;
											//trace("index nullified")
										}
									}
								}
								

								//RING FINGER
								//WANTS TO CONFUSE WITH PINKY (MUST FIND PINKY FIRST)
								// USE HANDEDNESS TO STRENGTHERN ID
								knuckle = cO.handList[j].knuckleList[3];
								maxDist = 70;
								minDist = 0//35;
								maxAngleHor = Math.PI / 4;
								//minAngleHor = Math.PI / 3;
								maxAnglePalmDir = Math.PI/15;
							
								for (var k:int = 0; k <fn; k++)// fingertips
								{
									//trace(cO.handList[j].fingerList[k].type, cO.handList[j].fingerList[k].fingertype);
									
									var finger = cO.handList[j].fingerList[k];
									
									//trace("pinky",cO.handList[j].pinky.id,cO.handList[j].pinky.motionPointID)
									
									if ((finger.fingertype != "thumb")&&(finger.fingertype == "")&&(finger.fingertype != "ring")&&(!cO.handList[j].ring.id))
									{
										//GET FINGER KNUCKLE DISTANCE
										dist = Vector3D.distance(knuckle.position, finger.position);
										//GET PALM TO KNUCKLE VECTOR IN horizontal PLANE
										hplane_pk = knuckle.position.subtract(palm.position);
										//GET FINGER TO KNUCKLE VECTOR IN Horizontal PLANE
										hplane_kf = finger.palmplane_position.subtract(knuckle.position);
										//hplane_kf = finger.position.subtract(knuckle.position);
										
										//get angle between finger and knuckle in horizontal palm plane
										ang_hor = Vector3D.angleBetween( hplane_kf,hplane_pk);
										
										//get angle btween in horizontal
										//ang_ver = Vector3D.angleBetween(vplane_pk, vplane_kf);
										
										//GET ANGLE BETWEEN FINGER AND PLAM DIRECTION
										ang_palmdir = Vector3D.angleBetween( palm.direction, hplane_kf);
										
										//trace("pinky finger assignment", dist, ang_hor)

										if ((dist < maxDist)&&(dist > minDist)&&(ang_hor<maxAngleHor))//&&(ang_palmdir<maxAnglePalmDir))
										{
											//trace("finger",k,knuckle.type, dist, ang_hor, maxAngleHor, ang_palmdir,maxAnglePalmDir)
											cO.handList[j].fingerList[k].fingertype = "ring";
											cO.handList[j].ring = cO.handList[j].fingerList[k];
										}
									}
									else if (cO.handList[j].ring) 
									{
										//test to see if middle finger motion poin still being tracked
										var mpo:MotionPointObject = GestureGlobals.gw_public::motionPoints[cO.handList[j].ring.motionPointID];
										if (!mpo) {
											cO.handList[j].ring.id = null;
											//trace("ring nullified")
										}
									}
								}
								}
							}
					}
		}
		

		//TODO FIGURE OUT FRONZEN TIP PROBLEM (IS IT BECAUSE NO CACHE POSITON EXISTS??)
		// FIGURE OUT WHY CACHING IS SLOW (CACHED POSITON SEEMS TO BE 10 FRAMES BACK WHEN LOOK ING AT HIGH CURL)
		public function positionTips():void 
		{
			//force_update = true;
			//trace("positionTips");
			
				for (j = 0; j < cO.hn; j++)
					{	
						// FIND MATCHING FINGER TIPS
						
						var tn = cO.handList[j].tipList.length;
						var kn = cO.handList[j].knuckleList.length;
						
						if (kn&&tn) // ONLY WHEN KNUCKLES EXIST
						{
							//thumb	
							if (cO.handList[j].thumb){
								if (cO.handList[j].thumb.id)
								{
								cO.handList[j].tipList[0].position = cO.handList[j].thumb.position;
								cO.handList[j].tipList[0].direction = cO.handList[j].thumb.direction;
								//trace("thumb",cO.handList[j].thumb);
								}	
							}
							//index	
							if (cO.handList[j].index.id)
							{
								cO.handList[j].tipList[1].position = cO.handList[j].index.position;
								cO.handList[j].tipList[1].direction = cO.handList[j].index.direction;
								//trace("index",cO.handList[j].index);
							}
							//middle
							if (cO.handList[j].middle.id)
							{
							cO.handList[j].tipList[2].position = cO.handList[j].middle.position;
							cO.handList[j].tipList[2].direction = cO.handList[j].middle.direction;
							}
							//ring	
							if (cO.handList[j].ring.id)
							{
							cO.handList[j].tipList[3].position = cO.handList[j].ring.position;
							cO.handList[j].tipList[3].direction = cO.handList[j].ring.direction;
							}
							//pinky		
							if (cO.handList[j].pinky.id)
							{
							cO.handList[j].tipList[4].position = cO.handList[j].pinky.position;
							cO.handList[j].tipList[4].direction = cO.handList[j].pinky.direction;
							}
							
							///////////////////////////
							//CACHE FINGER TIP VALUES
							for (var m:int = 0; m <tn; m++)// fingertips
							{
							var tp = cO.handList[j].tipList[m];
								tp.positionCached = tp.position;
								tp.directionCached = tp.direction;
								
								//trace("cache test",m,tp.positionCached, tp.position)
							}
							
						

						}
						////////////////////////
						//cache palm position
						cO.handList[j].positionCached = cO.handList[j].position;
					}
		}
		
		public function positionJoints():void 
		{
			// JOINT ALWAYS REPOSITIONED AS ARE DIRECT CONSEQUENCE ON TIPS AND KNUCKLES WHICH "ALWAYS" EXIST
			
					for (j = 0; j < cO.hn; j++)
					{	
						// FIND MATCHING FINGER TIPS
						var fn = cO.handList[j].tipList.length;
						
						if (cO.handList[j].knuckleList.length != 0)// ONLY WHEN KNUCKLES EXIST
						{
							
							for (var k:int = 0; k <fn; k++)// fingertips
							{
							
									//get tip
									var ft = cO.handList[j].tipList[k];
									
									// draw back to knucle from tip to knuckle
									for (var m:int = 0; m <cO.handList[j].dipList.length; m++)// fingertips
									{
										var dp = cO.handList[j].dipList[m];
									
										//POSITION DIPS
										if (k==m) 
										{
											var pos:Vector3D = ft.position;
											var dir:Vector3D = ft.direction;
											var scale:Number = 15
											var dir_scale:Vector3D = new Vector3D(dir.x*scale,dir.y*scale,dir.z*scale)
											var v:Vector3D  = pos.subtract(dir_scale);
											
											//trace(v)
											dp.position = v;
										}
									}
									
									//POSITION PIPS
									for (var m:int = 0; m <cO.handList[j].pipList.length; m++)// fingertips
									{
										var pp = cO.handList[j].pipList[m];
										
										if ((k-1)==m) 
										{
											// get anchor point
											var pos:Vector3D = ft.position;
											var dir:Vector3D = ft.direction;
											var scale:Number = 30
											var dir_scale:Vector3D = new Vector3D(dir.x*scale,dir.y*scale,dir.z*scale)
											var v:Vector3D  = pos.subtract(dir_scale);
											
											// get knuckle direction
											var kp:Vector3D = cO.handList[j].knuckleList[m + 1].position;
											var dir:Vector3D = v.subtract(kp);
											var scale2:Number = 0.3;
											var dir_scale2:Vector3D = new Vector3D(dir.x * scale2, dir.y * scale2, dir.z * scale2);
											// move dist towards knuckle
											var v2:Vector3D = v.subtract(dir_scale2);
											
											pp.position = v2;
										}
									}
								
								
						}
					}
					}
			
		}
		
		
		
		
		
		public function findFingerAverage():void 
		{

				//////////////////////////////////////////////////////////////////////////////
				// GET FAV 
				for (j = 0; j < cO.hn; j++)
				{
					var fav_pt:Vector3D = new Vector3D();
					var pfav_pt:Vector3D = new Vector3D();
					var hfn:int = cO.handList[j].fingerList.length;
					var hfnk:Number = 0;
					
					if (hfn) hfnk = 1 / hfn;
					
					for (i = 0; i < hfn; i++)
							{	
									var fpt:MotionPointObject = cO.handList[j].fingerList[i];

									// finger average point (fingers + thumb)
									fav_pt.x += fpt.position.x;
									fav_pt.y += fpt.position.y;
									fav_pt.z += fpt.position.z;
									
									if (fpt.fingertype == "finger") 
									//if (cO.motionArray[i].fingertype == "finger") // add other finger types
									{
										// finger average point
										pfav_pt.x += fpt.position.x;
										pfav_pt.y += fpt.position.y;
										pfav_pt.z += fpt.position.z;
									}
							}
							fav_pt.x *= hfnk;
							fav_pt.y *= hfnk;
							fav_pt.z *= hfnk;
							
							pfav_pt.x *= hfnk-1;
							pfav_pt.y *= hfnk-1;
							pfav_pt.z *= hfnk - 1;
							
							// TEST
							///////////////////////////////////////////////////////////////////////
							// CALCUALTE DIRECTION OF HAND
							//var direction:Vector3D = fav_pt.subtract(cO.handList[j].palm.position);
							//cO.handList[j].palm.direction = direction;
							//////////////////////////////////////////////////////////////////////
							
							//////////////////////////////////////////////////////////////////////////////////////////////////
							// push fav point to hand object
							cO.handList[j].fingerAveragePosition = fav_pt;
							cO.handList[j].pureFingerAveragePosition = pfav_pt;
								
							///////////////////////////////////////////////////////////////////////////////////////////////////			
							// GET HAND ORIENTATION
							var v:Vector3D = cO.handList[j].fingerAveragePosition.subtract(cO.handList[j].palm.position)
							var orienAngle:Number = v.dotProduct(cO.handList[j].palm.normal);// Vector3D.angleBetween(v0, v1);
							
							if (orienAngle > 0) {
								cO.handList[j].orientation = "down";
							}
							else if (orienAngle < 0) {
								cO.handList[j].orientation = "up";
							}
							//else cO.handList[j].orientation = "udefined";
							//trace(orienAngle,cO.handList[j].orientation);
				}
				//trace("hand pos",cO.hand.position)
		}

		
		public function findHandRadius():void 
		{

			for (j = 0; j < cO.hn; j++)
				{
					//trace("number finger",fn,fnk,fav_pt.x,fav_pt.y,fav_pt.z)
					var favlength:Number = 0//100//100;
					var palmratio:Number = 0.6//1.4;
							
					var hfn:int = cO.handList[j].fingerList.length;
					var hfnk:Number = 0;
					if (hfn) hfnk = 1 / hfn;
					
						for (i = 0; i < hfn; i++)
								{
								//if(){
								cO.handList[j].fingerList[i].favdist = Vector3D.distance(cO.handList[j].fingerList[i].position, cO.handList[j].fingerAveragePosition);
								// find average max length
								//favlength += cO.handList[j].fingerList[i].max_length; //??????
								favlength += cO.handList[j].fingerList[i].favdist; 
								//trace("favdist", cO.handList[j].fingerList[i].max_length, cO.handList[j].fingerList[i].favdist,cO.handList[j].fingerList[i].fingertype, hfnk)
								//}
								}
					favlength *= hfnk;	
					//trace(palmratio , favlength);
					
					// AVERAGE HAND RADIUS
					cO.handList[j].radius = favlength * palmratio;	
					//cO.handList[j].sphereRadius = favdist * palmratio;	
					//trace("rad",cO.handList[j].sphereRadius)
				}
		}
		
		
		
		// get nomalized finger length and palm angle
		// splay and flatness
		public function normalizeFingerSize():void 
		{
			var min_max_length:Number;
			var max_max_length:Number;
			var min_max_width:Number;
			var max_max_width:Number;
			var min_length:Number;
			var max_length:Number;
			var min_width:Number
			var max_width:Number
			var min_palmAngle:Number
			var max_palmAngle:Number
			var min_favdist:Number;
			var max_favdist:Number;
			var min_mwlr:Number;
			var max_mwlr:Number;
			
			
			for (j = 0; j < cO.hn; j++)
			{
				
			min_max_length = 0;
			max_max_length = 0;
			min_max_width = 0;
			max_max_width = 0;
			min_length = 0;
			max_length = 0;
			min_width = 0;
			max_width = 0;
			min_palmAngle = 0;
			max_palmAngle = 0;
			min_favdist = 0;
			max_favdist = 0;
			min_mwlr = 0;
			max_mwlr = 0;
				
			var hfn:uint = cO.handList[j].fingerList.length;
			var palm_mpoint:MotionPointObject = cO.handList[j].palm; // NEED TO SIMPLIFY		
			
			var normal:Vector3D = palm_mpoint.normal;
			var p_pos:Vector3D = palm_mpoint.position;
			var fav_pos:Vector3D = cO.handList[j].fingerAveragePosition;
			var fvp_mp:Vector3D = fav_pos.subtract(p_pos);
			
			var dist:Number = (fvp_mp.x * normal.x) + (fvp_mp.y * normal.y) + (fvp_mp.z * normal.z);
			var palm_plane_favpoint:Vector3D = new Vector3D((fav_pos.x - dist * normal.x), (fav_pos.y -dist*normal.y), (fav_pos.z - dist*normal.z));
							
			///////////////////////////////////////////////////
			// set plam plane fav projection point
			cO.handList[j].projectedFingerAveragePosition = palm_plane_favpoint;
			
			
			// get values
			for (i = 0; i < hfn; i++)
				{	
					var fpt:MotionPointObject = cO.handList[j].fingerList[i];
						
							
							var f_pos:Vector3D = fpt.position;
							
							var vp_mp:Vector3D = f_pos.subtract(p_pos);

							var dist1:Number = (vp_mp.x * normal.x) + (vp_mp.y * normal.y) + (vp_mp.z * normal.z);
							var palm_plane_point:Vector3D = new Vector3D((f_pos.x - dist1 * normal.x), (f_pos.y -dist1*normal.y), (f_pos.z - dist1*normal.z));
							
							fpt.palmplane_position = palm_plane_point
							//trace("projected point in palm plane",palm_plane_point)
				
							var ppp_dir:Vector3D = palm_plane_point.subtract(p_pos);
							
							// set palm angle of point
							fpt.palmAngle =  Vector3D.angleBetween(ppp_dir, palm_mpoint.direction);
							//palmAngle = Math.abs(Vector3D.angleBetween(cO.motionArray[i].direction, palm_mpoint.direction));

							// calc proper length from palm
							fpt.length = Vector3D.distance(p_pos, f_pos) //- std_radius;
							
							// FIND EXTENSION MEASURE
							var palm_finger_vector:Vector3D = fpt.position.subtract(palm_mpoint.position);
							var angle_diff:Number = Vector3D.angleBetween(fpt.direction, palm_finger_vector);
							// normalize
							fpt.extension = normalize(angle_diff, 0, Math.PI*0.5);
				}
						
				// find max and min values
				for (i = 0; i < hfn; i++)
				{
					var fpt0:MotionPointObject = cO.handList[j].fingerList[i];
					
						//max length max and min
						//var value_max_length:Number = fpt0.max_length;
						//if (value_max_length > max_max_length) max_max_length = value_max_length;
						//if ((value_max_length < min_max_length)&&(value_max_length!=0)) min_max_length = value_max_length;
						
						// length max and min
						var value_length:Number = fpt0.length;
						if (value_length > max_length) max_length = value_length;
						if ((value_length < min_length) && (value_length != 0)) min_length = value_length;
						
						// width max and min
						var value_width:Number = fpt0.width;
						if (value_width > max_width) max_width = value_width;
						if ((value_width < min_width)&&(value_width!=0)) min_width = value_width;
						
						// palm angle max and min
						var value_palm:Number = fpt0.palmAngle;
						if (value_palm > max_palmAngle) max_palmAngle = value_palm;
						if ((value_palm < min_palmAngle)&&(value_palm!=0)) min_palmAngle = value_palm;

						//finge raverage distance max and min
						var value:Number = fpt0.favdist;
						if (value > max_favdist) max_favdist = value;
						if ((value < min_favdist) && (value != 0)) min_favdist = value;
						
						
						//////////////////////////////////////////////////////////////////////////////
						// FIND MAX AND MIN LENGTHS AND WIDTH THAT ARE STORED IN THE MOTION POINT OBJECT
						
						// length max and min
						var value_length:Number = fpt0.length;
						if (value_length > fpt0.max_length) fpt0.max_length = value_length;
						if ((value_length < fpt0.min_length) && (value_length != 0)) fpt0.min_length = value_length;
						
						// width max and min
						var value_width:Number = fpt0.width;
						if (value_width > fpt0.max_width) fpt0.max_width = value_width;
						if ((value_width < fpt0.min_width)&&(value_width!=0)) fpt0.min_width = value_width;
				}
				
				for (i = 0; i < hfn; i++)
				{
					var fpt:MotionPointObject = cO.handList[j].fingerList[i];
					
						//max length max and min
						var value_max_length:Number = fpt.max_length;
						if (value_max_length > max_max_length) max_max_length = value_max_length;
						if ((value_max_length < min_max_length) && (value_max_length != 0)) min_max_length = value_max_length;
						
						var value_max_width:Number = fpt.max_width;
						if (value_max_width > max_max_width) max_max_width = value_max_width;
						if ((value_max_width < min_max_width) && (value_max_width != 0)) min_max_width = value_max_width;
						
						
						//CACULATE MAX_WIDTH TO MAX_LENGTH RATIO FOR EACH FINGER
						fpt.max_width_length_ratio = fpt.max_width/fpt.max_length
				}
				
				
				var avg_palm_angle:Number = 0;
				
				//normalize values and update
				for (i = 0; i < hfn; i++)
					{
						var fpt1:MotionPointObject = cO.handList[j].fingerList[i];
						//trace(fpt1.max_length, min_max_length, max_max_length)
						fpt1.normalized_max_length = normalize(fpt1.max_length, min_max_length, max_max_length);
						fpt1.normalized_length = normalize(fpt1.length, min_length, max_length);
						
						// native websocket does not provice width
						
						if (fpt1.width) {
							fpt1.normalized_max_width = normalize(fpt1.max_width, min_max_width, max_max_width);
							fpt1.normalized_width = normalize(fpt1.width, min_width, max_width);
						}
						else {
							fpt1.normalized_width = 0;
							fpt1.normalized_max_width = 0;
						}
						
						fpt1.normalized_palmAngle = normalize(fpt1.palmAngle, min_palmAngle, max_palmAngle);
						fpt1.normalized_favdist = normalize(fpt1.favdist, min_favdist, max_favdist);
						
						
						
						//AVERGE PALM ANGLE
						avg_palm_angle += fpt1.normalized_palmAngle;
						
						//trace("hand normalized values",i,fpt1.type,fpt1.fingertype,fpt1.normalized_length,fpt1.normalized_max_length,fpt1.normalized_palmAngle,fpt1.normalized_favdist)
						
						//GET MAX AND MIN WLRATIO
						var value_mwlr:Number = fpt1.max_width_length_ratio;
						if (value_mwlr > max_mwlr) max_mwlr = value_mwlr;
						if ((value_mwlr < min_mwlr)&&(value_mwlr!=0))min_mwlr = value_mwlr;
					}
					
					// set normalized mwlr values
					for (i = 0; i < hfn; i++)
					{
						var fpt3 = cO.handList[j].fingerList[i];
						fpt3.normalized_mwlr = normalize(fpt3.max_width_length_ratio, min_mwlr, max_mwlr);
						//trace("hand normalized values",i,fpt3.normalized_length,fpt3.normalized_width, fpt3.normalized_max_length,fpt3.normalized_max_width,fpt3.normalized_mwlr)

					}
					
					
					
					///////////////////////////////////////////////////////////////////////////////////////////////
					// FIND HAND FLATNESS MEASURE
					// DIST BETWEEN FAV POINT AND PROJECTED FAV POINT IN PLANE
					var pfav_fav_dist:Number = Vector3D.distance(palm_plane_favpoint,fav_pos)
					cO.handList[j].flatness = normalize(pfav_fav_dist, 0, 30);
					//trace("flatness", cO.handList[j].flatness);
					
					////////////////////////////////////////////////////////////////////////////////////////////////
					// FIND HAND SPLAY MEASURE
					//avg_palm_angle = avg_palm_angle / hfn;
					
					var splay_d:Number = 0;
					
					// MUST MAKE DISTANCE PAIR LIST
					for (var i:int = 0; i < hfn; i++)
					{
					for (var q:int = 0; q < i+1; q++)
					{
						if (i!=q)
						{
							var dist0:Number = Vector3D.distance(cO.handList[j].fingerList[i].position,cO.handList[j].fingerList[q].position);
							splay_d += dist0;
						}
					}
					}
					
					splay_d = 2 * splay_d / (hfn * (hfn - 1));
					cO.handList[j].splay = normalize(splay_d, 30, 120);
					//trace("splay", cO.handList[j].splay);
					
			}
		}
		
		
		// find thumb .. generate pair data
		public function findThumb():void
		{
		
		for (j = 0; j < cO.hn; j++)
				{
					
			//if (cO.handList[j].fingerList.length == 5)//&&(cO.handList[j].thumb==undefined))
			//{
				
				//trace("splay",cO.handList[j].splay)
				
				
			cO.handList[j].pair_table = new Array();
			
			var hfn:int = cO.handList[j].fingerList.length;
			
			var fpt:MotionPointObject //= cO.handList[j].fingerList[i];
			var palm_mpoint:MotionPointObject

						///////////////////////////////////////////////////////////////////////////////////
						// MOD THUMB PROB WITH FINGER LENGTH AND WIDTH
						
							// reset thumb
							//cO.handList[j].thumb = new MotionPointObject();
							
							// get largest thumb prob
							var thumb_list:Array = new Array()
							
							//trace("--");
							
							
							if ((cO.handList[j].lockedType == "left") || (cO.handList[j].lockedType == "right")) 
							{
								//trace("handedness known, check context of new candidates", cO.handList[j].type,cO.handList[j].lockedType);
								var palmcross:Vector3D = cO.handList[j].palm.normal.crossProduct(cO.handList[j].palm.direction);
							}
							
							
							for (i = 0; i < hfn; i++)
								{
									fpt = cO.handList[j].fingerList[i];
									
									// RESET THUMB PROB HIST
									//if (fpt.fingertype == "thumb") trace(fpt.thumb_prob);//fpt.thumb_prob = 1; 
									//else { fpt.thumb_prob = 0};
									fpt.thumb_prob = 0
									//fpt.fingertype = "";
									
									
									//ALL FEATURES////////////////////////////////////////////////////////////
									fpt.thumb_prob += 2*(1- fpt.normalized_length)//2
									fpt.thumb_prob += 5*(fpt.normalized_favdist) //WORKS VERY WELL ON OWN
									fpt.thumb_prob += 2 * (fpt.normalized_palmAngle);//2
									fpt.thumb_prob += 1 * (fpt.normalized_mwlr); //width to length ratio
									//fpt.thumb_prob += 1 * (fpt.normalized_width) // exeperimentatal
									//ALSO USE NORLAIZED AVERAGE EXTENSION (THUMB TENDS TO BEND MORE AS NO PIP)
									
									//trace("norm mwlr", fpt.thumb_prob,fpt.normalized_mwlr,fpt.normalized_width,fpt.normalized_length);
									//trace(i, fpt.width, fpt.normalized_width, fpt.length, fpt.normalized_length, fpt.normalized_favdist,fpt.normalized_palmAngle,fpt.normalized_mwlr, fpt.thumb_prob);
									
									thumb_list[i] = fpt.thumb_prob;
									/////////////////////////////////////////////////////////////////////////
								}	
							
						///////////////////////////////////////////////////////////////////////////////////
						// SET FINGER TO THUMB BASED ON HIGHEST PROB
						var max_tp:Number = Math.max.apply(null, thumb_list);
						var max_index:int = thumb_list.indexOf(max_tp);
						
						if ((max_index != -1) && ( cO.handList[j].fingerList[max_index]) && (cO.handList[j].fingerList[max_index].type == "finger")) //&&(!cO.handList[j].thumb)
						{
							
							// 
							//var v = cO.handList[j].projectedFingerAveragePosition.subtract(cO.handList[j].palm.position)
							var v:Vector3D = cO.handList[j].palm.direction;
							var v1:Vector3D = cO.handList[j].fingerList[max_index].palmplane_position.subtract(cO.handList[j].palm.position)
							
							var angle:Number = Vector3D.angleBetween(v, v1)
							var length:int = cO.handList[j].fingerList[max_index].length;
							var favdist:Number = cO.handList[j].fingerList[max_index].favdist;
							
								//////////////////////////////////////////////////////////////////////
								// QUICK EFFECTIVE METRIC/////////////////////////////////////////////
								// FOR WHEN FN!=5
								var ratio:Number = (1.1*length) / (favdist + 50 * angle)
								//////////////////////////////////////////////////////////
								
								
								//////////////////////////////////////////////////////////////////////
								// THUMB VALIDITY CHECK
								var validthumb:Boolean = true;// init value when no type lock
								if ((cO.handList[j].lockedType == "left") || (cO.handList[j].lockedType == "right")) 
									{
										validthumb = false; 
										
											if ((cO.handList[j].fingerList[max_index]) && (cO.handList[j].palm))
											{
												var tVector:Vector3D = cO.handList[j].fingerList[max_index].position.subtract(cO.handList[j].palm.position);
												var angle2:Number = palmcross.dotProduct(tVector);
												
												if ((angle2 < 0)&&(cO.handList[j].lockedType == "left")) {
													validthumb = true;
												}
												//right match
												if ((angle2 > 0)&&(cO.handList[j].lockedType == "right")) {
													validthumb = true;
												}
											}
									}
								/////////////////////////////////////////////////////////////////////////
								

								if (validthumb)
								{
									//trace(ratio);
									if (hfn == 5)
									{
									if ((ratio < 0.8))//0.56
									{
										// SET THUMB TYPE
										cO.handList[j].fingerList[max_index].fingertype = "thumb";	
									
										// SET THUMB IN HAND OBJECT
										cO.handList[j].thumb = cO.handList[j].fingerList[max_index];
										//trace("assign thumb", hfn);
										return
									}
									else {
										cO.handList[j].fingerList[max_index].fingertype = "";
										cO.handList[j].thumb = null//cO.handList[j].fingerList[max_index];//null
										//trace("fail", hfn,cO.handList[j].fingerList[max_index].position);
									}
									}
									else if (hfn == 4)
									{
									if ((ratio < 0.70))
									{
										// SET THUMB TYPE
										cO.handList[j].fingerList[max_index].fingertype = "thumb";	
									
										// SET THUMB IN HAND OBJECT
										cO.handList[j].thumb = cO.handList[j].fingerList[max_index];
										//trace("assign thumb", hfn);
										return
									}
									else {
										cO.handList[j].fingerList[max_index].fingertype = ""//"finger";
										cO.handList[j].thumb = null//cO.handList[j].fingerList[max_index];//null
										//trace("fail", hfn,cO.handList[j].fingerList[max_index].position);
									}
									}
									else if (hfn == 3)
									{
									if (ratio < 1.2)
									{
										// SET THUMB TYPE
										cO.handList[j].fingerList[max_index].fingertype = "thumb";	
									
										// SET THUMB IN HAND OBJECT
										cO.handList[j].thumb = cO.handList[j].fingerList[max_index];
										//trace("assign thumb", hfn);
										return
									}
									else {
										cO.handList[j].fingerList[max_index].fingertype = ""//"finger";
										cO.handList[j].thumb = null//cO.handList[j].fingerList[max_index];//null
										//trace("fail", hfn,cO.handList[j].fingerList[max_index].position);
									}
									}
									
									else if (hfn == 2) 
									{
										if (ratio < 2.1)
										{
										cO.handList[j].fingerList[max_index].fingertype = "thumb";
										cO.handList[j].thumb = cO.handList[j].fingerList[max_index];
										return
										}
										
										else {
										cO.handList[j].fingerList[max_index].fingertype =""// "finger";
										cO.handList[j].thumb = null;
										}
									}
								}
							//}
						}
						
						
						// NEED SECONDARY CONDITIONS TO ENSURE PINKY NOT SELECTED
						// CHECK LOCKED TYPE SEE IF ON CORRECT SIDE OF HAND
						else if ((validthumb)&&(hfn == 1))
						{
							// RATIO BREAKS APPART AS LENGTH AND FAV DIST NO LONGER RELEVANT
							// ANGLE IS ONLY REMAINING METRIC
							var v0:Vector3D = cO.handList[j].palm.direction
							var v10:Vector3D = cO.handList[j].fingerList[0].palmplane_position.subtract(cO.handList[j].palm.position)
							var angle0:Number = Vector3D.angleBetween(v0, v10)
							//trace("one", angle);
							
								if (angle0 > 0.2)
								{
									//trace("one")
									cO.handList[j].fingerList[0].fingertype = "thumb";
									cO.handList[j].thumb = cO.handList[j].fingerList[0];
									return
								}
								else {
									cO.handList[j].fingerList[0].fingertype =""// "finger";
									cO.handList[j].thumb = null;
								}
								
							}
						//}
	
						
						
							
							
							
						////////////////////////////////////////////////////////////////////////////////
						// GET HANDEDNESS
						// PERHAPS CROSS CHECK WITH ORIENTATION
						if (cO.handList[j].thumb)
						{
							//trace("thumb",cO.handList[j].thumb.width,cO.handList[j].thumb.normalized_width,cO.handList[j].thumb.normalized_mwlr)
							
							var palmcross:Vector3D = cO.handList[j].palm.normal.crossProduct(cO.handList[j].palm.direction);
							var thumbVector:Vector3D = cO.handList[j].thumb.position.subtract(cO.handList[j].palm.position);
							var angle1:Number = palmcross.dotProduct(thumbVector)
							
							if(angle1){
								if (angle1 < 0) cO.handList[j].type = "left";
								if (angle1 > 0) cO.handList[j].type = "right";
							}
							//else if (angle1 ==NaN) cO.handList[j].type = "undefined";
							
							//trace(angle, cO.handList[j].type)
						}
					}				
		}

		/////////////////////////////////////////////////////////////////////////////////////////////////////////////
		/////////////////////////////////////////////////////////////////////////////////////////////////////////////
		// Find Interactive Pinch Points //PINCH IP
		public function find3DPinchPoints():void
		{
			//trace("finding pinch points, geometric");
			
			var pinchThreshold:Number = 40 * 50//60; //GML CONFIG 
			var distThreshold:Number = 50//60; //GML CONFIG 
			
			var min_pprob:Number;
			var best_dist:Number;
			var best_pt1:MotionPointObject;
			var best_pt2:MotionPointObject;
			var palm:MotionPointObject;
			
				// FIND SMALLEST ANGLE DIFF TO PALM NORMAL && SMALLEST DIST BETWEEN
				// NEED POINT VELOCITY CHECK TO REMOVE BEDAXZZLE TRIGGER
					// CLOSEST TO PALM POINT -AMBIQUOUS
					// CLOSTEST TO FAV CREATES 2 FINGER ERROR
					// THUMB REQUOREMENT NEEDS FULL TESTING
				// PRESENT SINGLE PINCH POINT ALWAYS
			
			for (var j:int = 0; j < cO.hn; j++)
				{	
					
				//////////////////////////////////////////////////////////////////////////////////////////////////////////////	
				min_pprob = 20000;
				best_dist = 0;
				best_pt1 = new MotionPointObject()
				best_pt2 = new MotionPointObject();
				palm = cO.handList[j].palm;
				
				// GET LOCAL LIST OF CLOSE FINGER TIPS
				// gererate pair distances
				var fn:int = cO.handList[j].fingerList.length;
				
				for (var i:int = 0; i < fn; i++)
					{
					for (var q:int = 0; q < i+1; q++)
					{
						if ((i!=q))
						{
							var pt1:MotionPointObject = cO.handList[j].fingerList[i];
							var pt2:MotionPointObject = cO.handList[j].fingerList[q];
							var pt1_direction:Vector3D = pt1.position.subtract(palm.position);
							var pinch_dist:Number = Vector3D.distance(pt1.position,pt2.position);
							var pinchPalmAngle:Number = Vector3D.angleBetween(pt1_direction, palm.normal);
							
							var pinch_prob:Number = pinch_dist * 60 * pinchPalmAngle; //MAY NEED TO INCREASE TO 60 SEE RATIO
							
							if ((pinch_prob < min_pprob) && (pinch_prob != 0)) {
								min_pprob = pinch_prob;
								best_dist = pinch_dist;
								best_pt1 = pt1;
								best_pt2 = pt2;
								
								//trace("ppa",pinchPalmAngle, "dist",pinch_dist, "prob",pinch_prob, min_pprob, pt1.position,pt2.position);
							}
							//trace("pair",i,q)
						}
						
					}
				}
				
				// NEEDS FIX WHEN TRANSSITIONING BETWEEN STATES
				// PINKY TRIGGER (NEED WIDTH FOR BETTER THUMB)
				
				/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
				//trace("prob",min_pprob);

				// find midpoint between fingertips
					if ((best_pt1) && (best_pt2)&& (min_pprob != 0))
					{	
						// STRONG PINCH
						if ((fn == 2) && (best_dist<distThreshold)) 
						{
						var pmp:InteractionPointObject = new InteractionPointObject();
							pmp.position.x = best_pt1.position.x - (best_pt1.position.x - best_pt2.position.x) * 0.5;
							pmp.position.y = best_pt1.position.y - (best_pt1.position.y - best_pt2.position.y) * 0.5;
							pmp.position.z = best_pt1.position.z - (best_pt1.position.z - best_pt2.position.z) * 0.5;
							//pmp.handID = cO.hand.handID;
							pmp.type = "pinch";
															
						//add to pinch point list
						InteractionPointTracker.framePoints.push(pmp)
						//trace("2 pinch push", best_dist)	
						}
						
						 //WEAK PINCH
						else if (min_pprob < pinchThreshold)
						{
						var pmp0:InteractionPointObject = new InteractionPointObject();
							pmp0.position.x = best_pt1.position.x - (best_pt1.position.x - best_pt2.position.x) * 0.5;
							pmp0.position.y = best_pt1.position.y - (best_pt1.position.y - best_pt2.position.y) * 0.5;
							pmp0.position.z = best_pt1.position.z - (best_pt1.position.z - best_pt2.position.z) * 0.5;
							//pmp.handID = cO.hand.handID;
							pmp0.type = "pinch";
															
						//add to pinch point list
						InteractionPointTracker.framePoints.push(pmp0)
						//trace("n pinch push", pinchThreshold)
						}
					}
					
					
			}
		
		}
		
		/////////////////////////////////////////////////////////////////////////////////////////////////////////////
		// Find Interactive Hook Points 
		public function find3DHookPoints():void
		{
			// hooked fingers
			var hookThreshold:Number = 0.46; // GML ADJUST
			
			for (var j:int = 0; j < cO.hn; j++)
				{	
				var hfn:int = cO.handList[j].fingerList.length;
				
				for (i = 0; i < hfn; i++)
				{
					var hp:MotionPointObject = cO.handList[j].fingerList[i];
					//trace("hook extension",hp.extension)
						
					if (hp.fingertype == "finger")
					{
						if(hp.extension > hookThreshold)
							{	
							var pmp:InteractionPointObject = new InteractionPointObject();
								pmp.handID = hp.handID;
								pmp.position = hp.position;
								pmp.direction = hp.direction;
								//pmp.length = cO.motionArray[i].length;
								//pmp.extension = hp.extension;
								pmp.type = "hook";
								
							// push to interactive point list
							InteractionPointTracker.framePoints.push(pmp)
							}
					}
					// FAULT IN SKELETON 
					// AS KNUCKELE NOT KNOWN WELL THUMB APPEARS FLEXED WHEN NOT ACTUALLY 
					// SO ADJUST THRESHOLD
					if (hp.fingertype == "thumb")
					{
						if(hp.extension > hookThreshold + 0.2)
							{	
							var pmp0:InteractionPointObject = new InteractionPointObject();
								pmp0.handID = hp.handID;
								pmp0.position = hp.position;
								pmp0.direction = hp.direction;
								//pmp.length = cO.motionArray[i].length;
								//pmp.extension = hp.extension;
								pmp0.type = "hook";
								
							// push to interactive point list
							InteractionPointTracker.framePoints.push(pmp0)
							}
					}	
				}
			}
			
		}
		
		/////////////////////////////////////////////////////////////////////////////////////////////////////////////
		// Find Interactive Push/Pin Point (z-axis)
		public function find3DPushPoints():void
		{
			// must add other planes (orthogonal)
			// must add plane bounds (x and y for z)
			var z_wall:int = 50;
			
			for (var j:int = 0; j < cO.hn; j++)
				{	
				var hfn:int = cO.handList[j].fingerList.length;
					
					for (var i:int = 0; i < hfn; i++)
					{
						var pp:MotionPointObject = cO.handList[j].fingerList[i];
						
							//trace("pos",cO.motionArray[i].position)
							if (pp.position.x > z_wall) //side
							//if (pp.position.y > z_wall) //bottom
							//if (cO.motionArray[i].position.z > z_wall) //front
								{
								var pmp:InteractionPointObject = new InteractionPointObject();
									pmp.position = pp.position;
									pmp.direction = pp.direction;
									pmp.length = pp.length;
									pmp.type = "push";

								// push to interactive point list
								InteractionPointTracker.framePoints.push(pmp)
								}
					}
				}
				
		}
		
		////////////////////////////////////////////////////////////////////////
		// Find Interactive Trigger Points
		public function find3DTriggerPoints():void
		{	
			// FIND THUMB 
				// THUMB CHECK EXTENSION
					// CHECK POINT ANGLE AND VECTOR ANGLE
					// CHECK FOR PARALLEL DIRECTION 
				// GET PURE FINGER AV
				// GET PURE FINGER DIRECTION AX
				// PUSH TARGET POINT
				// PUSH TRIGGER STATE BASED ON THUMB STATE
				
			var triggerThreshold:Number = 0.6; // bigger threahold than hook // GML ADJUST
			
				for (var j:int = 0; j < cO.hn; j++)
				{	
				var hfn:int = cO.handList[j].fingerList.length;
				var hfnk:Number = 0;
				var thumb:MotionPointObject = cO.handList[j].thumb;	
				
					//trace(thumb.extension)
					if (thumb)
					{
						// ADDED ONLY ONE FINGER CONDITION
						if ((thumb.extension > triggerThreshold)&&(cO.handList[j].fingerList.length>=1)) //1 rad 90 deg ish
							{
							var	t_pt:InteractionPointObject = new InteractionPointObject();
							
							for (i = 0; i < hfn; i++)
							{
								if (cO.handList[j].fingerList[i].fingertype == "finger")
								{
								var pt:MotionPointObject = cO.handList[j].fingerList[i];
				
									// finger average point
									t_pt.position.x += pt.position.x;
									t_pt.position.y += pt.position.y;
									t_pt.position.z += pt.position.z;
										
									t_pt.direction.x += pt.direction.x;
									t_pt.direction.y += pt.direction.y;
									t_pt.direction.z += pt.direction.z;
								}
							}
							
							if (hfn >1) hfnk = 1 / (hfn-1);
							
							t_pt.position.x *= hfnk;
							t_pt.position.y *= hfnk;
							t_pt.position.z *= hfnk;
							
							t_pt.direction.x *= hfnk;
							t_pt.direction.y *= hfnk;
							t_pt.direction.z *= hfnk;
							//t_pt.handID = cO.hand.handID;		
							
							t_pt.fn = cO.handList[j].fingerList.length
							t_pt.type = "trigger";
							
							// push when triggered
							InteractionPointTracker.framePoints.push(t_pt);
							}
					}		
			}
		}
		
		////////////////////////////////////////////////////////////////////////
		// Find Interactive Region Points (3d volume)
		public function find3DRegionPoints():void
		{
			var x_min:Number; 
			var x_max:Number;
			var y_min:Number; 
			var y_max:Number;
			var z_min:Number; 
			var z_max:Number;
			
			for (var j:int = 0; j < cO.hn; j++)
				{	
				x_min = 0; 
				x_max = 300;
				y_min = 0; 
				y_max = 300;
				z_min = 0; 
				z_max = 300;	

				var hfn:int = cO.handList[j].fingerList.length;
			
					for (i = 0; i < hfn; i++)
						{
						var pt:MotionPointObject = cO.handList[j].fingerList[i];	
						
						if ((x_min < pt.position.x < x_max) && (y_min < pt.position.y < y_max) && (z_min < pt.position.z < z_max))
							{
								// create region point
								var tp:InteractionPointObject = new InteractionPointObject();
									tp.position = cO.motionArray[i].position;
									tp.direction = cO.motionArray[i].direction;
									tp.length = cO.motionArray[i].length;
									//tp.handID = cO.motionArray[i].handID;
									tp.type = "region";
						
									//cO.iPointArray.push(tp); // test
								InteractionPointTracker.framePoints.push(tp)
							}
						}
				}
		}	
		
		/////////////////////////////////////////////////////////////////////////
		// Find Interactive Frame Points
		public function find3DFramePoints():void
		{
			// fn == 3;
			// CHECK EXTENSION
				// ADD TO LIST
				// WHEN 2 POINTS 
				// CHECK ANGLE BETWEEN
				// CREATE 4 CORNER POINTS
			// PUSH FRAME POINTS
			
			var minAngle:Number = 0.9; // GML CONFIG
			var maxAngle:Number = Math.PI / 2; //GML CONFIG
			var minExtension:Number = 0.55;
			
			for (var j:int = 0; j < cO.hn; j++)
				{	
				var pointlist:Vector.<MotionPointObject>
				var hfn:int = cO.handList[j].fingerList.length;
			
				pointlist = new Vector.<MotionPointObject>
				
				if (hfn == 2)
				{
						/// find extended fingers
						for (var i:int = 0; i < hfn; i++)
						{
							var pt:MotionPointObject = cO.handList[j].fingerList[i];
							if ((pt.type == "finger") && (pt.extension < minExtension)) pointlist.push(pt);
							//trace(pt.extension)
						}
						//trace(pointlist.length)
						
						if (pointlist.length == 2) 
						{
							var palm_finger_vectorA:Vector3D = pointlist[0].position.subtract(cO.handList[j].position);
							var palm_finger_vectorB:Vector3D = pointlist[1].position.subtract(cO.handList[j].position);
							var angle_diff:Number = Vector3D.angleBetween(palm_finger_vectorA, palm_finger_vectorB);
							//trace("diff", angle_diff);
							
							if ((angle_diff > minAngle)&&(angle_diff < maxAngle))
							{
							
								// create complimentary frame points
								var fav:Vector3D = cO.handList[j].fingerAveragePosition;
								var palm_fav_vector:Vector3D = fav.subtract(cO.handList[j].position);
								var cpt:Vector3D = fav.add(palm_fav_vector);
								
								var cff_pt:InteractionPointObject = new InteractionPointObject();
										cff_pt.position = cpt;
										//cff_pt.direction = palm.direction;
										//t_pt.normal = cO.hand.normal;
										cff_pt.handID = cO.handList[j].handID;
										cff_pt.type = "frame";
										
									InteractionPointTracker.framePoints.push(cff_pt)
								
								// palm point // create interactions points
								var ff_pt:InteractionPointObject = new InteractionPointObject();
										ff_pt.position = cO.handList[j].position;
										//ff_pt.direction = palm.direction;
										//t_pt.normal = cO.hand.normal;
										//ff_pt.handID = cO.handList[j].handID;
										ff_pt.type = "frame";
										
								InteractionPointTracker.framePoints.push(ff_pt)
								//trace("push frame point");
									
								for (var q:int = 0; q < pointlist.length; q++)
								{
									// create interactions points
									var ff_pt0:InteractionPointObject = new InteractionPointObject();
										ff_pt0.position = pointlist[q].position;
										//ff_pt.direction =pointlist[j].direction;
										//t_pt.normal = cO.hand.normal;
										//ff_pt.handID = cO.handList[j].handID;
										ff_pt0.type = "frame";
										
									InteractionPointTracker.framePoints.push(ff_pt0)
									//trace("push frame point");
								}

									
							}
						}
						
				}	
			}						
		}
		
		
		/////////////////////////////////////////////////////////////////////////
		// Collect Interactive FingerTip Points
		public function find3DFingerPoints():void
		{
			
			for (var j:int = 0; j < cO.hn; j++)
				{	
				var hfn:int = cO.handList[j].fingerList.length;
			
				for (var i:int = 0; i < hfn; i++)
						{
							var fpt:MotionPointObject = cO.handList[j].fingerList[i];
							/// get fingers
							if (fpt.fingertype == "finger")
							{
								var f_pt:InteractionPointObject = new InteractionPointObject();
										f_pt.position = fpt.position;
										f_pt.direction = fpt.direction;
										//f_pt.handID = cO.hand.handID;
										f_pt.type = "finger";
										
									InteractionPointTracker.framePoints.push(f_pt)
							}
									
							//if (fpt.fingertype == "finger") f_pt.type = "finger";
							//if (fpt.fingertype == "index") f_pt.type = "index";
							//if (fpt.fingertype == "middle") f_pt.type = "middle";
							//if (fpt.fingertype == "ring") f_pt.type = "ring";
							//if (fpt.fingertype == "pinky") f_pt.type = "pinky";
							//if ((fpt.fingertype == "finger") || (fpt.fingertype == "index") || (fpt.fingertype == "middle") || (fpt.fingertype == "ring") || (fpt.fingertype == "pinky")) InteractionPointTracker.framePoints.push(f_pt)
						}
				}
		}
		
		/////////////////////////////////////////////////////////////////////////
		// Collect Interactive Thumb Points
		public function find3DThumbPoints():void
		{
			for (var j:int = 0; j < cO.hn; j++)
				{	
					var hfn:int = cO.handList[j].fingerList.length;
					//var v0:Vector3D = new Vector3D(0,0,0)
					//get thumb points
					if ((hfn>0)&&(cO.handList[j].thumb!=null)&&(cO.handList[j].thumb.fingertype=="thumb")) 
					{
						var tpt:MotionPointObject = cO.handList[j].thumb;
						
						var t_pt:InteractionPointObject = new InteractionPointObject();
							t_pt.position = tpt.position;
							t_pt.direction = tpt.direction;
							//t_pt.handID = cO.hand.handID;
							t_pt.type = "thumb";
									
						InteractionPointTracker.framePoints.push(t_pt)
						//trace("push thumb point");
					}
				}
		}
		
		/////////////////////////////////////////////////////////////////////////
		// Collect Interactive Thumb Points
		public function find3DFingerAndThumbPoints():void
		{
			for (var j:int = 0; j < cO.hn; j++)
				{	
					var hfn:int = cO.handList[j].fingerList.length;
					
					for (var i:int = 0; i < hfn; i++)
						{
						var dpt:MotionPointObject = cO.handList[j].fingerList[i];
					
							if((dpt)&&(dpt.fingertype=="thumb")||(dpt.fingertype == "finger")) 
							{
							var d_pt:InteractionPointObject = new InteractionPointObject();
								d_pt.position = dpt.position;
								d_pt.direction = dpt.direction;
								//t_pt.handID = cO.hand.handID;
								d_pt.type = "digit";
										
							InteractionPointTracker.framePoints.push(d_pt)
							}
						}
				}
		}
		
		/////////////////////////////////////////////////////////////////////////
		// Collect Interactive FingerAverage Points
		public function find3DFingerAveragePoints():void 
		{
			
				for (j = 0; j < cO.hn; j++)
				{
					var favpt:Vector3D = cO.handList[j].fingerAveragePosition;
					
					if ((favpt.x != 0) && (favpt.y != 0) && (favpt.z != 0))
					{
						// FAV POINT NEEDS DIRECTION AND NORMAL
						var fv_pt:InteractionPointObject = new InteractionPointObject();
							fv_pt.position = cO.handList[j].fingerAveragePosition;
							fv_pt.handID = cO.handList[j].handID;
							fv_pt.type = "finger_average";

						InteractionPointTracker.framePoints.push(fv_pt)	
					}
				}
		}
		
		/////////////////////////////////////////////////////////////////////////
		// Collect Interactive Palm Points
		public function find3DPalmPoints():void 
		{
			var hn:int = cO.handList.length;
			var flatness:Number = 0.4;
			var orientation:String;
			var handednes:String;
			
			// PALM IP MAY BE CREATED BASED ON FLATNESS , ORIENTATION AND HANDEDNESS CRITERIA
			// IN THE SAME WAY AS PINCH, HOOK, TRIGGER MAY BE CREATED BASED ON SEPERATION AND EXTENSION CRITERIA
			
				for (j = 0; j < cO.hn; j++)
				{
						var palm_pt:InteractionPointObject = new InteractionPointObject();
						
						////////////////////////////////////////////////////////////////
						// CREAT PALM POINT
						////////////////////////////////////////////////////////////////
						
							palm_pt.position = cO.handList[j].palm.position;
							palm_pt.direction = cO.handList[j].palm.direction;
							palm_pt.normal = cO.handList[j].palm.normal;
							palm_pt.rotation = cO.handList[j].palm.rotation;
							palm_pt.handID = cO.handList[j].palm.handID;
							
							palm_pt.fn = cO.handList[j].fingerList.length;
							
							palm_pt.flatness = cO.handList[j].flatness;
							palm_pt.orientation = cO.handList[j].orientation;
							//palm_pt.type  = cO.handList[j].type 
							palm_pt.radius  = cO.handList[j].radius  
							palm_pt.type = "palm";	
							
							//trace("fist: geometric", palm_pt.fist, cO.handList[j].orientation, cO.handList[j].flatness, cO.handList[j].splay, cO.handList[j].type);
							
						InteractionPointTracker.framePoints.push(palm_pt)
				}
		}
		
		public function find3DFistPoints():void 
		{
			var hn:int = cO.handList.length;
			var flatness:Number = 0.4;
			var orientation:String;
			var handednes:String;
			
			//trace("find fist points");
			
			// PALM IP MAY BE CREATED BASED ON FLATNESS , ORIENTATION AND HANDEDNESS CRITERIA
			// IN THE SAME WAY AS PINCH, HOOK, TRIGGER MAY BE CREATED BASED ON SEPERATION AND EXTENSION CRITERIA
			
				for (j = 0; j < cO.hn; j++)
				{	
						var fist_pt:InteractionPointObject = new InteractionPointObject();
						
							// TEST FOR OPENESS
							//
							if (cO.handList[j].fingerList.length == 0) 
							{
								if (cO.handList[j].flatness<10) fist_pt.fist = true;
								//trace("fist: 0",cO.handList[j].sphereRadius,cO.handList[j].palm.sphereRadius,cO.handList[j].flatness);
								
							}
							// STRONG TRACKING ERROR 2 FINGERS
							else if (cO.handList[j].fingerList.length == 2)
							{
								if ((cO.handList[j].fingerList[0].length < 80) && (cO.handList[j].fingerList[1].length < 80))
								{
								//if ((cO.handList[j].flatness<0.2)&&(cO.handList[j].palm.sphereRadius<70)){
									fist_pt.fist = true;
								}
								//trace("2 fist: ",palm_pt.fist,cO.handList[j].fingerAveragePosition,cO.handList[j].fingerList[0].length,cO.handList[j].fingerList[1].length);
							}
							// WEAK TRACKING ERROR 1 FINGER
							else if (cO.handList[j].fingerList.length == 1)
							{
								if (cO.handList[j].fingerList[0].length<90){
								//if ((cO.handList[j].flatness<0.4)&&(cO.handList[j].palm.sphereRadius<60)){
									fist_pt.fist = true;
								}
								//trace("1 fist: ",palm_pt.fist,cO.handList[j].fingerList.length,cO.handList[j].palm.sphereRadius,cO.handList[j].flatness,cO.handList[j].fingerAveragePosition,cO.handList[j].fingerList[0].length);
							}
							else {
								fist_pt.fist = false;
							}
							//trace("fist: ", palm_pt.fist);
							///////////////////////////////////////////////////
							//OVERIDE FLATNESS AND HAND ORIENTATION
							///////////////////////////////////////////////////
							if (fist_pt.fist) 
							{
								cO.handList[j].orientation = "unknown";
								cO.handList[j].flatness = 0;
								cO.handList[j].splay = 0;
								cO.handList[j].type = "unknown";
								//cO.handList[j].fist = true;
								
								
								////////////////////////////////////////////////////////////////
								// CREAT FIST POINT
								////////////////////////////////////////////////////////////////
						
								fist_pt.position = cO.handList[j].palm.position;
								fist_pt.direction = cO.handList[j].palm.direction;
								fist_pt.normal = cO.handList[j].palm.normal;
								fist_pt.rotation = cO.handList[j].palm.rotation;
								fist_pt.handID = cO.handList[j].palm.handID;
								
								fist_pt.fn = cO.handList[j].fingerList.length;
								
								fist_pt.flatness = cO.handList[j].flatness;
								fist_pt.orientation = cO.handList[j].orientation;
								//palm_pt.type  = cO.handList[j].type 
								fist_pt.radius  = cO.handList[j].radius  
								fist_pt.type = "fist";	
							
								//trace("fist: geometric");
							
								InteractionPointTracker.framePoints.push(fist_pt)
							}
				}
		}
		
		/////////////////////////////////////////////////////////////////////////////////////////////////////////////
		//Collect Interactive Tool Points 
		public function find3DToolPoints():void
		{
			// hooked fingers
			//var hook_extension:Number = 30;
			
			/*
			for (var j:int = 0; j < hn; j++)
				{	
				var hfn:int = cO.handList[j].fingerList.length;
			
				for (i = 0; i < hfn; i++)
				{
					
					if (cO.motionArray[i].type == "tool")
						{	
							//trace("tool");
							//var pmp:MotionPointObject = new MotionPointObject();
							var pmp:InteractionPointObject = new InteractionPointObject();
								pmp.handID = cO.handList[j].fingerList[i].handID;
								pmp.position = cO.handList[j].fingerList[i].position;
								pmp.direction = cO.handList[j].fingerList[i].direction;
								pmp.length = cO.handList[j].fingerList[i].length;
								pmp.type = "tool";

								// push to interactive point list	
								InteractionPointTracker.framePoints.push(pmp)
						}
					}
				}*/
		}
		
		
		////////////////////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////////////
		// helper functions
		////////////////////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////////////
		
		private static function normalize(value : Number, minimum : Number, maximum : Number) : Number {

                        return (value - minimum) / (maximum - minimum);
        }

        private static function limit(value : Number, min : Number, max : Number) : Number {
                        return Math.min(Math.max(min, value), max);
        }
	}
}