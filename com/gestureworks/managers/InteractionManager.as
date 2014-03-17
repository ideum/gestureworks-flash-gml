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
	import com.gestureworks.core.CoreSprite;
	import com.gestureworks.core.TouchSprite;
	import com.gestureworks.core.TouchCluster;
	import com.gestureworks.core.CoreCluster;
	import com.gestureworks.core.TouchGesture;
	import com.gestureworks.core.TouchPipeline;
	import com.gestureworks.core.TouchTransform;
	import com.gestureworks.core.TouchVisualizer;
	import com.gestureworks.core.CoreVisualizer;
	
	import com.gestureworks.events.GWInteractionEvent;
	import com.gestureworks.events.GWEvent;
	import com.gestureworks.events.GWGestureEvent;
	import com.gestureworks.events.GWTouchEvent;
	
	import com.gestureworks.interfaces.ITouchObject3D;
	import com.gestureworks.interfaces.ITouchObject;
	import com.gestureworks.utils.GestureParser;
	
	import com.gestureworks.managers.TouchPointHistories;
	import com.gestureworks.managers.InteractionPointTracker;
	import com.gestureworks.objects.MotionPointObject;
	import com.gestureworks.objects.InteractionPointObject;
	import com.gestureworks.objects.ClusterObject;
	import com.gestureworks.objects.FrameObject;
	import com.gestureworks.objects.GestureListObject;
	import com.gestureworks.objects.TouchPointObject;
	import com.gestureworks.objects.StrokeObject;
	import com.gestureworks.objects.TimelineObject;
	import com.gestureworks.objects.TransformObject;
	import com.gestureworks.objects.ipClusterObject;
	//import com.gestureworks.cml.elements.TouchContainer3D;
	
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
		public static var interactionPoints:Dictionary = new Dictionary();
		public static var touchObjects:Dictionary = new Dictionary();
		private static var virtualTransformObjects:Dictionary = new Dictionary();
		public static var interactionPointCount:int;
		private static var iPointArray:Vector.<InteractionPointObject>
		
		private static var gs:CoreSprite;
		private static var interaction_init:Boolean = false;
		
		private static var sw:int;
		private static var sh:int;
		
		private static var hooks:Vector.<Function>;
		private static var _overlays:Vector.<ITouchObject> = new Vector.<ITouchObject>();
		public static var hitTest3D:Function;
		
		
		gw_public static function initialize():void
		{
			if (!interaction_init)
			{
			trace("interaction manager init");
			///////////////////////////////////////////////////////////////////////////////////////
			// ref gloabl motion point list
			interactionPoints = GestureGlobals.gw_public::interactionPoints;
			touchObjects = GestureGlobals.gw_public::touchObjects;
			interactionPointCount =  GestureGlobals.gw_public::interactionPointCount;
			
			// init interaction point manager
			InteractionPointTracker.initialize();
			
			
			// CREATE GLOBAL INTERACTION SPRITE//////////////////////
				gs = new CoreSprite();
					/////////////////////////////////////////////////////////
					// CREATE CORE CLUSTER MANAGER
					gs.cc = new CoreCluster();
					//gs.cc.initPreMetrics(); //TOO SOON
					
					gs.cv = new CoreVisualizer();
				
				/////////////////////////////////////////////////////////
				// CREATE GLOBAL TIMELINE
				
				var tiO = new TimelineObject();  
					tiO.timelineOn = false; // activates timline manager
					tiO.pointEvents = false; // pushes point events into timline
					tiO.clusterEvents = false; // pushes cluster events into timeline
					tiO.gestureEvents = false; // pushes gesture events into timleine
					tiO.transformEvents = false; // pushes transform events into timeline
				GestureGlobals.gw_public::timeline = tiO;
				
				// assign arrays
				iPointArray = GestureGlobals.gw_public::iPointArray;
					
				GestureWorks.application.addChild(gs);
				GestureGlobals.gw_public::core = gs;
			
			/////////////////////////////////////////////////////////

			sw = GestureWorks.application.stageWidth
			sh = GestureWorks.application.stageHeight;
			
			///////////////////////////////////////////////////////////////////////////////////////////////////////////////
			// leave this on for all input types
			GestureWorks.application.addEventListener(GWEvent.ENTER_FRAME, interactionFrameHandler); //MOVE TO INTERACTION MANAGER
			interaction_init = true;
			}
		}
		
		gw_public static function deInitialize():void 
		{
			
			
		}
		

		
		public static function onInteractionBeginPoint(pt:InteractionPointObject):void
		{			
			//trace("interaction point begin, interactionManager",event.value.interactionPointID);
			//trace("event mode",event.value.mode )

				// DUPE CORE IP LIST FOR NOW
				// create new interaction point clone for each interactive display object 
				
				/*
				var ipO:InteractionPointObject  = new InteractionPointObject();	
				
						// need to make it modaly invariant
						ipO.id = gs.interactionPointCount; // NEEDED FOR THUMBID
						ipO.interactionPointID = pt.interactionPointID;
						ipO.handID = pt.handID;
						ipO.type = pt.type;
						ipO.mode = pt.mode;
						
						ipO.position = pt.position;
						ipO.direction = pt.direction;
						ipO.normal = pt.normal;
						ipO.velocity = pt.velocity;

						
						ipO.radius = pt.radius;
						ipO.length = pt.length;
						ipO.width = pt.width;
						
						//ADVANCED IP PROEPRTIES
						ipO.flatness = pt.flatness;
						ipO.orientation = pt.orientation;
						ipO.fn = pt.fn;
						ipO.splay = pt.splay;
						ipO.fist = pt.fist;
						
						ipO.phase = "begin"
						//trace(ipO.interactionPointID)
						*/
						
						
					pt.id = interactionPointCount;		
					pt.interactionPointID = pt.interactionPointID;
					//ipO.handID = pt.handID;
						//ipO.type = pt.type;
					//ipO.mode = pt.mode;
					pt.phase = "begin";
					
				////////////////////////////////////////////
				//ADD TO GLOBAL Interaction POINT LIST
				iPointArray.push(pt);//ipO
				////////////////////////////////////////////
				
				//trace("ip begin",ipO.type)
				// update local touch object point count
				interactionPointCount++;
				//gms.interactionPointCount++;

				///////////////////////////////////////////////////////////////////////////
				// ASSIGN POINT OBJECT WITH GLOBAL POINT LIST DICTIONARY
				interactionPoints[pt.interactionPointID]  = pt//ipO;
					
				////////////////////////////////////////////////////////////////////////////
				// REGISTER TOUCH POINT WITH TOUCH MANAGER
				//registerInteractionPoint(pt);//ipO
			//}
			
			//trace("gms ipointArray length",gms.cO.iPointArray.length,ipO.position )
		}
		
		/*
		// stage motion end
		public static function onInteractionEnd(event:GWInteractionEvent):void
		{
			var ipointObject:InteractionPointObject = interactionPoints[event.value.interactionPointID];
			//trace("Motion point End, motionManager", iPID)
			
			if (ipointObject)
			{
				ipointObject.phase="end"
				
					// REMOVE POINT FROM GLOBAL LIST
					iPointArray.splice(ipointObject.id, 1);
					
					// REDUCE GLOBAL INTERACTION POINT COUNT
					interactionPointCount--;
					
					// UPDATE INTERACTION POINT ID 
					for (var i:uint = 0; i < iPointArray.length; i++)//gms.cO.iPointArray.length
					{
						//gms.cO.iPointArray[i].id = i;
						iPointArray[i].id = i;
					}
				
					// DELETE FROM UNIQUE GLOBAL INPUT POINT LIST
					delete interactionPoints[event.value.interactionPointID];
			}
			trace("interaction point end EVENT",interactionPointCount)
		}*/
		
		public static function onInteractionEndPoint(interactionPointID:int):void
		{
			var ipO:InteractionPointObject = interactionPoints[interactionPointID] as InteractionPointObject;
			//trace("Motion point End, motionManager", iPID)
			
			if (ipO)
			{
					ipO.phase= "end"
				
					// REMOVE POINT FROM GLOBAL LIST
					iPointArray.splice(ipO.id, 1);
	
					// REDUCE GLOBAL INTERACTION POINT COUNT
					interactionPointCount--;
					
					// UPDATE INTERACTION POINT ID 
					for (var i:int = 0; i < iPointArray.length; i++)//gms.cO.iPointArray.length
					{
						//gms.cO.iPointArray[i].id = i;
						iPointArray[i].id = i;
					}
					// DELETE FROM UNIQUE GLOBAL INPUT POINT LIST
					delete interactionPoints[interactionPointID] as InteractionPointObject;
			}
			//trace("interaction point end POINT",interactionPointCount)
		}
		
		public static function onInteractionUpdatePoint(pt:InteractionPointObject):void
		{			
			//  CONSOLODATED UPDATE METHOD FOR POINT POSITION AND TOUCH OBJECT CALCULATIONS
			var ipO:InteractionPointObject = interactionPoints[pt.interactionPointID] as InteractionPointObject;
			
			//trace("interaction move point, interactionsManager", pt.interactionPointID);
			
				if (ipO)
				{	
					//mpO = event.value;
					ipO.interactionPointID  = pt.interactionPointID;
					ipO.mode = pt.mode;
					ipO.position = pt.position;
					ipO.direction = pt.direction;
					ipO.normal = pt.normal;
					ipO.screen_position = pt.screen_position;
					ipO.screen_direction = pt.screen_direction;
					ipO.screen_normal = pt.screen_normal;
					
					ipO.velocity = pt.velocity;
					
					ipO.radius = pt.radius
					ipO.length = pt.length;
					ipO.width = pt.width;
					
					ipO.flatness = pt.flatness;
					ipO.orientation = pt.orientation;
					ipO.fn = pt.fn;
					ipO.splay = pt.splay;
					ipO.fist = pt.fist;
					
					//sensors
					ipO.acceleration = pt.acceleration;
					ipO.buttons = pt.buttons;
					
					
					ipO.phase = "update"
					//mpO.handID = event.value.handID;
					//ipO.moveCount ++;
					
					//trace("gms ipointArray length",gms.cO.iPointArray.length,ipO.position )
				}
				

				// UPDATE POINT HISTORY
				// NOT APPARENTLY NEEDED AS GET FROM CLUSTER HISTORY
				// SAME WITH VECTOR ANALYSIS
				//InteractionPointHistories.historyQueue(ipO);
				//ipO.history.unshift(InteractionPointHistories.historyObject(ipO))
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
		
		/**
		 * Assign interaction points to parent's with interaction poiont bubbling enabled.
		 * @param	target
		 * @param	event
		 */
		private static function propagateInteractionPoint(ipt:InteractionPointObject, ts:Object):void {
			
			//trace("propgate interaction");
			if ((ts.parent) && (ts.parent  is ITouchObject))
			{
				if (ts.parent.interactionPointBubbling)
				{
					//PUSH INTERACTION POINT TO PARENT
					ts.parent.cO.iPointArray.push(ipt); //TODO: REFERENCE IPOINTARRAY DREICTLY IN TOUCHSPRITE
						
					//INIT PUSH OF INTERACTION POINT TO GRANDPARENT
					if  (ts.parent.parent is ITouchObject)propagateInteractionPoint(ipt,ts.parent);
					//else if (ts.targetParent) ts.parent.cO.iPointArray.push(ipt);
				}
			}
		}

		/**
		 * Registers a function to externally modify the provided GWTouchEvent for point processing
		 * @param  hook  The hook function with GWTouchEvent parameter
		 */
		public static function registerHook(hook:Function):void {
			trace("register hooks");
			if (!hooks)
				hooks = new Vector.<Function>();
			hooks.push(hook);
			
			trace("hooks",hooks.length)
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
		 * Determines the event's target is valid based on activated state and local mode settings.
		 * @param	event
		 * @return
		 */
		/*
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
		}*/
		
		/**
		 * If target is not activated, updates the target to the first activated ancestor
		 * @param	event
		 */
		/*
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
		*/
		///////////////////////////////////////////////////////////////////////////////////////////////////////
		///////////////////////////////////////////////////////////////////////////////////////////////////////

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
			
			// A VEHICLE TO CONTAIN CORE GESTURE VALUES
			/////////////////////////////////////////////////////////////////////////
			obj.ipcOList = new Dictionary();//iPointClusterListObject(); 
				//obj.ipcOList.id = obj.touchObjectID;
			GestureGlobals.gw_public::iPointClusterLists[obj.touchObjectID] = obj.ipcOList;
			
			// create generic analysis engine
			//if (GestureGlobals.analyzeCluster)
				//{
				/////////////////////////////////////////////////////////////////////////
				// CREATES A NEW CLUSTER OBJECT FOR THE TOUCHSPRITE
				// HANDLES CORE GEOMETRIC RAW PROPERTIES OF THE CLUSTER
				/////////////////////////////////////////////////////////////////////////
				obj.cO = new ClusterObject(); // touch cluster 2d 
					obj.cO.id = obj.touchObjectID; 
				GestureGlobals.gw_public::clusters[obj.touchObjectID] = obj.cO; //ONLY REGISTAR GESTURES AND TOUCH OBJECTS
				
				// create new stroke object
				//SHOULD MOVE INTO TOUCH SUBCLUSTER// SPECIAL PEN CONSTRUCT
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
				
									//TODO: KILL AND INTERGRATE FUNCTIONALITY INTO GLOBAL TIMELINE OBJECT
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
													//TODO:DONT REGISTAR
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
								
							//TOO SOON
								//obj.tc.initIPSupport();
								//obj.tc.initIPFilters(); //CHECK
								//obj.tc.initSubClusters();
							
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
			
			//trace("t",GestureWorks.activeTouch, "m:",GestureWorks.activeMotion,"s:",GestureWorks.activeSensor)
			//INIT PREMETRICS (TURN ON RELVANT IP SUBCLUSTER GENERATORS)
			if (GestureGlobals.frameID == 1) gs.cc.initPreMetrics();
			
			///////////////////////////////////////////////////////////////////////////////
			// GLOBAL CORE INITS AND UPDATES
			///////////////////////////////////////////////////////////////////////////////
			
				gs.cc.updateCoreRawPointCount();
			
				//GET TOUCH PREMETRICS
				if (GestureWorks.activeTouch) gs.cc.getTouchGeoMetrics();
				
				//GET MOTION POINT LIST
				if (GestureWorks.activeMotion) gs.cc.getMotionGeoMetrics();
				
				//GET SENSOR PREMETRICS
				if (GestureWorks.activeSensor) gs.cc.getSensorGeoMetrics();
				
				//gs.cc.updateCoreRawPointCount();
				
				//GLOBAL VISUALIZER FOR RAW INPUT DATA
				gs.cv.updateDebugDisplay();
				
			/////////////////////////////////////////////////////////////////////////////////
			/////////////////////////////////////////////////////////////////////////////////
			
			
			////////////////////////////////////////////////////////////////////////////
			// DEPTH SORTING
			////////////////////////////////////////////////////////////////////////////
			var temp_tOList:Array = new Array();//= touchObjects;

			for each(var itO:Object in touchObjects)
			{
				//trace("interactive object", itO,itO.cO.iPointArray.length,itO.tc.core)
				
				//if (itO is TouchContainer3D) trace(itO.iPointArray.length)
				
				//if (!itO.tc.core)
				//{
				//trace("index", itO.index, itO.name);
					if ((itO.parent) &&(itO.visible))
					{
						itO.index = itO.parent.getChildIndex(itO);
						temp_tOList.push(itO);
					}
					else if (itO is ITouchObject3D) 
					{
						//TODO: organize more 
						// may need to add 1000 for 3d starting point
						//trace("depth", itO.z)
						itO.index = itO.z//1000;
						temp_tOList.push(itO);
					}
				//}
				//if (itO is ITouchObject) trace(itO.index)
			}
			//MAY BE REQUIRED WHEN OBJECTS ADDED AND REMOVED
			// THNE AGAIN MAY NOT BE REQUIRED AS JUST ADDED TO DICTIONARY LATER!
			//temp_tOList.sortOn("index", [Array.NUMERIC]);
			//REQUIRED//////////////////////// REVERSES ORDER OF ADDITON AND THERFOR INDEX
			temp_tOList.reverse();
			
			
			//TEST TRACE
			//for (var i:int = 0; i < temp_tOList.length; i++) 
			//{
				//trace("TEMP INDEX", temp_tOList[i].index, temp_tOList[i] );
			//}
			
			///////////////////////////////////////////////////////////////////////////
			
			
			/////////////////////////////////////////////////////////////////////////////
			//IP HIT TESTING /////////////////////////////////////////////////////////////
			/////////////////////////////////////////////////////////////////////////////
			// LOOP THROUGH GLOABL IP LIST // THEN LOOP THROUGH TOUCH OBJECTS
			
				//SELECTIVELY ADD IPOINTS TO TOUCH OBJETCS/////////////
				for (var k:uint = 0; k < iPointArray.length; k++)
				{
					hitTestiPointsAddLocal(iPointArray[k], temp_tOList);
					hitTestiPointsAddGlobal(iPointArray[k],temp_tOList);
				}
				//REMOVE POINTS///////////////////////////////////////
				for (var j:uint = 0; j < temp_tOList.length; j++) 
				{	
					hitTestiPointsRemove(temp_tOList[j]);
				}
			/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
			
			
			
			
			
			
			////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////	
			// UPDATE ALL INTERACTIVE OBJECTS ON DISPLAY LIST
			//for each(var tO:Object in touchObjects)//
			for (var i:int = 0; i < temp_tOList.length; i++) 
			{
				var tO:Object = temp_tOList[i];
				//trace("index", tO.getChildIndex());
		
				
				///////////////////////////////////////////////////////////////////////
				// update touch,cluster and gesture processing
				///////////////////////////////////////////////////////////////////////
				if (tO.tc) tO.tc.updateClusterAnalysis();
				
				if (tO.tp) tO.tp.processPipeline();
				if (tO.tg) tO.tg.manageGestureEventDispatch();
				if (tO.tt)
				{
					tO.tt.transformManager();
					tO.tt.updateLocalProperties();
				}
				//NEED CLUSTER HISTORIES FOR GESTURES
				ClusterHistories.historyQueue(tO.cO);//obj.touchObjectID
				//trace("end main processing loop", obj.tpn, obj.ipn, obj.tc.core, gts.touchPointCount, gts.cO.pointArray.length,gts.cO.iPointArray.length,"id", obj.touchObjectID, gts.touchObjectID,gms.touchObjectID);
				
				///////////////////////////////////////////////////////////////////////

				// move to timeline visualizer
				// CURRENTLY NO GESTURE OR CLUSTER ANALYSIS REQURES
				// DIRECT CLUSTER OR TRANSFROM HISTORY, USED IN DEBUG ONLY
				if (tO.visualizer && tO.visualizer.debug_display)
				{
					//UPDATE TRANSFORM HISTORIES
					//TransformHistories.historyQueue(tO.touchObjectID);
					TransformHistories.historyQueue(tO.trO);
					
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
		}
		

		public static function hitTestiPointsAddLocal(ipt:InteractionPointObject,temp_tOList:Array):void
			{
				///////////////////////////////////////////////////////////////////////////////////////////////////////////////
				// touch cluster hit test
				///////////////////////////////////////////////////////////////////////////////////////////////////////////////
				for (var i:int = 0; i < temp_tOList.length; i++) 
				{
					var ts = temp_tOList[i];
					
					//trace("ip hit test interaction manager",ts, i)
					///////////////////////////////////////////////////////////////////////////////////////////////////
					// TOUCH
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
						//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
						//MOTION
						if (ts.motionEnabled)
						{
								if ((ipt)&&(ipt.mode=="motion"))//&&(ts.tc.ipSupported(ipt.type))
								{
									//INDEX AND INTERACTIOPN POINT CHILDREN INDEPENDANT
									//if ((ts.touchClusterMode == "global")&&(ipt.phase=="begin")) ts.cO.iPointArray.push(ipt);
									
									//INDEX AND MOUSE CHILDREN DEPENDANT
									if (((ts.motionClusterMode == "local_strong")&&(ipt.phase=="begin"))||((ts.motionClusterMode == "local_weak")&&(ipt.phase=="begin"))) 
									{
										if (ts is ITouchObject)
										{
											var x = ipt.screen_position.x//normalize(ipt.position.x, minX, maxX) * sw;
											var y = ipt.screen_position.y//normalize(ipt.position.y, minY, maxY) * sh;
											
											if ((ts.hitTestPoint(x, y, true))&&((!ts.mouseChildren)||(!ts.interactionPointChildren)))
											{
												ts.cO.iPointArray.push(ipt);
												propagateInteractionPoint(ipt, ts);
												return;
											}
										}
										else if (ts is ITouchObject3D)
										{
											//trace("3D MOTION HITTEST");
											if (hitTest3D != null) {
												
												var x = ipt.screen_position.x //normalize(ipt.position.x, minX, maxX) * sw;
												var y = ipt.screen_position.y//normalize(ipt.position.y, minY, maxY) * sh;
												
												if ((hitTest3D(ts as ITouchObject3D, x, y))&&((!ts.mouseChildren)||(!ts.interactionPointChildren)))
												{ 
													ts.cO.iPointArray.push(ipt);
													propagateInteractionPoint(ipt, ts);
													return;
												}
											}
										}
									}
									// DISPLAY INDEX VALUE DOES NOT DETERMIN WEAK LOCAL CLUSTERING (FFEATURE)
									else if ((ts.motionClusterMode == "local_weak")&&(ipt.phase=="update"))
									{
										if (ts is ITouchObject)
										{
											var x = ipt.screen_position.x//normalize(ipt.position.x, minX, maxX) * sw;
											var y = ipt.screen_position.y//normalize(ipt.position.y, minY, maxY) * sh;
											
											if ((ts.hitTestPoint(x, y, true))&&((!ts.mouseChildren)||(!ts.interactionPointChildren)))
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
										//trace("3D MOTION HITTEST");
										
											if (hitTest3D != null) {
												
											var x = ipt.screen_position.x//normalize(ipt.position.x, minX, maxX) * sw;
											var y = ipt.screen_position.y//normalize(ipt.position.y, minY, maxY) * sh;

												if ((hitTest3D(ts as ITouchObject3D, x, y))&&((!ts.mouseChildren)||(!ts.interactionPointChildren)))
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
						//////////////////////////////////////////////////////////////////////////////////////////////////////////////
						//SENSOR
						
						
						
					}
			}
			
		
		public static function hitTestiPointsAddGlobal(ipt:InteractionPointObject,temp_tOList:Array):void
			{
				///////////////////////////////////////////////////////////////////////////////////////////////////////////////
				// touch cluster hit test
				///////////////////////////////////////////////////////////////////////////////////////////////////////////////
				for (var i:int = 0; i < temp_tOList.length; i++) 
				{
					var ts = temp_tOList[i];
					//trace(ts.sensorEnabled, ipt, ipt.mode);
					if (ipt.phase == "begin")
					{
						//TOUCH
						if ((ts.touchEnabled)&&(ipt)&&(ipt.mode=="touch"))//&&(ts.tc.ipSupported(ipt.type))
						{
							if (ts.touchClusterMode == "global") ts.cO.iPointArray.push(ipt);
						}
						//MOTION
						else if ((ts.motionEnabled)&&(ipt)&&(ipt.mode=="motion"))//&&(ts.tc.ipSupported(ipt.type))
						{
							if (ts.motionClusterMode == "global") ts.cO.iPointArray.push(ipt);
						}
						//SENSOR
						else if ((ts.sensorEnabled)&&(ipt)&&(ipt.mode=="sensor"))//&&(ts.tc.ipSupported(ipt.type))
						{
							if (ts.sensorClusterMode == "global") ts.cO.iPointArray.push(ipt);
							
						}
					}
				}
			}
			
		//////////////////////////////////////////////////////////////////////////////////////
		// REMOVING INTERACTION POINTS FROM LOCAL LIST
		//////////////////////////////////////////////////////////////////////////////////////
		public static function hitTestiPointsRemove(ts:Object):void
			{
					if (ts.cO.iPointArray.length)
						{
						for (var i:uint = 0; i < ts.cO.iPointArray.length; i++)
							{
								var k_pt:InteractionPointObject = ts.cO.iPointArray[i];
								
								if (k_pt)
								{
									//TOUCH////////////////////////////////////////
									if ((ts.touchEnabled)&&(k_pt.mode == "touch"))
									{
										//trace(ts.cO.iPointArray[i].interactionPointID,ts.cO.iPointArray[i].phase);
										if (k_pt.phase == "end") ts.cO.iPointArray.splice(i, 1);
										
										else if ((k_pt.phase == "update")&&(ts.touchClusterMode == "local_weak"))
										{
											if ((!ts.hitTestPoint(k_pt.position.x, k_pt.position.y, false))&&(!ts.mouseChildren)) ts.cO.iPointArray.splice(i, 1);
										}
									}
									//MOTION///////////////////////////////////////
									if ((ts.motionEnabled)&&(k_pt.mode == "motion"))
									{
										//trace(ts.cO.iPointArray[i].interactionPointID,ts.cO.iPointArray[i].phase);
										if (k_pt.phase == "end") ts.cO.iPointArray.splice(i, 1);
										
										else if ((k_pt.phase == "update")&&(ts.motionClusterMode == "local_weak"))
										{
											if ((!ts.hitTestPoint(k_pt.screen_position.x, k_pt.screen_position.y, false))&&(!ts.mouseChildren)) ts.cO.iPointArray.splice(i, 1);
										}
									}
									//SENSOR///////////////////////////////////////
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
			
			
			
			/*
			private static function normalize(value : Number, minimum : Number, maximum : Number) : Number {

                        return (value - minimum) / (maximum - minimum);
         }*/
		
	}
}