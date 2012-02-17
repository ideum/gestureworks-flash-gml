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
	import flash.display.Sprite;
	import flash.display.Bitmap;
	
	/**
	 * ...
	 * @author  
	 */
	public class ProSplash extends Sprite 
	{
		[Embed(source = "../../../../../lib/assets/splash_screen_pro.png")] private var Splash:Class;
		
		public function ProSplash() 
		{
			var splash:Bitmap = new Splash();
			addChild(splash);
			
			var version:SplashVersion = new SplashVersion();
			addChild(version);
			version.x = 247;
			version.y = 480;
		}
		
	}

}