////////////////////////////////////////////////////////////////////////////////
//
//  IDEUM
//  Copyright 2011-2012 Ideum
//  All Rights Reserved.
//
//  GestureWorks
//
//  File:    DefaultFonts.as
//  Authors:  Ideum
//             
//  NOTICE: Ideum permits you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

package com.gestureworks.text
{
	import flash.text.Font;
	
	public class DefaultFonts
	{				
		// Open Sans
		[Embed(source = '../../../../lib/fonts/OpenSansRegular.ttf', 
			fontName = 'OpenSansRegular', 
			fontFamily = 'OpenSans', 
			fontWeight = 'normal', 
			fontStyle = 'normal', 
			mimeType = 'application/x-font-truetype', 
			advancedAntiAliasing = 'true', 
			embedAsCFF = 'false',
			unicodeRange='U+0020-007E')]
		public static var OpenSansRegular:Class;
		Font.registerFont(OpenSansRegular);	
		
		[Embed(source = '../../../../lib/fonts/OpenSansItalic.ttf',
			fontName = 'OpenSansItalic',
			fontFamily = 'OpenSans', 
			fontStyle = 'italic',
			mimeType = 'application/x-font-truetype',
			advancedAntiAliasing = 'true',
			embedAsCFF='false',
			unicodeRange='U+0020-007E')]		
		public static var OpenSansItalic:Class;
		Font.registerFont(OpenSansItalic);
		
		[Embed(source = '../../../../lib/fonts/OpenSansBold.ttf',
			fontName = 'OpenSansBold',
			fontFamily = 'OpenSans', 
			fontStyle = 'bold',
			mimeType = 'application/x-font-truetype',
			advancedAntiAliasing = 'true',
			embedAsCFF='false',
			unicodeRange='U+0020-007E')]		
		public static var OpenSansBold:Class;
		Font.registerFont(OpenSansBold);
	}
}