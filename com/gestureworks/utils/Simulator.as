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
	import com.gestureworks.core.*;
	import com.gestureworks.managers.*;
	
	public class Simulator 
	{		
		gw_public static function initialize():void
		{	
			MouseManager.gw_public::initialize();		
			KeyListener.gw_public::initialize();
			GestureWorks.activeSim = true;			
			trace("simulator is on");
		}
		
		gw_public static function deactivate():void 
		{
			MouseManager.gw_public::deactivate();
			KeyListener.gw_public::deactivate();
			GestureWorks.activeSim = false;
			trace("simulator is off");
		}
		
	}
}