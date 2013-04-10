package com.gestureworks.managers 
{
	import com.gestureworks.core.GestureWorks;
	import com.leapmotion.leap.events.LeapEvent;
	import com.leapmotion.leap.LeapMotion;
	import com.leapmotion.leap.Pointable;
	import flash.display.Sprite;
	
	/**
	 * ...
	 * @author
	 */
	public class LeapManager extends Sprite
	{
		public var leap:LeapMotion;		
		protected var debug:Boolean = false;
		public var outputLeap:Boolean = false;
		
		public function LeapManager() {	
			
			leap = new LeapMotion(); 
			leap.controller.addEventListener( LeapEvent.LEAPMOTION_INIT, onInit );
			leap.controller.addEventListener( LeapEvent.LEAPMOTION_CONNECTED, onConnect );
			leap.controller.addEventListener( LeapEvent.LEAPMOTION_DISCONNECTED, onDisconnect );
			leap.controller.addEventListener( LeapEvent.LEAPMOTION_EXIT, onExit );
			leap.controller.addEventListener( LeapEvent.LEAPMOTION_FRAME, onFrame );
		}
		
		public function onInit( event:LeapEvent ):void
		{ 
			//GestureWorks.activeMotion = true;
			if (debug)
				trace("Leap Initialized");
		}

		public function onConnect( event:LeapEvent ):void
		{
			if(debug)
				trace( "Leap Connected" );				
			GestureWorks.application.stage.addChild(this);				
		}

		public function onDisconnect( event:LeapEvent ):void
		{
			if(debug)
				trace( "Leap Disconnected" );
			//GestureWorks.application.stage.removeChild(this);								
		}

		public function onExit( event:LeapEvent ):void
		{
			if(debug)
				trace( "Leap Exited" );
		}		

		protected function onFrame(event:LeapEvent):void
		{			
			dispatchEvent(new LeapEvent(event.type, event.frame));
			if (outputLeap)
			{
				for each(var pointable:Pointable in event.frame.pointables)
				{
					trace("POINT ID:"+ pointable.id+ " x:"+ pointable.tipPosition.x+ " y:"+ pointable.tipPosition.y+ " z:"+ pointable.tipPosition.z);
				}
			}
		}		
		
	}

}