package com.gestureworks.tuio
{
	import flash.display.Stage;
	import flash.utils.getDefinitionByName;
	import com.gestureworks.core.GestureWorks;
	import flash.system.Capabilities;
	
	public class TuioLink
	{
		public static function initialize(stage:Stage):void
		{
			if (Capabilities.playerType != "Desktop") return;
			
			try
			{
				var Tuio:Class = getDefinitionByName("com.gestureworks.utils.TUIO") as Class;
				var tuio:* = new Tuio();
				stage.addChild(tuio);
				GestureWorks.activeTUIO = tuio;
			}
			catch (e:Error)
			{
				throw new Error("if you are trying to utilize TUIO, please make sure that you have included this statement into your Main Document class:  ' import com.gestureworks.utils.TUIO; TUIO; '. ");
			}
			
		}
		
	}
	
}