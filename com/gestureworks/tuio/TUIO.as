////////////////////////////////////////////////////////////////////////////////
//
//  Ideum
//  Copyright 2011-2012 Ideum
//  All Rights Reserved.
//
//  GestureWorks
//
//  File:    TUIO.as
//  Authors:  Ideum
//             
//  NOTICE: Ideum permits you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

package com.gestureworks.tuio 
{
	import com.gestureworks.core.GestureWorks;
	import com.gestureworks.tuio.TUIOManager;
	import flash.system.Capabilities;
	
	/**
	 * This class initializes TUIO. Declare tuio="true" in the main class or as an attribute in the GestureWorksApplication tag.
	 * TUIO currently only works in AIR, and the following import statement is required: import com.gestureworks.core.GestureWorksAIR; GestureWorksAIR;
	 * This statement loads the neccesary GestureWorks AIR exclusive classes.
	 */
	public class TUIO 
	{		
		public static function initialize():void
		{
			// check for AIR runtime.
			if (Capabilities.playerType != "Desktop") return;			

			// create gestureworks TUIOManager
			var tuioManager:TUIOManager = new TUIOManager;
			GestureWorks.application.addChild(tuioManager);
			
			// tuio is now active
			GestureWorks.activeTUIO = true;
			trace("TUIO is active - if your OS supports Native touch, please inactivate touch support in your control panel.");
		}	
	}
}