////////////////////////////////////////////////////////////////////////////////
//
//  IDEUM
//  Copyright 2011-2012 Ideum
//  All Rights Reserved.
//
//  GestureWorks
//
//  File:    MotionManager.as
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
	import com.gestureworks.core.TouchMovieClip;
	import com.gestureworks.core.TouchSprite;
	import com.gestureworks.core.TouchCluster;
	import com.gestureworks.core.TouchGesture;
	import com.gestureworks.core.TouchPipeline;
	import com.gestureworks.core.TouchTransform;
	import com.gestureworks.core.TouchVisualizer;
	
	import com.gestureworks.events.GWInteractionEvent;
	import com.gestureworks.events.GWEvent;
	import com.gestureworks.events.GWGestureEvent;
	import com.gestureworks.events.GWTouchEvent;
	
	import com.gestureworks.interfaces.ITouchObject3D;
	import com.gestureworks.interfaces.ITouchObject;
	import com.gestureworks.utils.GestureParser;
	
	import com.gestureworks.managers.TouchPointHistories;
	import com.gestureworks.managers.InteractionPointTracker;
	
	import com.gestureworks.objects.InteractionPointObject;
	import com.gestureworks.objects.ClusterObject;
	import com.gestureworks.objects.FrameObject;
	import com.gestureworks.objects.GestureListObject;
	import com.gestureworks.objects.TouchPointObject;
	import com.gestureworks.objects.StrokeObject;
	import com.gestureworks.objects.TimelineObject;
	import com.gestureworks.objects.TransformObject;
	
	
	import flash.utils.Dictionary;
	import images.GWSplash;
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.events.TouchEvent;
	import flash.utils.Dictionary;
	import org.tuio.TuioEvent;
	import flash.geom.Vector3D;
	
 	
	
	
		
	public class InteractionManager 
	{	
		//public static var touchPoints:Dictionary = new Dictionary();
		public static var ipoints:Dictionary = new Dictionary();
		public static var touchObjects:Dictionary = new Dictionary();
		private static var virtualTransformObjects:Dictionary = new Dictionary();
		
		
		private static var gs:TouchSprite;
		private static var interaction_init:Boolean = false;
		
		private static var sw:int;
		private static var sh:int;
		
		private static var hooks:Vector.<Function>;
		private static var _overlays:Vector.<ITouchObject> = new Vector.<ITouchObject>();
		
		private static var minX:Number
		private static var maxX:Number
		private static var minY:Number
		private static var maxY:Number
		private static var minZ:Number
		private static var maxZ:Number
		
		public static var hitTest3D:Function;
		
		gw_public static function initialize():void

		{
			if (!interaction_init)
			{
			trace("interaction manager init");
			///////////////////////////////////////////////////////////////////////////////////////
			// ref gloabl motion point list
			//touchPoints = GestureGlobals.gw_public::touchPoints;
			ipoints = GestureGlobals.gw_public::interactionPoints;
			touchObjects = GestureGlobals.gw_public::touchObjects;
			
			// init interaction point manager
			InteractionPointTracker.initialize();
			
			//if (GestureWorks.activeMotion) 
			//gms = GestureGlobals.gw_public::touchObjects[GestureGlobals.motionSpriteID];
			//if (GestureWorks.activeTouch)
			gs = GestureGlobals.gw_public::touchObjects[GestureGlobals.globalSpriteID];
			//if (GestureWorks.activeSensor)
			//gss = GestureGlobals.gw_public::touchObjects[GestureGlobals.sensorSpriteID];
			
			sw = GestureWorks.application.stageWidth
			sh = GestureWorks.application.stageHeight;
			
			minX = GestureGlobals.gw_public::leapMinX;
			maxX = GestureGlobals.gw_public::leapMaxX;
			minY = GestureGlobals.gw_public::leapMinY;
			maxY = GestureGlobals.gw_public::leapMaxY;
			minZ = GestureGlobals.gw_public::leapMinZ;
			maxZ = GestureGlobals.gw_public::leapMaxZ;

			/////////////////////////////////////////////////////////////////////////////////////////
			//DRIVES UPDATES ON POINT LIFETIME
			//GestureWorks.application.addEventListener(GWInteractionEvent.INTERACTION_END, onInteractionEnd);
			//GestureWorks.application.addEventListener(GWInteractionEvent.INTERACTION_BEGIN, onInteractionBegin);
			//GestureWorks.application.addEventListener(GWInteractionEvent.INTERACTION_UPDATE, onInteractionUpdate);
			
			///////////////////////////////////////////////////////////////////////////////////////////////////////////////
			// leave this on for all input types
			GestureWorks.application.addEventListener(GWEvent.ENTER_FRAME, interactionFrameHandler); //MOVE TO INTERACTION MANAGER
		
			interaction_init = true;
			}
		}
		
		gw_public static function deInitialize():void
		{
			//GestureWorks.application.removeEventListener(GWInteractionEvent.INTERACTION_END, onInteractionEnd);
			//GestureWorks.application.removeEventListener(GWInteractionEvent.INTERACTION_BEGIN, onInteractionBegin);
			//GestureWorks.application.removeEventListener(GWInteractionEvent.INTERACTION_UPDATE, onInteractionUpdate);
		}

		
		
		// registers touch point via touchSprite
		public static function registerInteractionPoint(ipo:InteractionPointObject):void
		{
			ipo.history.unshift(InteractionPointHistories.historyObject(ipo))
		}
		
		
		public static function onInteractionBegin(event:GWInteractionEvent):void
		{			
			//trace("interaction point begin, interactionManager",event.value.interactionPointID);
			//trace("event mode",event.value.mode )

				// DUPE CORE IP LIST FOR NOW
				// create new interaction point clone for each interactive display object 
				var ipO:InteractionPointObject  = new InteractionPointObject();	
				
						// need to make it modaly invariant
						ipO.id = gs.interactionPointCount; // NEEDED FOR THUMBID
						ipO.interactionPointID = event.value.interactionPointID;
						ipO.handID = event.value.handID;
						ipO.type = event.value.type;
						ipO.mode = event.value.mode;
						
						ipO.position = event.value.position;
						ipO.direction = event.value.direction;
						ipO.normal = event.value.normal;
						ipO.velocity = event.value.velocity;

						
						ipO.radius = event.value.radius;
						ipO.length = event.value.length;
						ipO.width = event.value.width;
						
						//ADVANCED IP PROEPRTIES
						ipO.flatness = event.value.flatness;
						ipO.orientation = event.value.orientation;
						ipO.fn = event.value.fn;
						ipO.splay = event.value.splay;
						ipO.fist = event.value.fist;
						
						ipO.phase = "begin"
						//trace(ipO.interactionPointID)
						
				////////////////////////////////////////////
				//ADD TO GLOBAL Interaction POINT LIST
				gs.cO.iPointArray.push(ipO);
				////////////////////////////////////////////
				
				//trace("ip begin",ipO.type)
				// update local touch object point count
				gs.interactionPointCount++;
				//gms.interactionPointCount++;

				///////////////////////////////////////////////////////////////////////////
				// ASSIGN POINT OBJECT WITH GLOBAL POINT LIST DICTIONARY
				GestureGlobals.gw_public::interactionPoints[event.value.interactionPointID] = ipO;
					
				////////////////////////////////////////////////////////////////////////////
				// REGISTER TOUCH POINT WITH TOUCH MANAGER
				registerInteractionPoint(ipO);
			//}
			
			//trace("gms ipointArray length",gms.cO.iPointArray.length,ipO.position )
		}
		
		
		// stage motion end
		public static function onInteractionEnd(event:GWInteractionEvent):void
		{
			var iPID:int = event.value.interactionPointID;
			var ipointObject:InteractionPointObject = ipoints[iPID];
			//trace("Motion point End, motionManager", iPID)
			
			if (ipointObject)
			{
				ipointObject.phase="end"
				
					// REMOVE POINT FROM GLOBAL LIST
					gs.cO.iPointArray.splice(ipointObject.id, 1);
					
						//LOCAL OBJECTES REMOVE POINTS BASED ON ClUSTERING METHODS
						//SEE KINEMETRIC
					
					// REDUCE GLOBAL INTERACTION POINT COUNT
					//gms.interactionPointCount--;
					gs.interactionPointCount--;
					
					// UPDATE INTERACTION POINT ID 
					for (var i:int = 0; i < gs.cO.iPointArray.length; i++)//gms.cO.iPointArray.length
					{
						//gms.cO.iPointArray[i].id = i;
						gs.cO.iPointArray[i].id = i;
					}
				
					// DELETE FROM UNIQUE GLOBAL INPUT POINT LIST
					delete ipoints[event.value.interactionPointID];
			}
			//trace("interaction point end",gms.interactionPointCount)
		}
		
	
		// the Stage TOUCH_MOVE event.	// DRIVES POINT PATH UPDATES
		public static function onInteractionUpdate(event:GWInteractionEvent):void
		{			
			//  CONSOLODATED UPDATE METHOD FOR POINT POSITION AND TOUCH OBJECT CALCULATIONS
			var ipO:InteractionPointObject = ipoints[event.value.interactionPointID];
			
			//trace("interaction move event, interactionsManager", event.value.interactionPointID);
			
				if (ipO)
				{	
					//mpO = event.value;
					ipO.interactionPointID  = event.value.interactionPointID;
					ipO.mode = event.value.mode;
					ipO.position = event.value.position;
					ipO.direction = event.value.direction;
					ipO.normal = event.value.normal;
					ipO.velocity = event.value.velocity;
					
					ipO.radius = event.value.radius
					ipO.length = event.value.length;
					ipO.width = event.value.width;
					
					ipO.flatness = event.value.flatness;
					ipO.orientation = event.value.orientation;
					ipO.fn = event.value.fn;
					ipO.splay = event.value.splay;
					ipO.fist = event.value.fist;
					
					ipO.phase = "update"
					//mpO.handID = event.value.handID;
					//ipO.moveCount ++;
					
					//trace("gms ipointArray length",gms.cO.iPointArray.length,ipO.position )
				}
				

				// UPDATE POINT HISTORY 
				InteractionPointHistories.historyQueue(event);
		}	
	
		///////////////////////////////////////////////////////////////////////////////////////
		///////////////////////////////////////////////////////////////////////////////////////
		
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

		///////////////////////////////////////////////////////////////////////////////////////
		///////////////////////////////////////////////////////////////////////////////////////
		
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
		 * Assign interaction points to parent's with cluster bubbling enabled.
		 * @param	target
		 * @param	event
		 */
		private static function propagateInteractionPoint(ipt:InteractionPointObject, ts:Object):void {
			
			trace("propgate interaction");
			if ((ts.parent) && (ts.parent  is ITouchObject))
			{
				if (ts.parent.interactionPointBubbling)
				{
					//PUSH INTERACTION POINT TO PARENT
					ts.parent.cO.iPointArray.push(ipt);
						
					//INIT PUSH OF INTERACTION POINT TO GRANDPARENT
					if  (ts.parent.parent is ITouchObject)propagateInteractionPoint(ipt,ts.parent);
					//else if (ts.targetParent) ts.parent.cO.iPointArray.push(ipt);
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
				//target.pointArray.push(pointObject);
				
				//UPDATE LOCAL CLUSTER OBJECT
				//target.cO.pointArray = target.pointArray;	
				
				target.cO.touchArray.push(pointObject);
				
				// INCREMENT POINT COUTN ON LOCAL TOUCH OBJECT
				target.touchPointCount++;
				
				// ASSIGN POINT OBJECT WITH GLOBAL POINT LIST DICTIONARY
				GestureGlobals.gw_public::points[event.touchPointID] = pointObject;
				
				//MAY NEED TO REGISTER IP
				//if(target.registerPoints)
					//registerTouchPoint(event);

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
			//target.pointArray.push(pointObject);
			
			//UPDATE LOCAL CLUSTER OBJECT
			//touch object point list and cluster point list should be consolodated
			//target.cO.pointArray = target.pointArray;
			
					target.cO.touchArray.push(pointObject);
			
			//UPDATE POINT LOCAL COUNT
			target.touchPointCount++;
			
			// add touch down to touch object gesture event timeline
			if ((target.tiO)&&(target.tiO.timelineOn) && (target.tiO.pointEvents)) target.tiO.frame.pointEventArray.push(event); /// puts each touchdown event in the timeline event array
			
			//trace("ts clone bubble target, point array length",pointArray.length, pointObject.touchPointID, pointObject.objectList.length, this);
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
					//TODO: FX ref
					//else
						//onTouchDown(e);
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
			
			//trace("activated target",event.target)
			
			if (!event.target || (event.target is ITouchObject && event.target.active)) 
				return;
			else if (virtualTransformObjects[event.target])
				event.target = virtualTransformObjects[event.target];
			else
				event.target = event.target.parent;
			activatedTarget(event);
		}
		
		///////////////////////////////////////////////////////////////////////////////////////////////////////
		///////////////////////////////////////////////////////////////////////////////////////////////////////
		
		
		
		private static function normalize(value : Number, minimum : Number, maximum : Number) : Number {

                        return (value - minimum) / (maximum - minimum);
         }
		 
		 
		 ///////////////////////////////////////////////////////////////////
		///////////////////////////////////////////////////////////////////
		// MOVE ALL TO INTERACTION MANAGER
		///////////////////////////////////////////////////////////////////
		///////////////////////////////////////////////////////////////////
			
		public static function preinitBase(obj:ITouchObject):void 
        {
			//trace("create touchsprite base", obj.debugDisplay); 
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
			//trace("init base", obj)
							obj.tc = new TouchCluster(obj.touchObjectID); 
							obj.tp = new TouchPipeline(obj.touchObjectID);
		if (obj.gestureEvents)	obj.tg = new TouchGesture(obj.touchObjectID);
							obj.tt = new TouchTransform(obj.touchObjectID);
							obj.visualizer = new TouchVisualizer(obj.touchObjectID);
		}	
		
		public static function callLocalGestureParser(obj:ITouchObject):void
		{
			//trace("call local parser touch sprite",obj );
			
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
			//trace("begin main processing loop", obj.tpn, obj.ipn, obj.tc.core,gts.touchPointCount, gts.cO.pointArray.length,gts.cO.iPointArray.length,"id", obj.touchObjectID, gts.touchObjectID,gms.touchObjectID);
			// MAIN GESTURE PROCESSING LOOP/////////////////////////////////
			
				if (obj.tc) obj.tc.updateClusterAnalysis();
				if (obj.tp) obj.tp.processPipeline();
				if (obj.tg) obj.tg.manageGestureEventDispatch();
				if (obj.tt){
					obj.tt.transformManager();
					obj.tt.updateLocalProperties();
				}
				
				ClusterHistories.historyQueue(obj.touchObjectID);
				//trace("end main processing loop", obj.tpn, obj.ipn, obj.tc.core, gts.touchPointCount, gts.cO.pointArray.length,gts.cO.iPointArray.length,"id", obj.touchObjectID, gts.touchObjectID,gms.touchObjectID);
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
		
		public static function interactionFrameHandler(event:GWEvent):void
		{
		//	trace("touch frame process ----------------------------------------------",gs.touchPointCount, gs.cO.touchArray.length,gs.cO.iPointArray.length);	
			
			//INCREMENT TOUCH FRAME id
			GestureGlobals.frameID += 1;
			
			//trace(GestureGlobals.frameID)
			/////////////////////////////////////////////////////////////////////////////
			
			if (GestureWorks.activeTouch)
			{
				// GET TOUCH PREMETRICS
				gs.tc.initGeoMetric2D();
				gs.tc.getGeoMetrics2D(); 
			}
			
			if (GestureWorks.activeSensor)
			{
				//GET SENSOR PREMETRICS
				//getSensorMetrics();
			}
			
			//GET MOTION POINT LIST
			if (GestureWorks.activeMotion)
			{
				// GET PREMETRICS
				if (GestureGlobals.frameID == 200) gs.tc.initGeoMetric3D();// TODO:MUST CHNAGE TO INIT ONCE GML IS FULLY PARSED // ON ALL OBJECTS
				gs.tc.getSkeletalMetrics3D();
				gs.tc.getGeoMetrics3D();
			}
			
			
			////////////////////////////////////////////////////////////////////////////
			// DEPTH SORTING
			////////////////////////////////////////////////////////////////////////////
			var temp_tOList:Array = new Array();//= touchObjects;

			for each(var itO:Object in touchObjects)
			{
				if (!itO.tc.core)
				{
				//trace("index", itO.index, itO.name);
				
					if (itO.parent) 
					{
						itO.index = itO.parent.getChildIndex(itO);
						temp_tOList.push(itO);
					}
				}
				//if (itO is ITouchObject) trace(itO.index)
			}
			//temp_tOList.sortOn("index", [Array.NUMERIC]);//Array.NUMERIC
			
			temp_tOList.reverse(); //DOES WORK
			
			/*
			//TEST TRACE
			for (var i:int = 0; i < temp_tOList.length; i++) 
			{
				trace("TEMP INDEX", temp_tOList[i].index);
			}
			*/
			///////////////////////////////////////////////////////////////////////////
			
			
			
			/////////////////////////////////////////////////////////////////////////////
			// HIT SEQUENCE TESTING
			
			
			/*
			// LOOP THROUGH TOUCH OBJECTS 
			//THEN HAVE EACH LOOP THROUGH GLOBAL IP LIST
			for (var i:int = 0; i < temp_tOList.length; i++) 
			{
				//temp_tOList[i].tc.clusterHitTest();
				hitTestCluster(temp_tOList[i]);
			}
			*/
			
			// LOOP THROUGH GLOABL IP LIST
			// THEN LOOP THROUGH TOUCH OBJECTS
			if (gs)
			{
				//SELECTIVELY ADD IPOINTS TO TOUCH OBJETCS
				for (var k:uint = 0; k < gs.cO.iPointArray.length; k++)
				{
					hitTestClusterADD(gs.cO.iPointArray[k],temp_tOList);
				}
				
				//ADD GLOBAL POINTS
				for (var k:uint = 0; k < gs.cO.iPointArray.length; k++)
				{
					hitTestClusterADDGLOBAL(gs.cO.iPointArray[k],temp_tOList);
				}
				
				
				//REMOVE POINTS
				for (var j:uint = 0; j < temp_tOList.length; j++) 
				{	
					hitTestCluster2remove(temp_tOList[j]);
				}
				
			}
			
			
	
			// update all touch objects in display list
			//for each(var tO:Object in touchObjects)//
			for (var i:int = 0; i < temp_tOList.length; i++) 
			{
				//var tO:ITouchObject = temp_tOList[i];
				var tO:Object = temp_tOList[i];
				
				//trace("index", tO.getChildIndex());
				
				if (tO.cO)
				{
					////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
					//PULL TOUCH POINT DATA INTO EACH TOUCHOBJECT //GET GLOBAL TOUCH POINTS		
					if ((GestureWorks.activeNativeTouch) && (tO.touchEnabled) && (!tO.tc.core)) tO.cO.touchArray = gs.cO.touchArray;
					////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
					//PULL MOTION POINT DATA INTO EACH TOUCHOBJECT //GET GLOBAL MOTION POINTS		
					if ((GestureWorks.activeMotion) && (tO.motionEnabled) && (!tO.tc.core))
					{
							if (GestureGlobals.frameID == 200) 
							{
								tO.tc.initIPSupport();
								tO.tc.initIPFilters(); //CHECK
							}
							tO.cO.motionArray = gs.cO.motionArray
							tO.cO.handList = gs.cO.handList;
					}
					////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
					//PULL SENSOR POINT DATA INTO EACH TOUCHOBJECT //GET GLOBAL SENSOR POINTS //GLOBAL PUSH TO ALL SENSOR ENABLED VIOs
					if ((GestureWorks.activeSensor) && (tO.sensorEnabled) && (!tO.tc.core)) tO.cO.sensorArray = gs.cO.sensorArray
				}
				else 
					continue;
					
					
				///////////////////////////////////////////////////////////////////////
				//LOOPS THROUGH GS IP POINT ARRAY AND PERFROMS HIT TEST ON TOUCHOBJECT
				// SHOULD TAKE POINT AND LOOK THROUGH TOUCHOBJECTS INSTEAD
				//tO.tc.clusterHitTest();
				///////////////////////////////////////////////////////////////////////
				
				///////////////////////////////////////////////////////////////////////
				// update touch,cluster and gesture processing
				updateTouchObject(ITouchObject(tO));
				///////////////////////////////////////////////////////////////////////

				// move to timeline visualizer
				// CURRENTLY NO GESTURE OR CLUSTER ANALYSIS REQURES
				// DIRECT CLUSTER OR TRANSFROM HISTORY, USED IN DEBUG ONLY
				if ((tO.visualizer)&&(tO.visualizer.debug_display)&& (!tO.tc.core))
				{
					//UPDATE TRANSFORM HISTORIES
					TransformHistories.historyQueue(tO.touchObjectID);
					
					// update touch object debugger display
					tO.updateDebugDisplay();
					//trace("update display");
				}
			}
			
			
			
			//TRACK INTERACTIONS POINTS AND INTERACTION EVENTS
			// update interation point global list
			InteractionPointTracker.getActivePoints();
			
			// zero motion frame count
			GestureGlobals.motionFrameID = 1;
			//trace(GestureGlobals.motionframeID)
			
			
			//KILL POINTS THAT DONE REMOVE AUTOMATICALLY
			//killZombies(ITouchObject(tO));
			
			
			
		}
		
		/*
		public static function killZombies(tO:ITouchObject):void
		{
			
				// check for erroneous points
				// kill after processing (just in case)
				if (tO.tpn != 0) {
					
					//trace("kill length",tO.tpn,tO.pointArray.length)
					
					for (var i:int = 0; i < tO.pointArray.length; i++) {//tO.tpn
						if (touchPoints[tO.pointArray[i].touchPointID] == undefined) {

							tO.cO.pointArray.length = 0; // best way to kill
							return
						}
					}
				}
		}*/
		
		
		// EXTERNAL UPDATE METHOD/////////////////////////////////////////////////////////
		public static function updateTouchObject(tO:ITouchObject):void
		{
				//trace("updating touch object", tO, tO.N, tO.tc.core);
				// THERFOR CLUSTER ANALYSIS IS N SPECICIFC AND SELF MAMANGED SWITCHING
				// PIPELINE PROCESSING IS GESTURE OBJECT STATE DEPENDANT AND NOT N DEPENDANT
				
				updateTObjProcessing(tO);
				//trace(tO.touchObjectID)
				
				/*
				// check for erroneous points
				// kill after processing (just in case)
				if (tO.tpn != 0) {
					
					trace("kill length",tO.tpn,tO.pointArray.length)
					
					for (var i:int = 0; i < tO.pointArray.length; i++) {//tO.tpn
						if (touchPoints[tO.pointArray[i].touchPointID] == undefined) {

							tO.cO.pointArray.length = 0; // best way to kill
							return
						}
					}
				}*/
		}
		
		
		public static function hitTestCluster(ts:Object):void
			{
				//ONLY DOES HIT TEST IF MOTION OR TOUCH POINTS EXIST
				//TODO: SIMPLIFY LOGIC FOR MUTLIMODAL CLUSTERING OPTIONS
				if ((gs))//&&(ts.mpn)
				{
				//trace("hit test ip cluster",gms.cO.iPointArray.length,ts.motionClusterMode,ts)

					///////////////////////////////////////////////////////////////////////////////////////////////////////////////
					// touch cluster hit test
					///////////////////////////////////////////////////////////////////////////////////////////////////////////////
					if (ts.touchEnabled)
					{
					//trace("touch ",ts.touchClusterMode, "cO ip",ts.cO.iPointArray.length, "tcO ip:",ts.cO.tcO.iPointArray.length,"gs touch", gs.cO.touchArray.length, "gs ip", gs.cO.iPointArray.length);	
						///////////////////////////////////////////////////////////////////////////////////
						// SCAN GLOBAL SPRITE FOR INTERACTION POINTS
						///////////////////////////////////////////////////////////////////////////////////
						for (var i:uint = 0; i < gs.cO.iPointArray.length; i++)
							{
								var ipt:InteractionPointObject = gs.cO.iPointArray[i];
								trace("hit testing ips")
								
								//FILTER BY MODE
								if ((ipt)&&(ipt.mode=="touch"))//&&(ts.tc.ipSupported(ipt.type))
								{
									//trace(ts,gms);
									//var xh:Number = normalize(ipt.position.x, minX, maxX) *sw;//1920
									//var yh:Number = normalize(ipt.position.y, minY, maxY) * sh//ts.stage.stageHeight//1080;// ;
									//trace("ht",ts.motionClusterMode)

									if ((ts.touchClusterMode == "local_strong")&&(ipt.phase=="begin")) 
									{
										if (ts is ITouchObject)//((ts is TouchSprite)||(ts is TouchMovieClip))
										{
											if (ts.hitTestPoint(ipt.position.x, ipt.position.y, true)) {
											if (!ts.mouseChildren) ts.cO.iPointArray.push(ipt);
											}
										}
										if (ts is ITouchObject3D)//TouchObject3D
										{
											if (hitTest3D != null) {
												if (hitTest3D(ts as ITouchObject3D, ipt.position.x, ipt.position.y)) ts.cO.iPointArray.push(ipt);
											}
										}
									}
									else if ((ts.touchClusterMode == "local_weak")&&((ipt.phase=="update")||(ipt.phase=="begin")))//reduced redundant hit testing
									{
										if (ts is ITouchObject)//((ts is TouchSprite)||(ts is TouchMovieClip))
										{
											//trace("2d hit test");
											if (ts.hitTestPoint(ipt.position.x, ipt.position.y, true))
											{
												// CHECK TO SEE IF ALREADY ADDED
												var match:Boolean = false;
												for (var b:uint = 0; b < ts.cO.iPointArray.length; b++)
												{
													if (ts.cO.iPointArray[b].interactionPointID == ipt.interactionPointID) match = true;
												}
												if ((!match)&&(!ts.mouseChildren) ) ts.cO.iPointArray.push(ipt);
											}
										}
										if (ts is ITouchObject3D)//TouchObject3D
										{
											//trace("3d hit test", ts.vto, ts.vto.parent, ts.vto.parent.scene, ts.view, TouchManager3D.hitTest3D(ts as TouchObject3D,ts.view, xh, yh));
											//trace("3d hit test", TouchManager3D.hitTest3D(ts as TouchObject3D, ipt.position.x, ipt.position.y));
											
											if (hitTest3D != null) {
												if (hitTest3D(ts as ITouchObject3D, ipt.position.x, ipt.position.y)) ts.cO.iPointArray.push(ipt);
											}
										}
									} 
									else if ((ts.touchClusterMode == "global")&&(ipt.phase=="begin")) 
									{
										if (!ts.mouseChildren) ts.cO.iPointArray.push(ipt);
									}
								}
							}
						//////////////////////////////////////////////////////////////////////////////////////
						// REMOVING INTERACTION POINTS FROM LOCAL LIST
						//////////////////////////////////////////////////////////////////////////////////////
						if (ts.cO.iPointArray.length)
						{
						//trace("strong length", ts.cO.iPointArray.length);
						for (i = 0; i < ts.cO.iPointArray.length; i++)
							{
								var k_pt:InteractionPointObject = ts.cO.iPointArray[i];
								
								if (k_pt)
								{
									if (k_pt.mode == "touch")
									{
										//trace(ts.cO.iPointArray[i].interactionPointID,ts.cO.iPointArray[i].phase);
										if (k_pt.phase == "end") ts.cO.iPointArray.splice(i, 1);
										
										else if ((k_pt.phase == "update")&&(ts.touchClusterMode == "local_weak"))
										{
											if (!ts.hitTestPoint(k_pt.position.x, k_pt.position.y, false)) ts.cO.iPointArray.splice(i, 1);
										}
									}
								}
							}
						}
						
						
						
					}
	
				}
			}

			
			
			
			public static function hitTestClusterADD(ipt:InteractionPointObject,temp_tOList:Array):void
			{
				///////////////////////////////////////////////////////////////////////////////////////////////////////////////
				// touch cluster hit test
				///////////////////////////////////////////////////////////////////////////////////////////////////////////////
				for (var i:int = 0; i < temp_tOList.length; i++) 
				{
					var ts = temp_tOList[i];
					
					if (ts.touchEnabled)
					{
								if ((ipt)&&(ipt.mode=="touch"))//&&(ts.tc.ipSupported(ipt.type))
								{
									//INDEX AND INTERACTIOPN POINT CHILDREN INDEPENDANT
									//if ((ts.touchClusterMode == "global")&&(ipt.phase=="begin")) ts.cO.iPointArray.push(ipt);
									
									//INDEX AND MOUSE CHILDREN DEPENDANT
									if (((ts.touchClusterMode == "local_strong")&&(ipt.phase=="begin"))||((ts.touchClusterMode == "local_weak")&&(ipt.phase=="begin"))) 
									{
										if (ts is ITouchObject)
										{
											if ((ts.hitTestPoint(ipt.position.x, ipt.position.y, true))&&((!ts.mouseChildren)||(!ts.interactionPointChildren)))
											{
												ts.cO.iPointArray.push(ipt);
												propagateInteractionPoint(ipt, ts);
												return;
											}
										}
										else if (ts is ITouchObject3D)
										{
											if (hitTest3D != null) {
												if ((hitTest3D(ts as ITouchObject3D, ipt.position.x, ipt.position.y))&&((!ts.mouseChildren)||(!ts.interactionPointChildren)))
												{ 
													ts.cO.iPointArray.push(ipt);
													propagateInteractionPoint(ipt, ts);
													return;
												}
											}
										}
									}
									// DISPLAY INDEX VALUE DOES NOT DETERMIN WEAK LOCAL CLUSTERING (FFEATURE)
									else if ((ts.touchClusterMode == "local_weak")&&(ipt.phase=="update"))
									{
										if (ts is ITouchObject)
										{
											if ((ts.hitTestPoint(ipt.position.x, ipt.position.y, true))&&((!ts.mouseChildren)||(!ts.interactionPointChildren)))
											{
												// CHECK TO SEE IF ALREADY ADDED
												var match:Boolean = false;
												for (var b:uint = 0; b < ts.cO.iPointArray.length; b++)
												{
													if (ts.cO.iPointArray[b].interactionPointID == ipt.interactionPointID) match = true;
												}
												if (!match)
												{
													ts.cO.iPointArray.push(ipt);
													propagateInteractionPoint(ipt, ts);
												}
											}
										}
									}
									else if (ts is ITouchObject3D)
									{
											if (hitTest3D != null){
												if ((hitTest3D(ts as ITouchObject3D, ipt.position.x, ipt.position.y))&&((!ts.mouseChildren)||(!ts.interactionPointChildren)))
												{	
													var match:Boolean = false;
													for (var b:uint = 0; b < ts.cO.iPointArray.length; b++)
													{
														if (ts.cO.iPointArray[b].interactionPointID == ipt.interactionPointID) match = true;
													}
													if (!match) {
														ts.cO.iPointArray.push(ipt);
														propagateInteractionPoint(ipt, ts);
													}
												}
											}
									}
								} 
								
								
								
								
								
								
								
								
									
						}
					}
			}
			
			
			public static function hitTestClusterADDGLOBAL(ipt:InteractionPointObject,temp_tOList:Array):void
			{
				///////////////////////////////////////////////////////////////////////////////////////////////////////////////
				// touch cluster hit test
				///////////////////////////////////////////////////////////////////////////////////////////////////////////////
				for (var i:int = 0; i < temp_tOList.length; i++) 
				{
					var ts = temp_tOList[i];

					//TOUCH
					if ((ts.touchEnabled)&&(ipt)&&(ipt.mode=="touch"))//&&(ts.tc.ipSupported(ipt.type))
					{
						if ((ts.touchClusterMode == "global")&&(ipt.phase=="begin")) ts.cO.iPointArray.push(ipt);
					}
					/*
					//MOTION
					else if ((ts.motionEnabled)&&(ipt)&&(ipt.mode=="motion"))//&&(ts.tc.ipSupported(ipt.type))
					{
						if ((ts.motionClusterMode == "global")&&(ipt.phase=="begin")) ts.cO.iPointArray.push(ipt);
					}
					//SENSOR
					else if ((ts.sensorEnabled)&&(ipt)&&(ipt.mode=="sensor"))//&&(ts.tc.ipSupported(ipt.type))
					{
						if ((ts.sensorClusterMode == "global")&&(ipt.phase=="begin")) ts.cO.iPointArray.push(ipt);
					}*/
				}
			}
			
			
			public static function hitTestCluster2remove(ts:Object):void
			{
				
						//////////////////////////////////////////////////////////////////////////////////////
						// REMOVING INTERACTION POINTS FROM LOCAL LIST
						//////////////////////////////////////////////////////////////////////////////////////
						if (ts.cO.iPointArray.length)
						{
						for (var i:uint = 0; i < ts.cO.iPointArray.length; i++)
							{
								var k_pt:InteractionPointObject = ts.cO.iPointArray[i];
								
								if (k_pt)
								{
									//TOUCH
									if ((ts.touchEnabled)&&(k_pt.mode == "touch"))
									{
										//trace(ts.cO.iPointArray[i].interactionPointID,ts.cO.iPointArray[i].phase);
										if (k_pt.phase == "end") ts.cO.iPointArray.splice(i, 1);
										
										else if ((k_pt.phase == "update")&&(ts.touchClusterMode == "local_weak"))
										{
											if ((!ts.hitTestPoint(k_pt.position.x, k_pt.position.y, false))&&(!ts.mouseChildren)) ts.cO.iPointArray.splice(i, 1);
										}
									}
									//MOTION
									if ((ts.motionEnabled)&&(k_pt.mode == "motion"))
									{
										//trace(ts.cO.iPointArray[i].interactionPointID,ts.cO.iPointArray[i].phase);
										if (k_pt.phase == "end") ts.cO.iPointArray.splice(i, 1);
										
										else if ((k_pt.phase == "update")&&(ts.motionClusterMode == "local_weak"))
										{
											if ((!ts.hitTestPoint(k_pt.position.x, k_pt.position.y, false))&&(!ts.mouseChildren)) ts.cO.iPointArray.splice(i, 1);
										}
									}
									//SENSOR
									if ((ts.sensorEnabled)&&(k_pt.mode == "sensor"))
									{
										//trace(ts.cO.iPointArray[i].interactionPointID,ts.cO.iPointArray[i].phase);
										if (k_pt.phase == "end") ts.cO.iPointArray.splice(i, 1);
										
										else if ((k_pt.phase == "update")&&(ts.sensorClusterMode == "local_weak"))
										{
											if ((!ts.hitTestPoint(k_pt.position.x, k_pt.position.y, false))&&(!ts.mouseChildren)) ts.cO.iPointArray.splice(i, 1);
										}
									}
								}
							}
						}
			}
		
		
	}
}