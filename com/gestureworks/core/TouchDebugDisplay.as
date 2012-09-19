﻿////////////////////////////////////////////////////////////////////////////////
//
//  IDEUM
//  Copyright 2011-2012 Ideum
//  All Rights Reserved.
//
//  GestureWorks
//
//  File:    TouchSpriteDebugDisplay.as
//  Authors:  Ideum
//             
//  NOTICE: Ideum permits you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////
package com.gestureworks.core
{
	import flash.events.Event;
	import flash.display.Sprite;
	
	import com.gestureworks.utils.debug.*;
	import com.gestureworks.managers.ClusterHistories;
	import com.gestureworks.managers.TransformHistories;

	public class TouchDebugDisplay
	{
		/**
		* @private
		*/
		public var debug_display:Sprite;
		/**
		* @private
		*/
		/**
		* @private
		*/
		private var cluster_vectors:DebugClusterVectors;
		/**
		* @private
		*/
		public var cluster_points:DebugClusterPoints;
		/**
		* @private
		*/
		private var cluster_orient:DebugClusterOrientation;
		private var cluster_vectordata:DebugClusterVectorData;
		/**
		* @private
		*/
		private var cluster_web:DebugClusterWeb;
		/**
		* @private
		*/
		private var cluster_circle:DebugClusterCircle;
		/**
		* @private
		*/
		private var cluster_box:DebugClusterBox;
		/**
		* @private
		*/
		private var cluster_center:DebugClusterCenter;
		/**
		* @private
		*/
		private var cluster_rotation:DebugClusterRotation;
		
		//private var cluster_datalist:DebugClusterDataList;
		//private var cluster_chart:DebugClusterChart;
		/**
		* @private
		*/
		private var cluster_data_view:DebugClusterDataView;
		//private var processing_data_view:DebugTouchObjectDataView;
		/**
		* @private
		*/
		private var gesture_data_view:DebugGestureDataView;
		/**
		* @private
		*/
		private var touchObject_transform:DebugTouchObjectTransform;
		/**
		* @private
		*/
		private var touchObject_pivot:DebugTouchObjectPivot;
		//private var touchObject_datalist:DebugTouchObjectDataList;
		/**
		* @private
		*/
		private var touchObject_data_view:DebugTouchObjectDataView;
		
		
		// point object //////////////////////////
		/**
		* @private
		*/
		private var pointVectorsOn:Boolean = false;
		/**
		* @private
		*/
		private var pointShapesOn:Boolean = false;
		// cluster object //////////////////////////
		/**
		* @private
		*/
		private var clusterWebOn:Boolean = false;
		/**
		* @private
		*/
		private var clusterOrientationOn:Boolean = false;
		private var clusterVectorDataOn:Boolean = false;
		/**
		* @private
		*/
		private var clusterBoxOn:Boolean = false;
		/**
		* @private
		*/
		private var clusterCircleOn:Boolean = false;
		//private var clusterDataOn:Boolean = false;
		//private var clusterChartOn:Boolean = false;
		/**
		* @private
		*/
		private var clusterCenterOn:Boolean = false;
		/**
		* @private
		*/
		private var clusterRotationOn:Boolean = false;
		
		/**
		* @private
		*/
		private var clusterDataViewOn:Boolean = false;
		// processing object //////////////////////////
		/**
		* @private
		*/
		private var processingDataOn:Boolean = false;
		/**
		* @private
		*/
		private var processingDataViewOn:Boolean = false;
		
		// gesture object //////////////////////////
		/**
		* @private
		*/
		private var gestureDataOn:Boolean = false;
		/**
		* @private
		*/
		private var gestureDataViewOn:Boolean = false;
		
		// touch object //////////////////////////
		/**
		* @private
		*/
		private var touchObjectTransformOn:Boolean = false;
		/**
		* @private
		*/
		private var touchObjectPivotOn:Boolean = false;
		/**
		* @private
		*/
		private var touchObjectDataOn:Boolean = false;
		/**
		* @private
		*/
		private var touchObjectDataViewOn:Boolean = false;
		
		/**
		* @private
		*/
		private var viewAlwaysOn:Boolean = false;
		/**
		* @private
		*/
		private var displayRadius:int = 200;
		
		private var ts:Object;
		private var id:int
		
		public function TouchDebugDisplay(touchObjectID:int):void
		{
			id = touchObjectID;
			ts = GestureGlobals.gw_public::touchObjects[id];
			initDebug();
          }
		  
		// initializers    
        public function initDebug():void 
        {
				//trace("create touchsprite debug display")

				debug_display = new Sprite();
				initDebugVars();
				initDebugDisplay();
				
				if (ts.stage) addtostage();
				else ts.addEventListener(Event.ADDED_TO_STAGE, addtostage);
		}
		
		 public function addtostage(e:Event = null):void 
        {
			//trace("added to stage debug")
			ts.stage.addChild(debug_display);
			
		}
		
		public function initDebugVars():void
		{
		//if (trace_debug_mode) trace("init debug cml vars");
		
		ts.cml = new XMLList(CML.Objects)
		var numLayers:int = ts.cml.DebugKit.DebugLayer.length()
			
			ts.debugdisplayOn = ts.cml.DebugKit.attribute("displayOn") == "true" ?true:false;
			viewAlwaysOn = ts.cml.DebugKit.attribute("displayAlwaysOn") == "true" ?true:false;
			displayRadius = int(ts.cml.DebugKit.attribute("displayRadius"));
		
		for (var i:int = 0; i < numLayers; i++) {
			var type:String = ts.cml.DebugKit.DebugLayer[i].attribute("type")
		
			if (type == "point_vectors") pointVectorsOn = ts.cml.DebugKit.DebugLayer[i].attribute("displayOn")== "true" ?true:false;
			if (type == "point_shapes") pointShapesOn  = ts.cml.DebugKit.DebugLayer[i].attribute("displayOn")== "true" ?true:false;
			
			if (type == "cluster_box") clusterBoxOn = ts.cml.DebugKit.DebugLayer[i].attribute("displayOn")== "true" ?true:false;
			if (type == "cluster_circle") clusterCircleOn = ts.cml.DebugKit.DebugLayer[i].attribute("displayOn")== "true" ?true:false;
			if (type == "cluster_center") clusterCenterOn = ts.cml.DebugKit.DebugLayer[i].attribute("displayOn")== "true" ?true:false;
			if (type == "cluster_rotation") clusterRotationOn = ts.cml.DebugKit.DebugLayer[i].attribute("displayOn")== "true" ?true:false;
			if (type == "cluster_web") clusterWebOn  = ts.cml.DebugKit.DebugLayer[i].attribute("displayOn")== "true" ?true:false;
			if (type == "cluster_orientation") clusterOrientationOn  = ts.cml.DebugKit.DebugLayer[i].attribute("displayOn") == "true" ?true:false;
			
			//if (type == "cluster_vector_data") clusterVectorDataOn = cml.DebugKit.DebugLayer[i].attribute("displayOn")== "true" ?true:false;
			//if (type == "cluster_line_chart") clusterChartOn  = cml.DebugKit.DebugLayer[i].attribute("displayOn") == "true" ?true:false;
			//if (type == "cluster_data_list") clusterDataOn  = cml.DebugKit.DebugLayer[i].attribute("displayOn") == "true" ?true:false;
			if (type == "cluster_data_view") clusterDataViewOn  = ts.cml.DebugKit.DebugLayer[i].attribute("displayOn")== "true" ?true:false;
			
			//if (type == "gesture_data_list") gestureDataOn  = cml.DebugKit.DebugLayer[i].attribute("displayOn")== "true" ?true:false;
			if (type == "gesture_data_view") gestureDataViewOn  = ts.cml.DebugKit.DebugLayer[i].attribute("displayOn") == "true" ?true:false;
			
			//if (type == "processing_data_list") processingDataOn  = cml.DebugKit.DebugLayer[i].attribute("displayOn")== "true" ?true:false;
			//if (type == "processing_data_view") processingDataOn  = cml.DebugKit.DebugLayer[i].attribute("displayOn")== "true" ?true:false;
			
			if (type == "touchobject_transform") touchObjectTransformOn = ts.cml.DebugKit.DebugLayer[i].attribute("displayOn")== "true" ?true:false;
			if (type == "touchobject_pivot") touchObjectPivotOn  = ts.cml.DebugKit.DebugLayer[i].attribute("displayOn") == "true" ?true:false;
			//if (type == "touchobject_data_list") touchObjectDataOn  = cml.DebugKit.DebugLayer[i].attribute("displayOn")== "true" ?true:false;
			if (type == "touchobject_data_view") touchObjectDataViewOn  = ts.cml.DebugKit.DebugLayer[i].attribute("displayOn")== "true" ?true:false;
		}
					
	}
	public function initDebugDisplay():void 
	{
		//if (trace_debug_mode) trace("init debug display",touchObjectID);
					/////////////////////////////////////////////////////////////////
					// piont display/
					/////////////////////////////////////////////////////////////////
			if (ts.debugdisplayOn)
			{		
					if(pointVectorsOn){
						// create cluster point circles
						cluster_vectors = new DebugClusterVectors(id);
							cluster_vectors.setStyles();
						debug_display.addChild(cluster_vectors);
               		}
					if(pointShapesOn){
						// create cluster point circles
						cluster_points = new DebugClusterPoints(id);
							cluster_points.setStyles();
						debug_display.addChild(cluster_points);
					}
					
					////////////////////////////////////////////////////////////////////
					// cluster display
					////////////////////////////////////////////////////////////////////
					
					if(clusterBoxOn){
						// create cluster oultine box 
						cluster_box = new DebugClusterBox(id);
							cluster_box.setStyles();
						debug_display.addChild(cluster_box);
					}
					if(clusterCircleOn){
						// create cluster outline circle
						cluster_circle = new DebugClusterCircle(id);
							cluster_circle.setStyles();
						debug_display.addChild(cluster_circle);
					}
					if(clusterWebOn){
						// create cluster web
						cluster_web = new DebugClusterWeb(id);
							cluster_web.setStyles();
						debug_display.addChild(cluster_web);
					}
					if(clusterCenterOn){
						// create cluster centers
						cluster_center = new DebugClusterCenter(id);
							cluster_center.setStyles();
							cluster_center.init();
						debug_display.addChild(cluster_center);
					}
					if(clusterOrientationOn){
						// create cluster orientation
						cluster_orient = new DebugClusterOrientation(id);
							cluster_orient.setStyles();
						debug_display.addChild(cluster_orient);
					}
					if(clusterRotationOn){
						// create cluster outline circle
						cluster_rotation = new DebugClusterRotation(id);
							cluster_rotation.setStyles();
						debug_display.addChild(cluster_rotation);
					}
					
					/*
					if(clusterVectorDataOn){
						// create cluster vectors
						cluster_vectordata = new DebugClusterVectorData(touchObjectID);
							cluster_vectordata.setStyles();
						debug_display.addChild(cluster_vectordata);
					}
					//  cluster table data display
					if(clusterDataOn){
						// create cluster data list
						cluster_datalist = new DebugClusterDataList(touchObjectID);
							cluster_datalist.setStyles();
							cluster_datalist.init();
						debug_display.addChild(cluster_datalist);
					}
					// cluster line char display
					if(clusterChartOn){
						// create cluster data list
						cluster_chart = new DebugClusterChart(touchObjectID);
							cluster_chart.setStyles();
							//cluster_chart.displayRadius(displayRadius);
							cluster_chart.init();
						debug_display.addChild(cluster_chart);
					}
					*/
					// simplified combined data table and line chart display
					if(clusterDataViewOn){
						// create cluster data list
						cluster_data_view = new DebugClusterDataView(id);
							cluster_data_view.setStyles();
							cluster_data_view.displayRadius = displayRadius;
							cluster_data_view.init();
						debug_display.addChild(cluster_data_view);
					}

					///////////////////////////////////////////////////////////////////////
					// gesture display
					///////////////////////////////////////////////////////////////////////
					
					
					///////////////////////////////////////
					// simplified gesture data display 
					///////////////////////////////////////
					if(gestureDataViewOn){
						// create cluster data list
						gesture_data_view = new DebugGestureDataView(id);
							gesture_data_view.setStyles();
							gesture_data_view.displayRadius = displayRadius;
							gesture_data_view.init();
						debug_display.addChild(gesture_data_view);
					}
					
					///////////////////////////////////////////////////////////////////////
					// processing display
					///////////////////////////////////////////////////////////////////////
					
					
					
					
					
					
					
					////////////////////////////////////////////////////////////////////////
					// touch object display
					////////////////////////////////////////////////////////////////////////
					if(touchObjectTransformOn){
						// create cluster data list
						touchObject_transform = new DebugTouchObjectTransform(id);
							touchObject_transform.setStyles();
						debug_display.addChild(touchObject_transform);
					}
					if(touchObjectPivotOn){
						// create cluster data list
						touchObject_pivot = new DebugTouchObjectPivot(id);
							touchObject_pivot.setStyles();
							touchObject_pivot.init();
						debug_display.addChild(touchObject_pivot);
					}
					//////////////////////////////////
					// complete table data
					//////////////////////////////////
					/*
					if(touchObjectDataOn){
						// create cluster data list
						touchObject_datalist = new DebugTouchObjectDataList(touchObjectID);
							touchObject_datalist.setStyles();
							touchObject_datalist.init();
						debug_display.addChild(touchObject_datalist);
					}*/
					//////////////////////////////////
					// simplfied table data
					//////////////////////////////////
					if(touchObjectDataViewOn){
						// create cluster data list
						touchObject_data_view = new DebugTouchObjectDataView(id);
							touchObject_data_view.setStyles();
							touchObject_data_view.displayRadius = displayRadius;
							touchObject_data_view.init();
						debug_display.addChild(touchObject_data_view);
					}
			}
	}
			
	/**
	* @private
	*/
	public function drawDebugDisplay():void
	{
		//if (trace_debug_mode) trace("trying to draw display", N, touchObjectID);
		
		if ((ts.debugdisplayOn)&&(debug_display))
			{
			if (viewAlwaysOn) 
			{
				if (clusterDataViewOn) cluster_data_view.drawDataView();
				if (gestureDataViewOn) gesture_data_view.drawDataView();
				if (touchObjectDataViewOn) touchObject_data_view.drawDataView();
			}
			
			if (ts.N)
			{
				if (ts.N == 1) 
				{
					if (touchObjectPivotOn) touchObject_pivot.drawVectors();
				}
				
				if (ts.N >= 1) 
				{
					if(pointShapesOn)cluster_points.drawPoints();
					if (pointVectorsOn) cluster_vectors.drawVectors();
					//if (clusterVectorDataOn) cluster_vectordata.drawVectorData();
					if (touchObjectTransformOn) touchObject_transform.drawTransform();
					//if (clusterChartOn) cluster_chart.drawChart();
					
					if (!viewAlwaysOn) {
						//if (clusterDataOn) cluster_data_view.drawDataList();
						//if (gestureDataOn) gesture_datalist.drawDataList();
						//if (touchObjectDataOn) touchObject_datalist.drawDataList();
						
						if (clusterDataViewOn) cluster_data_view.drawDataView();
						if (gestureDataViewOn) gesture_data_view.drawDataView();
						if (touchObjectDataViewOn) touchObject_data_view.drawDataView();
					}
				}
				
				if (ts.N >= 2) 
				{
					//if (clusterVectorDataOn) cluster_vectordata.drawVectorData();
					if(clusterWebOn)cluster_web.drawWeb();
					if(clusterBoxOn)cluster_box.drawBox();			
					if(clusterCircleOn)cluster_circle.drawCircle();
					if(clusterCenterOn)cluster_center.drawCenter();
					if(clusterRotationOn)cluster_rotation.drawRotation();
					
					//if (clusterDataOn) cluster_datalist.drawDataList();
					//if (clusterDataViewOn) cluster_data_view.drawDataView();
					//if (gestureDataOn) gesture_datalist.drawDataList();
					//if (gestureDataViewOn) gesture_data_view.drawDataView();
					//if (touchObjectDataOn) touchObject_datalist.drawDataList();
					//if (touchObjectDataViewOn) touchObject_data_view.drawDataView();
				}
				
				 if (ts.N == 5) 
				{
					if(clusterOrientationOn)cluster_orient.drawOrientation();
				}
			}
		}
	}
	/**
	* @private
	*/
	public function clearDebugDisplay():void
	{
		//if(trace_debug_mode) trace("trying to clear debug display",touchObjectID)
		
		if ((ts.debugdisplayOn)&&(debug_display))
		{
			if(pointVectorsOn)cluster_vectors.clear();
			if (pointShapesOn) cluster_points.clear();
			
			if(clusterOrientationOn)cluster_orient.clear();
			//if(clusterVectorDataOn)cluster_vectordata.clear();
			if (clusterWebOn) cluster_web.clear();
			if (clusterBoxOn) cluster_box.clear();	
			if (clusterCircleOn) cluster_circle.clear();
			if (clusterCenterOn) cluster_center.clear();
			if (clusterRotationOn) cluster_rotation.clear();
			//if (clusterDataOn) cluster_datalist.clear();
			
			//if (clusterChartOn) cluster_chart.clear();
			if (touchObjectPivotOn) touchObject_pivot.clear();
			if (touchObjectTransformOn) touchObject_transform.clear();
			
			if (!viewAlwaysOn) {
				//if (clusterDataOn) cluster_datalist.clear();
				//if (gestureDataOn) gesture_datalist.clear();
				//if (touchObjectDataOn) touchObject_datalist.clear();
				
				if (clusterDataViewOn) cluster_data_view.clear();		
				if (gestureDataViewOn) gesture_data_view.clear();
				if (touchObjectDataViewOn) touchObject_data_view.clear();
			}
		}
	}
	/**
	* @private
	*/
	public function updateDebugDisplay():void
	{
		if (debug_display)
			{
			clearDebugDisplay();
			drawDebugDisplay();
			}
	}
	//////////////////////////////////////////////////////////////////////////////////////////	
	
	}
}