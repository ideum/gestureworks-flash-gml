////////////////////////////////////////////////////////////////////////////////
//
//  IDEUM
//  Copyright 2011-2012 Ideum
//  All Rights Reserved.
//
//  GestureWorks
//
//  File:    Unregistered.as
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
	
	public class Unregistered extends Sprite 
	{
		[Embed(source = "../../../../../lib/assets/unable_to_verify.png")] private var Splash:Class;
		
		public function Unregistered() 
		{
			var splash:Bitmap = new Splash();
			addChild(splash);
			
			var buttonGW:SplashButton = new SplashButton(180, 60, 0, "http://support.gestureworks.com/");
			buttonGW.x = 581;
			buttonGW.y = 162;
			addChild(buttonGW);
			
			var buttonOE:SplashButton = new SplashButton(180, 60, 0, "http://openexhibits.org/support/");
			buttonOE.x = 581;
			buttonOE.y = 342;		
			addChild(buttonOE);
		}	
	}
}