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
	
	public class OEUnregistered extends Sprite 
	{
		[Embed(source = "../../../../../lib/assets/OEUnregistered.png")] private var Splash:Class;
		
		public function OEUnregistered() 
		{
			var splash:Bitmap = new Splash();
			addChild(splash);
			
			var button:SplashButton = new SplashButton(290, 75, 0, "http://openexhibits.org/support");
			addChild(button);
			
			button.x = 255;
			button.y = 457;
		}	
	}
}