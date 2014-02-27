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
	//import com.gestureworks.events.GWTouchEvent;
	import com.gestureworks.objects.TouchPointObject;
	import com.gestureworks.core.GestureWorks;
	import com.gestureworks.core.GestureGlobals;
	import com.gestureworks.core.gw_public;
	//import flash.events.TouchEvent;
	//import flash.geom.Point;
	
	public class TouchPointHistories 
	{
		private static var point:TouchPointObject //= new TouchPointObject();
		private static var pt:TouchPointObject //= new TouchPointObject();
		//private static var currentFrameID:int;
		//private static var FrameID:int;
		
		public static function historyQueue(point):void//event:GWTouchEvent
		{
			//point = GestureGlobals.gw_public::touchPoints[event.touchPointID]
			
			if (point) 
			{
				point.history.unshift(historyObject(point));			
				if (point.history.length-1>=GestureGlobals.pointHistoryCaptureLength) point.history.pop();
			}
		}

		public static function historyObject(point:TouchPointObject):TouchPointObject//event:GWTouchEvent
		{
			//trace(pt.moveCount)
			
			pt = new TouchPointObject;
				pt.position = point.position;
				pt.size = point.size;
				pt.pressure = point.pressure;
				pt.area = point.area;
				pt.radius = point.radius;
				pt.moveCount ++;
				
				if (point.history.length >= 1) 
				{
					pt.dx = point.position.x - point.history[0].position.x;
					pt.dy = point.position.y - point.history[0].position.y;
					pt.dz = point.position.z - point.history[0].position.z;
					// NO SUB-PIXEL RESOLUTION
					//trace(pt.x, pt.y, pt.dx, pt.dy, event.stageX, event.stageY, event.pressure);
				}
				else {
					pt.dx = 0;
					pt.dy = 0;
					pt.dz = 0;
				}
				
			return pt;
		}
		
	}

}