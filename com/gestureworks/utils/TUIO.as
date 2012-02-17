////////////////////////////////////////////////////////////////////////////////
//
//  IDEUM
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
////////////////////////////////////////////////////////////////////////////////
//
//  IDEUM
//  Copyright 2011-2012 Ideum
//  All Rights Reserved.
//
//  GestureWorks
//
//  File:    TUIOManager.as
//  Authors:  Ideum
//             
//  NOTICE: Ideum permits you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

package com.gestureworks.utils
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TouchEvent;
	import org.tuio.connectors.UDPConnector;
	import org.tuio.osc.OSCEvent;
	import org.tuio.TuioClient;
	import org.tuio.TuioManager;
	import org.tuio.debug.TuioDebug;
	import org.tuio.TuioEvent;
	import flash.ui.*;
	//import com.gestureworks.core.DisplayList;
	
	import com.gestureworks.managers.SocketTouchManager;
	
	public class TUIO extends Sprite
	{
		private var udpConnector:UDPConnector;
		
		public function TUIO() 
		{
			super();
						
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(event:Event = null):void 
		{			
			Multitouch.inputMode = MultitouchInputMode.NONE;			
			udpConnector = new UDPConnector();
			var tc:TuioClient = new TuioClient(udpConnector);
			var tm:TuioManager = TuioManager.init(stage);
			tc.addListener(tm);
			//tc.addListener(TuioDebug.init(stage))
			tm.addEventListener(TuioEvent.ADD, pointAddedHandler);
			tm.addEventListener(TuioEvent.UPDATE, pointUpdatedHandler);
			tm.addEventListener(TuioEvent.REMOVE, pointRemovedHandler);
		}
		
		private function pointAddedHandler(e:TuioEvent):void
		{
			var object:Object = new Object();
			object.touchPointID = e.tuioContainer.sessionID;
			object.x = e.tuioContainer.x * stage.stageWidth;
			object.y = e.tuioContainer.y * stage.stageHeight;
			SocketTouchManager.add(object);
		}
		
		private function pointUpdatedHandler(e:TuioEvent):void
		{			
			var object:Object = new Object();
			object.touchPointID = e.tuioContainer.sessionID;
			object.x = e.tuioContainer.x * stage.stageWidth;
			object.y = e.tuioContainer.y * stage.stageHeight;
			SocketTouchManager.update(object);
		}
		
		private function pointRemovedHandler(e:TuioEvent):void
		{			
			var object:Object = new Object();
			object.touchPointID = e.tuioContainer.sessionID;
			object.x = e.tuioContainer.x * stage.stageWidth;
			object.y = e.tuioContainer.y * stage.stageHeight;
			SocketTouchManager.remove(object);
		}
	}
}