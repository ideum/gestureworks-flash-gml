﻿////////////////////////////////////////////////////////////////////////////////
//
//  IDEUM
//  Copyright 2011-2012 Ideum
//  All Rights Reserved.
//
//  GestureWorks
//
//  File:    TouchSpriteBase.as
//  Authors:  Ideum
//             
//  NOTICE: Ideum permits you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////
package com.gestureworks.core
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.events.TouchEvent;
	import flash.geom.Point;

	import com.gestureworks.core.GestureWorks;
	import com.gestureworks.core.GestureGlobals;
	import com.gestureworks.core.gw_public;
	import com.gestureworks.core.CML;
	import com.gestureworks.core.GML;
	
	import com.gestureworks.managers.TouchManager;
	import com.gestureworks.managers.ObjectManager;
	import com.gestureworks.managers.MouseManager;
	
	import com.gestureworks.objects.PointObject;
	import com.gestureworks.objects.PropertyObject;
	import com.gestureworks.objects.ClusterObject;
	import com.gestureworks.objects.ProcessObject;
	import com.gestureworks.objects.GestureObject;
	import com.gestureworks.objects.TimelineObject;
	import com.gestureworks.objects.TransformObject;
	
	import com.gestureworks.utils.GestureParser;
	import com.gestureworks.utils.MousePoint;
	
	
	/**
	 * The TouchSpriteBase class is the base class for all touch and gestures enabled
	 * Sprites that require additional display list management. 
	 * 
	 * <pre>
	 * 	<b>Properties</b>
	 * 	 blobContainerEnabled="false"
	 * 	 touchChildren="false"
	 * 	 targetParent = "false"
	 * </pre>
	 */
	
	public class TouchSpriteBase extends Sprite
	{
		/**
		 * @private
		 */
		public var point:*;
		/**
		 * @private
		 */
		public var gml:XMLList;
		/**
		 * @private
		 */
		public var cml:XMLList;
		
		// internal public 
		public var cO:ClusterObject;
		public var pO:ProcessObject;
		public var gO:GestureObject;
		public var tiO:TimelineObject;
		public var trO:TransformObject;
		
		public function TouchSpriteBase():void
		{
			super();
			initBase();
        }
		  
		// initializers
         private function initBase():void 
         {
			//trace("create touchsprite base");
					
				    // add touch event listener 
					if (GestureWorks.supportsTouch) addEventListener(TouchEvent.TOUCH_BEGIN, onTouchDown, false, 0, true); // bubbles up when nested
					//if (GestureWorks.supportsTouch) addEventListener(TouchEvent.TOUCH_BEGIN, onTouchDown, true, 0, true); 
					//if (GestureWorks.supportsTouch) addEventListener(TouchEvent.TOUCH_END, onTouchUp, false,0,true); // bubbles up when nested
					else addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
					
					// set mouseChildren to default
					mouseChildren = false;
									
					// Register touchObject with object manager, return object id
					_touchObjectID = ObjectManager.registerTouchObject(this);
					GestureGlobals.gw_public::touchObjects[_touchObjectID] = this;
					
					// create generic analysis engine
					//if (GestureGlobals.analyzeCluster)
						//{
						/////////////////////////////////////////////////////////////////////////
						// CREATES A NEW CLUSTER OBJECT FOT THE TOUCHSPRITE
						// HANDLES CORE GEOMETRIC RAW PROPERTIES OF THE CLUSTER
						/////////////////////////////////////////////////////////////////////////
						cO = new ClusterObject();
							cO.id = touchObjectID;
						GestureGlobals.gw_public::clusters[_touchObjectID] = cO;
						
						/////////////////////////////////////////////////////////////////////////
						// CREATES A NEW PROCESS OBJECT FOT THE TOUCHSPRITE
						// A VEHICLE TO CONTAIN CORE PROCESSED (FILTERED) CLUSTER VALUES
						/////////////////////////////////////////////////////////////////////////
						pO = new ProcessObject();
							pO.id = touchObjectID;
						GestureGlobals.gw_public::processes[_touchObjectID] = pO;
						
						/////////////////////////////////////////////////////////////////////////
						// CREATERS A NEW GESTURE OBJECT
						// A VEHICLE TO CONTAIN CORE GESTURE VALUES
						/////////////////////////////////////////////////////////////////////////
						gO = new GestureObject();
							gO.id = touchObjectID;
						GestureGlobals.gw_public::gestures[_touchObjectID] = gO;
						
						/////////////////////////////////////////////////////////////////////////
						// CREATES A NEW TRANSFORM OBJECT
						// ACTS AS A VIRTUAL DISPLAY OBJECT CONTAINS ALL THE MODIFIED AND MAPPED
						// DISPLAY PROPERTIES TO BE TRANSFERED TO THE TOUCHSPRITE
						/////////////////////////////////////////////////////////////////////////
						trO = new TransformObject();
							trO.id = touchObjectID;
						GestureGlobals.gw_public::transforms[_touchObjectID] = trO;
						
						/////////////////////////////////////////////////////////////////////////
						// CREATES A NEW TIMLINE OBJECT 
						// CONTAINS A HISTORY OF ALL TOUCH EVENTS, CLUSTER EVENTS, GESTURE EVENTS 
						// AND TRANSFORM EVENTS THAT OCCUR ON THE TOUCHSPRITE
						/////////////////////////////////////////////////////////////////////////
						tiO = new TimelineObject();
							tiO.id = touchObjectID;
							tiO.timelineOn = false; // activates timlein manager
							tiO.pointEvents = false; // pushes point events into timline
							tiO.clusterEvents = false; // pushes cluster events into timeline
							tiO.gestureEvents = false; // pushes gesture events into timleine
							tiO.transformEvents = false; // pushes transform events into timeline
						GestureGlobals.gw_public::timelines[_touchObjectID] = tiO;
					//}
		}
		
		
		////////////////////////////////////////////////////////////////
		// public read only
		////////////////////////////////////////////////////////////////
		//public var _componentID:int = 0; //read only
		//public function get componentID():int { return _componentID;}
		/**
		 * @private
		 */
		public var _touchObjectID:int = 0; // read only
		public function get touchObjectID():int { return _touchObjectID; }
		/**
		 * @private
		 */
		public var _pointArray:Array = new Array(); // read only
		public function get pointArray():Array { return _pointArray; }
		/**
		 * @private
		 */
		public var _N:int = 0; // number of touch points in the cluster // read only
		public function get N():int { return _N; }
		/**
		 * @private
		 */
		public var _dN:Number = 0; // read only
		public function get dN():Number { return _dN; }
		
		// determin if object created by cml of native as3
		/**
		 * @private
		 */
		public var _cml_item:Boolean = false;
		public function get cml_item():Boolean{return _cml_item;}
		public function set cml_item(value:Boolean):void
		{
			_cml_item=value;
		}
		
		// debug trace statements
		/**
		 * @private
		 */
		public var trace_debug_mode:Boolean = false;
		public function get traceDebugModeOn():Boolean{return trace_debug_mode;}
		public function set traceDebugModeOn(value:Boolean):void
		{
			trace_debug_mode=value;
		}
		
		// point count
		/**
		 * @private
		 */
		private var _pointCount:int;
		public function get pointCount():int{return _pointCount;}
		public function set pointCount(value:int):void
		{
			_pointCount=value;
		}
		
		// cluster ID
		/**
		 * @private
		 */
		private var _clusterID:int;
		public function get clusterID():int{return _clusterID;}
		public function set clusterID(value:int):void
		{
			_clusterID = value;
		}
		/**
		 * @private
		 */
		private var _gestureList:Object = new Object();
		public function get gestureList():Object
		{
			return _gestureList;
		}
		public function set gestureList(value:Object):void
		{
			_gestureList = value;
			
			for (var i:String in gestureList) 
			{
				gestureList[i] = gestureList[i].toString() == "true" ?true:false;
				if (trace_debug_mode) trace("setting gestureList:", gestureList[i]);
			}
			
			/////////////////////////////////////////////////////////////////////
			// Convert GML Into Property Objects That describe how to match,analyze, 
			// process and map point/clusterobject properties
			/////////////////////////////////////////////////////////////////////
			callLocalGestureParser();
		}
		/**
		 * @private
		 */
		private function callLocalGestureParser():void
		{
			var gp:GestureParser = new GestureParser();
				gp.gestureList = gestureList;
				gp.parse(touchObjectID);
				
				if(trace_debug_mode) gp.traceGesturePropertyList();
		}
		/**
		 * @private
		 */
		private function onMouseDown(e:MouseEvent):void
		{			
			var pointID:int = MousePoint.getID();
			
			var event:TouchEvent = new TouchEvent(TouchEvent.TOUCH_BEGIN, true, false, pointID, false, e.stageX, e.stageY);
			onTouchDown(event);
		}
		/**
		 * @private
		 */
		private var _touchChildren:Boolean = false;
		public function get touchChildren():Boolean{return _touchChildren;}
		public function set touchChildren(value:Boolean):void
		{
			_touchChildren = value;
			
			// reset bubling on touch listener
			if (value) mouseChildren = true;
			else mouseChildren = false;
		}
		/**
		 * @private
		 */
		private var _pointContainerEnabled:Boolean = false;
		public function get pointContainerEnabled():Boolean{return _pointContainerEnabled;}
		public function set pointContainerEnabled(value:Boolean):void
		{
			_pointContainerEnabled = value;
		}
		
		/**
		 * @private
		 */
		/*
		private function removeCaptureListener():void
		{
			removeEventListener(TouchEvent.TOUCH_BEGIN, onTouchDown,true);
			addEventListener(TouchEvent.TOUCH_BEGIN, onTouchDown,false, 0,true);
		}
		*/
		/**
		 * @private
		 */
		/*
		private function addCaptureListener():void
		{
			removeEventListener(TouchEvent.TOUCH_BEGIN, onTouchDown, false);
			addEventListener(TouchEvent.TOUCH_BEGIN, onTouchDown, true,0,true);
		}
		*/
		/**
		 * @private
		 */
		// allows touch and gesture events to explicitly target parent touch object
		private var _targetParent:Boolean = false
		public function get targetParent():Boolean{return _targetParent;}
		public function set targetParent(value:Boolean):void
		{
			_targetParent = value;
		}
		
		/**
		 * @private
		 */
		// turns off targeting
		private var _targeting:Boolean = true;
		public function get targeting():Boolean{return _targeting;}
		public function set targeting(value:Boolean):void
		{
			_targeting = value;
		}
		
		/**
		 * @private
		 */
		// allows all touch and gesture events be to explicitly urned off
		//private var _touchable:Boolean = true;
		//public function get touchable():Boolean{return _touchable;}
		//public function set touchable(value:Boolean):void
		//{
			//_touchable = value;
			//trace("turn off touch",name, value)
		//}
		
		/**
		 * @private
		 */
		// manages assignment of touch begin events
		// determins what parent or child object owns the touch points
		// determins clustering
		
		
		// PLEASE LEAVE THIS AS A PUBLIC FUNCTION...  It is required for TUIO support !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
		public function onTouchDown(event:TouchEvent):void
		{			
			//trace("-this.name",this.name,"-target.name:", event.target.name,"-phase:", event.eventPhase)
			//if(!distributeTarget){
			
			if (GestureWorks.activeTUIO)
			{
				assignEvent(event);
				return;
			}
			
			
				if (GestureWorks.supportsTouch)
				{
					if(_targeting){
						if (targetParent) {
							//trace("redefine target as parent:", event.target.parent.name);
							if ((event.target.parent is TouchSprite)||(event.target.parent is TouchMovieClip)){
								event.target.parent.assignEvent(event);
								//event.stopPropagation(); // allows touch down and tap
							}
						}
						
						else {
						 if (this == event.target) {
							//trace("assign target:", event.target.parent.name);
							assignEvent(event);
							//event.stopPropagation(); // allows touch down and tap
						 }
						}
					}
					else assignEvent(event);
					//trace("natural target:",event.target.name,_touchable);
				}
			// for mouse events
			else assignEvent(event);
		}
		
		
		/*
		private function onTouchUp(event:TouchEvent):void
		{
			//trace("touchup", event.target.name, event.touchPointID);
			if(!distributeTarget){
				if (targetParent) {
						//trace("redefine target as parent:", event.target.parent.name);
						if ((event.target.parent is TouchSprite)||(event.target.parent is TouchMovieClip)){
							//event.target.parent.
							//event.stopPropagation(); // allows touch down and tap
							trace("local touch end parent pass",event.target.name)
						}
					}
				else {
					 if (this == event.target) {
						//assignEvent(event);
						trace("local touch end target",event.target.name)
						//event.stopPropagation(); // allows touch down and tap
					 }
					}
				}
			else trace("local touch end multi-target", event.target.name);
			
			//TouchManager.onTouchUp(event);
		}
		*/
		
		
		
		/**
		 * @private
		 */
		public function assignEvent(event:TouchEvent):void
		{			
			var pointObject:PointObject  = new PointObject();
			var historyArray:Array = new Array();
									
			point = new Object();
			pointObject.point=point;
						
			pointObject.object = this; 
			pointObject.event = event;
			pointObject.id = pointCount;
			pointObject.touchPointID = event.touchPointID;
						
			//trace("event",event.target.name, event.currentTarget.name, this.name)
						
			if (GestureWorks.supportsTouch && !GestureWorks.activeTUIO)
			{
				//pointObject.point.x = event.stageX;
				//pointObject.point.y = event.stageY;
				pointObject.point.x = event.localX;
				pointObject.point.y = event.localY;
			}
			else
			{
				pointObject.point.x = event.stageX;
				pointObject.point.y = event.stageY;
			}
						
			_pointArray.push(pointObject);
			cO.pointArray = _pointArray;
			
			if((tiO.timelineOn)&&(tiO.pointEvents)) tiO.frame.pointEventArray.push(event); /// puts each touchdown event in the timeline event array
						
			GestureGlobals.gw_public::points[event.touchPointID] = pointObject;
						
			if (GestureWorks.supportsTouch) TouchManager.gw_public::registerTouchPoint(event);
			else MouseManager.gw_public::registerMousePoint(event);
						
			pointCount++;
			//trace("Touch down", event.touchPointID);
			
			////////////////////////////////////
			//event.stopPropagation();
			event.stopImmediatePropagation();
			///////////////////////////////////
		}
		////////////////////////////////////////////////////////////////////////////
	}
}