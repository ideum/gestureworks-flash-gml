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
	import flash.text.TextField;
	import flash.text.TextFormat;
	import com.gestureworks.text.DefaultFonts;
	
	/**
	 * ...
	 * @author  
	 */
	public class OESplash extends Sprite 
	{
		[Embed(source = "../../../../../lib/assets/oesplash.png")] private var Splash:Class;
		
		public function OESplash() 
		{
			var splash:Bitmap = new Splash();
			addChild(splash);
		}
		
	}

}