////////////////////////////////////////////////////////////////////////////////
//
//  IDEUM
//  Copyright 2011-2012 Ideum
//  All Rights Reserved.
//
//  GestureWorks
//
//  File:    ProSplash.as
//  Authors:  Ideum
//             
//  NOTICE: Ideum permits you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

package com.gestureworks.utils.modeScreens 
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import com.gestureworks.managers.ModeManager;

	public class OESplash extends Sprite 
	{
		
		[Embed(source = "../../../../../lib/assets/oe_splash.png")] 
		public var SplashImage:Class;
		
		public function OESplash() 
		{
			var splash:Bitmap = new SplashImage;
			addChild(splash);
		}
		
	}

}