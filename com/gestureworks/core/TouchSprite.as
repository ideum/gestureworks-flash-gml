////////////////////////////////////////////////////////////////////////////////
//
//  IDEUM
//  Copyright 2011-2012 Ideum
//  All Rights Reserved.
//
//  GestureWorks
//
//  File:    TouchSprite.as
//  Authors:  Ideum
//             
//  NOTICE: Ideum permits you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////
package com.gestureworks.core
{
	import com.gestureworks.events.GWEvent;
	import com.gestureworks.events.GWGestureEvent;
	import flash.display.Stage;
	
	import flash.events.*;
	
	//import flash.events.TimerEvent
	
	import flash.utils.Timer;
	import flash.system.System;
	
	/**
	 * The TouchSprite class is representative of total multi touch integration into 
	 * the base Flash Sprite object.  It may act as a fundamental building block for
	 * other applications and non-timeline based user interfaces.
	 */
	
	public class TouchSprite extends TouchSpriteDebugDisplay
	{
		/**
		* Default constructor.
		*/
		
		/**
		* This method is called when the default constructor has finished
		* and before this object is attached to the stage, or its 
		* prospective parent.  You may override this method when creating a
		* subclass of TouchObject to ensure specific paramaters are defined
		* and established.
		* 
		* <p>You do not call this method directly, GestureWorks calls the
		* <code>preinitialize()</code> method in response to object instantiation.</p>
		*/
		
		public function TouchSprite():void
		{
			super();
			initTouchSprite();
	
        }
		 
        private function initTouchSprite():void 
        {	
			//trace("create touchsprite interface");
			GestureWorks.application.addEventListener(GWEvent.ENTER_FRAME, onEnterFrame, false, 0, true);
			
			//if (GestureWorks.supportsTouch) addEventListener(TouchEvent.TOUCH_BEGIN, onTouchDown, false, 0, true); 
			
			this.addEventListener(GWGestureEvent.GESTURELIST_UPDATE, onGestureListUpdate);
			
			//var myTimer:Timer = new Timer(20, 0);
				//myTimer.addEventListener(TimerEvent.TIMER, timerHandler, false,10,false);
				//myTimer.start();
		}
		////////////////////////////////////////////////////////////
		// Properties: Private
		////////////////////////////////////////////////////////////
		/**
		 * @private
		 */
		
		private function onEnterFrame(event:GWEvent):void  
		{
			if (trace_debug_mode)  trace("TouchSprite update-----------------------------",GestureGlobals.frameID, N,System.totalMemory);
			
			updateClusterCount();
			
			if (N==0)
			{	
				updateGestureAnalysis();
				updateTransformation();
				updateGestureValues();
			}
			else 
			{
			//updateClusterAnalysis();
			//updateProcessing();
			//updateGestureAnalysis();
			//updateTransformation();
			
			updateDebugDisplay();
			}
		}
		
		/*
		private function timerHandler(event:TimerEvent):void
		{
		  
			if (N!=0)
			{
				//trace("sprite timer");
				updateClusterAnalysis();
				updateProcessing();
				updateGestureAnalysis();
				updateTransformation();
				updateDebugDisplay();
				//event.updateAfterEvent();
			}
		}*/
		
		private function onGestureListUpdate(event:GWGestureEvent):void  
		{
			//trace("gesturelist update");
			this.initTimeline();
		}
		
		//override public function onTouchDown(event:TouchEvent):void
		//{
			//trace("t down		", "TARGET:	", event.target.name, "		CURRENT TARGET:	", event.currentTarget.name);
			
			// assign touchpoint cluster
			//assignEvent(event);
		//}
		
	}
}