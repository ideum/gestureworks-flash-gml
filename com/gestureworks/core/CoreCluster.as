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
	
	import com.gestureworks.objects.TouchPointObject;
	import com.gestureworks.objects.MotionPointObject;
	import com.gestureworks.objects.ClusterObject;
	import com.gestureworks.objects.ipClusterObject;
	import com.gestureworks.objects.GestureListObject;
	import com.gestureworks.objects.TimelineObject;
	import com.gestureworks.objects.DimensionObject;
	
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
		private var cluster_geometric:GeoMetric;
		
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
		//touch
		public var penTouchPoints:Boolean = false; 
		public var tagTouchPoints:Boolean = false; 
		public var fingerTouchPoints:Boolean = false; 
		
		public static var touchObjects:Dictionary = new Dictionary();
		
		public function CoreCluster(touchObjectID:int):void
		{
			id = touchObjectID;
			ts = GestureGlobals.gw_public::touchObjects[id];
			touchObjects = GestureGlobals.gw_public::touchObjects;
			
			gO = ts.gO;
			cO = ts.cO;
				tcO = cO.tcO;
				mcO = cO.mcO;
				scO = cO.scO;
			
			tiO = ts.tiO;
			
			initCluster();
          }
		  
		/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		// initializers
		/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        /**
		 * @private
		 */
		public function initCoreGeoMetric():void
		{
			//trace("tc init geometric call");
			if (core) {
				cluster_geometric = new GeoMetric(id);
				cluster_geometric.init();
			}
		}
		
		
		public function updateCoreRawPointCount():void 
		{
			//	trace("update raw cluster count");
				// get motion point counts
				if (ts.motionEnabled) cluster_geometric.findMotionClusterConstants();  // get mpn
				
				// get touch point count
				if (ts.touchEnabled) cluster_kinemetric.findTouchClusterConstants(); // get tpn
				
				// get sensor point count
				if (ts.sensorEnabled) cluster_kinemetric.findSensorClusterConstants(); // get spn
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
							
			return result		
		} 
		
		public function initTouchGeoMetric2D():void
		{
			// look at global gesture list and check what fiducials are required
			// activate gloabl touch geometric 2d anlysis
			
			if ((core) && (!core_init))
			{
			//trace("geometric 2d premetrics init", core);
			
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
						
					if ((g.cluster_type == "finger") || (g.cluster_type == "all")) 
					{
						fingerTouchPoints = true; 
					}
					if ((g.cluster_type == "tag") || (g.cluster_type == "all")) 
					{			
						tagTouchPoints = true; 
					
							// creat five point tag
							cO.objectArray[0] = new Array()
								cO.objectArray[0][0] = new TouchPointObject();
								cO.objectArray[0][0].dist = 100;
								cO.objectArray[0][1] = new TouchPointObject();
								cO.objectArray[0][1].dist = 96;
								cO.objectArray[0][2] = new TouchPointObject();
								cO.objectArray[0][2].dist = 92;
								cO.objectArray[0][3] = new TouchPointObject();
								cO.objectArray[0][3].dist = 84;
								cO.objectArray[0][4] = new TouchPointObject();
								cO.objectArray[0][4].dist = 76;
					}
					if ((g.cluster_type == "pen") || (g.cluster_type == "all")) 
					{
						penTouchPoints = true; 
					}
			}
			}
			}
					
		}
		
		//ESTABLISHES GLOABL IP SUPPORT
		// SEE TOUCH MANAGER
		public function initPoseGeoMetric3D():void
		{
			//trace("set geometric init",core);
			if ((core)&&(!core_init)){
			
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
						}
					//}
				
			}
				
			}
			//DIDNT REALLY NEED AS FRAME DRIVEN
			core_init = true;
			}
		}
		
		
		
		
		public function getVectorMetrics():void 
		{
			// for unistroke only
			if (cO.ipn == 1) // CHNAGE TO ipn
			{
				cluster_vectormetric.resetPathProperties(); // reset stroke data object
				cluster_vectormetric.getSamplePath(); // collect sample path
			}
			
			// multistroke next
		}
		
		public function getTouchGeoMetrics2D():void
		{
			// can only happen once
			if(core){
				//trace("get geometric 2d",cluster_geometric);
				cluster_geometric.findFingerTouchPoints();
				//cluster_geometric.find2DTagTouchPoints();
				//cluster_geometric.findPenTouchPoints
			}
		}
		
		public function getSkeletalGeoMetrics3D():void 
		{
			//trace("get skeletal geometric");
			
			if (core)
			{
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
					cluster_geometric.dynamicSkeletonUpdate();
			}
		}
		
		public function getPoseGeoMetrics3D():void 
		{
			//TODO:  SET TO BE AWARE OF NUMBER OF FINGERS ASOCOCIATED WITH CONFIG
			// SET TO BE AWARE OF REQUIRED HAND SETTINGS FLATNESS AND ORIENTATION
			
			if (core)//
			{
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
		}
		
		
		public function mapMotion3Dto2D():void 
		{
			//trace("tc mapping motion points", cO.motionArray.length, cO.motionArray2D.length, cluster_geometric );
			if (!ts.transform3d) cluster_geometric.mapMotionPoints3Dto2D();
		}
		
	}
}