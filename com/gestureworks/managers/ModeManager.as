////////////////////////////////////////////////////////////////////////////////
//
//  IDEUM
//  Copyright 2011-2012 Ideum
//  All Rights Reserved.
//
//  GestureWorks
//
//  File:    ModeManager.as
//  Authors:  Ideum
//             
//  NOTICE: Ideum permits you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

package com.gestureworks.managers 
{
	import com.gestureworks.core.*;
	import com.gestureworks.utils.*;
	import com.gestureworks.utils.modeScreens.*;
	import flash.display.*;
	import flash.events.*;
	import flash.utils.*;
	
	public class ModeManager extends Sprite
	{
		private static var isOpenExhibits:Boolean = true;
		private static var isTrial:Boolean = false;

		private var modeImage:Sprite;
		private var splashTime:int = 5000;
		private var timer:Timer = new Timer(splashTime);
		private var trialTimer = new TrialTimer;
		
		public function ModeManager()
		{
			super();
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private final function init(event:Event = null):void
		{
			if (isOpenExhibits) {
				modeImage = new OESplash;
				configModeImage();
			}
			else if (isTrial) {
				modeImage = new StandardSplash;
				configModeImage();
				stage.addChild(trialTimer);
				trialTimer.addEventListener(TrialTimer.COMPLETE, trialTimerComplete);
				trialTimer.y = 20
				trialTimer.x = 20;
				stage.addEventListener(Event.ENTER_FRAME, keepTTOnTop);					
			}
			else {
				load();
			}
		}
		
		private final function configModeImage():void
		{
			stage.addChild(modeImage);
			modeImage.x = (stage.stageWidth - modeImage.width) / 2;
			modeImage.y = (stage.stageHeight - modeImage.height) / 2;
			stage.addEventListener(Event.ENTER_FRAME, keepSSOnTop);
			timer.addEventListener(TimerEvent.TIMER, onSplashComplete);
			timer.start();		
		}
		
		private final function onSplashComplete(e:TimerEvent):void
		{
			stage.removeEventListener(Event.ENTER_FRAME, keepSSOnTop);	
			if (isTrial) {
				modeImage.alpha = .25;
			}
			else {
				stage.removeChild(modeImage);
				stage.addEventListener(Event.REMOVED_FROM_STAGE, onInvalidRemove);
			}
			timer.stop();			
			timer.removeEventListener(TimerEvent.TIMER, onSplashComplete);
			modeImage = null;
			load();
		}
		
		private final function load():void
		{									
			if (isTrial) return;
			
			var p:* = parent;
			if (p) p.gwComplete = true;
			
			// initialize input managers
			TouchManager.gw_public::initialize();
			MouseManager.gw_public::initialize();
			ObjectManager.gw_public::initialize();
			EnterFrameManager.gw_public::initialize();
			KeyListener.gw_public::initialize();
			
			// add devices here
			MotionManager.gw_public::initialize();
			SensorManager.gw_public::initialize();
		}

		private final function onInvalidRemove(event:Event):void
		{
			throw new Error("Illegal attempt to remove splash screen in trial mode.");
		}		
		
		private final function keepSSOnTop(event:Event):void
		{
			stage.setChildIndex( modeImage, stage.numChildren - 1 );
		}

		private final function keepTTOnTop(event:Event):void
		{
			stage.setChildIndex( trialTimer, stage.numChildren - 1 );
		}
		
		private final function trialTimerComplete(event:Event):void
		{
			if (!GestureWorks.activeNativeTouch) 
				GestureWorks.activeNativeTouch = false;
			TouchManager.gw_public::deInitialize();
			throw new Error("Gestureworks Flash Trial has expired");
		}

	}
}