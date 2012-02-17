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
	 * @author Matthew Valverde
	 */
	public class RunTimeSplashScreen extends Sprite 
	{
		[Embed(source = "../../../../../lib/assets/Powered_by_GW.png")] private var Splash:Class;
		
		public function RunTimeSplashScreen() 
		{
			var splash:Bitmap = new Splash();
			addChild(splash);
		}
		
	}

}