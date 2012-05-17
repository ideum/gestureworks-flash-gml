package com.gestureworks.tuio 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import org.tuio.connectors.*;
	import org.tuio.*;
	import org.tuio.TuioEvent;
	import com.gestureworks.tuio.TEvent;
	
	public class TUIOLink extends Sprite
	{
		public static var POINT_ADDED:String = "pointadded";
		public static var POINT_UPDATED:String = "pointupdated";
		public static var POINT_REMOVED:String = "pointremoved";
		
		public var tuioInitialized:Boolean;
		public var tuioManager:TuioManager;
		
		public var ip:String;
		public var port:uint;
		public var type:String;
		
		public function TUIOLink(ipAddress:String="localhost", portAddress:int=3333, socketType:String="udp")
		{
			super();
			
			ip = ipAddress;
			port = portAddress;
			type = socketType;
			
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		public function init(event:Event=null):void
		{
			if (tuioInitialized) return;
			
			trace("here we are at the inti for teh link")
			
			var tc:TuioClient;
			if (type == "udp") tc = new TuioClient(new UDPConnector(ip, port));
			if (type == "tcp") tc = new TuioClient(new TCPConnector(ip, port));
			tc.addListener(TuioManager.init(stage));
			
			tuioManager = TuioManager.getInstance();
			tuioManager.addEventListener(TuioEvent.ADD_CURSOR, curserAddedUpdate);
			tuioManager.addEventListener(TuioEvent.UPDATE, cursorUpdateHandler);
			tuioManager.addEventListener(TuioEvent.REMOVE_CURSOR, cursorRemoveHandler);
			
			tuioInitialized=true
		}
		
		private function curserAddedUpdate(event:TuioEvent):void
		{			
			trace("curser has been added");
			var object:Object = new Object();
			object.touchPointID = event.tuioContainer.sessionID;
			object.x = event.tuioContainer.x;
			object.y = event.tuioContainer.y;
			dispatchEvent(new TEvent(TUIOLink.POINT_ADDED, object));
		}
		
		private function cursorUpdateHandler(event:TuioEvent):void
		{			
			var object:Object = new Object();
			object.touchPointID = event.tuioContainer.sessionID;
			object.x = event.tuioContainer.x;
			object.y = event.tuioContainer.y;
			dispatchEvent(new TEvent(TUIOLink.POINT_UPDATED, object));
		}
		
		private function cursorRemoveHandler(event:TuioEvent):void
		{			
			var object:Object = new Object();
			object.touchPointID = event.tuioContainer.sessionID;
			object.x = event.tuioContainer.x;
			object.y = event.tuioContainer.y;
			dispatchEvent(new TEvent(TUIOLink.POINT_REMOVED, object));
		}
	}
}