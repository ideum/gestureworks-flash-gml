﻿////////////////////////////////////////////////////////////////////////////////
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
	import com.gestureworks.core.GestureWorks;
	import com.gestureworks.core.gw_public;
	import com.gestureworks.events.GWEvent;
	import com.gestureworks.managers.TouchManager;
	import com.gestureworks.utils.SimulatorGraphic;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TouchEvent;
	
	public class MouseManager
	{
		private static var currentMousePoint:int;
		private static var mousePointX:Number = 0;
		private static var mousePointY:Number = 0;
		private static var hold:Boolean;
		private static var allowMouseStartDrag:Boolean = false;
		
		
		/**
		 * Sets the simulator graphic color.
		 * @default 0xFFAE1F
		 */
		public static var graphicColor:uint = 0xFFAE1F;
		
		/**
		 * Sets the simulator graphic alpha.
		 * @default 1.0
		 */
		public static var graphicAlpha:Number = 1;
		
		/**
		 * Sets the simulator graphic radius
		 * @default 15
		 */
		public static var graphicRadius:Number = 15;
				
		
		
		// initialization method, call through to TouchManager
		gw_public static function initialize():void
		{	
			TouchManager.gw_public::initialize();
		}
			
		
		
		/**
		 * @private
		 */
		gw_public static function registerMousePoint(event:TouchEvent):void
		{							
			GestureWorks.application.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			GestureWorks.application.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			GestureWorks.application.addEventListener(GWEvent.ENTER_FRAME, mouseFrameHandler);			
			
			TouchManager.gw_public::registerTouchPoint(event);
		
			currentMousePoint = event.touchPointID;
			mousePointX = event.localX;
			mousePointY = event.localY;
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
				var circleGraphic:SimulatorGraphic = new SimulatorGraphic(graphicColor, graphicRadius, graphicAlpha);
					circleGraphic.x = mousePointX;
					circleGraphic.y = mousePointY;
					circleGraphic.id = currentMousePoint
					circleGraphic.addEventListener(MouseEvent.MOUSE_DOWN, simulatorGraphicPoint);
				GestureWorks.application.addChild(circleGraphic);
				
				return;
			}
			
			var event:TouchEvent = new TouchEvent(TouchEvent.TOUCH_END, true, false, currentMousePoint, false, mousePointX, mousePointY);
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
			
			var event:TouchEvent = new TouchEvent(TouchEvent.TOUCH_MOVE, true, false, 0, false, mousePointX, mousePointY);
			TouchManager.onTouchMove(event);
		}
		
		private static function mouseFrameHandler(e:Event):void
		{
			var event:TouchEvent = new TouchEvent(TouchEvent.TOUCH_MOVE, true, false, currentMousePoint, false, mousePointX, mousePointY);
			TouchManager.onTouchMove(event);
		}
	}
}