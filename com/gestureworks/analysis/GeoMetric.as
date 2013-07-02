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
	import com.gestureworks.objects.PointObject;
	import com.gestureworks.objects.MotionPointObject;
	import com.gestureworks.objects.InteractionPointObject;
	import com.gestureworks.objects.ClusterObject;
	import com.gestureworks.objects.PointPairObject;
	import com.gestureworks.managers.PointPairHistories;
	import com.gestureworks.managers.InteractionPointTracker;
	
	//import com.leapmotion.leap.Frame 
	//import com.leapmotion.leap.Finger 
	//import com.leapmotion.leap.Hand
	//import com.leapmotion.leap.Vector3;
	
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
		
		public function resetCluster():void
		{
			//////////////////////////////////////
			// SUBCLUSTER STRUCTURE
			// CAN BE USED FOR BI-MANUAL GESTURES
			// CAN BE USED FOR CONCURRENT GESTURE PAIRS
			/////////////////////////////////////
			//clear interactive point list
			cO.iPointArray = new Vector.<Object>();
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
		}
		
		// get noamlized finger length and palm angle
		public function normalizeFingerSize():void 
		{
			var min_max_length:Number = 0;
			var max_max_length:Number = 0;
			var min_length:Number = 0;
			var max_length:Number = 0;
			//var min_width:Number
			//var max_width:Number
			var min_palmAngle:Number = 0
			var max_palmAngle:Number = 0
			var min_favdist:Number = 0;
			var max_favdist:Number = 0;

			// get values
			for (i = 0; i < fn; i++)
				{	
					if (cO.motionArray[i].type == "finger")
					{	
						var palm_mpoint:MotionPointObject = GestureGlobals.gw_public::motionPoints[cO.motionArray[i].handID];
						
						if (palm_mpoint) 
						{
							var p_pos:Vector3D = palm_mpoint.position;
							var f_pos:Vector3D = cO.motionArray[i].position;
							var normal:Vector3D = palm_mpoint.normal;
							var vp_mp:Vector3D = f_pos.subtract(p_pos);

							var dist:Number = (vp_mp.x * normal.x) + (vp_mp.y * normal.y) + (vp_mp.z * normal.z);
							var palm_plane_point:Vector3D = new Vector3D((f_pos.x - dist * normal.x), (f_pos.y -dist*normal.y), (f_pos.z - dist*normal.z));
							
							cO.motionArray[i].palmplane_position = palm_plane_point
							//trace("projected point in palm plane",palm_plane_point)
							
							var ppp_dir:Vector3D = palm_plane_point.subtract(p_pos);
							
							// set palm angle of point
							cO.motionArray[i].palmAngle =  Vector3D.angleBetween(ppp_dir, palm_mpoint.direction);
							//palmAngle = Math.abs(Vector3D.angleBetween(cO.motionArray[i].direction, palm_mpoint.direction));

							// calc proper length
							cO.motionArray[i].length = Vector3D.distance(p_pos,f_pos);
						}
						else {
							cO.motionArray[i].length = 0;
							cO.motionArray[i].palmAngle = 0;
						}
						
						
						//trace("width",cO.motionArray[i].width)
						
						////////////////////////////////////////////////////
						// get percent extension
						var l:Number = cO.motionArray[i].length;
						var max_l:Number = cO.motionArray[i].max_length;
						var min_l:Number = cO.motionArray[i].min_length;
						var ext:Number = 0;
						
						//update max and min length
						if (l > max_l) cO.motionArray[i].max_length = l;
						if ((l < min_l)&&(l!=0)) cO.motionArray[i].min_length = l;
						
						// normalize
						// calc relative extension
						ext = Math.round(100 * ((l - min_l) / (max_l -min_l)));
						if (ext < 0) ext = 0;
						if (ext > 100) ext = 100;
						
						 cO.motionArray[i].extension = ext;
						//trace(cO.motionArray[i].extension,l,min_l,max_l)
						/////////////////////////////////////////////////////
					}
				}
				
				for (i = 0; i < fn; i++)
				{
					if (cO.motionArray[i].type == "finger")
					{	
						//max length max and min
						var value_max_length = cO.motionArray[i].max_length;
						if (value_max_length > max_max_length) max_max_length = value_max_length;
						if ((value_max_length < min_max_length)&&(value_max_length!=0)) min_max_length = value_max_length;
						
						// length max and min
						var value_length = cO.motionArray[i].length;
						if (value_length > max_length) max_length = value_length;
						if ((value_length < min_length)&&(value_length!=0)) min_length = value_length;
						
						// palm angle max and min
						var value_palm = cO.motionArray[i].palmAngle;
						if (value_palm > max_palmAngle) max_palmAngle = value_palm;
						if ((value_palm < min_palmAngle)&&(value_palm!=0)) min_palmAngle = value_palm;

						//finge raverage distance max and min
						var value = cO.motionArray[i].favdist;
						if (value > max_favdist) max_favdist = value;
						if ((value < min_favdist)&&(value!=0)) min_favdist = value;
					}
				}
			
				//normalized values and update
				for (i = 0; i < fn; i++)
					{
					if (cO.motionArray[i].type == "finger")
						{	
						cO.motionArray[i].normalized_max_length = normalize(cO.motionArray[i].max_length, min_max_length, max_max_length);
						cO.motionArray[i].normalized_length = normalize(cO.motionArray[i].length, min_length, max_length);
						//cO.motionArray[i].normalized_width = normalize(cO.motionArray[i].width, min_width, max_width);
						cO.motionArray[i].normalized_palmAngle = normalize(cO.motionArray[i].palmAngle, min_palmAngle, max_palmAngle);
						cO.motionArray[i].normalized_favdist = normalize(cO.motionArray[i].favdist, min_favdist, max_favdist);
						}
					}	
		}
		

		// get noamlized finger length and palm angle
		// PALM IP
		// FAV IP
		public function createHand():void 
		{
			trace("create hand")
			
			//cO.hand[0] = new Vector();
			var fav_pt:Vector3D = new Vector3D();
			var fnk:Number = 0;
			
			if (fn-1) fnk = 1 / (fn-1);
			
			for (i = 0; i < fn; i++)
					{
						/// create hand
						if (cO.motionArray[i].type == "palm") 
						{
							cO.hand = cO.motionArray[i] //palmID
							//cO.hand[0][0] = cO.motionArray[i].motionPointID; //palmID
							
							//var palm_pt:MotionPointObject = new MotionPointObject();
							var palm_pt:InteractionPointObject = new InteractionPointObject();
								palm_pt.position = cO.motionArray[i].position;
								palm_pt.direction = cO.motionArray[i].direction;
								palm_pt.handID = cO.motionArray[i].handID;
								palm_pt.type = "palm";
								
							//cO.iPointArray.push(palm_pt); // test
							InteractionPointTracker.framePoints.push(palm_pt)
							//trace("push plam point");
						}
						
						if (cO.motionArray[i].type == "finger")
						{
							// finger average point
							fav_pt.x += cO.motionArray[i].position.x;
							fav_pt.y += cO.motionArray[i].position.y;
							fav_pt.z += cO.motionArray[i].position.z;
						}
					}
					
				fav_pt.x *= fnk;
				fav_pt.y *= fnk;
				fav_pt.z *= fnk;
			
					//var fv_pt:MotionPointObject = new MotionPointObject();
					var fv_pt:InteractionPointObject = new InteractionPointObject();
						fv_pt.position = fav_pt;
						fv_pt.handID = cO.hand.handID;
						fv_pt.type = "finger_average";
						
					cO.iPointArray.push(fv_pt);
					//InteractionPointTracker.framePoints.push(fv_pt)
			
			//trace("number finger",fn,fnk,fav_pt.x,fav_pt.y,fav_pt.z)
			var favlength:Number = 0;
			var palmratio = 0.4;
			
			for (i = 0; i < fn; i++)
				{
					if (cO.motionArray[i].type == "finger")
						{
						cO.motionArray[i].favdist = Vector3D.distance(cO.motionArray[i].position, fav_pt);
						// find average max length
						favlength += cO.motionArray[i].max_length;
						//trace("favdist",cO.motionArray[i].favdist,cO.motionArray[i].fingertype, min_favdist, max_favdist )
						}
				}
				
				cO.hand.sphereRadius = fnk * favlength * palmratio;
				
				//trace("rad",cO.hand.sphereRadius)
			
		}
		
		
		// find thumb .. generate pair data
		//.. should save data to cluster table for rot and scale paired operations
		public function findThumb():void
		{
			//var ma = cO.motionArray;
			var pair_table:Array = new Array();

			// CALC PAIR VALUES FOR UNIQUE POINT PAIRS
			// COPY FROM ONE SIDE OF MATRIX TO THE OTHER TO HALVE CALCS
			//trace("---------------");
			
			// use max length values instaed of current values
			// will reduce thumb shift upon extension
			// or simply require min extension before using real time length
			
			if (fn == 3) 
			{
				var temp_pair:Array = new Array();
				
				for (i = 0; i < 3; i++)
				{
					if (cO.motionArray[i].type == "finger")
					{
					// reset thum alloc
					cO.motionArray[i].fingertype = "finger";
							 
					// reset thumb probs
					cO.motionArray[i].thumb_prob = 0;
					cO.motionArray[i].mean_thumb_prob = 0
						
					// push to single pair
					temp_pair.push(cO.motionArray[i]);
					}
				}
			
				if (temp_pair.length == 2)
				{
					var palm_mpoint:MotionPointObject = GestureGlobals.gw_public::motionPoints[temp_pair[0].handID];
					
					if (palm_mpoint)
					{
						// set prob
						// fav dist is equal
						temp_pair[0].thumb_prob = (1-temp_pair[0].normalized_length) + 5*(temp_pair[0].normalized_palmAngle);
						temp_pair[1].thumb_prob = (1-temp_pair[1].normalized_length) + 5*(temp_pair[1].normalized_palmAngle);
						
						// set thumb
						if (temp_pair[1].thumb_prob > temp_pair[0].thumb_prob)  temp_pair[1].fingertype = "thumb";	
						else temp_pair[0].fingertype = "finger";
					}
				}	
			}
			
			if (fn > 3)
			{
						for (i = 0; i < fn; i++)
									{
									//trace("-" );
									if (cO.motionArray[i].type == "finger")
									{	
									//var pair_array:Array = new Array();
									palm_mpoint= GestureGlobals.gw_public::motionPoints[cO.motionArray[i].handID];
									var pair_array:Array = new Array();
											
									if(palm_mpoint)
											{
											// find all 20 //unique pairs (10 for 5 points) 
											for (var q:int = 0; q < fn; q++) //i+1
												{
													if ((i != q) && (cO.motionArray[q].type == "finger"))//(N > i + 1
													{
														//find separation dist for each pair	
														var dist:Number = Vector3D.distance(cO.motionArray[i].position, cO.motionArray[q].position);
														
														var pair_data:Array = new Array()
															pair_data.pointID = cO.motionArray[i].motionPointID; // ROOT POINT ID
															pair_data.pair_pointID = cO.motionArray[q].motionPointID; // PAIRED POINT ID
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
												pair_table.push(pair_array);
											}
											
									}
							}

						// SORT PAIR PROB ARRAYS
							// COPY COLUMN ELEMENTS INTO AN ARRAY
							// SORT ARRAY
							// GET MAX AND MIN DIST VALUES
							// CALC NORMALIZED VALUE (BETWEEN 0 AND 1)
							// PUSH RESULTS TO PAIR TABLE
	
						// get table size
						var tn:int = pair_table.length;
						for (i = 0; i < tn; i++)
									{		
										// create temp array
										var min_dist:Number = 0;
										var max_dist:Number = 0;
										//var temp_column_arrayA:Array = new Array();

										var tnn:int = pair_table[i].length;
										/// copy data from table
											for (q = 0; q < tnn; q++)
												{	
													if (pair_table[i][q].distance != 0){ // temp_column_arrayA.push(pair_table[i][q].distance);
														var value_pair = pair_table[i][q].distance
														if (value_pair > max_dist) max_dist = value_pair;
														if ((value_pair < min_dist) && (value_pair != 0)) min_dist = value_pair;
													}
												}	
												
										/// sort data	
										//temp_column_arrayA.sort(Array.DESCENDING);
											
										/// find max and min values
										//if (temp_column_arrayA[tnn - 1]) min_dist = temp_column_arrayA[tnn - 1]
										//if (temp_column_arrayA[0]) max_dist = temp_column_arrayA[0];
										
										
										/// find normalized values
										/// write into table
										for (q = 0; q < tnn; q++)
										{
											pair_table[i][q].max_distance = max_dist;
											pair_table[i][q].min_distance = min_dist;
											//pair_table[i][q].normalized_distance = normalize(temp_column_arrayA[q], min_dist, max_dist);
											pair_table[i][q].normalized_distance = normalize(pair_table[i][q].distance, min_dist, max_dist);
											
											pair_table[i][q].pair_prob = 2 * (pair_table[i][q].normalized_distance)
											//pair_table[i][q].pair_prob = 2*(pair_table[i][q].normalized_distance)
											
											// accumulate based on paired sets on primary point in pair
											GestureGlobals.gw_public::motionPoints[pair_table[i][q].pointID].thumb_prob += pair_table[i][q].pair_prob//1;
										
											/*
											trace("");
											trace("ID", pair_table[i][q].pointID,"pairedID",pair_table[i][q].pair_pointID);
											trace("norm dist", pair_table[i][q].distance, min_dist, max_dist, pair_table[i][q].normalized_distance);
											trace("norm dang",  pair_table[i][q].directionAngle, min_dang, max_dang,  pair_table[i][q].normalized_directionAngle);
											trace("norm pang",  pair_table[i][q].positionAngle, min_pang, max_pang,  pair_table[i][q].normalized_positionAngle);
											trace("pair prob", pair_table[i][q].pair_prob);
											*/
											}							
								}
					}	


						///////////////////////////////////////////////////////////////////////////////////
						// MOD THUMB PROB WITH FINGER LENGTH AND WIDTH
						
							// get largest thumb prob
							var thumb_list:Array = new Array()
							
							for (i = 0; i < fn; i++)
								{
									if (cO.motionArray[i].type == "finger") 
									{
										cO.motionArray[i].thumb_prob += (1-cO.motionArray[i].normalized_length) + 5 * (cO.motionArray[i].normalized_palmAngle) + 5 * (cO.motionArray[i].normalized_favdist)
										
										//cO.motionArray[i].thumb_prob += (1- cO.motionArray[i].normalized_length)
										//cO.motionArray[i].thumb_prob += (cO.motionArray[i].normalized_favdist) //WORKS VERY WELL ON OWN
										//cO.motionArray[i].thumb_prob += (cO.motionArray[i].normalized_palmAngle)
										
										//trace("iD",cO.motionArray[i].motionPointID,"norm length", cO.motionArray[i].normalized_length,"norm palm angle", cO.motionArray[i].normalized_palmAngle,"thumb prob",cO.motionArray[i].thumb_prob)
										//trace(cO.motionArray[i].max_length,cO.motionArray[i].normalized_max_length);
										}
									thumb_list[i] = cO.motionArray[i].thumb_prob;
									//thumb_list[i] = cO.motionArray[i];
								}	
							///////////////////////////////////////////////////////////////////////////////////
							// optional history buffer
							var hist_avg:Boolean = false;
							if (hist_avg)
							{
								// find temporal average thumb prob
								for (i = 0; i < fn; i++)
								{
									//trace("---",cO.motionArray[i].history.length);
									for (var h:int = 0; h < cO.motionArray[i].history.length; h++)
									{
										cO.motionArray[i].mean_thumb_prob += cO.motionArray[i].history[h].thumb_prob
									}
									cO.motionArray[i].mean_thumb_prob = cO.motionArray[i].mean_thumb_prob / cO.motionArray[i].history.length;
									
									//cO.motionArray[pn].mean_thumb_prob // cO.motionArray[pn].history.length;
									//trace("mtp", cO.motionArray[i].motionPointID , cO.motionArray[i].mean_thumb_prob)
									thumb_list[i] = cO.motionArray[i].mean_thumb_prob
								}
							}
						///////////////////////////////////////////////////////////////////////////////////
						// SET FINGER TO THUMB BASED ON HIGHEST PROB
						
						var max_tp:Number = Math.max.apply(null, thumb_list);
						var max_index:int = thumb_list.indexOf(max_tp);
						
						if ((max_index != -1) && ( cO.motionArray[max_index]) && (cO.motionArray[max_index].type == "finger")) 
						{
							cO.motionArray[max_index].fingertype = "thumb";	
							//trace("t",cO.motionArray[max_index].favdist, cO.motionArray[max_index].normalized_favdist);
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

		
		/////////////////////////////////////////////////////////////////////////////////////////////////////////////
		// Interactive Pinch Points 
		//PINCH IP
		public function find3DPinchPoints():void
		{
			var pinchThreshold:Number = 30;
			
			if (fn)
				{
					// pinch
					//////////////////////////////////////////////////////////////////
							
								for (i = 0; i < fn; i++)
									{
										
									//trace("type kinemetric",cO.motionArray[i].type);
									
									for (var j3:uint = 0; j3 <fn; j3++)
										{
										if ((i != j3)&&(cO.motionArray[i].type=="finger")&&(cO.motionArray[j3].type=="finger")){
									
												var fv0:Vector3D = cO.motionArray[i].position;
												var fv1:Vector3D = cO.motionArray[j3].position;
												
												///pinch distance
												//CAN DIFF THUMB AS SHORTEST FINGER IN SET (40-60PX)
												var pinch_dist:Number = Vector3D.distance(fv0,fv1) ;
												//trace(pinch_dist)
												
												if ((pinch_dist <= pinchThreshold)&&(pinch_dist!=0))
												{
													
													// PUSH PINCH POINT INTERRACTION EVENT
													//InteractionManager.onInteractionBegin(new GWInteractionEvent(GWInteractionEvent.INTERACTION_BEGIN, mp, true, false));
													
													
													// find midpoint between fingertips
													//var pmp:MotionPointObject = new MotionPointObject();
													var pmp:InteractionPointObject = new InteractionPointObject();
														pmp.position.x = fv0.x - (fv0.x - fv1.x) * 0.5;
														pmp.position.y = fv0.y - (fv0.y - fv1.y) * 0.5;
														pmp.position.z = fv0.z - (fv0.z - fv1.z) * 0.5;
														pmp.type = "pinch";
														//pmp.handID = cO.motionArray[i].handID;
														
														////////////////////////////
														// perform hit test
														var ht:Boolean = true//ts.hitTestPoint(pmp.position.x,pmp.position.y);
														//trace("httttt", ht)
														
														//PUSH POINT TO TOUCH OBJECT INTERACTIVEPOINT LIST
														//TREAT AS LOCAL CLUSTER PROCESS ACCORDINGLY
														
														//MOVE TO INTERACTION MANAGER
														//if (ht)
														//{
															//CREATE SUBCLUSTER	
															//add to pinch point list
															
															
															//cO.iPointArray.push(pmp); // test
															
															//InteractionPointTracker.framePoints.push(pmp)
															
															
															//COULD CALL CLUSTER TYPE PINCH RATHER THAN LABELING POINTS 
															//cO.clusterArray[0].type = "pinch";
															//cO.type = "pinch";
														//}
												}
									}
								}
							}
							
							// GET LOCAL LIST OF CLOSE FINGER TIPS
							
							// FIND CLOSEST TO PALM POINT
							
							// PUSH CLOSESR TO IPA
							// PUSH PINCH POINT MOTION POINT EVENT
							
							
							
				}
		}
		
		/////////////////////////////////////////////////////////////////////////////////////////////////////////////
		// Interactive Tool Points 
		public function find3DToolPoints():void
		{
			// hooked fingers
			var hook_extension:Number = 30;
			
				for (i = 0; i < fn; i++)
				{
					if (cO.motionArray[i].type == "tool")
						{	
							//trace("tool");
							//var pmp:MotionPointObject = new MotionPointObject();
							var pmp:InteractionPointObject = new InteractionPointObject();
									pmp.handID = cO.motionArray[i].handID;
									pmp.position = cO.motionArray[i].position;
									pmp.direction = cO.motionArray[i].direction;
									pmp.length = cO.motionArray[i].length;
									pmp.type = "tool";

									// push to interactive point list
									//cO.iPointArray.push(pmp);//test	
									InteractionPointTracker.framePoints.push(pmp)
						}
				}
		}
		
		/////////////////////////////////////////////////////////////////////////////////////////////////////////////
		// Interactive Hook Points 
		public function find3DHookPoints():void
		{
			// hooked fingers
			var hook_extension:Number = 30;
			
				for (i = 0; i < fn; i++)
				{
					if ((cO.motionArray[i].type == "finger")&&(cO.motionArray[i].extension < hook_extension))
						{	
							//trace("hook");
							//var pmp:MotionPointObject = new MotionPointObject();
							var pmp:InteractionPointObject = new InteractionPointObject();
									//pmp.id = cO.motionArray[i].id;
									//pmp.motionPointID = cO.motionArray[i].motionPointID;
									pmp.handID = cO.motionArray[i].handID;
									pmp.position = cO.motionArray[i].position;
									pmp.direction = cO.motionArray[i].direction;
									//pmp.length = cO.motionArray[i].length;
									pmp.type = "hook";
									

									// push to interactive point list
									//cO.iPointArray.push(pmp);//test	
									InteractionPointTracker.framePoints.push(pmp)
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
		
					for (i = 0; i < fn; i++)
					{
						if (cO.motionArray[i].type == "finger")
						{
							//trace("pos",cO.motionArray[i].position)
								if (cO.motionArray[i].position.x > z_wall) 
								{	
									//trace("z",cO.motionArray[i].position.z)

									// touch sprite hit test
									var pp_ht:Boolean = true//ts.hitTestPoint(cO.motionArray[i].position.x , cO.motionArray[i].position.y);
								
									
									//if (pp_ht) {
											//create point
											//trace("push");
										//	var pmp:MotionPointObject = new MotionPointObject();
											var pmp:InteractionPointObject = new InteractionPointObject();
													//pmp.id = cO.motionArray[i].id;
													//pmp.motionPointID = cO.motionArray[i].motionPointID;
													pmp.handID = cO.motionArray[i].handID;
													pmp.position = cO.motionArray[i].position;
													pmp.direction = cO.motionArray[i].direction;
													pmp.length = cO.motionArray[i].length;
													pmp.type = "push";

											// push to interactive point list
											//cO.iPointArray.push(pmp);//test
											InteractionPointTracker.framePoints.push(pmp)
									//}
									
								}
						}
					}
		}
		
		////////////////////////////////////////////////////////////////////////
		// Interactive Trigger Points
		public function find3DTriggerPoints():void
		{
			//find3DThumbPoints();
			
			var triggerThreshold:Number = 45;
			var tempList:Array = new Array();
			//trace("--frame----------------------------------");
				
								//only works for 2 fingers
								for (i = 0; i < fn; i++)
									{
									for (var j3:uint = 0; j3 <fn; j3++)
										{
										if ((i != j3)&&(cO.motionArray[i].type=="finger")&&(cO.motionArray[j3].type=="finger")){
				
										
										// need to also make non repeateable
												
												//NOTE WILL NEED TO FIND BEST PAIR AND LOCK OUT OTHER FINGER PAIRS
												// FINGER AND THUMB
												// FIND THUM 
												// GET CLOSEST FINGER
												// CHECK ANGLE
												// PERFORM HIT TEST
												// RETURN FINGER VECTOR
											
											
												var fv0:Vector3D = cO.motionArray[i].direction//position;
												var fv1:Vector3D = cO.motionArray[j3].direction//position;
												var tfv:MotionPointObject = new MotionPointObject();
												
												///pinch distance
												//CAN DIFF THUMB AS SHORTEST FINGER IN SET (40-60PX)
												var angle:Number = (Vector3D.angleBetween(fv0, fv1))*RAD_DEG//*RAD_DEG// mind max
												var dist:Number = Vector3D.distance(fv0, fv1) // find min
												var length:Number// find min
												
												//trace("angle",angle);
												//trace("width",fingers[i].width, fingers[j3].width);
												//trace("length",fingers[i].length, fingers[j3].length);
												
												if (angle > triggerThreshold) 
												{
													
													var array:Array = new Array()
														array[0] = new Array();
															array[0].point = cO.motionArray[i];
															array[0].length = cO.motionArray[i].length;
														array[1] = new Array();
															array[1].point = cO.motionArray[j3];	
															array[1].length = cO.motionArray[j3].length;
														
														array.sortOn("length", Array.DESCENDING);
														tfv = array[0].point
														
														
														//create trigger point
														//var tp:MotionPointObject = new MotionPointObject();
														var tp:InteractionPointObject = new InteractionPointObject();
															tp.position = tfv.position;
															tp.direction = tfv.direction;
															tp.length = tfv.length;
															//tp.id = tfv.id;
															//tp.motionPointID = tfv.motionPointID;
															tp.handID = tfv.handID;
															tp.type = "trigger";
														
														var tpht:Boolean = true//ts.hitTestPoint(tp.position.x , tp.position.y);
														
														//if (tpht){
															//add to pinch point list
															//if ((tp.position.x != 0) && (tp.position.y != 0)) 
															//{
																//cO.iPointArray.push(tp); // test
																InteractionPointTracker.framePoints.push(tp)
															//}
															
															//trace("finger", i,j3, tp.id, "angle", angle, tp.motionPointID,tpht,cO.motionArray[i].length,cO.motionArray[j3].length)
															// when found trigger pair return out of loop
															//return 
														//}	
												}
				
											}
									}
								}

		}
		
		////////////////////////////////////////////////////////////////////////
		// Interactive Region Points (3d volume)
		public function find3DRegionPoints():void
		{
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