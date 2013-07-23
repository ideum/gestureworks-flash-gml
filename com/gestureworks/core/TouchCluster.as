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
	import com.gestureworks.analysis.GeoMetric;
	import com.gestureworks.objects.GestureObject;
	
	import com.gestureworks.objects.ClusterObject;
	import com.gestureworks.objects.GestureListObject;
	import com.gestureworks.objects.TimelineObject;
	import com.gestureworks.objects.DimensionObject;
	
	import flash.geom.Point;
	import flash.display.DisplayObject;
	
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
		private var cluster_geometric:GeoMetric;
		
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
		public var core:Boolean;
		
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
					if (geometricsOn)cluster_geometric = new GeoMetric(id);
		}
		/**
		 * @private
		 */
		// internal public
		public function initClusterAnalysisConfig():void
			{
				// analyzes and characterizes multi-point motion
				if (kinemetricsOn)		cluster_kinemetric.init();
				if (vectormetricsOn)	cluster_vectormetric.init();
				if(geometricsOn)		cluster_geometric.init();
							
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
				
				if(geometricsOn)	getGeoMetrics(); // must preceed kinemetrics
				if(kinemetricsOn) 	getKineMetrics();
				if(vectormetricsOn)	getVectorMetrics();
				
				//trace("hand pos",cO.hand.position)
				
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
		
		public function getGeoMetrics():void 
		{
			//trace("TouchSprite findcluster update-----------------------------",GestureGlobals.frameID, _N);
			
			if (!core)
			{
				//trace("get core geometrics")
				
				//////////////////////////////////////////////////////
				// RESET CLUSTER
				//////////////////////////////////////////////////////
				cluster_geometric.resetGeoCluster();
				
				
				/////////////////////////////////////////////////////
				//BUILD SKELETAL MODEL FROM RAW MOTION POINTS
				/////////////////////////////////////////////////////
				
				// BASIC HAND
					cluster_geometric.clearHandData();	
					cluster_geometric.createHand(); // palm points // finger list palm ip 
				// SKELETAL DETAIL
					cluster_geometric.findFingerAverage();// finger average point// up down 
					cluster_geometric.normalizeFingerSize(); // norm lengths (palm distances)
					cluster_geometric.findHandRadius(); // favdist 
					cluster_geometric.findThumb(); // thumb // left// right
				// ADVANCED SKELETON
					//--cluster_geometric.findFingers(); // identify fingers
					//--cluster_geometric.findJoints(); // finger joints //knuckle / wrist
				////////////////////////////////////////////////
				
				
			
		
				
				
			// CHECK IP DEFINITION IN GML
			// FILTER BY TYPE 
			// APPLY KINEMETRIC BY IP TYPE
				
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
				
					//trace("matching gesture cluster input type",g.cluster_type)
						/////////////////////////////////////////////////////
						// ESTABLISH GLOBAL VIRTUAL INTERACTION POINTS SEEDS
						////////////////////////////////////////////////////
					if (g.cluster_input_type == "motion")
						{
						// FUNDAMENTAL INTERACTION POINTS
							if ((g.cluster_type == "finger")||(g.cluster_type == "all")) cluster_geometric.find3DFingerPoints(); 
							if ((g.cluster_type == "thumb")||(g.cluster_type == "all")) cluster_geometric.find3DThumbPoints(); 
							if ((g.cluster_type == "palm")||(g.cluster_type == "all")) cluster_geometric.find3DPalmPoints(); 
							if ((g.cluster_type == "finger_average")||(g.cluster_type == "all")) cluster_geometric.find3DFingerAveragePoints(); 
							
						//CONFIGURATION BASED INTERACTION POINTS
							if ((g.cluster_type == "pinch")||(g.cluster_type == "all")) cluster_geometric.find3DPinchPoints(); 
							if ((g.cluster_type == "trigger")||(g.cluster_type == "all"))cluster_geometric.find3DTriggerPoints(); 
							if ((g.cluster_type == "push")||(g.cluster_type == "all")) cluster_geometric.find3DPushPoints(); 
							if ((g.cluster_type == "hook")||(g.cluster_type == "all")) cluster_geometric.find3DHookPoints(); 
							if ((g.cluster_type == "frame")||(g.cluster_type == "all")) cluster_geometric.find3DFramePoints(); 
						
						// LATER
							//---cluster_geometric.find3DToolPoints();
							//---cluster_geometric.find3DRegionPoints();
							//---cluster_geometric.find3dTipTapPoints();
						}
					}
				}
			}
			
				
			
			// MUST USE INTERACTION POINT TRACKER TO INJECT INTERACTION POINTS BASED ON:
					//HIT TESTING
					//RAY CASTING
					//OR GLOBAL CLUSTERING ??
		}
		
		public function getKineMetrics():void 
		{		
	
			cluster_kinemetric.find3DIPConstants();
			cluster_kinemetric.find3DDimension();
			
			if (!core)
			{
				// move to 3d kinemetrics
				// FIND MOTION CHARACTER
				cluster_kinemetric.find3DIPConstants();
				cluster_kinemetric.find3DDimension();
				
				//cluster_kinemetric.find3DTapPoints();
				//cluster_kinemetric.find3DHoldPoints();
				//cluster_kinemetric.findMeanInst3DMotionTransformationIPA();
			}
			
			if ((!ts.transform3d)&&(ts.motion3d))
			{
				cluster_kinemetric.mapCluster3Dto2D();
			}
			
		
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
					
					
					////////////////////////////////////////////////////////////////////////////////////////////////////////////////
					// PROCESSING TOUCH KINEMETRICS
					// TOUCH POINTS
					///////////////////////////////////////////////////////////////////////////////////////////////////////////////
				
					if (ts.N != 0) // check kinemetric and if continuous analysis
					{		
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
																		//cluster_kinemetric.findSimpleMeanInstTransformation();
									
										// BASIC DRAG CONTROL // ALGORITHM // type drag
										if (g.algorithm == "drag")			cluster_kinemetric.findMeanInstTranslation();
										//if (g.algorithm == "translate")			cluster_kinemetric.findMeanInstTranslation();

										// BASIC SCALE CONTROL // ALGORITHM // type scale
										if (g.algorithm == "scale")		cluster_kinemetric.findMeanInstSeparation();
																		//cluster_kinemetric.findSimpleMeanInstSeparation();
									
										// BASIC ROTATE CONTROL // ALGORITHM // type rotate
										if (g.algorithm == "rotate")		cluster_kinemetric.findMeanInstRotation();
																			//cluster_kinemetric.findSimpleMeanInstRotation();
									
									
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
				/////////////////////////////////////////////////////////////////////////////////////////////////////////////
				// END TOUCH POINT KINEMETRIC PROCESSING
				//////////////////////////////////////////////////////////////////////////////////////////////////////////////
				
				
				
				
				//////////////////////////////////////////////////////////////////////////////////////////////////////////////
				//////////////////////////////////////////////////////////////////////////////////////////////////////////////
				// PROCESSING INTERACTION POINT KINEMETRICS
				// INTERACTION POINTS FROM
				// MOTION POINTS
				//////////////////////////////////////////////////////////////////////////////////////////////////////////////
				
				// processing algorithms when in motion
					if(ts.cO.fn!=0){		// check kinemetric and if continuous analysis
					
					////////////////////////////////////////////////
					// SKELETON MATCH
					/////////////////////////////////////////////////
					
					// MATCH NUMBER OF HANDS
							// 0 ANY
							// 1
							// 2
							// MATCH HANDEDNESS 
								// LEFT
								// RIGHT
							// MATCH HAND ORIENTATION
								// UP
								// DOWN
						// MATCH NUMBER OF THUMBS PER HAND
							//0 ANY
							//1
							// 2 NONE??
						// MATCH NUMBER OF FINGERS PER HAND
							//5/4/3/2/1 DIGITS
							//4/3/2/1 PURE FINGER
							
					//////////////////////////////////////////////////
					// SKELETON CONFIG MATCH
					//////////////////////////////////////////////////
						
					// MATCH INTERACTION POINT TYPE
								// NONE
								// PINCH
								// TRIGGER
								// HOOK
								// FINGER
								// THUMB
								// PALM
								// FAV
								// FRAME
								// PUSH 
								// REGION 
								// TOOL
								
					///////////////////////////////////////////////
					// MOTION MATCH
					///////////////////////////////////////////////
						
						// check point number requirements
						//if((ts.fn >= g.nMin)&&(ts.fn<= g.nMax)||(ts.fn == g.n))
						//{
							//trace("call motion cluster calc",ts.cO.fn,g.algorithm);

							// activate all by default
							g.activeEvent = true;
							
							if (g.algorithm_class == "3d_kinemetric")
							{
									// BASIC 3D DRAG/SCALE/ROTATE CONTROL // ALGORITHM // type manipulate
									if (g.algorithm == "3d_manipulate") cluster_kinemetric.findMeanInst3DMotionTransformation(); // PUSH INTERACTION POINT TYPE
									
									// BASIC 3D DRAG // ALGORITHM // type drag
									//if (g.algorithm == "3d_translate") 	cluster_kinemetric.findMeanInst3DMotionTranslation();
									
									// GENERIC 3D ROTATE
									//if (g.algorithm == "3d_rotate") 	cluster_kinemetric.findMeanInst3DMotionTranslation();
									
									//GENERIC 3D DCALE
									//if (g.algorithm == "3d_separate") 	cluster_kinemetric.findMeanInst3DMotionTranslation();
									
									// GENERIC TAP 
									//if (g.algorithm == "3d_tap") 	cluster_kinemetric.findMeanInst3DMotionTranslation();
									
									///////////////////////////////////////////////////////////////////////////////////
									// LIMIT DELTA BY CLUSTER VALUES
									/////////////////////////////////////////////////////////////////////////////////////
									g.activeEvent = false;
									
										for (DIM = 0; DIM < dn; DIM++) 
										{
											gdim = g.dList[DIM];
												gdim.activeDim = true; // ACTIVATE DIM
											res = gdim.property_result
											
											//WHEN THERE ARE NO LIMITS IMPOSED
											gdim.clusterDelta = cO[res];

											//CLOSE DIM IF NO VALUE
											if (gdim.clusterDelta == 0) gdim.activeDim = false;
											//trace("GESTURE OBJECT", res, cO[res], gdim.clusterDelta);
											
											// CLOSE GESTURE OBJECT IF ALL DIMS INACTIVE
											if (gdim.activeDim) g.activeEvent = true;
										}


										g.data.x = cO.x; // gesture position
										g.data.y = cO.y; // gesture position
										g.data.z = cO.z; // gesture position
										g.data.hn = cO.hn; // current hand number
										g.data.fn = cO.fn; // current finger total
										
										//////////////////////////////////////////////////////////////////
										//////////////////////////////////////////////////////////////////
										
										//if ((g.activeEvent) && (g.dispatchEvent))
										//trace("CLUSTER OBJECT","dx",cO["dx"],"dy",cO["dx"], "etm_dx",cO["etm_dx"],"etm_dy", cO["etm_dy"],"ddx", cO["etm_ddx"],"ddy", cO["etm_ddy"])
						//}	
							///////////////////////////////////////////////////
						}
				}
				///////////////////////////////////////////////////////////////////////////////////////////////////////////////
				// END IP KIMETRIC PROCESSING
				///////////////////////////////////////////////////////////////////////////////////////////////////////////////
				
				
				
				//else {
					//trace("processing algorithm when NOT touching");
				//}

				}
			}
			
			
			if ((!ts.transform3d)&&(ts.motion3d))
			{
				cluster_kinemetric.mapCluster3Dto2D();
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