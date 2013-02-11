////////////////////////////////////////////////////////////////////////////////
//
//  IDEUM
//  Copyright 2011-2012 Ideum
//  All Rights Reserved.
//
//  GestureWorks
//
//  File:    TrialSplash.as
//  Authors:  Ideum
//             
//  NOTICE: Ideum permits you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

package com.gestureworks.utils.modeScreens 
{
	import flash.display.Sprite;
	import flash.display.Bitmap;
	import com.gestureworks.utils.Yolotzin;
	import flash.events.Event;
	import flash.text.TextField;
	
	/**
	 * ...
	 * @author  
	 */
	public class TrialSplash extends Sprite 
	{
		[Embed(source = "../../../../../lib/assets/gw_splash.png")] private var Splash:Class;
		[Embed(source = "../../../../../lib/assets/trial_splash.png")] private var SplashNoDate:Class;
		
		private var splash:Bitmap;
		public function TrialSplash(ignoreDateCountdown:Boolean=false) 
		{
			
			if (ignoreDateCountdown)
			{
				splash = new Splash();
				addChild(splash);
				var button:SplashButton =  new SplashButton(130, 30);
				addChild(button);
			}
			
			else
			{
				splash = new SplashNoDate();
				addChild(splash);				
				
				var button:SplashButton = new SplashButton(130, 30);
				addChild(button);
				button.x = 200;
				button.y = 195;				

				var timeString:String = Yolotzin.trialLeft.toString();
				if (timeString.length == 1) timeString = "0" + Yolotzin.trialLeft.toString();
				
				var timeLeft:SplashText = new SplashText(timeString, 66, 0x000000, 4);
				timeLeft.selectable = false;
				addChild(timeLeft);
				timeLeft.x = 116;
				timeLeft.y = 150;
			}
			
			//var version:SplashVersion = new SplashVersion();
			//addChild(version);
			//version.x = 247;
			//version.y = 490;			
		}	
		
	}

}