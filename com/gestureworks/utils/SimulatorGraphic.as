////////////////////////////////////////////////////////////////////////////////
//
//  IDEUM
//  Copyright 2011-2012 Ideum
//  All Rights Reserved.
//
//  GestureWorks
//
//  File:   SimulatorGraphic.as
//  Authors:  Ideum
//             
//  NOTICE: Ideum permits you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////
package com.gestureworks.utils
{
	import flash.display.Sprite;
	import com.gestureworks.core.CML;
	
	public class SimulatorGraphic extends Sprite
	{
		public var id:int;
		public function SimulatorGraphic(color:uint=0x009966, radius:int=15, alpha:Number=.5)
		{			
			graphics.beginFill(color, alpha);
			graphics.drawCircle(0, 0, radius);
			graphics.endFill();
		}
	}
}