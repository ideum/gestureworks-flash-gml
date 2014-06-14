﻿////////////////////////////////////////////////////////////////////////////////
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
	//import com.gestureworks.managers.TouchPointHistories;
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
	import flash.geom.Point;
	import flash.utils.Dictionary;
	import org.tuio.TuioEvent;
	
	import flash.geom.Vector3D;
	import com.gestureworks.objects.InteractionPointObject;
	
	import com.gestureworks.core.TouchSprite; 
	import com.gestureworks.core.CoreSprite; 
 	

	
	public class TouchManager
	{
		public static var touchPoints:Dictionary;
		public static var touchObjects:Dictionary;
		private static var virtualTransformObjects:Dictionary;
		private static var touchArray:Vector.<TouchPointObject>
		private static var gs:CoreSprite;
		private static var touchPointCount:int
		private static var touch_init:Boolean = false;
		
		private static var pointObject:TouchPointObject;		
		
		//TODO: UPDATE MOUSE EVENT TOUCH SIMULATOR FOR NEW TOUCHPOINT EVENTLESS
		//TODO: UPDATE LEAP2D EVENT TOUCH SIMULATOR FOR NEW TOUCHPOINT EVENTLESS
		//TODO: UPDATE TUIO EVENT TOUCH SIMULATOR FOR NEW TOUCHPOINT EVENTLESS
		//TODO: REMOVE ALL OLD EVENT DRIVEN STUFF
		
		// initializes touchManager
		gw_public static function initialize():void
		{	
			if ((!touch_init)&&(GestureWorks.activeTouch))
			{
				trace("init touchmanager");
				//trace("touch frame processing rate:",GestureGlobals.touchFrameInterval);
				
				//gs = GestureGlobals.gw_public::core;
				touchPointCount = GestureGlobals.gw_public::touchPointCount
				touchPoints = GestureGlobals.gw_public::touchPoints;
				touchObjects = GestureGlobals.gw_public::touchObjects;
				touchArray = GestureGlobals.gw_public::touchArray;
				
				
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

		
		/**
		 * Convert TouchEvent to GWTouchEvent
		 * @param	event
		 */
		private static function onTouchEnd(e:TouchEvent):void {
			var event:GWTouchEvent = new GWTouchEvent(e);
			onTouchUp(event);
			//--onTouchUpPoint(event.touchPointID);
		}	
		
		/**
		 * Convert TouchEvent to GWTouchEvent
		 * @param	event
		 */
		private static function onMove(e:TouchEvent):void {
			
			//var event:GWTouchEvent = new GWTouchEvent(e); // KILLS PERFORMANCE
			//onTouchMove(event);
			
			//var tpO:TouchPointObject  = new TouchPointObject();
				//	tpO.id = touchPointCount; 
				//	tpO.touchPointID = event.touchPointID;
				//	tpO.position = new Vector3D (event.stageX, event.stageY, event.stageZ);
				//	tpO.size = new Vector3D (event.sizeX, event.sizeY);
				//	tpO.pressure = event.pressure;
				
			var tpO:TouchPointObject  = new TouchPointObject();
					tpO.id = touchPointCount; //?????
					tpO.touchPointID = e.touchPointID;
					tpO.position = new Vector3D (e.stageX, e.stageY, 0);//e.stageZ
					tpO.size = new Vector3D (e.sizeX, e.sizeY);
					tpO.pressure = e.pressure;	
	
			onTouchMovePoint(tpO);
		}	
		
		/**
		 * Convert TouchEvent to GWTouchEvent
		 * @param	event
		 */
		private static function onTouchBegin(e:TouchEvent):void 
		{			
			var event:GWTouchEvent = new GWTouchEvent(e);			
			
			//TODO:CREATE TOUCH POINT HERE AND INJECT
			onTouchDown(event);
			
			/*
			var tpO:TouchPointObject  = new TouchPointObject();
					tpO.id = touchPointCount; 
					tpO.touchPointID = event.touchPointID;
					tpO.position = new Vector3D (event.stageX, event.stageY, event.stageZ);
					tpO.size = new Vector3D (event.sizeX, event.sizeY);
					tpO.pressure = event.pressure;
			
			onTouchDownPoint(tpO);
			*/
		}
		
		
		public static function onTouchDown(event:GWTouchEvent):void
		{
			//trace("touch manager on touch down", event.touchPointID,gs.touchPointCount, gs.cO.touchArray.length)
			
			//////////////////////////////////////////////////////////////////////////////
			// CREATE NEW TOUCHPOINT IN GLOBAL TOUCH OBJECT
			// ADD TO POINT LIST OF GLOBAL TOUCH OBJECT
			var tpO:TouchPointObject  = new TouchPointObject();
					
					tpO.id = touchPointCount; 
					tpO.touchPointID = event.touchPointID;
			
					if (!tpO.size) tpO.size = new Vector3D(event.sizeX,event.sizeY);
					if (!tpO.position) tpO.position = new Vector3D(event.stageX,event.stageY,event.stageZ);
					tpO.pressure = event.pressure;
					//tpO.phase = "begin";
					
					//ADD TO GLOBAL MOTION SPRITE POINT LIST//////////////////
					touchArray.push(tpO);
					touchPointCount++;
					
					// ASSIGN POINT OBJECT WITH GLOBAL POINT LIST DICTIONARY/////////
					touchPoints[tpO.touchPointID] = tpO;

			///////////////////////////////////////////////////////////////////////////////////
			///////////////////////////////////////////////////////////////////////////////////
			//trace("TM DOWN",event.stageX,event.stageY,event.stageZ,validTarget(event));
		}
		
		
		
		public static function onTouchDownPoint(pt:TouchPointObject):void
		{
			//trace("touch manager on touch down", event.touchPointID,gs.touchPointCount, gs.cO.touchArray.length)
			
			//////////////////////////////////////////////////////////////////////////////
			// CREATE NEW TOUCHPOINT IN GLOBAL TOUCH OBJECT
			// ADD TO POINT LIST OF GLOBAL TOUCH OBJECT
			
			if (!touchArray) touchArray = new Vector.<TouchPointObject> 
			
			
			var tpO:TouchPointObject = new TouchPointObject();//????????
					tpO.id = gs.touchPointCount; 
					tpO.touchPointID = pt.touchPointID;
					tpO.position = pt.position;
					//tpO.size = pt.size;
					tpO.size.x = 0;
					tpO.size.y = 0;
					//tpO.pressure = pt.pressure;
					
					//ADD TO GLOBAL MOTION SPRITE POINT LIST//////////////////
					touchArray.push(pt);//tpO
					touchPointCount++;
				
					// ASSIGN POINT OBJECT WITH GLOBAL POINT LIST DICTIONARY/////////
					touchPoints[pt.touchPointID] = pt//tpO;
				
				// REGISTER TOUCH POINT WITH TOUCH MANAGER
				//registerTouchPoint(pt);//tpO
				
			///////////////////////////////////////////////////////////////////////////////////
			///////////////////////////////////////////////////////////////////////////////////
			//trace("TM DOWN",event.stageX,event.stageY,event.stageZ,validTarget(event));
		}
		
		
		// stage on TOUCH_UP.
		public static function onTouchUp(event:GWTouchEvent):void
		{
			////////////////////////////////////////////////////////////////////////////////////
			//trace("Touch point End, touchManager", event.touchPointID,gs.touchPointCount, gs.cO.touchArray.length)
			var tpO:TouchPointObject = touchPoints[event.touchPointID] as TouchPointObject;
			//trace("ready to remove", pointObject);
			
			if (tpO)
			{
					// REMOVE POINT FROM LOCAL LIST
					touchArray.splice(tpO.id, 1);
					// REDUCE LOACAL POINT COUNT
					touchPointCount--;
					
					// UPDATE POINT ID 
					for (var i:uint = 0; i < touchArray.length; i++)
					{
						touchArray[i].id = i;
					}
					// DELETE FROM GLOBAL POINT LIST
					delete touchPoints[event.touchPointID]as TouchPointObject;
			}
			
			//trace("should be removed",mpoints[motionPointID], motionSprite.motionPointCount, motionSprite.cO.motionArray.length);
			/////////////////////////////////////////////////////////////////////////////////////
		}
		
		public static function onTouchUpPoint(touchPointID:int):void
		{
			////////////////////////////////////////////////////////////////////////////////////
			trace("Touch point End, touchManager");// , event.touchPointID, gs.touchPointCount, gs.cO.touchArray.length)
			
			var tpO:TouchPointObject = touchPoints[touchPointID] as TouchPointObject;
			
			if (tpO)
			{
					// REMOVE POINT FROM LOCAL LIST
					touchArray.splice(tpO.id, 1);
					
					// REDUCE LOACAL POINT COUNT
					touchPointCount--;
					
					// UPDATE POINT ID 
					for (var i:uint = 0; i < touchArray.length; i++)
					{
						touchArray[i].id = i;
					}
					// DELETE FROM GLOBAL POINT LIST
					delete touchPoints[touchPointID]as TouchPointObject;
			}
			/////////////////////////////////////////////////////////////////////////////////////
			//trace("touch manger point up");
		}
		
		
		public static function onTouchMove(event:GWTouchEvent):void
		{	
			//trace("touch manager on touch move", event.touchPointID, gts.touchPointCount, gts.cO.touchArray.length)
			///////////////////////////////////////////////////////////////////////////////
			///////////////////////////////////////////////////////////////////////////////
			//  CONSOLODATED UPDATE METHOD FOR POINT POSITION AND TOUCH OBJECT CALCULATIONS
			
			var tpO:TouchPointObject = touchPoints[event.touchPointID]as TouchPointObject;
			
				if (tpO)
				{	
					if (!tpO.size) tpO.size = new Vector3D(event.sizeX,event.sizeY);
					if (!tpO.position) tpO.position = new Vector3D(event.stageX,event.stageY,event.stageZ);
					
					tpO.touchPointID  = event.touchPointID;
					//tpO.pressure = event.pressure;
					tpO.moveCount ++;
				}
				
				// UPDATE POINT HISTORY 
			//	TouchPointHistories.historyQueue(tpO);
				//////////////////////////////////////////////////////////////////////////////
				/////////////////////////////////////////////////////////////////////////////
		}		
		
		
		
		public static function onTouchMovePoint(pt:TouchPointObject):void
		{	
			var tpO:TouchPointObject = touchPoints[pt.touchPointID] as TouchPointObject;
			
				if (tpO)
				{	
					//tpO.id  = pt.id;
					tpO.touchPointID  = pt.touchPointID;
					tpO.position = pt.position;
					tpO.size = pt.size;
					tpO.pressure = pt.pressure;
					tpO.moveCount ++;
					//trace( tpO.moveCount);
				}
				
				
				
				// UPDATE POINT HISTORY 
			//	TouchPointHistories.historyQueue(tpO);
				//////////////////////////////////////////////////////////////////////////////
				/////////////////////////////////////////////////////////////////////////////
				//trace("touchmove-------------------------",tpO.moveCount,pt.position);
		}		
		
		
	}
}