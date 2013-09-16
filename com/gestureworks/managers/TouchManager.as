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
	import com.gestureworks.core.ITouchObject;
	import com.gestureworks.core.TouchCluster;
	import com.gestureworks.core.TouchGesture;
	import com.gestureworks.core.TouchPipeline;
	import com.gestureworks.core.TouchTransform;
	import com.gestureworks.core.TouchVisualizer;
	import com.gestureworks.events.GWEvent;
	import com.gestureworks.events.GWGestureEvent;
	import com.gestureworks.events.GWTouchEvent;
	import com.gestureworks.managers.PointHistories;
	import com.gestureworks.objects.ClusterObject;
	import com.gestureworks.objects.FrameObject;
	import com.gestureworks.objects.GestureListObject;
	import com.gestureworks.objects.PointObject;
	import com.gestureworks.objects.StrokeObject;
	import com.gestureworks.objects.TimelineObject;
	import com.gestureworks.objects.TransformObject;
	import com.gestureworks.utils.GestureParser;
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.events.TouchEvent;
	import flash.utils.Dictionary;
	import org.tuio.TuioEvent;
	import org.tuio.TuioTouchEvent;
	
	
	
	
	
	
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
		public static var points:Dictionary = new Dictionary();
		public static var touchObjects:Dictionary = new Dictionary();
		
		private static var gms:*;
		
		// initializes touchManager
		gw_public static function initialize():void
		{	
			//trace("touch frame processing rate:",GestureGlobals.touchFrameInterval);
			
			points = GestureGlobals.gw_public::points;
			touchObjects = GestureGlobals.gw_public::touchObjects;
			
			//global_motion_sprite = GestureGlobals.gw_public::touchObjects[GestureGlobals.motionSpriteID];
			
			if (GestureWorks.activeNativeTouch) {			
				
				//DRIVES POINT REGISTRATION
				GestureWorks.application.addEventListener(TouchEvent.TOUCH_BEGIN, onTouchBegin);
				
				//DRIVES UPDATES ON POINT LIFETIME
				GestureWorks.application.addEventListener(TouchEvent.TOUCH_END, onTouchEnd);
				
				// DRIVES UPDATES ON TOUCH POINT PATHS
				GestureWorks.application.addEventListener(TouchEvent.TOUCH_MOVE, onMove);
			}

			// leave this on for all input types
			GestureWorks.application.addEventListener(GWEvent.ENTER_FRAME, touchFrameHandler);
		}
		
		gw_public static function resetGlobalClock():void
		{
			//globalClock = new Timer(GestureGlobals.touchFrameInterval, 0);
			//globalClock = new Timer(2000, 0);
		}
		
		gw_public static function deInitialize():void
		{
			GestureWorks.application.removeEventListener(TouchEvent.TOUCH_BEGIN, onTouchBegin);
			GestureWorks.application.removeEventListener(TouchEvent.TOUCH_END, onTouchEnd);
			GestureWorks.application.removeEventListener(TouchEvent.TOUCH_MOVE, onMove);
		}		
		
		public static function pointCount():int {
			
			var count:int = 0;
			for each(var point:Object in points)
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
			points[event.touchPointID].history.unshift(PointHistories.historyObject(event))	
		}
		
		/**
		 * Determines the event's target is valid based on activated state and local mode settings.
		 * @param	event
		 * @return
		 */
		public static function validTarget(event:GWTouchEvent):Boolean {
			activatedTarget(event);
			
			if (event.target is ITouchObject && event.target.activated) {
				
				//local mode filters
				if (event.target.localModes) {
					switch(event.source) {
						case TouchEvent.TOUCH_BEGIN:
							return event.target.nativeTouch;
						case MouseEvent.MOUSE_DOWN:
							return event.target.simulator;
						case TuioEvent.ADD:
							return event.target.tuio;
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
			if (!event.target || (event.target is ITouchObject && event.target.activated)) 
				return;
			event.target = event.target.parent;
			activatedTarget(event);
		}
		
		/**
		 * Convert TouchEvent to GWTouchEvent
		 * @param	event
		 */
		private static function onTouchBegin(e:TouchEvent):void {			
			var event:GWTouchEvent = new GWTouchEvent(e);					
			if(validTarget(event))
				onTouchDown(event);
		}
		
		/**
		 * Decides how to assign the captured touch point to a cluster and pass to parent, an explicit target, an explicit list of 
		 * targets or passed to any touch object in the local display stack.
		 * @param	event
		 * @param	overrideRegisterPoints
		 */
		public static function onTouchDown(event:GWTouchEvent, overrideRegisterPoints:Boolean=false):void
		{
			if (event.target is ITouchObject) { 
											
				if ((ITouchObject(event.target).registerPoints) || overrideRegisterPoints) {
				
					if (duplicateDeviceInput(event)) return;
								
					if (event.target.targetParent && event.target.parent is ITouchObject) { //ASSIGN PRIMARY CLUSTER TO PARENT
							assignPoint(event.target.parent, event);
					}
					else if (event.target.targetObject && event.target.targetObject is ITouchObject)	// ASSIGN PRIMARY CLUSTER TO TARGET
					{							
						assignPoint(event.target.targetObject, event);
						event.target.targetList[j].broadcastTarget = true;
					}
					else if (event.target.targetList[0] is ITouchObject)
					{							
						//ASSIGN THIS TOUCH OBJECT AS PRIMARY CLUSTER
						assignPoint(ITouchObject(event.target), event);
						
						//CREATE SECONDARY CLUSTERS ON TARGET LIST ITEMS
						for (var j:uint = 0; j < event.target.targetList.length; j++) 
						{
							assignPointClone(event.target.targetList[j], event);
							event.target.targetList[j].broadcastTarget = true;
						}
					}
					else {
						 assignPoint(ITouchObject(event.target), event);
						 if(event.target.parent is ITouchObject)
							propagatePoint(ITouchObject(event.target.parent), event);
					}
				}
			}								
		}
		
	/**
		 * Convert TouchEvent to GWTouchEvent
		 * @param	event
		 */
		private static function onTouchEnd(event:TouchEvent):void{
			onTouchUp(new GWTouchEvent(event));
		}		
		
		// stage on TOUCH_UP.
		public static function onTouchUp(event:GWTouchEvent, overrideRegisterPoints:Boolean=false):void
		{
			var pointObject:Object = points[event.touchPointID];
			
			if (pointObject) {
				// allows bindings to work without killing global nativeTouch listeners
				// NOTE: when enabling targeting object will have to be replaced with objectList
				if ((ITouchObject(pointObject.object).registerPoints) || overrideRegisterPoints) { 
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
						if(tO.N == 0) tO.broadcastTarget = false;
						
						////////////////////////////////////////////////////////
						//FORCES IMMEDIATE UPDATE ON TOUCH UP
						//HELPS ENSURE ACCURATE RELEASE STATE FOR SINGLE FINGER SINGLE TAP CAPTURES
						updateTouchObject(tO);
					}
				}
				// DELETE FROM GLOBAL POINT LIST
				delete points[event.touchPointID];
			}
		}
		
		
		/**
		 * Convert TouchEvent to GWTouchEvent
		 * @param	event
		 */
		private static function onMove(event:TouchEvent):void{
			onTouchMove(new GWTouchEvent(event));
		}			
	
		private static var pointObject:PointObject;		
		// the Stage TOUCH_MOVE event.	
		// DRIVES POINT PATH UPDATES
		public static function onTouchMove(event:GWTouchEvent, overrideRegisterPoints:Boolean=false):void
		{	
			//  CONSOLODATED UPDATE METHOD FOR POINT POSITION AND TOUCH OBJECT CALCULATIONS
			pointObject = points[event.touchPointID];
			
			if (pointObject) {
				// allows bindings to work without killing global nativeTouch listeners
				// NOTE: when enabling targeting object will have to be replaced with objectList
				if (pointObject.object["registerPoints"] || overrideRegisterPoints) { 
					// UPDATE POINT POSITIONS
					pointObject.x = event.stageX;					
					pointObject.y = event.stageY;
					pointObject.z = event.stageZ;
					pointObject.moveCount++;
					
					// UPDATE POINT HISTORY 
					// PUSHES NEWEST LOCATION DATA TO POINT PATH/HISTORY
					PointHistories.historyQueue(event);
				}
			}
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
		private static function propagatePoint(target:ITouchObject, event:GWTouchEvent):void {
			if (!target)
				return;
			
			if (target.clusterBubbling) {
				assignPointClone(target, event);
				
				if(target.parent is ITouchObject)
					propagatePoint(ITouchObject(target.parent), event);
			}
		}
		
		/**
		 * Registers assigned touch point globaly and to relevant local clusters 
		 * @param	target
		 * @param	event
		 */
		private static function assignPoint(target:ITouchObject, event:GWTouchEvent):void // asigns point
		{		
			// create new point object
			var pointObject:PointObject  = new PointObject();	
				pointObject.object = DisplayObject(target); // sets primary touch object/cluster
				pointObject.id = target.pointCount; // NEEDED FOR THUMBID
				pointObject.touchPointID = event.touchPointID;
				pointObject.x = event.stageX;
				pointObject.y = event.stageY; 
				pointObject.z = event.stageZ; 
				pointObject.objectList.push(target); // seeds cluster/touch object list
				
				//ADD TO LOCAL POINT LIST
				target.pointArray.push(pointObject);
				
				//UPDATE LOCAL CLUSTER OBJECT
				target.cO.pointArray = target.pointArray;												
				
				// INCREMENT POINT COUTN ON LOCAL TOUCH OBJECT
				target.pointCount++;
				
				// ASSIGN POINT OBJECT WITH GLOBAL POINT LIST DICTIONARY
				GestureGlobals.gw_public::points[event.touchPointID] = pointObject;
				
				if(target.registerPoints)
					registerTouchPoint(event);

				// add touch down to touch object gesture event timeline
				if((target.tiO)&&(target.tiO.timelineOn)&&(target.tiO.pointEvents)) target.tiO.frame.pointEventArray.push(event); /// puts each touchdown event in the timeline event array	

				///////////////////////////////////////////////////////////////////////////////////////
				//CREATE POINT PAIR
				
				/*
				if(target.cO.pointArray.length>1){
				var lastpointID:int = cO.pointArray[cO.pointArray.length - 2].touchPointID;
				var ppt:PointPairObject = new PointPairObject();
					ppt.idA = lastpointID;
					ppt.idB = pointObject.touchPointID;
					
				//cO.pointPairArray.push(ppt);
				
				//trace("pair")
				} */
				
		}	
		
		private static function assignPointClone(target:*, event:GWTouchEvent):void // assigns point copy
		{
				// assign existing point object
				var pointObject:PointObject = GestureGlobals.gw_public::points[event.touchPointID]
					// add this touch object to touchobject list on point
					pointObject.touchPointID = event.touchPointID;//-??
					pointObject.objectList.push(target);  ////////////////////////////////////////////////NEED TO COME UP WITH METHOD TO REMOVE TOUCH OBJECT THAT ARE NOT LONGER ON STAGE
	
				//ADD TO LOCAL POINT LIST
				target.pointArray.push(pointObject);
				
				//UPDATE LOCAL CLUSTER OBJECT
				//touch object point list and cluster point list should be consolodated
				target.cO.pointArray = target.pointArray;
				
				//create point pair
				/*
				if(target.cO.pointArray.length!=1){
				var lastpointID:Number = target.cO.pointArray[target.cO.pointArray.length - 2].touchPointID;
				var ppt:PointPairObject = new PointPairObject();
					ppt.idA = lastpointID;
					ppt.idB = pointObject.touchPointID;
					
				//cO.pointPairArray.push(ppt);
				//trace("Clone pair");
				}*/
				
				//UPDATE POINT LOCAL COUNT
				target.pointCount++;
				
				// add touch down to touch object gesture event timeline
				if ((target.tiO)&&(target.tiO.timelineOn) && (target.tiO.pointEvents)) target.tiO.frame.pointEventArray.push(event); /// puts each touchdown event in the timeline event array
				
				//trace("ts clone bubble target, point array length",pointArray.length, pointObject.touchPointID, pointObject.objectList.length, this);
		}	
		
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
		
		// UPDATE ALL TOUCH OBJECTS IN DISPLAY LIST
		public static function touchFrameHandler(event:GWEvent):void
		{
			//trace("touch frame process ----------------------------------------------");	
			
			//INCREMENT TOUCH FRAME id
			GestureGlobals.frameID += 1;
			
			/////////////////////////////////////////////////////////////////////////////
			//GET MOTION POINT LIST
			gms = GestureGlobals.gw_public::touchObjects[GestureGlobals.motionSpriteID];
			
			//TRACK INTERACTIONS POINTS AND INTERACTION EVENTS
			//InteractionPointTracker.framePoints = gms.cO.iPointArray;
			InteractionPointTracker.getActivePoints();

			// update all touch objects in display list
			for each(var tO:Object in touchObjects)
			{
				//trace("tm touchobject",tO);
				////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
				//PULL MOTION POINT DATA INTO EACH TOUCHOBJECT
				//COULD BE JUST INTERACTION POINT DATA ??
				// BUT NEEDS TO LOCALLY DETERMIN PICH HIT TEST
				// PERHAPS A INTERACTION POINT CADIDATE LIST THEN PERFORM HIT LOCAL TO THE TOUCHOBJECT
				
				//GET GLOBAL MOTION POINTS
				tO.cO.motionArray = gms.cO.motionArray/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
				
				// update touch,cluster and gesture processing
				updateTouchObject(ITouchObject(tO));
				
				// DISTRO HAND MODEL AND INTERACTION POINTS TO TOUCH OBJECTS
				tO.cO.handList = gms.cO.handList;///////////////////////////////////////////////////////////////////////////////////////////////////////
				tO.cO.iPointArray = gms.cO.iPointArray//////////////////////////////////////////////////////////////////////////////////////////////////
				
				
				//UPDATE CLUSTER HISTORIES
				// moved to touch object
				//ClusterHistories.historyQueue(tO.touchObjectID);
					
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
				
				
				// clear frame 
				// was just pushing events and never clearing object 
				if(tO.tiO) tO.tiO.frame = new FrameObject();
			}
			
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
				if (tO.tpn!=0) {
					for (var i:int = 0; i < tO.tpn; i++) {
						if (points[tO.pointArray[i].touchPointID] == undefined) {
						
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