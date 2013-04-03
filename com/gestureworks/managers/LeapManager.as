package com.gestureworks.managers 
{
	import com.gestureworks.core.GestureWorks;
	import com.leapmotion.leap.events.LeapEvent;
	import com.leapmotion.leap.LeapMotion;
	import flash.display.Sprite;
	
	/**
	 * ...
	 * @author
	 */
	public class LeapManager extends Sprite
	{
		public static var leap:LeapMotion;		
		protected var debug:Boolean = false;
		
		public function LeapManager() {	
			
			leap = new LeapMotion(); 
			leap.controller.addEventListener( LeapEvent.LEAPMOTION_INIT, onInit );
			leap.controller.addEventListener( LeapEvent.LEAPMOTION_CONNECTED, onConnect );
			leap.controller.addEventListener( LeapEvent.LEAPMOTION_DISCONNECTED, onDisconnect );
			leap.controller.addEventListener( LeapEvent.LEAPMOTION_EXIT, onExit );
			leap.controller.addEventListener( LeapEvent.LEAPMOTION_FRAME, onFrame );
			
			GestureWorks.supportsTouch = false;
			GestureWorks.application.stage.addChild(this);
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
		}

		public function onDisconnect( event:LeapEvent ):void
		{
			if(debug)
				trace( "Leap Disconnected" );
		}

		public function onExit( event:LeapEvent ):void
		{
			if(debug)
				trace( "Leap Exited" );
		}		

		protected function onFrame(event:LeapEvent):void
		{			
			dispatchEvent(new LeapEvent(event.type, event.frame));
		}		
		
	}

}