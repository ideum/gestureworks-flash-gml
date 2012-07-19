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
package com.gestureworks.analysis 
{
	//import com.gestureworks.core.TouchSprite;
	
	import com.gestureworks.core.GestureGlobals;
	import com.gestureworks.core.gw_public;
	import com.gestureworks.objects.PropertyObject;
	
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
	
	public class gestureContinuous
	{
		/**
	 * A collection of gestures attached to this object.
	 */
		private var touchObjectID:int;
		
		private var ts:Object;//private var ts:TouchSprite;
		private var i:String;
		private var j:String;
		
		// translation limits -------------//
		/**
		* @private
		*/
		
		/*
		private var transLimits:Boolean = false;
		private	var x_max:Number = 600;
		private	var x_min:Number = 0.05;
		private	var y_max:Number = 600;
		private	var y_min:Number = 0.05;
		// scale limits --------------//
		private	var scaleLimits:Boolean = true;
		private	var scaleX_max:Number = 1;
		private	var scaleX_min:Number = 0.3;
		private	var scaleY_max:Number = 1;
		private	var scaleY_min:Number = 0.3;
		// rotation limits ----------------//
		private	var rotLimits:Boolean = false;
		private	var rotate_max:Number = 2*Math.PI;
		private	var rotate_min:Number = 0;
		*/
		
		// tween logic
		//private var gestureTween:Boolean = true;

		 /**
		 *  Constructor.
		 *  
		 * @langversion 3.0
		 * @playerversion AIR 1.5
		 * @playerversion Flash 10
		 * @playerversion Flash Lite 4
		 * @productversion GestureWorks 1.5
		 */ 
		public function gestureContinuous(_id:int) {
			
			touchObjectID = _id;
			init();
		}
		
		public function init():void
		{	
			ts = GestureGlobals.gw_public::touchObjects[touchObjectID];
		}
		
		public  function processPipeline():void
		{
			//trace("processing pipeline");
			
			/////////////////////////////////////////////////////////////////////////////////////////////////////////
			// core transform properties //default map for direct gesture manipulations
			/////////////////////////////////////////////////////////////////////////////////////////////////////////
									
						ts.trO.x =	ts.cO.x;
						ts.trO.y =	ts.cO.y;
						ts.trO.width = ts.cO.width
						ts.trO.height = ts.cO.height
						ts.trO.radius = ts.cO.radius
						ts.trO.scale = ts.cO.separation
						ts.trO.scaleX = ts.cO.separationX
						ts.trO.scaleY = ts.cO.separationY
						ts.trO.rotation = ts.cO.rotation
						ts.trO.orientation = ts.cO.orientation
			
			////////////////////////////////////////////////////////////////////////////////////////////////////////
			// map dynamic cluster deltas results into gesture object
			////////////////////////////////////////////////////////////////////////////////////////////////////////
			
			
			for (i in ts.gO.pOList)
				{	
						for (j in ts.gO.pOList[i])
						{
								if ((ts.gO.pOList[i][j] is PropertyObject))
								{
									//ts.gO.pOList[i][j].clusterDelta = 0;
									ts.gO.pOList[i][j].gestureDelta = 0;
								}
						}
				}
			
			for (i in ts.gO.pOList)
				{
					if (ts.gestureList[i])
					{
						// reset gesture event status
						ts.gO.pOList[i].activeEvent = false;
				
						
						for (j in ts.gO.pOList[i])
						{
								if ((ts.gO.pOList[i][j] is PropertyObject))
								{
									
									/////////////////////////////////////////
									// map filter properties
									// PULLED REFERENCE TO PROCESS DELTA
									/////////////////////////////////////////
									//if (ts.gO.pOList[i][j].processDelta != 0) 
									//ts.gO.pOList[i][j].gestureDelta = ts.gO.pOList[i][j].processDelta;
									
									ts.gO.pOList[i][j].gestureDelta = ts.gO.pOList[i][j].clusterDelta;
									
									//trace("cluster delta",i,j,ts.gO.pOList[i][j].clusterDelta);
									
									//if (i=="n-drag") trace(i,ts.gO.pOList[i][j].clusterDelta,ts.gO.pOList[i][j].gestureDelta)
									
									/*
									////////////////////////////////////////////
									// process gesture tweens
									///////////////////////////////////////////
									//if ((ts.N <= 1)&&(ts.gestureTweenOn)&&(ts.gO.pOList[i][j].release_inertiaOn)&&(ts.gO.pOList[i][j].release_inertia))
									if ((ts.N == 0)&&(ts.gestureTweenOn)&&(ts.gO.pOList[i][j].release_inertiaOn)&&(ts.gO.pOList[i][j].release_inertia))
									{
										//trace("tweening in pipeline",i,j, ts.gO.pOList[i][j].release_inertiaOn);
										
											var count:int = ts.gO.pOList[i][j].release_inertia_count;
											
											if ((count > ts.gO.pOList[i][j].release_inertia_Maxcount)||(Math.abs(ts.gO.pOList[i][j].gestureDelta) < ts.gO.pOList[i][j].delta_min))
												{
												ts.gO.pOList[i][j].release_inertiaOn = false;
												ts.gO.pOList[i][j].gestureDelta = 0;
												ts.gO.pOList[i][j].release_inertia_count = 0;
												}
											else {
												//trace("tween min", i,j, ts.gO.pOList[i][j].release_inertia_factor,ts.gO.pOList[i][j].release_inertia_base,ts.gO.pOList[i][j].gestureDelta);
										
												ts.gO.pOList[i][j].release_inertiaOn = true;
												ts.gO.pOList[i][j].gestureDelta *= ts.gO.pOList[i][j].release_inertia_factor * Math.pow(ts.gO.pOList[i][j].release_inertia_base, count);
												ts.gO.pOList[i][j].release_inertia_count++;
												}
									}*/
									
									
									
									/////////////////////////////////////////
									// MULTIPLY FILTER
									/////////////////////////////////////////
	
									if ((ts.gO.pOList[i][j].func) && (ts.gO.pOList[i][j].func_factor)) 
									{
										ts.gO.pOList[i][j].gestureDelta = functionGenerator(ts.gO.pOList[i][j].func, ts.gO.pOList[i][j].gestureDelta , ts.gO.pOList[i][j].func_factor);
									}
									else if (ts.gO.pOList[i][j].func_factor) ts.gO.pOList[i][j].gestureDelta = ts.gO.pOList[i][j].func_factor * ts.gO.pOList[i][j].gestureDelta;
									//else ts.gO.pOList[i][j].gestureDelta = ts.gO.pOList[i][j].gestureDelta;
								
									
									
									
									/////////////////////////////////////////
									// DELTA FILTER
									// limit gesture deltas
									/////////////////////////////////////////
									
									if (ts.trace_debug_mode) trace("delta threshold", ts.gO.pOList[i][j].delta_threshold);
									
									if (ts.gO.pOList[i][j].delta_threshold)
									{
										if ((Math.abs(ts.gO.pOList[i][j].gestureDelta) < ts.gO.pOList[i][j].delta_min) || ( Math.abs(ts.gO.pOList[i][j].gestureDelta) > ts.gO.pOList[i][j].delta_max))
										{
											//trace("delta threshold met, set to zero",i,ts.gO.pOList[i][j].gestureDelta)
											ts.gO.pOList[i][j].gestureDelta = 0;
											//if (ts.trace_debug_mode) 
											
										}
									}
									
									
									
									/////////////////////////////////////////
									// VALUE FILTER
									// limit gesture values 
									/////////////////////////////////////////
									
									if (ts.gO.pOList[i][j].boundaryOn) 
									{
										//trace(ts.gO.pOList[i][j].boundaryOn,ts.gO.pOList[i][j].boundary_min,ts.gO.pOList[i][j].boundary_max);
										//trace(ts.gO.pOList[i][j].gestureValue);
										//trace(ts.gO.pOList[i][j].target_id,ts.gO.pOList[i][j].gestureValue);
										
										if (Math.abs(ts.gO.pOList[i][j].gestureValue) < ts.gO.pOList[i][j].boundary_min)//
										{
											if (ts.gO.pOList[i][j].gestureDelta < 0) 
											{
												ts.gO.pOList[i][j].gestureDelta = 0;
												//trace("below min");
												//if ((ts.gO.pOList[i][j].target_id == "dx") || (ts.gO.pOList[i][j].target_id == "dy")) 
												//ts.trO.dtheta = 0;
												//ts.gO.pOList[i]["dtheta"].gestureDelta = 0;
												//ts.trO["dtheta"] = 0;
												//ts.dtheta = 0;
												
												//if ((ts.gO.pOList[i][j].target_id == "dx") || (ts.gO.pOList[i][j].target_id == "dy"))  xy_lock = true; 
											}
											
										}
										
										if (Math.abs(ts.gO.pOList[i][j].gestureValue) > ts.gO.pOList[i][j].boundary_max) 
										{
											if (ts.gO.pOList[i][j].gestureDelta > 0) 
											{
												ts.gO.pOList[i][j].gestureDelta = 0;
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
									
									
									
									///////////////////////////////////////////////////////////////////////////////////////////////////////////
									// 
									// map transform properties
									if (ts.gO.pOList[i][j].target_id) 
									{
										// ENSURES ADDITIVE DELTAS DO NOT ACCUMILATE OUTSIDE OF EACH "FRAME"
										ts.trO[ts.gO.pOList[i][j].target_id] = 0;
									}
									
									
									//// active gesture event switch
									//if (ts.gO.pOList[i][j].gestureDelta == 0) ts.gO.pOList[i].activeEvent = false;
									//else ts.gO.pOList[i].activeEvent = true;
									
									// active gesture event switch
									if (ts.gO.pOList[i][j].gestureDelta != 0) ts.gO.pOList[i].activeEvent = true;
								}
						}	
				}
			}
			
			// confirm gesture complete 
			// check no gesture is tweening
			//NOTE WILL MAKE GESTURE OBJECT SPECIFIC
			if (!ts.gestureTweenOn) ts.gO.complete = true;
			
			
							if (!ts.disableNativeTransform){
			
									//////////////////////////////////////////////////////////////////////////////////////////////////////////
									// dynamic delta properties
									//////////////////////////////////////////////////////////////////////////////////////////////////////////
									
									// MAP GESTURE PROPERTIES
									// map gesture object into transform object
									for (i in ts.gO.pOList)
										{
											if (ts.gestureList[i]) // check exists on gesture list
											{
											for (j in ts.gO.pOList[i])
											{
												if ((ts.gO.pOList[i][j] is PropertyObject)&&(ts.gO.pOList[i][j].target_id))
												{
													
													/////////////////////////////////////////
													// map transform limits
													if (ts.gO.pOList[i][j].target_id == "dsx") ts.gO.pOList[i][j].gestureValue = ts.trO.obj_scaleX;
													if (ts.gO.pOList[i][j].target_id == "dsy") ts.gO.pOList[i][j].gestureValue = ts.trO.obj_scaleY;
													if (ts.gO.pOList[i][j].target_id == "dtheta") ts.gO.pOList[i][j].gestureValue = ts.trO.obj_rotation;
													if (ts.gO.pOList[i][j].target_id == "dthetaX") ts.gO.pOList[i][j].gestureValue = ts.trO.obj_rotationX;
													if (ts.gO.pOList[i][j].target_id == "dthetaY") ts.gO.pOList[i][j].gestureValue = ts.trO.obj_rotationY;
													if (ts.gO.pOList[i][j].target_id == "dthetaZ") ts.gO.pOList[i][j].gestureValue = ts.trO.obj_rotationZ;
													if (ts.gO.pOList[i][j].target_id == "dx") ts.gO.pOList[i][j].gestureValue = ts.trO.obj_x;
													if (ts.gO.pOList[i][j].target_id == "dy") ts.gO.pOList[i][j].gestureValue = ts.trO.obj_y;
													
													// ENSURE DELTAS MAPPED TO THE SAME PROPERTY ARE ADDITIVE IN A "FRAME"
													ts.trO[ts.gO.pOList[i][j].target_id] += ts.gO.pOList[i][j].gestureDelta;
													if (ts.trace_debug_mode) trace("gesture data", i, j, ts.gO.pOList[i][j].gestureDelta, ts.trO[ts.gO.pOList[i][j].target_id]);
													
													//trace("target_values", ts.trO[ts.gO.pOList[i][j].target_id]);
												}
											}
										}
										}
										//trace("testing");
								}
			
								
			////////////////////////////////////////
			// tween shut down check
			////////////////////////////////////////
			// shut down
			ts.gestureTweenOn = false;
			
			/*
			//Open back up if release inertia still on 
			for (i in ts.gO.pOList)
			{
			for (j in ts.gO.pOList[i])
				{
				//if ((ts.gO.pOList[i][j] is PropertyObject) && (ts.gO.pOList[i][j].gestureDimensionTweenOn)) ts.gestureTweenOn = true;
				if ((ts.gO.pOList[i][j] is PropertyObject)&&(ts.gO.pOList[i][j].release_inertiaOn)) ts.gestureTweenOn = true;
				}
			}
			*/
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
		
		
		
		
		
		
		/*
		public function applyGestureValueTween():void
		{
			ts.gO.gestureTweenOn = false;
			
				for (i in ts.gO.pOList)
					{
						//if ((ts.gO.pOList[i]) && (ts.gestureList[i]))// check exists on gesture list
					//	{
							for (j in ts.gO.pOList[i])
							{
								if (ts.gO.pOList[i][j] is PropertyObject)
								{
									if ((ts.gO.pOList[i][j].release_inertiaOn) && (ts.gO.pOList[i][j].release_inertia)) applyDeltaEase(i, j);
									else ts.gO.pOList[i][j].gestureDelta = 0;  // NOT ZEROING VALUE ALLOWS TWEENING BETWEEN TOUCH MOVE FRAMES SMOOTING MOTION	
									
									if (ts.gO.pOList[i][j].release_inertiaOn) ts.gO.gestureTweenOn = true;
									else ts.gO.gestureTweenOn = false;
									
									if (ts.trace_debug_mode) trace(" eased gesture delta", ts.gO.pOList[i][j].gestureDelta);
								}
							}
						//}
				}
				if (!ts.gO.gestureTweenOn) ts.gO.complete = true;
		}*/
		
		/*
		public function applyDeltaEase(i:String, j:String ):void
		{
			//trace("aplying delta aease");
			var po:Object = ts.gO.pOList[i][j]
			var count:int = po.release_inertia_count++

			if ((count > po.release_inertia_Maxcount)||(Math.abs(po.gestureDelta) < po.delta_min))
				{
				po.release_inertiaOn = false;
				po.gestureDelta = 0;
				po.release_inertia_count = 0;
				}
			else {
				
				po.release_inertiaOn = true;
				po.gestureDelta *= po.release_inertia_factor * Math.pow(po.release_inertia_base, count);
				//trace("applying ease", po.gestureDelta);
				}
			//trace(j,po.gestureDelta,count);
		}*/
		
		// SHOULD TARGET GESTURE OBJECT AND DIMENTION DIRECT AS ABOVE
		public function restartGestureTween():void
		{
			ts.gestureTweenOn = true;
			
			for (i in ts.gO.pOList)
				{
					//if ((ts.gO.pOList[i]) && (ts.gestureList[i]))// check exists on gesture list
					//{
						for (j in ts.gO.pOList[i])
						{
							if (ts.gO.pOList[i][j] is PropertyObject)
							{
								ts.gO.pOList[i][j].release_inertiaOn = true;
								ts.gO.pOList[i][j].release_inertia_count = 0;
								if (ts.trace_debug_mode) trace("restart tween");
							}
						}
					//}
				}
			//trace("gesture tween restarted");
		}
		
		// SHOULD TARGE GESTURE OBJECT AND DIMENTION DIRECT AS ABOVE
		public function resetGestureTween():void
		{
			ts.gestureTweenOn = false;
			
			for (i in ts.gO.pOList)
				{	
				//if ((ts.gO.pOList[i]) && (ts.gestureList[i]))// check exists on gesture list
					//{
					for (j in ts.gO.pOList[i])
					{
						if (ts.gO.pOList[i][j] is PropertyObject)
						{
							ts.gO.pOList[i][j].release_inertiaOn = false;
							ts.gO.pOList[i][j].release_inertia_count = 0;
							ts.gO.pOList[i][j].gestureDelta = 0;
							if (ts.trace_debug_mode) trace("reset tween");
						}
					}
				//}
			}
			//trace("gesture tween reset");
		}
		//////////////////////////////////////////////////////////////////////////////////
		
	}
}