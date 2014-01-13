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
	import flash.utils.Dictionary;
	
	import com.gestureworks.core.TouchSprite;
	import com.gestureworks.core.GestureWorks;
	import com.gestureworks.core.GestureWorksCore;
	import com.gestureworks.core.GestureGlobals;
	import com.gestureworks.core.GestureWorks;
	import com.gestureworks.core.gw_public;
	
	import com.gestureworks.utils.ArrangePoints;
	import com.gestureworks.managers.PointHistories;
	import com.gestureworks.events.GWEvent;
	import com.gestureworks.events.GWMotionEvent;
	import com.gestureworks.objects.MotionPointObject;
	
	import com.gestureworks.objects.GestureObject;
	import com.gestureworks.objects.ClusterObject;
	import com.gestureworks.objects.ipClusterObject;
	import com.gestureworks.objects.GestureListObject;
	import com.gestureworks.objects.TimelineObject;
	import com.gestureworks.objects.DimensionObject;

	import com.leapmotion.leap.events.LeapEvent;
	import com.leapmotion.leap.LeapMotion;
	
	import com.gestureworks.managers.Motion3DSManager;
	
	
	
	public class MotionManager 
	{	

		public static var lmManager:LeapManager
	//	public static var motionSocketMgr:Motion3DSManager
		
		public static var motionSprite:TouchSprite;
		
		public static var leapEnabled:Boolean = false;
		public static var leapmode:String = "3d"//"2d";
		
		public static var mpoints:Dictionary = new Dictionary();
		public static var touchObjects:Dictionary = new Dictionary();
		
		gw_public static function initialize():void

		{	
			//if(debug)
				trace("init leap motion device----------------------------------------------------",leapmode)
				
			if (leapEnabled)
			{
				if(leapmode == "2d"){
					lmManager = new Leap2DManager();
					lmManager.addEventListener(LeapEvent.LEAPMOTION_FRAME, onFrame);
				}
				if (leapmode == "3d"){
					lmManager = new Leap3DManager();
					lmManager.addEventListener(LeapEvent.LEAPMOTION_FRAME, onFrame);
				}
				
				if (leapmode == "2d_ds") {
					trace(leapmode)
				}
				
				if (leapmode == "3d_ds") {
					trace(leapmode)
					
					// init leap socker mgr
					//leapsocketMgr = new Leap3DSManager;
					
					//lmManager = new Leap3DManager();
					//lmManager.addEventListener(LeapEvent.LEAPMOTION_FRAME, onFrame);
				}
			}
			
			///////////////////////////////////////////////////////////////////////////////////////
			// ref gloabl motion point list
			mpoints = GestureGlobals.gw_public::motionPoints;
			touchObjects = GestureGlobals.gw_public::touchObjects;
			
			// CREATE GLOBAL MOTION SPRITE TO HANDLE ALL GEOMETRIC GLOBAL ANALYSIS OF MOTION POINTS
			motionSprite = new TouchSprite();
				motionSprite.active = true;
				motionSprite.motionEnabled = true;
				motionSprite.tc.core = true; // fix for global core analysis
				
			GestureGlobals.motionSpriteID = motionSprite.touchObjectID;

			//////////////////////////////////////////
			//TODO:
			// init interaction manager
			// CREATE MOLTIMODAL MANAGER
			
			
		}
		
		gw_public static function deInitialize():void
		{
			if (leapmode == "2d" && lmManager) {
				lmManager.removeEventListener(LeapEvent.LEAPMOTION_FRAME, onFrame);
				Leap2DManager(lmManager).dispose();
				lmManager = null;
			}
		}

		
		
		public static function onFrame(event:LeapEvent):void 
		{
			//trace("motion frame------------------------------------", event.frame)
			GestureGlobals.motionFrameID += 1;
		}
		
		
		// registers touch point via touchSprite
		public static function registerMotionPoint(mpo:MotionPointObject):void
		{
			mpo.history.unshift(MotionPointHistories.historyObject(mpo))
		}
		
		
		public static function onMotionBegin(event:GWMotionEvent):void
		{			
			//trace("motion point begin, motionManager",event.value.motionPointID);
			
			// create new point object
			var mpointObject:MotionPointObject  = new MotionPointObject();
					
					mpointObject.id = motionSprite.motionPointCount; // NEEDED FOR THUMBID ?????????????? not in motion
					mpointObject.motionPointID = event.value.motionPointID;
					mpointObject.type = event.value.type;
					mpointObject.handID = event.value.handID;
					
					mpointObject.position = event.value.position;
					mpointObject.direction = event.value.direction;
					mpointObject.normal = event.value.normal;
					mpointObject.velocity = event.value.velocity;

					mpointObject.sphereCenter = event.value.sphereCenter;
					mpointObject.sphereRadius = event.value.sphereRadius;
					
					mpointObject.length = event.value.length;
					mpointObject.width = event.value.width;
					
					
					//ADD TO GLOBAL MOTION SPRITE POINT LIST
					motionSprite.cO.motionArray.push(mpointObject);
					motionSprite.motionPointCount++;
				
				
				// ASSIGN POINT OBJECT WITH GLOBAL POINT LIST DICTIONARY
				GestureGlobals.gw_public::motionPoints[event.value.motionPointID] = mpointObject;
				
				// REGISTER TOUCH POINT WITH TOUCH MANAGER
				registerMotionPoint(mpointObject);
			
		}
		
		
		// stage motion end
		public static function onMotionEnd(event:GWMotionEvent):void
		{
			//trace("Motion point End, motionManager", event.value.motionPointID)
			var motionPointID:int = event.value.motionPointID;
			var pointObject:MotionPointObject = mpoints[motionPointID];
			
			//trace("ready to remove", pointObject);
			
			if (pointObject)
			{
					// REMOVE POINT FROM LOCAL LIST
					motionSprite.cO.motionArray.splice(pointObject.id, 1);
					//test motionSprite.cO.motionArray.splice(pointObject.motionPointID, 1);
					
					// REDUCE LOACAL POINT COUNT
					motionSprite.motionPointCount--;
					
					// UPDATE POINT ID 
					for (var i:int = 0; i < motionSprite.cO.motionArray.length; i++)
					{
						motionSprite.cO.motionArray[i].id = i;
					}
				
					// DELETE FROM GLOBAL POINT LIST
					delete mpoints[event.value.motionPointID];
			}
			
			//trace("should be removed",mpoints[motionPointID], motionSprite.motionPointCount, motionSprite.cO.motionArray.length);
			
			//trace("motion point tot",motionSprite.motionPointCount)
		}
		
	
		// the Stage TOUCH_MOVE event.	// DRIVES POINT PATH UPDATES
		public static function onMotionMove(event:GWMotionEvent):void
		{			
			//  CONSOLODATED UPDATE METHOD FOR POINT POSITION AND TOUCH OBJECT CALCULATIONS
			var mpO:MotionPointObject = mpoints[event.value.motionPointID];
			
			//trace("motion move/Update event, motionManager", event.value.motionPointID);
			
				if (mpO)
				{	
					
					//trace(event.value.position.x, event.value.position.y,event.value.position.z)
					//mpO = event.value;
					
					//mpO.id  = event.value.id;
					//mpO.motionPointID  = event.value.motionPointID;
					mpO.position = event.value.position;
					mpO.direction = event.value.direction;
					mpO.normal = event.value.normal;
					mpO.velocity = event.value.velocity;
					
					mpO.sphereRadius = event.value.sphereRadius;
					mpO.sphereCenter = event.value.sphereCenter;
					
					mpO.length = event.value.length;
					mpO.width = event.value.width;
					//mpO.handID = event.value.handID;
					
				
					mpO.moveCount ++;
					//trace( mpO.moveCount);
				}
				
				// UPDATE POINT HISTORY 
				MotionPointHistories.historyQueue(event);
		}	
	}
}