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
	import com.gestureworks.core.GestureGlobals;
	import com.gestureworks.core.GestureWorks;
	import com.gestureworks.core.gw_public;
	import com.gestureworks.core.TouchCluster;
	import com.gestureworks.core.TouchGesture;
	import com.gestureworks.core.TouchPipeline;
	import com.gestureworks.core.TouchTransform;
	import com.gestureworks.events.GWGestureEvent;
	import com.gestureworks.events.GWTouchEvent;
	import com.gestureworks.managers.MouseManager;
	import com.gestureworks.managers.ObjectManager;
	import com.gestureworks.managers.TouchManager;
	import com.gestureworks.objects.ClusterObject;
	import com.gestureworks.objects.GestureListObject;
	import com.gestureworks.objects.PointObject;
	import com.gestureworks.objects.StrokeObject;
	import com.gestureworks.objects.TimelineObject;
	import com.gestureworks.objects.TransformObject;
	import com.gestureworks.utils.GestureParser;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.events.TouchEvent;
	import flash.geom.Point;
	import org.tuio.TuioTouchEvent;
	
	
	
	

	
	/**
	 * The TouchMovieClip class is the base class for all touch and gestures enabled
	 * MovieClips that require additional display list management. 
	 * 
	 * <pre>
	 * 		<b>Properties</b>
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
	
	public class TouchMovieClip extends MovieClip
	{
		//public var point:Point;
		//public var point:*;
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
		public var sO:StrokeObject;
		public var gO:GestureListObject;
		public var tiO:TimelineObject;
		public var trO:TransformObject;
		
		public var tc:TouchCluster;
		public var tp:TouchPipeline;
		public var tg:TouchGesture;
		public var tt:TouchTransform;
		public var td:TouchDebugDisplay;
		
		public static var GESTRELIST_UPDATE:String = "gestureList update";
		
		public function TouchMovieClip():void
		{
			super();
			
			// set mouseChildren to default false
			mouseChildren = false; //false
			//mouseEnabled = false;
			
			debugDisplay = false;
			preinitBase();
        }
		  
		// initializers
         private function preinitBase():void 
         {
			//trace("create touchsprite base");
					addEventListener(GWGestureEvent.GESTURELIST_UPDATE, onGestureListUpdate); 
					updateListeners();				
									
					// Register touchObject with object manager, return object id
					_touchObjectID = ObjectManager.registerTouchObject(this);
					GestureGlobals.gw_public::touchObjects[_touchObjectID] = this;
					
					// create generic analysis engine
					//if (GestureGlobals.analyzeCluster)
						//{
						/////////////////////////////////////////////////////////////////////////
						// CREATES A NEW CLUSTER OBJECT FOR THE TOUCHSPRITE
						// HANDLES CORE GEOMETRIC RAW PROPERTIES OF THE CLUSTER
						/////////////////////////////////////////////////////////////////////////
						cO = new ClusterObject();
							cO.id = touchObjectID;
						GestureGlobals.gw_public::clusters[_touchObjectID] = cO;
						
						// create new stroke object
						sO = new StrokeObject();
							sO.id = touchObjectID;
						
						/////////////////////////////////////////////////////////////////////////
						// CREATERS A NEW GESTURE OBJECT
						// A VEHICLE TO CONTAIN CORE GESTURE VALUES
						/////////////////////////////////////////////////////////////////////////
						gO = new GestureListObject();
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
						// CREATES A NEW TIMELINE OBJECT 
						// CONTAINS A HISTORY OF ALL TOUCH EVENTS, CLUSTER EVENTS, GESTURE EVENTS 
						// AND TRANSFORM EVENTS THAT OCCUR ON THE TOUCHSPRITE
						/////////////////////////////////////////////////////////////////////////
						tiO = new TimelineObject();
							tiO.id = touchObjectID;
							tiO.timelineOn = false; // activates timline manager
							tiO.pointEvents = false; // pushes point events into timline
							tiO.clusterEvents = false; // pushes cluster events into timeline
							tiO.gestureEvents = false; // pushes gesture events into timleine
							tiO.transformEvents = false; // pushes transform events into timeline
						GestureGlobals.gw_public::timelines[_touchObjectID] = tiO;
						
					//}
					// bypass gml requirement for testing
					initBase()
					//if (debugDisplay)
					//td = new TouchDebugDisplay(touchObjectID);
		}
		
		/**
		 * Registers/unregisters event handlers depending on the active modes
		 */
		public function updateListeners():void {
			
			//clear 
			removeEventListener(TuioTouchEvent.TOUCH_DOWN, onTuioTouchDown, false);
			removeEventListener(TouchEvent.TOUCH_BEGIN, onTouchDown, false); 
			removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			
			if (GestureWorks.activeTUIO)		
				addEventListener(TuioTouchEvent.TOUCH_DOWN, onTuioTouchDown, false, 0, true);
			if (GestureWorks.activeNativeTouch)		
				addEventListener(TouchEvent.TOUCH_BEGIN, onTouchDown, false, 0, true); // bubbles up when nested
			if (GestureWorks.activeSim)				
				addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
		}
		
		 private function initBase():void 
		{
										tc = new TouchCluster(touchObjectID);
										tp = new TouchPipeline(touchObjectID);
					if (gestureEvents)	tg = new TouchGesture(touchObjectID);
										tt = new TouchTransform(touchObjectID);
					if (debugDisplay)	td = new TouchDebugDisplay(touchObjectID);
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
		//public var _pointArray:Array = new Array(); // read only
		//public function get pointArray():Array { return _pointArray; }
		//public function set pointArray(value:Array):void
		//{
			//_pointArray=value;
		//}
		
		
		
		public var _pointArray:Vector.<PointObject> = new Vector.<PointObject>(); // read only
		public function get pointArray():Vector.<PointObject> { return _pointArray; }
		
		/**
		 * @private
		 */
		public var _N:int = 0; // number of touch points in the cluster // read only
		public function get N():int { return _N; }
		public function set N(value:int):void 
		{ 
			_N = value;
		}
		
		/**
		 * @private
		 */
		public var _dN:Number = 0; // read only
		public function get dN():Number { return _dN; }
		public function set dN(value:Number):void 
		{ 
			_dN = value;
		}
		
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
			// makes sure that if gesture list changes timeline gesture int is reset
			/////////////////////////////////////////////////////////////////////////
			dispatchEvent(new GWGestureEvent(GWGestureEvent.GESTURELIST_UPDATE, false));
			
		}
		/**
		 * @private
		 */
		private function callLocalGestureParser():void
		{
			//trace("callLocalGestureParser movie clip")
			
			var gp:GestureParser = new GestureParser();
				gp.gestureList = gestureList;
				gp.parse(touchObjectID);
				
				if (trace_debug_mode) gp.traceGesturePropertyList();
				
			initBase();
		}
		/**
		 * @private
		 */
		private function onMouseDown(e:MouseEvent):void
		{			
			var event:GWTouchEvent = new GWTouchEvent(e);
			onTouchDown(event);
		}
		/**
		 * @private
		 */
		private function onTuioTouchDown(e:TuioTouchEvent):void
		{			
			var event:GWTouchEvent = new GWTouchEvent(e);			
			if (!mouseChildren) { 
				e.stopPropagation();
				onTouchDown(event, this);
			}	
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
				//////////////////
				// new stuff
				//////////////////
				
				// if target gets passed it takes precendence, otherwise try to find it
				// currently target gets passed in as argument for our global hit test
				// if no target is found then bail
				if (!target)
					target = event.target; // object that got hit, used for our non-tuio gesture events
				if (!target)
					return;
					
				var parent:* = target.parent;	
				
				//trace("target: ", target, "parent: ", target.parent,clusterBubbling)
				//trace(target, event.stageX, event.localX);
				//trace("event targets",event.target,event.currentTarget, event.eventPhase)
				
				///////////////
				// native touch
				///////////////
				if (1)
				// UPDATE: replaced the first condition (above) so everything that gets put through these conditions.
				// -Charles (5/16/2012)
				{					
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
							_targetList[j].broadcastTarget = true;
						}
						
						else if ((_targetList[0] is TouchSprite)||(_targetList[0] is TouchMovieClip))
						{							
							//ASSIGN THIS TOUCH OBJECT AS PRIMARY CLUSTER
							assignPoint(event);
							
							//CREATE SECONDARY CLUSTERS ON TARGET LIST ITEMS
							for (var j:uint = 0; j < _targetList.length; j++) 
							{
								_targetList[j].assignPointClone(event);
								_targetList[j].broadcastTarget = true;
							}
						}
						
						else if (_clusterBubbling)
						{	
							//trace(event.eventPhase)
							if (3 == event.eventPhase) { // bubbling phase
								
								if (!((event.target is TouchSprite)||(event.target is TouchMovieClip)))//
									assignPoint(event);
								else	
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
				///////////////////////////////////////
				// mouse events - no longer used
				/////////////////////////////////////////
				else {
					assignPoint(event);
					return										
				}
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
				pointObject.id = pointCount; // NEEDED FOR THUMBID
				pointObject.touchPointID = event.touchPointID;
				pointObject.x = event.stageX;
				pointObject.y = event.stageY; 
				pointObject.objectList.push(this); // seeds cluster/touch object list
				
				//ADD TO LOCAL POINT LIST
				_pointArray.push(pointObject);
				
				//UPDATE LOCAL CLUSTER OBJECT
				cO.pointArray = _pointArray;
				
				// INCREMENT POINT COUTN ON LOCAL TOUCH OBJECT
				pointCount++;
				
				// ASSIGN POINT OBJECT WITH GLOBAL POINT LIST DICTIONARY
				GestureGlobals.gw_public::points[event.touchPointID] = pointObject;
				
				// REGISTER TOUCH POINT WITH TOUCH MANAGER
				TouchManager.gw_public::registerTouchPoint(event);
				// REGISTER MOUSE POINT WITH MOUSE MANAGER
				if (GestureWorks.activeSim) MouseManager.gw_public::registerMousePoint(event);
				
				// add touch down to touch object gesture event timeline
				if((tiO)&&(tiO.timelineOn)&&(tiO.pointEvents)) tiO.frame.pointEventArray.push(event); /// puts each touchdown event in the timeline event array	

				//trace("ts root target, point array length",pointArray.length, pointObject.touchPointID, pointObject.objectList.length, this);
				
		}
		
		private function assignPointClone(event:TouchEvent):void // assigns point copy
		{
				// assign existing point object
				var pointObject:PointObject = GestureGlobals.gw_public::points[event.touchPointID]
					// add this touch object to touchobject list on point
					pointObject.touchPointID = event.touchPointID;//-??
					pointObject.objectList.push(this);  ////////////////////////////////////////////////NEED TO COME UP WITH METHOD TO REMOVE TOUCH OBJECT THAT ARE NOT LONGER ON STAGE
	
				//ADD TO LOCAL POINT LIST
				_pointArray.push(pointObject);
				
				//UPDATE LOCAL CLUSTER OBJECT
				//touch object point list and cluster point list should be consolodated
				cO.pointArray = _pointArray;
				
				//UPDATE POINT LOCAL COUNT
				pointCount++;
				
				// add touch down to touch object gesture event timeline
				if ((tiO)&&(tiO.timelineOn) && (tiO.pointEvents)) tiO.frame.pointEventArray.push(event); /// puts each touchdown event in the timeline event array
				
				//trace("ts clone bubble target, point array length",_pointArray.length, pointObject.touchPointID, pointObject.objectList.length, this);
		}
		////////////////////////////////////////////////////////////////////////////
		
		/**
		 * @private
		 */
		private var _clusterEvents:Boolean = false;
		/**
		* Determins whether clusterEvents are processed and dispatched on the touchSprite.
		*/
		public function get clusterEvents():Boolean{return _clusterEvents;}
		public function set clusterEvents(value:Boolean):void
		{
			_clusterEvents=value;
		}
		
		///////////////////////////////////////////////////////////////////////////
		// FILTER OVERRIDES
		
		private var _deltaFilterOn:Boolean = false//true;
		/**
		* Determins whether filtering is applied to the delta values.
		*/
		public function get deltaFilterOn():Boolean{return _deltaFilterOn;}
		public function set deltaFilterOn(value:Boolean):void
		{
			_deltaFilterOn=value;
		}
		
		/**
		* @private
		*/
		private var _gestureTouchInertia:Boolean = false;
		/**
		* Determins whether touch inertia is processed on the touchSprite.
		*/
		public function get gestureTouchInertia():Boolean{return _gestureTouchInertia;}
		public function set gestureTouchInertia(value:Boolean):void
		{
			_gestureTouchInertia = value;
			_deltaFilterOn=value;
		}
		
		public function updateClusterAnalysis():void
		{
			if(tc) tc.updateClusterAnalysis();
		}
		
		public function updateMotionClusterAnalysis():void
		{
			if(tc) tc.updateMotionClusterAnalysis();
		}
		
		public function updateSensorClusterAnalysis():void
		{
			if(tc) tc.updateSensorClusterAnalysis();
		}
		
		////////////////////////////////////////////////////////////////////////////
		
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		//gesture settings
		////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		/**
		* @private
		*/
		//public read write
		private var _gestureEventStart:Boolean = true;
		/**
		* Indicates whether any gestureEvents have been started on the touchSprite.
		*/
		public function get gestureEventStart():Boolean{return _gestureEventStart;}
		public function set gestureEventStart(value:Boolean):void
		{
			_gestureEventStart=value;
		}
		
		
		/**
		* @private
		*/
		private var _gestureEventComplete:Boolean = true;
		/**
		* Indicates weather all gestureEvents have been completed on the touchSprite.
		*/
		public function get gestureEventComplete():Boolean{return _gestureEventComplete;}
		public function set gestureEventComplete(value:Boolean):void
		{
			_gestureEventComplete=value;
		}
		
		/**
		* @private
		*/
		private var _gestureEventRelease:Boolean = true;
		/**
		* Indicates whether all touch points have been released on the touchSprite.
		*/
		public function get gestureEventRelease():Boolean{return _gestureEventRelease;}
		public function set gestureEventRelease(value:Boolean):void
		{
			_gestureEventRelease = value;
			
			
		}
		
		/**
		* @private
		*/
		// NOW SET TO TRUE BY DEFAULT
		// TURN OFF TO OPTOMIZE WHEN USING NATIVE
		// TODO, AUTO ON WHEN ATTATCH LISTENERS
		private var _gestureEvents:Boolean = true;
		/**
		* Determins whether gestureEvents are processed and dispatched on the touchSprite.
		*/
		public function get gestureEvents():Boolean{return _gestureEvents;}
		public function set gestureEvents(value:Boolean):void
		{
			_gestureEvents=value;
		}
		
		/**
		* @private
		*/
		public var _gestureReleaseInertia:Boolean = false;	// gesture release inertia switch
		/**
		* Determins whether release inertia is given to gestureEvents on the touchSprite.
		*/
		public function get gestureReleaseInertia():Boolean{return _gestureReleaseInertia;}
		public function set gestureReleaseInertia(value:Boolean):void
		{
			_gestureReleaseInertia=value;
		}
		
		//gestures tweening
		public var _gestureTweenOn:Boolean = false;
		public function get gestureTweenOn():Boolean
		{
			return _gestureTweenOn;
		}
		public function set gestureTweenOn(value:Boolean):void
		{
			_gestureTweenOn = value;
		}
		
		public function updateGesturePipeline():void
		{
			if (tp) tp.processPipeline();
			if (tg) tg.manageGestureEventDispatch();
		}
		
		///////////////////////////////////////////////////////////////////////////////////
		// TRANSFORMS
		///////////////////////////////////////////////////////////////////////////////////
		/**
		* @private
		*/
		// nested transfrom 
		private var _nestedTransform:Boolean = false;
		
		public function get nestedTransform():Boolean { return _nestedTransform} 
		public function set nestedTransform(value:Boolean):void
		{
			_nestedTransform = value
		}
		/**
		* @private
		*/
		private var _transformEvents:Boolean = false;
		/**
		* Determins whether transformEvents are processed and dispatched on the touchSprite.
		*/
		public function get transformEvents():Boolean{return _transformEvents;}
		public function set transformEvents(value:Boolean):void
		{
			_transformEvents=value;
		}
	
		/**
		* @private
		*/
		private var _transformComplete:Boolean = false;
		
		public function get transformComplete():Boolean { return _transformComplete; }
		public function set transformComplete(value:Boolean):void
		{
			_transformComplete=value;
		}
		/**
		* @private
		*/
		private var _transformStart:Boolean = false;
		
		public function get transformStart():Boolean { return _transformStart; }
		public function set transformStart(value:Boolean):void
		{
			_transformStart=value;
		}
		
		/**
		* @private
		*/
		private var _transformEventStart:Boolean = true;
		
		public function get transformEventStart():Boolean{return _transformEventStart;}
		public function set transformEventStart(value:Boolean):void
		{
			_transformEventStart=value;
		}
		/**
		* @private
		*/
		private var _transformEventComplete:Boolean = true;
		
		public function get transformEventComplete():Boolean{return _transformEventComplete;}
		public function set transformEventComplete(value:Boolean):void
		{
			_transformEventComplete=value;
		}
		/**
		* @private
		*/
		// NOW SET TO TRUE BY DEFAULT FOR AS3 DEV 
		private var _disableNativeTransform:Boolean = true;
		/**
		* Determins whether transformations are handled internally (natively) on the touchSprite.
		*/
		public function get disableNativeTransform():Boolean{return _disableNativeTransform;}
		public function set disableNativeTransform(value:Boolean):void
		{
			_disableNativeTransform=value;
		}
		/**
		* @private
		*/
		// default true so that all nested gestures are correct unless specidied
		private var _transformGestureVectors:Boolean = true;
		/**
		* Determins whether transformations are handled internally (natively) on the touchSprite.
		*/
		public function get transformGestureVectors():Boolean{return _transformGestureVectors;}
		public function set transformGestureVectors(value:Boolean):void
		{
			_transformGestureVectors=value;
		}
		/**
		* @private
		*/
		// NOW SET TO TRUE BY DEFAULT FOR AS3 DEV 
		private var _disableAffineTransform:Boolean = true;
		/**
		* Determins whether internal (native) transformations are affine (dynamically centered) on the touchSprite.
		*/
		public function get disableAffineTransform():Boolean{return _disableAffineTransform;}
		public function set disableAffineTransform(value:Boolean):void
		{
			_disableAffineTransform=value;
		}
		
		private var _x_lock:Boolean = false;
		public function get x_lock():Boolean {return _x_lock;}	
		public function set x_lock(value:Boolean):void { _x_lock = value; }
		
		private var _y_lock:Boolean = false;
		public function get y_lock():Boolean {return _y_lock;}	
		public function set y_lock(value:Boolean):void{_y_lock = value;}
		
		/////////////////////////////////////////////////////////////
		// $ affine transform methods
		/////////////////////////////////////////////////////////////
		// x property
		public function get $x():Number {return _$x;}
		public function set $x(value:Number):void
		{
			_$x = value;
		}
		// y property
		public function get $y():Number {return _$y;}
		public function set $y(value:Number):void
		{
			_$y = value;
		}
		// rotation property
		public function get $rotation():Number{return _$rotation;}
		public function set $rotation(value:Number):void
		{
			_$rotation = value;
		}
		// scaleX property
		public function get $scaleX():Number {return _$scaleX;}
		public function set $scaleX(value:Number):void
		{
			_$scaleX = value;
		}
		// scaleY property
		public function get $scaleY():Number {return _$scaleY;}	
		public function set $scaleY(value:Number):void
		{
			_$scaleY = value;
		}
		// affine transform point 
		public function get $transformPoint():Point { return new Point(trO.x, trO.y);} 
		public function set $transformPoint(pt:Point):void
		{
			var tpt:Point = tt.affine_modifier.transformPoint(pt);
				trO.x = tpt.x;
				trO.y = tpt.y;
		}
		
		/*
		// rotationX property
		public function get $rotationX():Number{return _rotationX;}
		public function set $rotationX(value:Number):void
		{
			_rotationX = value;
		}
		// rotationY property
		public function get $rotationY():Number{return _rotationY;}
		public function set $rotationY(value:Number):void
		{
			_rotationY = value;
		}
		// rotationZ property
		public function get $rotationZ():Number{return _rotationZ;}
		public function set $rotationZ(value:Number):void
		{
			_rotationZ = value;
		}
		
		*/
		
		
		public var _$x:Number = 0;
		public var _$y:Number = 0;
		public var _$scaleX:Number = 1;
		public var _$scaleY:Number = 1;
		public var _$rotation:Number = 0;
		public var _$width:Number = 0;
		public var _$height:Number = 0;
		//private var t_x:Number = 0;
		//private var t_y:Number =  0;
		
		
		/**
	* @private
	*/
	public function updateTransformation():void 
	{
		if(tt){
			tt.transformManager();
			tt.updateLocalProperties();
		}
	}
	
	
	//public var debug_display:Boolean = false;
	
	
	public function updateDebugDisplay():void
	{
		if(td) td.updateDebugDisplay()
	}
	
	private function onGestureListUpdate(event:GWGestureEvent):void  
		{
			//trace("gesturelist update");
			if (tg) tg.initTimeline();
		}
		
		private var _debugDisplay:Boolean = false;
		public function get debugDisplay():Boolean {return _debugDisplay;}	
		public function set debugDisplay(value:Boolean):void
		{
			_debugDisplay = value;
		}
		
		private var _gestureFilters:Boolean = true;
		public function get gestureFilters():Boolean {return _gestureFilters;}	
		public function set gestureFilters(value:Boolean):void
		{
			_gestureFilters = value;
		}
		
		// BROAD CASTING TEST
		private var _broadcastTarget:Boolean = false;
		public function get broadcastTarget():Boolean {return _broadcastTarget;}	
		public function set broadcastTarget(value:Boolean):void
		{
			_broadcastTarget = value;
		}
		
		public function updateTObjProcessing():void
		{			
			if ( !(GestureWorks.activeMotion) || (GestureWorks.activeMotion && cO.n != 0) ) {
				if (tc) tc.updateClusterAnalysis();
				if (tp) tp.processPipeline();
				if (tg) tg.manageGestureEventDispatch();
				if (tt){
					tt.transformManager();
					tt.updateLocalProperties();
				}
			}
		}
		
		/**
		 * Registers event listeners. Also processes GWTouchEvents by evaluating which types of touch events (TUIO, native touch, and mouse) are active then registers
		 * and dispatches appropriate events.
		 * @param	type
		 * @param	listener
		 * @param	useCapture
		 * @param	priority
		 * @param	useWeakReference
		 */
		override public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void 
		{
			if (type.indexOf("gwTouch") > -1)
			{				
				super.addEventListener(GWTouchEvent.eventType(type), function(e:*):void {
					dispatchEvent(new GWTouchEvent(e));
				});
			}
			
			super.addEventListener(type, listener, useCapture, priority, useWeakReference);
		}
		
	}
}