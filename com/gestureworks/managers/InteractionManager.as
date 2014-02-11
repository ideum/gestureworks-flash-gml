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
		public static var touchPoints:Dictionary = new Dictionary();
		public static var ipoints:Dictionary = new Dictionary();
		public static var touchObjects:Dictionary = new Dictionary();
		private static var virtualTransformObjects:Dictionary = new Dictionary();
		
		//private static var gms:TouchSprite;
		private static var gs:TouchSprite;
		//private static var gss:TouchSprite;
		
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
			trace("interaction manager init");
			///////////////////////////////////////////////////////////////////////////////////////
			// ref gloabl motion point list
			touchPoints = GestureGlobals.gw_public::touchPoints;
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
			
			trace("event mode",event.value.mode )
			
			//var ref:*
			
			//if (event.value.mode = "touch") ref = gs;
			//else if (event.value.mode = "motion") ref = gms;
			//else if (event.value.mode = "sensor") ref = gss;
			
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
				//gts.cO.iPointArray.push(ipO);
				
				//trace("ip begin",ipO.type)
				
				///////////////////////////////////////////////////////////////////
				// ADD TO LOCAL OBJECT Interaction POINT LIST
				for each(var tO:Object in touchObjects)
				{
					//trace("test", tO.motionClusterMode,tO.tc.ipSupported(ipO.type), ipO.type);
					//NOTE SUPPORT IP TYPES IS ONLY GLOBAL FOR NOW
					//WILL HAVE TO INIT SUPPORTED TYPES FOR EACH VIO
					
					//trace(ipO.type, ipO.modal_type, ipO.input_type)
					
					if ((tO.motionClusterMode == "local_strong")&&(ipO.mode=="motion"))//&&(tO.tc.ipSupported(ipO.type)))
					{
						
						
						var xh:Number = normalize(ipO.position.x, minX, maxX) * sw;//tO.stage.stageWidth;//1920
						var yh:Number = normalize(ipO.position.y, minY, maxY) * sh;//tO.stage.stageHeight; //1080
						
						// 2D HIT TEST FOR 2D OBJECT
						if ((tO is TouchSprite)||(tO is TouchMovieClip))//ITouchObject
						{
							//trace("2d hit test");			
							if (tO.hitTestPoint(xh, yh, false)) tO.cO.iPointArray.push(ipO);
									// CALL ASSIGN......
						}			
						//2D HIT TEST ON 3D OBJECT
						if (tO is ITouchObject3D) //ITouchObject //TouchObject3D
						{
							if (hitTest3D != null) {
								//trace("3d hit test"));
							//trace("3d hit test",hitTest3D(tO as ITouchObject3D, tO.view, xh, yh),tO, tO.vto,tO.name, tO.view, tO as ITouchObject3D)
								if (hitTest3D(tO as ITouchObject3D, xh, yh)==true) {
									tO.cO.iPointArray.push(ipO);
									// CALL ASSIGN.......
								}
							}
							

						}
							
					}
					else if ((tO.touchClusterMode == "local_strong")&&(ipO.mode=="touch"))//&&(tO.tc.ipSupported(ipO.type)))
					{
						
						
						var xh:Number = normalize(ipO.position.x, minX, maxX) * sw;//tO.stage.stageWidth;//1920
						var yh:Number = normalize(ipO.position.y, minY, maxY) * sh;//tO.stage.stageHeight; //1080
						
						// 2D HIT TEST FOR 2D OBJECT
						if ((tO is TouchSprite)||(tO is TouchMovieClip))//ITouchObject
						{
							//trace("2d hit test");			
							if (tO.hitTestPoint(xh, yh, false)) tO.cO.iPointArray.push(ipO);
									// CALL ASSIGN......
						}			
						//2D HIT TEST ON 3D OBJECT
						if (tO is ITouchObject3D) //ITouchObject //TouchObject3D
						{
							if (hitTest3D != null) {
								//trace("3d hit test"));
							//trace("3d hit test",hitTest3D(tO as ITouchObject3D, tO.view, xh, yh),tO, tO.vto,tO.name, tO.view, tO as ITouchObject3D)
								if (hitTest3D(tO as ITouchObject3D, xh, yh)==true) {
									tO.cO.iPointArray.push(ipO);
									// CALL ASSIGN.......
								}
							}
							

						}
							
					}
				}
				
				
				
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
					//gms.cO.iPointArray.splice(ipointObject.id, 1);
					gs.cO.iPointArray.splice(ipointObject.id, 1);
					
					// REMOVE FROM LOCAL OBJECTES
					for each(var tO:Object in touchObjects)
					{
						if ((tO.motionClusterMode == "local_strong")&&(ipointObject.mode=="motion")) tO.cO.iPointArray.splice(ipointObject.id, 1);
						else if ((tO.touchClusterMode == "local_strong")&&(ipointObject.mode=="touch")) tO.cO.iPointArray.splice(ipointObject.id, 1);
					}
					
					
					// REDUCE GLOBAL POINT COUNT
					//gms.interactionPointCount--;
					gs.interactionPointCount--;
					
					// UPDATE POINT ID 
					for (var i:int = 0; i < gs.cO.iPointArray.length; i++)//gms.cO.iPointArray.length
					{
						//gms.cO.iPointArray[i].id = i;
						gs.cO.iPointArray[i].id = i;
					}
				
					// DELETE FROM GLOBAL POINT LIST
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
		//TEMP TEST
		
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
			//trace("touch frame process ----------------------------------------------",gs.touchPointCount, gs.cO.pointArray.length,gs.cO.iPointArray.length);	
			
			//INCREMENT TOUCH FRAME id
			GestureGlobals.frameID += 1;
			
			//trace(GestureGlobals.frameID)
			/////////////////////////////////////////////////////////////////////////////
			
			if (GestureWorks.activeSensor)
			{
				// GET PREMETRICS
				// getTouchMetrics();
			}
			
			if (GestureWorks.activeSensor)
			{
				//GET PREMETRICS
				//getSensorMetrics();
			}
			
			//GET MOTION POINT LIST
			if (GestureWorks.activeMotion)
			{
				// TODO:MUST CHNAGE TO INIT ONCE GML IS FULLY PARSED // ON ALL OBJECTS
				if (GestureGlobals.frameID == 200) gs.tc.initGeoMetric3D();//initi geemetic gloabl ip activation
				
				// GET PREMETRICS
				gs.tc.getSkeletalMetrics3D();
				
				//trace("FrameID");
				
				
			}
			
			//TODO: CLEAN UP INIT
			// DISABLE BLOCK WHEN NO MOTION POINTS
			// update all touch objects in display list
			for each(var tO:Object in touchObjects)
			{
				//trace("tm touchobject","pn",tO.tpn,tO.cO.pointArray.length, gs.cO.pointArray.length,"ipn",tO.ipn,tO.cO.iPointArray.length, gs.cO.iPointArray.length, GestureWorks.activeNativeTouch,tO.touchEnabled,tO.tc.core,tO.tc.touch_core,"id", tO.touchObjectID, gs.touchObjectID);//gms.touchObjectID)
				
				////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
				//PULL TOUCH POINT DATA INTO EACH TOUCHOBJECT
				//GET GLOBAL TOUCH POINTS		
				if ((GestureWorks.activeNativeTouch) && (tO.touchEnabled) && (!tO.tc.core))
				{
					//trace("cluster",tO.cO)
					if (tO.cO)
					{
						//GLOBAL PUSH TO ALL TOUCH ENABLED VIOs
						tO.cO.pointArray = gs.cO.pointArray; // ALWAYS GLOBAL
						tO.cO.iPointArray = gs.cO.iPointArray; //WILL GET PUSHED USING HIT TEST
						//trace("push global touch to local touch object","pn",tO.tpn,tO.cO.pointArray.length, gs.cO.pointArray.length,"ipn",tO.ipn,tO.cO.iPointArray.length, gs.cO.iPointArray.length,tO.tc.core);
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
						tO.cO.sensorArray = gs.cO.sensorArray
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
						
						tO.cO.motionArray = gs.cO.motionArray
						tO.cO.handList = gs.cO.handList;
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
			
			
			//KILL POINTS THAT DONE REMOVE AUTOMATICALLY
			//killZombies(ITouchObject(tO));
			
		}
		
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
		}
		
		
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
		
		
		
	}
}