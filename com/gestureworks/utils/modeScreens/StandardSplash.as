////////////////////////////////////////////////////////////////////////////////
//
//  IDEUM
//  Copyright 2011-2012 Ideum
//  All Rights Reserved.
//
//  GestureWorks
//
//  File:    StandardSplash.as
//  Authors:  Ideum
//             
//  NOTICE: Ideum permits you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

package com.gestureworks.utils.modeScreens 
{
	import com.gestureworks.managers.ModeManager;
	import flash.display.Sprite;
	import flash.display.Bitmap;
	
	public class StandardSplash extends Sprite 
	{
		[Embed(source = "../../../../../lib/assets/gw_splash.png")]
		private var SplashImage:Class;	
		
		public function StandardSplash() 
		{
			var splash:Bitmap = new SplashImage;
			addChild(splash);
			
			var version:SplashVersion = new SplashVersion();
			addChild(version);
			version.x = 247;
			version.y = 490;
		}
		
	}

}