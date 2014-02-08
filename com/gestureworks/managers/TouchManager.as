////////////////////////////////////////////////////////////////////////////////
//
//  IDEUM
//  Copyright 2011-2012 Ideum
//  All Rights Reserved.
//
//  GestureWorks
//
//  File:    TouchManager.as
//  Authors:  Ideum
//             
//  NOTICE: Ideum permits you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////
package com.gestureworks.managers
{
	import com.gestureworks.core.GestureGlobals;
	import com.gestureworks.core.GestureWorks;
	import com.gestureworks.core.gw_public;
	import com.gestureworks.interfaces.ITouchObject;
	import com.gestureworks.core.TouchCluster;
	import com.gestureworks.core.TouchGesture;
	import com.gestureworks.core.TouchPipeline;
	import com.gestureworks.core.TouchTransform;
	import com.gestureworks.core.TouchVisualizer;
	import com.gestureworks.events.GWEvent;
	import com.gestureworks.events.GWGestureEvent;
	import com.gestureworks.events.GWTouchEvent;
	import com.gestureworks.managers.TouchPointHistories;
	import com.gestureworks.objects.ClusterObject;
	import com.gestureworks.objects.FrameObject;
	import com.gestureworks.objects.GestureListObject;
	import com.gestureworks.objects.TouchPointObject;
	import com.gestureworks.objects.StrokeObject;
	import com.gestureworks.objects.TimelineObject;
	import com.gestureworks.objects.TransformObject;
	import com.gestureworks.utils.GestureParser;
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.events.TouchEvent;
	import flash.utils.Dictionary;
	import org.tuio.TuioEvent;
	
	import flash.geom.Vector3D;
	import com.gestureworks.objects.InteractionPointObject;
	
	import com.gestureworks.core.TouchSprite; 
	import com.gestureworks.core.TouchMovieClip; 	
	
	
	/* 
	IMPORTANT NOTE TO DEVELOPER ********************************
	PlEASE DO NOT ERASE OR DEVALUE ANYTHING WHITHIN THIS CLASS
	IF YOU HAVE ANY QUESTIONS, ANY AT ALL. PLEASE ASK PAUL LACEY
	DO NOT TAKE CODE OUT UNLESS YOUR CHANGES ARE VERIEFIED, 
	TESTED AND CONTINUE TO WORK WITH LEGACY BUILDS !
	************************************************************
	*/
	
	public class TouchManager
	{
		public static var touchPoints:Dictionary = new Dictionary();
		public static var touchObjects:Dictionary = new Dictionary();
		private static var virtualTransformObjects:Dictionary = new Dictionary();
		
		private static var gts:TouchSprite;
		private static var gms:*;
		private static var gss:*;
		
		private static var hooks:Vector.<Function>;
		private static var _overlays:Vector.<ITouchObject> = new Vector.<ITouchObject>();
		
		private static var gms_init:Boolean = false;
		private static var gss_init:Boolean = false;
		
		// initializes touchManager
		gw_public static function initialize():void
		{	
			//trace("touch frame processing rate:",GestureGlobals.touchFrameInterval);
			
			touchPoints = GestureGlobals.gw_public::touchPoints;
			touchObjects = GestureGlobals.gw_public::touchObjects;
			
			// CREATE GLOBAL MOTION SPRITE TO HANDLE ALL GEOMETRIC GLOBAL ANALYSIS OF MOTION POINTS
			gts = new TouchSprite();
				gts.active = true;
				gts.touchEnabled = true;
				gts.tc.touch_core = true; // fix for global core analysis
				gts.tc.core = true;
				
				/*
				gts.graphics.lineStyle(4, 0x333333, 1);
				gts.graphics.beginFill(0x555555,0.5);
				gts.graphics.drawRect(0, 0, 300, 300);
				gts.x = 200;
				gts.y = 200;
				
				gts.debugDisplay = true;
				gts.nativeTransform = true;
				gts.affineTransform = false;
				//ts0.gestureTouchInertia = true;
				gts.gestureReleaseInertia = true;
				gts.gestureEvents = true;
				
				gts.gestureList = { "1-finger-pivot":true, "5-finger-orient":true, "n-manipulate-inertia":true };
				//ts0.gestureList = {"n-manipulate":true};
				
			addChild(gts);
				*/
				
				
			GestureGlobals.touchSpriteID = gts.touchObjectID;

			
			if (GestureWorks.activeNativeTouch) {			
				
				//DRIVES POINT REGISTRATION
				GestureWorks.application.addEventListener(TouchEvent.TOUCH_BEGIN, onTouchBegin);
				//DRIVES UPDATES ON POINT LIFETIME
				GestureWorks.application.addEventListener(TouchEvent.TOUCH_END, onTouchEnd);
				// DRIVES UPDATES ON TOUCH POINT PATHS
				GestureWorks.application.addEventListener(TouchEvent.TOUCH_MOVE, onMove);
			}
			
			// leave this on for all input types
			GestureWorks.application.addEventListener(GWEvent.ENTER_FRAME, touchFrameHandler); //MOVE TO INTERACTION MANAGER
		}
		
		gw_public static function deInitialize():void
		{
			GestureWorks.application.removeEventListener(TouchEvent.TOUCH_BEGIN, onTouchBegin);
			GestureWorks.application.removeEventListener(TouchEvent.TOUCH_END, onTouchEnd);
			GestureWorks.application.removeEventListener(TouchEvent.TOUCH_MOVE, onMove);
		}	
		
	
		public static function pointCount():int {
			
			var count:int = 0;
			for each(var point:TouchPointObject in touchPoints)
			//for each(var ts:Object in touchObjects)
				{
				count++;
				//trace("what")
				}
			//trace(count);
			return count;
		} 
		
		// registers touch point via touchSprite
		private static function registerTouchPoint(event:GWTouchEvent):void
		{
			//FIX CELAN UP REFERENCE 
			touchPoints[event.touchPointID].history.unshift(TouchPointHistories.historyObject(event))	
		}
		
		
		
		
		
		
		
		
		
		
		
		
		
		/**
		 * Register a virtual transform object with the touch manager
		 * @param	t
		 */
		public static function registerVTO(t:ITouchObject):void {
			virtualTransformObjects[t.vto] = t;  
		}
		
		/**
		 * Deregisters a virtual transform object 
		 * @param	t
		 */		
		public static function deregisterVTO(t:ITouchObject):void {
			delete virtualTransformObjects[t.vto];
		}
		
		/**
		 * Registers a function to externally modify the provided GWTouchEvent for point processing
		 * @param  hook  The hook function with GWTouchEvent parameter
		 */
		public static function registerHook(hook:Function):void {
			if (!hooks)
				hooks = new Vector.<Function>();
			hooks.push(hook);
		}
		
		/**
		 * Unregisters a hook function
		 * @param	hook
		 */
		public static function deregisterHook(hook:Function):void {
			if(hooks){
				var index:int = hooks.indexOf(hook);
				if (index > -1)
					hooks.splice(index, 1);
			}
		}
		
		/**
		 * Applies updates to GWTouchEvent through registered hook functions
		 * @param	event
		 */
		private static function applyHooks(event:GWTouchEvent):void {
			for each(var hook:Function in hooks) {
				event = hook(event);
			}
		}
		
		/**
		 * Registers global overlays to receive point data
		 */
		public static function get overlays():Vector.<ITouchObject> { return _overlays; }
		public static function set overlays(o:Vector.<ITouchObject>):void {
			_overlays = o;
		}	
		
		/**
		 * Sends overlays through pipeline
		 * @param	e
		 */
		public static function processOverlays(e:GWTouchEvent, o:Vector.<ITouchObject> = null):void {
			if (!o)
				o = overlays;
			for each(var overlay:ITouchObject in o) 	{
					
				var actual:Object = e.target;									
				overlay.active = true;
				e.target = overlay;
				overlay.dispatchEvent(e);
				
				if (e.type == "gwTouchBegin") {
					if(actual)
						assignPointClone(e);
					else
						onTouchDown(e);
				}
			}			
		}
		
		/**
		 * Determines the event's target is valid based on activated state and local mode settings.
		 * @param	event
		 * @return
		 */
		public static function validTarget(event:GWTouchEvent):Boolean {
			activatedTarget(event);
			
			//trace("valid target check",event.target,event.source)
			
			if (event.target is ITouchObject && event.target.active) {
				
				//local mode filters
				if (event.target.localModes) {
					
					//trace("event source",event.source, event.target.localModes)
					
					switch(event.source) {
						case TouchEvent:
							return event.target.nativeTouch;
						case MouseEvent:
							return event.target.simulator;
						case TuioEvent:
							return event.target.tuio;
						case Leap2DManager:
							return event.target.leap2D;
						case Touch2DSManager:
							return event.target.server;
						default:
							return true;
					}
				}			
				return true;
				
			}
			return false;
		}
		
		/**
		 * If target is not activated, updates the target to the first activated ancestor
		 * @param	event
		 */
		private static function activatedTarget(event:GWTouchEvent):void {
			
			trace("activated target",event.target)
			
			if (!event.target || (event.target is ITouchObject && event.target.active)) 
				return;
			else if (virtualTransformObjects[event.target])
				event.target = virtualTransformObjects[event.target];
			else
				event.target = event.target.parent;
			activatedTarget(event);
		}
		
		/**
		 * Convert TouchEvent to GWTouchEvent
		 * @param	event
		 */
		private static function onTouchBegin(e:TouchEvent):void 
		{			
			var event:GWTouchEvent = new GWTouchEvent(e);					
			onTouchDown(event);
			//processOverlays(event);
		}
		
		/**
		 * Decides how to assign the captured touch point to a cluster and pass to parent, an explicit target, an explicit list of 
		 * targets or passed to any touch object in the local display stack.
		 * @param	event
		 * @param	overrideRegisterPoints
		 */
		public static function onTouchDown(event:GWTouchEvent):void
		{
			trace("touch manager on touch down", event.touchPointID,gts.touchPointCount, gts.cO.pointArray.length)
			
			//////////////////////////////////////////////////////////////////////////////
			// CREATE NEW TOUCHPOINT IN GLOBAL TOUCH OBJECT
			// ADD TO POINT LIST OF GLOBAL TOUCH OBJECT
			var tpO:TouchPointObject  = new TouchPointObject();
					
					tpO.id = gts.motionPointCount; 
					tpO.touchPointID = event.touchPointID;
					tpO.position.x = event.stageX;
					tpO.position.y = event.stageY;
					tpO.position.z = event.stageZ;
					
					//tpO.length = event.value.length;
					//tpO.width = event.value.width;
					
					//ADD TO GLOBAL MOTION SPRITE POINT LIST
					gts.cO.pointArray.push(tpO);
					gts.touchPointCount++;//touchPointCount++;
				
				
				// ASSIGN POINT OBJECT WITH GLOBAL POINT LIST DICTIONARY
				GestureGlobals.gw_public::touchPoints[event.touchPointID] = tpO;
				
				// REGISTER TOUCH POINT WITH TOUCH MANAGER
				//TODO: REF POINT OBJECTS NOT EVENT
				registerTouchPoint(event);//tpO
				
			///////////////////////////////////////////////////////////////////////////////////
			///////////////////////////////////////////////////////////////////////////////////
			
			
			/*
			applyHooks(event);
			
			if (validTarget(event)) { 
											
				if (ITouchObject(event.target).registerPoints) {
				
					if (duplicateDeviceInput(event)) return;
								
					if (event.target.targetParent && event.target.parent is ITouchObject && event.target.parent.active) { //ASSIGN PRIMARY CLUSTER TO PARENT
						event.target = event.target.parent;	
						assignPoint(event);
					}
					//else if (event.target.targetList.length)
					//{							
						//ASSIGN THIS TOUCH OBJECT AS PRIMARY CLUSTER
						//assignPoint(event);
						//var tgt:Object;
						//
						//CREATE SECONDARY CLUSTERS ON TARGET LIST ITEMS
						//for (var i:int = 0; i < event.target.targetList.length; i++) 
						//{
							//tgt = event.target.targetList[i];
							//
							//if (!tgt is ITouchObject)
								//tgt = virtualTouchObjects[tgt];
							//
							//if(tgt is ITouchObject && tgt.active){
								//assignPointClone(event, ITouchObject(tgt));
								//tgt.broadcastTarget = true;
							//}
						//}
					//}
					else {
						 assignPoint(event);
						 if (event.target.parent is ITouchObject) {
							event.target = event.target.parent;
							propagatePoint( event);
						 }
					}
				}
			}
			*/
			//trace("TM DOWN",event.stageX,event.stageY,event.stageZ,validTarget(event));
		}
		
	/**
		 * Convert TouchEvent to GWTouchEvent
		 * @param	event
		 */
		private static function onTouchEnd(e:TouchEvent):void {
			var event:GWTouchEvent = new GWTouchEvent(e);
			onTouchUp(event);
			//processOverlays(event);
		}		
		
		// stage on TOUCH_UP.
		public static function onTouchUp(event:GWTouchEvent):void
		{
			////////////////////////////////////////////////////////////////////////////////////
			//trace("Touch point End, touchManager", event.touchPointID,gts.touchPointCount, gts.cO.pointArray.length)
			var touchPointID:int = event.touchPointID;
			var tpO:TouchPointObject = touchPoints[touchPointID];
			
			//trace("ready to remove", pointObject);
			
			if (tpO)
			{
					// REMOVE POINT FROM LOCAL LIST
					gts.cO.pointArray.splice(tpO.id, 1);
					//test motionSprite.cO.motionArray.splice(pointObject.motionPointID, 1);
					
					// REDUCE LOACAL POINT COUNT
					gts.touchPointCount--;
					
					// UPDATE POINT ID 
					for (var i:int = 0; i < gts.cO.pointArray.length; i++)
					{
						gts.cO.pointArray[i].id = i;
					}
				
					// DELETE FROM GLOBAL POINT LIST
					delete touchPoints[event.touchPointID];
			}
			
			//trace("should be removed",mpoints[motionPointID], motionSprite.motionPointCount, motionSprite.cO.motionArray.length);
			/////////////////////////////////////////////////////////////////////////////////////
			/////////////////////////////////////////////////////////////////////////////////////
			
			
			/*
			applyHooks(event);
			var pointObject:Object = points[event.touchPointID];
			
			if (pointObject) {
				// allows bindings to work without killing global nativeTouch listeners
				// NOTE: when enabling targeting object will have to be replaced with objectList
				if (ITouchObject(pointObject.object).registerPoints) { 
					/////////////////////////////////////////////////////////////////////////////////////
					/////////////////////////////////////////////////////////////////////////////////////
					// LOOP THROUGH ALL CLUSTERS LISTED ON POINT
					for (var j:int = 0; j < pointObject.objectList.length; j++)
					{
						//trace("updating targets");
						var i:int;
						var tO:ITouchObject = pointObject.objectList[j];
						
						//trace("tsprite:", tO, "frame:", tO.tiO.frame.pointEventArray);
						//trace("tsprite:",tO, "pointlist",tO.N,tO.pointArray.length, tO.pointArray);
						
						// UPDATE EVENT TIMELINES // push touch up event to touch object timeline
						//if ((tO.tiO.timelineOn) && (tO.tiO.pointEvents)) 
						if(tO.tiO) tO.tiO.frame.pointEventArray.push(event);// pushed touch up events into the timeline object
						//UPDATE DEBUG DISPLAY // clear local debug display
						if ((tO.visualizer) && (tO.visualizer.debug_display) && (tO.cO)) 	tO.visualizer.clearDebugDisplay(); // clear display
						
						// analyze for taps
						if (tO.tg) tO.tg.onTouchEnd(event);
						
						// REMOVE POINT FROM LOCAL LIST
						tO.pointArray.splice(pointObject.id, 1);
						
						// REDUCE LOACAL POINT COUNT
						tO.pointCount--;
						
						// UPDATE POINT ID 
						for (i = 0; i < tO.pointArray.length; i++) {
							tO.pointArray[i].id = i;
						}
						
						// update broadcast state
						//if(tO.N == 0) tO.broadcastTarget = false;
						
						////////////////////////////////////////////////////////
						//FORCES IMMEDIATE UPDATE ON TOUCH UP
						//HELPS ENSURE ACCURATE RELEASE STATE FOR SINGLE FINGER SINGLE TAP CAPTURES
						updateTouchObject(tO);
					}
				}
				// DELETE FROM GLOBAL POINT LIST
				delete points[event.touchPointID];
			}*/
		}
		
		
		/**
		 * Convert TouchEvent to GWTouchEvent
		 * @param	event
		 */
		private static function onMove(e:TouchEvent):void {
			var event:GWTouchEvent = new GWTouchEvent(e);
			onTouchMove(event);
			//processOverlays(event);			
		}			
	
		private static var pointObject:TouchPointObject;		
		// the Stage TOUCH_MOVE event.	
		// DRIVES POINT PATH UPDATES
		
		public static function onTouchMove(event:GWTouchEvent):void
		{	
			trace("touch manager on touch move", event.touchPointID, gts.touchPointCount, gts.cO.pointArray.length)
			///////////////////////////////////////////////////////////////////////////////
			///////////////////////////////////////////////////////////////////////////////
			//  CONSOLODATED UPDATE METHOD FOR POINT POSITION AND TOUCH OBJECT CALCULATIONS
			var tpO:TouchPointObject = touchPoints[event.touchPointID];
			
				if (tpO)
				{	
					//trace(event.value.position.x, event.value.position.y,event.value.position.z)
					//tpO.id  = //event.id;
					tpO.touchPointID  = event.touchPointID;
					
					tpO.position.x = event.stageX;
					tpO.position.y = event.stageY;
					tpO.position.z = event.stageZ;
					
					//tpO.length = event.sizeX;
					//tpO.width = event.sizeY;
					//tpO.pressure = event.pressure;
					

					tpO.moveCount ++;
					//trace( tpO.moveCount);
				}
				
				// UPDATE POINT HISTORY 
				TouchPointHistories.historyQueue(event);
				//////////////////////////////////////////////////////////////////////////////
				/////////////////////////////////////////////////////////////////////////////
			
			
			/*
			applyHooks(event);
			//  CONSOLODATED UPDATE METHOD FOR POINT POSITION AND TOUCH OBJECT CALCULATIONS
			pointObject = points[event.touchPointID];
			
			if (pointObject) {
				// allows bindings to work without killing global nativeTouch listeners
				// NOTE: when enabling targeting object will have to be replaced with objectList
				if (pointObject.object["registerPoints"]) { 
					// UPDATE POINT POSITIONS
					//pointObject.position.x = event.stageX;					
					//pointObject.position.y = event.stageY;
					//pointObject.position.z = event.stageZ;
					pointObject.position = new Vector3D(event.stageX, event.stageY,event.stageZ); 
					
					pointObject.moveCount++;
					
					// UPDATE POINT HISTORY 
					// PUSHES NEWEST LOCATION DATA TO POINT PATH/HISTORY
					
					// SHOULD PUSH POINT OBJECT NOT EVENT 
					// TO REDUCE REFERENING
					PointHistories.historyQueue(event);
				}
				//trace("PointObject",pointObject.source,pointObject.target )
			}
			//trace("TM MOVE",event.stageX,event.stageY,event.stageZ,event.source, event.target,event.touchPointID);
			*/
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
		 * Assign point clones to parent's with cluster bubbling enabled.
		 * @param	target
		 * @param	event
		 */
		private static function propagatePoint(event:GWTouchEvent):void {
			if (!event.target)
				return;
			
			if (validTarget(event) && event.target.clusterBubbling) {
				assignPointClone(event);
				
				if (event.target.parent is ITouchObject) {
					event.target = event.target.parent;
					propagatePoint(event);
				}
			}
		}
		
		/**
		 * Registers assigned touch point globaly and to relevant local clusters 
		 * @param	target
		 * @param	event
		 */
		private static function assignPoint(event:GWTouchEvent, target:ITouchObject = null):void // asigns point
		{		
			if (!target)
				target = event.target as ITouchObject;
				
			// create new point object
			var pointObject:TouchPointObject  = new TouchPointObject();	
				pointObject.object = target; // sets primary touch object/cluster
				pointObject.id = target.touchPointCount; // NEEDED FOR THUMBID
				pointObject.touchPointID = event.touchPointID;
				//pointObject.position.x = event.stageX;
				//pointObject.position.y = event.stageY; 
				//pointObject.position.z = event.stageZ; 
				pointObject.position = new Vector3D(event.stageX, event.stageY,event.stageZ); 
				
				pointObject.objectList.push(target); // seeds cluster/touch object list
				
				target.view = event.view;
				
				//ADD TO LOCAL POINT LIST
				target.pointArray.push(pointObject);
				
				//UPDATE LOCAL CLUSTER OBJECT
				target.cO.pointArray = target.pointArray;												
				
				// INCREMENT POINT COUTN ON LOCAL TOUCH OBJECT
				target.touchPointCount++;
				
				// ASSIGN POINT OBJECT WITH GLOBAL POINT LIST DICTIONARY
				GestureGlobals.gw_public::points[event.touchPointID] = pointObject;
				
				if(target.registerPoints)
					registerTouchPoint(event);

				// add touch down to touch object gesture event timeline
				if((target.tiO)&&(target.tiO.timelineOn)&&(target.tiO.pointEvents)) target.tiO.frame.pointEventArray.push(event); /// puts each touchdown event in the timeline event array	
		}	
		
		private static function assignPointClone(event:GWTouchEvent, target:ITouchObject=null):void // assigns point copy
		{
			if (!target)
				target = event.target as ITouchObject;
				
			// assign existing point object
			var pointObject:TouchPointObject = GestureGlobals.gw_public::points[event.touchPointID]
				// add this touch object to touchobject list on point
				pointObject.touchPointID = event.touchPointID;//-??
				pointObject.objectList.push(target);  ////////////////////////////////////////////////NEED TO COME UP WITH METHOD TO REMOVE TOUCH OBJECT THAT ARE NOT LONGER ON STAGE

			//ADD TO LOCAL POINT LIST
			target.pointArray.push(pointObject);
			
			//UPDATE LOCAL CLUSTER OBJECT
			//touch object point list and cluster point list should be consolodated
			target.cO.pointArray = target.pointArray;
			
			//UPDATE POINT LOCAL COUNT
			target.touchPointCount++;
			
			// add touch down to touch object gesture event timeline
			if ((target.tiO)&&(target.tiO.timelineOn) && (target.tiO.pointEvents)) target.tiO.frame.pointEventArray.push(event); /// puts each touchdown event in the timeline event array
			
			//trace("ts clone bubble target, point array length",pointArray.length, pointObject.touchPointID, pointObject.objectList.length, this);
		}	
		
		
		
		
		
		
		///////////////////////////////////////////////////////////////////
		///////////////////////////////////////////////////////////////////
		// MOVE ALL TO INTERACTION MANAGER
		///////////////////////////////////////////////////////////////////
		///////////////////////////////////////////////////////////////////
			
		public static function preinitBase(obj:ITouchObject):void 
        {
			//trace("create touchsprite base"); 
			obj.addEventListener(GWGestureEvent.GESTURELIST_UPDATE, onGestureListUpdate); 
			obj.updateListeners();				
							
			// Register touchObject with object manager, return object id
			obj.touchObjectID = ObjectManager.registerTouchObject(obj);
			GestureGlobals.gw_public::touchObjects[obj.touchObjectID] = obj;
			
			// create generic analysis engine
			//if (GestureGlobals.analyzeCluster)
				//{
				/////////////////////////////////////////////////////////////////////////
				// CREATES A NEW CLUSTER OBJECT FOR THE TOUCHSPRITE
				// HANDLES CORE GEOMETRIC RAW PROPERTIES OF THE CLUSTER
				/////////////////////////////////////////////////////////////////////////
				obj.cO = new ClusterObject(); // touch cluster 2d 
					obj.cO.id = obj.touchObjectID; 
				GestureGlobals.gw_public::clusters[obj.touchObjectID] = obj.cO;
				
				// create new stroke object
				obj.sO = new StrokeObject(); 
					obj.sO.id = obj.touchObjectID;
				
				/////////////////////////////////////////////////////////////////////////
				// CREATERS A NEW GESTURE OBJECT
				// A VEHICLE TO CONTAIN CORE GESTURE VALUES
				/////////////////////////////////////////////////////////////////////////
				obj.gO = new GestureListObject(); 
					obj.gO.id = obj.touchObjectID;
				GestureGlobals.gw_public::gestures[obj.touchObjectID] = obj.gO;
				
				/////////////////////////////////////////////////////////////////////////
				// CREATES A NEW TRANSFORM OBJECT
				// ACTS AS A VIRTUAL DISPLAY OBJECT CONTAINS ALL THE MODIFIED AND MAPPED
				// DISPLAY PROPERTIES TO BE TRANSFERED TO THE TOUCHSPRITE
				/////////////////////////////////////////////////////////////////////////
				obj.trO = new TransformObject(); 
					obj.trO.id = obj.touchObjectID;
				GestureGlobals.gw_public::transforms[obj.touchObjectID] = obj.trO;
				
				/////////////////////////////////////////////////////////////////////////
				// CREATES A NEW TIMELINE OBJECT 
				// CONTAINS A HISTORY OF ALL TOUCH EVENTS, CLUSTER EVENTS, GESTURE EVENTS 
				// AND TRANSFORM EVENTS THAT OCCUR ON THE TOUCHSPRITE
				/////////////////////////////////////////////////////////////////////////
				obj.tiO = new TimelineObject();  
					obj.tiO.id = obj.touchObjectID;
					obj.tiO.timelineOn = false; // activates timline manager
					obj.tiO.pointEvents = false; // pushes point events into timline
					obj.tiO.clusterEvents = false; // pushes cluster events into timeline
					obj.tiO.gestureEvents = false; // pushes gesture events into timleine
					obj.tiO.transformEvents = false; // pushes transform events into timeline
				GestureGlobals.gw_public::timelines[obj.touchObjectID] = obj.tiO;
				
			//}
			
			// bypass gml requirement for testing
			initBase(obj);
			if (obj.debugDisplay)
				obj.visualizer.initDebug();
		}	
		
		private static function initBase(obj:ITouchObject):void 
		{
							obj.tc = new TouchCluster(obj.touchObjectID); 
							obj.tp = new TouchPipeline(obj.touchObjectID);
		if (obj.gestureEvents)	obj.tg = new TouchGesture(obj.touchObjectID);
							obj.tt = new TouchTransform(obj.touchObjectID);
							obj.visualizer = new TouchVisualizer(obj.touchObjectID);
		}	
		
		public static function callLocalGestureParser(obj:ITouchObject):void
		{
			//trace("call local parser touch sprite", );
			
			var gp:GestureParser = new GestureParser(); 
				gp.gestureList = obj.gestureList;
				gp.parse(obj.touchObjectID);
				
				if (obj.traceDebugMode) gp.traceGesturePropertyList();
				
			//tp re init vector metric and get new stroke lib for comparison
			if (obj.tc) obj.tc.initClusterAnalysisConfig();
			
			// update touch object transform proerty limits
			// note: multiple gestures on same object will overwrite property limits is map to same property
			if (obj.tt) obj.tt.updateTransformLimits();
			
			//trace("local gesture parser triggered init");
		}	
		
		
		private static function updateTObjProcessing(obj:ITouchObject):void
		{
			
			// MAIN GESTURE PROCESSING LOOP/////////////////////////////////
			
				if (obj.tc) obj.tc.updateClusterAnalysis();
				if (obj.tp) obj.tp.processPipeline();
				if (obj.tg) obj.tg.manageGestureEventDispatch();
				if (obj.tt){
					obj.tt.transformManager();
					obj.tt.updateLocalProperties();
				}
				
				ClusterHistories.historyQueue(obj.touchObjectID);
		}	
		
		private static function onGestureListUpdate(event:GWGestureEvent):void  
		{
			//trace("gesturelist update");
			var obj:ITouchObject = event.target as ITouchObject;
			if (obj.tg) obj.tg.initTimeline();
		}		
		
		//////////////////////////////////////////////////////////////////////////////////////////////////
		//////////////////////////////////////////////////////////////////////////////////////////////////
		// UPDATE ALL TOUCH OBJECTS IN DISPLAY LIST
		// WILL MOVE TO INTERACTION MANAGER AND MAKE GENERIC 
		// FOR MULTIMODAL
		
		public static function touchFrameHandler(event:GWEvent):void
		{
			trace("touch frame process ----------------------------------------------",gts.touchPointCount, gts.cO.pointArray.length);	
			
			//INCREMENT TOUCH FRAME id
			GestureGlobals.frameID += 1;
			
			//trace(GestureGlobals.frameID)
			/////////////////////////////////////////////////////////////////////////////
			if (GestureWorks.activeSensor)
			{
				gss = GestureGlobals.gw_public::touchObjects[GestureGlobals.sensorSpriteID]; //REMOVE AND ASSIGN ONLY ONCE
			}
			
			//GET MOTION POINT LIST
			if (GestureWorks.activeMotion)
			{
				gms = GestureGlobals.gw_public::touchObjects[GestureGlobals.motionSpriteID]; //REMOVE AND ASSIGN ONLY ONCE
				gms.tc.getSkeletalMetrics3D();
				
				//trace("FrameID");
				// TODO:MUST CHNAGE TO INIT ONCE GML IS FULLY PARSED
				// ON ALL OBJECTS
				if (GestureGlobals.frameID == 200) gms.tc.initGeoMetric3D();//initi geemetic gloabl ip activation
				
			}
			
			//TODO: CLEAN UP INIT
			// DISABLE BLOCK WHEN NO MOTION POINTS
			// update all touch objects in display list
			for each(var tO:Object in touchObjects)
			{
				//trace("tm touchobject",tO, tO.tc.core,GestureWorks.activeSensor,tO.sensorEnabled);
				
				
				////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
				//PULL SENSOR POINT DATA INTO EACH TOUCHOBJECT
				//GET GLOBAL SENSOR POINTS		
				if ((GestureWorks.activeNativeTouch) && (tO.touchEnabled) && (!tO.tc.core))
				{
					if (tO.cO)
					{
						//trace("push global sensor to local touch object");
						//GLOBAL PUSH TO ALL SENSOR ENABLED VIOs
						tO.cO.pointArray = gts.cO.pointArray
					}
					else 
						continue;
				}
				
				
				////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
				//PULL SENSOR POINT DATA INTO EACH TOUCHOBJECT
				//GET GLOBAL SENSOR POINTS		
				if ((GestureWorks.activeSensor) && (tO.sensorEnabled) && (!tO.tc.core))
				{
					if (tO.cO)
					{
						//trace("push global sensor to local touch object");
						//GLOBAL PUSH TO ALL SENSOR ENABLED VIOs
						tO.cO.sensorArray = gss.cO.sensorArray
					}
					else 
						continue;
				}
				
				////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
				//PULL MOTION POINT DATA INTO EACH TOUCHOBJECT
				//GET GLOBAL MOTION POINTS		
				if((GestureWorks.activeMotion)&&(tO.motionEnabled)){ //MUST ADD !CORE
					if (tO.cO)
					{
						if (GestureGlobals.frameID == 200) 
						{
							//trace("int ip support")
							tO.tc.initIPSupport();
							tO.tc.initIPFilters(); //CHECK
						}
						
						tO.cO.motionArray = gms.cO.motionArray
						tO.cO.handList = gms.cO.handList;
					}
					else 
						continue;
				}
				///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
				// update touch,cluster and gesture processing
				updateTouchObject(ITouchObject(tO));
				

				// move to timeline visualizer
				// CURRENTLY NO GESTURE OR CLUSTER ANALYSIS REQURES
				// DIRECT CLUSTER OR TRANSFROM HISTORY, USED IN DEBUG ONLY
				if ((tO.visualizer)&&(tO.visualizer.debug_display))
				{
					//UPDATE TRANSFORM HISTORIES
					TransformHistories.historyQueue(tO.touchObjectID);
					
					// update touch object debugger display
					tO.updateDebugDisplay();
				}
			}
			
			//TRACK INTERACTIONS POINTS AND INTERACTION EVENTS
			// update interation point global list
			InteractionPointTracker.getActivePoints();
			
			// zero motion frame count
			GestureGlobals.motionFrameID = 1;
			//trace(GestureGlobals.motionframeID)
		}
		
		
		// EXTERNAL UPDATE METHOD/////////////////////////////////////////////////////////
		
		public static function updateTouchObject(tO:ITouchObject):void
		{
				//trace("hello", ts, ts.N);
				// THERFOR CLUSTER ANALYSIS IS N SPECICIFC AND SELF MAMANGED SWITCHING
				// PIPELINE PROCESSING IS GESTURE OBJECT STATE DEPENDANT AND NOT N DEPENDANT
				

				updateTObjProcessing(tO);
				//trace(tO.touchObjectID)
				
				// check for erroneous points
				// kill after processing (just in case)
				if (tO.tpn != 0) {
					
					trace("length",tO.tpn,tO.pointArray.length)
					
					for (var i:int = 0; i < tO.pointArray.length; i++) {//tO.tpn
						if (touchPoints[tO.pointArray[i].touchPointID] == undefined) {
						
							//trace("kill zombe",tO,tO.cO,tO.cO.pointArray.length,tO.cO.pointArray.length,tO.pointArray[i].touchPointID,i);

								/*
									tO.pointCount = 0;
									tO.cO.n = 0;
									tO.N = 0;
									tO.pointArray[i] = null;
									tO.cO.pointArray[i] = null;
							 
									// REMOVE POINT FROM LOCAL LIST
									tO.pointArray.splice(tO.pointArray[i].touchPointID, 1);
									
									// REDUCE LOACAL POINT COUNT
									tO.pointCount--;
									
									// UPDATE POINT ID 
									for (var k:int = 0; k < tO.pointArray.length; k++)
									{
										tO.pointArray[k].id = k;
									}
								*/
							
							tO.cO.pointArray.length = 0; // best way to kill
							return
						}
					}
				}
		}
		
		
	}
}