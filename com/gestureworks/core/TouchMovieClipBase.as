////////////////////////////////////////////////////////////////////////////////
//
//  IDEUM
//  Copyright 2011-2012 Ideum
//  All Rights Reserved.
//
//  GestureWorks
//
//  File:    TouchMovieClipBase.as
//  Authors:  Ideum
//             
//  NOTICE: Ideum permits you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

package com.gestureworks.core
{
	import flash.display.MovieClip;
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
	//import com.gestureworks.objects.ProcessObject;
	import com.gestureworks.objects.GestureObject;
	import com.gestureworks.objects.TimelineObject;
	import com.gestureworks.objects.TransformObject;
	
	import com.gestureworks.utils.GestureParser;
	import com.gestureworks.utils.MousePoint;
	
	import com.gestureworks.events.GWGestureEvent;
	
	import com.gestureworks.utils.Simulator;
	
	import org.tuio.TuioTouchEvent;
	
	/**
	 * The TouchMovieClipBase class is the base class for all touch and gestures enabled
	 * MovieClips that require additional display list management. 
	 * 
	 * <pre>
	 *		<b>Properties</b>
	 * 		mouseChildren="false"
	 *		touchChildren="false"
	 *		targetParent = "false"
	 *		disableNativeTransform = "true"
	 *		disableAffineTransform = "true"
	 *		gestureEvents = "true"
	 *		clusterEvents = "false"
	 *		transformEvents = "false"
	 * </pre>
	 */
	
	public class TouchMovieClipBase extends MovieClip
	{
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
		public var gO:GestureObject;
		public var tiO:TimelineObject;
		public var trO:TransformObject;
		
		public static var GESTRELIST_UPDATE:String = "gestureList update";
		
		public function TouchMovieClipBase():void
		{
			super();
			
			// set mouseChildren to default
			mouseChildren = false;
			
			initBase();
        }
		  
		// initializers
         private function initBase():void 
         {
			//trace("create touchmovieclip base");
					
					// add touch event listener - the order of the conditions are important! (Charles 5/31/12)
					if (GestureWorks.activeTUIO)					
						addEventListener(TuioTouchEvent.TOUCH_DOWN, onTuioTouchDown, false, 0, true);
					if (GestureWorks.supportsTouch)
						addEventListener(TouchEvent.TOUCH_BEGIN, onTouchDown, false, 0, true); // bubbles up when nested
					else
						addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);

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
		public var _touchObjectID:int = 0; 
		public function get touchObjectID():int { return _touchObjectID; }
		/**
		 * @private
		 */
		public var _pointArray:Array = new Array(); // read only
		public function get pointArray():Array { return _pointArray;}	
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
			
			/*
			for (var i:String in gestureList) 
			{
				gestureList[i] = gestureList[i].toString() == "true" ?true:false;
				if (trace_debug_mode) trace("setting gestureList:", gestureList[i]);
			}
			*/
			///////////////////////////////////////////////////////////////////////
			// Convert GML Into Property Objects That describe how to match,analyze, 
			// process and map point/clusterobject properties
			///////////////////////////////////////////////////////////////////////
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
			onTouchDown(event, e.target);
		}
		
		/**
		 * @private
		 */
		private function onTuioTouchDown(e:TuioTouchEvent):void
		{			
			var pointID:int = e.tuioContainer.sessionID;		
			var event:TouchEvent = new TouchEvent(TouchEvent.TOUCH_BEGIN, true, false, pointID, false, e.stageX, e.stageY);
			
			// currentTarget seems to work here, b/c there is filtering going on within onTouchDown
			// normally this would be the target, but Tuio library doesn't recognize mouseChildren = false
			onTouchDown(event, e.currentTarget);					
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
		private var _clusterBubbling:Boolean = false;
		/** 
		 * Allows touch points from a childclusters to copy into container touch objects
		 * in the local parent child display list stack. This allows the for the concept of parallel
		 * clustering of touch point. Where a single touch point can simultaniuosly be a 
		 * member of multiple touch point clusters. This allows multiple gestures to be 
		 * dispatched from multiple touch objects from a set of touch points.
		*/
		public function get clusterBubbling():Boolean{return _clusterBubbling;}
		public function set clusterBubbling(value:Boolean):void
		{
			_clusterBubbling = value;
		}
		
		/**
		 * @private
		 */
		private var _targetParent:Boolean = false;
		/**
		* Allows touch and gesture events to explicitly target the parent touch object
		**/
		public function get targetParent():Boolean{return _targetParent;}
		public function set targetParent(value:Boolean):void
		{
			_targetParent = value;
		}
		
		/**
		 * @private
		 */
		private var _targetObject:Object;
		/** 
		 * Allows touch and gesture events to explicitly target a touch object 
		 * this can be outside the local parent child display list stack
		*/
		public function get targetObject():Object{return _targetObject;}
		public function set targetObject(value:Object):void
		{
			_targetObject = value;
		}
		
		/**
		 * @private
		 */
		private var _targetList:Array = [];
		/** 
		* Allows touch and gesture events to explicitly target a group of defined 
		* touch objects which can be outside of the local parent child display list stack
		*/
		public function get targetList():Array{return _targetList;}
		public function set targetList(value:Array):void
		{
			_targetList = value;
		}
		
		
		/**
		 * @private
		 */
		private var _targeting:Boolean = true;
		/** 
		* Turns off manual ALL targeting control, defaults to a simple hit test
		* targeting model with exclusive target clustering
		*/
		public function get targeting():Boolean{return _targeting;}
		public function set targeting(value:Boolean):void
		{
			_targeting = value;
		}
		
		/**
		 * @private
		 */
		
		/**
		 * decides how to assign the captured touch point to a cluster
		 * can pass to parent, an explicit target, an explicit list or 
		 * targets or a passed to any touch object in the local display stack.
		 */
		 
		// PLEASE LEAVE THIS AS A PUBLIC FUNCTION...  It is required for TUIO support !!!
		public function onTouchDown(event:TouchEvent, target:*=null):void
		{			
				//////////////////////////////////
				// ASSUMING HIT TEST IS CORRECT TUIO
				// 
				// touch socket 
				//if (GestureWorks.activeTUIO)
				//{
					//assignPoint(event);
					//event.stopPropagation();
					//return;
				//}
				
			
				//////////////////
				// new stuff
				//////////////////
				
				// if target gets passed it takes precendence, otherwise try to find it
				// currently target gets passed in as argument for our global hit test 
				if (!target)
					target = event.target; // object that got hit, used for our non-tuio gesture events
				if (!target)
					target = this; 
				
				var parent:* = target.parent;										
			
				
				//trace("target: ", target.id, "parent: ", target.parent)
				//trace(event.target, event.stageX, event.localX);
				
				//if (GestureWorks.supportsTouch || GestureWorks.activeTUIO)
				// UPDATE: replaced the first condition (above) so everything that gets put through these conditions.
				// -Charles (5/16/2012)
				
				if (1)
				{
					if (_targeting) { // COMPLEX TARGETING
						if (targetParent) { //LEGACY SUPPORT
							if ((target is TouchSprite) || (target is TouchMovieClip)) 
							{								
								//ASSIGN PRIMARY CLUSTER TO PARENT
								parent.assignPoint(event);
								//event.stopPropagation(); // allows touch down and tap
							}
						}
						else if ((_targetObject is TouchSprite)||(_targetObject is TouchMovieClip))
						{							
							// ASSIGN PRIMARY CLUSTER TO TARGET
							_targetObject.assignPoint(event);							
						}
						
						else if ((_targetList[0] is TouchSprite)||(_targetList[0] is TouchMovieClip))
						{							
							//ASSIGN THIS TOUCH OBJECT AS PRIMARY CLUSTER
							assignPoint(event);
							
							//CREATE SECONDARY CLUSTERS ON TARGET LIST ITEMS
							for (var j:int = 0; j < _targetList.length; j++) 
							{
								_targetList[j].assignPointClone(event);
							}
						}
						
						else if (_clusterBubbling)
						{							
							if (3 == event.eventPhase){ // bubling phase
								assignPointClone(event);
							}
							else if (2 == event.eventPhase) { //targeting phase
								assignPoint(event);
							 }
						}
						else {
							// added the !mouseChildren in order to simluator to work properly -charles (5/17/2012)
							if (2 == event.eventPhase && !mouseChildren) { //targeting phase
								assignPoint(event);
								//event.stopPropagation(); // allows touch down and tap
							 }
						}
						
					}
					// SIMPLE TARGETING
					else 
					{
						return
						assignPoint(event);
						//event.stopPropagation();
					}
					
				}
				// mouse events
				else {
					return										
					//assignPoint(event);
					//event.stopPropagation();
				}
				//trace("event targets",event.target,event.currentTarget, event.eventPhase)
		}
		

		/**
		 * @private
		 */
		
		 /**
		 * registers assigned touch point globaly and to relevant local clusters 
		 */
		private function assignPoint(event:TouchEvent):void // asigns point
		{
			// create new point object
			var pointObject:PointObject  = new PointObject();					
				pointObject.object = this; // sets primary touch object/cluster
				pointObject.objectList.push(this); // seeds cluster/touch object list
				
				pointObject.id = pointCount;
				pointObject.touchPointID = event.touchPointID;
				pointObject.x = event.stageX;
				pointObject.y = event.stageY;
				
				//update touch object point list
				_pointArray.push(pointObject);
				
				// update cluster object point list
				cO.pointArray = _pointArray;
				
				// increment point count on touch object
				pointCount++;
				
				
				GestureGlobals.gw_public::points[event.touchPointID] = pointObject;

				// regisiter touch point with touchmanager
				if (GestureWorks.supportsTouch) TouchManager.gw_public::registerTouchPoint(event);
				
				else MouseManager.gw_public::registerMousePoint(event);
				
				// add touch down to touch object gesture event timeline
				if ((tiO.timelineOn) && (tiO.pointEvents)) tiO.frame.pointEventArray.push(event); /// puts each touchdown event in the timeline event array

				//trace("point array length", _pointArray.length);
		}
		
		private function assignPointClone(event:TouchEvent):void // assigns point copy
		{
				// assign existing point object
				var pointObject:Object = GestureGlobals.gw_public::points[event.touchPointID]
				// add this touch object to touchobject list on point
				pointObject.objectList.push(this);  ////////////////////////////////////////////////NEED TO COME UP WITH METHOD TO REMOVE TOUCH OBJECT THAT ARE NOT LONGER ON STAGE
	
				//ADD TO LOCAL POINT LIST
				_pointArray.push(pointObject);
				
				//UPDATE POINT LOCAL COUNT
				pointCount++;
				
				//UPDATE LOCAL CLUSTER OBJECT
				//touch object point list and cluster point list should be consolodated
				cO.pointArray = _pointArray;
				
				// add touch down to touch object gesture event timeline
				if ((tiO.timelineOn) && (tiO.pointEvents)) tiO.frame.pointEventArray.push(event); /// puts each touchdown event in the timeline event array
				
				//trace("point array length",_pointArray.length, pointObject, pointObject.objectList.length);
		}
		////////////////////////////////////////////////////////////////////////////
	}
}