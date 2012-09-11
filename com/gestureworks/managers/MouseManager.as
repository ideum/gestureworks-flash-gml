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
	//import com.gestureworks.core.TouchSpriteBase;
	import com.gestureworks.core.GestureWorks;
	import com.gestureworks.core.GestureGlobals;
	import com.gestureworks.core.gw_public;
	import com.gestureworks.utils.ArrangePoints;
	//import com.gestureworks.managers.TouchUpdateManager;
	import com.gestureworks.managers.PointHistories;
	import com.gestureworks.events.GWEvent;
	import com.gestureworks.managers.TouchManager;
	import com.gestureworks.core.CML;
	
	public class MouseManager
	{
		// simulator variables
		public static var currentMousePoint:int;
		private static var hold:Boolean;
		private static var allowMouseStartDrag:Boolean = false;
		private static var mousePointX:Number = 0;
		private static var mousePointY:Number = 0;
		private static var simGraphicColor:uint = 0xFFAE1F;
		private static var simGraphicAlpha:Number = 1;
		private static var simGraphicRadius:Number = 15;
		
		gw_public static function initialize():void
		{
			if (!GestureWorks.hasCML) return;
			
			var debugObjects:XMLList = CML.Objects.DebugKit.DebugLayer;
			
			//trace("dbo",debugObjects)
			
			//for (var i:int = 0; i < debugObjects.length(); i++)
			//{
				//trace(debugObjects[i],debugObjects[i].style.radius,debugObjects[i].style.fill_color,debugObjects[i].style.fill_alpha);
				//if (debugObjects[i].@type == "point_shapes" && debugObjects[i].@displayOn=="true")
				//{
					
					//if (debugObjects[i].@radius != "") simGraphicRadius = 15//debugObjects[i].style.radius;
					//if (debugObjects[i].@fill_color != "") simGraphicColor = 0xFFAE1F//Number(debugObjects[i].style.fill_color);
					//if (debugObjects[i].@fill_alpha != "") simGraphicAlpha = 1//Number(debugObjects[i].style.fill_alpha);
				//}
			//}
		}
						
		// registers mouse point via touchSprite and a touchEvent.  please see TouchSpriteBase
		gw_public static function registerMousePoint(event:TouchEvent):void
		{				
			//trace("register mouse point");
			//TouchManager.points[event.touchPointID].history.unshift(PointHistories.historyObject(event.localX, event.localY, GestureGlobals.frameID, 0, event, TouchManager.points[event.touchPointID]));
			
			//TouchManager.points[event.touchPointID].history.unshift(PointHistories.historyObject(event.localX, event.localY, event, GestureGlobals.frameID));
			
			TouchManager.points[event.touchPointID].history.unshift(PointHistories.historyObject(event));
			
				
			GestureWorks.application.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			GestureWorks.application.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			GestureWorks.application.addEventListener(GWEvent.ENTER_FRAME, mouseFrameHandler);
				
			currentMousePoint = event.touchPointID;
			mousePointX = event.localX;
			mousePointY = event.localY;
			//mousePointX = event.stageX;
			//mousePointY = event.stageY;
		}
		
		private static function onMouseUp(e:MouseEvent):void
		{			
			//trace("Mouse up");
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
				//trace("added circle");
				var circleGraphic:SimulatorGraphic = new SimulatorGraphic(simGraphicColor, simGraphicRadius, simGraphicAlpha);
					circleGraphic.x = mousePointX;
					circleGraphic.y = mousePointY;
					circleGraphic.id = currentMousePoint
					circleGraphic.addEventListener(MouseEvent.MOUSE_DOWN, simulatorGraphicPoint);
				GestureWorks.application.addChild(circleGraphic);
				
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
			
			//mousePointX = e.localX;
			//mousePointY = e.localY;
			
			//trace("on mouse move",mousePointX);
			
			if (!allowMouseStartDrag) return;
			if (!hold || e.target.toString()!="[object SimulatorGraphic]") return;
			
			//var event:TouchEvent = new TouchEvent(TouchEvent.TOUCH_MOVE, true, false, e.target.id, false, mousePointX, mousePointY);
			var event:TouchEvent = new TouchEvent(TouchEvent.TOUCH_MOVE, true, false, 0, false, mousePointX, mousePointY);
			TouchManager.onTouchMove(event);
		}
		
		private static function mouseFrameHandler(e:Event):void
		{
			//trace("MouseEvent moving")
			var event:TouchEvent = new TouchEvent(TouchEvent.TOUCH_MOVE, true, false, currentMousePoint, false, mousePointX, mousePointY);
			TouchManager.onTouchMove(event);
		}
	}
}