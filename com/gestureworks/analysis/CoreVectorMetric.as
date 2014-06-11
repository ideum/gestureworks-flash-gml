////////////////////////////////////////////////////////////////////////////////
//
//  IDEUM
//  Copyright 2011-2012 Ideum
//  All Rights Reserved.
//
//  GestureWorks
//
//  File:    CoreVectorMetric.as
//  Authors:  Ideum
//             
//  NOTICE: Ideum permits you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////
package com.gestureworks.analysis
{
	import com.gestureworks.managers.PoolManager;
	import flash.display.Sprite;
	import flash.events.TouchEvent;
	import flash.geom.Point;
	
	import com.gestureworks.events.GWEvent;
	import com.gestureworks.events.GWGestureEvent;
	//import com.gestureworks.analysis.GesturePipeline;
	import com.gestureworks.analysis.CoreTemporalMetric;
	
	//import com.gestureworks.managers.TimelineHistories;
	import com.gestureworks.objects.FrameObject; 
	import com.gestureworks.objects.DimensionObject;
	
	import com.gestureworks.objects.ipClusterObject;
	import com.gestureworks.objects.StrokeObject;
	import com.gestureworks.objects.GestureListObject;
	import com.gestureworks.objects.TimelineObject;
	
	public class CoreVectorMetric extends Sprite
	{
		/**
		* @private
		*/
		//internal public
		//public var gesture_cont:GesturePipeline;
		/**
		* @private
		*/
		//public var gesture_disc:CoreTemporalMetric;
		
		/**
		* @private
		*/
		private var gn:uint;
		private var key:uint;
		private var DIM:uint; 
		private var tapOn:Boolean = false;
		
		private var timerCount:int = 0;
		
		private var ts:Object;
		private var id:uint;
		
		//private var cO:ipClusterObject
		private var sO:StrokeObject
		private var gO:GestureListObject;
		private var tiO:TimelineObject;
		
		private var sub_cO:ipClusterObject
		/////////////////////////////////////////////////////////
		
		public function CoreVectorMetric():void
		{
			//super();
			id = touchObjectID;
			//ts = GestureGlobals.gw_public::touchObjects[id];
			
			//sub_cO = new ipClusterObject();
			
			//TODO: POINT TO RELEVANT SUBCLUSTER 
			
			//gO = GestureGlobals.gw_public::gestures[id]//ts.gO;
			
			initGesture();
         }
		
		/**
		* @private
		*/
		public function initStroke():void
		{
			gn = gO.pOList.length;
			for (key=0; key < gn; key++) 
			//for (key in gO.pOList)
			{	
				//MAKE GML PROGRAMMABLE SET GLOBAL POINT HISTORY
				if (gO.pOList[key].gesture_type == "stroke") GestureGlobals.pointHistoryCaptureLength = 150; // define in GML

				//trace("tsgesture, timelineon:",tiO.timelineOn, tiO.timelineInit);
			}	
			//trace("init timeline",tapOn,tiO.timelineOn);
		}
		
		/**
		* @private
		*/
		//////////////////////////////////////////////////////
		// currently not used
		// intended for non tap gestures that require timeline 
		// analysis like gesture sequencing
		//////////////////////////////////////////////////////
		private function updateTimelineGestureAnalysis():void
		{
			//findTimelineGestures();
		}
		
		/**
		* @private
		*/
		public function manageGestureEventDispatch():void 
		{
			//trace("manage dispatch-----------------------------");
			//////////////////////////////////////////////////////////////
			// ONLY IF GESTURE EVENTS ARE ACTIVE
			if (ts.gestureEvents)processVectorMetric();
		}
		
		////////////////////////////////////////////////////////////////////////////////////
		///////////////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////////
		
		public function processVectorMetric():void {
			
			//trace("process vector metric");
			
			var strokeCalled:Boolean = false;
			
			for (key = 0; key < gn; key++) 
			{
				//if (ts.gestureList[gO.pOList[key].gesture_id])||(ts.gestureList[gO.pOList[key].gesture_set_id])) so can validate set
				//{
					if (gO.pOList[key].gesture_type == "stroke")
						{
							if ((ts.cO.remove) && (!gO.pOList[key].complete)&&(!strokeCalled)) 
								{
								//trace("find stroke..", cO.path_data, cO.history[0].path_data);
												
								var pn:uint = sO.path_n;
								// MAKES SURE PATH IS LONG ENOUGHT TO RESAMPLE
								if (pn > 60)
								{
									ts.tc.cluster_vectormetric.normalizeSamplePath();
									ts.tc.cluster_vectormetric.findStrokeGesture();
									strokeCalled = true;
									//trace("touch gesture call stroke analysis");
								}
								//else ts.tc.cluster_vectormetric.resetPathProperties();
							}
						gO.pOList[key].complete = true;
						}
						
					if (gO.pOList[key].gesture_type == "path")
						{
							//trace("find path data");
							// path layout tool
							// resample based on number of touch object in group
							// return point list to peg objects on path
						}
				//}
			}
		}
		
		
	}
}