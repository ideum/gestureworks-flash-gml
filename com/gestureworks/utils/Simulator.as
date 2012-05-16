////////////////////////////////////////////////////////////////////////////////
//
//  IDEUM
//  Copyright 2011-2012 Ideum
//  All Rights Reserved.
//
//  GestureWorks
//
//  File:    Simulator.as
//  Authors:  Ideum
//             
//  NOTICE: Ideum permits you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////
package com.gestureworks.utils 
{
	import com.gestureworks.core.CML;
	import com.gestureworks.core.GestureWorks;
	
	public class Simulator 
	{		
		public static function initialize(simulator:Boolean = false):void
		{			
			if (GestureWorks.hasCML) 
			{
				var simString:String = CML.Objects.@simulator;
				simulator = simString == "true" ? true : false;	
			}
						
			GestureWorks.supportsTouch = !simulator;
			
			if (!GestureWorks.supportsTouch) {
				trace("simulator is on");
				Simulator.on = true;
			}
		}
		
		
		// Added this property, to do conditional checks in TouchSpriteBase
		// - Charles (5/16/2012)
		public static var on:Boolean = false;
		
	}
}