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
	import adobe.utils.CustomActions;
	import com.gestureworks.core.DisplayList;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.TouchEvent;
	import com.gestureworks.managers.TouchManager;
	import flash.utils.getQualifiedSuperclassName;
	
	public class SocketTouchManager extends Sprite
	{
		private static var displayList:Array = DisplayList.array;
		
		public static function add(object:Object):void
		{			
			/*this is the main hit test for the framework.  It is a work in progress and should be optimized and made as flexible as can be.*/
			
			var displayObject:*;
			var index:int = 0;
			
			// Loop through the gestureworks.core.DisplayList in order to find the HitTest.
			for (var i:int = 0; i < displayList.length; i++)
			{
				if (displayList[i].hasOwnProperty("onTouchDown"))
				{
					if (displayList[i].hitTestPoint(object.x, object.y, true))
					{						
						// if the display list object is a TouchContainer, index for accessing the top TouchContainer.  if statement maybe better like: if(displayList[i] as TouchContainer)
						if (getQualifiedSuperclassName(displayList[i]) == "com.gestureworks.cml.element::TouchContainer")
						{							
							// determine top index for all TouchContainers that might be in contact with the hit test.
							if ((displayList[i].parent.getChildIndex((displayList[i]))) >= index)
							{
								index = displayList[i].parent.getChildIndex((displayList[i]));
								
								displayObject = displayList[i];
							}
						}
						else
						{
							// if the display object is not a TouchContainer, it does not require indexing.
							displayObject = displayList[i];
						}
					}
				}
			}
									
			if (!displayObject) return;
			
			// If displayObject exists, pass it a TouchEvent to it's onTouchDown handler.
			var event:TouchEvent = new TouchEvent(TouchEvent.TOUCH_BEGIN, true, false, object.touchPointID, false, object.x, object.y);
			displayObject.onTouchDown(event);
			
			// This if statement deals with buttons that have a property handler downHandler.
			if (displayObject.hasOwnProperty("downHandler")) displayObject.downHandler();
		}
		
		public static function update(object:Object):void
		{
			var event:TouchEvent = new TouchEvent(TouchEvent.TOUCH_MOVE, true, false, object.touchPointID, false, object.x, object.y);
			TouchManager.onTouchMove(event);
		}
		
		public static function remove(object:Object):void
		{
			var event:TouchEvent = new TouchEvent(TouchEvent.TOUCH_END, true, false, object.touchPointID, false, object.x, object.y);
			TouchManager.onTouchUp(event);
		}
	}
}