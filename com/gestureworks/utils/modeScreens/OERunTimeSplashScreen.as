////////////////////////////////////////////////////////////////////////////////
//
//  IDEUM
//  Copyright 2011-2012 Ideum
//  All Rights Reserved.
//
//  GestureWorks
//
//  File:    RunTimeSplashScreen.as
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
	public class OERunTimeSplashScreen extends Sprite 
	{
		[Embed(source = "../../../../../lib/assets/oesplash_runtime.png")] private var Splash:Class;
		
		public function OERunTimeSplashScreen() 
		{
			var splash:Bitmap = new Splash();
			addChild(splash);
		}
		
	}

}