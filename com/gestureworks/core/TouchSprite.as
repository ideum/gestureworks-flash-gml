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
	//import flash.display.Stage;
	
	import flash.events.*;
	
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
			// move to initGestures
			this.addEventListener(GWGestureEvent.GESTURELIST_UPDATE, onGestureListUpdate); 
		}
		
		
		private function initGestures(event:Event):void  
		{
			// automatically set up gesture list
			// using gesture listeners
			// match to type names in GML
			
			//var gestureEventListener:Boolean = false;
			
			//if (hasEventListener(GWGestureEvent.EVENT)) trace("gestures");
			
			if (hasEventListener(GWGestureEvent.DRAG)) trace("has drag listener");
			if (hasEventListener(GWGestureEvent.SCALE)) trace("has scale listener");
			if (hasEventListener(GWGestureEvent.ROTATE)) trace("has rotate listener");
			
			//if (hasEventListener(GWGestureEvent.CUSTOM.NEW_GESTURE)) trace("has custom listener");
			//if (hasEventListener(GWGestureEvent.CUSTOM.SEED_GESTURE)) trace("has seed listener");
			//if (hasEventListener(GWGestureEvent.CUSTOM.EXAMPLE_GESTURE)) trace("has example listener");
			
			//if (hasEventListener(GWGestureEvent.CUSTOM.N_DRAG)) trace("has n-drag listener");
			//if (hasEventListener(GWGestureEvent.CUSTOM.THREE_FINGER_DRAG)) trace("has 3-finger-drag listener");
			
			if (hasEventListener(GWGestureEvent.GML.NEW_GESTURE)) trace("has custom listener");
			if (hasEventListener(GWGestureEvent.GML.SEED_GESTURE)) trace("has seed listener");
			if (hasEventListener(GWGestureEvent.GML.EXAMPLE_GESTURE)) trace("has example listener");
			
			if (hasEventListener(GWGestureEvent.GML.N_DRAG)) trace("has n-drag listener");
			if (hasEventListener(GWGestureEvent.GML.THREE_FINGER_DRAG)) trace("has 3-finger-drag listener");
			
			
			//TEST THIS
			//if(willTrigger)
			
			
			// dispatch gesture list update event
			
		}
		
		////////////////////////////////////////////////////////////
		// Properties: Private
		////////////////////////////////////////////////////////////
		/**
		 * @private
		 */
		
		private function onGestureListUpdate(event:GWGestureEvent):void  
		{
			//trace("gesturelist update");
			this.initTimeline();
		}
		
	}
}