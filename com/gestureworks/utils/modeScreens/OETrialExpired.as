////////////////////////////////////////////////////////////////////////////////
//
//  IDEUM
//  Copyright 2011-2012 Ideum
//  All Rights Reserved.
//
//  GestureWorks
//
//  File:    TrialExpired.as
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
	
	/**
	 * ...
	 * @author  
	 */
	public class OETrialExpired extends Sprite 
	{
		[Embed(source = "../../../../../lib/assets/OE_Trial_Expired.png")] private var Splash:Class;
		
		public function OETrialExpired() 
		{
			var splash:Bitmap = new Splash();
			addChild(splash);
			
			var button:SplashButton = new SplashButton(200, 75);
			addChild(button);
			
			button.x = 298;
			button.y = 478;
		}
		
	}

}