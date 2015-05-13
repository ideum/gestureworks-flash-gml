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
	
	import com.gestureworks.core.CoreSprite;
	import com.gestureworks.core.TouchSprite;
	import com.gestureworks.core.GestureGlobals;
	import com.gestureworks.core.GestureWorks;
	import com.gestureworks.core.GestureWorksCore;
	import com.gestureworks.core.gw_public;
	import com.gestureworks.objects.MotionPointObject;
	
	import com.leapmotion.leap.events.LeapEvent;
	import com.leapmotion.leap.LeapMotion;
	
	import flash.utils.Dictionary;
	
	public class MotionManager 
	{	
		//public static var lmManager:LeapManager
		private static var motion_init:Boolean = false;
		public static var gs:CoreSprite;
		public static var leapEnabled:Boolean = false;
		public static var leapmode:String = "3d"//"2d";
		
		public static var motionArray:Vector.<MotionPointObject>
		public static var motionPointCount:int;
		public static var motionPoints:Dictionary;
		
		gw_public static function initialize():void

		{	
			//if(debug)
				trace("init leap motion device----------------------------------------------------",leapmode,leapEnabled)
			
			//if (GestureWorks.activeMotion){	
			
			//leapmode= "3d_ds"
			
			if (leapEnabled)
			{
				trace("leapmode",leapmode);
				//if (!GestureWorksCore.deviceServer)
				//{
				/*
					// NATIVE LEAP MANAGERS
					if(leapmode == "2d"){
						lmManager = new Leap2DManager();
						lmManager.addEventListener(LeapEvent.LEAPMOTION_FRAME, onFrame);
					}
					if (leapmode == "3d"){
						lmManager = new Leap3DManager();
						lmManager.addEventListener(LeapEvent.LEAPMOTION_FRAME, onFrame);
					}
					*/
				//}
				
				//SERVER LEAP MANAGERS
				if (leapmode == "2d_ds") {
					trace(leapmode)
				}
				if (leapmode == "3d_ds") {
					//trace(leapmode)
					
					// init leap socker mgr
					//leapsocketMgr = new Leap3DSManager;
					
					//lmManager = new Leap3DManager();
					//lmManager.addEventListener(LeapEvent.LEAPMOTION_FRAME, onFrame);
				}
			}
			
			if (!motion_init)
			{
				trace("init motion manager");
				///////////////////////////////////////////////////////////////////////////////////////
				// ref gloabl motion point list
				motionPoints = GestureGlobals.gw_public::motionPoints;
				motionPointCount = GestureGlobals.gw_public::motionPointCount;
				motionArray =  GestureGlobals.gw_public::motionArray;
			}
			//}
		}
		
		gw_public static function deInitialize():void
		{
			//if (leapmode == "2d" && lmManager) {
				//lmManager.removeEventListener(LeapEvent.LEAPMOTION_FRAME, onFrame);
				//Leap2DManager(lmManager).dispose();
				//lmManager = null;
			//}
			//if (leapmode == "3d" && lmManager) {
				//lmManager.removeEventListener(LeapEvent.LEAPMOTION_FRAME, onFrame);
				//Leap3DManager(lmManager).dispose();
				//lmManager = null;
			//}
		}

		public static function onFrame(event:LeapEvent):void 
		{
			//trace("motion frame------------------------------------", event.frame)
			GestureGlobals.motionFrameID += 1;
		}
		
		public static function onMotionBeginPoint(pt:MotionPointObject):void
		{			
			//trace("motion point begin, motionManager",event.value.motionPointID);
			// create new point object
			
			//if(pt){
			var mpO:MotionPointObject = pt;
				mpO.id = motionPointCount; 
				mpO.phase = "begin";
				mpO.handID = pt.handID;
					
				//ADD TO GLOBAL MOTION SPRITE POINT LIST
				if (!motionArray) motionArray = new Vector.<MotionPointObject>
				motionArray.push(mpO);
				motionPointCount++;
				
				//trace(pt.motionPointID,motionPoints[pt.motionPointID])
				
				// ASSIGN POINT OBJECT WITH GLOBAL POINT LIST DICTIONARY
				motionPoints[pt.motionPointID] = mpO;//as MotionPointObject
				 //GestureGlobals.gw_public::motionPoints[pt.motionPointID]= mpO
			//}
		}
		

		public static function onMotionEndPoint(motionPointID:int):void
		{
			//trace("Motion point End, motionManager", event.value.motionPointID)
			var mpO:MotionPointObject = motionPoints[motionPointID] as MotionPointObject;
			
			if (mpO)
			{
					mpO.phase = "end";
					// REMOVE POINT FROM LOCAL LIST
					motionArray.splice(mpO.id, 1);
					// REDUCE LOACAL POINT COUNT
					motionPointCount--;
					
					// UPDATE POINT ID 
					for (var i:uint = 0; i < motionArray.length; i++)
					{
						motionArray[i].id = i;
					}
					// DELETE FROM GLOBAL POINT LIST
					delete motionPoints[motionPointID] as MotionPointObject;
			}
			//trace("should be removed",mpoints[motionPointID], motionSprite.motionPointCount, motionSprite.cO.motionArray.length);
			//trace("motion point tot",motionSprite.motionPointCount)
		}
		
		public static function onMotionMovePoint(pt:MotionPointObject):void
		{			
			//  CONSOLODATED UPDATE METHOD FOR POINT POSITION AND TOUCH OBJECT CALCULATIONS
			//trace("motion move/Update event, motionManager", event.value.motionPointID);
			
			var mpO:MotionPointObject = motionPoints[pt.motionPointID] as MotionPointObject;
			
				if (mpO)
				{	
					//trace(event.value.position.x, event.value.position.y,event.value.position.z)
					//mpO.id  = event.value.id;
					//mpO.motionPointID  = event.value.motionPointID;
					//mpO.handID = pt.handID;
					
					mpO.position = pt.position;
					mpO.direction = pt.direction;
					mpO.normal = pt.normal;
					mpO.velocity = pt.velocity;
					mpO.sphereRadius = pt.sphereRadius;
					mpO.sphereCenter = pt.sphereCenter;
					mpO.length = pt.length;
					mpO.width = pt.width;
					mpO.moveCount ++;
					mpO.phase = "update";
					mpO.handID = pt.handID;
					
					mpO.screen_direction = pt.screen_direction;
					mpO.screen_position = pt.screen_position;
					mpO.screen_normal = pt.screen_normal;
					//trace( mpO.moveCount);
					
					
					//mpO.joint_0 = pt.joint_0;
					//mpO.joint_1 = pt.joint_1;
					//mpO.joint_2 = pt.joint_2;
					//mpO.joint_3 = pt.joint_3;
					
				}
		}
		
		
	}
}