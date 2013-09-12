////////////////////////////////////////////////////////////////////////////////
//
//  IDEUM
//  Copyright 2011-2012 Ideum
//  All Rights Reserved.
//
//  GestureWorks
//
//  File:    TouchSprite.as
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
	import com.gestureworks.core.TouchVisualizer;
	import com.gestureworks.events.GWGestureEvent;
	import com.gestureworks.events.GWTouchEvent;
	import com.gestureworks.managers.ClusterHistories;
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
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TouchEvent;
	import flash.geom.Point;
	import flash.utils.Dictionary;
	import org.tuio.TuioTouchEvent;
	
	
	
	//import com.gestureworks.objects.PointPairObject;
	
	
	
	/**
	 * The TouchSprite class is the base class for all touch and gestures enabled
	 * Sprites that require additional display list management. 
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
	
	public class TouchSprite extends Sprite
	{
		/**
		 * @private
		 */
		public var gml:XMLList;
		
		// internal public 
		public var cO:ClusterObject; // touch
		
		public var sO:StrokeObject;
		public var gO:GestureListObject;
		public var tiO:TimelineObject;
		public var trO:TransformObject;
		
		public var tc:TouchCluster;
		public var tp:TouchPipeline;
		public var tg:TouchGesture;
		public var tt:TouchTransform;
		public var visualizer:TouchVisualizer;
		
		public static var GESTRELIST_UPDATE:String = "gestureList update";
		
		//tracks event listeners
		private var _tsEventListeners:Array = [];
		private var gwTouchListeners:Dictionary = new Dictionary();
		
		private var _activated:Boolean = false;

		public function TouchSprite():void
		{
			super();

			// set mouseChildren to default false
			mouseChildren = false; //false
			//mouseEnabled = false;			
			debugDisplay = false;
        }
		
		/**
		 * Lazy gesture activation
		 */
		public function get activated():Boolean { return _activated; }
		public function set activated(a:Boolean):void {
			if (!_activated && a) {
				_activated = true;
				preinitBase();
			}
		}
		
		private var _localModes:Boolean;
		/**
		 * Flag indicating the application of local modes over the global settings. By default, all objects are enabled for input
		 * processing based on the application level mode settings (i.e. nativeTouch, simulator, tuio, etc.). This flag allows the 
		 * inclusion/exclusion of specific input interaction according to local overrides. Note that the corresponding global setting
		 * must be enabled in order to locally enable the input. 
		 */
		public function get localModes():Boolean { return _localModes; }
		public function set localModes(l:Boolean):void {
			if (_localModes == l) return;
			_localModes = l;
			updateListeners();
		}
		
		private var _nativeTouch:Boolean;
		/**
		 * Local override to enable/disable native touch input.
		 * @see localModes
		 */		
		public function get nativeTouch():Boolean { return _nativeTouch && GestureWorks.activeNativeTouch; }
		public function set nativeTouch(n:Boolean):void {
			if (_nativeTouch == n) return;
			_nativeTouch = n;
			updateListeners();
		}
		
		private var _simulator:Boolean;
		/**
		 * Local override to enable/disable mouse input.
		 * @see localModes
		 */		
		public function get simulator():Boolean { return _simulator && GestureWorks.activeSim; }
		public function set simulator(s:Boolean):void {
			if (_simulator == s) return;
			_simulator = s;
			updateListeners();	
		}
		
		private var _tuio:Boolean;
		/**
		 * Local override to enable/disable tuio input.
		 * @see localModes
		 */		
		public function get tuio():Boolean { return _tuio && GestureWorks.activeTUIO; }
		public function set tuio(t:Boolean):void {
			if (_tuio == t) return;
			_tuio = t;
			updateListeners();
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
						cO = new ClusterObject(); // touch cluster 2d
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
					initBase();
					if (debugDisplay)
						visualizer.initDebug();
		}
		
		/**
		 * Re-registers event listeners with updated mode settings
		 */
		public function updateListeners():void {			
			updateGWTouchListeners();
		}
		
		/**
		 * Re-registers GWTouchEvent events with updated mode settings
		 */
		private function updateGWTouchListeners():void {
			for (var type:String in gwTouchListeners) {
				for each(var l:* in gwTouchListeners[type]) {
					if(l.type)
						super.removeEventListener(l.type, l.listener);
					else{
						super.removeEventListener(type, l.listener);
						addEventListener(type, l.listener);
					}
				}
			}
		}
		
		 private function initBase():void 
		{
							tc = new TouchCluster(touchObjectID);
							tp = new TouchPipeline(touchObjectID);
		if (gestureEvents)	tg = new TouchGesture(touchObjectID);
							tt = new TouchTransform(touchObjectID);
							visualizer = new TouchVisualizer(touchObjectID);
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
		public var _pointArray:Vector.<PointObject> = new Vector.<PointObject>(); // read only
		public function get pointArray():Vector.<PointObject> { return _pointArray; }
		
		/**
		 * @private
		 */
		public var _N:int = 0; // number of points in the super cluster // read only
		public function get N():int { return _N; }
		public function set N(value:int):void { 	_N = value; }
		
		public var _tpn:int = 0; // number of touch points in the parent cluster // read only
		public function get tpn():int { return _tpn; }
		public function set tpn(value:int):void { 	_tpn = value;}
		
		public var _ipn:int = 0; // number of motion points in the parent cluster // read only
		public function get ipn():int { return _ipn; }
		public function set ipn(value:int):void { 	_ipn = value;}
		
		
		/**
		 * @private
		 */
		public var _dN:Number = 0; // read only
		public function get dN():Number { return _dN; }
		public function set dN(value:Number):void { _dN = value;}
		
		// determin if object created by cml of native as3
		/**
		 * @private
		 */
		public var _cml_item:Boolean = false;
		public function get cml_item():Boolean{return _cml_item;}
		public function set cml_item(value:Boolean):void{	_cml_item=value;}
		
		// debug trace statements
		/**
		 * @private
		 */
		public var trace_debug_mode:Boolean = false;
		public function get traceDebugModeOn():Boolean{return trace_debug_mode;}
		public function set traceDebugModeOn(value:Boolean):void{	trace_debug_mode=value;}
		
		// point count
		/**
		 * @private
		 */
		private var _pointCount:int;
		public function get pointCount():int{return _pointCount;}
		public function set pointCount(value:int):void {	_pointCount = value; }
		
		// motion point count
		/**
		 * @private
		 */
		private var _motionPointCount:int;
		public function get motionPointCount():int{return _motionPointCount;}
		public function set motionPointCount(value:int):void {	_motionPointCount = value; }
		
		// interaction point count
		/**
		 * @private
		 */
		private var _interactionPointCount:int;
		public function get interactionPointCount():int{return _interactionPointCount;}
		public function set interactionPointCount(value:int):void{	_interactionPointCount=value;}
		
		// cluster ID
		/**
		 * @private
		 */
		private var _clusterID:int;
		public function get clusterID():int{return _clusterID;}
		public function set clusterID(value:int):void{	_clusterID = value;}
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
			activated = true;
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
			//trace("call local parser touch sprite", );
			
			var gp:GestureParser = new GestureParser();
				gp.gestureList = gestureList;
				gp.parse(touchObjectID);
				
				if (trace_debug_mode) gp.traceGesturePropertyList();
				
			//tp re init vector metric and get new stroke lib for comparison
			if (tc) tc.initClusterAnalysisConfig();
		}
		
		/**
		 * @private
		 */
		private var _touchChildren:Boolean = false;
		/**
		 * Allows touch events to be passed down to child display object. Has the same function as MouseChildren.
		 */
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
		public function onTouchDown(event:TouchEvent, downTarget:*=null):void
		{			
				//////////////////
				// new stuff
				//////////////////
				
				// if target gets passed it takes precendence, otherwise try to find it
				// currently target gets passed in as argument for our global hit test
				// if no target is found then bail
				if (!downTarget)
					downTarget = event.target; // object that got hit, used for our non-tuio gesture events
				if (!downTarget)
					return;
					
				var parent:* = downTarget.parent;	
				
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
							if ((downTarget is TouchSprite) || (downTarget is TouchMovieClip)) 
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
				
				var register:Boolean;
				// REGISTER TOUCH POINT WITH TOUCH MANAGER				
				register = localModes ? nativeTouch : GestureWorks.activeNativeTouch;		
				if (register && registerPoints)
					TouchManager.gw_public::registerTouchPoint(event);
				// REGISTER MOUSE POINT WITH MOUSE MANAGER
				register = localModes ? simulator : GestureWorks.activeSim;		
				if (register && registerPoints) 
					MouseManager.gw_public::registerMousePoint(event);
				
				// add touch down to touch object gesture event timeline
				if((tiO)&&(tiO.timelineOn)&&(tiO.pointEvents)) tiO.frame.pointEventArray.push(event); /// puts each touchdown event in the timeline event array	

				//trace("ts root target, point array length",pointArray.length, pointObject.touchPointID, pointObject.objectList.length, this);
				
				//trace("down:", event.touchPointID, cO.pointArray.length, this._pointArray.length )
				
				
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
		* Determines whether clusterEvents are processed and dispatched on the touchSprite.
		*/
		public function get clusterEvents():Boolean{return _clusterEvents;}
		public function set clusterEvents(value:Boolean):void{	_clusterEvents=value;}
		
		///////////////////////////////////////////////////////////////////////////
		// FILTER OVERRIDES
		private var _deltaFilterOn:Boolean = false//true;
		/**
		* Determines whether filtering is applied to the delta values.
		*/
		public function get deltaFilterOn():Boolean{return _deltaFilterOn;}
		public function set deltaFilterOn(value:Boolean):void{	_deltaFilterOn=value;}
		
		/**
		* @private
		*/
		private var _gestureTouchInertia:Boolean = false;
		/**
		* Determines whether touch inertia is processed on the touchSprite.
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
		
		//public function updateMotionClusterAnalysis():void
		//{
			//if(tc) tc.updateMotionClusterAnalysis();
		//}
		
		//public function updateSensorClusterAnalysis():void
		//{
			//if(tc) tc.updateSensorClusterAnalysis();
		//}
		
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
		public function set gestureEventStart(value:Boolean):void{	_gestureEventStart=value;}
		
		/**
		* @private
		*/
		private var _gestureEventComplete:Boolean = true;
		/**
		* Indicates weather all gestureEvents have been completed on the touchSprite.
		*/
		public function get gestureEventComplete():Boolean{return _gestureEventComplete;}
		public function set gestureEventComplete(value:Boolean):void{	_gestureEventComplete=value;}
		
		/**
		* @private
		*/
		private var _gestureEventRelease:Boolean = true;
		/**
		* Indicates whether all touch points have been released on the touchSprite.
		*/
		public function get gestureEventRelease():Boolean{return _gestureEventRelease;}
		public function set gestureEventRelease(value:Boolean):void{_gestureEventRelease = value;}
		
		/**
		* @private
		*/
		// NOW SET TO TRUE BY DEFAULT
		// TURN OFF TO OPTOMIZE WHEN USING NATIVE
		// TODO, AUTO ON WHEN ATTATCH LISTENERS
		private var _gestureEvents:Boolean = true;
		/**
		* Determines whether gestureEvents are processed and dispatched on the touchSprite.
		*/
		public function get gestureEvents():Boolean{return _gestureEvents;}
		public function set gestureEvents(value:Boolean):void {	_gestureEvents = value; }
		
		/**
		 * Returns an array registered events
		 */
		public function get eventListeners():Array { return _tsEventListeners; }		
		
		/**
		* @private
		*/
		public var _gestureReleaseInertia:Boolean = false;	// gesture release inertia switch
		/**
		* Determines whether release inertia is given to gestureEvents on the touchSprite.
		*/
		public function get gestureReleaseInertia():Boolean{return _gestureReleaseInertia;}
		public function set gestureReleaseInertia(value:Boolean):void{	_gestureReleaseInertia=value;}
		
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
		public function set nestedTransform(value:Boolean):void{	_nestedTransform = value}
		/**
		* @private
		*/
		private var _transformEvents:Boolean = false;
		/**
		* Determines whether transformEvents are processed and dispatched on the touchSprite.
		*/
		public function get transformEvents():Boolean{return _transformEvents;}
		public function set transformEvents(value:Boolean):void{	_transformEvents=value;}
	
		/**
		* @private
		*/
		private var _transformComplete:Boolean = false;
		public function get transformComplete():Boolean { return _transformComplete; }
		public function set transformComplete(value:Boolean):void{	_transformComplete=value;}
		/**
		* @private
		*/
		private var _transformStart:Boolean = false;
		public function get transformStart():Boolean { return _transformStart; }
		public function set transformStart(value:Boolean):void{	_transformStart=value;}
		/**
		* @private
		*/
		private var _transformEventStart:Boolean = true;
		public function get transformEventStart():Boolean{return _transformEventStart;}
		public function set transformEventStart(value:Boolean):void{	_transformEventStart=value;}
		/**
		* @private
		*/
		private var _transformEventComplete:Boolean = true;
		public function get transformEventComplete():Boolean{return _transformEventComplete;}
		public function set transformEventComplete(value:Boolean):void {	_transformEventComplete = value; }
		
		/**
		 * Enables/Disables all GWTouchEvent and GWGestureEvent listeners
		 */
		private var _touchEnabled:Boolean = true;
		public function get touchEnabled():Boolean { return _touchEnabled; }
		public function set touchEnabled(t:Boolean):void {
			if (_touchEnabled == t) return;			
			_touchEnabled = t;
			
			var eCnt:int = _tsEventListeners.length;
			var e:*;
			for(var i:int = eCnt-1; i >= 0; i--) {
				e = _tsEventListeners[i];
				if (GWTouchEvent.isType(e.type) || GWGestureEvent.isType(e.type)) {
					if (_touchEnabled) {
						addGWTouch(e.type, e.listener, e.capture);
						super.addEventListener(e.type, e.listener, e.capture);
					}
					else {
						removeGWTouch(e.type);
						super.removeEventListener(e.type, e.listener, e.capture);
					}
				}
			}
		}		

		/**
		* @private
		*/
		// NOW SET TO TRUE BY DEFAULT FOR AS3 DEV 
		private var _disableNativeTransform:Boolean = true;
		/**
		* Determines whether transformations are handled internally (natively) on the touchSprite.
		*/
		public function get disableNativeTransform():Boolean{return _disableNativeTransform;}
		public function set disableNativeTransform(value:Boolean):void {_disableNativeTransform = value; }
		/**
		* Determines whether transformations are handled internally (natively) on the touchSprite.
		* Same as !disableNativeTransform.
		*/
		public function get nativeTransform():Boolean{return !_disableNativeTransform;}
		public function set nativeTransform(value:Boolean):void {_disableNativeTransform = !value; }						
		/**
		* @private
		*/
		// default true so that all nested gestures are correct unless specidied
		private var _transformGestureVectors:Boolean = true;
		/**
		* Determines whether transformations are handled internally (natively) on the touchSprite.
		*/
		public function get transformGestureVectors():Boolean{return _transformGestureVectors;}
		public function set transformGestureVectors(value:Boolean):void{	_transformGestureVectors=value;}
		/**
		* @private
		*/
		// NOW SET TO TRUE BY DEFAULT FOR AS3 DEV 
		private var _disableAffineTransform:Boolean = true;
		/**
		* Determines whether gesture event driven transformations are affine on the touchSprite.
		* You must use the $attributes when this flag is set.
		*/
		public function get disableAffineTransform():Boolean{return _disableAffineTransform;}
		public function set disableAffineTransform(value:Boolean):void {_disableAffineTransform = value;}
		/**
		* Determines whether gesture event driven transformations are affine on the touchSprite.
		* You must use the $attributes when this flag is set.
		* Same as !disableAffineTransform
		*/
		public function get affineTransform():Boolean{return !_disableAffineTransform;}
		public function set affineTransform(value:Boolean):void{_disableAffineTransform = !value;}		
		
		private var _x_lock:Boolean = false;
		public function get x_lock():Boolean {return _x_lock;}	
		public function set x_lock(value:Boolean):void { _x_lock = value; }
		
		private var _y_lock:Boolean = false;
		public function get y_lock():Boolean {return _y_lock;}	
		public function set y_lock(value:Boolean):void { _y_lock = value; }	
		
		
		/////////////////////////////////////////////////////////////
		// transform boundaries
		/////////////////////////////////////////////////////////////		
		//translation
		private var _minX:Number;
		public function get minX():Number { return _minX; }
		public function set minX(value:Number):void {
			_minX = value;
		}
		
		private var _maxX:Number;
		public function get maxX():Number { return _maxX; }
		public function set maxX(value:Number):void {
			_maxX = value;
		}
		
		private var _minY:Number;
		public function get minY():Number { return _minY; }
		public function set minY(value:Number):void {
			_minY = value;
		}
		
		private var _maxY:Number;
		public function get maxY():Number { return _maxY; }
		public function set maxY(value:Number):void {
			_maxY = value;
		}		
		
		private var _minZ:Number;
		public function get minZ():Number { return _minZ; }
		public function set minZ(value:Number):void {
			_minZ = value;
		}		
	
		private var _maxZ:Number;
		public function get maxZ():Number { return _maxZ; }
		public function set maxZ(value:Number):void {
			_maxZ = value;
		}
		
		//scale
		private var _minScale:Number;
		public function get minScale():Number { return _minScale; }
		public function set minScale(value:Number):void {
			_minScale = value;
			minScaleX = value;
			minScaleY = value;
		}
		
		private var _maxScale:Number;
		public function get maxScale():Number { return _maxScale; }
		public function set maxScale(value:Number):void {
			_maxScale = value;
			maxScaleX = value; 
			maxScaleY = value;
		}		
		
		private var _minScaleX:Number;
		public function get minScaleX():Number { return _minScaleX; }
		public function set minScaleX(value:Number):void {
			_minScaleX = value;
		}
		
		private var _maxScaleX:Number;
		public function get maxScaleX():Number { return _maxScaleX; }
		public function set maxScaleX(value:Number):void {
			_maxScaleX = value;
		}			
		
		private var _minScaleY:Number;
		public function get minScaleY():Number { return _minScaleY; }
		public function set minScaleY(value:Number):void {
			_minScaleY = value;
		}	
		
		private var _maxScaleY:Number;
		public function get maxScaleY():Number { return _maxScaleY; }
		public function set maxScaleY(value:Number):void {
			_maxScaleY = value;
		}			
		
		private var _minScaleZ:Number;
		public function get minScaleZ():Number { return _minScaleZ; }
		public function set minScaleZ(value:Number):void {
			_minScaleZ = value;
		}		
		
		private var _maxScaleZ:Number;
		public function get maxScaleZ():Number { return _maxScaleZ; }
		public function set maxScaleZ(value:Number):void {
			_maxScaleZ = value;
		}		
		
		//rotation
		private var _minRotation:Number;
		public function get minRotation():Number { return _minRotation; }
		public function set minRotation(value:Number):void {
			_minRotation = value;
			minRotationX = value;
			minRotationY = value;
		}		
		
		private var _maxRotation:Number;
		public function get maxRotation():Number { return _maxRotation; }
		public function set maxRotation(value:Number):void {
			_maxRotation = value;
			maxRotationX = value;
			maxRotationY = value;
		}	
		
		private var _minRotationX:Number;
		public function get minRotationX():Number { return _minRotationX; }
		public function set minRotationX(value:Number):void {
			_minRotationX = value;
		}		
		
		private var _maxRotationX:Number;
		public function get maxRotationX():Number { return _maxRotationX; }
		public function set maxRotationX(value:Number):void {
			_maxRotationX = value;
		}
		
		private var _minRotationY:Number;
		public function get minRotationY():Number { return _minRotationY; }
		public function set minRotationY(value:Number):void {
			_minRotationY = value;
		}		
		
		private var _maxRotationY:Number;
		public function get maxRotationY():Number { return _maxRotationY; }
		public function set maxRotationY(value:Number):void {
			_maxRotationY = value;
		}
		
		private var _minRotationZ:Number;
		public function get minRotationZ():Number { return _minRotationZ; }
		public function set minRotationZ(value:Number):void {
			_minRotationZ = value;
		}		
		
		private var _maxRotationZ:Number;
		public function get maxRotationZ():Number { return _maxRotationZ; }
		public function set maxRotationZ(value:Number):void {
			_maxRotationZ = value;
		}		
		
		/////////////////////////////////////////////////////////////
		//transform methods
		/////////////////////////////////////////////////////////////
		override public function set x(value:Number):void {super.x = value < minX ? minX : value > maxX ? maxX : value;}		
		override public function set y(value:Number):void {super.y = value < minY ? minY : value > maxY ? maxY : value;}
		override public function set z(value:Number):void {super.z = value < minZ ? minZ : value > maxZ ? maxZ : value;}
		override public function set scaleX(value:Number):void {super.scaleX = value < minScaleX ? minScaleX : value > maxScaleX ? maxScaleX : value;}		
		override public function set scaleY(value:Number):void {super.scaleY = value < minScaleY ? minScaleY : value > maxScaleY ? maxScaleY : value;}			
		override public function set scaleZ(value:Number):void {super.scaleZ = value < minScaleZ ? minScaleZ : value > maxScaleZ ? maxScaleZ : value;}
		override public function set rotation(value:Number):void {super.rotation = value < minRotation ? minRotation : value > maxRotation ? maxRotation : value;}
		override public function set rotationX(value:Number):void {super.rotationX = value < minRotationX ? minRotationX : value > maxRotationX ? maxRotationX : value;}		
		override public function set rotationY(value:Number):void {super.rotationY = value < minRotationY ? minRotationY : value > maxRotationY ? maxRotationY : value;}				
		override public function set rotationZ(value:Number):void { super.rotationZ = value < minRotationZ ? minRotationZ : value > maxRotationZ ? maxRotationZ : value;}	
		
		private var _scale:Number = 1;
		/**
		 * Scales display object
		 */	
		public function get scale():Number{return _scale;}
		public function set scale(value:Number):void
		{
			_scale = value < minScale ? minScale : value > maxScale ? maxScale : value;
			scaleX = scale;
			scaleY = scale;
		}					
		
		
		/////////////////////////////////////////////////////////////
		// $ affine transform boundaries
		/////////////////////////////////////////////////////////////			
		//translation
		private var _$minX:Number;
		public function get $minX():Number { return _$minX; }
		public function set $minX(value:Number):void {
			_$minX = value;
		}
		
		private var _$maxX:Number;
		public function get $maxX():Number { return _$maxX; }
		public function set $maxX(value:Number):void {
			_$maxX = value;
		}
		
		private var _$minY:Number;
		public function get $minY():Number { return _$minY; }
		public function set $minY(value:Number):void {
			_$minY = value;
		}
		
		private var _$maxY:Number;
		public function get $maxY():Number { return _$maxY; }
		public function set $maxY(value:Number):void {
			_$maxY = value;
		}		
		
		private var _$minZ:Number;
		public function get $minZ():Number { return _$minZ; }
		public function set $minZ(value:Number):void {
			_$minZ = value;
		}		
	
		private var _$maxZ:Number;
		public function get $maxZ():Number { return _$maxZ; }
		public function set $maxZ(value:Number):void {
			_$maxZ = value;
		}
		
		//scale
		private var _$minScale:Number;
		public function get $minScale():Number { return _$minScale; }
		public function set $minScale(value:Number):void {
			_$minScale = value;
		}
		
		private var _$maxScale:Number;
		public function get $maxScale():Number { return _$maxScale; }
		public function set $maxScale(value:Number):void {
			_$maxScale = value;
		}			
		
		private var _$minScaleX:Number;
		public function get $minScaleX():Number { return _$minScaleX; }
		public function set $minScaleX(value:Number):void {
			_$minScaleX = value;
		}
		
		private var _$maxScaleX:Number;
		public function get $maxScaleX():Number { return _$maxScaleX; }
		public function set $maxScaleX(value:Number):void {
			_$maxScaleX = value;
		}			
		
		private var _$minScaleY:Number;
		public function get $minScaleY():Number { return _$minScaleY; }
		public function set $minScaleY(value:Number):void {
			_$minScaleY = value;
		}	
		
		private var _$maxScaleY:Number;
		public function get $maxScaleY():Number { return _$maxScaleY; }
		public function set $maxScaleY(value:Number):void {
			_$maxScaleY = value;
		}			
		
		private var _$minScaleZ:Number;
		public function get $minScaleZ():Number { return _$minScaleZ; }
		public function set $minScaleZ(value:Number):void {
			_$minScaleZ = value;
		}		
		
		private var _$maxScaleZ:Number;
		public function get $maxScaleZ():Number { return _$maxScaleZ; }
		public function set $maxScaleZ(value:Number):void {
			_$maxScaleZ = value;
		}		
		
		//rotation
		private var _$minRotation:Number;
		public function get $minRotation():Number { return _$minRotation; }
		public function set $minRotation(value:Number):void {
			_$minRotation = value;
		}		
		
		private var _$maxRotation:Number;
		public function get $maxRotation():Number { return _$maxRotation; }
		public function set $maxRotation(value:Number):void {
			_$maxRotation = value;
		}
		
		private var _$minRotationX:Number;
		public function get $minRotationX():Number { return _$minRotationX; }
		public function set $minRotationX(value:Number):void {
			_$minRotationX = value;
		}		
		
		private var _$maxRotationX:Number;
		public function get $maxRotationX():Number { return _$maxRotationX; }
		public function set $maxRotationX(value:Number):void {
			_$maxRotationX = value;
		}
		
		private var _$minRotationY:Number;
		public function get $minRotationY():Number { return _$minRotationY; }
		public function set $minRotationY(value:Number):void {
			_$minRotationY = value;
		}		
		
		private var _$maxRotationY:Number;
		public function get $maxRotationY():Number { return _$maxRotationY; }
		public function set $maxRotationY(value:Number):void {
			_$maxRotationY = value;
		}
		
		private var _$minRotationZ:Number;
		public function get $minRotationZ():Number { return _$minRotationZ; }
		public function set $minRotationZ(value:Number):void {
			_$minRotationZ = value;
		}		
		
		private var _$maxRotationZ:Number;
		public function get $maxRotationZ():Number { return _$maxRotationZ; }
		public function set $maxRotationZ(value:Number):void {
			_$maxRotationZ = value;
		}		
		
		/////////////////////////////////////////////////////////////
		// $ affine transform methods
		/////////////////////////////////////////////////////////////
		// x property
		public function get $x():Number {return _$x;}
		public function set $x(value:Number):void {_$x = value < $minX ? $minX : value > $maxX ? $maxX : value;}
		// y property
		public function get $y():Number {return _$y;}
		public function set $y(value:Number):void {_$y = value < $minY ? $minY : value > $maxY ? $maxY : value;}
		// z property
		public function get $z():Number {return _$z;}
		public function set $z(value:Number):void {_$z = value < $minZ ? $minZ : value > $maxZ ? $maxZ : value;}
		// rotation property
		public function get $rotation():Number{return _$rotation;}
		public function set $rotation(value:Number):void {_$rotation = value < $minRotation ? $minRotation : value > $maxRotation ? $maxRotation : value;}
		// rotationX property
		public function get $rotationX():Number{return _$rotationX;}
		public function set $rotationX(value:Number):void {_$rotationX = value < $minRotationX ? $minRotationX : value > $maxRotationX ? $maxRotationX : value;}
		// rotationY property
		public function get $rotationY():Number{return _$rotationY;}
		public function set $rotationY(value:Number):void{	_$rotationY = value < $minRotationY ? $minRotationY : value > $maxRotationY ? $maxRotationY : value;}
		// rotationZ property
		public function get $rotationZ():Number{return _$rotationZ;}
		public function set $rotationZ(value:Number):void{	_$rotationZ = value < $minRotationZ ? $minRotationZ : value > $maxRotationZ ? $maxRotationZ : value;}
		// scaleX property
		public function get $scaleX():Number {return _$scaleX;}
		public function set $scaleX(value:Number):void{	_$scaleX = value < $minScaleX ? $minScaleX : value > $maxScaleX ? $maxScaleX : value;}
		// scaleY property
		public function get $scaleY():Number {return _$scaleY;}	
		public function set $scaleY(value:Number):void{_$scaleY = value < $minScaleY ? $minScaleY : value > $maxScaleY ? $maxScaleY : value;}
		// scaleZ property
		public function get $scaleZ():Number {return _$scaleY;}	
		public function set $scaleZ(value:Number):void{	_$scaleZ = value < $minScaleZ ? $minScaleZ : value > $maxScaleZ ? $maxScaleZ : value;}
		// affine transform point  
		public function get $transformPoint():Point { return new Point(trO?trO.x:0, trO?trO.y:0);} 
		public function set $transformPoint(pt:Point):void
		{
			if (!tt) return;
			var tpt:Point = tt.affine_modifier.transformPoint(pt);
			trO.x = tpt.x;
			trO.y = tpt.y;
		}
		//affine scale
		public function get $scale():Number{return _$scale;}
		public function set $scale(value:Number):void
		{
			_$scale = value < $minScale ? $minScale : value > $maxScale ? $maxScale : value;
			$scaleX = _$scale;
			$scaleY = _$scale;
		}		

		public var _$x:Number = 0;
		public var _$y:Number = 0;
		public var _$z:Number = 0;
		public var _$scale:Number = 1;		
		public var _$scaleX:Number = 1;
		public var _$scaleY:Number = 1;
		public var _$scaleZ:Number = 1;
		public var _$rotation:Number = 0;
		public var _$rotationX:Number = 0;
		public var _$rotationY:Number = 0;
		public var _$rotationZ:Number = 0;
		public var _$width:Number = 0;
		public var _$height:Number = 0;				
		
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
	
	public function updateDebugDisplay():void
	{
		if(visualizer) visualizer.updateDebugDisplay()
	}
	
	private function onGestureListUpdate(event:GWGestureEvent):void  
		{
			//trace("gesturelist update");
			if (tg) tg.initTimeline();
		}
		
		private var _debugDisplay:Boolean = false;
		public function get debugDisplay():Boolean { return _debugDisplay;}	
		public function set debugDisplay(value:Boolean):void {
			if (debugDisplay == value) return;
						
			_debugDisplay = value;
			if(visualizer)
				visualizer.initDebug();
		}
		
		private var _gestureFilters:Boolean = true;
		public function get gestureFilters():Boolean {return _gestureFilters;}	
		public function set gestureFilters(value:Boolean):void{	_gestureFilters = value;}
		
		// BROADCASTING TEST
		private var _broadcastTarget:Boolean = false;
		public function get broadcastTarget():Boolean {return _broadcastTarget;}	
		public function set broadcastTarget(value:Boolean):void{	_broadcastTarget = value;}
		
		// TRANSFORM 3D
		private var _transform3d:Boolean = false;
		public function get transform3d():Boolean {return _transform3d;}	
		public function set transform3d(value:Boolean):void {	_transform3d = value; }
		
		// TRANSFORM 3D
		private var _motion3d:Boolean = false;
		public function get motion3d():Boolean {return _motion3d;}	
		public function set motion3d(value:Boolean):void{	_motion3d = value;}
		
		
		private var _registerPoints:Boolean = true;
		/**
		* Determines if the touch points are registered to the TouchManager. One can override 
		* this behaivor by setting the value to false. This is useful when creating custom 
		* TouchSprite extensions and external framework bindings.
		* @default true
		*/
		public function get registerPoints():Boolean { return _registerPoints} 
		public function set registerPoints(value:Boolean):void{	_registerPoints = value}		
		
		private var _away3d:Boolean = false;
		/**
		* Sets whether this is representing an Away3D object.
		* @default true
		*/		
		public function get away3d():Boolean {return _away3d;}	
		public function set away3d(value:Boolean):void { _away3d = value; }
		
		public function updateTObjProcessing():void
		{
			
			// MAIN GESTURE PROCESSING LOOP/////////////////////////////////
			
				if (tc) tc.updateClusterAnalysis();
				if (tp) tp.processPipeline();
				if (tg) tg.manageGestureEventDispatch();
				if (tt){
					tt.transformManager();
					tt.updateLocalProperties();
				}
				
				ClusterHistories.historyQueue(_touchObjectID);
		}
		
		/**
		 * Overrides dispatch event to deconlfict duplicate device input 
		 * @param	event
		 * @return
		 */
		override public function dispatchEvent(event:Event):Boolean 
		{
			if (event is GWTouchEvent && duplicateDeviceInput(GWTouchEvent(event)))
				return false;
			return super.dispatchEvent(event);
		}
		
		/**
		 * Registers event listeners. 
		 * @param	type
		 * @param	listener
		 * @param	useCapture
		 * @param	priority
		 * @param	useWeakReference
		 */
		override public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void 
		{			
			addGWTouch(type, listener, useCapture, priority, useWeakReference);
			
			//prevent duplicate events
			if(searchEvent(type, listener, useCapture) < 0)
				_tsEventListeners.push( { type:type, listener:listener, capture:useCapture } );
			
			super.addEventListener(type, listener, useCapture, priority, useWeakReference);
		}
		
		/**
		 * Processes GWTouchEvents by evaluating which types of touch events (TUIO, native touch, and mouse) are active then registers
		 * and dispatches appropriate events.
		 * @param	type
		 * @param	listener
		 * @param	useCapture
		 * @param	priority = 0
		 * @param	useWeakReference
		 */
		private function addGWTouch(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void
		{
			if (GWTouchEvent.isType(type))
			{	
				var listeners:Array = [];
				for each(var gwt:String in GWTouchEvent.eventTypes(type,this)) {
					function gwl(e:*):void {
						dispatchEvent(new GWTouchEvent(e, e.type, e.bubbles, true));
					}
					super.addEventListener(gwt, gwl, useCapture, priority, useWeakReference);
					listeners.push( { type:gwt, listener:gwl } );
				}
				
				listeners.push( { listener:listener } );
				gwTouchListeners[type] = listeners;				
			}			
		}
		
		/**
		 * Unregisters event listeners. 
		 * @param	type
		 * @param	listener
		 * @param	useCapture
		 */
		override public function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void 
		{
			if (!super.hasEventListener(type))
				return;
				
			removeGWTouch(type);
			
			//update event registration array	
			var i:int = searchEvent(type, listener, useCapture);
			if(i >= 0)
				_tsEventListeners.splice(i, 1);
			
			super.removeEventListener(type, listener, useCapture);
		}
		
		/**
		 * Manages removal of GWTouchEvents and associated input (TUIO, native touch, and mouse) events.
		 * @param	type GWTouchEvent type
		 */
		private function removeGWTouch(type:String):void {
			if (GWTouchEvent.isType(type)) {
				for each(var l:* in gwTouchListeners[type]) {
					if (l.type)
						super.removeEventListener(l.type, l.listener);
				}
				delete gwTouchListeners[type];
			}			
		}
		
		/**
		 * Unregisters all event listeners
		 */
		public function removeAllListeners():void {
			var eCnt:int = _tsEventListeners.length;
			var e:*;
			for(var i:int = eCnt-1; i >= 0; i--) {
				e = _tsEventListeners[i];
				removeEventListener(e.type, e.listener, e.capture);
			}
			_tsEventListeners = null;
		}
		
		/**
		 * Search registerd events for provided event
		 * @param	type Event type
		 * @param	listener Listener function
		 * @param	useCapture Capture flag
		 * @return The index of the event in the registration list, or -1 if not registered
		 */
		private function searchEvent(type:String, listener:Function, useCapture:Boolean = false):int {
			for (var i:int = 0; i < _tsEventListeners.length; i++) {
				var el:* = _tsEventListeners[i];
				if (el.type == type && el.listener == listener && el.capture == useCapture) {
					return i;
				}
			}			
			return -1;
		}
		
		private static var input1:GWTouchEvent;
		/**
		 * Prioritizes native touch input over mouse input from the touch screen. Processing
		 * both inputs from the same device produces undesired results. Assumes touch events
		 * will precede mouse events.
		 * @param	event
		 * @return
		 */
		private static function duplicateDeviceInput(event:GWTouchEvent):Boolean {
			if (input1 && input1.source != event.source && (event.time - input1.time < 200))
				return true;
			input1 = event;
			return false;
		}		
		
		/**
		 * Calls the Dispose method for each child possessing a Dispose method then removes all children. 
		 * This is the root destructor intended to be called by overriding dispose functions. 
		 */		
		//public function dispose():void {
			//
			//remove all children
			//for (var i:int = numChildren - 1; i >= 0; i--)
			//{
				//var child:Object = getChildAt(i);
				//if (child.hasOwnProperty("dispose"))
					//child["dispose"]();
				//removeChildAt(i);
			//}	
			//
			//unregister events
			//removeAllListeners();
			//
			//remove from master list
			//delete GestureGlobals.gw_public::touchObjects[_touchObjectID];
		//}
		
	}
}