////////////////////////////////////////////////////////////////////////////////
//
//  IDEUM
//  Copyright 2011-2012 Ideum
//  All Rights Reserved.
//
//  GestureWorks
//
//  File:    TouchMovieClip.as
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
	
	
	/**
	 * The TouchMovieClip class is representative of total multi touch integration into 
	 * the base Flash MovieClip object.  It may act as a fundamental building block for
	 * other applications and non-timeline based user interfaces.
	 */
	
	public class TouchMovieClip extends TouchMovieClipDebugDisplay
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
		
		public function TouchMovieClip():void
		{
			super();
			initTouchMovieClip();
        }
		 
        private function initTouchMovieClip():void 
        {	
			//trace("create touchsprite interface");
			GestureWorks.application.addEventListener(GWEvent.ENTER_FRAME, onEnterFrame);
			this.addEventListener(GWGestureEvent.GESTURELIST_UPDATE, onGestureListUpdate);
			
			
			
			
			
		//	trace("cml item",cml_item, _cml_item);
			
			/*
			if (_cml_item)
			{
				// for cml handled objects
				gestureEvents = false;
				disableNativeTransform = false;
			}
			else {
				// for as3 handled object
				gestureEvents = true;
				disableNativeTransform = true;
			}*/
		}
		////////////////////////////////////////////////////////////
		// Properties: Public
		////////////////////////////////////////////////////////////
		/**
		 * @private
		 */
		private function onEnterFrame(event:GWEvent):void 
		{
			//trace("TouchMovieClip update-----------------------------",GestureGlobals.frameID, N);
			
			updateClusterCount();
			
			if (N==0)
			{	
				updateGestureAnalysis();
				updateTransformation();
				updateGestureValues();
			}
			else updateDebugDisplay();
		}
		
		
		private function onGestureListUpdate(event:GWGestureEvent):void  
		{
			//trace("gesturelist update");
			this.initTimeline();
		}
		
	}
}