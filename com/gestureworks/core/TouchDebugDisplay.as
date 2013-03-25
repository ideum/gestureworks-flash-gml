////////////////////////////////////////////////////////////////////////////////
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
		private var _pointVectorsOn:Boolean = false;
		public function get pointVectorsOn():Boolean
		{
			return _pointVectorsOn;
		}
		public function set pointVectorsOn(value:Boolean):void
		{
			_pointVectorsOn = value;
		}
		
		/**
		* @private
		*/
		private var _pointShapesOn:Boolean = false;
		public function get pointShapesOn():Boolean
		{
			return _pointShapesOn;
		}
		public function set pointShapesOn(value:Boolean):void
		{
			_pointShapesOn = value;
		}
		
		
		// cluster object //////////////////////////
		/**
		* @private
		*/
		private var _clusterWebOn:Boolean = false;
		/**
		* @private
		*/
		private var _clusterOrientationOn:Boolean = false;
		private var _clusterVectorDataOn:Boolean = false;
		/**
		* @private
		*/
		private var _clusterBoxOn:Boolean = false;
		/**
		* @private
		*/
		private var _clusterCircleOn:Boolean = false;
		//private var clusterDataOn:Boolean = false;
		//private var clusterChartOn:Boolean = false;
		/**
		* @private
		*/
		private var _clusterCenterOn:Boolean = false;
		/**
		* @private
		*/
		private var _clusterRotationOn:Boolean = false;
		
		/**
		* @private
		*/
		private var _clusterDataViewOn:Boolean = false;
		// processing object //////////////////////////
		/**
		* @private
		*/
		private var _processingDataOn:Boolean = false;
		/**
		* @private
		*/
		private var _processingDataViewOn:Boolean = false;
		
		// gesture object //////////////////////////
		/**
		* @private
		*/
		private var _gestureDataOn:Boolean = false;
		/**
		* @private
		*/
		private var _gestureDataViewOn:Boolean = false;
		
		// touch object //////////////////////////
		/**
		* @private
		*/
		private var _touchObjectTransformOn:Boolean = false;
		/**
		* @private
		*/
		private var _touchObjectPivotOn:Boolean = false;
		/**
		* @private
		*/
		private var _touchObjectDataOn:Boolean = false;
		/**
		* @private
		*/
		private var _touchObjectDataViewOn:Boolean = false;
		
		/**
		* @private
		*/
		private var viewAlwaysOn:Boolean = false;
		/**
		* @private
		*/
		private var displayRadius:int = 200;
		
		
		
		private var _pointData:Boolean = true;
		public function get pointData():Boolean
		{
			return _pointData;
		}
		public function set pointData(value:Boolean):void
		{
			_pointData = value;
		}
		private var _panelData:Boolean = false;
		public function get panelData():Boolean
		{
			return _panelData;
		}
		public function set panelData(value:Boolean):void
		{
			_panelData = value;
		}
		private var _touchObjectData:Boolean = true;
		public function get touchObjectData():Boolean
		{
			return _touchObjectData;
		}
		public function set touchObjectData(value:Boolean):void
		{
			_touchObjectData = value;
		}
		
		
		
		
		
		
		
		
		
		
		
		private var ts:Object;
		private var id:uint
		
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
		//if (trace_debug_mode) 
		//trace("init debug cml vars");
		
		//trace(_pointData,_panelData,_touchObjectData)
		
		if (CML.Objects != null) 
		{
			ts.cml = new XMLList(CML.Objects)
			var numLayers:int = ts.cml.DebugKit.DebugLayer.length()
				
				ts.debugDisplay = ts.cml.DebugKit.attribute("displayOn") == "true" ?true:false;
				viewAlwaysOn = ts.cml.DebugKit.attribute("displayAlwaysOn") == "true" ?true:false;
				displayRadius = int(ts.cml.DebugKit.attribute("displayRadius"));
			
			for (var i:int = 0; i < numLayers; i++) {
				var type:String = ts.cml.DebugKit.DebugLayer[i].attribute("type")
			
				if (type == "point_vectors") _pointVectorsOn = ts.cml.DebugKit.DebugLayer[i].attribute("displayOn")== "true" ?true:false;
				if (type == "point_shapes") _pointShapesOn  = ts.cml.DebugKit.DebugLayer[i].attribute("displayOn")== "true" ?true:false;
				
				if (type == "cluster_box") _clusterBoxOn = ts.cml.DebugKit.DebugLayer[i].attribute("displayOn")== "true" ?true:false;
				if (type == "cluster_circle") _clusterCircleOn = ts.cml.DebugKit.DebugLayer[i].attribute("displayOn")== "true" ?true:false;
				if (type == "cluster_center") _clusterCenterOn = ts.cml.DebugKit.DebugLayer[i].attribute("displayOn")== "true" ?true:false;
				if (type == "cluster_rotation") _clusterRotationOn = ts.cml.DebugKit.DebugLayer[i].attribute("displayOn")== "true" ?true:false;
				if (type == "cluster_web") _clusterWebOn  = ts.cml.DebugKit.DebugLayer[i].attribute("displayOn")== "true" ?true:false;
				if (type == "cluster_orientation") _clusterOrientationOn  = ts.cml.DebugKit.DebugLayer[i].attribute("displayOn") == "true" ?true:false;
				
				//if (type == "cluster_vector_data") clusterVectorDataOn = cml.DebugKit.DebugLayer[i].attribute("displayOn")== "true" ?true:false;
				//if (type == "cluster_line_chart") clusterChartOn  = cml.DebugKit.DebugLayer[i].attribute("displayOn") == "true" ?true:false;
				//if (type == "cluster_data_list") clusterDataOn  = cml.DebugKit.DebugLayer[i].attribute("displayOn") == "true" ?true:false;
				if (type == "cluster_data_view") _clusterDataViewOn  = ts.cml.DebugKit.DebugLayer[i].attribute("displayOn")== "true" ?true:false;
				
				//if (type == "gesture_data_list") gestureDataOn  = cml.DebugKit.DebugLayer[i].attribute("displayOn")== "true" ?true:false;
				if (type == "gesture_data_view") _gestureDataViewOn  = ts.cml.DebugKit.DebugLayer[i].attribute("displayOn") == "true" ?true:false;
				
				//if (type == "processing_data_list") processingDataOn  = cml.DebugKit.DebugLayer[i].attribute("displayOn")== "true" ?true:false;
				//if (type == "processing_data_view") processingDataOn  = cml.DebugKit.DebugLayer[i].attribute("displayOn")== "true" ?true:false;
				
				if (type == "touchobject_transform") _touchObjectTransformOn = ts.cml.DebugKit.DebugLayer[i].attribute("displayOn")== "true" ?true:false;
				if (type == "touchobject_pivot") _touchObjectPivotOn  = ts.cml.DebugKit.DebugLayer[i].attribute("displayOn") == "true" ?true:false;
				//if (type == "touchobject_data_list") touchObjectDataOn  = cml.DebugKit.DebugLayer[i].attribute("displayOn")== "true" ?true:false;
				if (type == "touchobject_data_view") _touchObjectDataViewOn  = ts.cml.DebugKit.DebugLayer[i].attribute("displayOn")== "true" ?true:false;
			}
		}
		
		else if(ts.debugDisplay)
		{
			if (_pointData)
			{
				//trace("point data");
				_pointVectorsOn = true;
				_pointShapesOn = true;
				_clusterBoxOn = true;
				_clusterCenterOn = true;
				_clusterCircleOn = true;
				_clusterRotationOn = true;
				_clusterWebOn = true;
				_clusterOrientationOn = true;
			}
			if (_panelData) 
			{
				//trace("panel data")
				_clusterDataViewOn = true;
				_gestureDataViewOn = true;
				_touchObjectDataViewOn = true;
			}
			if (_touchObjectData) 
			{
				//trace("touch object data")
				_touchObjectTransformOn = true;
				_touchObjectPivotOn = true;
			}
		}
		
	}
	public function initDebugDisplay():void 
	{
		//if (trace_debug_mode) trace("init debug display",touchObjectID);
					/////////////////////////////////////////////////////////////////
					// piont display/
					/////////////////////////////////////////////////////////////////
			if (ts.debugDisplay)
			{		
					if(_pointVectorsOn){
						// create cluster point circles
						cluster_vectors = new DebugClusterVectors(id);
							cluster_vectors.setStyles();
						debug_display.addChild(cluster_vectors);
               		}
					if(_pointShapesOn){
						// create cluster point circles
						cluster_points = new DebugClusterPoints(id);
							cluster_points.setStyles();
						debug_display.addChild(cluster_points);
					}
					
					////////////////////////////////////////////////////////////////////
					// cluster display
					////////////////////////////////////////////////////////////////////
					
					if(_clusterBoxOn){
						// create cluster oultine box 
						cluster_box = new DebugClusterBox(id);
							cluster_box.setStyles();
						debug_display.addChild(cluster_box);
					}
					if(_clusterCircleOn){
						// create cluster outline circle
						cluster_circle = new DebugClusterCircle(id);
							cluster_circle.setStyles();
						debug_display.addChild(cluster_circle);
					}
					if(_clusterWebOn){
						// create cluster web
						cluster_web = new DebugClusterWeb(id);
							cluster_web.setStyles();
						debug_display.addChild(cluster_web);
					}
					if(_clusterCenterOn){
						// create cluster centers
						cluster_center = new DebugClusterCenter(id);
							cluster_center.setStyles();
							cluster_center.init();
						debug_display.addChild(cluster_center);
					}
					if(_clusterOrientationOn){
						// create cluster orientation
						cluster_orient = new DebugClusterOrientation(id);
							cluster_orient.setStyles();
						debug_display.addChild(cluster_orient);
					}
					if(_clusterRotationOn){
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
					if(_clusterDataViewOn){
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
					if(_gestureDataViewOn){
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
					if(_touchObjectTransformOn){
						// create cluster data list
						touchObject_transform = new DebugTouchObjectTransform(id);
							touchObject_transform.setStyles();
						debug_display.addChild(touchObject_transform);
					}
					if(_touchObjectPivotOn){
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
					if(_touchObjectDataViewOn){
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
		//if (trace_debug_mode) 
		//trace("trying to draw display",ts.debugDisplay,debug_display);
		
		if ((ts.debugDisplay)&&(debug_display))
			{
			if (viewAlwaysOn) 
			{
				if (_clusterDataViewOn) cluster_data_view.drawDataView();
				if (_gestureDataViewOn) gesture_data_view.drawDataView();
				if (_touchObjectDataViewOn) touchObject_data_view.drawDataView();
			}
			
			if (ts.N)
			{
				if (ts.N == 1) 
				{
					if (_touchObjectPivotOn) touchObject_pivot.drawVectors();
				}
				
				if (ts.N >= 1) 
				{
					//trace("drawDebugDisplay");
					if(_pointShapesOn)cluster_points.drawPoints();
					if (_pointVectorsOn) cluster_vectors.drawVectors();
					//if (clusterVectorDataOn) cluster_vectordata.drawVectorData();
					if (_touchObjectTransformOn) touchObject_transform.drawTransform();
					//if (clusterChartOn) cluster_chart.drawChart();
					
					if (!viewAlwaysOn) {
						//if (clusterDataOn) cluster_data_view.drawDataList();
						//if (gestureDataOn) gesture_datalist.drawDataList();
						//if (touchObjectDataOn) touchObject_datalist.drawDataList();
						
						if (_clusterDataViewOn) cluster_data_view.drawDataView();
						if (_gestureDataViewOn) gesture_data_view.drawDataView();
						if (_touchObjectDataViewOn) touchObject_data_view.drawDataView();
					}
				}
				
				if (ts.N >= 2) 
				{
					//if (clusterVectorDataOn) cluster_vectordata.drawVectorData();
					if(_clusterWebOn)cluster_web.drawWeb();
					if(_clusterBoxOn)cluster_box.drawBox();			
					if(_clusterCircleOn)cluster_circle.drawCircle();
					if(_clusterCenterOn)cluster_center.drawCenter();
					if(_clusterRotationOn)cluster_rotation.drawRotation();
					
					//if (clusterDataOn) cluster_datalist.drawDataList();
					//if (clusterDataViewOn) cluster_data_view.drawDataView();
					//if (gestureDataOn) gesture_datalist.drawDataList();
					//if (gestureDataViewOn) gesture_data_view.drawDataView();
					//if (touchObjectDataOn) touchObject_datalist.drawDataList();
					//if (touchObjectDataViewOn) touchObject_data_view.drawDataView();
				}
				
				 if (ts.N == 5) 
				{
					if(_clusterOrientationOn)cluster_orient.drawOrientation();
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
		
		if ((ts.debugDisplay)&&(debug_display))
		{
			if(_pointVectorsOn) cluster_vectors.clear();
			if (_pointShapesOn) cluster_points.clear();
			
			if(_clusterOrientationOn)cluster_orient.clear();
			//if(clusterVectorDataOn)cluster_vectordata.clear();
			if (_clusterWebOn) cluster_web.clear();
			if (_clusterBoxOn) cluster_box.clear();	
			if (_clusterCircleOn) cluster_circle.clear();
			if (_clusterCenterOn) cluster_center.clear();
			if (_clusterRotationOn) cluster_rotation.clear();
			//if (clusterDataOn) cluster_datalist.clear();
			
			//if (clusterChartOn) cluster_chart.clear();
			if (_touchObjectPivotOn) touchObject_pivot.clear();
			if (_touchObjectTransformOn) touchObject_transform.clear();
			
			if (!viewAlwaysOn) {
				//if (clusterDataOn) cluster_datalist.clear();
				//if (gestureDataOn) gesture_datalist.clear();
				//if (touchObjectDataOn) touchObject_datalist.clear();
				
				if (_clusterDataViewOn) cluster_data_view.clear();		
				if (_gestureDataViewOn) gesture_data_view.clear();
				if (_touchObjectDataViewOn) touchObject_data_view.clear();
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