////////////////////////////////////////////////////////////////////////////////
//
//  IDEUM
//  Copyright 2011-2012 Ideum
//  All Rights Reserved.
//
//  GestureWorks
//
//  File:    MouseManager.as
//  Authors:  Ideum
//             
//  NOTICE: Ideum permits you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////
package com.gestureworks.managers
{
	import com.gestureworks.utils.SimulatorGraphic;
	import flash.display.DisplayObject;
	import flash.utils.Dictionary;
	import flash.events.TouchEvent;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.display.Shape;
	import flash.display.Sprite;
	import com.gestureworks.core.TouchSprite;
	import com.gestureworks.core.TouchSpriteBase;
	import com.gestureworks.core.GestureWorks;
	import com.gestureworks.core.GestureGlobals;
	import com.gestureworks.core.gw_public;
	import com.gestureworks.utils.ArrangePoints;
	import com.gestureworks.managers.TouchUpdateManager;
	import com.gestureworks.managers.PointHistories;
	import com.gestureworks.events.GWEvent;
	import com.gestureworks.managers.TouchManager;
	import com.gestureworks.core.CML;
	
	public class MouseManager
	{
		// simulator variables
		public static var currentMousePoint:int;
		private static var hold:Boolean;
		private static var allowMouseStartDrag:Boolean;
		private static var mousePointX:Number = 0;
		private static var mousePointY:Number = 0;
		private static var simGraphicColor:uint=0x009966;
		private static var simGraphicAlpha:Number = .6;
		private static var simGraphicRadius:int=15;
		
		gw_public static function initialize():void
		{
			if (!GestureWorks.hasCML) return;
			
			var debugObjects:XMLList = CML.Objects.DebugKit.DebugLayer;
			for (var i:int = 0; i < debugObjects.length(); i++)
			{
				if (debugObjects[i].@type == "point_shapes" && debugObjects[i].@displayOn=="true")
				{
					if (debugObjects[i].@radius != "") simGraphicRadius = int(debugObjects[i].@radius);
					if (debugObjects[i].@fill_color != "") simGraphicColor = debugObjects[i].@fill_color;
					if (debugObjects[i].@fill_alpha != "") simGraphicAlpha = Number(debugObjects[i].@fill_alpha);
				}
			}
		}
						
		// registers mouse point via touchSprite and a touchEvent.  please see TouchSpriteBase
		gw_public static function registerMousePoint(event:TouchEvent):void
		{	
			TouchManager.points[event.touchPointID].history.unshift(PointHistories.historyObject(event.localX, event.localY, event));
				
			GestureWorks.application.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			GestureWorks.application.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			GestureWorks.application.addEventListener(GWEvent.ENTER_FRAME, mouseFrameHandler);
				
			currentMousePoint = event.touchPointID;
			mousePointX = event.localX;
			mousePointY = event.localY;
			
			TouchManager.count++;
			TouchManager.isTouching = true;
		}
		
		private static function onMouseUp(e:MouseEvent):void
		{			
			if (hold)
			{
				if (GestureWorks.isShift) 
				{
					if (e.target.toString() == "[object SimulatorGraphic]")
					{
						GestureWorks.application.removeChild(e.target as DisplayObject);
						var eventHere:TouchEvent = new TouchEvent(TouchEvent.TOUCH_MOVE, true, false, e.target.id, false, mousePointX, mousePointY);
						TouchManager.onTouchUp(eventHere);
					}
				}
				else
				{
					if (allowMouseStartDrag)
					{
						if (e.target.toString() == "[object SimulatorGraphic]")
						{
							e.target.stopDrag();
							GestureWorks.application.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
						}
					}
				}
				
				hold = false;
				return;
			}
			
			GestureWorks.application.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			GestureWorks.application.removeEventListener(GWEvent.ENTER_FRAME, mouseFrameHandler);
			
			if (GestureWorks.isShift)
			{
				var circleGraphic:SimulatorGraphic = new SimulatorGraphic(simGraphicColor, simGraphicRadius, simGraphicAlpha);
				circleGraphic.x = mousePointX;
				circleGraphic.y = mousePointY;
				circleGraphic.id=currentMousePoint
				GestureWorks.application.addChild(circleGraphic);
				circleGraphic.addEventListener(MouseEvent.MOUSE_DOWN, simulatorGraphicPoint);
				return;
			}
			
			var event:TouchEvent = new TouchEvent(TouchEvent.TOUCH_MOVE, true, false, currentMousePoint, false, mousePointX, mousePointY);
			TouchManager.onTouchUp(event);
		}
		
		private static function simulatorGraphicPoint(event:MouseEvent):void
		{
			hold = true;
			if (!allowMouseStartDrag) return;
			
			event.target.startDrag();
			GestureWorks.application.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
		}
		
		private static function onMouseMove(e:MouseEvent):void
		{
			mousePointX = e.stageX;
			mousePointY = e.stageY;
			
			if (!allowMouseStartDrag) return;
					
			if (!hold || e.target.toString()!="[object SimulatorGraphic]") return;
			
			var event:TouchEvent = new TouchEvent(TouchEvent.TOUCH_MOVE, true, false, e.target.id, false, mousePointX, mousePointY);
			TouchManager.onTouchMove(event);
		}
		
		private static function mouseFrameHandler(e:Event):void
		{
			var event:TouchEvent = new TouchEvent(TouchEvent.TOUCH_MOVE, true, false, currentMousePoint, false, mousePointX, mousePointY);
			TouchManager.onTouchMove(event);
		}
	}
}