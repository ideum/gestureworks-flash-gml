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
	import com.gestureworks.analysis.CoreGeoMetric;
	import com.gestureworks.objects.GestureObject;
	
	import com.gestureworks.objects.TouchPointObject;
	import com.gestureworks.objects.MotionPointObject;
	import com.gestureworks.objects.ClusterObject;
	import com.gestureworks.objects.ipClusterObject;
	import com.gestureworks.objects.GestureListObject;
	import com.gestureworks.objects.TimelineObject;
	import com.gestureworks.objects.DimensionObject;
	import com.gestureworks.objects.InteractionPointObject;
	
	import flash.geom.Point;
	import flash.display.DisplayObject;
	import flash.utils.Dictionary;
		
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
		//private var cluster_geometric:CoreGeoMetric;
		
		private var gn:uint;
		private var key:uint;
		private var dn:uint 
		private var DIM:uint; 
		private var ts:Object;
		private var id:int;
		
		private var gO:GestureListObject;
		private var cO:ClusterObject
		private var tcO:ipClusterObject
		private var mcO:ipClusterObject
		private var scO:ipClusterObject
		private var tiO:TimelineObject
		
		public var motion_core:Boolean;
		public var touch_core:Boolean;
		public var sensor_core:Boolean;
		public var core:Boolean;
		public var core_init:Boolean= false;
		
		
		
		////////////////////////////////////////
		// define subcluster queries
		public var fingerPoints:Boolean = false; 
		public var thumbPoints:Boolean = false; 
		public var palmPoints:Boolean = false; 
		public var fingerAveragePoints:Boolean = false; 
		public var fingerAndThumbPoints:Boolean = false;
		public var pinchPoints:Boolean = false; 
		public var triggerPoints:Boolean = false; 
		public var pushPoints:Boolean = false; 
		public var hookPoints:Boolean = false; 
		public var framePoints:Boolean = false; 
		public var fistPoints:Boolean = false; 
		public var regionPoints:Boolean = false;
		public var toolPoints:Boolean = false;
		
		public var eyePoints:Boolean = false; 
		public var gazePoints:Boolean = false; 
		public var headPoints:Boolean = false; 
		
		//touch
		public var penTouchPoints:Boolean = false; 
		public var tagTouchPoints:Boolean = false; 
		public var fingerTouchPoints:Boolean = true; 
		public var shapeTouchPoints:Boolean = false; 
		
		//sensor
		public var accelerometerPoints:Boolean = false;
		public var controllerPoints:Boolean = false;
		
		public static var touchObjects:Dictionary = new Dictionary();
		private static var iPointClusterList:Dictionary = new Dictionary();
		
		public function TouchCluster(touchObjectID:int):void
		{
			id = touchObjectID;
			ts = GestureGlobals.gw_public::touchObjects[id];
			touchObjects = GestureGlobals.gw_public::touchObjects;
			iPointClusterList = GestureGlobals.gw_public::iPointClusterLists[id];
			
			//trace("init touch cluster",GestureGlobals.gw_public::iPointClusterLists[id]);
			
			cO = GestureGlobals.gw_public::clusters[id];//ts.cO;
			gO = GestureGlobals.gw_public::gestures[id];//ts.gO;
			tiO = GestureGlobals.gw_public::timelines[id]// ts.tiO;
			
			
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
			cluster_kinemetric = new KineMetric(id);
				cluster_kinemetric.init();
				
			//cluster_vectormetric = new VectorMetric(id);
				//cluster_vectormetric.init();
		}
		
		public function initClusterAnalysisConfig():void 
		{
			cluster_kinemetric.init();
			//cluster_vectormetric.init();
		}
		
		public function initSubClusters():void 
		{
		// CREATE INTERACTION POINT SUBCLUSTERS
			if (ts.touchEnabled)  initTouchSubClusters();
			if (ts.motionEnabled) initMotionSubClusters();
			if (ts.sensorEnabled) initSensorSubClusters();
		}
		
		public function initMotionSubClusters():void
		{
			//trace("init sublucster")
			
			
			//if (!cO.mSubClusterArray) cO.mSubClusterArray = new Vector.<ipClusterObject>
			
			// TODO: MOVE TO CLUSTER MANAGER NOT "TOUCHCLUSTER"
			
			//HAND TRACKING //////////////////////////////////////////////////////////////
			/*
				// init MOTION SKELETAL subclusters
				cO.mSubClusterArray[0] = new ipClusterObject();// finger
				cO.mSubClusterArray[0].active = true; //TODO: AUTOMATE ACTIVATION
				cO.mSubClusterArray[0].type = "finger";		
				cO.mSubClusterArray[1] = new ipClusterObject();// palm
				cO.mSubClusterArray[1].active = true;
				cO.mSubClusterArray[1].type = "palm";	
				cO.mSubClusterArray[2] = new ipClusterObject();// thumb
				cO.mSubClusterArray[2].active = true;
				cO.mSubClusterArray[2].type = "thumb";		
				cO.mSubClusterArray[3] = new ipClusterObject();// finger avergae
				cO.mSubClusterArray[3].active = true;
				cO.mSubClusterArray[3].type = "finger_average";
				cO.mSubClusterArray[4] = new ipClusterObject(); //finger and thumb
				cO.mSubClusterArray[4].active = true;
				cO.mSubClusterArray[4].type = "digit";
				// INIT MOTION VIRTUAL SUBCLUSTERS
				cO.mSubClusterArray[5] = new ipClusterObject(); // trigger
				cO.mSubClusterArray[5].active = true;
				cO.mSubClusterArray[5].type = "trigger";		
				cO.mSubClusterArray[6] = new ipClusterObject(); // pinch
				cO.mSubClusterArray[6].active = true;
				cO.mSubClusterArray[6].type = "pinch";
				cO.mSubClusterArray[7] = new ipClusterObject(); // hook
				cO.mSubClusterArray[7].active = true;
				cO.mSubClusterArray[7].type = "hook";
				cO.mSubClusterArray[8] = new ipClusterObject(); //frame
				cO.mSubClusterArray[8].active = true;
				cO.mSubClusterArray[8].type = "frame";
				cO.mSubClusterArray[9] = new ipClusterObject(); //fist
				cO.mSubClusterArray[9].active = true;
				cO.mSubClusterArray[9].type = "fist";
				
				cO.mSubClusterArray[10] = new ipClusterObject(); //region
				cO.mSubClusterArray[10].active = true;
				cO.mSubClusterArray[10].type = "push";
				cO.mSubClusterArray[11] = new ipClusterObject(); //region
				cO.mSubClusterArray[11].active = true;
				cO.mSubClusterArray[11].type = "region";
				
				//HAND OBJECT TRACKING 
				cO.mSubClusterArray[12] = new ipClusterObject(); //tool
				cO.mSubClusterArray[12].active = true;
				cO.mSubClusterArray[12].type = "tool";
				
				
			//FACE TRACKING//////////////////////////////////////////////////////
				
				cO.mSubClusterArray[13] = new ipClusterObject(); //gaze
				cO.mSubClusterArray[13].active = true;
				cO.mSubClusterArray[13].type = "gaze";
				cO.mSubClusterArray[14] = new ipClusterObject(); //eye
				cO.mSubClusterArray[14].active = true;
				cO.mSubClusterArray[14].type = "eye";
				////////////////////////////////////////////////////////////
				//
				*/
			
			//iPointClusterList["finger_dynamic"] = tSubClusterArray;
				
			// init MOTION SKELETAL subclusters
			
				if (fingerPoints)
				{
				iPointClusterList["finger"] = new ipClusterObject();// finger
				iPointClusterList["finger"].active = true; //TODO: AUTOMATE ACTIVATION
				iPointClusterList["finger"].mode = "motion";
				iPointClusterList["finger"].type = "finger";
				}
				if (palmPoints)
				{
				iPointClusterList["palm"] = new ipClusterObject();// palm
				iPointClusterList["palm"].active = true;
				iPointClusterList["palm"].mode = "motion";
				iPointClusterList["palm"].type = "palm";
				}
				if (thumbPoints)
				{
				iPointClusterList["thumb"] = new ipClusterObject();// thumb
				iPointClusterList["thumb"].active = true;
				iPointClusterList["thumb"].mode = "motion";	
				iPointClusterList["thumb"].type = "thumb";	
				}
				if (fingerAveragePoints)
				{
				iPointClusterList["finger_average"] = new ipClusterObject();// finger avergae
				iPointClusterList["finger_average"].active = true;
				iPointClusterList["finger_average"].mode = "motion";
				iPointClusterList["finger_average"].type = "finger_average";
				}
				if (fingerAndThumbPoints)
				{
				iPointClusterList["digit"] = new ipClusterObject(); //finger and thumb
				iPointClusterList["digit"].active = true;
				iPointClusterList["digit"].mode = "motion";
				iPointClusterList["digit"].type = "digit";
				}
				
				// INIT MOTION VIRTUAL SUBCLUSTERS
				if (triggerPoints)
				{
				iPointClusterList["trigger"] = new ipClusterObject(); // trigger
				iPointClusterList["trigger"].active = true;
				iPointClusterList["trigger"].mode = "motion";
				iPointClusterList["trigger"].type = "trigger";
				}
				if (pinchPoints)
				{
					
				//trace("test", iPointClusterList)	
					
				iPointClusterList.pinch = new ipClusterObject(); // pinch
				iPointClusterList.pinch.active = true;
				iPointClusterList.pinch.mode = "motion";
				iPointClusterList.pinch.type = "pinch";
				}
				if (hookPoints)
				{
				iPointClusterList["hook"] = new ipClusterObject(); // hook
				iPointClusterList["hook"].active = true;
				iPointClusterList["hook"].mode = "motion";
				iPointClusterList["hook"].type = "hook";
				}
				if (framePoints)
				{
				iPointClusterList["frame"] = new ipClusterObject(); //frame
				iPointClusterList["frame"].active = true;
				iPointClusterList["frame"].mode = "motion";
				iPointClusterList["frame"].type = "frame";
				}
				if (fistPoints)
				{
				iPointClusterList["fist"] = new ipClusterObject(); //fist
				iPointClusterList["fist"].active = true;
				iPointClusterList["fist"].mode = "motion";
				iPointClusterList["fist"].type = "fist";
				}
				if (pushPoints)
				{
				iPointClusterList["push"] = new ipClusterObject(); //region
				iPointClusterList["push"].active = true;
				iPointClusterList["push"].mode = "motion";
				iPointClusterList["push"].type = "push";
				}
				if(regionPoints){
				iPointClusterList["region"] = new ipClusterObject(); //region
				iPointClusterList["region"].active = true;
				iPointClusterList["region"].mode = "motion";
				iPointClusterList["region"].type = "region";
				}
				//HAND OBJECT TRACKING 
				if (toolPoints)
				{
				iPointClusterList["tool"] = new ipClusterObject(); //tool
				iPointClusterList["tool"].active = true;
				iPointClusterList["tool"].mode = "motion";
				iPointClusterList["tool"].type = "tool";
				}
				
				if (eyePoints) 
				{
					iPointClusterList["eye"] = new ipClusterObject(); //tool
					iPointClusterList["eye"].active = true;
					iPointClusterList["eye"].mode = "motion";
					iPointClusterList["eye"].type = "eye";
				}
				if (gazePoints) 
				{
					iPointClusterList["gaze"] = new ipClusterObject(); //tool
					iPointClusterList["gaze"].active = true;
					iPointClusterList["gaze"].mode = "motion";
					iPointClusterList["gaze"].type = "gaze";
				}
				if (headPoints) 
				{
					iPointClusterList["head"] = new ipClusterObject(); //tool
					iPointClusterList["head"].active = true;
					iPointClusterList["head"].mode = "motion";
					iPointClusterList["head"].type = "head";
				}
		}
		
		public function initTouchSubClusters():void
		{
			trace("attempting to init touch subclusters",fingerTouchPoints);
			//if (!cO.tSubClusterArray) cO.tSubClusterArray = new Vector.<ipClusterObject>
			
			/*
			//TOUCH SUBCLUSTERS
			//finger//////////////////
			cO.tSubClusterArray[0] = new ipClusterObject();
			cO.tSubClusterArray[0].active = true; //TODO: AUTOMATE ACTIVATION
			cO.tSubClusterArray[0].type = "finger_dynamic";
			cO.tSubClusterArray[0].motion_type = "dynamic";
			*/
			
			//trace();
			
			if (fingerTouchPoints)
			{
				iPointClusterList.finger_dynamic = new ipClusterObject();
				iPointClusterList.finger_dynamic.active = true; //TODO: AUTOMATE ACTIVATION
				iPointClusterList.finger_dynamic.mode = "touch";
				iPointClusterList.finger_dynamic.type = "finger_dynamic";
				//iPointClusterList["finger_dynamic"].motion_type = "dynamic";
				
				//trace("finger dynamic init")
			}
			if (penTouchPoints)
			{
				iPointClusterList.pen_dynamic = new ipClusterObject();
				iPointClusterList.pen_dynamic.active = true; //TODO: AUTOMATE ACTIVATION
				iPointClusterList.pen_dynamic.mode = "touch";
				iPointClusterList.pen_dynamic.type = "pen_dynamic";
				///iPointClusterList["pen_dynamic"].motion_type = "dynamic";
			}
			if (tagTouchPoints)
			{
				iPointClusterList.tag_dynamic = new ipClusterObject();
				iPointClusterList.tag_dynamic.active = true; //TODO: AUTOMATE ACTIVATION
				iPointClusterList.tag_dynamic.mode = "touch";
				iPointClusterList.tag_dynamic.type = "tag_dynamic";
				//iPointClusterList["tag_dynamic"].motion_type = "dynamic";
			}
			
			/*
			cO.tSubClusterArray[1] = new ipClusterObject();
			cO.tSubClusterArray[1].type = "finger_static";
			cO.tSubClusterArray[1].motion_type = "static";
			*/
			/*
			cO.tSubClusterArray[0] = new ipClusterObject();
			cO.tSubClusterArray[0].type = "finger_";
			cO.tSubClusterArray[0].motion_type = "dynamic";
			cO.tSubClusterArray[1] = new ipClusterObject();
			cO.tSubClusterArray[1].type = "finger";
			cO.tSubClusterArray[1].motion_type = "static";
			*/
			/*
			//pen//////////////////////
			cO.tSubClusterArray[2] = new ipClusterObject();
			cO.tSubClusterArray[2].type = "pen";
			cO.tSubClusterArray[2].motion_type = "dynamic";
			cO.tSubClusterArray[3] = new ipClusterObject();
			cO.tSubClusterArray[3].type = "pen";
			cO.tSubClusterArray[3].motion_type = "static";
			
			// tag/////////////////////
			cO.tSubClusterArray[4] = new ipClusterObject();
			cO.tSubClusterArray[4].type = "tag";
			cO.tSubClusterArray[4].motion_type = "dynamic";
			cO.tSubClusterArray[5] = new ipClusterObject();
			cO.tSubClusterArray[5].type = "tag";
			cO.tSubClusterArray[5].motion_type = "static";
			
			//chord////////////////////
			cO.tSubClusterArray[6] = new ipClusterObject();
			cO.tSubClusterArray[6].type = "chord";
			cO.tSubClusterArray[6].motion_type = "dynamic";
			cO.tSubClusterArray[7] = new ipClusterObject();
			cO.tSubClusterArray[7].type = "chord";
			cO.tSubClusterArray[7].motion_type = "static";
			
			// shape/////////////////////
			cO.tSubClusterArray[8] = new ipClusterObject();
			cO.tSubClusterArray[8].type = tshape";
			cO.tSubClusterArray[8].motion_type = "dynamic";
			cO.tSubClusterArray[9] = new ipClusterObject();
			cO.tSubClusterArray[9].type = "shape";
			cO.tSubClusterArray[9].motion_type = "static";
			*/
		}
		
		public function initSensorSubClusters():void
		{
			//SENSOR SUBCLUSTERS
			// wiiremote
			//if (!cO.sSubClusterArray) cO.sSubClusterArray = new Vector.<ipClusterObject>
			/*
			cO.sSubClusterArray[0] = new ipClusterObject();
			cO.sSubClusterArray[0].active = true;
			cO.sSubClusterArray[0].type = "wiimote";
			
			cO.sSubClusterArray[1] = new ipClusterObject();
			cO.sSubClusterArray[1].active = true;
			cO.sSubClusterArray[1].type = "native_accelerometer";
			
			cO.sSubClusterArray[2] = new ipClusterObject();
			cO.sSubClusterArray[2].active = true;
			cO.sSubClusterArray[2].type = "remote_accelerometer";
			*/
			if (controllerPoints)
			{
				iPointClusterList["wiimote"]= new ipClusterObject();
				iPointClusterList["wiimote"].active = true;
				iPointClusterList["wiimote"].mode = "sensor";
				iPointClusterList["wiimote"].type = "wiimote";
			}
			
			if (accelerometerPoints)
			{
				iPointClusterList["native_accelerometer"] = new ipClusterObject();
				iPointClusterList["native_accelerometer"].active = true;
				iPointClusterList["native_accelerometer"].mode = "sensor";
				iPointClusterList["native_accelerometer"].type = "native_accelerometer";
				
				iPointClusterList["remote_accelerometer"] = new ipClusterObject();
				iPointClusterList["remote_accelerometer"].active = true;
				iPointClusterList["remote_accelerometer"].mode = "sensor";
				iPointClusterList["remote_accelerometer"].type = "remote_accelerometer";
			}
			// accelerometer
			// myo
			// arduino
			// watch
			
		}
		
		/**
		 * @private
		 */
		// internal public
		public function updateClusterCount():void 
		{
			//trace("update cluster count");
			
			cluster_kinemetric.find3DGlobalIPConstants();  	// get ipn
			cluster_kinemetric.findRootClusterConstants(); 	// get n
			
			//trace("update ts count", ts.N, ts.tpn, ts.ipn)
			//trace("update co count", ts.cO.n, ts.cO.tpn, ts.cO.ipn);
			//trace("update tco count",ts.cO.tcO.tpn, ts.cO.tcO.ipn);
			//trace("update mco count",ts.cO.mcO.tpn, ts.cO.mcO.ipn);
			//trace("");
			
			// dN MUST MOVE TO CLUSTER
			ts.dN = cO.n - ts.N; 
			ts.N = cO.n;
			//trace(ts.dN)

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
			
			//if (ts.dN != 0)
			//{
				//if (ts.clusterEvents) manageClusterEventDispatch();
			//}
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
			/*
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
			}*/
			///////////////////////////////////////////////////
		}
		
		
		
		
	///////////////////////////////////////////////
	//-	//1 DEFINE A SET OF INTERACTION POINTS
	//-	//2 MATCH TO INTERACTION POINT HAND CONFIG (GEOMETRIC)
	//-	//3 HIT TEST QUALIFIED TO TARGET
	//-	//4 ANALYZE RELATIVE INTERACTION POINT CHANGES AND PROPERTIES 
	//-	//5 MATCH MOTION (KINEMETRIC)
	//-	//6 PUSH GESTURE POINT
	//-	//7 PROCESS GESTURE POINT FILTERS 
	//-		//APPLY CLUSTER DELTA LIMITS
	//-	//8 APPLY INTERNAL NATIVE TRANSFORMS 
			//APPLY TRANSFROM LIMITS
	//-	//9 CREATE GESTURE POINT AND ADD TO DISPLAY OBJECT GESTURE POINT LIST
	//-	//10 TEST GESTURE PERIOD PRIORITY AND EXCLUSIVITY
			// TEST SEQUENCE MATCH (HOLD AND MANIPULETE gESTURE POINTS EXIST)
	//-	//11 BUILD GESTURE EVENT OBJECT
	//-	//12 BUILD GESTURE DATA STRCUTURE
	//-	//13 ADD GESTURE EVENT TO TIMELINE
	//-	//14 DISPTACH GESTURE EVENT FROM DISPLAY OBJECT (TODO: REGISTER GESTURE EVENT GLOABLLY)
			// SINGULAR EVENT (GWGestureEvent.HOLD_MANIPULATE......)
	////////////////////////////////////////////
			
	//////E.G BIMANUAL HOLD & MANIPULATE [CONCURRENT] (NOT HOLD + MANIPULATE [SEQUENCIAL])
			//FIND HOLD POINT LIST
			//FIND MANIP POINT LIST 
			//FIND AVERAGE HOLD POINT XY FIND HOLD TIME
			//FIND DRAG,SCALE,ROTATE
			//UPDATE PARENT CLUSTER WITH DELTAS FROM IP SUBCLUSTERS
			//UPDATE GESTURE PIPELINE
			//UPDATE TRANSFROMS ON DISPLAY OBJECT
			//DISPLATCH SINGLE EVENT IF LISTENER PRESENT

		/**
		 * @private
		 */
		// internal public
		public function updateClusterAnalysis():void
			{
				//trace("update cluster analysis")

						
						if (GestureGlobals.frameID == 1) 
						{
							//TODO: MOVE INTO TC CLASS AND TRIGGER ON GML UPDATE IF REQUIRED
							initIPSupport();
							initIPFilters(); //CHECK
							initSubClusters();
						}
				
						
						// NEED TO MOVE INTO METRIC
						// GET N, IPN, TPN,MPN,SPN
						updateClusterCount();
						// GET GESTURE COUNT
						gn = gO.pOList.length;
				
						cluster_kinemetric.resetRootClusterValues();
						cluster_kinemetric.findRootInstDimention();
				
						//CLEARS DELTAS STORED IN GESTURE OBJECT
						//SO THAT VALUES DO NOT PERSIST BEYOND RELEASE (NOT TRUE FOR GESTURE DELTA)
						// CLEARS PRIME CLUSTER PRIME MODAL CLUSTERS AND ALL SUBCLUSTERS
						clearGestureObjectClusterDeltas();
					
						// FIND TOUCH, MOTION, SENSOR SUBCLUSTERS
						findSubClusters();
						
				//if (kinemetricsOn) 
				//{	
					// GET KINEMETRICS FOR SUBCLUSTERS
					//if (ts.touchEnabled) getKineMetrics();
					//if (ts.touchEnabled) getKineMetrics2D();//getTouchKineMetrics
					//if (ts.motionEnabled ) getKineMetrics3D();//getMotionKineMetrics
					if (ts.motionEnabled || ts.touchEnabled) getKineMetrics3D();//getMotionKineMetrics
					//if (ts.sensorEnabled) getSensorKineMetrics();
				//}
				
				//if (vectormetricsOn) 
				//{
					//if (ts.touchEnabled) getVectorMetrics();
					//TODO: 3D VECTOR METRICS
					//if (ts.motion_input) getVectorMetrics3D();
				//}
				//cluster_kinemetric.findRootInstDimention();
				
				//if ((ts.clusterEvents) && (ts.N)) manageClusterPropertyEventDispatch();
				//getGesturePoints();
				
				
				//trace(ts.cO.motionArray.length);
				//trace(ts.cO.iPointArray.length);
				//trace(ts.cO.iPointArray2D.length);
			
		}
		
		public function ipSupported(type:String):Boolean
		{
			var result:Boolean = false;
							
							//MOTION ////////////////////////////////////////////////////////////////////////
								//HAND
								if ((type == "finger")&&(fingerPoints)) 						result = true; 
								if ((type == "thumb")&&(thumbPoints))							result = true; 
								if ((type == "palm")&&(palmPoints)) 							result = true; 
								if ((type == "finger_average") && (fingerAveragePoints)) 	 	result = true; 
								if ((type == "digit") &&(fingerAndThumbPoints))					result = true; 										 
								if ((type == "pinch")&&(pinchPoints)) 							result = true; 			 
								if ((type == "trigger")&&(triggerPoints ))						result = true; 		
								if ((type == "push")&&(pushPoints)) 							result = true; 			 
								if ((type == "hook")&&(hookPoints)) 							result = true; 			 
								if ((type == "frame") && (framePoints)) 						result = true; 
								if ((type == "fist") && (fistPoints)) 							result = true; 
							
								//FACE
								if ((type == "eye") && (eyePoints)) 							result = true;
								if ((type == "gaze") && (gazePoints)) 							result = true; 
							
							
							//TOUCH///////////////////////////////////////////////////////////////////////////
								if ((type == "pen") && (penTouchPoints)) 							result = true; 
								if ((type == "tag") && (tagTouchPoints)) 							result = true; 
								if ((type == "finger") && (fingerTouchPoints)) 					result = true;
								if ((type == "shape") && (shapeTouchPoints)) 						result = true; 
							
							//SENSOR/////////////////////////////////////////////////////////////////////////
							if ((type == "accelerometer") && (accelerometerPoints)) 							result = true;
							
			return result		
		} 
		
		// CAN CONSOLODATE INTO CORE CLUSTER
		// ESTABLISHES LOCAL IP SUPPORT TO ALLOW IN LOCAL IP LIST
		public function initIPSupport():void
		{
			var gn:int = gO.pOList.length;
			
		//	trace("TOUCHCLUSTER core init ip support", gn)
			for (key = 0; key < gn; key++) 
			//for (key in gO.pOList) //if(gO.pOList[key] is GesturePropertyObject)
			{
				// if gesture object is active in gesture list
				if (ts.gestureList[gO.pOList[key].gesture_id])
				{
					var g:GestureObject = gO.pOList[key];
				
					//trace("matching gesture cluster input type",key, g.gesture_xml, g.gesture_id, g.gesture_type ,g.cluster_type,g.cluster_input_type)
						/////////////////////////////////////////////////////
						// ESTABLISH GLOBAL VIRTUAL INTERACTION POINTS SEEDS
						////////////////////////////////////////////////////
						
					
						////////////////////////////////////////////////////////////
						if (g.cluster_input_type == "motion")
						{		
						//g.cluster_type = "all"	
						
						// FUNDAMENTAL INTERACTION POINTS
							if ((g.cluster_type == "finger")||(g.cluster_type == "all")) 			fingerPoints = true; 
							if ((g.cluster_type == "thumb")||(g.cluster_type == "all")) 			thumbPoints = true; 
							if ((g.cluster_type == "palm")||(g.cluster_type == "all")) 				palmPoints = true; 
							if ((g.cluster_type == "finger_average") || (g.cluster_type == "all")) 	fingerAveragePoints = true; 
							if (g.cluster_type == "digit") 											fingerAndThumbPoints = true; 
							
						//CONFIGURATION BASED INTERACTION POINTS
							if ((g.cluster_type == "pinch")||(g.cluster_type == "all")) 			pinchPoints = true; 
							if ((g.cluster_type == "trigger")||(g.cluster_type == "all"))			triggerPoints = true; 
							if ((g.cluster_type == "push")||(g.cluster_type == "all")) 				pushPoints = true; 
							if ((g.cluster_type == "hook")||(g.cluster_type == "all")) 				hookPoints = true; 
							if ((g.cluster_type == "frame") || (g.cluster_type == "all")) 			framePoints = true; 
							if ((g.cluster_type == "fist") || (g.cluster_type == "all")) 			fistPoints = true; 

						// LATER
							//---cluster_geometric.find3DToolPoints();
							//---cluster_geometric.find3DRegionPoints();
							//---cluster_geometric.find3dTipTapPoints();
							
							
							if ((g.cluster_type == "gaze") || (g.cluster_type == "all")) 			gazePoints = true; 
							if ((g.cluster_type == "eye") || (g.cluster_type == "all")) 			eyePoints = true; 
							if ((g.cluster_type == "head") || (g.cluster_type == "all")) 			headPoints = true; 
							
						}
						/////////////////////////////////////////////////////////
						if (g.cluster_input_type == "touch")
						{
							if ((g.cluster_type == "pen") || (g.cluster_type == "all")) 			penTouchPoints = true; 
							if ((g.cluster_type == "tag") || (g.cluster_type == "all")) 			tagTouchPoints = true; 
							if ((g.cluster_type == "finger") || (g.cluster_type == "all")) 			fingerTouchPoints = true; 
							if ((g.cluster_type == "shape")||(g.cluster_type == "all")) 			shapeTouchPoints = true; 
						}
						
						/////////////////////////////////////////////////////////
						if (g.cluster_input_type == "sensor")
						{
							if ((g.cluster_type == "accelerometer") || (g.cluster_type == "all")) 			accelerometerPoints = true;
							if ((g.cluster_type == "controller") || (g.cluster_type == "all")) 				controllerPoints = true;
						}
				}
				
			}
		}
		
	
		public function initIPFilters():void
		{
			//cluster_kinemetric.initFilterIPCluster();
		}
		
		public function getVectorMetrics():void 
		{
			// for unistroke only
			if (cO.ipn == 1) // CHNAGE TO ipn
			{
				//cluster_vectormetric.resetPathProperties(); // reset stroke data object
				//cluster_vectormetric.getSamplePath(); // collect sample path
			}
			
			// multistroke next
		}
		
		public function clearGestureObjectClusterDeltas():void
		{
			gn = gO.pOList.length;
			
			for (key = 0; key < gn; key++) 
			{
				// if gesture object is active in gesture list
				if (ts.gestureList[gO.pOList[key].gesture_id])
				{
					// set dim length
					dn = gO.pOList[key].dList.length;	
					//////////////////////////////////////////////////////////////////////
					// zero cluster deltas
					for (DIM=0; DIM < dn; DIM++) gO.pOList[key].dList[DIM].clusterDelta = 0;	
				}
			}
		}
		
		
		public function getSensorMetrics():void 
		{		
			//cluster_kinemetric.find3DIPAcceleration();
		}
		/*
		public function getKineMetrics2D():void 
		{			
			gn = gO.pOList.length;
			
			//trace("-touch cluster -----------------------------",gn);
			
			for (key = 0; key < gn; key++) 
			//for (key in gO.pOList) //if(gO.pOList[key] is GesturePropertyObject)
			{
				
				// if gesture object is active in gesture list
				// FILTER BY INPUT TYPE
				//trace(gO.pOList[key].gesture_id,ts.gestureList[gO.pOList[key].gesture_id],gO.pOList[key].cluster_input_type)
				
				if ((ts.gestureList[gO.pOList[key].gesture_id])&&(gO.pOList[key].cluster_input_type=="touch"))//gO.pOList[key].cluster_input_type=="it_was_me"
				{
				
					// set dim length
					dn = gO.pOList[key].dList.length;
					
					//////////////////////////////////////////////////////////////////////////////////////////////////////////////
					//////////////////////////////////////////////////////////////////////////////////////////////////////////////
					// PROCESSING INTERACTION POINT KINEMETRICS
					// INTERACTION POINTS FROM // TOUCH POINTS
					//////////////////////////////////////////////////////////////////////////////////////////////////////////////
				
					//trace("TOUCHCLUSTER: processing motion kinemetrics",ts.cO.ipn);
					
					// processing algorithms when in motion
					if(ts.cO.ipn!=0){	//&&(sub_cO_n==gn))	// check kinemetric and if continuous analyze
						
						var g:GestureObject = gO.pOList[key];
						var c_type:String = g.cluster_type;
						c_type = "finger_dynamic"
						
						var subClusterArray:ipClusterObject = iPointClusterList[c_type];

						//trace("touch cluster", c_type, g.cluster_type, subClusterArray)
						
						if (subClusterArray)
						{
						
						var sub_cO_n:int =  subClusterArray.ipn;

						//trace(sub_cO_n,cluster_n)
						//trace("gesture algorithm and class---------------------------------------",sub_cO_n, g.algorithm_class, g.algorithm)
						
						// check point number requirements
						if((sub_cO_n >= g.nMin)&&(sub_cO_n<= g.nMax)||(sub_cO_n == g.n))
						{
							//trace("call touch cluster calc",ts.cO.fn,g.algorithm);
							
							///////////////////////////////////////////////
							// MOTION MATCH
							///////////////////////////////////////////////
							
							// activate all by default
							g.activeEvent = true;

							
							if (g.algorithm_class == "kinemetric")
							{
									// BASIC 3D DRAG // ALGORITHM // type drag
									if (g.algorithm == "drag") 	cluster_kinemetric.find2DIPTranslation(subClusterArray);
									if (g.algorithm == "scale") 	cluster_kinemetric.find2DIPSeparation(c_type);
									if (g.algorithm == "rotate") 	cluster_kinemetric.find2DIPRotation(c_type);
									if (g.algorithm == "manipulate") 	cluster_kinemetric.find2DIPTransformation(c_type);

									///////////////////////////////////////////////////////////////////////////////////
									// LIMIT DELTA BY CLUSTER VALUES
									/////////////////////////////////////////////////////////////////////////////////////
									g.activeEvent = false; // deactivate by default then reactivate based on value
									
									//NEED TO PULL FROM RELVANT SUBCLUSTER
									
										for (DIM = 0; DIM < dn; DIM++) 
										{
										var	gdim:DimensionObject = g.dList[DIM];
												gdim.activeDim = true; // ACTIVATE DIM
										var	res:String = gdim.property_result
										
										
										//////////////////////////////////////////////////////////////////////////////////
										// CLUSTER DELTA CACHE
										if (res == "x") gdim.clusterDelta = subClusterArray.position.x;//cO.position.x
										else if(res == "y") gdim.clusterDelta = subClusterArray.position.y;//cO.position.y//
										else if (res == "z") gdim.clusterDelta = subClusterArray.position.z;//cO.position.z//
										
										else
										{
											//WHEN THERE ARE NO LIMITS IMPOSED
											gdim.clusterDelta = subClusterArray[res];
											//gdim.clusterDelta = cO[res];
											//trace("result", res,cO.tSubClusterArray[b][res]);
										}
										//////////////////////////////////////////////////////////////////////////////////////////
										
											//CLOSE DIM IF NO VALUE
											if (gdim.clusterDelta == 0) gdim.activeDim = false;

											// CLOSE GESTURE OBJECT IF ALL DIMS INACTIVE
											if (gdim.activeDim) g.activeEvent = true;
											
											//trace("GESTURE MOTION OBJECT", res, cO.subClusterArray[b][res], gdim.clusterDelta, g.activeEvent,gdim.activeDim);
										}
										
										//trace("sub_cluster data", g.activeEvent, g.dispatchEvent, cO.subClusterArray[b].dx,cO.subClusterArray[b].ipn,cO.hn, cO.fn );
										
										//NEED TO PULL FROM RELVANT GESTURE OBJECT//SUBCLUSTER OBJECT
										//g.data.x = subClusterArray[c_type].position.x; 		// gesture position
										//g.data.y = subClusterArray[c_type].position.y; 		// gesture position
										//g.data.z = subClusterArray[c_type].position.z; 		// gesture position
										//g.data.ipn = subClusterArray[c_type].ipn; 	// current ip total
										
										//trace(g.data.x,
										//if ((g.activeEvent) && (g.dispatchEvent))
										//trace("CLUSTER OBJECT","dx",cO["dx"],"dy",cO["dx"], "etm_dx",cO["etm_dx"],"etm_dy", cO["etm_dy"],"ddx", cO["etm_ddx"],"ddy", cO["etm_ddy"])
						}	
							///////////////////////////////////////////////////
						}
				}
				}
				///////////////////////////////////////////////////////////////////////////////////////////////////////////////
				// END IP TOUCH KIMETRIC PROCESSING
				///////////////////////////////////////////////////////////////////////////////////////////////////////////////
				}
			}

				//cluster_kinemetric.WeaveTouchSubClusterData()
				
				//	WEAVE TOUCH DATA INTO ROOT SUPER CLUSTER
				//cluster_kinemetric.WeaveTouchRootClusterData(); // should move to cluster manager
			}
		
		*/
		
		
		
		
		/*
		public function getKineMetrics():void 
		{		
	
			gn = gO.pOList.length;
			
			cluster_kinemetric.resetTouchClusterValues();
			cluster_kinemetric.findTouchInstDimention();
			
			//cluster_geometric.find2DTagPoints(); 
			
			//trace("-touch cluster -----------------------------",gn);
			
			for (key = 0; key < gn; key++) 
			//for (key in gO.pOList) //if(gO.pOList[key] is GesturePropertyObject)
			{
				
				// if gesture object is active in gesture list
				// FILTER BY INPUT TYPE
				
				//NOTE TOUCGH GESTURE EVENTS WERE BEING REACTIVATED BY MOTION INOPUT AND INTERFERING WITH MOTION GESTURE EVENTS
				// FIX WAS TO FILTER CLUSTER PROCESSING SO THAT EVENTACTIVE STATES WERE NOT OVERWRITTEN
				// NEED TO UPDATE TOUCH GESTURES AND TYPE THEM (TOUCH, MOTION, MOTION & TOUCH, SENSOR, SENSOR & TOUCH, SENSOR & MOTION...)	
				/// need to test more
				
				//trace(gO.pOList[key].cluster_input_type);
				
				
				////////////////////////////////////////////////
				//TAG HACK
				//if ((ts.gestureList[gO.pOList[key].gesture_id])&&((gO.pOList[key].cluster_input_type="")||(gO.pOList[key].cluster_input_type="touch"))&&(cluster_geometric.tag_match))
				// also consider not motion
				//gO.pOList[key].cluster_input_type!="motion"
				if ((ts.gestureList[gO.pOList[key].gesture_id])&&((gO.pOList[key].cluster_input_type=="")||(gO.pOList[key].cluster_input_type=="touch")||(gO.pOList[key].cluster_input_type=="touch_")))
				{
				
					// set dim length
					dn = gO.pOList[key].dList.length;

					var g:GestureObject = gO.pOList[key];
					
					////////////////////////////////////////////////////////////////////////////////////////////////////////////////
					// PROCESSING TOUCH KINEMETRICS
					// TOUCH POINTS
					///////////////////////////////////////////////////////////////////////////////////////////////////////////////
				
					if (ts.tpn != 0) // check kinemetric and if continuous analyze
					{		
						// check point number requirements
						if((ts.tpn >= g.nMin)&&(ts.tpn <= g.nMax)||(ts.tpn == g.n))
						{
							//trace("call cluster calc",ts.N);
							
							if (g.algorithm_class == "kinemetric")
							{
									// activate all by default
									g.activeEvent = true;
									
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
											
											//trace("touch result",res);
											////////////////////////////////////////////////////
											// CHECK FOR CLUSTER PROEPERTY VALUE LIMITS IF EXIST
											////////////////////////////////////////////////////
											
											// WHEN PROPERTY LIMITS ESTABLISHED
											// ONLY USES ONE VAR PER PROPERTY BUT COULD BE EXTENDED
											// STILL NEED TO MAP RETURN TO RESULT
											if (gdim.property_vars[0])
											{
												//trace("tcO property ",gdim.property_vars[0],gdim.property_vars[0]["var"]);
												//TODO: FIX VARAIBLES BLOCK
												var num:Number = Math.abs(tcO[gdim.property_vars[0]["var"]]);
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
														gdim.clusterDelta = tcO[res];//dim_var = num;
														//trace("MIN",num)
													}
													else gdim.clusterDelta = 0//dim_var = 0;
												}
												// when max 
												else if (gdim.property_vars[0]["max"] != null) 
												{	
													//if (num <= gdim.property_vars[0]["max"])	gdim.clusterDelta = cO[res];//dim_var = num;
													//else gdim.clusterDelta = 0;//dim_var = 0;
												}
												else {
													//TODO: APPLY MAPPING PROPERTIES
													gdim.clusterDelta = tcO[res];
												}
												
											}
											
											
											
											//WHEN THERE ARE NO LIMITS IMPOSED
											else {
												// check new vector map
												// note will chnage to touchcluster array //cO.tSubClusterArray[b].position.z;
												//trace("touch result",res,tcO["position"],tcO["position"].x,tcO["position"]["x"]);//
												if (res == "x") gdim.clusterDelta = tcO.position.x;
												else if (res == "y") gdim.clusterDelta = tcO.position.y;
												else if (res == "z") gdim.clusterDelta = tcO.position.z;
												//TODO:WILL NEED FOR SCALE AND ROTATE,SIZE, DELTA_POSITION, DELTA_SCALE, DELTA_ROTATE, ACCELERATION, JOLT, JERK....
												//or map one to one using name
												else gdim.clusterDelta = tcO[res];
											}
											
											/////////////////////////////////////////////////////////////
											//GREAT FOR FINDING CLUSTER PROPERTIES
											//trace("touchcluster",res,tcO[res])
											/////////////////////////////////////////////////////////////
											

											//CLOSE DIM IF NO VALUE
											if (gdim.clusterDelta == 0) gdim.activeDim = false;
											//trace("GESTURE OBJECT", res, cO[res], gdim.clusterDelta);
											
											// CLOSE GESTURE OBJECT IF ALL DIMS INACTIVE
											if (gdim.activeDim) g.activeEvent = true;
											
											//trace("TOUCH GESTURE OBJECT", res, tcO[res], gdim.clusterDelta, g.activeEvent,gdim.activeDim);
										}


										g.data.x = tcO.position.x;
										g.data.y = tcO.position.y;
										g.data.z = tcO.position.z;
										//g.data.n = tpn;
										
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
				
				//else {
					//trace("processing algorithm when NOT touching");
				//}

				}
				
				
				/*
				///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
				// MULTIMODAL TRANSMODAL CROSS MODAL CLUSTER ANALYSIS
				// TOUCH AND MOTION ///////////////////////////////////////////////////////
				if (gO.pOList[key].cluster_input_type == "touch_motion") 
				{
					// set dim length
					dn = gO.pOList[key].dList.length;

					var g:GestureObject = gO.pOList[key];
					
					////////////////////////////////////////////////////////////////////////////////////////////////////////////////
					// PROCESSING TOUCH KINEMETRICS
					// TOUCH POINTS
					///////////////////////////////////////////////////////////////////////////////////////////////////////////////
				
					if (ts.tpn != 0) // check kinemetric and if continuous analyze
					{		
						// check point number requirements
						if((ts.tpn >= g.nMin)&&(ts.tpn <= g.nMax)||(ts.tpn == g.n))
						{
							//trace("call cluster calc",ts.N);
							
							if (g.algorithm_class == "kinemetric")
							{
									// activate all by default
									g.activeEvent = true;
									
									//trace("kinemetric algorithm",gO.pOList[key].algorithm);
									
									// BASIC DRAG/SCALE/ROTATE CONTROL // ALGORITHM // type manipulate
									//if (g.algorithm == "manipulate") 	cluster_kinemetric.findMeanInstTransformationMModal();
							}
						}
					}
				}*/
				
				// TOUCH AND SENSOR
				// MOTION AND SENSOR
			/*
				
			}
			
			//	WEAVE TOUCH DATA INTO ROOT SUPER CLUSTER
			cluster_kinemetric.WeaveTouchRootClusterData(); // should move to cluster manager
		}*/
		
		
		/*
		public function clusterHitTest():void 
		{		
			//if (!core) cluster_kinemetric.hitTestCluster();
		}*/
		
		/*
		public function mapMotion3Dto2D():void 
		{
			//trace("tc mapping motion points", cO.motionArray.length, cO.motionArray2D.length, cluster_geometric );
			if (!ts.transform3d) cluster_geometric.mapMotionPoints3Dto2D();
		}*/
		
		public function findSubClusters():void 
		{		
				///////////////////////////////////////////////////////////////////
				// MUST PRECEED IP TRANSFORMATION 
				///////////////////////////////////////////////////////////////////
				// FOR NATIVE MAPPING AND GESTURE OBJECT DATA STRUCTURE SIMPLIFICATION
				// MAY NEED TO ALWAYS BE ON FOR STAGE OBJECTS
				//if (!ts.transform3d) 
				cluster_kinemetric.mapCluster3Dto2D();
				
				// GET IP SUBCLUSTERS // PUSH TO SUBCLUSTER MATRIX
				//cluster_kinemetric.getSubClusters();
				getSubClusters();
				
				cluster_kinemetric.getSubClusterConstants();
				////////////////////////////////////////////////////////////////////
		}
		
		public function getSubClusters():void 
		{
			//trace("getting subclusters");
				for each (var iPointCluster:ipClusterObject in iPointClusterList) 
				{
					//trace("get subclusters", iPointCluster.iPointArray.length)
					if (iPointCluster)
					{
						if (iPointCluster.iPointArray) iPointCluster.iPointArray.length = 0;
						else iPointCluster.iPointArray = new Vector.<InteractionPointObject>();
					}
					//trace("zero");
				}
				
				//update subcluster point arrays //////////////////////////////
				for (var i:uint = 0; i < cO.iPointArray.length; i++) 
				{
					var ipt:InteractionPointObject = cO.iPointArray[i]
					var type:String = String(ipt.type);
					
					//trace("update subcluster",cO.iPointArray.length, iPointClusterList[type], iPointClusterList[type].iPointArray.length);
					if (iPointClusterList[type])
					{
						if (ts.touchEnabled && iPointClusterList[type].mode=="touch")			iPointClusterList[type].iPointArray.push(ipt);
						else if (ts.motionEnabled && iPointClusterList[type].mode=="motion")	iPointClusterList[type].iPointArray.push(ipt);
						else if (ts.sensorEnabled && iPointClusterList[type].mode=="sensor")	iPointClusterList[type].iPointArray.push(ipt);
					}
					//trace("sorting local ips");
				}
		}

		public function getKineMetrics3D():void 
		{		
			//trace("3d kinmetrics-------------------------");
			
			gn = gO.pOList.length;
			
			//trace("-touch cluster -----------------------------",gn);
			
			for (key = 0; key < gn; key++) 
			//for (key in gO.pOList) //if(gO.pOList[key] is GesturePropertyObject)
			{
				
				// if gesture object is active in gesture list
				// FILTER BY INPUT TYPE
				//trace(gO.pOList[key].gesture_id,ts.gestureList[gO.pOList[key].gesture_id],gO.pOList[key].cluster_input_type)
				
				if ((ts.gestureList[gO.pOList[key].gesture_id])&&(gO.pOList[key].cluster_input_type=="motion" || gO.pOList[key].cluster_input_type=="touch"))
				{
				
					// set dim length
					dn = gO.pOList[key].dList.length;
					
					//////////////////////////////////////////////////////////////////////////////////////////////////////////////
					//////////////////////////////////////////////////////////////////////////////////////////////////////////////
					// PROCESSING INTERACTION POINT KINEMETRICS
					// INTERACTION POINTS FROM // MOTION POINTS
					//////////////////////////////////////////////////////////////////////////////////////////////////////////////
				
					//trace("TOUCHCLUSTER: processing motion kinemetrics",ts.cO.ipn);
					
					// processing algorithms when in motion
					if(ts.cO.ipn!=0){	//&&(sub_cO_n==gn))	// check kinemetric and if continuous analyze
					
					
						////////////////////////////////////////////////
						// SKELETON MATCH
						// TODO: CREAT EXPLICIT SKELETON CONFIG MATCH 
						// PARALLEL TO IMPLICIT CONFIG MATCH
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
								//2 NONE??
							// MATCH NUMBER OF FINGERS PER HAND
								//5/4/3/2/1 DIGITS
								//4/3/2/1 PURE FINGER
				
						//////////////////////////////////////////////////
						// IMPLICIT SKELETON CONFIG MATCH 
						// FROM INTERACTION POINT TYPE DEFINITION
						//////////////////////////////////////////////////
						
							// DONT PROCESS KINEMTRIC IF WRONG SETTING ON IP POINT
							// MUST HAVE CORRECT NUMBER OF FINGERS ON HAND (1 FUBGER TRIGGER VS TWI FINGER TRIGGER)
							// MUST HAVE CORRECT FLATNESS (OPEN PALM VS CLOSED PALM)
							// CURRENTLY IS HARD CODED INTO THE PALM AND TRIGGER IP CREATION
						
						var g:GestureObject = gO.pOList[key];
						var c_type:String = g.cluster_type;
						
						//if (c_type=="") c_type = "finger_dynamic"
						
						var b:int = 0;
						var subClusterArray:ipClusterObject = iPointClusterList[c_type];
						//trace("tc motion cluster motion",c_type, iPointClusterList[c_type],subClusterArray )
						
						if (subClusterArray)
						{
						var sub_cO_n:int =  subClusterArray.ipn;

						//trace("ipn",sub_cO_n)

						// check point number requirements
						if((sub_cO_n >= g.nMin)&&(sub_cO_n<= g.nMax)||(sub_cO_n == g.n))
						{
							//trace("call motion cluster calc",ts.cO.fn,g.algorithm_class,g.algorithm);
							///////////////////////////////////////////////
							// MOTION MATCH
							///////////////////////////////////////////////
							
							// activate all by default
							g.activeEvent = true;
							
							if (g.algorithm_class == "3d_kinemetric" || g.algorithm_class =="kinemetric")
							{
									// BASIC 3D DRAG/SCALE/ROTATE CONTROL // ALGORITHM // type manipulate
									if (g.algorithm == "3d_manipulate" || g.algorithm == "3d_transform"|| g.algorithm == "manipulate") cluster_kinemetric.find3DIPTransformation(subClusterArray); 
									
									// BASIC 3D DRAG // ALGORITHM // type drag
									if (g.algorithm == "3d_translate" || g.algorithm == "drag") 	cluster_kinemetric.find3DIPTranslation(subClusterArray);
									
									// GENERIC 3D ROTATE
									if (g.algorithm == "3d_rotate" || g.algorithm == "rotate") 	cluster_kinemetric.find3DIPRotation(subClusterArray);
									
									//GENERIC 3D DCALE
									if (g.algorithm == "3d_separate" || g.algorithm == "scale")	cluster_kinemetric.find3DIPSeparation(subClusterArray);
									
									// GENERIC TAP 
									if (g.algorithm == "3d_tap") 	cluster_kinemetric.find3DIPTapPoints(subClusterArray);
									
									// GENERIC HOLD 
									if (g.algorithm == "3d_hold") 	cluster_kinemetric.find3DIPHoldPoints(subClusterArray);
									
									///////////////////////////////////////////////////////////////////////////////////
									// LIMIT DELTA BY CLUSTER VALUES
									/////////////////////////////////////////////////////////////////////////////////////
									g.activeEvent = false; // deactivate by default then reactivate based on value
									
									//NEED TO PULL FROM RELVANT SUBCLUSTER
									
										for (DIM = 0; DIM < dn; DIM++) 
										{
										var	gdim:DimensionObject = g.dList[DIM];
												gdim.activeDim = true; // ACTIVATE DIM
										var	res:String = gdim.property_result
										
										
													////////////////////////////////////////////////////////////////////////////////////////
													// CLUSTER DELTA CACHE IN GESTURE OBJECT
													if (res == "x") gdim.clusterDelta = subClusterArray.position.x;//cO.position.x;
													else if(res == "y") gdim.clusterDelta = subClusterArray.position.y;// cO.position.y;
													else if (res == "z") gdim.clusterDelta = subClusterArray.position.z;//cO.position.z;
													
													else
													{
														//WHEN THERE ARE NO LIMITS IMPOSED
														gdim.clusterDelta = subClusterArray[res]; //OVERIDES BLENDING??
														//gdim.clusterDelta = cO[res];
													}
													////////////////////////////////////////////////////////////////////////////////////////
													//trace("result", res);
													
										
											//CLOSE DIM IF NO VALUE
											if (gdim.clusterDelta == 0) gdim.activeDim = false;

											// CLOSE GESTURE OBJECT IF ALL DIMS INACTIVE
											if (gdim.activeDim) g.activeEvent = true;
											
											//trace("GESTURE MOTION OBJECT", res, cO.subClusterArray[b][res], gdim.clusterDelta, g.activeEvent,gdim.activeDim);
										}
										
										//trace("sub_cluster data", g.activeEvent, g.dispatchEvent, cO.subClusterArray[b].dx,cO.subClusterArray[b].ipn,cO.hn, cO.fn );
										
										//NEED TO PULL FROM RELVANT GESTURE OBJECT//SUBCLUSTER OBJECT
										g.data.x = subClusterArray.position.x; 		// gesture position
										g.data.y = subClusterArray.position.y; 		// gesture position
										g.data.z = subClusterArray.position.z; 		// gesture position
										//g.data.hn = subClusterArray.hn;							// current hand number
										//g.data.fn = subClusterArray.fn; 							// current finger total
										g.data.ipn = subClusterArray.ipn; 	// current ip total
										//MAY EXTEND TO NEW ARCHITECTURE
										//g.data.gp = cO.gesturePoint;					// gesture point created from kinemetric3d analysis
										
										//TODO:
										// ADD TRANSFORMED POINT LOCALTION DATA 2D AND 3D LOCAL
										// ADD TRANSFORMED DELTA DATA FOR NESTED GESTURE EVENTS
										//////////////////////////////////////////////////////////////////
										//////////////////////////////////////////////////////////////////
										
										//if ((g.activeEvent) && (g.dispatchEvent))
										//trace("CLUSTER OBJECT","dx",cO["dx"],"dy",cO["dx"], "etm_dx",cO["etm_dx"],"etm_dy", cO["etm_dy"],"ddx", cO["etm_ddx"],"ddy", cO["etm_ddy"])
						}	
							///////////////////////////////////////////////////
						}
						}
				}
				///////////////////////////////////////////////////////////////////////////////////////////////////////////////
				// END IP KIMETRIC PROCESSING
				///////////////////////////////////////////////////////////////////////////////////////////////////////////////
				}
			}
			////////////////////////////////////////////////////////
			// DEFAULT STATIC WEAVING 
			// NO MODAL HERACY FOR WEIGHTED BLENDING OF DELTAS
			//cluster_kinemetric.WeaveMotionSubClusterData();
			//cluster_kinemetric.WeaveMotionRootClusterData();
		}
		
		
		//TODO: KILL GESTUREPOINT AND USE GESTURE EVENT INSTEAD
		// use gesture points as replacement for internal gesture events for batching sequences
		// MULL OVER IMPLICATIONS TO VIRTUAL 3D INTERACTIVE SPACE
		/*
		public function getGesturePoints():void 
		{		
		//	trace("-----")
				for (var i:int = 0; i < cO.gPointArray.length; i++) 
					{
					trace(cO.gPointArray[i].type,cO.gPointArray[i].position);// cO.gPointArray[i].n
					}
		}*/
		
		/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
		//sensors
		// mouse position // left or right or both
			// left click (left wink)
			// right click (right wink)
			// hold (stare/gaze lock)
			// (flare)
			// pupil size (presure dist??)
			// wink/blink/flare/
		

	}
}