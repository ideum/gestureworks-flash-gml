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
			sd = sh;
			//if (ts.traceDebugMode) 
			
			trace("CoreGeoMetric:res",sw,sh,sd);
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
			
			if (gs.hn < 2)
				{
				for (i = 0; i < gs.mpn; i++)//mpn
					{
					///	updateHand palm
					if (motionArray[i].type == "palm") 
						{
						//CREATE HAND OBJECT
						var hand:HandObject = new HandObject();	
							hand.motionPointID = motionArray[i].motionPointID //palmID
							hand.position = motionArray[i].position //palmID
							hand.direction = motionArray[i].direction
							hand.normal = motionArray[i].normal
							hand.handID = motionArray[i].handID;
							hand.palm = motionArray[i]; // link palm point
							hand.orientation = hand.palm.orientation
							hand.type = hand.palm.handside;
							hand.radius = hand.palm.sphereRadius;
							
						if (!handList) handList = new Vector.<HandObject>
						handList.push(hand);
						}
					}
				}
							
								
					//	link finger motion points 
					for (j = 0; j < gs.hn; j++)//handList.length
					{								
						for (i = 0; i < gs.mpn; i++)//mpn
						{							
								if (handList[j].handID == motionArray[i].handID)
								{
								if (motionArray[i].fingertype == "thumb") handList[j].thumb = motionArray[i];
								if (motionArray[i].fingertype == "index") handList[j].index = motionArray[i];
								if (motionArray[i].fingertype == "middle") handList[j].middle = motionArray[i];
								if (motionArray[i].fingertype == "ring") handList[j].ring = motionArray[i];
								if (motionArray[i].fingertype == "pinky") handList[j].pinky = motionArray[i];
								
								handList[j].fingerList.push(motionArray[i]);
								}
						}	
					}
				
		}
		
		/*
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
							
							
							if (hfn == 0) {
								fav_pt = handList[j].palm.position;
								pfav_pt = handList[j].palm.position;
							}
							
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
		}*/

		/*
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
		}*/
		
		/*
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
			
			//trace("coregeometric:palm,",hn,j,p_pos, direction)
			
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
							
							//fpt.palmplaneline_position = palm_plane_line_point
							
				
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
		*/
		
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
		}
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