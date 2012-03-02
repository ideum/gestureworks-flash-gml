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
	import flash.text.TextField;
	
	/**
	 * ...
	 * @author  
	 */
	
	public class OETrialSplash extends Sprite 
	{
		[Embed(source = "../../../../../lib/assets/oe_trial_splash.png")] private var Splash:Class;
		
		public function OETrialSplash() 
		{
			var splash:Bitmap = new Splash();
			addChild(splash);
			
			var timeString:String = Yolotzin.trialLeft.toString();
			if (timeString.length == 1)timeString = "0" + Yolotzin.trialLeft.toString();
			var timeLeft:SplashText = new SplashText(timeString, 66, 0x000000, 5);
			addChild(timeLeft);
			timeLeft.x = 603;
			timeLeft.y = 92;
		}
		
	}

}