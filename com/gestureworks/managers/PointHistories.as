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
			
			if (point) {
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
				
				pt.x = event.stageX;
				pt.y = event.stageY;
				pt.w = event.sizeX;
				pt.h = event.sizeY;
				pt.dx = event.stageX - point.history[0].x;
				pt.dy = event.stageY - point.history[0].y;
					// NO SUB-PIXEL RESOLUTION
					//trace(pt.x, pt.y, pt.dx, pt.dy, event.stageX, event.stageY, event.pressure);
					
					//var sx:Number = event.sizeX * Math.exp(90)
					//var sy:Number = event.sizeY*Math.exp(90)
					//trace(event.sizeX,event.sizeY, event.pressure, sx,sy);
				//trace(pt.dx,pt.dy,event.stageY,point.history[0].y,point.history[1].y,point.history[3].y)
			}
			
			
			else {
				// for initial values
				//trace("zero delta")
				pt.frameID = currentFrameID;
				pt.dx = 0;
				pt.dy = 0;
				
				pt.x = event.stageX;
				pt.y = event.stageY;
				pt.w = event.sizeX;
				pt.h = event.sizeY;
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