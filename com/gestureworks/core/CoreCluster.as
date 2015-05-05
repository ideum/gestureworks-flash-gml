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
	import com.gestureworks.analysis.CoreTemporalMetric;
	import com.gestureworks.objects.GestureObject;
	
	import com.gestureworks.objects.TouchPointObject;
	import com.gestureworks.objects.MotionPointObject;
	import com.gestureworks.objects.SensorPointObject;
	import com.gestureworks.objects.InteractionPointObject;
	import com.gestureworks.objects.ClusterObject;
	import com.gestureworks.objects.ipClusterObject;
	import com.gestureworks.objects.GestureListObject;
	import com.gestureworks.objects.TimelineObject;
	import com.gestureworks.objects.DimensionObject;
	
	import com.gestureworks.core.CoreVisualizer;
	
	import flash.geom.Point;
	import flash.display.DisplayObject;
	import flash.utils.Dictionary;
		
	/**
	* @private
	*/
	public class CoreCluster
	{
		/**
		* @private
		*/
		//public var cluster_vectormetric:VectorMetric;
		private var cluster_geometric:CoreGeoMetric;
		private var cluster_temporalmetric:CoreTemporalMetric;
		public var visualizer:CoreVisualizer;
		
		private var gn:uint;
		private var key:uint;
		private var dn:uint 
		private var DIM:uint; 
		private var ts:Object;
		private var id:int;
		
		private var tpn:int
		private var mpn:int
		private var spn:int
		private var ipn:int
		private var tpnk1:Number;
		private var tpnk0:Number;
		private var mc:int;
		private var tpn1;
		
		private var gs:CoreSprite;
		private var touchArray:Vector.<TouchPointObject>
		private var motionArray:Vector.<MotionPointObject>
		//private var motionArray2D:Vector.<MotionPointObject>
		private var sensorArray:Vector.<SensorPointObject>
		private var iPointArray:Vector.<InteractionPointObject>
		private var iPointClusterLists:Object;
		
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
		
		public var gazePoints:Boolean = false; 
		public var eyePoints:Boolean = false; 
		public var headPoints:Boolean = false; 
		
		//touch
		public var penTouchPoints:Boolean = false; 
		public var tagTouchPoints:Boolean = false; 
		public var fingerTouchPoints:Boolean = false; 
		
		public static var touchObjects:Dictionary;
		
		public function CoreCluster():void
		{
			gs = GestureGlobals.gw_public::core;
			touchObjects = GestureGlobals.gw_public::touchObjects;
			iPointClusterLists = GestureGlobals.gw_public::iPointClusterLists;
			
			
			touchArray = GestureGlobals.gw_public::touchArray;
			motionArray = GestureGlobals.gw_public::motionArray;
			sensorArray = GestureGlobals.gw_public::sensorArray;
			iPointArray = GestureGlobals.gw_public::iPointArray;
			
			initCoreGeoMetric();
			initCoreTemporalMetric();
          }
		  
		/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		// initializers
		/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        /**
		 * @private
		 */
		public function initCoreGeoMetric():void
		{
			cluster_geometric = new CoreGeoMetric();
			cluster_geometric.init();
			
			visualizer = new CoreVisualizer();
		}
		
		public function initCoreTemporalMetric():void
		{
			cluster_temporalmetric = new CoreTemporalMetric();
			cluster_temporalmetric.init();
		}
		
		
		public function updateCoreRawPointCount():void 
		{
			
			//trace("array lengths",touchArray.length, motionArray.length, sensorArray.length,iPointArray.length);
			
			//	trace("update raw cluster count");
				// get motion point counts
				//if (gs.motionEnabled) cluster_geometric.findMotionClusterConstants();  // get mpn
				//if (gs.motionEnabled) 
				findMotionClusterConstants();  // get mpn
				
				// get touch point count
				//if (gs.touchEnabled) cluster_kinemetric.findTouchClusterConstants(); // get tpn
				//if (gs.touchEnabled) 
				findTouchClusterConstants(); // get tpn
				
				// get sensor point count
				//if (gs.sensorEnabled) cluster_kinemetric.findSensorClusterConstants(); // get spn
				//if (gs.sensorEnabled) 
				findSensorClusterConstants(); // get spn
		}
		
		public function findMotionClusterConstants():void
		{
			if (motionArray) mpn = motionArray.length;
			else mpn = 0;
			
			gs.mpn = mpn;
		}
		
		public function findTouchClusterConstants():void
		{
			//trace("KineMetric::findTouchClusterConstants");

				//if (ts.traceDebugMode) trace("find cluster..............................",N);
				///////////////////////////////////////////////
				// get number of touch points in cluster
				if (touchArray) tpn = touchArray.length;
				else tpn = 0;
				
				gs.tpn = tpn;
			
				//TODO: NEED TO FIX lock number
				//LN = ts.tcO.hold_n // will need to move to interaction point structure or temporal metric mgmt
				
				// derived point totals
				if (tpn) 
				{
					tpn1 = tpn - 1;
					tpnk0 = 1 / tpn;
					tpnk1 = 1 / tpn1;
					
					//pointList = cO.touchArray; // copy most recent point array data
					mc = touchArray[0].moveCount; // get sample move count value
				}
				if (tpn == 0) tpnk1 = 0;
		}
		
		public function findSensorClusterConstants():void
		{
				if (sensorArray) spn = sensorArray.length;
				else spn = 0;
				
				gs.spn = spn;
		}
		
	
		public function ipSupported(type:String):Boolean
		{
			var result:Boolean = false;
							
							//motion
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
							
							
							//touch 
							if ((type == "pen") && (penTouchPoints)) 						result = true; 
							if ((type == "tag") && (tagTouchPoints)) 						result = true; 
							if ((type == "finger") && (fingerTouchPoints)) 						result = true; 
							
							//add sensor
							//if ((type == "wiimote") && (wiimoteSesnorPoints)) 						result = true; 
							//if ((type == "controller") && (controllerSensorPoints)) 						result = true; 
							//if ((type == "accelerometer") && (acceleromterSensorPoints)) 						result = true; 
							
			return result		
		} 
		
		

		//ESTABLISHES GLOABL IP SUPPORT
		public function initPreMetrics():void
		{
			//trace("set geometric init",core)
			
			var key:int;
			// for each touchsprite/motionsprite
			// go through gesture list on initialization
			// look for motion gestures that need specific sub cluster types
			// swithed on
			// note global gesture list need that represents a compiled list of gestures from all objects??
			
			for each(var tO:Object in touchObjects)
			{
			// numbers of gestures on this object
			var gn:int = tO.gO.pOList.length;
				//trace("gesture number",tO,gn, tO.gO,tO.gO.pOList,tO.gO.pOList.length)
			for (key = 0; key < gn; key++) 
			//for (key in gO.pOList) //if(gO.pOList[key] is GesturePropertyObject)
			{
				/////////////////////////////////////////////////////////
				// 
				// if gesture object is active in gesture list
				//if (tO.gestureList[tO.gO.pOList[key].gesture_id])
				//{
					var g:GestureObject = tO.gO.pOList[key];
				
					//trace("matching gesture cluster input type",key, g.gesture_xml, g.gesture_id, g.gesture_type ,g.cluster_type,g.cluster_input_type)
					/////////////////////////////////////////////////////
					// ESTABLISH GLOBAL VIRTUAL INTERACTION POINTS SEEDS
					////////////////////////////////////////////////////
					if (g.cluster_input_type == "touch")
						{
							if ((g.cluster_type == "finger") || (g.cluster_type == "all")) fingerTouchPoints = true;
							if ((g.cluster_type == "tag") || (g.cluster_type == "all")) tagTouchPoints = true; 
							if ((g.cluster_type == "pen") || (g.cluster_type == "all")) penTouchPoints = true; 
						}

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
						}
					
						if (g.cluster_input_type == "sensor")
						{	
							//accelerometer
							//wiimote
							//xbox
							//myo
						}
				
			}
				
			}
		}
		
		////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		//
		////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
		public function getTouchGeoMetrics():void
		{
			//trace("get geometric 2d",cluster_geometric);
			cluster_geometric.findFingerTouchPoints();
			//cluster_geometric.find2DTagTouchPoints();
			//cluster_geometric.findPenTouchPoints();
		}
		
		public function getSensorGeoMetrics():void
		{
			//trace("get geometric 2d",cluster_geometric);
			cluster_geometric.findSensorAccelerometerPoints();
			cluster_geometric.findSensorControllerPoints();
		}
		
		public function getMotionGeoMetrics():void
		{
			//trace("get geometric 2d",cluster_geometric);
			mapMotion3Dto2D();
			getSkeletalGeoMetrics3D();
			getPoseGeoMetrics3D();
		}
		
		public function getTemporalMetrics():void
		{
			//trace("get geometric 2d",cluster_geometric);
			cluster_temporalmetric.findGesturePoints();
		}
		
		
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
		public function getSkeletalGeoMetrics3D():void 
		{
			//trace("get skeletal geometric");
			
				//trace("get core geometrics")
				
				//////////////////////////////////////////////////////
				// RESET CLUSTER
				//////////////////////////////////////////////////////
				//cluster_geometric.resetGeoCluster();
				
				cluster_geometric.clearHandData();	
				
				
				// NEEDS TO UPDATE HERE TO STAY CURRENT
				// NEED TO FIND OUT WHY ??
				//cluster_geometric.findMotionClusterConstants()
				
				/////////////////////////////////////////////////////
				//BUILD SKELETAL MODEL FROM RAW MOTION POINTS
				/////////////////////////////////////////////////////
				
				// BASIC HAND
					cluster_geometric.updateMotionPoints();//createHand(); // palm points // finger list palm ip 
					
					
				// SKELETAL DETAIL
					cluster_geometric.findFingerAverage();// finger average point// up down 
					cluster_geometric.findHandOrientation();
					cluster_geometric.findHandDirection();
					cluster_geometric.normalizeFingerFeatures(); // norm lengths (palm distances)
					cluster_geometric.findHandRadius(); // favdist 
					cluster_geometric.findThumb(); // thumb // left// right
				
					
				// ADVANCED SKELETON
				//	cluster_geometric.dynamicSkeletonUpdate();
			
		}
		
		public function getPoseGeoMetrics3D():void 
		{
			//TODO:  SET TO BE AWARE OF NUMBER OF FINGERS ASOCOCIATED WITH CONFIG
			// SET TO BE AWARE OF REQUIRED HAND SETTINGS FLATNESS AND ORIENTATION

			//trace("get core geometrics", core);
			
			//FOR EACH GESTURE ON TS
			//var gn:int = ts.gO.pOList.length;
			//trace("hello", gn)
			
			//for (key = 0; key < gn; key++) 
			//{
			//var g:GestureObject = gO.pOList[key];

				//if (g.cluster_input_type == "motion")
				//{
				// FOR EACH HAND
				//for (var j:int = 0; j < cO.hn; j++)
					//{	
					// IF H_FN AND FLATNESS AND ORINETATION MATCH
					//trace(g.h_fn,g.h_flatness)
					
					//if ((cO.handList[j].fingerList.length == g.h_fn)&&(cO.handList[j].flatness == g.h_flatness))
						//{
						if (fingerPoints)			cluster_geometric.find3DFingerPoints(); 
						if (thumbPoints)			cluster_geometric.find3DThumbPoints(); 
						if (palmPoints)				cluster_geometric.find3DPalmPoints(); 
						if (fingerAveragePoints)	cluster_geometric.find3DFingerAveragePoints(); 
						if (fingerAndThumbPoints)	cluster_geometric.find3DFingerAndThumbPoints(); 
									
						//CONFIGURATION BASED INTERACTION POINTS
						if (pinchPoints)			cluster_geometric.find3DPinchPoints(); 
						if (triggerPoints)			cluster_geometric.find3DTriggerPoints(); 
						if (pushPoints)				cluster_geometric.find3DPushPoints(); 
						if (hookPoints)				cluster_geometric.find3DHookPoints(); 
						if (framePoints)			cluster_geometric.find3DFramePoints(); 
						if (fistPoints)			cluster_geometric.find3DFistPoints(); 
						
						// LATER
							//---cluster_geometric.find3DToolPoints();
							//---cluster_geometric.find3DRegionPoints();
							//---cluster_geometric.find3dTipTapPoints();
						//}
					//}
				//}
			//}
			
		}
		
		
		public function mapMotion3Dto2D():void 
		{
			//trace("tc mapping motion points", cO.motionArray.length, cO.motionArray2D.length, cluster_geometric );
			//if (!ts.transform3d) 
			cluster_geometric.mapMotionPoints3Dto2D();
		}
		
		
		
		
		public function manageTimeline():void
		{
			cluster_temporalmetric.manageTimeline();
		}
		
		
		
	}
}