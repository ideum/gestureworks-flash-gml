////////////////////////////////////////////////////////////////////////////////
//
//  IDEUM
//  Copyright 2011-2012 Ideum
//  All Rights Reserved.
//
//  GestureWorks
//
//  File:   SocketTouchManager.as
//  Authors:  Ideum
//             
//  NOTICE: Ideum permits you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

package com.gestureworks.managers
{
	import com.gestureworks.core.*;
	import com.gestureworks.managers.*;
	import flash.display.*;
	import flash.events.*;
	
	public class SocketTouchManager extends Sprite
	{		
		public static function add(object:Object):void
		{
			/*
			var event:TouchEvent = new TouchEvent(TouchEvent.TOUCH_BEGIN, true, false, object.touchPointID, false, object.x, object.y);			
			var hitObject:DisplayObject = HitTestManager.instance.hitTest(GestureWorks.application, object.x, object.y, "down");
			if (hitObject && hitObject is TouchSprite)
				TouchSprite(hitObject).onTouchDown(event, hitObject);
			*/
		}
		
		public static function update(object:Object):void
		{
			
			//var hitObject:DisplayObject = HitTestManager.instance.hitTest(GestureWorks.application, object.x, object.y, "move");									
			var event:TouchEvent = new TouchEvent(TouchEvent.TOUCH_MOVE, true, false, object.touchPointID, false, object.x, object.y);
			TouchManager.onTouchMove(event);
			
		}
		
		public static function remove(object:Object):void
		{
			
			//var hitObject:DisplayObject = HitTestManager.instance.hitTest(GestureWorks.application, object.x, object.y, "up");						
			var event:TouchEvent = new TouchEvent(TouchEvent.TOUCH_END, true, false, object.touchPointID, false, object.x, object.y);
			TouchManager.onTouchUp(event);
			
		}		
	}
}