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
		
		private static var gs:TouchSprite;
		private static var touch_init:Boolean = false;
		private static var pointObject:TouchPointObject;		
		
		// initializes touchManager
		gw_public static function initialize():void
		{	
			if (!touch_init)
			{
				trace("init touchmanager");
				//trace("touch frame processing rate:",GestureGlobals.touchFrameInterval);
				
				touchPoints = GestureGlobals.gw_public::touchPoints;
				touchObjects = GestureGlobals.gw_public::touchObjects;
				
				gs = GestureGlobals.gw_public::touchObjects[GestureGlobals.globalSpriteID];
				
				if (gs){
				// CREATE GLOBAL MOTION SPRITE TO HANDLE ALL GEOMETRIC GLOBAL ANALYSIS OF MOTION POINTS
				//gs = new TouchSprite();
					//gs.active = true;
					//gs.tc.core = true;
					//gs.debugDisplay = true;
					
					//gs.tc.touch_core = true; // fix for global core analysis
					//gs.touchEnabled = true;
				
					//trace("touch manger calling geo init")
					//gs.tc.initGeoMetric();
					
				//GestureWorks.application.addChild(gs);
				//GestureGlobals.globalSpriteID = gs.touchObjectID;
				//}
				//ACTIVATE
				//else {
					gs.touchEnabled = true;
					gs.tc.touch_core = true;
					//gs.debugDisplay = true;
				}
				
				
				

				
				if (GestureWorks.activeNativeTouch)
				{			
					//DRIVES POINT REGISTRATION
					GestureWorks.application.addEventListener(TouchEvent.TOUCH_BEGIN, onTouchBegin);
					//DRIVES UPDATES ON POINT LIFETIME
					GestureWorks.application.addEventListener(TouchEvent.TOUCH_END, onTouchEnd);
					// DRIVES UPDATES ON TOUCH POINT PATHS
					GestureWorks.application.addEventListener(TouchEvent.TOUCH_MOVE, onMove);
				}
				touch_init = true;
			}
		}
		
		gw_public static function deInitialize():void
		{
			GestureWorks.application.removeEventListener(TouchEvent.TOUCH_BEGIN, onTouchBegin);
			GestureWorks.application.removeEventListener(TouchEvent.TOUCH_END, onTouchEnd);
			GestureWorks.application.removeEventListener(TouchEvent.TOUCH_MOVE, onMove);
		}	
		
	
		public static function pointCount():int 
		{
			var count:int = 0;
			for each(var point:TouchPointObject in touchPoints)
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
		 * Convert TouchEvent to GWTouchEvent
		 * @param	event
		 */
		private static function onTouchEnd(e:TouchEvent):void {
			var event:GWTouchEvent = new GWTouchEvent(e);
			onTouchUp(event);
		}	
		
		/**
		 * Convert TouchEvent to GWTouchEvent
		 * @param	event
		 */
		private static function onMove(e:TouchEvent):void {
			var event:GWTouchEvent = new GWTouchEvent(e);
			onTouchMove(event);
		}	
		
		/**
		 * Convert TouchEvent to GWTouchEvent
		 * @param	event
		 */
		private static function onTouchBegin(e:TouchEvent):void 
		{			
			var event:GWTouchEvent = new GWTouchEvent(e);					
			onTouchDown(event);
		}
		
		public static function onTouchDown(event:GWTouchEvent):void
		{
			//trace("touch manager on touch down", event.touchPointID,gs.touchPointCount, gs.cO.touchArray.length)
			
			//////////////////////////////////////////////////////////////////////////////
			// CREATE NEW TOUCHPOINT IN GLOBAL TOUCH OBJECT
			// ADD TO POINT LIST OF GLOBAL TOUCH OBJECT
			var tpO:TouchPointObject  = new TouchPointObject();
					
					tpO.id = gs.touchPointCount; 
					tpO.touchPointID = event.touchPointID;
					tpO.position.x = event.stageX;
					tpO.position.y = event.stageY;
					tpO.position.z = event.stageZ;
					tpO.size.x = event.sizeX;
					tpO.size.y = event.sizeY;
					
					//ADD TO GLOBAL MOTION SPRITE POINT LIST
					
					gs.cO.touchArray.push(tpO);
					
					gs.touchPointCount++;//touchPointCount++;
				
					//trace("push touch point");
				
				// ASSIGN POINT OBJECT WITH GLOBAL POINT LIST DICTIONARY
				GestureGlobals.gw_public::touchPoints[event.touchPointID] = tpO;
				
				// REGISTER TOUCH POINT WITH TOUCH MANAGER
				//TODO: REF POINT OBJECTS NOT EVENT
				registerTouchPoint(event);//tpO
				
			///////////////////////////////////////////////////////////////////////////////////
			///////////////////////////////////////////////////////////////////////////////////
			//trace("TM DOWN",event.stageX,event.stageY,event.stageZ,validTarget(event));
		}
		
		// stage on TOUCH_UP.
		public static function onTouchUp(event:GWTouchEvent):void
		{
			////////////////////////////////////////////////////////////////////////////////////
			//trace("Touch point End, touchManager", event.touchPointID,gs.touchPointCount, gs.cO.touchArray.length)
			var touchPointID:int = event.touchPointID;
			var tpO:TouchPointObject = touchPoints[touchPointID];
			
			//trace("ready to remove", pointObject);
			
			if (tpO)
			{
					// REMOVE POINT FROM LOCAL LIST
					gs.cO.touchArray.splice(tpO.id, 1);
					
					//test gs.cO.touchArray.splice(tpO.touchPointID, 1);
					//test motionSprite.cO.motionArray.splice(pointObject.motionPointID, 1);
					
					// REDUCE LOACAL POINT COUNT
					gs.touchPointCount--;
					
					// UPDATE POINT ID 
					for (var i:int = 0; i < gs.cO.touchArray.length; i++)
					{
						gs.cO.touchArray[i].id = i;
					}
				
					// DELETE FROM GLOBAL POINT LIST
					delete touchPoints[event.touchPointID];
			}
			
			//trace("should be removed",mpoints[motionPointID], motionSprite.motionPointCount, motionSprite.cO.motionArray.length);
			/////////////////////////////////////////////////////////////////////////////////////
		}
		
		public static function onTouchMove(event:GWTouchEvent):void
		{	
			//trace("touch manager on touch move", event.touchPointID, gts.touchPointCount, gts.cO.touchArray.length)
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
					
					tpO.size.x = event.sizeX;
					tpO.size.y = event.sizeY;
					//tpO.pressure = event.pressure;
					

					tpO.moveCount ++;
					//trace( tpO.moveCount);
				}
				
				// UPDATE POINT HISTORY 
				TouchPointHistories.historyQueue(event);
				//////////////////////////////////////////////////////////////////////////////
				/////////////////////////////////////////////////////////////////////////////
		}		
		
		
	}
}