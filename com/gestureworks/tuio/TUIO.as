////////////////////////////////////////////////////////////////////////////////
//
//  Ideum
//  Copyright 2011-2012 Ideum
//  All Rights Reserved.
//
//  GestureWorks
//
//  File:    TUIO .as
//  Authors:  Ideum
//             
//  NOTICE: Ideum permits you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

package com.gestureworks.tuio 
{
	import com.gestureworks.core.*;
	import flash.system.*;
	import flash.utils.*;
	
	import com.gestureworks.tuio.TUIOManager;
	
	public class TUIO 
	{		
		public static function initialize():void
		{			
			if ( Capabilities.playerType != "Desktop") return;	
			var tuioString:String = CML.Objects.@tuio;
			if (tuioString == "") return;
			var tuioManager:TUIOManager = new TUIOManager;
			var tuio:Boolean = tuioString == "true" ? true : false;
			GestureWorks.application.addChild(tuioManager);
			GestureWorks.activeTUIO = tuio;
			if (tuio) trace("tuio is active \n & if your OS supports Native touch, please inactivate touch support in your control panel.");
		}	
	}
}