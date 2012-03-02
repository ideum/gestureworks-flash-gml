////////////////////////////////////////////////////////////////////////////////
//
//  IDEUM
//  Copyright 2011-2012 Ideum
//  All Rights Reserved.
//
//  GestureWorks
//
//  File:    TrialTimer.as
//  Authors:  Ideum
//             
//  NOTICE: Ideum permits you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////
package com.gestureworks.utils.modeScreens 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import com.gestureworks.core.GestureWorks;
	
	public class TrialTimer extends Sprite 
	{
		public static var COMPLETE:String = "complete trial timer";
		private var timerCompleteAmount:Number = 3600;
		private var textString:String;
		private var finalString:String;
		private var textColor:uint = 0x666666;
		private var textSize:int = 18;
		private var timer:Timer;
		private var count:int;
		private var timerText:SplashText;
		
		public function TrialTimer() 
		{
			textString = GestureWorks.isOpenExibits ? "Open Exhibits trial time : " : "GestureWorks trial time : ";
			
			finalString = GestureWorks.isOpenExibits ? "Open Exhibits trial timer has expired" : "GestureWorks trial timer has expired";
			
			timer=new Timer(1000);
			timer.addEventListener(TimerEvent.TIMER, updateDisplay);
			timer.start();
			
			timerText = new SplashText("", textSize, textColor);
			timerText.width = 300;
			addChild(timerText);
		}
		
		private function updateDisplay(event:TimerEvent):void
		{			
			timerText.updateText(textString + formatTime(timerCompleteAmount));
			
			if (timerCompleteAmount==0)
			{
				timer.stop();
				timer.removeEventListener(TimerEvent.TIMER, updateDisplay);
				timerText.updateText(finalString);
				dispatchEvent(new Event(TrialTimer.COMPLETE));
			}
			
			timerCompleteAmount--;
		}
		
		private function formatTime(t:int):String
		{
			var s:int=Math.round(t);
			var m:int=0;
			if (s>0)
			{
				while (s > 59)
				{
					m++;
					s-=60;
				}
				
				//return String((m < 10 ? "0" : "") + m + ":" + (s < 10 ? "0" : "") + s);
				return String((m < 10 ? "0" : "") + m + ":" + (s < 10 ? "0" : "") + s);
			}
			else
			{
				return "00:00";
			}
		}
		
	}
}