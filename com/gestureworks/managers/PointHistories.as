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
	import com.gestureworks.objects.PointObject;
	import com.gestureworks.core.GestureWorks;
	import com.gestureworks.core.GestureGlobals;
	import com.gestureworks.core.gw_public;
	import flash.events.TouchEvent;
	import flash.geom.Point;
	
	public class PointHistories 
	{
				
		public static function historyQueue(event:TouchEvent):void
		{
			var point:PointObject = GestureGlobals.gw_public::points[event.touchPointID]
			
			//if () {
			if (point) {
				//var history:Array = GestureGlobals.gw_public::points[event.touchPointID].history;
				//point.history.unshift(historyObject(point.history[0].x, point.history[0].y, event, point.history[0].frameID));
				
				point.history.unshift(historyObject(point.history[0].x, point.history[0].y, point.history[0].frameID, point.moveCount, event));
				
				//trace(history[0].moveCount,GestureGlobals.gw_public::points[event.touchPointID].moveCount)
								
				if (point.history.length-1>=GestureGlobals.pointHistoryCaptureLength)
				{
					point.history.pop();
				}
			}
		}
		
		// loads history object and returns value.
		//public static function historyObject(X:Number, Y:Number, event:TouchEvent, FrameID:int):Object
		public static function historyObject(X:Number, Y:Number, FrameID:int,moveCount:int,event:TouchEvent):Object
		{
			//var c0:Number = 1 / moveCount;
			var point:PointObject = GestureGlobals.gw_public::points[event.touchPointID]
			var pt:Object = new Object();
			var currentFrameID:int = GestureGlobals.frameID
			//trace("point hist update",GestureGlobals.frameID);
			//trace(event.stageX,event.stageY,event.localX,event.localY )

				if (!GestureWorks.supportsTouch || GestureWorks.activeTUIO)
				{
					pt.frameID = currentFrameID;
					pt.x = event.localX;
					pt.y = event.localY;
					pt.dx = event.localX - X;
					pt.dy = event.localY - Y;
				}
				else
				{
					pt.frameID = currentFrameID;
					pt.x = event.stageX;
					pt.y = event.stageY;
					pt.dx = event.stageX - X;
					pt.dy = event.stageY - Y;
				}

			
			if (FrameID == currentFrameID) 
			{
				point.DX += pt.dx;
				point.DY += pt.dy;
			}
			else {
				point.DX = pt.dx;
				point.DY = pt.dy;
				point.moveCount = 1;
			}
			
			return pt;
		}
		
	}

}