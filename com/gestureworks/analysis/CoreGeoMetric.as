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
		
		private var sw:int
		private var sh:int
		private var sd:int
		
		private var std_radius:int = 30;
		
		//private var tpn:uint = 0;
		//private var mpn:uint = 0;
	//	private var spn:uint = 0;
		//private var ipn:uint = 0;
		//private var hn:uint = 0;
		//private var fn:uint = 0;
		
		public var tag_match:Boolean = false;
		
		
		
		private var maxindex:Number = 0;
		private var maxmiddle:Number = 0;
		private var maxring:Number = 0;
		private var maxpinky:Number = 0;
			
		private var maxpfav:Number = 0;
		private var rootRadius:Number = 1;
		
		
		
		
		public function CoreGeoMetric() 
		{
			//touchObjectID = _id;
			//init();
		}
		
		public function init():void
		{
			//trace("init cluster geometric ");
			
			gs = GestureGlobals.gw_public::core; // need to find center of object for orientation and pivot
			touchArray = GestureGlobals.gw_public::touchArray;
			motionArray = GestureGlobals.gw_public::motionArray;
			sensorArray = GestureGlobals.gw_public::sensorArray;
			handList = GestureGlobals.gw_public::handList;
			
			iPointClusterLists = GestureGlobals.gw_public::iPointClusterLists;
			
			sw = GestureWorks.application.stageWidth
			sh = GestureWorks.application.stageHeight;
			sd = sh;
			//if (ts.traceDebugMode) 
			
			//trace("CoreGeoMetric:res",sw,sh,sd);
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
							tip.size = tp.size;
							//tip.pressure = tp.pressure;
							tip.age = tp.age;
							tip.mode = "touch";
							tip.source = "native";
							tip.type = "finger"; 
							//tip.motion = "dynamic"
								
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
		public function createHands():void 
		{
			
			if (motionArray) gs.mpn = motionArray.length;
			else gs.mpn = 0;
			
			if (handList) gs.hn = handList.length;
			else gs.hn = 0;
			
			
			//trace("hand num,ber",gs.hn);
			if (gs.hn <= 2)
			{
				//trace("create hand, palm",handList.length,motionArray.length);
				for (i = 0; i < gs.mpn; i++)//mpn
					{
					///	updateHand palm
					if (handList.length ==1)
					{
					if ((motionArray[i].type == "palm")&&(handList[0].handID != motionArray[i].handID))
						{
						//CREATE HAND OBJECT
						var hand:HandObject = new HandObject();	
							hand.motionPointID = motionArray[i].motionPointID //palmID
							//hand.position = motionArray[i].position //palmID
							//hand.direction = motionArray[i].direction
							//hand.normal = motionArray[i].normal
							hand.handID = motionArray[i].handID;
							hand.palm = motionArray[i]; // link palm point
							hand.orientation = hand.palm.orientation
							hand.type = hand.palm.handside;
							hand.radius = hand.palm.radius;
							hand.deviceType = hand.deviceType;
							
						if (!handList) handList = new Vector.<HandObject>
						handList.push(hand);
						//trace("create second hand",j,handList[j].palm.position )
						}
					
						
					}
					else {
						if (motionArray[i].type == "palm")
						{
						//CREATE HAND OBJECT
						var hand:HandObject = new HandObject();	
							hand.motionPointID = motionArray[i].motionPointID //palmID
							//hand.position = motionArray[i].position //palmID
							//hand.direction = motionArray[i].direction
							//hand.normal = motionArray[i].normal
							hand.handID = motionArray[i].handID;
							hand.palm = motionArray[i]; // link palm point
							hand.orientation = hand.palm.orientation
							hand.type = hand.palm.handside;
							hand.radius = hand.palm.radius;
							hand.deviceType = motionArray[i].deviceType;
							
						if (!handList) handList = new Vector.<HandObject>
						handList.push(hand);
						
						//trace("create first hand",j,handList[j].palm.position )
						}
					}
					}
					///////////////////////////////////////////////////////////////////////////////////////////////////////////
				}
					
					
					
				//	link finger motion points 
				for (j = 0; j < gs.hn; j++)//handList.length
				{				
					if	(handList[j].fingerList.length < 5) 
					{
						for (i = 0; i < gs.mpn; i++)//mpn
						{							
								if ((handList[j].handID == motionArray[i].handID)&&(motionArray[i].type == "finger"))
								{
								//trace("create hand, fingers");
								if (motionArray[i].fingertype == "thumb")handList[j].thumb = motionArray[i];
								if (motionArray[i].fingertype == "index") handList[j].index = motionArray[i];
								if (motionArray[i].fingertype == "middle") handList[j].middle = motionArray[i];
								if (motionArray[i].fingertype == "ring") handList[j].ring = motionArray[i];
								if (motionArray[i].fingertype == "pinky") handList[j].pinky = motionArray[i];
								
								handList[j].fingerList.push(motionArray[i]);
								}
						}
						//trace("assign finger points in hand",j,handList[j].palm.position )
					}
					
				}
				
		}
		
		
/*
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
		
		}*/
		
		
		
		public function getProjectedPoints():void {
			
			for (i = 0; i < handList.length; i++)
					{
					var ppt = handList[i].palm;	
					
					for (j = 0; j < handList[i].fingerList.length; j++)//mpn
						{
							
							var fpt = handList[i].fingerList[j];
						
							//GET PALM PLANE POINT PROJECTION
							var f_pos:Vector3D = fpt.position;
							var p_pos:Vector3D = ppt.position;
							var vp_mp:Vector3D = f_pos.subtract(p_pos);
							var normal:Vector3D = ppt.normal;
							var dist1:Number = (vp_mp.x * normal.x) + (vp_mp.y * normal.y) + (vp_mp.z * normal.z);
							var palm_plane_point:Vector3D = new Vector3D((f_pos.x - dist1 * normal.x), (f_pos.y -dist1 * normal.y), (f_pos.z - dist1 * normal.z));
									
							fpt.palmplane_position = palm_plane_point;
							//trace("projected point in palm plane",palm_plane_point);
						}
					}
			}
		
		
		public function findInteractionPointsExplicit():void
		{
			//trace("finding Splay points, geometric explicit");
			
			var k = 40;
			
			
	
			var palm:MotionPointObject;
			var hn:int = handList.length
			
			//tip palm distances
			var thumbdist:Number = 0;
			var indexdist:Number = 0; 
			var middledist:Number = 0;
			var ringdist:Number = 0;
			var pinkydist:Number = 0;
			
			//finger tip separation
			var thumbindexdist:Number = 0;
			var thumbmiddledist:Number = 0;
			var indexmiddledist:Number = 0;
			var middleringdist:Number = 0;
			var ringpinkydist:Number = 0;
			var indexpinkydist:Number = 0;
			
			var splayradius:Number = rootRadius*1.53// 80//rootRadius;//70;
			var fistradius:Number = rootRadius*0.77//40//rootRadius * //0.67;//50;
			var triggerradius:Number = rootRadius//50//rootRadius *// 0.67;//50;
			var pinchradius:Number = rootRadius*0.58//30//rootRadius * //0.40;//30;
			var splayfdist:Number = rootRadius*0.21//11//rootRadius * //0.15;// 11;
			
			
			//var zangle:Number; // simple absolute pitch calculation based on hand normal
			//var kangle:Number; // factor that scale for in verse pitch
			//var zaxis:Vector3D = new Vector3D(0, 0, 1);
			//var palmNormalXZProjection:Vector3D; 
			
			var projecttoplane:Boolean = true;
			
			//trace("hand length",hn );
			for (var j:int = 0; j < hn; j++)
				{	
					
				palm = handList[j].palm;
				
				//zangle = Vector3D.angleBetween(palm.normal, zaxis);
				//kangle = 0.2*((Math.PI * 0.5) - zangle);	
				
				if (projecttoplane)
				{
				
				thumbdist =  Vector3D.distance(palm.position, handList[j].thumb.palmplane_position);
				indexdist =  Vector3D.distance(palm.position, handList[j].index.palmplane_position);
				middledist =  Vector3D.distance(palm.position, handList[j].middle.palmplane_position);
				ringdist =  Vector3D.distance(palm.position, handList[j].ring.palmplane_position);
				pinkydist =  Vector3D.distance(palm.position, handList[j].pinky.palmplane_position);
				
				thumbindexdist = Vector3D.distance(handList[j].index.palmplane_position, handList[j].thumb.palmplane_position);
				thumbmiddledist = Vector3D.distance(handList[j].middle.palmplane_position, handList[j].thumb.palmplane_position);
				indexmiddledist = Vector3D.distance(handList[j].index.palmplane_position, handList[j].middle.palmplane_position);
				middleringdist = Vector3D.distance(handList[j].middle.palmplane_position, handList[j].ring.palmplane_position);
				ringpinkydist = Vector3D.distance(handList[j].ring.palmplane_position, handList[j].pinky.palmplane_position);
				indexpinkydist = Vector3D.distance(handList[j].index.palmplane_position, handList[j].pinky.palmplane_position);
				}
				else{
				
				thumbdist =  Vector3D.distance(palm.position, handList[j].thumb.position);
				indexdist =  Vector3D.distance(palm.position, handList[j].index.position);
				middledist =  Vector3D.distance(palm.position, handList[j].middle.position);
				ringdist =  Vector3D.distance(palm.position, handList[j].ring.position);
				pinkydist =  Vector3D.distance(palm.position, handList[j].pinky.position);
				
				thumbindexdist = Vector3D.distance(handList[j].index.position, handList[j].thumb.position);
				thumbmiddledist = Vector3D.distance(handList[j].middle.position, handList[j].thumb.position);
				indexmiddledist = Vector3D.distance(handList[j].index.position, handList[j].middle.position);
				middleringdist = Vector3D.distance(handList[j].middle.position, handList[j].ring.position);
				ringpinkydist = Vector3D.distance(handList[j].ring.position, handList[j].pinky.position);
				
				}
				
				if ((handList[j].palm.position.x!=0)&&(handList[j].ring.position.x != 0) && (handList[j].middle.position.x != 0) && (handList[j].ring.position.x != 0))
				{
					// find max lengths
					if (indexdist > maxindex) maxindex = indexdist;
					if (middledist > maxmiddle) maxmiddle = middledist;
					if (ringdist > maxring) maxring = ringdist;
					if (pinkydist > maxpinky) maxpinky = pinkydist;
					
					maxpfav = (maxindex + maxmiddle + maxring + maxpinky) * 0.2;
					rootRadius = maxpfav * 0.6;   //realsesne 75// 79 projected
												  //leap 50//52 projected
					
				}
				else trace("not ready for fav")
				
				
			
				trace("finger dist:", thumbdist, indexdist, middledist, ringdist, pinkydist,handList[j].deviceType, rootRadius, thumbindexdist);
				//trace("finger sep dista", thumbindexdist, indexmiddledist, middleringdist, ringpinkydist);
				//trace("palm pos:",handList[j].palm.position,"finger pos:",handList[j].index.position,handList[j].middle.position,handList[j].ring.position);
				//trace("zangle:", zangle, kangle);
			//	trace("finger dist:", thumbdist, indexdist, thumbindexdist );
				
				
				//trace("max finger dist:", maxindex, maxmiddle, maxring, maxpinky);
				//trace("maxpfav:", maxpfav, "rootRadius", rootRadius);
				
				//trace("scaled finger dist:", zangle * thumbdist, zangle * indexdist, zangle * middledist, zangle * ringdist, zangle * pinkydist);
				//trace("scaled finger dist:", kangle*thumbdist, kangle*indexdist, kangle*middledist, kangle*ringdist, kangle*pinkydist);
				
				//handList[i].
				
				if (handList[j].deviceType == "LeapMotion")
				{
				splayradius = rootRadius*1.53// 80////70;
				fistradius = rootRadius*0.77//40/ //0.67;//50;
				triggerradius = rootRadius//50//// 0.67;//50;
				pinchradius = rootRadius*0.58//30// //0.40;//30;
				splayfdist = rootRadius*0.21//11/ //0.15;// 11;
				
				if(rootRadius!=0){
				
					
					if ((thumbindexdist <= pinchradius)&&(middledist>fistradius)&&(ringdist>fistradius)&&(pinkydist>fistradius))//&&(thumbdist>fistradius-10)&&(indexdist>fistradius)
					{	
						handList[j].IPState = "pinch";
						handList[j].IPPosition = palm.position;
						handList[j].IPScreenPosition = palm.screen_position;
					}
					
					else if ((thumbindexdist >= triggerradius)&&(thumbdist>triggerradius)&&(indexdist>fistradius)&&(middledist<fistradius)&&(ringdist<fistradius)&&(pinkydist<fistradius))
					{	
						handList[j].IPState = "trigger";
						handList[j].IPPosition = palm.position;
						handList[j].IPScreenPosition = palm.screen_position;
					}
					
					else if ((indexdist>splayradius)&&(middledist>splayradius)&&(ringdist>splayradius)&&(pinkydist>splayradius))
					{	
						if ((thumbindexdist > 4 * splayfdist) && (indexmiddledist > splayfdist) && (middleringdist > splayfdist) && (ringpinkydist > 2 * splayfdist))
						{
						handList[j].IPState = "splay";
						handList[j].IPPosition = palm.position;
						handList[j].IPScreenPosition = palm.screen_position;
						}
					}

					else if ((thumbdist < fistradius)&&(indexdist<fistradius)&&(middledist<fistradius)&&(ringdist<fistradius)&&(pinkydist<fistradius))
					{	
						handList[j].IPState = "fist";
						handList[j].IPPosition = palm.position;
						handList[j].IPScreenPosition = palm.screen_position;
					}
					
					
					
					
					else if ((thumbdist < fistradius)&&(indexdist>splayradius)&&(middledist>splayradius)&&(ringdist<fistradius)&&(pinkydist<fistradius))
					{	
						if (indexmiddledist > splayfdist)
						{
						handList[j].IPState = "peace";
						handList[j].IPPosition = palm.position;
						handList[j].IPScreenPosition = palm.screen_position;
						}
					}
					
					else if ((thumbdist > splayradius)&&(indexdist>splayradius)&&(middledist<fistradius)&&(ringdist<fistradius)&&(pinkydist>splayradius))
					{	
						if (indexpinkydist > 3*splayfdist)
						{
						handList[j].IPState = "love";
						handList[j].IPPosition = palm.position;
						handList[j].IPScreenPosition = palm.screen_position;
						}
					}
					
					else if ((thumbdist < fistradius)&&(indexdist>splayradius)&&(middledist<fistradius)&&(ringdist<fistradius)&&(pinkydist<fistradius))
					{	
						handList[j].IPState = "point";
						handList[j].IPPosition = palm.position;
						handList[j].IPScreenPosition = palm.screen_position;
					}
					
					else if ((thumbdist > splayradius)&&(indexdist<fistradius)&&(middledist<fistradius)&&(ringdist<fistradius)&&(pinkydist<fistradius))
					{	
						handList[j].IPState = "thumb";
						handList[j].IPPosition = palm.position;
						handList[j].IPScreenPosition = palm.screen_position;
					}
					
					else{
					handList[j].IPState = "none";
					handList[j].IPPosition = palm.position;
					handList[j].IPScreenPosition = palm.screen_position;
					}
					
					//trace("ip state",handList[j].IPState , rootRadius)
				}
				}
				
				else if (handList[j].deviceType == "RealSense")
				{
				splayradius = rootRadius*1.4//110//
				fistradius = rootRadius*1.14//90//
				triggerradius = rootRadius*0.63//50//
				pinchradius = rootRadius*0.51//40//
				splayfdist =  rootRadius*0.31//25//
				
				
				if(rootRadius!=0){
				
					
					if (((thumbindexdist <= pinchradius)||(thumbmiddledist <= pinchradius*1.1))&&(middledist>fistradius)&&(ringdist>fistradius)&&(pinkydist>fistradius))//&&(thumbdist>fistradius-10)&&(indexdist>fistradius)
					{	
						handList[j].IPState = "pinch";
						handList[j].IPPosition = palm.position;
						handList[j].IPScreenPosition = palm.screen_position;
					}
					
					else if ((thumbindexdist >= triggerradius)&&(thumbdist>triggerradius)&&(indexdist>fistradius)&&(middledist<fistradius)&&(ringdist<fistradius)&&(pinkydist<fistradius))
					{	
						handList[j].IPState = "trigger";
						handList[j].IPPosition = palm.position;
						handList[j].IPScreenPosition = palm.screen_position;
					}
					
					else if ((indexdist>splayradius)&&(middledist>splayradius)&&(ringdist>splayradius)&&(pinkydist>splayradius))
					{	
						if ((thumbindexdist > 2 * splayfdist) && (thumbmiddledist > 2 * splayfdist) &&(indexmiddledist > splayfdist) && (middleringdist > splayfdist) && (ringpinkydist >  splayfdist))
						{
						handList[j].IPState = "splay";
						handList[j].IPPosition = palm.position;
						handList[j].IPScreenPosition = palm.screen_position;
						}
					}

					else if ((thumbdist < fistradius)&&(indexdist < fistradius)&&(middledist < fistradius)&&(ringdist < fistradius)&&(pinkydist < fistradius))
					{	
						handList[j].IPState = "fist";
						handList[j].IPPosition = palm.position;
						handList[j].IPScreenPosition = palm.screen_position;
					}
					
					
					
					/*
					else if ((thumbdist < fistradius)&&(indexdist>splayradius)&&(middledist>splayradius)&&(ringdist<fistradius)&&(pinkydist<fistradius))
					{	
						if (indexmiddledist > splayfdist)
						{
						handList[j].IPState = "peace";
						handList[j].IPPosition = palm.position;
						handList[j].IPScreenPosition = palm.screen_position;
						}
					}
					
					else if ((thumbdist > splayradius)&&(indexdist>splayradius)&&(middledist<fistradius)&&(ringdist<fistradius)&&(pinkydist>splayradius))
					{	
						if (indexpinkydist > 3*splayfdist)
						{
						handList[j].IPState = "love";
						handList[j].IPPosition = palm.position;
						handList[j].IPScreenPosition = palm.screen_position;
						}
					}
					
					else if ((thumbdist < fistradius)&&(indexdist>splayradius)&&(middledist<fistradius)&&(ringdist<fistradius)&&(pinkydist<fistradius))
					{	
						handList[j].IPState = "point";
						handList[j].IPPosition = palm.position;
						handList[j].IPScreenPosition = palm.screen_position;
					}
					
					else if ((thumbdist > splayradius)&&(indexdist<fistradius)&&(middledist<fistradius)&&(ringdist<fistradius)&&(pinkydist<fistradius))
					{	
						handList[j].IPState = "thumb";
						handList[j].IPPosition = palm.position;
						handList[j].IPScreenPosition = palm.screen_position;
					}
					*/
					else{
					handList[j].IPState = "none";
					handList[j].IPPosition = palm.position;
					handList[j].IPScreenPosition = palm.screen_position;
					}
					
					trace("ip state",handList[j].IPState , rootRadius)
				}
				}
				
				
			}
		}
		/*
		public function find3DPinchPointsExplicit():void
		{
			//trace("finding pinch points, geometric explicit");
			
			var pinchThreshold:Number = 20//60; //GML CONFIG 
			var dist:Number;
			var radius:Number = 50;
			var palm:MotionPointObject;
			var hn:int = handList.length
				
			//trace("hand length",hn );
				
			for (var j:int = 0; j < hn; j++)
				{	
				dist = Vector3D.distance(handList[j].index.position, handList[j].thumb.position);
				
				var thumbdist:Number = Vector3D.distance(handList[j].palm.position, handList[j].thumb.position);
				var indexdist:Number = Vector3D.distance(handList[j].palm.position, handList[j].index.position);
				var middledist:Number = Vector3D.distance(handList[j].palm.position, handList[j].middle.position);
				var ringdist:Number = Vector3D.distance(handList[j].palm.position, handList[j].ring.position);
				var pinkydist:Number = Vector3D.distance(handList[j].palm.position, handList[j].pinky.position);
				
				//trace("pinch dist",dist,thumbdist,indexdist,middledist,ringdist,pinkydist );

				// find midpoint between fingertips
					if ((dist <= pinchThreshold)&&(middledist>radius)&&(ringdist>radius)&&(pinkydist>radius))
					{	
						//trace("pinch point",dist)
						var pmp:InteractionPointObject = new InteractionPointObject();
						
							pmp.position = handList[j].thumb.position;
							pmp.screen_position = handList[j].thumb.screen_position;
							pmp.handID = handList[j].handID;
							pmp.type = "pinch";
							pmp.mode = "motion";
							pmp.source = "native" // so that interaction point tracker works
															
						//add to pinch point list
						InteractionPointTracker.framePoints.push(pmp)
						//trace("2 pinch push", best_dist)	
					}
				
				}
		}
		
		
		public function find3DTriggerPointsExplicit():void
		{
			//trace("finding pinch points, geometric explicit");
			
			var triggerThreshold:Number = 50//60; //GML CONFIG 
			var radius:Number = 50;
			var dist:Number;
			var palm:MotionPointObject;
			var hn:int = handList.length
				
			//trace("hand length",hn );
				
			for (var j:int = 0; j < hn; j++)
				{	
				dist = Vector3D.distance(handList[j].index.position, handList[j].thumb.position);
				
				var thumbdist:Number = Vector3D.distance(handList[j].palm.position, handList[j].thumb.position);
				var indexdist:Number = Vector3D.distance(handList[j].palm.position, handList[j].index.position);
				var middledist:Number = Vector3D.distance(handList[j].palm.position, handList[j].middle.position);
				var ringdist:Number = Vector3D.distance(handList[j].palm.position, handList[j].ring.position);
				var pinkydist:Number = Vector3D.distance(handList[j].palm.position, handList[j].pinky.position);
				
				//trace("trigger dist",dist,indexdist,middledist, ringdist,pinkydist);
				// find midpoint between fingertips
					if ((dist >= triggerThreshold)&&(middledist<radius)&&(ringdist<radius)&&(pinkydist<radius))
					{	
						//trace("pinch point",dist)
						var pmp:InteractionPointObject = new InteractionPointObject();
						
							pmp.position = handList[j].index.position;
							pmp.screen_position = handList[j].index.screen_position;
							pmp.handID = handList[j].handID;
							pmp.type = "trigger";
							pmp.mode = "motion";
							pmp.source = "native" // so that interaction point tracker works
															
						//add to pinch point list
						InteractionPointTracker.framePoints.push(pmp)
						//trace("2 pinch push", best_dist)	
					}
				
				}
		}
		
		public function find3DFistPointsExplicit():void
		{
			//trace("finding fist points, geometric explicit");
			var radius:Number = 55;
			var palm:MotionPointObject;
			var hn:int = handList.length
				
			//trace("hand length",hn );
				
			for (var j:int = 0; j < hn; j++)
				{	
				var thumbdist:Number = Vector3D.distance(handList[j].palm.position, handList[j].thumb.position);
				var indexdist:Number = Vector3D.distance(handList[j].palm.position, handList[j].index.position);
				var middledist:Number = Vector3D.distance(handList[j].palm.position, handList[j].middle.position);
				var ringdist:Number = Vector3D.distance(handList[j].palm.position, handList[j].ring.position);
				var pinkydist:Number = Vector3D.distance(handList[j].palm.position, handList[j].pinky.position);
				
				trace("fist dist",thumbdist,indexdist,middledist, ringdist,pinkydist);
				// find midpoint between fingertips
					if ((indexdist<radius+10)&&(middledist<radius)&&(ringdist<radius)&&(pinkydist<radius))
					{	
						//trace("pinch point",dist)
						var pmp:InteractionPointObject = new InteractionPointObject();
						
							pmp.position = handList[j].palm.position;
							pmp.screen_position = handList[j].palm.screen_position;
							pmp.handID = handList[j].handID;
							pmp.type = "fist";
							pmp.mode = "motion";
							pmp.source = "native" // so that interaction point tracker works
															
						//add to pinch point list
						InteractionPointTracker.framePoints.push(pmp)
						//trace("2 pinch push", best_dist)	
					}
				
				}
		}
		
		public function find3DSplayPointsExplicit():void
		{
			//trace("finding Splay points, geometric explicit");
			var radius:Number = 65;
			var palm:MotionPointObject;
			var hn:int = handList.length
				
			//trace("hand length",hn );
				
			for (var j:int = 0; j < hn; j++)
				{	
				var thumbdist:Number = Vector3D.distance(handList[j].palm.position, handList[j].thumb.position);
				var indexdist:Number = Vector3D.distance(handList[j].palm.position, handList[j].index.position);
				var middledist:Number = Vector3D.distance(handList[j].palm.position, handList[j].middle.position);
				var ringdist:Number = Vector3D.distance(handList[j].palm.position, handList[j].ring.position);
				var pinkydist:Number = Vector3D.distance(handList[j].palm.position, handList[j].pinky.position);
				
				trace("splay dist",thumbdist,indexdist,middledist, ringdist,pinkydist);
				// find midpoint between fingertips
					if ((indexdist>radius)&&(middledist>radius)&&(ringdist>radius)&&(pinkydist>radius))
					{	
						//trace("pinch point",dist)
						var pmp:InteractionPointObject = new InteractionPointObject();
						
							pmp.position = handList[j].palm.position;
							pmp.screen_position = handList[j].palm.screen_position;
							pmp.handID = handList[j].handID;
							pmp.type = "splay";
							pmp.mode = "motion";
							pmp.source = "native" // so that interaction point tracker works
															
						//add to pinch point list
						InteractionPointTracker.framePoints.push(pmp)
						//trace("2 pinch push", best_dist)	
					}
				
				}
		}*/
		/*
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
			
		}*/
		/*
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
							
							trace("fist: geometric",palm_pt.position, palm_pt.fist, handList[j].orientation, handList[j].flatness, handList[j].splay, handList[j].type);
							
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
		}*/
		
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