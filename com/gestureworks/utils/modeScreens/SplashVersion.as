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
	
	/**
	 * ...
	 * @author  
	 */
	public class SplashVersion extends Sprite 
	{
		
		public function SplashVersion() 
		{
			var gestureWorksVersion:SplashText = new SplashText(GestureWorks.version, 14, 0xFFFFFF);
			addChild(gestureWorksVersion);
			
			var gestureWorksCopyRight:SplashText = new SplashText(GestureWorks.copyright, 14, 0xFFFFFF);
			addChild(gestureWorksCopyRight);
			gestureWorksCopyRight.x = 96;
			gestureWorksCopyRight.width = 300;
			gestureWorksCopyRight.alpha = .6;
		}
		
	}

}