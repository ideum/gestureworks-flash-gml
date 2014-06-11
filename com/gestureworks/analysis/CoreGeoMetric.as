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
	import flash.display.Sprite;
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	import flash.geom.Utils3D;
	import flash.geom.Point;
	import org.openzoom.flash.viewport.controllers.ViewportControllerBase;
	import com.gestureworks.core.GestureWorks;
	import com.gestureworks.core.GestureGlobals;
	import com.gestureworks.core.gw_public;
	import com.gestureworks.core.CoreSprite;
	
	import com.gestureworks.objects.HandObject;
	import com.gestureworks.objects.TouchPointObject;
	import com.gestureworks.objects.MotionPointObject;
	import com.gestureworks.objects.SensorPointObject;
	import com.gestureworks.objects.InteractionPointObject;
	import com.gestureworks.objects.ClusterObject;
	import com.gestureworks.objects.ipClusterObject;
	import com.gestureworks.managers.InteractionPointTracker;
		
	public class CoreGeoMetric
	{
		//////////////////////////////////////
		// ARITHMETIC CONSTANTS
		//////////////////////////////////////
		private static const RAD_DEG:Number = 180 / Math.PI;
		private static const DEG_RAD:Number = Math.PI / 180 ;
		
		//private var touchObjectID:int;
		private var gs:CoreSprite;
		private var touchArray:Vector.<TouchPointObject>; 
		private var motionArray:Vector.<MotionPointObject>; 
		//private var motionArray2D:Vector.<MotionPointObject>; 
		private var sensorArray:Vector.<SensorPointObject>; 
		private var handList:Vector.<HandObject>;
		private var iPointArray:Vector.<InteractionPointObject>;
		
		private var iPointClusterLists:Object//Vector.<ipClusterObject>;
		
		private var i:uint = 0;
		private var j:uint = 0;
		
		private var minX:Number //=-220//180 
		private var maxX:Number //=220//180
		private var minY:Number //=350//270 
		private var maxY:Number //=120//50//-75
		private var minZ:Number //=350//270 
		private var maxZ:Number //=120//50//-75
		
		private var sw:int
		private var sh:int
		
		private var std_radius:int = 30;
		
		//private var tpn:uint = 0;
		//private var mpn:uint = 0;
	//	private var spn:uint = 0;
		//private var ipn:uint = 0;
		//private var hn:uint = 0;
		//private var fn:uint = 0;
		
		public var tag_match:Boolean = false;
		
		public function CoreGeoMetric() 
		{
			//touchObjectID = _id;
			//init();
		}
		
		public function init():void
		{
			trace("init cluster geometric ");
			
			gs = GestureGlobals.gw_public::core; // need to find center of object for orientation and pivot
			touchArray = GestureGlobals.gw_public::touchArray;
			motionArray = GestureGlobals.gw_public::motionArray;
			sensorArray = GestureGlobals.gw_public::sensorArray;
			handList = GestureGlobals.gw_public::handList;
			
			iPointClusterLists = GestureGlobals.gw_public::iPointClusterLists;
			

			sw = GestureWorks.application.stageWidth
			sh = GestureWorks.application.stageHeight;
			
			// move to device server
			minX = GestureGlobals.gw_public::leapMinX;
			maxX = GestureGlobals.gw_public::leapMaxX;
			minY = GestureGlobals.gw_public::leapMinY;
			maxY = GestureGlobals.gw_public::leapMaxY;
			minZ = GestureGlobals.gw_public::leapMinZ;
			maxZ = GestureGlobals.gw_public::leapMaxZ;
			
			//if (ts.traceDebugMode) 
		}
		
		
		public function resetGeoCluster():void
		{
			//////////////////////////////////////
			// SUBCLUSTER STRUCTURE
			// CAN BE USED FOR BI-MANUAL GESTURES
			// CAN BE USED FOR CONCURRENT GESTURE PAIRS
			/////////////////////////////////////
		}

		
		///////////////////////////////////////////////////////////////////////////////////
		///////////////////////////////////////////////////////////////////////////////////
		// 2d touch config analysis
		///////////////////////////////////////////////////////////////////////////////////
		///////////////////////////////////////////////////////////////////////////////////
		
		/////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
		//NATIVE TOUCH POINT TO IP METHOD
		public function findFingerTouchPoints():void
		{
			//trace("find fingers");
			if (touchArray){
			
			var fn:int = touchArray.length;
		
				for (var i:int = 0; i < fn; i++)
				{
					var tp:TouchPointObject = touchArray[i];
	
					var tip:InteractionPointObject = new InteractionPointObject();
							tip.rootPointID = tp.touchPointID;
							tip.position = tp.position;
							tip.mode = "touch";
							tip.source = "native";
							tip.type = "finger_dynamic";
								
						// push to interactive point list
						InteractionPointTracker.framePoints.push(tip);
				}	
			}
		}
		//public function findPenTouchPoints():void{}
		//public function findTouchPointProperties(): void{}
		//public function find2DTagPoints():void{}
		
		
		
		///////////////////////////////////////////////////////////////////////////////////
		///////////////////////////////////////////////////////////////////////////////////
		// 3d config analysis
		///////////////////////////////////////////////////////////////////////////////////
		///////////////////////////////////////////////////////////////////////////////////
		
		public function mapMotionPoints3Dto2D():void 
		{
			//trace("geometric mapping motion points", motionArray.length, motionArray2D.length);
			//if (!ts.transform3d) 
			
			if (motionArray){
			// CLEARS OUT LOCAL POINT ARRAYS
			//var temp_motionArray2D = new Vector.<MotionPointObject>();
			
			//if (ts.motionEnabled)
				//{
				//trace("converting from 3d ip to 2d motion");
				// NORMALIZE MOTION POINT DATA TO 2D
				for (var i:uint = 0; i < motionArray.length; i++) 
						{
							var pt:MotionPointObject = motionArray[i];
							
							//trace(pt.type);
							if (pt.type != "eye")
							{
								if (pt.position)
								{
									pt.screen_position = new Vector3D();
									pt.screen_position.x = normalize(pt.position.x, minX, maxX) * sw;
									pt.screen_position.y = normalize(pt.position.y, minY, maxY) * sh;
									pt.screen_position.z = pt.position.z
								}
								
								if (pt.direction)
								{
									pt.screen_direction = new Vector3D();
									pt.screen_direction.x = -pt.direction.x;
									pt.screen_direction.y = pt.direction.y;
									pt.screen_direction.z = pt.direction.z;
								}
								if (pt.normal)
								{
									pt.screen_normal = new Vector3D();
									pt.screen_normal.x = -pt.normal.x;
									pt.screen_normal.y = pt.normal.y;
									pt.screen_normal.z = pt.normal.z;
								}
							}
							else {
								
								pt.screen_position = new Vector3D();
								pt.screen_direction = new Vector3D();
								pt.screen_normal = new Vector3D();
								
								pt.screen_position = pt.position;
								pt.screen_direction = pt.direction;
								pt.screen_normal = pt.normal;
							}
						}
				}
		}	
		
		
		// clear derived point and cluster motion data
		public function clearHandData():void
		{
			var clear_fingers:Boolean = false;
			var clear_palm:Boolean = false;
			
			if (motionArray){
			
			for (i = 0; i < motionArray.length; i++)//mpn
				{	
					if (motionArray[i]) {
						
						if ((motionArray[i].type == "finger")&&(clear_fingers))
						{	
							// reset thum alloc// move to cluster
							//motionArray[i].fingertype = "finger";	 
							
							// reset thumb probs // move to cluster
							motionArray[i].thumb_prob = 0;
							motionArray[i].mean_thumb_prob = 0
							// normalized data
							motionArray[i].normalized_length = 0;
							motionArray[i].normalized_width = 0;
							motionArray[i].normalized_palmAngle = 0;
							motionArray[i].normalized_favdist = 0;
						}
						
						if ((motionArray[i].type == "palm")&&(clear_palm))
						{	
							// reset thum alloc// move to cluster
							motionArray[i].fingertype = null;	 
							
							// reset thumb probs // move to cluster
							motionArray[i].thumb_prob = 0;
							motionArray[i].mean_thumb_prob = 0
							// normalized data
							motionArray[i].normalized_length = 0;
							motionArray[i].normalized_width = 0;
							motionArray[i].normalized_palmAngle = 0;
							motionArray[i].normalized_favdist = 0;
						}
					}
				}
				// reset motion points in list
				//handList.length = 0;
			
				// reset hands
				gs.hn = 0;
				gs.fn = 0;
			}
		}
		
		
		// get normalized finger length and palm angle
		// create basic hand
		public function updateMotionPoints():void 
		{
			//trace("updateMotionPoints",mpn, motionArray.length, handList.length, hn)
			
			if (motionArray) gs.mpn = motionArray.length;
			else gs.mpn = 0;
			
			if (handList) gs.hn = handList.length;
			else gs.hn = 0;
			
				for (i = 0; i < gs.mpn; i++)//mpn
					{
						//////////////////////////////////////////////////////
						/// create hand
						if (motionArray[i].type == "palm") 
						{
										if (gs.hn != 0)
										{
										for (j = 0; j < gs.hn; j++)//handList.length
										{
											//trace("////////////////////////////////",handList[j].handID, motionArray[i].handID)
											
											
											if ((handList[j].handID != motionArray[i].handID)&&(handList.length < 2))
											{
												//trace("create another hand");
												//create hand
												var hand:HandObject = new HandObject();	
													hand.motionPointID = motionArray[i].motionPointID //palmID
													hand.position = motionArray[i].position //palmID
													hand.direction = motionArray[i].direction
													hand.normal = motionArray[i].normal
													hand.handID = motionArray[i].handID;
													hand.palm = motionArray[i]; // link palm point
								
												handList.push(hand);
												//trace("p",motionArray[i].handID)
											}
											else {
												//trace("update hand",j,handList[j].handID,motionArray[i].handID);
												//update hand
												//handList[j] = motionArray[i];
												handList[j].position = motionArray[i].position;
												handList[j].direction = motionArray[i].direction
												handList[j].normal = motionArray[i].normal
												handList[j].palm = motionArray[i];
												}	
											}
										}
										else {
											//trace("--------------------------------------------------------zero create hand");
											//create hand
											var hand:HandObject = new HandObject();	
													hand.motionPointID = motionArray[i].motionPointID //palmID
													hand.position = motionArray[i].position //palmID
													hand.direction = motionArray[i].direction
													hand.normal = motionArray[i].normal
													hand.handID = motionArray[i].handID;
													hand.palm = motionArray[i]; // link palm point
													
											if (!handList) handList = new Vector.<HandObject>
											handList.push(hand);
										}
							}
					}
					
					// CHECK PALM POINT STILL EXISTS
					// IF NOT REMOVE FROM HAND LIST
					//MOTION POINTS NOT KILLED FROM SERVER PROPERLY
					var mpo:MotionPointObject
					
					if (handList) {
						
					gs.hn = handList.length
					
					for (j = 0; j < gs.hn; j++)
					{
						
						if (handList[j])
						{
						if (handList[j].palm)
						{
							mpo = GestureGlobals.gw_public::motionPoints[handList[j].palm.motionPointID];
							if (!mpo) {
								//trace("palm gone", handList[j].palm.motionPointID, handList[j].motionPointID, handList[j].handID);
								
								//WILL NEED better VALID HAND LIST PLACEMENT
								handList[j].seedList.length = 0;
								handList[j].fingerList.length = 0;
								handList[j].pipList.length = 0;
								handList[j].dipList.length = 0;
								handList[j].tipList.length = 0;
								handList[j].palm = null;
								handList[j].index = null;
								handList[j].middle = null;
								handList[j].ring = null;
								handList[j].pinky = null;
								
								handList.splice(j, 1);
								gs.hn -= 1;//note splicing error
							}
						}
						else {
							handList[j].seedList.length = 0;
							handList[j].fingerList.length = 0;
							handList[j].pipList.length = 0;
							handList[j].dipList.length = 0;
							handList[j].tipList.length = 0;
							handList[j].palm = null;
							handList[j].index = null;
							handList[j].middle = null;
							handList[j].ring = null;
							handList[j].pinky = null;
							
							handList.splice(j, 1);
							gs.hn -= 1;
						}
						}
					}
					
					///////////////////////////////////////////////
					// GET HAND NUM TOTAL
					gs.hn = handList.length;
					}
					else gs.hn = 0;
					
					
					///////////////////////////////////////////////
					// PUSH FINGERS
					var fnum:int = 0;
					
					for (j = 0; j < gs.hn; j++)
					{
						//clear previos motion points
						handList[j].fingerList.length = 0;
						
						//trace("-------");
						
						for (i = 0; i < gs.mpn; i++)//mpn
							{	
							var mp:MotionPointObject = motionArray[i];

							if ((handList[j].handID == mp.handID))
							{
								if (mp.type == "finger")
									{
										//trace("CREATE NEW FINGER ZERO", mp.motionPointID, mp.id ,mp.position,handList[j].fingerList.length)
										//mp.fingertype = "finger"; // KILLING THUMB
										// push fingers into finger list
										handList[j].fingerList.push(mp);
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
								fnum += handList[j].fingerList.length;
								// push local finger list total
								//handList[j].hfn = handList[j].fingerList.length;
							}
					/////////////////////////////////////////////
					//GET FINGER NUM TOTAL
					gs.fn = fnum
		}
		
		public function lockHandType():void 
		{
			
			for (j = 0; j < handList.length; j++)
				{
					if ((handList[j].type)&&(handList[j].fingerList.length==5)&&(handList[j].orientation=="down"))
						{
						
						//trace("hand type",handList[j].type);
						if (handList[j].type == "right") handList[j].typeCache ++;
						else if (handList[j].type == "left") handList[j].typeCache --;
						
						handList[j].scanCount ++;
							
						//test if can be locked 
						 if ((handList[j].scanCount > 20) &&(!handList[j].handLock))
						 {
							
							handList[j].handLock = true;
							handList[j].scanCount = 0;
							 
							 if (handList[j].typeCache > 0) handList[j].lockedType = "right";
							 if (handList[j].typeCache < 0) handList[j].lockedType = "left";
							 
							 //trace("lockedtype",handList[j].typeCache, handList[j].lockedType);
						}
						}
				}
		}
		
		public function lockThumb():void 
		{
			//for (j = 0; j < hn; j++)
				//{
					//if (handList[j].type)
						//{
						/*
						if (handList[j].thumb) {
							
							if (handList[j].thumb.id) handList[j].thumbCount ++;
							handList[j].thumbCount --;
						}
						else handList[j].thumbCount --;
						
						//trace("tc",handList[j].thumbCount);
						
						//test if can be locked 
						if ((handList[j].thumbCount > 20)&&(!handList[j].thumbLock))
						{
							
							 handList[j].thumbLock = true;
							 handList[j].thumbCount = 0;
							 trace("locked thumb",handList[j].thumbCount, handList[j].thumbLock);
						}
						else if ((handList[j].thumbCount <0) &&(Math.abs(handList[j].thumbCount)>20))//&& (handList[j].thumbLock))
						{
							trace("start looking for thumb");
							handList[j].thumbLock = false;
							// handList[j].thumbCount = 0;
							
						}
						// trace("attempted thumb lock", handList[j].thumbCount, handList[j].thumbLock);
						//}
						*/
				//}
				
		}
		
		public function dynamicSkeletonUpdate():void 
		{
			for (j = 0; j < handList.length; j++)
				{
					var h:HandObject = handList[j];
					
					if (h.handLock) 
					{	
						if ((h.type) && (h.fingerList.length == 5) && (h.seedList.length == 0)) 
							{
								//trace("create new hand skeleton", handList[j].type, handList[j].lockedType);
								lockThumb();
								createSkeleton(true);
								matchFingers(true);
								positionTips();
								positionJoints();
							}
						// SHOULD ADD NEW CONDITION TO CHECK TO FOR ORIENTATION FLIPS 
						// UPDATE KNUCKELES BUT PRESERVE CACHED STATES AND
						else if ((h.type) && (h.fingerList.length == 5) &&(h.splay< 0.3))
							{
								//trace("reset hand skeleton");
								//reset hand type
									h.handLock = false;
									lockHandType();
									
								//reset thumb
									h.thumbLock = false;
									lockThumb();
									
								// reset skeleton
								createSkeleton(true);
								matchFingers(true);
								positionTips();
								positionJoints();
							}
						else if ((h.type) && (h.fingerList.length == 5) && (h.splay > 0.8))
						{
								//trace("reset hand skeleton");
								//reset hand type
									h.handLock = false;
									lockHandType();
									
								//reset thumb
									h.thumbLock = false;
									lockThumb();
									
								// reset skeleton
								createSkeleton(true);
								matchFingers(true);
								positionTips();
								positionJoints();
						}
						else{
								//trace("update skeleton")
								lockThumb();
								createSkeleton(false);//false
								matchFingers(false);//false
								positionTips();
								positionJoints();
						}
					}
					else {
						//trace("lock hand type");
						lockHandType();
						//lock thumb
					}
					
				}
				
				cacheFingers();
		}
		
		//NEED TO INCLUDE ORIENATION
		public function pushSeeds():void 
		{
			//RESET SEED LIST
			handList[j].seedList.length = 0 ;
			handList[j].seedList = new Vector.<Vector3D>();
			
			var align:Number = -(Math.PI / 24);
			var t3:Number = (Math.PI / 3);
			var t6:Number = (Math.PI / 6);
			var t12:Number = (Math.PI / 12);
			var t24:Number = (Math.PI / 24);
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
									
									
									
									if (handList[j].lockedType == "right")
									{
											 x0 = std_radius*1.3* Math.cos(7*t6);
											 y0 = std_radius*1.3* Math.sin(7*t6);
												
											 x1 = std_radius*1.1* Math.cos(2*t3);
											 y1 = std_radius*1.1* Math.sin(2*t3);
												
											 x2 = std_radius * Math.cos(3*t6);
											 y2 = std_radius * Math.sin(3*t6);
												
											 x3 = std_radius * Math.cos(t3);
											 y3 = std_radius * Math.sin(t3);
												
											 x4 = std_radius*1.4 * Math.cos(t6);
											 y4 = std_radius*1.4 * Math.sin(t6);
												
												handList[j].seedList[0] = new Vector3D(x0, 0,y0);
												handList[j].seedList[1]= new Vector3D(x1,0, y1);
												handList[j].seedList[2]= new Vector3D(x2,0, y2);
												handList[j].seedList[3] = new Vector3D(x3,0, y3);
												handList[j].seedList[4] = new Vector3D(x4,0, y4);
									}
									
									else if (handList[j].lockedType == "left")
									{
										 x0 = std_radius*1.3 * Math.cos(-t6+t12+align); //
										 y0 = std_radius*1.3 * Math.sin(-t6+t12+align); //
										
										 x1 = std_radius *1.1* Math.cos(t3-t12-align);
										 y1 = std_radius *1.1* Math.sin(t3-t12-align);//-t12
										
										 x2 = std_radius * Math.cos(3*t6-align);
										 y2 = std_radius * Math.sin(3*t6-align);
												
										 x3 = std_radius*1.0 * Math.cos(2*t3 + t12-align);
										 y3 = std_radius*1.0 * Math.sin(2*t3 + t12- align);
												
										 x4 = std_radius*1.4 * Math.cos(6*t6-align);
										 y4 = std_radius*1.4 * Math.sin(6*t6-align);

											handList[j].seedList[0] = new Vector3D(x0, 0,y0);
											handList[j].seedList[1] = new Vector3D(x1,0, y1);
											handList[j].seedList[2] = new Vector3D(x2,0, y2);
											handList[j].seedList[3] = new Vector3D(x3,0, y3);
											handList[j].seedList[4] = new Vector3D(x4,0, y4);
									}
									else {
										handList[j].seedList[0] = new Vector3D();
										handList[j].seedList[1]= new Vector3D();
										handList[j].seedList[2]= new Vector3D();
										handList[j].seedList[3] = new Vector3D();
										handList[j].seedList[4] = new Vector3D();
									}
		}
		
		public function createSkeleton(force_update:Boolean):void 
		{
			//trace("create hand")

			for (j = 0; j <handList.length; j++)
				{
					// SEED SKELTON GEOMETRY
					if (handList[j].seedList.length==0) pushSeeds()
					
						var s:int = 30;
						var p:Vector3D = handList[j].position;
							var rotX:Number = RAD_DEG * Math.asin(handList[j].normal.x);
							var rotY:Number = RAD_DEG * Math.asin(handList[j].direction.x);
							var rotZ:Number = RAD_DEG * Math.asin(handList[j].normal.z);
							
							var orient:Number = 0//180//Math.PI/2//0;
							
							//ADJUST ROTATION MATRIX BASED ON ORIENTATION
							// MUST FOX FINGER MATHCING AND MAKE ORIENTATIION INDEPEDANT
							// AND FIX DOT PRODCT PROBLEM
							if (handList[j].orientation == "up") orient = 180//Math.PI;
							else orient = 0;
							
							//trace(handList[j].orientation, orient, rotX, rotX + orient,handList[j].type,handList[j].lockedType)
							//
							
							// roate in 3d space
							var m:Matrix3D = new Matrix3D ()//(1,0,0,1,0,1,0,1,0,0,1,1,0,0,0,1);
								m.appendRotation(rotX + orient, new Vector3D(0, 0, 1));
								m.appendRotation(rotZ, new Vector3D(-1, 0, 0));
								m.appendRotation(rotY , new Vector3D(0, 1, 0)); //direction
					
							var sn:int = handList[j].seedList.length;
					
						//trace("sn",sn);
	
								if (force_update)
								{
								//trace("skeleton rebuilt");
								
								// CLEAR OUT LISTS
								handList[j].knuckleList.length = 0;
								handList[j].tipList.length = 0;
								handList[j].dipList.length = 0;
								handList[j].pipList.length = 0;
								
								//CLEAR FINGER REFERENCES TO FORCE ID CYCLE
								//handList[j].thumb = null; // MUST RESET IN THUMB ID FUNCTION
								handList[j].index = new MotionPointObject();
								handList[j].middle = new MotionPointObject()//null;
								handList[j].ring = new MotionPointObject()//null;
								handList[j].pinky = new MotionPointObject()//null;
								
								//CLEAR FINGER IDS
								for (i = 0; i <handList[j].fingerList.length; i++)
									{	
									if (handList[j].fingerList[i].fingertype!="thumb") handList[j].fingerList[i].fingertype = "";
									}
								
								//trace("create knuckle", sn)
								////////////////////////////////////////////////
								// CREATE SKELTAL KNUCLE, JOINTS AND TIPS SEEDS
								////////////////////////////////////////////////
									for (i = 0; i <sn; i++)//mpn
									{	
										//handList[j].seedList.push(vArray[i]);
										
										// create static number of knuckles
										var kp:MotionPointObject = new MotionPointObject();
											kp.handID = handList[j].handID;	
											kp.type = "mcp" + (i+1);
											
											var v:Vector3D = handList[j].seedList[i];
											var pv:Vector3D = Utils3D.projectVector(m, v);			
											// translate
											var rv:Vector3D = p.add(pv);
								
											kp.position = rv;
											
										handList[j].knuckleList.push(kp);
										
										//exclude thumb
										if (i != 0)
										{
											//create joints PIPS
											var j_pip:MotionPointObject = new MotionPointObject();
												j_pip.handID = handList[j].handID;	
												j_pip.type = "pip" + (i);
												
												var ds:Vector3D = new Vector3D(handList[j].direction.x * s, handList[j].direction.y * s, handList[j].direction.z * s);
												var vd:Vector3D = kp.position.add(ds);
												
												j_pip.position = vd;
											handList[j].pipList.push(j_pip);
										}
										
										//create joints DIPS
										var j_dip:MotionPointObject = new MotionPointObject();
											j_dip.handID = handList[j].handID;	
											j_dip.type = "dip" + (i+1);
											
											var ds2:Vector3D = new Vector3D(handList[j].direction.x * s*1.3, handList[j].direction.y * s*1.3, handList[j].direction.z * s*1.3);
											var vd2:Vector3D = kp.position.add(ds2);
											j_dip.position = vd2;
										handList[j].dipList.push(j_dip);
										
										// create TIPS
										var j_tip:MotionPointObject = new MotionPointObject();
											j_tip.handID = handList[j].handID;	
											j_tip.type = "tip" + (i+1);
											
											var ds3:Vector3D = new Vector3D(handList[j].direction.x * s*1.6, handList[j].direction.y * s*1.6, handList[j].direction.z * s*1.6);
											var vd3:Vector3D = kp.position.add(ds3);
											j_tip.position = vd3;
										handList[j].tipList.push(j_tip);
										
									}
							
									//trace("build",handList[j].knuckleList.length)
							}
							else
							{
								var kn:int = handList[j].knuckleList.length;
								var dn:int = handList[j].dipList.length
								var pn:int = handList[j].pipList.length
								var tn:int = handList[j].tipList.length;
								
								//trace("update joints",kn, dn,pn,tn, sn)
								
								//update knuckles
								for (i = 0; i <kn; i++)//mpn
									{	
										var v:Vector3D = handList[j].seedList[i];
										var pv:Vector3D = Utils3D.projectVector(m, v);			
											
										// translate
										var rv:Vector3D = p.add(pv);
										handList[j].knuckleList[i].position = rv;
									}
								
								//////////////////////////////////////////////////////////////////
								//CACHED POSITONS
								//update tips to cached values
								//TODO: MUST INCLUDE PALM ROATION IN PLANE
								for (i = 0; i <tn; i++)//mpn
									{		
										var v2:Vector3D = handList[j].positionCached;
										var palm_vel:Vector3D = handList[j].palm.position.subtract(v2);
										
										//GET POSITION CACHE
										if (handList[j].tipList[i].positionCached)
										{
											/*
											var normal:Vector3D = handList[j].palm.normal;
											var v0:Vector3D = handList[j].tipList[i].positionCached;
												
											// FIND RELATIVE POSITON TO PALM
											var v:Vector3D = v0.subtract(handList[j].palm.position);
											
											// PROJECT INTO THE PALM PLANE
											var dist:Number = (v.x * normal.x) + (v.y * normal.y) + (v.z * normal.z);
											var palm_plane_chachedtip:Vector3D = new Vector3D((v0.x - dist * normal.x), (v0.y -dist*normal.y), (v0.z - dist*normal.z));
											
											handList[j].tipList[i].position = palm_plane_chachedtip.add(palm_vel);
											*/
											
											
											
											// PROJECT INTO THE PALM PLANE
											var diff:Vector3D = handList[j].tipList[i].positionCached.subtract(handList[j].tipList[i].planePositionCached)
											var rel:Vector3D = handList[j].tipList[i].relativePositionCached;
											var plane_pos:Vector3D = handList[j].tipList[i].planePositionCached
											
											var pv:Vector3D = Utils3D.projectVector(m,plane_pos );			
											var fv:Vector3D = pv.add(diff);
											// translate
											var trans_fv:Vector3D = fv.add(palm_vel);
											
											handList[j].tipList[i].position = trans_fv;
											
											//trace("palm velocity",palm_vel)
											
											}
											
										//GET DIRECTION CACHE
										if (handList[j].tipList[i].directionCached)
										{
											// get direction vector (palm normal simplfication)
											var v0:Vector3D = handList[j].tipList[i].directionCached;
											handList[j].tipList[i].direction = v0;
										}
										
									}	
							}
						
						
							//trace(handList[j].knuckleList.length);
							
							
							
							//////////////////////////////////////////////////////////
							//CREATE KNUCLE PROJECTION POINTS IN PALM LINE
							// GET PALM LINE POINT PROJECTION
							
							for (i = 0; i <kn; i++)//mpn
								{		
								var kpt = handList[j].knuckleList[i];
								var direction = handList[j].palm.direction;
								var k_pos:Vector3D = kpt.position;
								var vkp_mpl:Vector3D = k_pos.subtract(handList[j].palm.position);
								
								var dist2:Number = (vkp_mpl.x * direction.x) + (vkp_mpl.y * direction.y) + (vkp_mpl.z * direction.z);
								var palm_plane_line_point:Vector3D = new Vector3D((k_pos.x - dist2 * direction.x), (k_pos.y -dist2 * direction.y), (k_pos.z - dist2 * direction.z));
								
								kpt.palmplaneline_position = palm_plane_line_point
								
								}
							
							
							
							
							
							
							
							
					}
		}
		

		// UNIQUE FINGER IDS
		public function matchFingers(force_update:Boolean):void 
		{
			//force_update = true;
			
					for (j = 0; j < handList.length; j++)
					{	
						
						// FIND MATCHING FINGER TIPS
						var fn:int = handList[j].fingerList.length;
						var kn:int = handList[j].knuckleList.length // ONLY WHEN KNUCKLES EXIST
						
						if (fn &&kn)
						{	
							/////////////////////////////////////////////////////////////////////////////////
							// check for valid thumb
							//trace("t",handList[j].thumb.motionPointID,handList[j].thumb);
							if (handList[j].thumb)
							{
							if (handList[j].thumb.motionPointID) 
								{
									//test to see if middle finger motion poin still being tracked
									var mpo:MotionPointObject = GestureGlobals.gw_public::motionPoints[handList[j].thumb.motionPointID];
									if (!mpo) {
										handList[j].thumb.id = null//false;
										//trace("thumb nullified")
									}
									//else handList[j].thumb.id = null//true;
										
								}
							}
							
							/////////////////////////////////////////////////////////////////////////////////////////
							// CHECK PINKY VALID
							if (handList[j].pinky)
							{
							if ((handList[j].pinky.motionPointID) &&(handList[j].pinky.isValid))
								{
									//test to see if middle finger motion poin still being tracked
									var mpo:MotionPointObject = GestureGlobals.gw_public::motionPoints[handList[j].pinky.motionPointID];
									if (!mpo) {
										handList[j].pinky.isValid = false;
										//trace("pinky nullified")
									}
									handList[j].pinky.isValid = true;
								}
							}

							/////////////////////////////////////////////////////////////////////////////////////////
							// CHECK MIDDLE VALID
							if (handList[j].middle)
							{
							if (handList[j].middle.motionPointID) 
								{
									//test to see if middle finger motion poin still being tracked
									var mpo:MotionPointObject = GestureGlobals.gw_public::motionPoints[handList[j].middle.motionPointID];
									if (!mpo) {
										handList[j].middle.isValid = false;
										//trace("middle nullified")
									}
									handList[j].middle.isValid = true;	
								}
							}
							/////////////////////////////////////////////////////////////////////////////////////////
							// CHECK INDEX VALID
							if (handList[j].index)
							{
							if (handList[j].index.motionPointID) 
								{
									//test to see if middle finger motion poin still being tracked
									var mpo:MotionPointObject = GestureGlobals.gw_public::motionPoints[handList[j].index.motionPointID];
									if (!mpo) {
										handList[j].index.isValid = false;
										//trace("index nullified")
									}
									handList[j].index.isValid = true;
								}
							}
							/////////////////////////////////////////////////////////////////////////////////////////
							// CHECK RING VALID
							if (handList[j].ring)
							{
							if (handList[j].ring.motionPointID) 
								{
									//test to see if middle finger motion poin still being tracked
									var mpo:MotionPointObject = GestureGlobals.gw_public::motionPoints[handList[j].ring.motionPointID];
									if (!mpo) {
										handList[j].ring.isValid = false;
										//trace("ring nullified")
									}
									handList[j].ring.isValid = true;
								}
							}
	
							//TODO FIGURE OUT HOW LOCKING THESE POINTS
							//LEADS TO CACHE LOCKING ALSO
							
							//PINKY
							//if (!handList[j].pinky.isValid)
							getPinky(fn,handList[j].knuckleList[4],95,45,Math.PI/20,40,20);
								
							//MIDDLE
							//if (!handList[j].middle.isValid)
							getMiddle(fn,handList[j].knuckleList[2],20,0,Math.PI/40, 10,20);
								
							//INDEX// put before middle to protect point // but point throws plam??
							//if (!handList[j].index.isValid)
							getIndex(fn,handList[j].knuckleList[1], 60, 20, Math.PI /15, 15,20); //50,25
								
							//RING
							//if (!handList[j].ring.isValid)
							getRing(fn,handList[j].knuckleList[3], 60, 20, Math.PI / 15,15,20); 
						}
					}
					
					findClassifiedFingerData();
		}
		
		public function getPinky(fn:int,knuckle:MotionPointObject,maxDist:Number,minDist:Number,maxAngle:Number,maxKnuckleDist:Number,prev_max:Number):void 
		{
			for (var k:int = 0; k <fn; k++)// fingertips
								{
								var finger:MotionPointObject = handList[j].fingerList[k];
								
								if ((finger.positionCached)&&(finger.palmplaneline_position)&&(finger.projected_finger_direction)&&(finger.palmplaneline_position)&&(knuckle.palmplaneline_position)){
								
								if ((finger.fingertype != "thumb")&&(finger.fingertype == "")&&(finger.fingertype != "pinky")&&(!handList[j].pinky.id))
									{	
										var palm = handList[j].palm;
										
										var dist:Number = Vector3D.distance(finger.palmplaneline_position,palm.position)
										//var minDist:int = 45;
										//var maxDist:int = 95;
										
										//trace("palm line dist", k, dist);
										
										var planeline_pf:Vector3D = finger.palmplaneline_position.subtract(palm.position);
										
										var cp_angle:Number = handList[j].d_n_crossproduct.dotProduct(planeline_pf)
										var correct_side:Boolean = false;
												
										if ((handList[j].lockedType == "left") && (cp_angle > 0)) correct_side = true;
										else if ((handList[j].lockedType == "right") && (cp_angle < 0)) correct_side = true;
										//trace("cp",cp_angle)
										
										//GET FINGER TO KNUCKLE VECTOR IN Horizontal PLANE
										var plane_kf:Vector3D = finger.palmplane_position.subtract(knuckle.position);
												
										//GET DIFF ANGLE BETWEEEN PROJECTED FINRGER TIP DIRECTION AND KNUCLE TO TIP VECTOR // FIND MIN
										var ang_diff:Number = Vector3D.angleBetween(finger.projected_finger_direction, plane_kf);
										
										// distance between projected knuckle and projected tip in palm line
										var k_dist:Number = Vector3D.distance(finger.palmplaneline_position,knuckle.palmplaneline_position)

										var prev_dist:Number = Vector3D.distance(finger.position,finger.positionCached)
										//trace("index finger cached",k, prev_dist)
										
										if (prev_dist < prev_max) 
										{
											trace("pinky finger cached",k, prev_dist)
											handList[j].fingerList[k].fingertype = "pinky";
											handList[j].pinky = handList[j].fingerList[k];
										}
										//CHECK DISTANCE RANGE
										//CHECK SIDE OF PALM POINT
										else if ((dist < maxDist)&&(dist > minDist)&&(correct_side)&&(ang_diff<maxAngle)&&(k_dist<maxKnuckleDist))
										{
											trace("pinky finger",k, dist,correct_side,k_dist)
											handList[j].fingerList[k].fingertype = "pinky";
											handList[j].pinky = handList[j].fingerList[k];
										}
									}
								else if (handList[j].pinky) 
									{
										//test to see if middle finger motion poin still being tracked
										var mpo:MotionPointObject = GestureGlobals.gw_public::motionPoints[handList[j].pinky.motionPointID];
										if (!mpo){
											handList[j].pinky.id = null;
											//trace("pinky nullified")
										}
									}
								}
								}
		}
		
		public function getMiddle(fn:int,knuckle:MotionPointObject,maxDist:Number,minDist:Number, maxAngle:Number,maxKnuckleDist:Number,prev_max:Number):void 
		{
			for (var k:int = 0; k <fn; k++)// fingertips
								{
								
								var finger:MotionPointObject = handList[j].fingerList[k];
								
								if (finger.palmplaneline_position && finger.positionCached && finger.projected_finger_direction && finger.palmplaneline_position && knuckle.palmplaneline_position)
								{
								
								if ((finger.fingertype != "thumb")&&(finger.fingertype == "")&&(finger.fingertype != "middle")&&(!handList[j].middle.id))
									{
										var palm = handList[j].palm;
										
										var dist:Number = Vector3D.distance(finger.palmplaneline_position,palm.position)
										//var minDist:int = 0;
										//var maxDist:int = 20;
										
										//trace("palm line dist", handList[j].fingerList[k].fingertype, k, dist);
										
										//GET FINGER TO KNUCKLE VECTOR IN Horizontal PLANE
										var plane_kf:Vector3D = finger.palmplane_position.subtract(knuckle.position);
												
										//GET DIFF ANGLE BETWEEEN PROJECTED FINRGER TIP DIRECTION AND KNUCLE TO TIP VECTOR // FIND MIN
										var ang_diff:Number = Vector3D.angleBetween(finger.projected_finger_direction, plane_kf);
										
										// distance between projected knuckle and projected tip in palm line
										var k_dist:Number = Vector3D.distance(finger.palmplaneline_position,knuckle.palmplaneline_position)
										
										var prev_dist:Number = Vector3D.distance(finger.position,finger.positionCached)
										//trace("index finger cached",k, prev_dist)
										
										
										//CHECK TO SEE IF NEIGHBOUR IS DEFINED
										var index:MotionPointObject = handList[j].index;
										var ring:MotionPointObject = handList[j].ring;
										var neighbourMax:int = 40;
										
										if (index.id) //context association with neighbour tip
										{
											var index_dist:Number = Vector3D.distance(finger.position, index.position)
											if (index_dist < neighbourMax)
											{
												trace("INDEX HELPED",k, index_dist)
												handList[j].fingerList[k].fingertype = "middle";
												handList[j].middle = handList[j].fingerList[k];
											}	
										}
										else if (ring.id) 
										{
											var ring_dist:Number = Vector3D.distance(finger.position, ring.position)
											if (ring_dist < neighbourMax)
											{
												trace("RING HELPED",k, ring_dist)
												handList[j].fingerList[k].fingertype = "middle";
												handList[j].middle = handList[j].fingerList[k];
											}	
										}
										
										else if (prev_dist < prev_max) 
										{
											trace("middle finger cached",k, prev_dist)
											handList[j].fingerList[k].fingertype = "middle";
											handList[j].middle = handList[j].fingerList[k];
										}
										//CHECK DISTANCE RANGE
										//CHECK SIDE OF PALM POINT
										else if ((dist < maxDist)&&(dist > minDist)&&(ang_diff<maxAngle)&&(k_dist<maxKnuckleDist))//&&(correct_side))
										{
											trace("middle finger",k, dist,k_dist)
											handList[j].fingerList[k].fingertype = "middle";
											handList[j].middle = handList[j].fingerList[k];
										}
									}
								else if (handList[j].middle) 
									{
										//test to see if middle finger motion poin still being tracked
										var mpo:MotionPointObject = GestureGlobals.gw_public::motionPoints[handList[j].middle.motionPointID];
										if (!mpo){
											handList[j].middle.id = null;
											//trace("pinky nullified")
										}
									}
								}
								}
		}
		
		public function getIndex(fn:int,knuckle:MotionPointObject,maxDist:Number,minDist:Number,maxAngle:Number,maxKnuckleDist:Number,prev_max:Number):void 
		{
			for (var k:int = 0; k <fn; k++)// fingertips
								{
								var finger:MotionPointObject = handList[j].fingerList[k];
								
								if(finger.projected_finger_direction && finger.palmplaneline_position && knuckle.palmplaneline_position && finger.positionCached){
								
								if ((finger.fingertype != "thumb")&&(finger.fingertype == "")&&(finger.fingertype != "index")&&(!handList[j].index.id))
									{
										
										var palm = handList[j].palm;
										
										var dist:Number = Vector3D.distance(finger.palmplaneline_position,palm.position)
										
										//var minDist:int = 45;
										//var maxDist:int = 95;
										
										//trace("palm line dist", k, dist);
										
										var planeline_pf:Vector3D = finger.palmplaneline_position.subtract(palm.position);
										
										var cp_angle:Number = handList[j].d_n_crossproduct.dotProduct(planeline_pf)
										var correct_side:Boolean = false;
												
										if ((handList[j].lockedType == "left") && (cp_angle > 0)) correct_side = true;
										else if ((handList[j].lockedType == "right") && (cp_angle < 0)) correct_side = true;
										//trace("cp",cp_angle)
										
										//GET FINGER TO KNUCKLE VECTOR IN Horizontal PLANE
										var plane_kf:Vector3D = finger.palmplane_position.subtract(knuckle.position);
												
										//GET DIFF ANGLE BETWEEEN PROJECTED FINRGER TIP DIRECTION AND KNUCLE TO TIP VECTOR // FIND MIN
										var ang_diff:Number = Vector3D.angleBetween(finger.projected_finger_direction, plane_kf);
										
										// distance between projected knuckle and projected tip in palm line
										var k_dist:Number = Vector3D.distance(finger.palmplaneline_position,knuckle.palmplaneline_position)
										//trace("index finger",finger.fingertype,k, dist,correct_side,ang_diff, k_dist )
									
										var prev_dist:Number = Vector3D.distance(finger.position,finger.positionCached)
										//trace("index finger cached",k, prev_dist)
										
										/*
										var middle:MotionPointObject = handList[j].middle;
										var neighbourMax:int = 40;
										
										
										if (middle.id) //context association with neighbour tip
										{
											var middle_dist:Number = Vector3D.distance(finger.position, middle.position)
											if (middle_dist < neighbourMax)
											{
												trace("MIDDLE HELPED",k, middle_dist)
												handList[j].fingerList[k].fingertype = "index";
												handList[j].index = handList[j].fingerList[k];
											}	
										}*/
										
										if (prev_dist < prev_max) 
										{
											trace("index finger cached",k, prev_dist)
											handList[j].fingerList[k].fingertype = "index";
											handList[j].index = handList[j].fingerList[k];
										}
										//CHECK DISTANCE RANGE
										//CHECK SIDE OF PALM POINT
										else if ((dist < maxDist)&&(dist > minDist)&&(!correct_side)&&(ang_diff<maxAngle)&&(k_dist<maxKnuckleDist))
										{
											trace("index finger",k, dist,correct_side,ang_diff, k_dist)
											handList[j].fingerList[k].fingertype = "index";
											handList[j].index = handList[j].fingerList[k];
										}
									}
								else if (handList[j].index) 
									{
										//test to see if middle finger motion poin still being tracked
										var mpo:MotionPointObject = GestureGlobals.gw_public::motionPoints[handList[j].index.motionPointID];
										if (!mpo){
											handList[j].index.id = null;
											//trace("pinky nullified")
										}
									}
									}
								}
		}
		
		public function getRing(fn:int,knuckle:MotionPointObject,maxDist:Number,minDist:Number,maxAngle:Number,maxKnuckleDist:Number,prev_max:Number):void 
		{
			for (var k:int = 0; k <fn; k++)// fingertips
								{
								
								var finger:MotionPointObject = handList[j].fingerList[k];
								
								if (finger.positionCached && finger.projected_finger_direction && finger.palmplaneline_position && finger.palmplaneline_position && knuckle.palmplaneline_position){
								
								if ((finger.fingertype != "thumb")&&(finger.fingertype == "")&&(finger.fingertype != "ring")&&(!handList[j].ring.id))
									{
										var palm = handList[j].palm;
										
										var dist:Number = Vector3D.distance(finger.palmplaneline_position,palm.position)
										//var minDist:int = 45;
										//var maxDist:int = 95;
										
										//trace("palm line dist", k, dist);
										
										var planeline_pf:Vector3D = finger.palmplaneline_position.subtract(palm.position);
										
										var cp_angle:Number = handList[j].d_n_crossproduct.dotProduct(planeline_pf)
										var correct_side:Boolean = false;
												
										if ((handList[j].lockedType == "left") && (cp_angle > 0)) correct_side = true;
										else if ((handList[j].lockedType == "right") && (cp_angle < 0)) correct_side = true;
										//trace("cp",cp_angle)
										
										//GET FINGER TO KNUCKLE VECTOR IN Horizontal PLANE
										var plane_kf:Vector3D = finger.palmplane_position.subtract(knuckle.position);
												
										//GET DIFF ANGLE BETWEEEN PROJECTED FINRGER TIP DIRECTION AND KNUCLE TO TIP VECTOR // FIND MIN
										var ang_diff:Number = Vector3D.angleBetween(finger.projected_finger_direction, plane_kf);
										
										// distance between projected knuckle and projected tip in palm line
										var k_dist:Number = Vector3D.distance(finger.palmplaneline_position,knuckle.palmplaneline_position)
										
										//trace("ring finger",finger.fingertype,k, dist,correct_side,ang_diff)
												
										
										var prev_dist:Number = Vector3D.distance(finger.position,finger.positionCached)
										//trace("index finger cached",k, prev_dist)
										
										
										/*
										var middle:MotionPointObject = handList[j].middle;
										var neighbourMax:int = 40;
										
										if (middle.id) //context association with neighbour tip
										{
											var middle_dist:Number = Vector3D.distance(finger.position, middle.position)
											if (middle_dist < neighbourMax)
											{
												trace("MIDDLE HELPED",k, middle_dist)
												handList[j].fingerList[k].fingertype = "ring";
												handList[j].ring = handList[j].fingerList[k];
											}	
										}*/
										
										if (prev_dist < prev_max) 
										{
											trace("ring finger cached",k, prev_dist)
											handList[j].fingerList[k].fingertype = "ring";
											handList[j].ring = handList[j].fingerList[k];
										}
										//CHECK DISTANCE RANGE
										//CHECK SIDE OF PALM POINT
										else if ((dist < maxDist)&&(dist > minDist)&&(correct_side)&&(ang_diff<maxAngle)&&(k_dist<maxKnuckleDist))
										{
											trace("ring finger",k, dist,correct_side,ang_diff)
											handList[j].fingerList[k].fingertype = "ring";
											handList[j].ring = handList[j].fingerList[k];
										}
									}
								else if (handList[j].ring) 
									{
										//test to see if middle finger motion poin still being tracked
										var mpo:MotionPointObject = GestureGlobals.gw_public::motionPoints[handList[j].ring.motionPointID];
										if (!mpo){
											handList[j].ring.id = null;
											//trace("pinky nullified")
										}
									}
								}
								}
		}
		
		
		public function positionTips():void 
		{
			//force_update = true;
			//trace("positionTips");
			
			// WHEN NO FINGER ASSIGNED TO A FINGER TYPE THERE IS NO DATA TO PULL FROM CACHE
			// SO FINGER TIP LOCKS ON FIXED POSITION IN SPACE.
			
				for (j = 0; j < handList.length; j++)
					{	
						// FIND MATCHING FINGER TIPS
						
						var tn:int = handList[j].tipList.length;
						var kn:int = handList[j].knuckleList.length;
						
						if (kn&&tn) // ONLY WHEN KNUCKLES EXIST
						{
							//thumb	
							if (handList[j].thumb){
								if (handList[j].thumb.id)
								{
								handList[j].tipList[0].position = handList[j].thumb.position;
								handList[j].tipList[0].direction = handList[j].thumb.direction;
								//trace("thumb",handList[j].thumb);
								}	
							}
							//index	
							if (handList[j].index.id)
							{
								handList[j].tipList[1].position = handList[j].index.position;
								handList[j].tipList[1].direction = handList[j].index.direction;
								//trace("index",handList[j].index);
							}
							//middle
							if (handList[j].middle.id)
							{
							handList[j].tipList[2].position = handList[j].middle.position;
							handList[j].tipList[2].direction = handList[j].middle.direction;
							}
							//ring	
							if (handList[j].ring.id)
							{
							handList[j].tipList[3].position = handList[j].ring.position;
							handList[j].tipList[3].direction = handList[j].ring.direction;
							}
							//pinky		
							if (handList[j].pinky.id)
							{
							handList[j].tipList[4].position = handList[j].pinky.position;
							handList[j].tipList[4].direction = handList[j].pinky.direction;
							}
						}
					}
		}
		
		
		public function cacheFingers():void 
		{
			for (j = 0; j < handList.length; j++)
					{	
						var tn:int = handList[j].tipList.length;
							///////////////////////////
							//CACHE FINGER TIP VALUES
							for (var m:int = 0; m <tn; m++)// fingertips
							{
							
								var tp:MotionPointObject = handList[j].tipList[m];
								
								if (tp.palmplane_position && handList[j].palm.position)
								{
									tp.positionCached = tp.position;
									tp.planePositionCached = tp.palmplane_position;
									tp.relativePositionCached = tp.palmplane_position.subtract(handList[j].palm.position);
									tp.directionCached = handList[j].palm.normal///tp.direction;
									
									//trace("cache test",m,tp.palmplane_position,tp.positionCached, tp.position)
								}
							}
							
						////////////////////////
						//cache palm position
						handList[j].positionCached = handList[j].position;
					}
		}
		
		
		public function positionJoints():void 
		{
			// JOINT ALWAYS REPOSITIONED AS ARE DIRECT CONSEQUENCE ON TIPS AND KNUCKLES WHICH "ALWAYS" EXIST
			
					for (j = 0; j <handList.length; j++)
					{	
						// FIND MATCHING FINGER TIPS
						var fn:int = handList[j].tipList.length;
						
						if (handList[j].knuckleList.length != 0)// ONLY WHEN KNUCKLES EXIST
						{
							
							for (var k:int = 0; k <fn; k++)// fingertips
							{
							
									//get tip
									var ft:MotionPointObject = handList[j].tipList[k];
									
									// draw back to knucle from tip to knuckle
									for (var m:int = 0; m <handList[j].dipList.length; m++)// fingertips
									{
										var dp:MotionPointObject = handList[j].dipList[m];
									
										//POSITION DIPS
										if (k==m)
										{
											if ((ft.position)&&(ft.direction)){
											var pos:Vector3D = ft.position;
											var dir:Vector3D = ft.direction;
											var scale:Number = 15
											var dir_scale:Vector3D = new Vector3D(dir.x*scale,dir.y*scale,dir.z*scale)
											var v:Vector3D  = pos.subtract(dir_scale);
											
											//trace(v)
											dp.position = v;
											}
										}
									}
									
									//POSITION PIPS
									for (var m:int = 0; m <handList[j].pipList.length; m++)// fingertips
									{
										var pp:MotionPointObject  = handList[j].pipList[m];
										
										if ((k-1)==m) 
										{
											if((ft.position)&&(ft.direction)){
											// get anchor point
											var pos:Vector3D = ft.position;
											var dir:Vector3D = ft.direction;
											var scale:Number = 30
											var dir_scale:Vector3D = new Vector3D(dir.x*scale,dir.y*scale,dir.z*scale)
											var v:Vector3D  = pos.subtract(dir_scale);
											
											// get knuckle direction
											var kp:Vector3D = handList[j].knuckleList[m + 1].position;
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
			
		}
		
		
		public function findClassifiedFingerData():void 
		{
			for (j = 0; j < handList.length; j++)
				{
					// GET KNUCKLE TO PALM PLANE PROJECTED TIP VECTOR
					if (handList[j].index.id) 	handList[j].index.palmplane_finger_knuckle_direction = handList[j].index.palmplane_position.subtract(handList[j].knuckleList[1].position);
					if (handList[j].middle.id) 	handList[j].middle.palmplane_finger_knuckle_direction = handList[j].middle.palmplane_position.subtract(handList[j].knuckleList[2].position);
					if (handList[j].ring.id) 	handList[j].ring.palmplane_finger_knuckle_direction = handList[j].ring.palmplane_position.subtract(handList[j].knuckleList[3].position);
					if (handList[j].pinky.id) 	handList[j].pinky.palmplane_finger_knuckle_direction = handList[j].pinky.palmplane_position.subtract(handList[j].knuckleList[4].position);
				}
		}
		
		
		public function findHandOrientation():void 
		{
			///////////////////////////////////////////////////////////////////////////////////////////////////			
			// GET HAND ORIENTATION
			// CREATE METHOD WHEN NO FINGERS EXIST BUT THUMB IS PRESENT
			// CREATE ORIENTATION LOCK SO STABLE TO FINGER NUMBER AND TYPE JBUT CHANGES IF FLIPS FROM PREVIOUS STATE
			for (j = 0; j < handList.length; j++)
				{
					//var v:Vector3D = handList[j].fingerAveragePosition.subtract(handList[j].palm.position)
					if (handList[j].pureFingerAveragePosition && handList[j].palm.position && handList[j].palm.normal){
					var v:Vector3D = handList[j].pureFingerAveragePosition.subtract(handList[j].palm.position)
					var orienAngle:Number = v.dotProduct(handList[j].palm.normal);// Vector3D.angleBetween(v0, v1);
							
					if (orienAngle > 0) {
							handList[j].orientation = "down";
						}
					else if (orienAngle < 0) {
							handList[j].orientation = "up";
						}
					else handList[j].orientation = "undefined";	
					//trace(orienAngle,handList[j].orientation);
					}
				}
		}
		
		public function findFingerAverage():void 
		{

				//////////////////////////////////////////////////////////////////////////////
				// GET FAV 
				for (j = 0; j < handList.length; j++)
				{
					var fav_pt:Vector3D = new Vector3D();
					var pfav_pt:Vector3D = new Vector3D();
					var hfn:int = handList[j].fingerList.length;
					var hfnk:Number = 0;
					
					if (hfn) hfnk = 1 / hfn;
					
					if (handList[j].position && handList[j].normal){
					
					for (i = 0; i < hfn; i++)
							{	
									var fpt:MotionPointObject = handList[j].fingerList[i];

									// finger average point (fingers + thumb)
									fav_pt.x += fpt.position.x;
									fav_pt.y += fpt.position.y;
									fav_pt.z += fpt.position.z;
									
									if (fpt.fingertype == "finger") 
									//if (motionArray[i].fingertype == "finger") // add other finger types
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
							
							pfav_pt.x *= (hfnk - 1);
							pfav_pt.y *= (hfnk - 1);
							pfav_pt.z *= (hfnk - 1);
							
							//////////////////////////////////////////////////////////////////////////////////////////////////
							// push fav point to hand object
							handList[j].fingerAveragePosition = fav_pt;
							handList[j].pureFingerAveragePosition = pfav_pt;
							
							//GET PROJECTED FAV POINT AND PROJECTED PUREFINGERFAV POINT
							var vp_mp:Vector3D = fav_pt.subtract(handList[j].position);
							var normal:Vector3D = handList[j].normal;
							var dist1:Number = (vp_mp.x * normal.x) + (vp_mp.y * normal.y) + (vp_mp.z * normal.z);
							var fav_palm_plane_point:Vector3D = new Vector3D((fav_pt.x - dist1 * normal.x), (fav_pt.y -dist1 * normal.y), (fav_pt.z - dist1 * normal.z));
							
							var pvp_mp:Vector3D = pfav_pt.subtract(handList[j].position);
							var pdist1:Number = (pvp_mp.x * normal.x) + (pvp_mp.y * normal.y) + (pvp_mp.z * normal.z);
							var pfav_palm_plane_point:Vector3D = new Vector3D((pfav_pt.x - pdist1 * normal.x), (pfav_pt.y -pdist1 * normal.y), (pfav_pt.z - pdist1 * normal.z));
							
							handList[j].projectedFingerAveragePosition = fav_palm_plane_point;
							handList[j].projectedPureFingerAveragePosition = pfav_palm_plane_point;
						}
				}
				//trace("hand pos",hand.position)
		}

		
		public function findHandRadius():void 
		{

			for (j = 0; j < handList.length; j++)
				{
					//trace("number finger",fn,fnk,fav_pt.x,fav_pt.y,fav_pt.z)
					var favlength:Number = 0//100//100;
					var palmratio:Number = 0.55//1.4;
							
					var hfn:int = handList[j].fingerList.length;
					var hfnk:Number = 0;
					if (hfn) hfnk = 1 / hfn;
					
						for (i = 0; i < hfn; i++)
								{
								//if(){
								handList[j].fingerList[i].favdist = Vector3D.distance(handList[j].fingerList[i].position, handList[j].fingerAveragePosition);
								// find average max length
								//favlength += handList[j].fingerList[i].max_length; //??????
								favlength += handList[j].fingerList[i].favdist; 
								//trace("favdist", handList[j].fingerList[i].max_length, handList[j].fingerList[i].favdist,handList[j].fingerList[i].fingertype, hfnk)
								//}
								}
					favlength *= hfnk;	
					//trace(palmratio , favlength);
					
					// set current favlength
					handList[j].favlength = favlength;
					
					//finger average distance max // only reset if larger than previous
					if (favlength > handList[j].max_favlength) handList[j].max_favlength = favlength;
					
					// AVERAGE HAND RADIUS USES CACHED MAXIMUM FAVLENGTH FO SESSION
					handList[j].radius = handList[j].max_favlength * palmratio;	
					//handList[j].sphereRadius = favdist * palmratio;	
					//trace("rad",handList[j].sphereRadius)
				}
		}
		
		public function findHandDirection():void 
		{
			
			var hn:int = handList.length;
			
			for (j = 0; j < hn; j++)
			{
					// TEST
					/*
					///////////////////////////////////////////////////////////////////////
					// CALCUALTE DIRECTION OF HAND
					var direction:Vector3D = handList[j].projectedFingerAveragePosition.subtract(handList[j].position); 
					var pdirection:Vector3D = handList[j].projectedPureFingerAveragePosition.subtract(handList[j].position); 
					
					var length:Number = direction.length;
					var unit_dir:Vector3D = new Vector3D(direction.x / length, direction.y / length, direction.z / length);
					var plength:Number = pdirection.length;
					var punit_dir:Vector3D = new Vector3D(pdirection.x / plength, pdirection.y / plength, pdirection.z / plength);
					
					//trace(handList[j].direction, handList[j].palm.direction, direction, unit_dir , length)
					//trace(handList[j].direction,handList[j].palm.direction, pdirection, punit_dir , plength)
					
					handList[j].palm.direction = unit_dir//direction
					handList[j].direction = unit_dir//direction
					
					//handList[j].palm.direction = punit_dir//direction
					//handList[j].direction = punit_dir//direction
					//////////////////////////////////////////////////////////////////////////////////
					*/
					
					
					///////////////////////////////////////////////////////////////////////////////////
					var hfn:uint = handList[j].fingerList.length;
					var dir:Vector3D = new Vector3D();
					var classified_count:int = 0;
					var ck:Number = 0;
					
					for (i = 0; i < hfn; i++)
					{	
					var fpt:MotionPointObject = handList[j].fingerList[i];

						if ((fpt.type == "finger")&&(fpt.fingertype != "")&&(fpt.fingertype != "thumb"))// exclude unclassified fingers and thumbs
						{
							//var finger_dir:Vector3D = fpt.palmplane_finger_knuckle_direction;
							classified_count += 1;
								
							dir.x +=  fpt.palmplane_finger_knuckle_direction.x;
							dir.y +=  fpt.palmplane_finger_knuckle_direction.y;
							dir.z +=  fpt.palmplane_finger_knuckle_direction.z;
							//trace("loop",fpt.fingertype,fpt.position,fpt.palmplane_finger_knuckle_direction, classified_count)
						}
					}

					if (classified_count!=0) ck = 1 / classified_count;
					else ck = 0;
							
						dir.x *= ck;
						dir.y *= ck;
						dir.z *= ck;
						
					
					// normalize vector
					var lng:Number = dir.length;
					var udir:Vector3D = new Vector3D(dir.x / lng, dir.y / lng, dir.z / lng);
					
					handList[j].direction_finger = dir;
					//trace("new dir",lng, dir,udir,ck, classified_count);
					
					if (lng) 
					{
						handList[j].palm.direction = udir//direction
						handList[j].direction = udir//direction
						
						//trace("fix direction")
					}
					
					/////////////////////////////////////////////////////////////////////////////////////////
					
					
					
					
					
					
					///////////////////////////////////////////////
					// GET DIRECTION / NORMAL CROSS PRODUCT
					if (handList[j].palm.normal && handList[j].palm.direction)
					{
					 handList[j].d_n_crossproduct =  handList[j].palm.normal.crossProduct(handList[j].palm.direction);
					}
			}
		}
		
		// get nomalized finger length and palm angle
		// splay and flatness
		public function normalizeFingerFeatures():void 
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
			
			var hn:int = handList.length
			
			for (j = 0; j < hn; j++)
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
				
			if(handList[j].palm.position && handList[j].palm.direction && handList[j].palm.normal && handList[j].fingerAveragePosition){
			
			var hfn:uint = handList[j].fingerList.length;
			var palm_mpoint:MotionPointObject = handList[j].palm; // NEED TO SIMPLIFY		
			
			var normal:Vector3D = palm_mpoint.normal;
			var direction:Vector3D = palm_mpoint.direction;
			var p_pos:Vector3D = palm_mpoint.position;
			var fav_pos:Vector3D = handList[j].fingerAveragePosition;
			var fvp_mp:Vector3D = fav_pos.subtract(p_pos);
			
			var dist:Number = (fvp_mp.x * normal.x) + (fvp_mp.y * normal.y) + (fvp_mp.z * normal.z);
			var palm_plane_favpoint:Vector3D = new Vector3D((fav_pos.x - dist * normal.x), (fav_pos.y -dist*normal.y), (fav_pos.z - dist*normal.z));
							
			///////////////////////////////////////////////////
			// set plam plane fav projection point
			handList[j].projectedFingerAveragePosition = palm_plane_favpoint;
			
			
			// get values
			for (i = 0; i < hfn; i++)
				{	
					var fpt:MotionPointObject = handList[j].fingerList[i];
						
							//GET PALM PLANE POINT PROJECTION
							var f_pos:Vector3D = fpt.position;
							var vp_mp:Vector3D = f_pos.subtract(p_pos);
							var dist1:Number = (vp_mp.x * normal.x) + (vp_mp.y * normal.y) + (vp_mp.z * normal.z);
							var palm_plane_point:Vector3D = new Vector3D((f_pos.x - dist1 * normal.x), (f_pos.y -dist1 * normal.y), (f_pos.z - dist1 * normal.z));
							
							fpt.palmplane_position = palm_plane_point
							//trace("projected point in palm plane",palm_plane_point)
							
							// GET PALM LINE POINT PROJECTION
							//var vp_mpl:Vector3D = f_pos.subtract(p_pos);
							var vp_mpl:Vector3D = palm_plane_point.subtract(p_pos);
							var dist2:Number = (vp_mpl.x * direction.x) + (vp_mpl.y * direction.y) + (vp_mpl.z * direction.z);
							
							var splay:Number = handList[j].splay;
							var palm_plane_line_point:Vector3D = new Vector3D((palm_plane_point.x - dist2 * direction.x), (palm_plane_point.y -dist2 * direction.y), (palm_plane_point.z - dist2 * direction.z));
							//var palm_plane_line_point:Vector3D = new Vector3D((f_pos.x - dist2 * direction.x), (f_pos.y -dist2 * direction.y), (f_pos.z - dist2 * direction.z));
							
							
							//palm_plane_line_point = new Vector3D (palm_plane_line_point.x*splay,palm_plane_line_point.y*splay,palm_plane_line_point.z);
							
							// from angle with cross product
							//var dist2:Number = Vector3D.distance(palm_plane_point, p_pos);
							//var vp_mpl:Vector3D = palm_plane_point.subtract(p_pos);
							//var cross:Vector3D = palm_mpoint.direction.crossProduct(palm_mpoint.normal);
							//var ang:Number = Vector3D.angleBetween(vp_mpl, cross);
							//var palm_plane_line_point:Vector3D = new Vector3D(palm_mpoint.position.x+dist2 * Math.cos(ang),palm_mpoint.position.y,palm_mpoint.position.z);
						
							// TEST SPLAY CORRECTION
							//trace(handList[j].splay)
							
							fpt.palmplaneline_position = palm_plane_line_point
							
				
							var ppp_dir:Vector3D = palm_plane_point.subtract(p_pos);
							
							// set palm angle of point
							fpt.palmAngle =  Vector3D.angleBetween(ppp_dir, palm_mpoint.direction);
							//palmAngle = Math.abs(Vector3D.angleBetween(motionArray[i].direction, palm_mpoint.direction));

							// calc proper length from palm
							fpt.length = Vector3D.distance(p_pos, f_pos) //- std_radius;
							
							// PALM FINGER VECTOR
							fpt.palm_finger_direction = fpt.position.subtract(palm_mpoint.position);
							
							//PROJECTED PALM FINGER VECTOR
							fpt.projected_palm_finger_direction = fpt.palmplane_position.subtract(palm_mpoint.position);
							
							//PROJECTED FINGER TIP VECTOR /////////////////////////////////////////////////////////
							var fvtip_pos:Vector3D = f_pos.add(fpt.direction);
							var fvtip_pos_palm:Vector3D = fvtip_pos.subtract(p_pos)
							var dist2:Number = (fvtip_pos_palm.x * normal.x) + (fvtip_pos_palm.y * normal.y) + (fvtip_pos_palm.z * normal.z);
							var projected_direction_pt:Vector3D = new Vector3D((fvtip_pos.x  - dist2 * normal.x), (fvtip_pos.y -dist2*normal.y), (fvtip_pos.z - dist2*normal.z));
							fpt.projected_finger_direction = projected_direction_pt.subtract(fpt.palmplane_position);
							
							
							
							
							
							// FIND EXTENSION MEASURE
							var angle_diff:Number = Vector3D.angleBetween(fpt.direction, fpt.palm_finger_direction);
							// normalize
							fpt.extension = normalize(angle_diff, 0, Math.PI*0.5);
				}
						
				// find max and min values
				for (i = 0; i < hfn; i++)
				{
					var fpt0:MotionPointObject = handList[j].fingerList[i];
					
						//max length max and min
						//var value_max_length:Number = fpt0.max_length;
						//if (value_max_length > max_max_length) max_max_length = value_max_length;
						//if ((value_max_length < min_max_length)&&(value_max_length!=0)) min_max_length = value_max_length;
						
						// LOCAL LENGTH MAX AND MIN OF FINGER GROUP
						var value_length:Number = fpt0.length; //SIMPLE PALM TO FINGER
						if (value_length > max_length) max_length = value_length;
						if ((value_length < min_length) && (value_length != 0)) min_length = value_length;
						
						// LOCAL WIDTH MAX AND MIN OF FINGER GROUP
						var value_width:Number = fpt0.width;
						if (value_width > max_width) max_width = value_width;
						if ((value_width < min_width)&&(value_width!=0)) min_width = value_width;
						
						// LOCAL PALM ANGLE MAX AND MIN OF FINGER GROUP
						var value_palm:Number = fpt0.palmAngle; //
						if (value_palm > max_palmAngle) max_palmAngle = value_palm;
						if ((value_palm < min_palmAngle)&&(value_palm!=0)) min_palmAngle = value_palm;

						//LOCAL FINGER AVERAGE DISTANCE TO PALM POINT OF FINGER GROUP
						var value:Number = fpt0.favdist; //
						if (value > max_favdist) max_favdist = value;
						if ((value < min_favdist) && (value != 0)) min_favdist = value;
						
						
						/////////////////////////////////////////////////////////////////////////////////
						// FIND MAX AND MIN LENGTHS AND WIDTH THAT ARE STORED IN THE MOTION POINT OBJECT
						
						// length max and min OF FINGER
						var value_length:Number = fpt0.length;
						if (value_length > fpt0.max_length) fpt0.max_length = value_length;
						if ((value_length < fpt0.min_length) && (value_length != 0)) fpt0.min_length = value_length;
						
						// width max and min OF FINGER
						var value_width:Number = fpt0.width;
						if (value_width > fpt0.max_width) fpt0.max_width = value_width;
						if ((value_width < fpt0.min_width)&&(value_width!=0)) fpt0.min_width = value_width;
				}
				
				for (i = 0; i < hfn; i++)
				{
					var fpt:MotionPointObject = handList[j].fingerList[i];
					
						//max length max and min OF FINGER GROUP
						var value_max_length:Number = fpt.max_length;
						if (value_max_length > max_max_length) max_max_length = value_max_length;
						if ((value_max_length < min_max_length) && (value_max_length != 0)) min_max_length = value_max_length;
						
						//max length max and min OF FINGER GROUP
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
						var fpt1:MotionPointObject = handList[j].fingerList[i];
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
						var fpt3 = handList[j].fingerList[i];
						fpt3.normalized_mwlr = normalize(fpt3.max_width_length_ratio, min_mwlr, max_mwlr);
						//trace("hand normalized values",i,fpt3.normalized_length,fpt3.normalized_width, fpt3.normalized_max_length,fpt3.normalized_max_width,fpt3.normalized_mwlr)

					}
					
					
					
					///////////////////////////////////////////////////////////////////////////////////////////////
					// FIND HAND FLATNESS MEASURE
					// DIST BETWEEN FAV POINT AND PROJECTED FAV POINT IN PLANE
					// SHOULD ADD EXCEPTION FO WHEN NO FINGERS (ZERO DISTANCE)
					var pfav_fav_dist:Number = Vector3D.distance(palm_plane_favpoint,fav_pos)
					handList[j].flatness = normalize(pfav_fav_dist, 0, 30);
					//trace("flatness", handList[j].flatness);
					
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
							var dist0:Number = Vector3D.distance(handList[j].fingerList[i].position,handList[j].fingerList[q].position);
							splay_d += dist0;
						}
					}
					}
					
					splay_d = 2 * splay_d / (hfn * (hfn - 1));
					handList[j].splay = normalize(splay_d, 30, 120);
					//trace("splay", handList[j].splay);
			}
			}
		}
		
		
		// find thumb .. generate pair data
		//TODO: FIND ORIENTATION REQUIREMENT FOR THUMB
		public function findThumb():void
		{
			
		var hn:int = handList.length
		
		for (j = 0; j < hn; j++)
			{
				
			handList[j].pair_table = new Array();
			
			var hfn:int = handList[j].fingerList.length;
			
			var fpt:MotionPointObject //= handList[j].fingerList[i];
			var palm_mpoint:MotionPointObject

						///////////////////////////////////////////////////////////////////////////////////
						// MOD THUMB PROB WITH FINGER LENGTH AND WIDTH
						
							// reset thumb
							//handList[j].thumb = new MotionPointObject();
							
							// get largest thumb prob
							var thumb_list:Array = new Array()
							
							//trace("--");
							
							
							for (i = 0; i < hfn; i++)
								{
									fpt = handList[j].fingerList[i];
									
									// RESET THUMB PROB HIST
									fpt.thumb_prob = 0

									//ALL FEATURES////////////////////////////////////////////////////////////
									fpt.thumb_prob += 2*(1- fpt.normalized_length)//2
									fpt.thumb_prob += 5*(fpt.normalized_favdist) //WORKS VERY WELL ON OWN
									fpt.thumb_prob += 2 * (fpt.normalized_palmAngle);//2
									
									// NO WIDTH WHEN IN WEBSOCKET
									//trace("width",i,fpt.width)
									if (fpt.width) fpt.thumb_prob += 1 * (fpt.normalized_mwlr); //width to length ratio
									
									//fpt.thumb_prob += 1 * (fpt.normalized_width) // experimentatal
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
						
						if ((max_index != -1) && (handList[j].fingerList[max_index]) && (handList[j].fingerList[max_index].type == "finger")) //&&(!handList[j].thumb)
						{
							
							// 
							//var v = handList[j].projectedFingerAveragePosition.subtract(handList[j].palm.position)
							var v:Vector3D = handList[j].palm.direction;
							var v1:Vector3D = handList[j].fingerList[max_index].palmplane_position.subtract(handList[j].palm.position)
							
							var angle:Number = Vector3D.angleBetween(v, v1)
							var length:int = handList[j].fingerList[max_index].length;
							var favdist:Number = handList[j].fingerList[max_index].favdist;
							
								//////////////////////////////////////////////////////////////////////
								// QUICK EFFECTIVE METRIC/////////////////////////////////////////////
								// FOR WHEN FN!=5
								var ratio:Number = (1.1*length) / (favdist + 50 * angle)
								//////////////////////////////////////////////////////////
								
								
								//////////////////////////////////////////////////////////////////////
								// THUMB VALIDITY CHECK
								var validthumb:Boolean = true;// init value when no type lock
								if ((handList[j].lockedType == "left") || (handList[j].lockedType == "right")) 
									{
										validthumb = false; 
											//PREVENTS THUMB REASIGNMENT (DURING PINCH)
											//PREVENTS THUMB OVERIDING CLASIFIED FINGERS
											//(handList[j].fingerList[max_index].fingertype=="")
											if ((handList[j].fingerList[max_index]) && (handList[j].palm)&&(handList[j].fingerList[max_index].fingertype==""))
											{
												var tVector:Vector3D = handList[j].fingerList[max_index].position.subtract(handList[j].palm.position);
												var angle2:Number = handList[j].d_n_crossproduct.dotProduct(tVector);
												
												if ((angle2 < 0)&&(handList[j].lockedType == "left")) {
													validthumb = true;
												}
												//right match
												if ((angle2 > 0)&&(handList[j].lockedType == "right")) {
													validthumb = true;
												}
											}
									}
									else if ((handList[j].type == "left") || (handList[j].type == "right")) 
									{
										validthumb = false; 
										
										if ((handList[j].fingerList[max_index]) && (handList[j].palm)&&(handList[j].fingerList[max_index].fingertype==""))
											{
												var tVector:Vector3D = handList[j].fingerList[max_index].position.subtract(handList[j].palm.position);
												var angle2:Number = handList[j].d_n_crossproduct.dotProduct(tVector);
												
												if ((angle2 < 0)&&(handList[j].type == "left")) {
													validthumb = true;
												}
												//right match
												if ((angle2 > 0)&&(handList[j].type == "right")) {
													validthumb = true;
												}
											}
									}
									//THERE CAN BE ONLY ONE THUMB
									//else if (handList[j].thumb) {
										//if (handList[j].thumb.id) validthumb = false; 
									//}
									
									//trace("type",handList[j].type,handList[j].lockedType,validthumb);
									
								/////////////////////////////////////////////////////////////////////////
								

								if (validthumb)
								{
									//trace(ratio);
									if (hfn == 5)
									{
									if ((ratio < 0.8))//0.56
									{
										// SET THUMB TYPE
										handList[j].fingerList[max_index].fingertype = "thumb";	
									
										// SET THUMB IN HAND OBJECT
										handList[j].thumb = handList[j].fingerList[max_index];
										//trace("assign thumb", hfn);
										return
									}
									else {
										handList[j].fingerList[max_index].fingertype = "";
										handList[j].thumb = null//handList[j].fingerList[max_index];//null
										//trace("fail", hfn,handList[j].fingerList[max_index].position);
									}
									}
									else if (hfn == 4)
									{
									if ((ratio < 0.70))
									{
										// SET THUMB TYPE
										handList[j].fingerList[max_index].fingertype = "thumb";	
									
										// SET THUMB IN HAND OBJECT
										handList[j].thumb = handList[j].fingerList[max_index];
										//trace("assign thumb", hfn);
										return
									}
									else {
										handList[j].fingerList[max_index].fingertype = ""//"finger";
										handList[j].thumb = null//handList[j].fingerList[max_index];//null
										//trace("fail", hfn,handList[j].fingerList[max_index].position);
									}
									}
									else if (hfn == 3)
									{
									if (ratio < 1.2)
									{
										// SET THUMB TYPE
										handList[j].fingerList[max_index].fingertype = "thumb";	
									
										// SET THUMB IN HAND OBJECT
										handList[j].thumb = handList[j].fingerList[max_index];
										//trace("assign thumb", hfn);
										return
									}
									else {
										handList[j].fingerList[max_index].fingertype = ""//"finger";
										handList[j].thumb = null//handList[j].fingerList[max_index];//null
										//trace("fail", hfn,handList[j].fingerList[max_index].position);
									}
									}
									
									else if (hfn == 2) 
									{
										if (ratio < 2.1)
										{
										handList[j].fingerList[max_index].fingertype = "thumb";
										handList[j].thumb = handList[j].fingerList[max_index];
										return
										}
										
										else {
										handList[j].fingerList[max_index].fingertype =""// "finger";
										handList[j].thumb = null;
										}
									}
								}
						}
						
						// NEED SECONDARY CONDITIONS TO ENSURE PINKY NOT SELECTED
						// CHECK LOCKED TYPE SEE IF ON CORRECT SIDE OF HAND
						else if ((validthumb)&&(hfn == 1)&&(handList[j].fingerList[0].type == "finger"))
						{
							// RATIO BREAKS APPART AS LENGTH AND FAV DIST NO LONGER RELEVANT
							// ANGLE IS ONLY REMAINING METRIC
							var v0:Vector3D = handList[j].palm.direction
							var v10:Vector3D = handList[j].fingerList[0].palmplane_position.subtract(handList[j].palm.position)
							var angle0:Number = Vector3D.angleBetween(v0, v10)
							//trace("one", angle);
							
								if (angle0 > 0.2)
								{
									//trace("one")
									handList[j].fingerList[0].fingertype = "thumb";
									handList[j].thumb = handList[j].fingerList[0];
									return
								}
								else {
									handList[j].fingerList[0].fingertype =""// "finger";
									handList[j].thumb = null;
								}
								
							}
	
						////////////////////////////////////////////////////////////////////////////////
						// GET HANDEDNESS
						// PERHAPS CROSS CHECK WITH ORIENTATION
						// INCASE SYSTEM THINKS HAND IS UPSIDE DOWN
						if ((handList[j].thumb)&&(handList[j].orientation=="down"))
						{
							//trace("thumb",handList[j].thumb.width,handList[j].thumb.normalized_width,handList[j].thumb.normalized_mwlr)
							
							if(handList[j].thumb.position){
							var thumbVector:Vector3D = handList[j].thumb.position.subtract(handList[j].palm.position);
							var angle1:Number =  handList[j].d_n_crossproduct.dotProduct(thumbVector)
							
							if(angle1){
								if (angle1 < 0) handList[j].type = "left";
								if (angle1 > 0) handList[j].type = "right";
							}
							//else if (angle1 ==NaN) handList[j].type = "undefined";
							
							//trace(angle, handList[j].type)
							}
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
			var hn:int = handList.length
				
			//trace("hand length",hn );
				
			for (var j:int = 0; j < hn; j++)
				{	
					
				//////////////////////////////////////////////////////////////////////////////////////////////////////////////	
				min_pprob = 20000;
				best_dist = 0;
				best_pt1 = new MotionPointObject()
				best_pt2 = new MotionPointObject();
				palm = handList[j].palm;
				
				// GET LOCAL LIST OF CLOSE FINGER TIPS
				// gererate pair distances
				var fn:int = handList[j].fingerList.length;
				
				
				
				for (var i:int = 0; i < fn; i++)
					{
					for (var q:int = 0; q < i+1; q++)
					{
						if ((i!=q))
						{
							var pt1:MotionPointObject = handList[j].fingerList[i];
							var pt2:MotionPointObject = handList[j].fingerList[q];
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
							
							pmp.screen_position.x = best_pt1.screen_position.x - (best_pt1.screen_position.x - best_pt2.screen_position.x) * 0.5;
							pmp.screen_position.y = best_pt1.screen_position.y - (best_pt1.screen_position.y - best_pt2.screen_position.y) * 0.5;
							pmp.screen_position.z = best_pt1.screen_position.z - (best_pt1.screen_position.z - best_pt2.screen_position.z) * 0.5;
							
							pmp.handID = handList[j].handID;
							pmp.type = "pinch";
							pmp.mode = "motion";
															
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
							
							pmp0.screen_position.x = best_pt1.screen_position.x - (best_pt1.screen_position.x - best_pt2.screen_position.x) * 0.5;
							pmp0.screen_position.y = best_pt1.screen_position.y - (best_pt1.screen_position.y - best_pt2.screen_position.y) * 0.5;
							pmp0.screen_position.z = best_pt1.screen_position.z - (best_pt1.screen_position.z - best_pt2.screen_position.z) * 0.5;
							
							//pmp.handID =  handList[j].handID;
							pmp0.type = "pinch";
							pmp0.mode = "motion";
															
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
			var hn:int = handList.length
			
			for (var j:int = 0; j < hn; j++)
				{	
				var hfn:int = handList[j].fingerList.length;
				
				for (i = 0; i < hfn; i++)
				{
					var hp:MotionPointObject = handList[j].fingerList[i];
					//trace("hook extension",hp.extension)
						
					if (hp.fingertype == "finger")
					{
						if(hp.extension > hookThreshold)
							{	
							var pmp:InteractionPointObject = new InteractionPointObject();
								pmp.handID = hp.handID;
								pmp.position = hp.position;
								pmp.direction = hp.direction;
								//pmp.length = motionArray[i].length;
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
								//pmp.length = motionArray[i].length;
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
			var hn:int = handList.length
			
			for (var j:int = 0; j < hn; j++)
				{	
				var hfn:int = handList[j].fingerList.length;
					
					for (var i:int = 0; i < hfn; i++)
					{
						var pp:MotionPointObject = handList[j].fingerList[i];
						
							//trace("pos",motionArray[i].position)
							if (pp.position.x > z_wall) //side
							//if (pp.position.y > z_wall) //bottom
							//if (motionArray[i].position.z > z_wall) //front
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
			var hn:int = handList.length
			
				for (var j:int = 0; j < hn; j++)
				{	
				var hfn:int = handList[j].fingerList.length;
				var hfnk:Number = 0;
				var thumb:MotionPointObject = handList[j].thumb;	
				
					//trace("THUMB EXTENTION",thumb.extension,triggerThreshold)
					if (thumb)
					{
						// ADDED ONLY ONE FINGER CONDITION
						// NEED TO ADD STRAIGHT THUMB TRIGGER
						
						if ((thumb.extension > triggerThreshold)&&(handList[j].fingerList.length>=1)) //1 rad 90 deg ish
							{
							var	t_pt:InteractionPointObject = new InteractionPointObject();
							
							for (i = 0; i < hfn; i++)
							{
								if (handList[j].fingerList[i].fingertype == "finger")
								{
								var pt:MotionPointObject = handList[j].fingerList[i];
				
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
							//t_pt.handID = hand.handID;		
							
							t_pt.fn = handList[j].fingerList.length
							t_pt.type = "trigger";
							
							// push when triggered
							InteractionPointTracker.framePoints.push(t_pt);
							
							trace("trigger point", t_pt);
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
			var hn:int = handList.length
			
			for (var j:int = 0; j < hn; j++)
				{	
				x_min = 0; 
				x_max = 300;
				y_min = 0; 
				y_max = 300;
				z_min = 0; 
				z_max = 300;	

				var hfn:int = handList[j].fingerList.length;
			
					for (i = 0; i < hfn; i++)
						{
						var pt:MotionPointObject = handList[j].fingerList[i];	
						
						if ((x_min < pt.position.x < x_max) && (y_min < pt.position.y < y_max) && (z_min < pt.position.z < z_max))
							{
								// create region point
								var tp:InteractionPointObject = new InteractionPointObject();
									tp.position = motionArray[i].position;
									tp.direction = motionArray[i].direction;
									tp.length = motionArray[i].length;
									//tp.handID = motionArray[i].handID;
									tp.type = "region";
						
									//iPointArray.push(tp); // test
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
			var hn:int = handList.length
			
			for (var j:int = 0; j < hn; j++)
				{	
				var pointlist:Vector.<MotionPointObject>
				var hfn:int = handList[j].fingerList.length;
			
				pointlist = new Vector.<MotionPointObject>
				
				if (hfn == 2)
				{
						/// find extended fingers
						for (var i:int = 0; i < hfn; i++)
						{
							var pt:MotionPointObject = handList[j].fingerList[i];
							if ((pt.type == "finger") && (pt.extension < minExtension)) pointlist.push(pt);
							//trace(pt.extension)
						}
						//trace(pointlist.length)
						
						if (pointlist.length == 2) 
						{
							var palm_finger_vectorA:Vector3D = pointlist[0].position.subtract(handList[j].position);
							var palm_finger_vectorB:Vector3D = pointlist[1].position.subtract(handList[j].position);
							var angle_diff:Number = Vector3D.angleBetween(palm_finger_vectorA, palm_finger_vectorB);
							//trace("diff", angle_diff);
							
							if ((angle_diff > minAngle)&&(angle_diff < maxAngle))
							{
							
								// create complimentary frame points
								var fav:Vector3D = handList[j].fingerAveragePosition;
								var palm_fav_vector:Vector3D = fav.subtract(handList[j].position);
								var cpt:Vector3D = fav.add(palm_fav_vector);
								
								var cff_pt:InteractionPointObject = new InteractionPointObject();
										cff_pt.position = cpt;
										//cff_pt.direction = palm.direction;
										//t_pt.normal = hand.normal;
										cff_pt.handID = handList[j].handID;
										cff_pt.type = "frame";
										
									InteractionPointTracker.framePoints.push(cff_pt)
								
								// palm point // create interactions points
								var ff_pt:InteractionPointObject = new InteractionPointObject();
										ff_pt.position = handList[j].position;
										//ff_pt.direction = palm.direction;
										//t_pt.normal = hand.normal;
										//ff_pt.handID = handList[j].handID;
										ff_pt.type = "frame";
										
								InteractionPointTracker.framePoints.push(ff_pt)
								//trace("push frame point");
									
								for (var q:int = 0; q < pointlist.length; q++)
								{
									// create interactions points
									var ff_pt0:InteractionPointObject = new InteractionPointObject();
										ff_pt0.position = pointlist[q].position;
										//ff_pt.direction =pointlist[j].direction;
										//t_pt.normal = hand.normal;
										//ff_pt.handID = handList[j].handID;
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
			var hn:int = handList.length
			
			for (var j:int = 0; j < hn; j++)
				{	
				var hfn:int = handList[j].fingerList.length;
			
				for (var i:int = 0; i < hfn; i++)
						{
							var fpt:MotionPointObject = handList[j].fingerList[i];
							/// get fingers
							if (fpt.fingertype == "finger")
							{
								var f_pt:InteractionPointObject = new InteractionPointObject();
										f_pt.position = fpt.position;
										f_pt.direction = fpt.direction;
										//f_pt.handID = hand.handID;
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
			var hn:int = handList.length
			
			for (var j:int = 0; j < hn; j++)
				{	
					var hfn:int = handList[j].fingerList.length;
					//var v0:Vector3D = new Vector3D(0,0,0)
					//get thumb points
					if ((hfn>0)&&(handList[j].thumb!=null)&&(handList[j].thumb.fingertype=="thumb")) 
					{
						var tpt:MotionPointObject = handList[j].thumb;
						
						var t_pt:InteractionPointObject = new InteractionPointObject();
							t_pt.position = tpt.position;
							t_pt.direction = tpt.direction;
							//t_pt.handID = hand.handID;
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
		var hn:int = handList.length	
			
			for (var j:int = 0; j < hn; j++)
				{	
					var hfn:int = handList[j].fingerList.length;
					
					for (var i:int = 0; i < hfn; i++)
						{
						var dpt:MotionPointObject = handList[j].fingerList[i];
					
							if((dpt)&&(dpt.fingertype=="thumb")||(dpt.fingertype == "finger")) 
							{
							var d_pt:InteractionPointObject = new InteractionPointObject();
								d_pt.position = dpt.position;
								d_pt.direction = dpt.direction;
								//t_pt.handID = hand.handID;
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
			var hn:int = handList.length
			
				for (j = 0; j < hn; j++)
				{
					var favpt:Vector3D = handList[j].fingerAveragePosition;
					
					if ((favpt.x != 0) && (favpt.y != 0) && (favpt.z != 0))
					{
						// FAV POINT NEEDS DIRECTION AND NORMAL
						var fv_pt:InteractionPointObject = new InteractionPointObject();
							fv_pt.position = handList[j].fingerAveragePosition;
							fv_pt.handID = handList[j].handID;
							fv_pt.type = "finger_average";

						InteractionPointTracker.framePoints.push(fv_pt)	
					}
				}
		}
		
		/////////////////////////////////////////////////////////////////////////
		// Collect Interactive Palm Points
		public function find3DPalmPoints():void 
		{
			var hn:int = handList.length;
			var flatness:Number = 0.4;
			var orientation:String;
			var handednes:String;
			
			// PALM IP MAY BE CREATED BASED ON FLATNESS , ORIENTATION AND HANDEDNESS CRITERIA
			// IN THE SAME WAY AS PINCH, HOOK, TRIGGER MAY BE CREATED BASED ON SEPERATION AND EXTENSION CRITERIA
			
				for (j = 0; j < gs.hn; j++)
				{
						var palm_pt:InteractionPointObject = new InteractionPointObject();
						
						////////////////////////////////////////////////////////////////
						// CREAT PALM POINT
						////////////////////////////////////////////////////////////////
						
							palm_pt.position = handList[j].palm.position;
							palm_pt.direction = handList[j].palm.direction;
							palm_pt.normal = handList[j].palm.normal;
							palm_pt.rotation = handList[j].palm.rotation;
							palm_pt.handID = handList[j].palm.handID;
							
							palm_pt.fn = handList[j].fingerList.length;
							
							palm_pt.flatness = handList[j].flatness;
							palm_pt.orientation = handList[j].orientation;
							//palm_pt.type  = handList[j].type 
							palm_pt.radius  = handList[j].radius  
							palm_pt.type = "palm";	
							
							//trace("fist: geometric", palm_pt.fist, handList[j].orientation, handList[j].flatness, handList[j].splay, handList[j].type);
							
						InteractionPointTracker.framePoints.push(palm_pt)
				}
		}
		
		public function find3DFistPoints():void 
		{
			var hn:int = handList.length;
			var flatness:Number = 0.4;
			var orientation:String;
			var handednes:String;
			
			//trace("find fist points");
			
			// PALM IP MAY BE CREATED BASED ON FLATNESS , ORIENTATION AND HANDEDNESS CRITERIA
			// IN THE SAME WAY AS PINCH, HOOK, TRIGGER MAY BE CREATED BASED ON SEPERATION AND EXTENSION CRITERIA
			
				for (j = 0; j < gs.hn; j++)
				{	
						var fist_pt:InteractionPointObject = new InteractionPointObject();
						
							// TEST FOR OPENESS
							//
							if (handList[j].fingerList.length == 0) 
							{
								if (handList[j].flatness<10) fist_pt.fist = true;
								//trace("fist: 0",handList[j].sphereRadius,handList[j].palm.sphereRadius,handList[j].flatness);
								
							}
							// STRONG TRACKING ERROR 2 FINGERS
							else if (handList[j].fingerList.length == 2)
							{
								if ((handList[j].fingerList[0].length < 80) && (handList[j].fingerList[1].length < 80))
								{
								//if ((handList[j].flatness<0.2)&&(handList[j].palm.sphereRadius<70)){
									fist_pt.fist = true;
								}
								//trace("2 fist: ",palm_pt.fist,handList[j].fingerAveragePosition,handList[j].fingerList[0].length,handList[j].fingerList[1].length);
							}
							// WEAK TRACKING ERROR 1 FINGER
							else if (handList[j].fingerList.length == 1)
							{
								if (handList[j].fingerList[0].length<90){
								//if ((handList[j].flatness<0.4)&&(handList[j].palm.sphereRadius<60)){
									fist_pt.fist = true;
								}
								//trace("1 fist: ",palm_pt.fist,handList[j].fingerList.length,handList[j].palm.sphereRadius,handList[j].flatness,handList[j].fingerAveragePosition,handList[j].fingerList[0].length);
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
								handList[j].orientation = "unknown";
								handList[j].flatness = 0;
								handList[j].splay = 0;
								handList[j].type = "unknown";
								//handList[j].fist = true;
								
								
								////////////////////////////////////////////////////////////////
								// CREAT FIST POINT
								////////////////////////////////////////////////////////////////
						
								fist_pt.position = handList[j].palm.position;
								fist_pt.direction = handList[j].palm.direction;
								fist_pt.normal = handList[j].palm.normal;
								fist_pt.rotation = handList[j].palm.rotation;
								fist_pt.handID = handList[j].palm.handID;
								
								fist_pt.fn = handList[j].fingerList.length;
								
								fist_pt.flatness = handList[j].flatness;
								fist_pt.orientation = handList[j].orientation;
								//palm_pt.type  = handList[j].type 
								fist_pt.radius  = handList[j].radius  
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
				var hfn:int = handList[j].fingerList.length;
			
				for (i = 0; i < hfn; i++)
				{
					
					if (motionArray[i].type == "tool")
						{	
							//trace("tool");
							//var pmp:MotionPointObject = new MotionPointObject();
							var pmp:InteractionPointObject = new InteractionPointObject();
								pmp.handID = handList[j].fingerList[i].handID;
								pmp.position = handList[j].fingerList[i].position;
								pmp.direction = handList[j].fingerList[i].direction;
								pmp.length = handList[j].fingerList[i].length;
								pmp.type = "tool";

								// push to interactive point list	
								InteractionPointTracker.framePoints.push(pmp)
						}
					}
				}*/
		}
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		///////////////////////////////////////////////////////////////////////////////////////////
		// FACE MOTION
		///////////////////////////////////////////////////////////////////////////////////////////
		
		///////////////////////////////////////////////////////////////////////////////////////////
		// collect interactive eye points
		public function find3DEyePoints():void
		{
			
			if (motionArray)
			{
			//trace("FIND3DEYEPOINTS",motionArray.length,motionArray2D.length)
			
			var pv:Vector3D = new Vector3D
			
				for (var i:int = 0; i < gs.mpn; i++)
				{
					var tp:MotionPointObject = motionArray[i];

					if (tp.type=="eye")
					{
						pv.x += tp.position.x;
						pv.y += tp.position.y;
						pv.z += tp.position.z;
						
						/*
						var tip:InteractionPointObject = new InteractionPointObject();
							tip.position = new Vector3D(tp.position.x, tp.position.y, tp.position.z);
							//tip.size. = tp.size;
							tip.mode = "motion";
							tip.type = "eye";
								
						// push to interactive point list
						InteractionPointTracker.framePoints.push(tip);
						//trace("push eye in geometric",tp.position);
						*/
					}
					/*
					else if (tp.type=="gaze")
					{
						var tip:InteractionPointObject = new InteractionPointObject();
							tip.position = new Vector3D(tp.position.x, tp.position.y, tp.position.z);
							//tip.size. = tp.size;
							tip.mode = "motion";
							tip.type = "gaze";
								
						// push to interactive point list
						InteractionPointTracker.framePoints.push(tip);
						//trace("push eye in geometric",tp.position);
					}*/	
				}
				
				pv.x *= 0.5;
				pv.y *= 0.5;
				pv.z *= 0.5;
				
				var tip:InteractionPointObject = new InteractionPointObject();
						tip.position = pv;
						//tip.size. = tp.size;
						tip.mode = "motion";
						tip.type = "eye";
								
				InteractionPointTracker.framePoints.push(tip);
				
				//trace("ip seed position",tip.position);
				
				
			}
		}
		
		// HEAD POINT//////////////////////////////////////////////////////////////////////////////
		
		public function find3DHeadPoints():void{}
		
		///////////////////////////////////////////////////////////////////////////////////////////
		//sensor metrics
		///////////////////////////////////////////////////////////////////////////////////////////
		
		public function findSensorAccelerometerPoints():void
		{
			if (sensorArray)
			{
			//trace("FIND andoird sensor POINTS",sensorArray.length)

				for (var i:int = 0; i < gs.spn; i++)
				{
					var tp:SensorPointObject = sensorArray[i];
					
					//trace("findSensorAccelPoints",sensorArray[i].acceleration);

					if (tp.type=="accelerometer")
					{
						//GestureGlobals.interactionPointCount++;
						
						var tip:InteractionPointObject = new InteractionPointObject();
						//tip.id = GestureGlobals.interactionPointCount;
						tip.acceleration = tp.acceleration;
						//tip.size. = tp.size;
						tip.mode = "sensor";
						//tip.category = "android";//??
						tip.type = "native_accelerometer";
								
						InteractionPointTracker.framePoints.push(tip);
						//trace("sensor ip",tip.acceleration);
					}
				}
				
			}
		}
		
		public function findSensorControllerPoints():void
		{
			if (sensorArray)
			{
			//trace("FIND andoird sensor POINTS",sensorArray.length)
			var mn:int = gs.spn;

				for (var i:int = 0; i < mn; i++)
				{
					var tp:SensorPointObject = sensorArray[i];
					
					//trace("findSensorAccelPoints",sensorArray[i].acceleration);

					if (tp.type=="controller")
					{
						var tip:InteractionPointObject = new InteractionPointObject();
						//tip.id = 10;
						tip.acceleration = tp.acceleration;
						//tip.orientation = tp.orientation;
						tip.mode = "sensor";
						//tip.category = "controller";
						tip.type = "wiimote";
						tip.buttons = tp.buttons;
								
						InteractionPointTracker.framePoints.push(tip);
						//trace("sensor ip",tip.acceleration);
					}
				}
				
			}
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