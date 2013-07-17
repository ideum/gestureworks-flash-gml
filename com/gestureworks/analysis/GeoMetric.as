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
	import com.gestureworks.core.GestureGlobals;
	import com.gestureworks.core.gw_public;
	import com.gestureworks.objects.HandObject;
	import com.gestureworks.objects.PointObject;
	import com.gestureworks.objects.MotionPointObject;
	import com.gestureworks.objects.InteractionPointObject;
	import com.gestureworks.objects.ClusterObject;
	import com.gestureworks.objects.PointPairObject;
	import com.gestureworks.managers.PointPairHistories;
	import com.gestureworks.managers.InteractionPointTracker;
	
	import flash.geom.Vector3D;
	import flash.geom.Utils3D;
	import flash.geom.Point;
		
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
		
		public var pointPairList:Vector.<PointPairObject>;// should operate directly on cluster
		
		// number in group
		public var N:uint = 0;
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
		
		//////////////////////////////
		// derived interaction point totals
		private var ipn:uint = 0;
		
		public function GeoMetric(_id:int) 
		{
			touchObjectID = _id;
			init();
		}
		
		public function init():void
		{
			ts = GestureGlobals.gw_public::touchObjects[touchObjectID]; // need to find center of object for orientation and pivot
			cO = ts.cO;
		
			if (ts.trace_debug_mode) trace("init cluster geometric");
		}
		
		public function findGeoConstants():void
		{
				//if (ts.trace_debug_mode) trace("find cluster..............................",N);
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
					if (fn1 == 0) fk0 = 0;
					//motionList = cO.motionArray;
					//mc = pointList[0].moveCount;
				}
				
				/////////////////////////////////////////
				// get derived interaction points in cluster
				ipn = ts.cO.ipn;
				
				if (ipn) {
					// do something
				}	
		}
		
		public function resetGeoCluster():void
		{
			//////////////////////////////////////
			// SUBCLUSTER STRUCTURE
			// CAN BE USED FOR BI-MANUAL GESTURES
			// CAN BE USED FOR CONCURRENT GESTURE PAIRS
			/////////////////////////////////////
			//clear interactive point list
			//cO.iPointArray = new Vector.<Object>();
		}

		///////////////////////////////////////////////////////////////////////////////////
		///////////////////////////////////////////////////////////////////////////////////
		///////////////////////////////////////////////////////////////////////////////////
		// 3d config analysis
		///////////////////////////////////////////////////////////////////////////////////
		///////////////////////////////////////////////////////////////////////////////////
		///////////////////////////////////////////////////////////////////////////////////
		
		// clear derived point and cluster motion data
		public function clearMotionPointData():void
		{
			for (i = 0; i < fn; i++)
				{	
					if (cO.motionArray[i].type == "finger")
					{	
						// reset thum alloc// move to cluster
						cO.motionArray[i].fingertype = "finger";	 
						
						// reset thumb probs // move to cluster
						cO.motionArray[i].thumb_prob = 0;
						cO.motionArray[i].mean_thumb_prob = 0
						// normalized data
						cO.motionArray[i].normalized_length = 0;
						cO.motionArray[i].normalized_palmAngle = 0;
						cO.motionArray[i].normalized_favdist = 0;
					}
					
					if (cO.motionArray[i].type == "palm")
					{	
						// reset thum alloc// move to cluster
						cO.motionArray[i].fingertype = null;	 
						
						// reset thumb probs // move to cluster
						cO.motionArray[i].thumb_prob = 0;
						cO.motionArray[i].mean_thumb_prob = 0
						// normalized data
						cO.motionArray[i].normalized_length = 0;
						cO.motionArray[i].normalized_palmAngle = 0;
						cO.motionArray[i].normalized_favdist = 0;
					}
				}
				
				// reset hands
				cO.handList.length = 0;
		}
		
		
		// get noamlized finger length and palm angle
		// PALM IP
		// FAV IP
		// PURE FAV IP
	
		public function createHand():void 
		{
			//trace("create hand")
			if (fn !=0) // no points no hand
			{
				for (i = 0; i < fn; i++)
					{
					//////////////////////////////////////////////////////
					/// create hand
						if (cO.motionArray[i].type == "palm") 
						{
						var hand:HandObject = new HandObject();	
							hand.position = cO.motionArray[i].position //palmID
							hand.direction = cO.motionArray[i].direction
							hand.normal = cO.motionArray[i].normal
							hand.handID = cO.motionArray[i].handID;
							hand.palm = cO.motionArray[i]; // link palm point
		
								
								var palm_pt:InteractionPointObject = new InteractionPointObject();
									//palm_pt.position = cO.hand.position;
									
									palm_pt.position = cO.motionArray[i].position;
									palm_pt.direction = cO.motionArray[i].direction;
									palm_pt.normal = cO.motionArray[i].normal;
									palm_pt.handID = cO.motionArray[i].handID;
									palm_pt.type = "palm";

								//InteractionPointTracker.framePoints.push(palm_pt)
								//trace("push plam point");
								
								cO.handList.push(hand);
								//trace("p",cO.motionArray[i].handID)
						}
					}

					hn = cO.handList.length;
					///////////////////////////////////////////////
					// PUSH FINGERS
					for (j = 0; j < hn; j++)
					{
						for (i = 0; i < fn; i++)
								{	
									//trace(cO.handList[j].handID ,cO.motionArray[i].handID)
									if ((cO.motionArray[i].type == "finger")&&(cO.handList[j].handID == cO.motionArray[i].handID))
									{
										// push fingers into 
										cO.handList[j].fingerList.push(cO.motionArray[i]);
									}
								}
					}
				
			}
		}
		
		
		public function findFingerAverage():void 
		{
				//////////////////////////////////////////////////////////////////////////////
				// GET FAV 
				for (j = 0; j < hn; j++)
				{
					var fav_pt:Vector3D = new Vector3D();
					var pfav_pt:Vector3D = new Vector3D();
					var hfn = cO.handList[j].fingerList.length;
					var hfnk = 0;
					
					if (hfn) hfnk = 1 / hfn;
					
					for (i = 0; i < hfn; i++)
							{	
									var fpt = cO.handList[j].fingerList[i];

									// finger average point (fingers + thumb)
									fav_pt.x += fpt.position.x;
									fav_pt.y += fpt.position.y;
									fav_pt.z += fpt.position.z;
	
									if (cO.motionArray[i].fingertype == "finger") // add other finger types
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
							
							
								// FAV POINT NEEDS DIRECTION AND NORMAL
								var fv_pt:InteractionPointObject = new InteractionPointObject();
									fv_pt.position = fav_pt;
									fv_pt.handID = cO.handList[j].handID;
									fv_pt.type = "finger_average";
									
								//cO.iPointArray.push(fv_pt);
								//InteractionPointTracker.framePoints.push(fv_pt)
						
								// push fav point to hand object
								cO.handList[j].fingerAveragePosition = fav_pt;
								cO.handList[j].pureFingerAveragePosition = pfav_pt;		
				}
				//trace("hand pos",cO.hand.position)
		}

		
		public function findHandRadius():void 
		{
			hn = cO.handList.length;
		
			for (j = 0; j < hn; j++)
				{
					//trace("number finger",fn,fnk,fav_pt.x,fav_pt.y,fav_pt.z)
					var favlength:Number = 100//100;
					var palmratio = 1.4;
							
					var hfn = cO.handList[j].fingerList.length;
					var hfnk = 0;
					if (hfn) hfnk = 1 / hfn;
					
						for (i = 0; i < hfn; i++)
								{
								cO.handList[j].fingerList[i].favdist = Vector3D.distance(cO.handList[j].fingerList[i].position, cO.handList[j].fingerAveragePosition);
								// find average max length
								favlength += cO.handList[j].fingerList[i].max_length; //??????
								//trace("favdist",cO.motionArray[i].favdist,cO.motionArray[i].fingertype, min_favdist, max_favdist )	
								}
					favlength = hfnk*favlength	
										
					cO.handList[j].sphereRadius = favlength * palmratio;	
					//trace("rad",cO.handList[j].sphereRadius)
				}
		}
		
		
		
		// get noamlized finger length and palm angle
		public function normalizeFingerSize():void 
		{
			var min_max_length:Number;
			var max_max_length:Number;
			var min_length:Number;
			var max_length:Number;
			//var min_width:Number
			//var max_width:Number
			var min_palmAngle:Number
			var max_palmAngle:Number
			var min_favdist:Number;
			var max_favdist:Number;
			
			
			for (j = 0; j < hn; j++)
			{
				
			min_max_length = 0;
			max_max_length = 0;
			min_length = 0;
			max_length = 0;
			// min_width
			// max_width
			min_palmAngle = 0
			max_palmAngle = 0
			min_favdist = 0;
			max_favdist = 0;
				
			var hfn = cO.handList[j].fingerList.length;
			var palm_mpoint:MotionPointObject = cO.handList[j].palm; // NEED TO SIMPLIFY		
			
			// get values
			for (i = 0; i < hfn; i++)
				{	
					var fpt = cO.handList[j].fingerList[i];
						
							var p_pos:Vector3D = palm_mpoint.position;
							var f_pos:Vector3D = fpt.position;
							var normal:Vector3D = palm_mpoint.normal;
							var vp_mp:Vector3D = f_pos.subtract(p_pos);

							var dist:Number = (vp_mp.x * normal.x) + (vp_mp.y * normal.y) + (vp_mp.z * normal.z);
							var palm_plane_point:Vector3D = new Vector3D((f_pos.x - dist * normal.x), (f_pos.y -dist*normal.y), (f_pos.z - dist*normal.z));
							
							fpt.palmplane_position = palm_plane_point
							//trace("projected point in palm plane",palm_plane_point)
				
							var ppp_dir:Vector3D = palm_plane_point.subtract(p_pos);
							
							// set palm angle of point
							fpt.palmAngle =  Vector3D.angleBetween(ppp_dir, palm_mpoint.direction);
							//palmAngle = Math.abs(Vector3D.angleBetween(cO.motionArray[i].direction, palm_mpoint.direction));

							// calc proper length
							fpt.length = Vector3D.distance(p_pos, f_pos);
							
							// FIND EXTENSION MEASURE
							var palm_finger_vector = fpt.position.subtract(palm_mpoint.position);
							var angle_diff = Vector3D.angleBetween(fpt.direction, palm_finger_vector);
							// normalize
							fpt.extension = normalize(angle_diff, 0, Math.PI*0.5);
				}
						
				
				for (i = 0; i < hfn; i++)
				{
					var fpt = cO.handList[j].fingerList[i];
					
						//max length max and min
						var value_max_length = fpt.max_length;
						if (value_max_length > max_max_length) max_max_length = value_max_length;
						if ((value_max_length < min_max_length)&&(value_max_length!=0)) min_max_length = value_max_length;
						
						// length max and min
						var value_length = fpt.length;
						if (value_length > max_length) max_length = value_length;
						if ((value_length < min_length)&&(value_length!=0)) min_length = value_length;
						
						// palm angle max and min
						var value_palm = fpt.palmAngle;
						if (value_palm > max_palmAngle) max_palmAngle = value_palm;
						if ((value_palm < min_palmAngle)&&(value_palm!=0)) min_palmAngle = value_palm;

						//finge raverage distance max and min
						var value = fpt.favdist;
						if (value > max_favdist) max_favdist = value;
						if ((value < min_favdist)&&(value!=0)) min_favdist = value;
				}
			
				//normalized values and update
				for (i = 0; i < hfn; i++)
					{
						var fpt = cO.handList[j].fingerList[i];
						
						fpt.normalized_max_length = normalize(fpt.max_length, min_max_length, max_max_length);
						fpt.normalized_length = normalize(fpt.length, min_length, max_length);
						//cO.motionArray[i].normalized_width = normalize(cO.motionArray[i].width, min_width, max_width);
						fpt.normalized_palmAngle = normalize(fpt.palmAngle, min_palmAngle, max_palmAngle);
						fpt.normalized_favdist = normalize(fpt.favdist, min_favdist, max_favdist);
					}
			}
		}
		
		
		
		// find thumb .. generate pair data
		//.. should save data to cluster table for rot and scale paired operations
		public function findThumb():void
		{
		
		for (j = 0; j < hn; j++)
				{
	
			cO.handList[j].pair_table = new Array();
			
			var hfn:int = cO.handList[j].fingerList.length;
			
			var fpt //= cO.handList[j].fingerList[i];
			var palm_mpoint

			// CALC PAIR VALUES FOR UNIQUE POINT PAIRS
			// COPY FROM ONE SIDE OF MATRIX TO THE OTHER TO HALVE CALCS
			//trace("---------------");
			
			// use max length values instaed of current values
			// will reduce thumb shift upon extension
			// or simply require min extension before using real time length
			
			if (hfn == 2) 
			{
				palm_mpoint = cO.handList[j].palm
				
				for (i = 0; i < 2; i++)
				{
					fpt = cO.handList[j].fingerList[i];
					
					// reset thum alloc
					fpt.fingertype = "finger";
					fpt.thumb_prob = 0;
					fpt.mean_thumb_prob = 0
				}
				
				
					if (palm_mpoint)
					{
						var fpt0 = cO.handList[j].fingerList[0];
						var fpt1 = cO.handList[j].fingerList[1];
						
						
						// set prob
						// fav dist is equal (so not usefull)
						// palm angle is equal (so not usefull)
						fpt0.thumb_prob = (1 - fpt0.normalized_length) ;
						fpt1.thumb_prob = (1 - fpt1.normalized_length);
						
						// set thumb
						if (fpt1.thumb_prob > fpt0.thumb_prob)  fpt1.fingertype = "thumb";	
						else fpt0.fingertype = "finger";
						
						// stuff table for later (pinch, trigger)
						var pair_array:Array = new Array();
						var dist:Number = Vector3D.distance(fpt0.position, fpt1.position);
						
							var pair_data:Array = new Array()
								pair_data.pointID = fpt0.motionPointID; // ROOT POINT ID
								pair_data.pair_pointID = fpt1.motionPointID; // PAIRED POINT ID
								pair_data.distance = dist;	//DISTANCE BETWEEEN PAIRS
								pair_data.max_distance = 0;
								pair_data.min_distance = 0;
								pair_data.normalized_distance = 0;
								pair_data.pair_prob = 0;
							pair_array.push(pair_data);
							
						cO.handList[j].pair_table.push(pair_array);
				}	
			}
			
			if (hfn > 2)
			{
				palm_mpoint = cO.handList[j].palm
				
					for (i = 0; i < hfn; i++)
							{	
							fpt0 = cO.handList[j].fingerList[i]
									
									var pair_array:Array = new Array();
											
									if(palm_mpoint)
											{
											// find all 20 //unique pairs (10 for 5 points) 
											for (var q:int = 0; q < hfn; q++) //i+1
												{
													if (i != q)
													{
													var fpt1 = cO.handList[j].fingerList[q];
														
														//find separation dist for each pair	
														var dist:Number = Vector3D.distance(fpt0.position, fpt1.position);
														
														var pair_data:Array = new Array()
															pair_data.pointID = fpt0.motionPointID; // ROOT POINT ID
															pair_data.pair_pointID = fpt1.motionPointID; // PAIRED POINT ID
															pair_data.distance = dist;	//DISTANCE BETWEEEN PAIRS
				
															pair_data.max_distance = 0;
															pair_data.min_distance = 0;
															pair_data.normalized_distance = 0;
															
															pair_data.pair_prob = 0;
															//trace("finger pair", i,"list", q, pair_data,cO.motionArray[q].motionPointID,dist,dAngle)
													pair_array.push(pair_data);
													}
												}
												// push to motion point
												cO.handList[j].pair_table.push(pair_array);
											}
							}

						// SORT PAIR PROB ARRAYS
							// COPY COLUMN ELEMENTS INTO AN ARRAY
							// SORT ARRAY
							// GET MAX AND MIN DIST VALUES
							// CALC NORMALIZED VALUE (BETWEEN 0 AND 1)
							// PUSH RESULTS TO PAIR TABLE
	
						// get table size
						var tn:int = cO.handList[j].pair_table.length;
						for (i = 0; i < tn; i++)//hfn
									{		
										// create temp array
										var min_dist:Number = 0;
										var max_dist:Number = 0;
										var tnn:int = cO.handList[j].pair_table[i].length;
										
										/// copy data from table
											for (q = 0; q < tnn; q++)
												{	
													if (cO.handList[j].pair_table[i][q].distance != 0){
														var value_pair:Number = cO.handList[j].pair_table[i][q].distance
														if (value_pair > max_dist) max_dist = value_pair;
														if ((value_pair < min_dist) && (value_pair != 0)) min_dist = value_pair;
													}
												}	
	
										/// find normalized values
										/// write into table
										for (q = 0; q < tnn; q++)
										{
											cO.handList[j].pair_table[i][q].max_distance = max_dist;
											cO.handList[j].pair_table[i][q].min_distance = min_dist;
											//pair_table[i][q].normalized_distance = normalize(temp_column_arrayA[q], min_dist, max_dist);
											cO.handList[j].pair_table[i][q].normalized_distance = normalize(cO.handList[j].pair_table[i][q].distance, min_dist, max_dist);
											
											cO.handList[j].pair_table[i][q].pair_prob = 2 * (cO.handList[j].pair_table[i][q].normalized_distance)
											//pair_table[i][q].pair_prob = 2*(pair_table[i][q].normalized_distance)
											
											// accumulate based on paired sets on primary point in pair
											GestureGlobals.gw_public::motionPoints[cO.handList[j].pair_table[i][q].pointID].thumb_prob += cO.handList[j].pair_table[i][q].pair_prob//1;
										
											/*
											trace("");
											trace("ID", pair_table[i][q].pointID,"pairedID",pair_table[i][q].pair_pointID);
											trace("norm dist", pair_table[i][q].distance, min_dist, max_dist, pair_table[i][q].normalized_distance);
											trace("norm dang",  pair_table[i][q].directionAngle, min_dang, max_dang,  pair_table[i][q].normalized_directionAngle);
											trace("norm pang",  pair_table[i][q].positionAngle, min_pang, max_pang,  pair_table[i][q].normalized_positionAngle);
											trace("pair prob", pair_table[i][q].pair_prob);
											*/
											
											//trace("pair prob", cO.handList[j].pair_table[i][q].pair_prob);
											}							
								}
					}	


						///////////////////////////////////////////////////////////////////////////////////
						// MOD THUMB PROB WITH FINGER LENGTH AND WIDTH
						
							// get largest thumb prob
							var thumb_list:Array = new Array()
							
							for (i = 0; i < hfn; i++)
								{
									fpt = cO.handList[j].fingerList[i];
									
									//ALL
									fpt.thumb_prob += 2*(1- fpt.normalized_length)
									fpt.thumb_prob += 5*(fpt.normalized_favdist) //WORKS VERY WELL ON OWN
									fpt.thumb_prob += 2*(fpt.normalized_palmAngle)

									thumb_list[i] = fpt.thumb_prob;
								}	
							
						///////////////////////////////////////////////////////////////////////////////////
						// SET FINGER TO THUMB BASED ON HIGHEST PROB
						var max_tp:Number = Math.max.apply(null, thumb_list);
						var max_index:int = thumb_list.indexOf(max_tp);
						
						if ((max_index != -1) && ( cO.handList[j].fingerList[max_index]) && (cO.handList[j].fingerList[max_index].type == "finger")) 
						{
							cO.handList[j].fingerList[max_index].fingertype = "thumb";	
							
							// SET THUMB IN HAND OBJECT
							cO.handList[j].thumb = cO.handList[j].fingerList[max_index];
						}
						
						// note sorting point list at this pahse doesnt seem to have any issues??
						// probably because there are no transformations yet
						
						/*
						thumb_list.sortOn("thumb_prob",Array.DESCENDING);
						
						
						/// find min 
						if (thumb_list[fn - 1]) {
							//min_dist = thumb_list[n - 1]
							//trace("min", thumb_list[fn - 1].thumb_prob, thumb_list[fn - 1].motionPointID);
							if((thumb_list[fn-1].type == "finger")) thumb_list[fn-1].fingertype = "middle";
						}
						
						// find max
						if (thumb_list[1]) {
							//max_dist = thumb_list[0];
							//trace("pinky", thumb_list[0].thumb_prob, thumb_list[1].motionPointID);
							if((thumb_list[0].type == "finger")) thumb_list[1].fingertype = "pinky";
						}
						
						// find max
						if (thumb_list[0]) {
							//max_dist = thumb_list[0];
							//trace("max", thumb_list[0].thumb_prob, thumb_list[0].motionPointID);
							if((thumb_list[0].type == "finger")) thumb_list[0].fingertype = "thumb";
						}
						*/				
						
				}		
							
		}

		/////////////////////////////////////////////////////////////////////////////////////////////////////////////
		/////////////////////////////////////////////////////////////////////////////////////////////////////////////
		// Interactive Pinch Points 
		//PINCH IP
		public function find3DPinchPoints():void
		{
			var pinchThreshold:Number = 40; 
			var min_pprob:Number;
			//var max_pprob:Number;
			var best_pt1:MotionPointObject;
			var best_pt2:MotionPointObject;
			var palm:MotionPointObject;
			
				// FIND SMALLEST ANGLE DIFF TO PALM NORMAL && SMALLEST DIST BETWEEN
				// NEED POINT VELOCITY CHECK TO REMOVE BEDAXZZLE TRIGGER
					// CLOSEST TO PALM POINT -AMBIQUOUS
					// CLOSTEST TO FAV CREATES 2 FINGER ERROR
					// THUMB REQUOREMENT NEEDS FULL TESTING
				// PRESENT SINGLE PINCH POINT ALWAYS
			
			for (var j:int = 0; j < hn; j++)
				{	
					
				//////////////////////////////////////////////////////////////////////////////////////////////////////////////	
				min_pprob = 1000;
				//max_pprob = 0;
				best_pt1 = new MotionPointObject()
				best_pt2 = new MotionPointObject();
				palm = cO.handList[j].palm;
				
				// GET LOCAL LIST OF CLOSE FINGER TIPS
				var tn:int = cO.handList[j].pair_table.length;
				
				for (var i:int = 0; i < tn; i++)
					{
					var tnn:int = cO.handList[j].pair_table[i].length;
					
					for (var q:int = 0; q < tnn; q++)
					{
						var pinch_dist:Number = cO.handList[j].pair_table[i][q].distance;
						var pt1:MotionPointObject = GestureGlobals.gw_public::motionPoints[cO.handList[j].pair_table[i][q].pointID];
						var pt2:MotionPointObject = GestureGlobals.gw_public::motionPoints[cO.handList[j].pair_table[i][q].pair_pointID];
						var pinchPalmAngle:Number = Vector3D.angleBetween(pt1.direction, palm.normal);
						//var norm_angle = normalize(pinchPalmAngle, 0, Math.PI);
						var pinch_prob = 0;
						
						// requires smaller threshold when fn >2 
						if (tn == 1) pinch_prob = pinch_dist;
						else pinch_prob = pinch_dist * 3 * pinchPalmAngle;
						
						// TODO -NORMALIZE AND FIND SMALLEST VALUE
						// PRESET ONLY ONE PICH POINT
						if ((pinch_prob < min_pprob) && (pinch_prob != 0)) {
							min_pprob = pinch_prob;
							best_pt1 = pt1;
							best_pt2 = pt2;
							
							trace("ppa",pinchPalmAngle, "dist",pinch_dist, "prob",pinch_prob, min_pprob, pt1.position,pt2.position);
						}
					}
				}
				/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
				
				
				
				//trace("prob",min_pprob);

				// find midpoint between fingertips
					if ((best_pt1) && (best_pt2)&&(min_pprob < pinchThreshold)&& (min_pprob != 0))
					{	
						var pmp:InteractionPointObject = new InteractionPointObject();
							pmp.position.x = best_pt1.position.x - (best_pt1.position.x - best_pt2.position.x) * 0.5;
							pmp.position.y = best_pt1.position.y - (best_pt1.position.y - best_pt2.position.y) * 0.5;
							pmp.position.z = best_pt1.position.z - (best_pt1.position.z - best_pt2.position.z) * 0.5;
							//pmp.handID = cO.hand.handID;
							pmp.type = "pinch";
															
						//add to pinch point list
						InteractionPointTracker.framePoints.push(pmp)
						//trace("pinch push")
					}
					
					
				}
		}
		
		/*
		/////////////////////////////////////////////////////////////////////////////////////////////////////////////
		// Interactive Tool Points 
		public function find3DToolPoints():void
		{
			// hooked fingers
			//var hook_extension:Number = 30;
			
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
				}
		}*/
		
		/////////////////////////////////////////////////////////////////////////////////////////////////////////////
		// Interactive Hook Points 
		public function find3DHookPoints():void
		{
			// hooked fingers
			var hookThreshold:Number = 0.4;
			
			for (var j:int = 0; j < hn; j++)
				{	
				var hfn:int = cO.handList[j].fingerList.length;
				
				for (i = 0; i < hfn; i++)
				{
					var hp:MotionPointObject = cO.handList[j].fingerList[i];
					//trace("hook extension",hp.extension)
	
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
			}
			
		}
		
		/////////////////////////////////////////////////////////////////////////////////////////////////////////////
		// Interactive Push/Pin Point (z-axis)
		public function find3DPushPoints():void
		{
			// must add other planes (orthogonal)
			// must add plane bounds (x and y for z)
			var z_wall:int = 50;
		
			
			for (var j:int = 0; j < hn; j++)
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
		// Interactive Trigger Points
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
				
			var triggerThreshold:Number = 0.6; // bigger threahold than hook
			
				for (var j:int = 0; j < hn; j++)
				{	
				var hfn:int = cO.handList[j].fingerList.length;
				var hfnk:Number = 0;
				var thumb:MotionPointObject = cO.handList[j].thumb;	
				
					//trace(thumb.extension)
					if (thumb.extension > triggerThreshold) //1 rad 90 deg ish
						{
						var	t_pt = new InteractionPointObject();
						
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
						t_pt.type = "trigger";
						
						// push when triggered
						InteractionPointTracker.framePoints.push(t_pt);
						}
					//}		
			}
		}
		
		////////////////////////////////////////////////////////////////////////
		// Interactive Region Points (3d volume)
		public function find3DRegionPoints():void
		{
			var x_min:Number; 
			var x_max:Number;
			var y_min:Number; 
			var y_max:Number;
			var z_min:Number; 
			var z_max:Number;
			
			for (var j:int = 0; j < hn; j++)
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
						var pt = cO.handList[j].fingerList[i];	
						
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
		// Interactive FingerTip Points
		public function find3DFingerPoints():void
		{
			var hn:int = cO.handList.length;
			
			for (var j:int = 0; j < hn; j++)
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
		// Interactive Thumb Points
		public function find3DThumbPoints():void
		{
			var hn:int = cO.handList.length;
			
			for (var j:int = 0; j < hn; j++)
				{	
					var hfn:int = cO.handList[j].fingerList.length;
				
					//get thumb points
					if ((hfn>0)&&(cO.handList[j].thumb)) 
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
		// Interactive Frame Points
		public function find3DFramePoints():void
		{
			// fn == 3;
			// CHECK EXTENSION
				// ADD TO LIST
				// WHEN 2 POINTS 
				// CHECK ANGLE BETWEEN
				// CREATE 4 CORNER POINTS
			// PUSH FRAME POINTS
			
			var hn:int = cO.handList.length;
			
			for (var j:int = 0; j < hn; j++)
				{	
				var pointlist:Vector.<MotionPointObject>
				var hfn:int = cO.handList[j].fingerList.length;
			
				pointlist = new Vector.<MotionPointObject>
				
				if (hfn == 2)
				{
					/// find extension measure
					// NEED TO GENERALIZE INTO HAND OBJECT
					
					for (var i:int = 0; i < hfn; i++)
						{
								if (cO.handList[j].fingerList[i].type == "finger")
								{
									var pt:MotionPointObject = cO.handList[j].fingerList[i];
									var palm_finger_vector:Vector3D = pt.position.subtract(cO.handList[j].position);
									var exe_diff:Number = Vector3D.angleBetween(pt.direction, palm_finger_vector);
									
									trace(exe_diff);
									if (exe_diff < 0.8) pointlist.push(pt);
								}	
						}
							
							//trace(pointlist.length)
						if (pointlist.length == 2) 
						{
							var palm_finger_vectorA:Vector3D = pointlist[0].position.subtract(cO.handList[j].position);
							var palm_finger_vectorB:Vector3D = pointlist[1].position.subtract(cO.handList[j].position);
							var angle_diff:Number = Vector3D.angleBetween(palm_finger_vectorA, palm_finger_vectorB);
							//trace("diff", angle_diff);
							
							if ((angle_diff > 1)&&(angle_diff < Math.PI/2))
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
									var ff_pt:InteractionPointObject = new InteractionPointObject();
										ff_pt.position = pointlist[q].position;
										//ff_pt.direction =pointlist[j].direction;
										//t_pt.normal = cO.hand.normal;
										//ff_pt.handID = cO.handList[j].handID;
										ff_pt.type = "frame";
										
									InteractionPointTracker.framePoints.push(ff_pt)
									//trace("push frame point");
								}

									
							}
						}
						
				}	
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