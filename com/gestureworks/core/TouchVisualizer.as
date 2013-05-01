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
	
	import com.gestureworks.analysis.PointVisualizer;
	import com.gestureworks.analysis.ClusterVisualizer;
	import com.gestureworks.analysis.GestureVisualizer;
	
	import com.gestureworks.managers.ClusterHistories;
	import com.gestureworks.managers.TransformHistories;

	public class TouchVisualizer
	{
		/**
		* @private
		*/
		private var ts:TouchSprite;
		/**
		* @private
		*/
		private var id:uint
		/**
		* displays touch cluster and gesture visulizations on the touchSprite.
		*/
		public var debug_display:Sprite;
		/**
		* @private
		*/
		private var point_visualizer:PointVisualizer;
		/**
		* @private
		*/
		private var cluster_visualizer:ClusterVisualizer;
		/**
		* @private
		*/
		private var gesture_visualizer:GestureVisualizer;
		/**
		* @private
		*/
		private var viewAlwaysOn:Boolean = false;
		/**
		* @private
		*/
		private var _pointDisplay:Boolean = true;
		/**
		* activates point visualization methods.
		*/
		public function get pointDisplay():Boolean { return _pointDisplay; }
		/**
		* activates point visualization methods.
		*/
		public function set pointDisplay(value:Boolean):void{_pointDisplay = value;}
		/**
		* @private
		*/
		private var _clusterDisplay:Boolean = true;
		/**
		* activates cluster visualization methods.
		*/
		public function get clusterDisplay():Boolean { return _clusterDisplay; }
		/**
		* activates cluster visualization methods.
		*/
		public function set clusterDisplay(value:Boolean):void { _clusterDisplay = value; }
		/**
		* @private
		*/
		private var _gestureDisplay:Boolean = true;
		/**
		* activates gesture visualization methods.
		*/
		public function get gestureDisplay():Boolean { return _gestureDisplay; }
		/**
		* activates gesture visualization methods.
		*/
		public function set gestureDisplay(value:Boolean):void{_gestureDisplay = value;}
		
		
		
		
		
		
		
		public function TouchVisualizer(touchObjectID:int):void
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
			
			for (var i:int = 0; i < numLayers; i++) {
				var type:String = ts.cml.DebugKit.DebugLayer[i].attribute("type")
			
				if (type == "point") pointDisplay = ts.cml.DebugKit.DebugLayer[i].attribute("displayOn") == "true" ?true:false;
				if (type == "cluster") clusterDisplay = ts.cml.DebugKit.DebugLayer[i].attribute("displayOn") == "true" ?true:false;
				if (type == "gesture") gestureDisplay = ts.cml.DebugKit.DebugLayer[i].attribute("displayOn")== "true" ?true:false;
			}
		}
		
	}
	public function initDebugDisplay():void 
	{
		//if (trace_debug_mode) trace("init debug display",touchObjectID);
					
			if (ts.debugDisplay)
			{		
					/////////////////////////////////////////////////////////////////
					// point display
					/////////////////////////////////////////////////////////////////
					if (pointDisplay) 
					{
						point_visualizer = new PointVisualizer(id);
							point_visualizer.setStyles();
						debug_display.addChild(point_visualizer);
					}
					
					////////////////////////////////////////////////////////////////////
					// cluster display
					////////////////////////////////////////////////////////////////////
					if (clusterDisplay) 
					{	
						cluster_visualizer = new ClusterVisualizer(id);
							cluster_visualizer.setStyles();
							cluster_visualizer.init();
						debug_display.addChild(cluster_visualizer);
						
						// NOTE ADD CLUSTER VECTORS
					}
					
					////////////////////////////////////////////////////////////////////////
					//  gesture touch object display
					////////////////////////////////////////////////////////////////////////
					if (gestureDisplay)
					{	
						gesture_visualizer = new GestureVisualizer(id);
							//gesture_visualizer.setStyles();
							gesture_visualizer.init();
						debug_display.addChild(gesture_visualizer);
					}
			}
	}
			
	/**
	* @private
	*/
	public function drawDebugDisplay():void
	{
		//trace("trying to draw display",ts.debugDisplay,debug_display);
		if ((ts.debugDisplay)&&(debug_display))
			{
			
			// touch points
			if (ts.N)
			{
				if (pointDisplay) 	point_visualizer.draw();
				if (clusterDisplay)	cluster_visualizer.draw();
				if (gestureDisplay) gesture_visualizer.draw();
				
			}
			
			// motion points
			if (ts.cO.fn) 
			{	
				if (pointDisplay)	point_visualizer.draw();
				if (clusterDisplay)	cluster_visualizer.draw();
				if (gestureDisplay) gesture_visualizer.draw();
			}
			
			//sensor points
			//if (ts.cO.sn) 
			//{	
				//if (pointDisplay)	point_visualizer.draw();
				//if (clusterDisplay)	cluster_visualizer.draw();
				//if (gestureDisplay) gesture_visualizer.draw();
			//}
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
			if (pointDisplay) 	point_visualizer.clear();
			if (clusterDisplay) cluster_visualizer.clear();
			if (gestureDisplay) gesture_visualizer.clear();
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