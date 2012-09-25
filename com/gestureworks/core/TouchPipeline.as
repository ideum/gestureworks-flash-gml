////////////////////////////////////////////////////////////////////////////////
//
//  IDEUM
//  Copyright 2011-2012 Ideum
//  All Rights Reserved.
//
//  GestureWorks
//
//  File:    gestureContinuous.as
//  Authors:  Ideum
//             
//  NOTICE: Ideum permits you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////
package com.gestureworks.core 
{
	//import com.gestureworks.core.TouchSprite;
	
	import com.gestureworks.core.GestureGlobals;
	import com.gestureworks.core.gw_public;
	import com.gestureworks.objects.ClusterObject;
	import com.gestureworks.objects.GestureListObject;
	import com.gestureworks.objects.TransformObject;
	import com.gestureworks.objects.DimensionObject;
	
	//import com.gestureworks.utils.NoiseFilter;
	
	/**
 * The TouchObject class is the base class for all touch enabled DisplayObjects. It
 * provides basic implementations for priortized gesture and touch processing as well as 
 * properties to dictate tactual object ownership and targeting. This object inherits
 * the Player default Sprite functionality.
 * 
 * <p>All TouchObjects are provided with a static reference to the global blob manager
 * at runtime. A DataProvider to the blob manager is established upon Application 
 * instantiation by the developer.</p>
 * 
 */
	
	public class TouchPipeline
	{
		/**
	 * A collection of gestures attached to this object.
	 */
		private var touchObjectID:int;
		private var ts:Object;
		private var gO:GestureListObject;
		private var cO:ClusterObject;
		private var trO:TransformObject;
		
		private var i:uint;
		private var j:uint;
		private var gn:uint

		 /**
		 *  Constructor.
		 *  
		 * @langversion 3.0
		 * @playerversion AIR 1.5
		 * @playerversion Flash 10
		 * @playerversion Flash Lite 4
		 * @productversion GestureWorks 1.5
		 */ 
		public function TouchPipeline(_id:int) {
			
			touchObjectID = _id;
			init();
		}
		
		public function init():void
		{	
			ts = GestureGlobals.gw_public::touchObjects[touchObjectID];
			cO = ts.cO;
			gO = ts.gO;
			trO = ts.trO;
		}
		
		public function processPipeline():void
		{
			//trace("processing pipeline");
			gn = gO.pOList.length;
			
			for (i=0; i < gn; i++) 
				{
				var dn:uint = gO.pOList[i].dList.length;
				
						for (j=0; j < dn; j++) 
						{
							// PULL DATA FROM CLUSTER
							gO.pOList[i].dList[j].gestureDelta = gO.pOList[i].dList[j].clusterDelta;
							//gO.pOList[i].dList[j].gestureDeltaCache = gO.pOList[i].dList[j].gestureDelta;
							
							
							ts.gestureFilters = false
							
							
									// turn of all filters  //------------- may also want to turn off when delta is already zero????
									if(ts.gestureFilters){

											///////////////////////////////////////////////////////////
											// average filter
											///////////////////////////////////////////////////////////
											
											if (gO.pOList[i].dList[j].mean_filter)
											{
												if(!gO.pOList[i].dList[j].gestureDeltaArray) gO.pOList[i].dList[j].gestureDeltaArray = new Array();
												var hist:uint = 8;
												var ln:uint =  gO.pOList[i].dList[j].gestureDeltaArray.length;
												var ln0:Number = 1 / ln;
												var delta:Number = gO.pOList[i].dList[j].gestureDelta
												var mvar:Number = 0;
												
												gO.pOList[i].dList[j].gestureDeltaArray.push(delta);
												if (ln >= hist) gO.pOList[i].dList[j].gestureDeltaArray.shift();
												
	
												for (var p:int = 0; p < ln; p++){ mvar += gO.pOList[i].dList[j].gestureDeltaArray[p];}
												mvar *= ln0;
												if(mvar) gO.pOList[i].dList[j].gestureDelta = mvar;	
											}
											
											///////////////////////////////////////////////////////////////////////////////////////////
											// NOISE FILTER BLOCK
											///////////////////////////////////////////////////////////////////////////////////////////
											/*
											if (gO.pOList[i].dList[j].noise_filter)
											{
												// init noise filter
												if(!gO.pOList[i].dList[j].noise_filterMatrix) gO.pOList[i].dList[j].noise_filterMatrix = new NoiseFilter();
												else {
													var estDelta:Number = gO.pOList[i].dList[j].noise_filterMatrix.next(gO.pOList[i].dList[j].clusterDelta);
													gO.pOList[i].dList[j].gestureDelta = gO.pOList[i].dList[j].filter_factor * estDelta + (1 - gO.pOList[i].dList[j].filter_factor) * gO.pOList[i].dList[j].clusterDelta;
													//trace("	applying filter:",i,j, "	cluster delta:",gO.pOList[i][j].clusterDelta, "	estinmated delta:",estDelta, "	filter factor:",gO.pOList[i][j].filter_factor)
												}
											}
											else gO.pOList[i].dList[j].gestureDelta = gO.pOList[i].dList[j].clusterDelta;
											*/

											//trace("pipe",ts.gO.pOList[i][j].clusterDelta,ts.gO.pOList[i][j].gestureDelta)
											

											////////////////////////////////////////////////////////////////////////////////////////////
											// easing block
											////////////////////////////////////////////////////////////////////////////////////////////
											
											if((ts.gestureReleaseInertia)&&(gO.pOList[i].dList[j].release_inertia_filter)){
												// select new gesture delta or cached delta based // based on N activity
												if (ts.N!=0)
												{
													//when touching calculate new deltas 
													if ((ts.N >= ts.gO.pOList[i].nMin) && (ts.N <= ts.gO.pOList[i].nMax) || (ts.N == ts.gO.pOList[i].n)) 
													{
														// fill cache with new values
														gO.pOList[i].dList[j].gestureDeltaCache = gO.pOList[i].dList[j].gestureDelta;
														
														// RESTART MATCHED DORMANT TWEEN THREADS
														//if (gO.pOList[i][j].release_inertia_filter)
														//{
														gO.pOList[i].dList[j].release_inertiaOn = true;
														gO.pOList[i].dList[j].release_inertia_count = 0;
															//if (ts.trace_debug_mode) trace("restart tween");
														//}
														
														// set phase 
														gO.pOList[i].passive = false;
														gO.pOList[i].active = true;
														//trace("touch active",i,j);
													}
													else {
														// when not meeting gesture calc conditions
														// but still touching use cached delta
														gO.pOList[i].dList[j].gestureDelta = gO.pOList[i].dList[j].gestureDeltaCache;
														
														// set phase
														gO.pOList[i].passive = true;
														gO.pOList[i].active = false;
														//trace("touch passive cache",i,j,gO.pOList[i][j].gestureDelta);
													}
												}
												else {
													// when not touching use cached delta
													gO.pOList[i].dList[j].gestureDelta = gO.pOList[i].dList[j].gestureDeltaCache;
													
													// set phase
													gO.pOList[i].passive = true;
													gO.pOList[i].active = false;
												}
												
												// when touching but when not matching n values // or when not touching // tween cached deltas 
												if ((ts.N < gO.pOList[i].nMin)||(ts.N > gO.pOList[i].nMax)||(ts.N == 0))
												{
													// set to passive phase
													gO.pOList[i].passive = true;
													gO.pOList[i].active = false;
													
													//trace("test",ts.N, i);
													// gesturetweenon no longer needed
													//if ((ts.gestureTweenOn) && (gO.pOList[i][j].release_inertiaOn) && (gO.pOList[i][j].release_inertia))
													if(gO.pOList[i].dList[j].release_inertiaOn)//&&(gO.pOList[i][j].release_inertia_filter)
													{
														var count:uint = gO.pOList[i].dList[j].release_inertia_count++;
															
															if (gO.pOList[i].dList[j].gestureDelta != 0)
															{
																//gO.pOList[i].dList[j].release_inertiaOn = true;
																gO.pOList[i].dList[j].gestureDelta *= gO.pOList[i].dList[j].release_inertia_factor * Math.pow(gO.pOList[i].dList[j].release_inertia_base, count);
															}
															
															//trace("gdelta",Math.abs(gO.pOList[i].dList[j].gestureDelta),gO.pOList[i].dList[j].delta_min);
															
															if ((count > gO.pOList[i].dList[j].release_inertia_Maxcount)||(Math.abs(gO.pOList[i].dList[j].gestureDelta) < gO.pOList[i].dList[j].delta_min))
															{
																gO.pOList[i].dList[j].release_inertiaOn = false;
																gO.pOList[i].dList[j].gestureDelta = 0;
																//ts.gO.pOList[i][j].gestureDeltaCache =0;
																gO.pOList[i].dList[j].release_inertia_count = 0;
															}
													}
													else {
														gO.pOList[i].dList[j].gestureDelta = 0;
														
														//NEED CHACHEING FOR FLICK AND SWIPE
														//ts.gO.pOList[i][j].gestureDeltaCache = 0;
														
														//trace("shut down zero delta",ts.gO.pOList[i][j].gestureDelta);
													}
													//trace("touch passive tween",i,j,gO.pOList[i][j].gestureDelta);
												}
											}
											
											

											///////////////////////////////////////////////////////////////////////////////////////////
											// MULTIPLY FILTER
											// multiplies delta by a const of proportionality
											// produces linear,quadartic,cubic or polynomial function
											///////////////////////////////////////////////////////////////////////////////////////////
											
											if (gO.pOList[i].dList[j].multiply_filter)
											{
												if (gO.pOList[i].dList[j].func) 
												{
													gO.pOList[i].dList[j].gestureDelta = functionGenerator(gO.pOList[i].dList[j].func, gO.pOList[i].dList[j].gestureDelta , gO.pOList[i].dList[j].func_factor);
												}
												else 
												{
													gO.pOList[i].dList[j].gestureDelta = gO.pOList[i].dList[j].func_factor * gO.pOList[i].dList[j].gestureDelta;
												}
											}
								
										
											
											
											
											///////////////////////////////////////////////////////////////////////////////////////////
											// DELTA FILTER
											// limits gesture deltas to delta min value
											// reduces the number of events and unnesesary transformations by zeroing small deltas
											//////////////////////////////////////////////////////////////////////////////////////////
											
											if (ts.trace_debug_mode) trace("delta threshold", gO.pOList[i][j].delta_threshold);
											
											if (gO.pOList[i].dList[j].delta_filter)
											{
												/*
												if ((Math.abs(ts.gO.pOList[i][j].gestureDelta) < ts.gO.pOList[i][j].delta_min) || ( Math.abs(ts.gO.pOList[i][j].gestureDelta) > ts.gO.pOList[i][j].delta_max))
												{
													//trace("delta threshold met, set to zero",i,ts.gO.pOList[i][j].gestureDelta)
													ts.gO.pOList[i][j].gestureDelta = 0;
													//if (ts.trace_debug_mode) 
													
												}*/
												
												if (Math.abs(gO.pOList[i].dList[j].gestureDelta) < gO.pOList[i].dList[j].delta_min) gO.pOList[i].dList[j].gestureDelta = 0;
												if ( Math.abs(gO.pOList[i].dList[j].gestureDelta) > gO.pOList[i].dList[j].delta_max) gO.pOList[i].dList[j].gestureDelta = gO.pOList[i].dList[j].delta_max;
											}
											
											
											
											
											////////////////////////////////////////////////////////////////////////////////////////////
											// VALUE FILTER
											// limit gesture values 
											// allows for value bounds so that gestures mapped to known object properties can be managed
											/////////////////////////////////////////////////////////////////////////////////////////////
											
											if (ts.gO.pOList[i].dList[j].boundary_filter) 
											{
												//trace(ts.gO.pOList[i].dList[j].boundary_filter,ts.gO.pOList[i].dList[j].boundary_min,ts.gO.pOList[i].dList[j].boundary_max);
												//trace(ts.gO.pOList[i][j].gestureValue);
												//trace(ts.gO.pOList[i][j].target_id,ts.gO.pOList[i][j].gestureValue);
												
												if (Math.abs(gO.pOList[i].dList[j].gestureValue) < gO.pOList[i].dList[j].boundary_min)//
												{
													if (gO.pOList[i].dList[j].gestureDelta < 0) 
													{
														gO.pOList[i].dList[j].gestureDelta = 0;
														//trace("below min");
														//if ((ts.gO.pOList[i][j].target_id == "dx") || (ts.gO.pOList[i][j].target_id == "dy")) 
														//ts.trO.dtheta = 0;
														//ts.gO.pOList[i]["dtheta"].gestureDelta = 0;
														//ts.trO["dtheta"] = 0;
														//ts.dtheta = 0;
														
														//if ((ts.gO.pOList[i][j].target_id == "dx") || (ts.gO.pOList[i][j].target_id == "dy"))  xy_lock = true; 
													}
												}
												if (Math.abs(gO.pOList[i].dList[j].gestureValue) > gO.pOList[i].dList[j].boundary_max) 
												{
													if (gO.pOList[i].dList[j].gestureDelta > 0) 
													{
														gO.pOList[i].dList[j].gestureDelta = 0;
														//trace("above max");
														//if ((ts.gO.pOList[i][j].target_id == "dx") || (ts.gO.pOList[i][j].target_id == "dy")) 
														//ts.trO.dtheta = 0;
														
														//ts.gO.pOList[i]["dtheta"].gestureDelta = 0;
														//ts.trO["dtheta"] = 0;
														//ts.dtheta = 0;
														//if ((ts.gO.pOList[i][j].target_id == "dx") || (ts.gO.pOList[i][j].target_id == "dy"))  xy_lock = true; 
													}
												}
												//trace(xy_lock);
												// rotate lock when out of xy bounds
												//if ((ts.gO.pOList[i][j].target_id == "dtheta")&&(xy_lock)) 
													//{
														//ts.gO.pOList[i][j].gestureDelta = 0;
														//trace("lock rotate");
													//}
													
											}
											
											
										
								}
								
								/////////////////////////////////////////////////////////////////////////////
								//fill cahche
								//////////////////////////////////////////////////////////////////////////////
								// cache reset only when delta is non zero 
								// otherwise cluster delta is zerod and cache zerod before cched value is pushed into gesure event
								if(gO.pOList[i].dList[j].gestureDelta != 0) gO.pOList[i].dList[j].gestureDeltaCache = gO.pOList[i].dList[j].gestureDelta;
								//trace("pipeline end", gO.pOList[i].dList[j].gestureDeltaCache)
								
								///////////////////////////////////////////////////////////////////////////////////////////////
								// END FILTER BLOCK
								///////////////////////////////////////////////////////////////////////////////////////////////
								
								// ENSURES ADDITIVE DELTAS DO NOT ACCUMILATE OUTSIDE OF EACH "FRAME"
								// 	MUST HAPPEN BEFIORE MAPPING OTHERWISE GESTURES THAT MAP DELTAS TO SAME VAR WILL BE OVERWITTEN
								if (gO.pOList[i].dList[j].target_id) trO[ts.gO.pOList[i].dList[j].target_id] = 0;
								
								////////////////////////////////////////////////////////////////////////////////////////////////////
								// active gesture event switch
								// deactivates gesture processing on gesture object if gesture deltas are zero for each dimention
								// is overrriden when object is touched ( when cluster analysis occures
								////////////////////////////////////////////////////////////////////////////////////////////////////
								if (gO.pOList[i].dList[j].gestureDelta != 0) gO.pOList[i].activeEvent = true;
								//trace("gesturedelta",gO.pOList[i].dList[j].gestureDelta)
						}	
						
						
									
			}
			
			////////////////////////////////////////////////////////////////////////////////////////////////////
			// mapping defined native  property values
			// map gesture object into transform object
			////////////////////////////////////////////////////////////////////////////////////////////////////
			// NEEDS TO BE SPERATE FROM MAIN PROCESSING LOOPE SO THAT FLITERS CAN BE INDEPENDANTLY TURNED OFF
			
			
			/////////////////////////////////////////////////////////////////////////////////////////////////////////
			// core transform properties //default map for direct gesture manipulations
			/////////////////////////////////////////////////////////////////////////////////////////////////////////
									
						trO.x =	cO.x; // NEED FOR AFFINE TRANSFORM NON NATIVE
						trO.y =	cO.y; // NEED FOR AFFINE TRANSFORM NON NATIVE
						trO.width = cO.width
						trO.height = cO.height
						trO.radius = cO.radius
						trO.scale = cO.separation
						trO.scaleX = cO.separationX
						trO.scaleY = cO.separationY
						trO.rotation = cO.rotation
						trO.orientation = cO.orientation
			
			////////////////////////////////////////////////////////////////////////////////////////////////////////
			// map dynamic cluster deltas results into gesture object
			////////////////////////////////////////////////////////////////////////////////////////////////////////
			if (!ts.disableNativeTransform)
			{	
			
				for (i=0; i < gn; i++) 
					{
						var dn:uint = gO.pOList[i].dList.length;
						for (j=0; j < dn; j++) 
							{
							if (gO.pOList[i].dList[j].target_id)
								{
									// map transform limits
									if (gO.pOList[i].dList[j].target_id == "dsx") gO.pOList[i].dList[j].gestureValue = trO.obj_scaleX;
									if (gO.pOList[i].dList[j].target_id == "dsy") gO.pOList[i].dList[j].gestureValue = trO.obj_scaleY;
									if (gO.pOList[i].dList[j].target_id == "dtheta") gO.pOList[i].dList[j].gestureValue = trO.obj_rotation;
									//if (gO.pOList[i][j].target_id == "dthetaX") gO.pOList[i][j].gestureValue = trO.obj_rotationX;
									//if (gO.pOList[i][j].target_id == "dthetaY") gO.pOList[i][j].gestureValue = trO.obj_rotationY;
									//if (gO.pOList[i][j].target_id == "dthetaZ") gO.pOList[i][j].gestureValue = trO.obj_rotationZ;
									if (gO.pOList[i].dList[j].target_id == "dx") gO.pOList[i].dList[j].gestureValue = trO.obj_x;
									if (gO.pOList[i].dList[j].target_id == "dy") gO.pOList[i].dList[j].gestureValue = trO.obj_y;
								
									// ENSURE DELTAS MAPPED TO THE SAME PROPERTY ARE ADDITIVE IN A "FRAME"
									trO[gO.pOList[i].dList[j].target_id] += gO.pOList[i].dList[j].gestureDelta;
									if (ts.trace_debug_mode) trace("gesture data", i, j, gO.pOList[i].dList[j].gestureDelta, trO[ts.gO.pOList[i].dList[j].target_id]);
													
									//trace("target_values", ts.trO[ts.gO.pOList[i][j].target_id]);
									}
								}					
					}
				//trace("testing", trO.obj_rotation);	
			}
			
			
			////////////////////////////////////////
			// accumulate gesture states to set global gesture object state
			// check no gesture is tweening
			// confirm gesture states
			////////////////////////////////////////
			if (gO.active)
			{
				// close tween
				ts.gestureTweenOn = false;
				
				// check for open tween
				for (i=0; i < gn; i++) 
				{
					if (!ts.gestureTweenOn) // if desired condition not already met
					{
						var dn0:uint = gO.pOList[i].dList.length;
						for (j = 0; j < dn0; j++) if ((gO.pOList[i].dList[j].release_inertiaOn)) ts.gestureTweenOn = true;
					}
				}
				
				//NOTE WILL NEED TO MAKE GESTURE OBJECT SPECIFIC
				// global logic
				 if ((!ts.gestureTweenOn)&&(ts.gO.passive)||(!ts.gestureTweenOn)&&(gO.release)) // must force state to wait for passive phase change
				 {
					gO.active = false;
					gO.passive = false;
					gO.complete = true;
				}
			}
			
			//////////////////////////////////////////////////////////////////////////////
		}
		
		private function functionGenerator(type:String,b:Number,k:Number):Number {
			
			var a:Number;
				if (type == "linear") 			a = b * k;
				else if (type == "quadratic") 	a = b * b * k; //FIX NEGATIVE
				else if (type == "cubic") 		a = b * b * b * k;
				else if (type == "exp2") 		a = Math.pow(2, k * b);
				else if (type == "exp10") 		a = Math.pow(10, k * b);
			return a
		}
	}
}