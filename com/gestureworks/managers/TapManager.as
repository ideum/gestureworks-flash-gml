////////////////////////////////////////////////////////////////////////////////
//
//  IDEUM
//  Copyright 2011-2012 Ideum
//  All Rights Reserved.
//
//  GestureWorks
//
//  File:    TapManager.as
//  Authors:  Ideum
//             
//  NOTICE: Ideum permits you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////
package com.gestureworks.managers
{
	import flash.utils.Dictionary;
	import com.gestureworks.core.GestureWorks;
	import com.gestureworks.core.GestureGlobals;
	import flash.events.TouchEvent;
	import flash.display.Sprite;
	import flash.events.Event;
	import com.gestureworks.core.gw_public;
	import com.gestureworks.core.TouchSprite;
	import flash.utils.Timer;
	import flash.events.TimerEvent;

	public class TapManager extends Sprite
	{
		private var tapTimer:Timer;
		
		public function TapManager()
		{
			super();
		}

		gw_public static function registerTap(object:TouchSprite, event:TouchEvent):void
		{
			trace(object,event.touchPointID);
			
			//tapTimer=new Timer(100);
			//tapTimer.addEventListener(TimerEvent.TIMER, tapTimerComplete);
		}

		private static function tapTimerComplete(event:TouchEvent):void
		{
			
		}

		
	}
}