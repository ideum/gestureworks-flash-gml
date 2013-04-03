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
	import com.gestureworks.core.gw_public;
	import com.gestureworks.core.TouchSprite;
	import com.leapmotion.leap.events.LeapEvent;
	import com.leapmotion.leap.LeapMotion;
	
	public class MotionManager 
	{	

		public static var lmManager:LeapManager
		public static var motionSprite:TouchSprite;
		
		gw_public static function initialize():void
		{						
			lmManager = new Leap2DManager();
			lmManager.addEventListener(LeapEvent.LEAPMOTION_FRAME, onFrame);
			
			// create gloabal motion sprite
			motionSprite = new TouchSprite();
			GestureGlobals.motionSpriteID = motionSprite.touchObjectID;
		}
		
		public static function onFrame(event:LeapEvent):void {
			//trace("ms frame------------------------------------", event.frame)
			// push frame data to global motionsprite
				motionSprite.cO.motionArray = event.frame
				
				// update motion frameID
				GestureGlobals.motionframeID += 1;
				
				//UPDATE CLUSTER HISTORIES
				ClusterHistories.historyQueue(motionSprite.touchObjectID);
			
			/////////////////////////////////
			// update main gesture pipe
			/////////////////////////////////
				
			//if (ms.tc) ms.updateMotionClusterAnalysis()
			if (motionSprite.tc) motionSprite.updateClusterAnalysis()
			if (motionSprite.tp) motionSprite.tp.processPipeline();
			if (motionSprite.tg) motionSprite.tg.manageGestureEventDispatch();
			if (motionSprite.tt){
				motionSprite.tt.transformManager();
				motionSprite.tt.updateLocalProperties();
			}			
		}
		
		
	}
}