////////////////////////////////////////////////////////////////////////////////
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
	import flash.events.Event;
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
	
	import com.gestureworks.events.GWGestureEvent;
	
	
	/**
	 * The TouchSpriteBase class is the base class for all touch and gestures enabled
	 * Sprites that require additional display list management. 
	 * 
	 * <pre>
	 * 		<b>Properties</b>
	 * 		mouseChildren="false"
	 *		touchChildren="false"
	 *		targetParent = "false"
	 *		disableNativeTransform = "true"
	 *		disableAffineTransform = "true"
	 *		gestureEvents = "false"
	 *		clusterEvents = "false"
	 *		transformEvents = "false"
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
		
		public static var GESTRELIST_UPDATE:String = "gestureList update";
		
		public function TouchSpriteBase():void
		{
			super();
			
			// set mouseChildren to default false
			mouseChildren = false; //false
			
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
			
			//for (var i:String in gestureList) 
			//{
				//gestureList[i] = gestureList[i].toString() == "true" ?true:false;
				//if (trace_debug_mode) trace("setting gestureList:", gestureList[i]);
			//}
			
			/////////////////////////////////////////////////////////////////////
			// Convert GML Into Property Objects That describe how to match,analyze, 
			// process and map point/clusterobject properties
			/////////////////////////////////////////////////////////////////////
			callLocalGestureParser();
			
			
			//////////////////////////////////////////////////////////////////////////
			// makes sure that if gesture list chnages timeline gesture int is reset
			/////////////////////////////////////////////////////////////////////////
			dispatchEvent(new GWGestureEvent(GWGestureEvent.GESTURELIST_UPDATE, false));
			
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
		// allows touchsprite touch listeners to switch between triggering at during capture phase or buble phase
		private var _capture:Boolean = false;
		public function get capture():Boolean{return _capture;}
		public function set capture(value:Boolean):void
		{
			_capture = value;
			
			/*
			if (_capture)
			{
				removeEventListener(TouchEvent.TOUCH_BEGIN, onTouchDown, false);
				//removeEventListener(TouchEvent.TOUCH_END, onTouchUp, false);
				
				addEventListener(TouchEvent.TOUCH_BEGIN, onTouchDown, true, 0, true);
				//addEventListener(TouchEvent.TOUCH_END, onTouchUp, true,0,true);
			}
			else {
				removeEventListener(TouchEvent.TOUCH_BEGIN, onTouchDown, true);
				//removeEventListener(TouchEvent.TOUCH_END, onTouchUp, true);
				
				addEventListener(TouchEvent.TOUCH_BEGIN, onTouchDown, false, 0, true);
				//addEventListener(TouchEvent.TOUCH_END, onTouchUp,false, 0,true);
			}*/
		}
		
		
		/**
		 * @private
		 */
		// allows touch and gesture events to explicitly target parent touch object
		private var _targetParent:Boolean = false;
		public function get targetParent():Boolean{return _targetParent;}
		public function set targetParent(value:Boolean):void
		{
			_targetParent = value;
		}
		
		/**
		 * @private
		 */
		// allows touch and gesture events to explicitly target parent touch object
		private var _targetCurrent:Boolean = false;
		public function get targetCurrent():Boolean{return _targetCurrent;}
		public function set targetCurrent(value:Boolean):void
		{
			_targetCurrent = value;
		}
		
		/**
		 * @private
		 */
		private var _targetStack:Boolean = false;
		/** 
		 * allows touch and gesture events to explicitly target the complete stack of activated 
		 * parent touch containers and the target touch object
		*/
		public function get targetStack():Boolean{return _targetStack;}
		public function set targetStack(value:Boolean):void
		{
			_targetStack = value;
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
		/**
		 * decides how to assign the captured touch point
		 * can pass to parent, self and parent or to self exclusively.
		 */
		 
		 // manages assignment of touch begin events
		// determins what parent or child object owns the touch points
		// determins clustering
		// PLEASE LEAVE THIS AS A PUBLIC FUNCTION...  It is required for TUIO support !!!
		
		public function onTouchDown(event:TouchEvent):void
		{			
			//trace("-this.name", this.name, "-target.name:", event.target.name, "-phase:", event.eventPhase, "-currentTarget:", event.currentTarget.name)
			//trace("this:	",this.name,"target:	", event.target.name,"-currentTarget:	", event.currentTarget.name)
			//if(!distributeTarget){
			
			
			
			//assignEvent(event);
			//event.target.assignEvent(event);
			//event.currentTarget.assignEvent(event);
			
			
			//if (event.target == event.currentTarget) assignEvent(event);
			
			//if (event.target.parent == event.currentTarget) event.target.parent.assignEvent(event);
			//if (event.target.parent == event.target) event.target.parent.assignEvent(event);
				//if (event.target.parent == event.target)event.target.assignEvent(event);
			
			//if (this == event.target) assignEvent(event);
			// assignEvent(event);
			/*
			if (targetParent) {
			if ((event.target.parent is TouchSprite)||(event.target.parent is TouchMovieClip)){
								event.target.parent.assignEvent(event);
			}
			}
			*/
			
			
				// touch socket 
				if (GestureWorks.activeTUIO)
				{
					assignEvent(event);
					return;
				}
				// native touch
				if (GestureWorks.supportsTouch)
				{
					if (_targeting) {
						if (targetParent) {
							//trace("redefine target as parent:", event.target.parent.name);
							if ((event.target.parent is TouchSprite)||(event.target.parent is TouchMovieClip)){
								event.target.parent.assignEvent(event);
								//event.stopPropagation(); // allows touch down and tap
							}
						}
						
						else if (targetCurrent)
						{ //else if
							if (this == event.currentTarget){
								assignEvent(event);
							}
						}
						else {
							 if (this == event.target) {
								assignEvent(event);
								event.stopPropagation(); // allows touch down and tap
							 }
						}
						
					}
					else assignEvent(event);
					//trace("natural target:",event.target.name,_touchable);
				}
				// mouse events
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
			
			
			// removes point id from global point dictionary
			//TouchManager.onTouchUp(event);
			
			//GestureGlobals.gw_public::points[event.touchPointID] = pointObject;
			//if (GestureWorks.supportsTouch) TouchManager.gw_public::registerTouchPoint(event);
			
			
			
			// remove point from local cluster
			// search for mathinc ID and remove
			//cO.pointArray ..........;
			//event.touchPointID..............
			
			
			
			
			
			// put touch up event on timeline
			if((tiO.timelineOn)&&(tiO.pointEvents)) tiO.frame.pointEventArray.push(event);
		}
		*/
		
		
		
		/**
		 * @private
		 */
		
		 /**
		 * registers assigned touch point globaly and to relevant local clusters 
		 */
		public function assignEvent(event:TouchEvent):void
		{
			//var ppt = GestureGlobals.gw_public::points[event.touchPointID];
			//trace(ppt);
			
			//check to see if point has been created already by another touch object
			//if (!ppt)
			//{
				//trace("point does not exist yet");
				
				// create new point object
				var pointObject:PointObject  = new PointObject();
				var historyArray:Array = new Array();
										
				point = new Object();
					pointObject.point=point;	
					pointObject.object = this; 
					pointObject.event = event;
					pointObject.id = pointCount;
					pointObject.touchPointID = event.touchPointID;
					
					// set point init position
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
				
				// add point object to touch object cluster
				_pointArray.push(pointObject);
				cO.pointArray = _pointArray;
				
				// add touch down to gesture event timeline
				if((tiO.timelineOn)&&(tiO.pointEvents)) tiO.frame.pointEventArray.push(event); /// puts each touchdown event in the timeline event array	
				
				// add point object to global point list
				GestureGlobals.gw_public::points[event.touchPointID] = pointObject;			
			//}
			
		//	else {
				//trace("point aready in system");
				//add to local cluster
				//cO.pointArray.push(GestureGlobals.gw_public::points[event.touchPointID]);
			//}
			
			// increment point count on touch object
			pointCount++;
			
			// regisiter touch point with touchmanager
			if (GestureWorks.supportsTouch) TouchManager.gw_public::registerTouchPoint(event);
			else MouseManager.gw_public::registerMousePoint(event);
			
			//trace(this.name, cO.pointArray.length, cO);
		}
		////////////////////////////////////////////////////////////////////////////
	}
}