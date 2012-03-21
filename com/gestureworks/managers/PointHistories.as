////////////////////////////////////////////////////////////////////////////////
//
//  IDEUM
//  Copyright 2011-2012 Ideum
//  All Rights Reserved.
//
//  GestureWorks
//
//  File:    PointHistories.as
//  Authors:  Ideum
//             
//  NOTICE: Ideum permits you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////
package com.gestureworks.managers 
{
	/**
	 * ...
	 * @author Paul Lacey
	 */
	
	import com.gestureworks.core.GestureWorks;
	import com.gestureworks.core.GestureGlobals;
	import com.gestureworks.core.gw_public;
	import flash.events.TouchEvent;
	
	public class PointHistories 
	{
				
		public static function historyQueue(event:TouchEvent):void
		{
			if(GestureGlobals.gw_public::points[event.touchPointID]){
				var history:Array = GestureGlobals.gw_public::points[event.touchPointID].history;
				history.unshift(historyObject(history[0].x,history[0].y,event));
								
				if (history.length-1>=GestureGlobals.pointHistoryCaptureLength)
				{
					history.pop();
				}
			}
		}
		
		// loads history object and returns value.
		public static function historyObject(X:Number, Y:Number, event:TouchEvent):Object
		{
			var object:Object = new Object();
			//trace("point hist update",GestureGlobals.frameID);
			//trace(event.stageX,event.stageY,event.localX,event.localY )
			
			if (!GestureWorks.supportsTouch || GestureWorks.activeTUIO)
			{
				object.frameID = GestureGlobals.frameID;
				object.x = event.localX;
				object.y = event.localY;
				object.dx = event.localX - X;
				object.dy = event.localY - Y;
			}
			else
			{
				object.frameID = GestureGlobals.frameID;
				object.x = event.stageX;
				object.y = event.stageY;
				object.dx = event.stageX - X;
				object.dy = event.stageY - Y;
			}
			
			return object;
		}
		
	}

}