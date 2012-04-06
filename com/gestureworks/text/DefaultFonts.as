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
		// Arial
		[Embed(source="../../../../lib/defaultFonts/arial.ttf",fontName='ArialFont',fontFamily='font',fontWeight='normal',fontStyle='normal',mimeType='application/x-font-truetype',advancedAntiAliasing='true',embedAsCFF='false',unicodeRange='U+0020-U+002F,U+0030-U+0039,U+003A-U+0040,U+0041-U+005A,U+005B-U+0060,U+0061-U+007A,U+007B-U+007E')]
		public static var ArialFont:Class;
		Font.registerFont(ArialFont);
		
		// Georgia
		[Embed(source="../../../../lib/defaultFonts/georgia.ttf",fontName='GeorgiaFont',fontFamily='font',fontWeight='normal',fontStyle='normal',mimeType='application/x-font-truetype',advancedAntiAliasing='true',embedAsCFF='false',unicodeRange='U+0020-U+002F,U+0030-U+0039,U+003A-U+0040,U+0041-U+005A,U+005B-U+0060,U+0061-U+007A,U+007B-U+007E')]
		public static var GeorgiaFont:Class;
		Font.registerFont(GeorgiaFont);
		
		// Georgia Italic
		[Embed(source="../../../../lib/defaultFonts/georgiaItalic.ttf",fontName='GeorgiaItalicFont',fontFamily='font',fontWeight='normal',fontStyle='normal',mimeType='application/x-font-truetype',advancedAntiAliasing='true',embedAsCFF='false',unicodeRange='U+0020-U+002F,U+0030-U+0039,U+003A-U+0040,U+0041-U+005A,U+005B-U+0060,U+0061-U+007A,U+007B-U+007E')]
		public static var GeorgiaItalicFont:Class;
		Font.registerFont(GeorgiaItalicFont);
		
		// Lucinda
		[Embed(source="../../../../lib/defaultFonts/lucinda.ttf",fontName='LucindaFont',fontFamily='font',fontWeight='normal',fontStyle='normal',mimeType='application/x-font-truetype',advancedAntiAliasing='true',embedAsCFF='false',unicodeRange='U+0020-U+002F,U+0030-U+0039,U+003A-U+0040,U+0041-U+005A,U+005B-U+0060,U+0061-U+007A,U+007B-U+007E')]
		public static var LucindaFont:Class;
		Font.registerFont(LucindaFont);
		
		// Lucinda Bold
		/*[Embed(source="../../../../lib/defaultFonts/lucindaBold.ttf",fontName='LucindaBoldFont',fontFamily='font',mimeType='application/x-font-truetype',embedAsCFF='false',unicodeRange='U+0020-U+002F,U+0030-U+0039,U+003A-U+0040,U+0041-U+005A,U+005B-U+0060,U+0061-U+007A,U+007B-U+007E')]
		public static var LucindaBoldFont:Class;
		Font.registerFont(LucindaBoldFont);*/
		
		// Verdana
		[Embed(source="../../../../lib/defaultFonts/verdana.ttf",fontName='VerdanaFont',fontFamily='font',fontWeight='normal',fontStyle='normal',mimeType='application/x-font-truetype',advancedAntiAliasing='true',embedAsCFF='false',unicodeRange='U+0020-U+002F,U+0030-U+0039,U+003A-U+0040,U+0041-U+005A,U+005B-U+0060,U+0061-U+007A,U+007B-U+007E')]
		public static var VerdanaFont:Class;
		Font.registerFont(VerdanaFont);
		
		// Verdana Bold
		/*
		[Embed(source="../../../../lib/defaultFonts/verdanaBold.ttf",fontName='VerdanaBoldFont',fontFamily='font',mimeType='application/x-font-truetype',embedAsCFF='false',unicodeRange='U+0020-U+002F,U+0030-U+0039,U+003A-U+0040,U+0041-U+005A,U+005B-U+0060,U+0061-U+007A,U+007B-U+007E')]
		public static var VerdanaBoldFont:Class;
		Font.registerFont(VerdanaBoldFont);
		*/
		
		// Helvetica New
		[Embed(source="../../../../lib/defaultFonts/helvetica.ttf",fontName='HelveticaFont',fontFamily='font',fontWeight='normal',fontStyle='normal',mimeType='application/x-font-truetype',advancedAntiAliasing='true',embedAsCFF='false',unicodeRange='U+0020-U+002F,U+0030-U+0039,U+003A-U+0040,U+0041-U+005A,U+005B-U+0060,U+0061-U+007A,U+007B-U+007E')]
		public static var HelveticaFont:Class;
		Font.registerFont(HelveticaFont);
		
		// Gotham Light
		[Embed(source="../../../../lib/defaultFonts/gothamLight.ttf",fontName='GothamLightFont',fontFamily='font',fontWeight='normal',fontStyle='normal',mimeType='application/x-font-truetype',advancedAntiAliasing='true',embedAsCFF='false',unicodeRange='U+0020-U+002F,U+0030-U+0039,U+003A-U+0040,U+0041-U+005A,U+005B-U+0060,U+0061-U+007A,U+007B-U+007E')]
		public static var GothamLightFont:Class;
		Font.registerFont(GothamLightFont);
		
		// Gotham Medium
		[Embed(source="../../../../lib/defaultFonts/gothamMedium.ttf",fontName='GothamMediumFont',fontFamily='font',fontWeight='normal',fontStyle='normal',mimeType='application/x-font-truetype',advancedAntiAliasing='true',embedAsCFF='false',unicodeRange='U+0020-U+002F,U+0030-U+0039,U+003A-U+0040,U+0041-U+005A,U+005B-U+0060,U+0061-U+007A,U+007B-U+007E')]
		public static var GothamMediumFont:Class;
		Font.registerFont(GothamMediumFont);
		
		// Gotham Medium
		[Embed(source="../../../../lib/defaultFonts/gillSans.ttc",fontName='GillSansLightFont',fontFamily='font',fontWeight='normal',fontStyle='normal',mimeType='application/x-font-truetype',advancedAntiAliasing='true',embedAsCFF='false',unicodeRange='U+0020-U+002F,U+0030-U+0039,U+003A-U+0040,U+0041-U+005A,U+005B-U+0060,U+0061-U+007A,U+007B-U+007E')]
		public static var GillSansLightFont:Class;
		Font.registerFont(GillSansLightFont);
		
		// OpenSansRegular
		[Embed(source="../../../../lib/defaultFonts/OpenSansRegular.ttf",fontName='OpenSansRegular',fontFamily='font',fontWeight='normal',fontStyle='normal',mimeType='application/x-font-truetype',advancedAntiAliasing='true',embedAsCFF='false',unicodeRange='U+0020-U+002F,U+0030-U+0039,U+003A-U+0040,U+0041-U+005A,U+005B-U+0060,U+0061-U+007A,U+007B-U+007E')]
		public static var OpenSansRegular:Class;
		Font.registerFont(OpenSansRegular);
		
		// OpenSansBold
		[Embed(source="../../../../lib/defaultFonts/OpenSansBold.ttf",fontName='OpenSansBold',fontFamily='font',fontWeight='normal',fontStyle='normal',mimeType='application/x-font-truetype',advancedAntiAliasing='true',embedAsCFF='false',unicodeRange='U+0020-U+002F,U+0030-U+0039,U+003A-U+0040,U+0041-U+005A,U+005B-U+0060,U+0061-U+007A,U+007B-U+007E')]
		public static var OpenSansBold:Class;
		Font.registerFont(OpenSansBold);
		
		// OpenSansExtraBold
		[Embed(source="../../../../lib/defaultFonts/OpenSansExtraBold.ttf",fontName='OpenSansExtraBold',fontFamily='font',fontWeight='normal',fontStyle='normal',mimeType='application/x-font-truetype',advancedAntiAliasing='true',embedAsCFF='false',unicodeRange='U+0020-U+002F,U+0030-U+0039,U+003A-U+0040,U+0041-U+005A,U+005B-U+0060,U+0061-U+007A,U+007B-U+007E')]
		public static var OpenSansExtraBold:Class;
		Font.registerFont(OpenSansExtraBold);
		
		// DroidSerif-BoldItalic
		[Embed(source="../../../../lib/defaultFonts/DroidSerifBoldItalic.ttf",fontName='DroidSerifBoldItalic',fontFamily='font',fontWeight='normal',fontStyle='normal',mimeType='application/x-font-truetype',advancedAntiAliasing='true',embedAsCFF='false',unicodeRange='U+0020-U+002F,U+0030-U+0039,U+003A-U+0040,U+0041-U+005A,U+005B-U+0060,U+0061-U+007A,U+007B-U+007E')]
		public static var DroidSerifBoldItalic:Class;
		Font.registerFont(DroidSerifBoldItalic);
		
		// DroidSerif-Bold
		[Embed(source="../../../../lib/defaultFonts/DroidSerifBold.ttf",fontName='DroidSerifBold',fontFamily='font',fontWeight='normal',fontStyle='normal',mimeType='application/x-font-truetype',advancedAntiAliasing='true',embedAsCFF='false',unicodeRange='U+0020-U+002F,U+0030-U+0039,U+003A-U+0040,U+0041-U+005A,U+005B-U+0060,U+0061-U+007A,U+007B-U+007E')]
		public static var DroidSerifBold:Class;
		Font.registerFont(DroidSerifBold);
		// DroidSerif-Italic
		[Embed(source="../../../../lib/defaultFonts/DroidSerifItalic.ttf",fontName='DroidSerifItalic',fontFamily='font',fontWeight='normal',fontStyle='normal',mimeType='application/x-font-truetype',advancedAntiAliasing='true',embedAsCFF='false',unicodeRange='U+0020-U+002F,U+0030-U+0039,U+003A-U+0040,U+0041-U+005A,U+005B-U+0060,U+0061-U+007A,U+007B-U+007E')]
		public static var DroidSerifItalic:Class;
		Font.registerFont(DroidSerifItalic);
		// DroidSerif-Regular
		[Embed(source="../../../../lib/defaultFonts/DroidSerifRegular.ttf",fontName='DroidSerifRegular',fontFamily='font',fontWeight='normal',fontStyle='normal',mimeType='application/x-font-truetype',advancedAntiAliasing='true',embedAsCFF='false',unicodeRange='U+0020-U+002F,U+0030-U+0039,U+003A-U+0040,U+0041-U+005A,U+005B-U+0060,U+0061-U+007A,U+007B-U+007E')]
		public static var DroidSerifRegular:Class;
		Font.registerFont(DroidSerifRegular);
		// Gotham-Bold
		[Embed(source="../../../../lib/defaultFonts/GothamBold.otf",fontName='GothamBold',fontFamily='font',fontWeight='normal',fontStyle='normal',mimeType='application/x-font-truetype',advancedAntiAliasing='true',embedAsCFF='false',unicodeRange='U+0020-U+002F,U+0030-U+0039,U+003A-U+0040,U+0041-U+005A,U+005B-U+0060,U+0061-U+007A,U+007B-U+007E')]
		public static var GothamBold:Class;
		Font.registerFont(GothamBold);
		
		// Gotham-Ultra
		[Embed(source="../../../../lib/defaultFonts/GothamUltra.otf",fontName='GothamUltra',fontFamily='font',fontWeight='normal',fontStyle='normal',mimeType='application/x-font-truetype',advancedAntiAliasing='true',embedAsCFF='false',unicodeRange='U+0020-U+002F,U+0030-U+0039,U+003A-U+0040,U+0041-U+005A,U+005B-U+0060,U+0061-U+007A,U+007B-U+007E')]
		public static var GothamUltra:Class;
		Font.registerFont(GothamUltra);
	}
}