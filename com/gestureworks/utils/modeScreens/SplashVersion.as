////////////////////////////////////////////////////////////////////////////////
//
//  IDEUM
//  Copyright 2011-2012 Ideum
//  All Rights Reserved.
//
//  GestureWorks
//
//  File:    SplashVersion.as
//  Authors:  Ideum
//             
//  NOTICE: Ideum permits you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

package com.gestureworks.utils.modeScreens 
{
	import flash.display.Sprite;
	import com.gestureworks.core.GestureWorks;

	public class SplashVersion extends Sprite 
	{		
		public function SplashVersion() 
		{
			var gestureWorksVersion:SplashText = new SplashText(GestureWorks.version, 14, 0xFFFFFF);
			gestureWorksVersion.selectable = false;
			addChild(gestureWorksVersion);
		}
		
	}
}