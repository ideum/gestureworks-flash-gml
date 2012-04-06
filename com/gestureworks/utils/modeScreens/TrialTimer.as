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
		private var timerCompleteAmount:Number = 3600;
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
			textString = "Trial Mode ";
			finalString = GestureWorks.isOpenExibits ? "Open Exhibits trial timer has expired" : "GestureWorks trial timer has expired";
			
			createText();
			updateTimerText(textString + "60:00");
			
			timer=new Timer(1000);
			timer.addEventListener(TimerEvent.TIMER, updateDisplay);
			timer.start();			
		}
		
		private function updateDisplay(event:TimerEvent):void
		{			
			updateTimerText(textString + formatTime(timerCompleteAmount));
			
			if (timerCompleteAmount==0)
			{
				timer.stop();
				timer.removeEventListener(TimerEvent.TIMER, updateDisplay);
				timerText.text = finalString;
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
		
		
		private function createText():void
		{
			var defaultFonts:DefaultFonts = new DefaultFonts;
			
			timerText = new TextField;	
			timerText.y = -40;
			timerText.antiAliasType = AntiAliasType.ADVANCED;
			timerText.width = 300;
			timerText.wordWrap = true;
			timerText.embedFonts = true;
			timerText.selectable = false;
			addChild(timerText);						
			
			readmeText = new TextField;
			readmeText.antiAliasType = AntiAliasType.ADVANCED;
			readmeText.width = 400;
			readmeText.wordWrap = true;
			readmeText.text = "See the Read Me to license";
			readmeText.embedFonts = true;
			readmeText.selectable = false;
			addChild(readmeText);
			
			formatBold = new TextFormat("OpenSansBold", 30, 0xFFFFFF);
			formatRegular = new TextFormat("OpenSansRegular", 30, 0xFFFFFF);
			
			readmeText.setTextFormat(formatRegular, 0, 7);			
			readmeText.setTextFormat(formatBold, 7, 15);				
			readmeText.setTextFormat(formatRegular, 15, readmeText.text.length);				
		}
		
		private function updateTimerText(txt:String):void
		{
			timerText.text = txt;
			timerText.setTextFormat(formatRegular, 0, txt.length-6);			
			timerText.setTextFormat(formatBold, txt.length-6, txt.length);			
		}
		
	}
}