////////////////////////////////////////////////////////////////////////////////
//
//  IDEUM
//  Copyright 2011-2012 Ideum
//  All Rights Reserved.
//
//  GestureWorks
//
//  File:    TouchSpriteCluster.as
//  Authors:  Ideum
//             
//  NOTICE: Ideum permits you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////
package com.gestureworks.core
{
	import com.gestureworks.events.GWClusterEvent;
	import com.gestureworks.analysis.KineMetric;
	import com.gestureworks.analysis.VectorMetric;
	//import com.gestureworks.analysis.GeoMetric;
	
	import com.gestureworks.objects.GestureObject;
	import flash.geom.Point;
	import flash.display.DisplayObject;
	//import com.gestureworks.analysis.VectorMetric;
	
	import com.gestureworks.objects.ClusterObject;
	import com.gestureworks.objects.GestureListObject;
	import com.gestureworks.objects.TimelineObject;
	
	import com.gestureworks.objects.DimensionObject;
	
	//use namespace id_internal;
	
	/**
	* @private
	*/
	public class TouchCluster
	{
		/**
		* @private
		*/
		private var cluster_kinemetric:KineMetric;
		public var cluster_vectormetric:VectorMetric;
		//private var cluster_geometric:GeoMetric;
		
		/**
		* @private
		*/
		private var kinemetricsOn:Boolean = true;
		private var vectormetricsOn:Boolean = true;
		private var geometricsOn:Boolean = true;
		
		private var gn:uint;
		private var key:uint;
		private var DIM:uint; 
		private var ts:Object;
		private var id:int;
		
		private var gO:GestureListObject;
		private var cO:ClusterObject
		private var tiO:TimelineObject
		
		public function TouchCluster(touchObjectID:int):void
		{
			
			id = touchObjectID;
			ts = GestureGlobals.gw_public::touchObjects[id];
			
			gO = ts.gO;
			cO = ts.cO;
			tiO = ts.tiO;
			
			initCluster();
          }
		  
		/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		// initializers
		/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        /**
		 * @private
		 */
        private function initCluster():void 
        {	
				initClusterVars();
				initClusterAnalysis();
				initClusterAnalysisConfig();
		}
		/**
		 * @private
		 */
		private function initClusterVars():void 
		{
				// set constructor logic 
				kinemetricsOn = true;
				vectormetricsOn = true;	
				geometricsOn = true;	
		}
		/**
		 * @private
		 */
		private function initClusterAnalysis():void
		{
			//trace("init cluster analysis", touchSprite_id);
							
					// analyzes and characterizes multi-point motion
					if (kinemetricsOn) cluster_kinemetric = new KineMetric(id);

					// analyzes and characterizes multi-point paths to match against established strokes
					if (vectormetricsOn) cluster_vectormetric = new VectorMetric(id);
					
					// characterizes advanced relative geometry of a cluster
					//if(geometricsOn)cluster_geometric = new GeoMetric(id);
		}
		/**
		 * @private
		 */
		private function initClusterAnalysisConfig():void
			{
				// analyzes and characterizes multi-point motion
				if (kinemetricsOn)		cluster_kinemetric.init();
				//if (vectormetricsOn)	cluster_vectormetric.init();
				//if(geometricsOn)		//cluster_geometric.init();
							
		}
		/**
		 * @private
		 */
		// internal public
		public function updateClusterCount():void 
		{
			//trace("update cluster count");
			
			// FIND CLUSTER COUNT
			cO.n = cO.pointArray.length
			ts.dN = cO.n - ts.N;
			ts.N = cO.n;
			
			
			// CLUSTER OBJECT UPDATE
			
			// reset cluster states
			cO.point_remove = false;
			cO.point_add = false;
			cO.remove = false; 
			cO.add = false;
			
			
				if (ts.dN < 0) 
				{
					cO.point_remove = true;
					//cO.point_add = false;
					
					if (ts.N == 0) 
					{
						cO.remove = true; 
						//cO.add = false;
					}
				}
				else if (ts.dN > 0) 
				{
					//cO.point_remove = false;
					cO.point_add = true;
					
					if (ts.N != 0)
					{
					//cO.remove = false; 
					cO.add = true; 
					}
				}
			
			if (ts.dN != 0)
			{
				if (ts.clusterEvents) manageClusterEventDispatch();
			}
			//trace(_dN, _N, cO.point_remove,cO.point_add,cO.remove,cO.add)
			
			
			
			///////////////////////////////////////////////////
			// move to pipeline
			///////////////////////////////////////////////////
			// GESTURE OBJECT UPDATE
			if (ts.dN > 0) ts.gO.start = true;
			
			if (ts.N != 0) 
			{
				gO.active = true;
				gO.complete = false;
				gO.release = false;
			}
			else {
				if (ts.dN < 0) 
				{
					gO.release = true;
					gO.passive = true;
				}
			}
			///////////////////////////////////////////////////
			
			//trace(_dN, _N, cO.point_remove);
			
			///////////////////////////////////////////////////////////////////////////////////////
			////////////////////////////////////////////////////////////////////////////////////////
			////FIND MOTION CLUSTER COUNT
			
			//motion point update
			cO.hn = cO.motionArray.hands.length;
			
			if(cO.hn!=0){
			//trace("hands",cO.hn)
			
			if (cO.hn == 2){ cO.fn = cO.motionArray.hands[0].fingers.length; + cO.motionArray.hands[1].fingers.length;}
			else if (cO.hn == 1) cO.fn = cO.motionArray.hands[0].fingers.length;
			else cO.fn = 0;
			
			//trace("total fingers", cO.fn)
			}
			//////////////////////////////////////////////////////////////////////////////////////////
			//////////////////////////////////////////////////////////////////////////////////////////
			
		}
		/**
		 * @private
		 */
		// internal public
		public function updateClusterAnalysis():void
			{
				//trace("update cluster analysis")
				updateClusterCount();
				getCluster()
				
				if(kinemetricsOn) 	getKineMetrics();
				if(vectormetricsOn)	getVectorMetrics();
				//if(geometricsOn)	getGeoMetrics();
				
				if ((ts.clusterEvents)&&(ts.N)) manageClusterPropertyEventDispatch();
		}
		
		
		public function updateMotionClusterAnalysis():void
			{
				//cluster_kinemetric.findMeanInst3DMotionTransformation();
		}
		
		public function updateSensorClusterAnalysis():void
			{
				//cluster_kinemetric.findSensorJolt();
		}
		
		
		public function getCluster():void 
		{
			//trace("TouchSprite findcluster update-----------------------------",GestureGlobals.frameID, _N);
			gn = gO.pOList.length;
			
			cluster_kinemetric.findClusterConstants();
			cluster_kinemetric.resetCluster();
			cluster_kinemetric.findInstDimention();
		}
		
		public function getVectorMetrics():void 
		{
			// for unistroke only
			if (ts.N == 1)
			{
				cluster_vectormetric.resetPathProperties(); // reset stroke data object
				cluster_vectormetric.getSamplePath(); // collect sample path
			}
			
			// multistroke next
		}
		
		public function getKineMetrics():void 
		{
		//cluster_kinemetric.findMeanInstTransformation();
		
		
			
			gn = gO.pOList.length;
			var dn:uint 
			
			//trace("-touch cluster -----------------------------",gn);
			
			for (key = 0; key < gn; key++) 
			//for (key in gO.pOList) //if(gO.pOList[key] is GesturePropertyObject)
			{
				
				// if gesture object is active in gesture list
				if (ts.gestureList[gO.pOList[key].gesture_id])
				{
				
					// set dim length
					dn = gO.pOList[key].dList.length;
					
					// zero cluster deltas
					for (DIM=0; DIM < dn; DIM++) gO.pOList[key].dList[DIM].clusterDelta = 0;	
					
					var g:GestureObject = gO.pOList[key];
					
					// processing algorithms when in touch
					if(ts.N!=0){		// check kinemetric and if continuous analysis
						// check point number requirements
						if((ts.N >= g.nMin)&&(ts.N <= g.nMax)||(ts.N == g.n))
						{
							//trace("call cluster calc",ts.N);
							
							
							// activate all by default
							g.activeEvent = true;
							
							if (g.algorithm_class == "kinemetric")
							{
									//trace("kinemetric algorithm",gO.pOList[key].algorithm);
									
									// BASIC DRAG/SCALE/ROTATE CONTROL // ALGORITHM // type manipulate
									if (g.algorithm == "manipulate") 	cluster_kinemetric.findMeanInstTransformation();
									
									// BASIC DRAG CONTROL // ALGORITHM // type drag
									if (g.algorithm == "drag")			cluster_kinemetric.findMeanInstTranslation();
									if (g.algorithm == "translate")			cluster_kinemetric.findMeanInstTranslation();

									// BASIC SCALE CONTROL // ALGORITHM // type scale
									if (g.algorithm == "scale")		cluster_kinemetric.findMeanInstSeparation();
								
									// BASIC ROTATE CONTROL // ALGORITHM // type rotate
									if (g.algorithm == "rotate")		cluster_kinemetric.findMeanInstRotation();
									
									// BASIC ORIENTATION CONTROL // ALGORITHM
									if (g.algorithm == "orient")		cluster_kinemetric.findInstOrientation();

									// BASIC PIVOT CONTROL // ALGORITHM
									if (g.algorithm == "pivot")		cluster_kinemetric.findInstPivot();
									
									///////////////////////////////////////////////////////////////////////////////////////
									// CLUSTER PROEPRTY LIMIT CONTROLLED DELTAS
									
									// BASIC SCROLL CONTROL // ALGORITHM
									// CONTINUOUS// MIN TRANSLATION IN X AND Y// VELOCITY MUST BE ABOVE MIN VALUE
									// RETURN AVERAGE ENSABLE TEMPORAL VELOCITY 
									if (g.algorithm == "scroll")	cluster_kinemetric.findMeanTemporalVelocity(); // ensamble temporal mean velocity

									// BASIC TILT CONTROL // ALGORITHM
									// CONTINUOUS// LOOK FOR SEPARATION OF CLUSTER IN X AND Y DIRECTION//SEPARATION MUST BE ABOVE MIN VALUE// LOCKED INTO 3 POINT EXCLUSIVE ACTIVATION
									// RETURN DX AND DY
									if (g.algorithm == "tilt")	cluster_kinemetric.findMeanInstSeparation();
									
									// BASIC FLICK CONTROL // ALGORITHM
									// SHOULD BE DISCRETE ON RELEASE // IF BETWEEN ACCEL THREHOLD RETURN GESTURE
									if ((g.algorithm == "flick")||(g.algorithm == "swipe"))
									{
										cluster_kinemetric.findMeanTemporalVelocity(); // ensamble temporal mean velocity
										cluster_kinemetric.findMeanTemporalAcceleration(); //ensamble temporal mean acceleration
									}
									
									
									///////////////////////////////////////////////////////////////////////////////////////////////////
									// MOVE TO TEMPORAL METRIC
									// BASIC HOLD CONTROL // ALGORITHM // type hold
									if (g.algorithm == "hold")
									{
										//if (trace_debug_mode) trace("cluster hold algorithm");
								
										var hold_number:int = ts.N;//gO.pOList[key].n; // REDUNDANT AS ONLY CALLED IF MEETS N CRITERIA
										var hold_dist:int = g.point_translation_max;
										var	hold_time:int = Math.ceil(g.point_event_duration_min/ GestureGlobals.touchFrameInterval);
									
										cluster_kinemetric.findLockedPoints(hold_dist, hold_time, hold_number);	
										
										if(!cO.hold_n)	g.activeEvent = false;
			
									}
									
									

									///////////////////////////////////////////////////////////////////////////////////
									// LIMIT DELTA BY CLUSTER VALUES
									/////////////////////////////////////////////////////////////////////////////////////
									g.activeEvent = false;
									
										for (DIM = 0; DIM < dn; DIM++) 
										{
											var gdim:DimensionObject = g.dList[DIM];
												gdim.activeDim = true; // ACTIVATE DIM
											var res:String = gdim.property_result
											
											
											////////////////////////////////////////////////////
											// CHECK FOR CLUSTER PROEPERTY VALUE LIMITS IF EXIST
											////////////////////////////////////////////////////
											
											// WHEN PROPERTY LIMITS ESTABLISHED
											// ONLY USES ONE VAR PER PROPERTY BUT COULD BE EXTENDED
											// STILL NEED TO MAP RETURN TO RESULT
											if (gdim.property_vars[0])
											{
												var num:Number = Math.abs(cO[gdim.property_vars[0]["var"]]);
												var dim_var:Number = 0;
													
												// when max and min
												if ((gdim.property_vars[0]["min"] != null) && (gdim.property_vars[0]["max"] != null))
												{
													if ((num >= gdim.property_vars[0]["min"])&&(num <= gdim.property_vars[0]["max"]))	gdim.clusterDelta = cO[res];//dim_var = num;
													else gdim.clusterDelta = 0;//dim_var = 0;
												}
												// when min
												else if(gdim.property_vars[0]["min"] != null) 
												{	
													if (num >= gdim.property_vars[0]["min"])	{
														gdim.clusterDelta = cO[res];//dim_var = num;
														//trace("MIN",num)
													}
													else gdim.clusterDelta = 0//dim_var = 0;
												}
												// when max 
												else if (gdim.property_vars[0]["max"] != null) 
												{	
													if (num <= gdim.property_vars[0]["max"])	gdim.clusterDelta = cO[res];//dim_var = num;
													else gdim.clusterDelta = 0;//dim_var = 0;
												}
												// when no limits
												else gdim.clusterDelta = cO[res];//dim_var = num;
											}
											//WHEN THERE ARE NO LIMITS IMPOSED
											else gdim.clusterDelta = cO[res];//rtn_dim = 1;
											/////////////////////////////////////////////////////////////
											
											
											//CLOSE DIM IF NO VALUE
											if (gdim.clusterDelta == 0) gdim.activeDim = false;
											//trace("GESTURE OBJECT", res, cO[res], gdim.clusterDelta);
											
											// CLOSE GESTURE OBJECT IF ALL DIMS INACTIVE
											if (gdim.activeDim) g.activeEvent = true;
										}


										g.data.x = cO.x;
										g.data.y = cO.y;
										g.data.n = cO.n;
										
										//////////////////////////////////////////////////////////////////
										//////////////////////////////////////////////////////////////////
										
										//if ((g.activeEvent) && (g.dispatchEvent))
										//trace("CLUSTER OBJECT","dx",cO["dx"],"dy",cO["dx"], "etm_dx",cO["etm_dx"],"etm_dy", cO["etm_dy"],"ddx", cO["etm_ddx"],"ddy", cO["etm_ddy"])
									
							}
							///////////////////////////////////////////////////
						}
				}
				
				// processing algorithms when in motion
					if(ts.cO.fn!=0){		// check kinemetric and if continuous analysis
						// check point number requirements
						//if((ts.N >= g.nMin)&&(ts.N <= g.nMax)||(ts.N == g.n))
						//{
							//trace("call motion cluster calc",ts.cO.fn);

							// activate all by default
							g.activeEvent = true;
							
							if (g.algorithm_class == "kinemetric")
							{
									//trace("kinemetric algorithm",gO.pOList[key].algorithm);
									
									// BASIC 3D DRAG/SCALE/ROTATE CONTROL // ALGORITHM // type manipulate
									if (g.algorithm == "3d_manipulate") cluster_kinemetric.findMeanInst3DMotionTransformation();
									
									// BASIC 3D DRAG // ALGORITHM // type drag
									//if (g.algorithm == "3d_translate") 	cluster_kinemetric.findMeanInst3dMotionTranslation();
									if (g.algorithm == "3d_translate") 	cluster_kinemetric.findMeanInst3DMotionTransformation();
									
									///////////////////////////////////////////////////////////////////////////////////
									// LIMIT DELTA BY CLUSTER VALUES
									/////////////////////////////////////////////////////////////////////////////////////
									g.activeEvent = false;
									
										for (DIM = 0; DIM < dn; DIM++) 
										{
											var gdim:DimensionObject = g.dList[DIM];
												gdim.activeDim = true; // ACTIVATE DIM
											var res:String = gdim.property_result
											
											//WHEN THERE ARE NO LIMITS IMPOSED
											gdim.clusterDelta = cO[res];//rtn_dim = 1;

											//CLOSE DIM IF NO VALUE
											if (gdim.clusterDelta == 0) gdim.activeDim = false;
											//trace("GESTURE OBJECT", res, cO[res], gdim.clusterDelta);
											
											// CLOSE GESTURE OBJECT IF ALL DIMS INACTIVE
											if (gdim.activeDim) g.activeEvent = true;
										}


										g.data.x = cO.x;
										g.data.y = cO.y;
										g.data.z = cO.z;
										g.data.hn = cO.hn;
										g.data.fn = cO.fn;
										
										//////////////////////////////////////////////////////////////////
										//////////////////////////////////////////////////////////////////
										
										//if ((g.activeEvent) && (g.dispatchEvent))
										//trace("CLUSTER OBJECT","dx",cO["dx"],"dy",cO["dx"], "etm_dx",cO["etm_dx"],"etm_dy", cO["etm_dy"],"ddx", cO["etm_ddx"],"ddy", cO["etm_ddy"])
									
							//}
							///////////////////////////////////////////////////
						}
				}
				
				
				
				
				//else {
					//trace("processing algorithm when NOT touching");
				//}

				}
			}
		}

		
		
		/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
		/**
		 * @private
		 */
		private function manageClusterEventDispatch():void 
		{	
				// point added to cluster
				if (cO.point_add)
				{
						ts.dispatchEvent(new GWClusterEvent(GWClusterEvent.C_POINT_ADD, {n:cO.n, id:"bob"}));
						if((tiO.timelineOn)&&(tiO.clusterEvents)) tiO.frame.clusterEventArray.push(new GWClusterEvent(GWClusterEvent.C_POINT_ADD, {n:cO.n}));
						cO.point_add = false;
				}
				// point removed cluster
				if (ts.cO.point_remove) 
				{
						ts.dispatchEvent(new GWClusterEvent(GWClusterEvent.C_POINT_REMOVE, {n:cO.n}));
						if((tiO.timelineOn)&&(tiO.clusterEvents)) tiO.frame.clusterEventArray.push(new GWClusterEvent(GWClusterEvent.C_POINT_REMOVE, {n:cO.n}));
						ts.cO.point_remove = false;
				}
				// cluster add
				if (ts.cO.remove)
				{
						ts.dispatchEvent(new GWClusterEvent(GWClusterEvent.C_REMOVE, {id:cO.id}));
						if((tiO.timelineOn)&&(tiO.clusterEvents))ts.tiO.frame.clusterEventArray.push(new GWClusterEvent(GWClusterEvent.C_REMOVE,  {id:cO.id}));
						ts.cO.remove = false;
				}
				// cluster remove
				if (ts.cO.add) 
				{
						ts.dispatchEvent(new GWClusterEvent(GWClusterEvent.C_ADD, {id:cO.id}));
						if((tiO.timelineOn)&&(tiO.clusterEvents)) tiO.frame.clusterEventArray.push(new GWClusterEvent(GWClusterEvent.C_ADD,  {id:cO.id}));
						cO.add = false;
				}	
		}
		
		/**
		 * @private
		 */
		private function manageClusterPropertyEventDispatch():void 
		{
				// cluster translate
				if ((cO.dx!=0)||(cO.dy!=0)) 
				{
					ts.dispatchEvent(new GWClusterEvent(GWClusterEvent.C_TRANSLATE, { dx:cO.dx, dy:cO.dy, n:cO.n }));
					if((tiO.timelineOn)&&(tiO.clusterEvents)) tiO.frame.clusterEventArray.push(new GWClusterEvent(GWClusterEvent.C_TRANSLATE, { dx:cO.dx, dy:cO.dy, n:cO.n }));
				}
				// cluster rotate
				if (cO.dtheta!=0)
				{
					ts.dispatchEvent(new GWClusterEvent(GWClusterEvent.C_ROTATE, {dtheta:cO.dtheta, n:cO.n }));
					if((tiO.timelineOn)&&(tiO.clusterEvents)) tiO.frame.clusterEventArray.push(new GWClusterEvent(GWClusterEvent.C_ROTATE, {dtheta:cO.dtheta, n:cO.n}));
				}
				//cluster separate
				if ((cO.dsx!=0)||(cO.dsy!=0)) 
				{
					ts.dispatchEvent(new GWClusterEvent(GWClusterEvent.C_SEPARATE, { dsx:cO.dsx, dsy: cO.dsy, n:cO.n }));
					if((tiO.timelineOn)&&(tiO.clusterEvents)) tiO.frame.clusterEventArray.push(new GWClusterEvent(GWClusterEvent.C_SEPARATE,{ dsx:cO.dsx, dsy:cO.dsy, n:cO.n }));
				}
				// cluster resize
				if ((cO.dw!=0)||(cO.dh!=0)) 
				{
					ts.dispatchEvent(new GWClusterEvent(GWClusterEvent.C_RESIZE, { dw:cO.dw, dh:cO.dh, n:cO.n }));
					if((tiO.timelineOn)&&(tiO.clusterEvents)) tiO.frame.clusterEventArray.push(new GWClusterEvent(GWClusterEvent.C_RESIZE, { dw:cO.dw, dh:cO.dh, n:cO.n }));
				}
				/////////////////////////////////////////////////////////////////////////////
				// cluster accelerate
				if ((cO.ddx!=0)||(cO.ddy!=0))
				{
					ts.dispatchEvent(new GWClusterEvent(GWClusterEvent.C_ACCELERATE, { ddx:cO.ddx, ddy:cO.ddy, n:cO.n }));
					if((tiO.timelineOn)&&(tiO.clusterEvents)) tiO.frame.clusterEventArray.push(new GWClusterEvent(GWClusterEvent.C_ACCELERATE, { ddx:cO.ddx, ddy:cO.ddy, n:cO.n }));
				}
		}	
	}
}