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
	import com.gestureworks.utils.Yolotzin;
	import flash.display.Sprite;
	import com.gestureworks.utils.CMLLoader;
	import com.gestureworks.utils.modeScreens.*;
	import com.gestureworks.core.gw_public;
	import com.gestureworks.utils.tgrqzd;
	import flash.events.Event;
	import flash.utils.setInterval;
	import flash.utils.clearInterval;
	import flash.utils.Timer;
	import com.gestureworks.core.GestureWorks;
	import com.gestureworks.utils.KeyListener;
	import com.gestureworks.utils.TimeCompare;
	
	/* 
		
		IMPORTANT NOTE TO DEVELOPER **********************************************
		 
		PlEASE DO NOT ERASE OR DEVALUE ANYTHING WHITHIN THIS CLASS IF YOU DO NOT UNDERSTAND IT'S CURRENT VALUE OR PLACE... PERIOD...
		IF YOU HAVE ANY QUESTIONS, ANY AT ALL. PLEASE ASK PAUL LACEY (paul@ideum.com) ABOUT IT'S IMPORTATANCE.
		IF PAUL IS UNABLE TO HELP YOU UNDERSTAND, THEN PLEASE LOOK AND READ THE ACTUAL CODE FOR IT'S PATH.
		SOMETHINGS AT FIRST MAY NOT BE CLEAR AS TO WHAT THE ACTUAL PURPOSE IS, BUT IT IS VALUABLE AND IS USED IF IT IS CURRENTLY WRITTTEN HERE.
		DO NOT TAKE CODE OUT UNLESS YOUR CHANGES ARE VERIEFIED, TESTED AND CONTINUE TO WORK WITH LEGACY BUILDS !
		
		*/
	
	public class ModeManager extends Sprite
	{
		private var alphaDate:Date = new Date("Tue Dec 20 23:59:59 GMT-0700 2011");
		private var modeImage:Sprite;
		private var waterImage:Sprite;	
		private var timer:Timer = new Timer(5000);
		private var key:String;
		private var timeInterval:uint;
		private var trialTimer:TrialTimer;
		private var _r:*;
		private var ignoreDateCountdown:Boolean = false;
		
		public function ModeManager(r:*, k:*)
		{
			super();
			
			_r = r;
			key = k;
			
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(event:Event = null):void
		{			
			if (!key)
			{
				key = "";
			}
			
			else if (key == "cl3ar") 
			{
				Yolotzin.mode = 2;
				complete();
				return;
			}
			
			else if (key == "ENTER OE KEY")
			{
				ignoreDateCountdown = true;
				GestureWorks.isOpenExibits = true;
				Yolotzin.mode = 0;
				complete();				
				return;
			}
			
			else if (key == "ENTER GW KEY")
			{
				ignoreDateCountdown = true;
				GestureWorks.isOpenExibits = false;
				Yolotzin.mode = 0;
				complete();				
				return;
			}
			
			
			var yolotzin:Yolotzin = new Yolotzin();
			addChild(yolotzin);
			yolotzin.tgrqzd::qftgtopiuqewer(_r, key, CMLLoader.settingsPath);
		}
		
		public function wComplete():void
		{
			var p:* = parent;
			if (p) p.writeComplete = true;
		}
		
		public function complete():void
		{					
			var timerCount:int;
						
			if (key != "cl3ar" && !Yolotzin.clear && Yolotzin.mode !=2 && Yolotzin.mode !=3)
			{
				modeImage = createModeImage(Yolotzin.mode);
				
				var timeOut:Number = Yolotzin.mode;
				
				if (Yolotzin.mode > 2) timeOut = 2;
				
				timerCount = 6000 - (timeOut * 2000);
			}
			
			if (Yolotzin.clear && Yolotzin.mode<2) modeImage = GestureWorks.isOpenExibits ? new OESplash() : new StandardSplash();
			
			if (modeImage) stage.addChild(modeImage);
			if (modeImage) modeImage.x = (stage.stageWidth - modeImage.width) / 2;
			if (modeImage) modeImage.y = (stage.stageHeight - modeImage.height) / 2;
			
			if(Yolotzin.clear && Yolotzin.mode<2) timerCount = 4000 - (Yolotzin.mode * 2000);
			
			timeInterval = setInterval(timerComplete, timerCount);
		}
						
		private function timerComplete():void
		{						
			clearInterval(timeInterval);
			
			if (Yolotzin.mode >= 0)
			{
				if (modeImage) stage.removeChild(modeImage);
				if (modeImage) modeImage = null;
			}
			else
			{
				addEventListener(Event.ENTER_FRAME, keepOnTop);
			}
			
			if (Yolotzin.mode==0)
			{
				trialTimer = new TrialTimer();
				stage.addChild(trialTimer);
				trialTimer.addEventListener(TrialTimer.COMPLETE, trialTimerComplete);
				trialTimer.y = stage.stageHeight - 60;
				trialTimer.x = 20;
				addEventListener(Event.ENTER_FRAME, keepOnTop);
			}
			
			TouchManager.gw_public::initialize();
			//TouchUpdateManager.gw_public::initialize();
			MouseManager.gw_public::initialize();
			ObjectManager.gw_public::initialize();
			EnterFrameManager.gw_public::initialize();
			KeyListener.gw_public::initialize();
			
			var p:* = parent;
			if (p) p.gwComplete = true;
		}
				
		private function keepOnTop(event:Event):void
		{
			// this used to be the water mark on the right, we are no longer using this!
			//if (watermark) stage.setChildIndex( watermark, stage.numChildren - 1 );
			
			if (modeImage) stage.setChildIndex( modeImage, stage.numChildren - 1 );
			if (trialTimer) stage.setChildIndex( trialTimer, stage.numChildren - 1 );
		}
		
		private function trialTimerComplete(event:Event):void
		{
			if (!GestureWorks.supportsTouch) GestureWorks.supportsTouch = true;
			TouchManager.gw_public::deInitialize();
		}
		
		private function createModeImage(mode:int):Sprite
		{
			var sprite:Sprite;
			
			switch (mode)
			{
				case -2:sprite = GestureWorks.isOpenExibits ? new OESplash() : new Unregistered(); break;
				case -1:sprite = GestureWorks.isOpenExibits ? new OESplash() : new Unregistered(); break;
				case 0:sprite = GestureWorks.isOpenExibits ? new OESplash() : new TrialSplash(ignoreDateCountdown); break;
				case 1:sprite = GestureWorks.isOpenExibits ? new OESplash() : new StandardSplash(); break;
				//these no longer relevant -charles
				//case 2:sprite = new ProSplash(); break;
				//case 3:sprite = new SiteSplash(); break;
				//case 4:sprite = new AlphaSplash(); break;
			}
			
			if (sprite) return sprite;
			else return null;
		}	
	}
}