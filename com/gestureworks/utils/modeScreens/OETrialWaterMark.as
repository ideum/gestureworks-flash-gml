////////////////////////////////////////////////////////////////////////////////
//
//  IDEUM
//  Copyright 2011-2012 Ideum
//  All Rights Reserved.
//
//  GestureWorks
//
//  File:    TrialWaterMark.as
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
	public class OETrialWaterMark extends Sprite 
	{
		[Embed(source = "../../../../../lib/assets/oe_trialWatermark.png")] private var Splash:Class;
		
		public function OETrialWaterMark() 
		{
			var splash:Bitmap = new Splash();
			addChild(splash);
		}	
	}
}