////////////////////////////////////////////////////////////////////////////////
//
//  IDEUM
//  Copyright 2011-2012 Ideum
//  All Rights Reserved.
//
//  GestureWorks
//
//  File:    SplashText.as
//  Authors:  Ideum
//             
//  NOTICE: Ideum permits you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////
package com.gestureworks.utils.modeScreens 
{
	import flash.text.*;
	
	public class SplashText extends TextField 
	{
		private var textFormat:TextFormat = new TextFormat();
		
		public function SplashText(txt:String, size:Number=15, color:uint=0x000000, spacing:int=0, font:String="OpenSansRegular") 
		{
			super();
			
			textFormat.size = size;
			textFormat.align = TextFormatAlign.LEFT;
			textFormat.color = color;
			textFormat.font = font;
			textFormat.letterSpacing = spacing;
			
			defaultTextFormat = textFormat;
			text = txt;
			antiAliasType = AntiAliasType.ADVANCED;
			multiline = true;
			wordWrap = true;
			embedFonts = true;
		}
		
		public function updateText(string:String):void
		{
			text = string;
		}
	}
}