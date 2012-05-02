////////////////////////////////////////////////////////////////////////////////
//
//  Ideum
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

package com.gestureworks.tuio 
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TouchEvent;
	import org.tuio.osc.OSCEvent;
	import org.tuio.TuioClient;
	import org.tuio.TuioManager;
	import org.tuio.debug.TuioDebug;
	import org.tuio.TuioEvent;
	import flash.ui.*;
	import flash.display.*
	import flash.utils.*;
	
	import com.gestureworks.managers.SocketTouchManager;
	
	public class TUIOManager extends Sprite
	{
		private var udpConnector:*;
		
		private var screenW:int;
		private var screenH:int;
		
		private var stageW:int;
		private var stageH:int;
		
		private var windowX:int;
		private var windowY:int;
		private var windowH:int;
		private var windowW:int;
		
		public function TUIOManager() 
		{			
			super();
						
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
			
			try
			{
				var UDPConnector:Class = getDefinitionByName("org.tuio.connectors.UDPConnector") as Class;
				udpConnector = new UDPConnector();
			}
			catch (e:Error)
			{
				throw new Error("TUIO is currently only supported in AIR, if you are trying to utilize TUIO, please make sure that you have included this statement into your Main Document class:  ' import com.gestureworks.core.GestureWorksAIR; GestureWorksAIR; '. ");
			}
			
		}
			
		private function init(event:Event = null):void 
		{
			
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			
			//TODO - auto-calibrate
			/*
			screenW = stage.fullScreenWidth;
			screenH = stage.fullScreenHeight;
			
			stageW = stage.stageWidth;
			stageH = stage.stageHeight;
			
			windowX = stage.nativeWindow.x;
			windowY = stage.nativeWindow.y;
			windowH = stage.nativeWindow.height;
			windowW = stage.nativeWindow.width;
			*/
						
			Multitouch.inputMode = MultitouchInputMode.NONE;			
			var tc:TuioClient = new TuioClient(udpConnector);
			var tm:TuioManager = TuioManager.init(stage);
			tc.addListener(tm);
			tc.addListener(TuioDebug.init(stage))
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
				
		private function map(v:Number, a:Number, b:Number, x:Number=0, y:Number=1):Number 
		{
			return (v == a) ? x : (v - a) * (y - x) / (b - a) + x;
		}
	}
}