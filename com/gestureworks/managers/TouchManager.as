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
	import com.gestureworks.core.TouchMovieClip;
	import com.gestureworks.core.VirtualTouchObject;
	import com.gestureworks.events.GWTouchEvent;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.utils.Dictionary;
	import flash.events.TouchEvent;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import flash.system.System;
	
	import com.gestureworks.core.GestureWorks;
	import com.gestureworks.core.GestureWorksCore;
	import com.gestureworks.core.GestureGlobals;
	import com.gestureworks.core.gw_public;
	import com.gestureworks.core.GML;
	import com.gestureworks.core.TouchSprite
	
	import com.gestureworks.utils.ArrangePoints;
	import com.gestureworks.managers.PointHistories;
	import com.gestureworks.events.GWEvent;
	
	import com.gestureworks.objects.PointObject;
	import com.gestureworks.objects.TouchObject;
	import com.gestureworks.managers.InteractionManager;
	import com.gestureworks.utils.Simulator;
	
	import com.gestureworks.objects.FrameObject;
	
	
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
				
				//DRIVES HIT TESTING
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
		private static function registerTouchPoint(event:TouchEvent):void
		{
			//FIX CELAN UP REFERENCE 
			points[event.touchPointID].history.unshift(PointHistories.historyObject(event))	
		}
		
		/**
		 * Convert TouchEvent to GWTouchEvent
		 * @param	event
		 */
		private static function onTouchBegin(event:TouchEvent):void{
			onTouchDown(new GWTouchEvent(event));
		}
		
		/**
		 * Decides how to assign the captured touch point to a cluster can pass to parent, an explicit target, an explicit list or 
		 * targets or a passed to any touch object in the local display stack.
		 * @param	event
		 * @param	downTarget
		 */
		public static function onTouchDown(event:GWTouchEvent, downTarget:*=null):void
		{
			if (event.eventPhase == 3) { //not stage
				
				if ((event.target is TouchSprite || event.target is TouchMovieClip) && event.target.activated) {
					
					if (duplicateDeviceInput(event)) return;
					
					// if target gets passed it takes precendence, otherwise try to find it
					// currently target gets passed in as argument for our global hit test
					// if no target is found then bail
					if (!downTarget)
						downTarget = event.target; // object that got hit, used for our non-tuio gesture events
					if (!downTarget)
						return;
						
					var parent:* = downTarget.parent;	
								
					if (downTarget.targetParent && ((downTarget is TouchSprite) || (downTarget is TouchMovieClip))) { //ASSIGN PRIMARY CLUSTER TO PARENT
							parent.assignPoint(event);
					}
					else if ((downTarget.targetObject is TouchSprite)||(downTarget.targetObject is TouchMovieClip))	// ASSIGN PRIMARY CLUSTER TO TARGET
					{							
						downTarget.targetObject.assignPoint(event);
						downTarget.targetList[j].broadcastTarget = true;
					}
					else if ((downTarget.targetList[0] is TouchSprite)||(downTarget.targetList[0] is TouchMovieClip))
					{							
						//ASSIGN THIS TOUCH OBJECT AS PRIMARY CLUSTER
						downTarget.assignPoint(event);
						
						//CREATE SECONDARY CLUSTERS ON TARGET LIST ITEMS
						for (var j:uint = 0; j < downTarget.targetList.length; j++) 
						{
							downTarget.targetList[j].assignPointClone(event);
							downTarget.targetList[j].broadcastTarget = true;
						}
					}
					else {
						 assignPoint(downTarget, event);
						 propagatePoint(parent, event);
					}	
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
		private static function propagatePoint(target:*, event:TouchEvent):void {
			if (!target)
				return;
			
			if (target.hasOwnProperty("clusterBubbling") && target.clusterBubbling) {
				assignPointClone(target, event);
				propagatePoint(target.parent, event);
			}
		}
		
		/**
		 * Registers assigned touch point globaly and to relevant local clusters 
		 * @param	target
		 * @param	event
		 */
		private static function assignPoint(target:*, event:TouchEvent):void // asigns point
		{		
			// create new point object
			var pointObject:PointObject  = new PointObject();	
				pointObject.object = target; // sets primary touch object/cluster
				pointObject.id = target.pointCount; // NEEDED FOR THUMBID
				pointObject.touchPointID = event.touchPointID;
				pointObject.x = event.stageX;
				pointObject.y = event.stageY; 
				pointObject.objectList.push(target); // seeds cluster/touch object list
				
				//ADD TO LOCAL POINT LIST
				target._pointArray.push(pointObject);
				
				//UPDATE LOCAL CLUSTER OBJECT
				target.cO.pointArray = target._pointArray;												
				
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
		
		private static function assignPointClone(target:*, event:TouchEvent):void // assigns point copy
		{
				// assign existing point object
				var pointObject:PointObject = GestureGlobals.gw_public::points[event.touchPointID]
					// add this touch object to touchobject list on point
					pointObject.touchPointID = event.touchPointID;//-??
					pointObject.objectList.push(target);  ////////////////////////////////////////////////NEED TO COME UP WITH METHOD TO REMOVE TOUCH OBJECT THAT ARE NOT LONGER ON STAGE
	
				//ADD TO LOCAL POINT LIST
				target._pointArray.push(pointObject);
				
				//UPDATE LOCAL CLUSTER OBJECT
				//touch object point list and cluster point list should be consolodated
				target.cO.pointArray = target._pointArray;
				
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
				
				//trace("ts clone bubble target, point array length",_pointArray.length, pointObject.touchPointID, pointObject.objectList.length, this);
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
				if ((TouchSprite(pointObject.object).registerPoints) || overrideRegisterPoints) { 
					/////////////////////////////////////////////////////////////////////////////////////
					/////////////////////////////////////////////////////////////////////////////////////
					// LOOP THROUGH ALL CLUSTERS LISTED ON POINT
					for (var j:int = 0; j < pointObject.objectList.length; j++)
					{
						//trace("updating targets");
						var i:int;
						var tO:Object = pointObject.objectList[j];
						
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
		
		
		private static var pointObject:PointObject;
		
		/**
		 * Convert TouchEvent to GWTouchEvent
		 * @param	event
		 */
		private static function onMove(event:TouchEvent):void{
			onTouchMove(new GWTouchEvent(event));
		}			
	
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
					pointObject.y = event.stageY;
					pointObject.x = event.stageX;
					pointObject.moveCount++;
					
					// UPDATE POINT HISTORY 
					// PUSHES NEWEST LOCATION DATA TO POINT PATH/HISTORY
					PointHistories.historyQueue(event);
				}
			}
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
				updateTouchObject(tO);
				
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
		
		public static function updateTouchObject(tO:Object):void
		{
				//trace("hello", ts, ts.N);
				// THERFOR CLUSTER ANALYSIS IS N SPECICIFC AND SELF MAMANGED SWITCHING
				// PIPELINE PROCESSING IS GESTURE OBJECT STATE DEPENDANT AND NOT N DEPENDANT
				

				tO.updateTObjProcessing();
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