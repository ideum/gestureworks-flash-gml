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
	import com.gestureworks.core.*;
	import com.gestureworks.text.*;
	import flash.display.*;
	import flash.events.*;
	import flash.text.*;
	import flash.utils.*;
	
	public class TrialTimer extends Sprite 
	{
		public static var COMPLETE:String = "complete trial timer";
		private var timerCompleteAmount:Number = 1800;
		private var textString:String;
		private var finalString:String;
		private var timer:Timer;
		private var count:int;
		private var timerText:TextField;
		private var readmeText:TextField;
		private var formatBold:TextFormat;
		private var formatRegular:TextFormat;
		
		public function TrialTimer() 
		{
			textString = "Gestureworks Trial Mode: ";
			finalString = "Trial timer has expired";
			
			createText();
			updateTimerText(textString + "60:00");
			
			timer = new Timer(1000);
			timer.addEventListener(TimerEvent.TIMER, updateDisplay);
			timer.start();			
		}
		
		private function updateDisplay(event:TimerEvent):void
		{			
			updateTimerText(textString + formatTime(timerCompleteAmount));
			
			if (timerCompleteAmount == 0) {
				timer.stop();
				timer.removeEventListener(TimerEvent.TIMER, updateDisplay);
				timerText.text = finalString;
				dispatchEvent(new Event(TrialTimer.COMPLETE));
			}
			
			timerCompleteAmount--;
		}
		
		private function formatTime(t:int):String
		{
			var s:int = Math.round(t);
			var m:int = 0;
			if (s > 0) {
				while (s > 59) {
					m++;
					s -= 60;
				}
				return String((m < 10 ? "0" : "") + m + ":" + (s < 10 ? "0" : "") + s);
			}
			else {
				return "00:00";
			}
		}
		
		
		private function createText():void
		{			
			timerText = new TextField;	
			timerText.y = 0;
			timerText.antiAliasType = AntiAliasType.ADVANCED;
			timerText.width = 800;
			timerText.wordWrap = true;
			timerText.embedFonts = true;
			timerText.selectable = false;
			timerText.background = false;
			addChild(timerText);						
			
			readmeText = new TextField;
			readmeText.antiAliasType = AntiAliasType.ADVANCED;
			readmeText.width = 500;
			readmeText.wordWrap = true;
			readmeText.y = 40;
			readmeText.text = "Click to purchase.";
			readmeText.embedFonts = true;
			readmeText.selectable = false;
			addChild(readmeText);
			
			formatRegular = new TextFormat("OpenSansRegular", 25, 0xFFFFFF);			
			readmeText.setTextFormat(formatRegular);						
		}
		
		private function updateTimerText(txt:String):void
		{
			timerText.text = txt;
			timerText.setTextFormat(formatRegular);
		}
		
	}
}