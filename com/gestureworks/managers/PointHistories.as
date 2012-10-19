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
				
				//point.history.unshift(historyObject(point.history[0].x, point.history[0].y, point.history[0].frameID, point.moveCount, event, point));
				
				//point.history.unshift(historyObject(point.history[0].x, point.history[0].y, event, point.history[0].frameID));
				point.history.unshift(historyObject(event));
				
				//trace(history[0].moveCount,GestureGlobals.gw_public::points[event.touchPointID].moveCount)
								
				if ((point.history.length>1)&&point.history.length-1>=GestureGlobals.pointHistoryCaptureLength)
				{
					point.history.pop();
				}
			}
		}
		
		// loads history object and returns value.
		//public static function historyObject(X:Number, Y:Number, event:TouchEvent, FrameID:int):Object
	//	public static function historyObject(X:Number, Y:Number, FrameID:int, moveCount:int, event:TouchEvent, point:PointObject):Object
		
		///public static function historyObject(X:Number, Y:Number, event:TouchEvent, FrameID:int):Object
		public static function historyObject(event:TouchEvent):PointObject
		{
			//var c0:Number = 1 / moveCount;
			var point:PointObject = GestureGlobals.gw_public::points[event.touchPointID]
			var pt:PointObject = new PointObject();
			
			var currentFrameID:int = GestureGlobals.frameID
			var FrameID:int = 0;
			
			//trace(" --point process");
			
			if (point.history.length>=1)//(point.history[0]) 
			{ 
				//trace("history")
				FrameID = point.history[0].frameID;
				pt.frameID = currentFrameID;
				
				//trace(FrameID,pt.frameID);
				
				if (!GestureWorks.supportsTouch || GestureWorks.activeTUIO)
				{
					pt.x = event.localX;
					pt.y = event.localY;
					pt.w = event.sizeX;
					pt.h = event.sizeY;
					pt.dx = event.localX - point.history[0].x;
					pt.dy = event.localY - point.history[0].y;
					//trace(pt.x,pt.y,pt.dx,pt.dy);
				}
				else
				{
					pt.x = event.stageX;
					pt.y = event.stageY;
					pt.w = event.sizeX;
					pt.h = event.sizeY;
					pt.dx = event.stageX - point.history[0].x;
					pt.dy = event.stageY - point.history[0].y;
					// NO SUB-PIXEL RESOLUTION
					//trace(pt.x,pt.y,pt.dx,pt.dy,event.stageX,event.stageY);
				}	
				//trace(pt.dx,pt.dy,event.stageY,point.history[0].y,point.history[1].y,point.history[3].y)
			}
			
			
			else {
				// for initial values
				//trace("zero delta")
				pt.frameID = currentFrameID;
				pt.dx = 0;
				pt.dy = 0;
				
				if (!GestureWorks.supportsTouch || GestureWorks.activeTUIO)
				{
					pt.x = event.localX;
					pt.y = event.localY;
					pt.w = event.sizeX;
					pt.h = event.sizeY;
				}
				else
				{
					pt.x = event.stageX;
					pt.y = event.stageY;
					pt.w = event.sizeX;
					pt.h = event.sizeY;
				}
			}
			
			
			
			
			
			if (FrameID == currentFrameID) 
			{
				point.DX += pt.dx;
				point.DY += pt.dy;
				//point.moveCount ++;
			}
			else {
				point.DX = pt.dx;
				point.DY = pt.dy;
				point.moveCount = 1;
			}
			
			//var rad:Number = Math.max(event.sizeX, event.sizeY);
			//trace("point augmentation data",event.sizeX,event.sizeY, rad);
			
			return pt;
		}
		
	}

}