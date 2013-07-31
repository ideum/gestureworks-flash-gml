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

package com.gestureworks.managers 
{
	import com.gestureworks.core.*;
	import com.gestureworks.events.*;
	import com.gestureworks.managers.*;
	import flash.display.*;
	import flash.events.*;
	import flash.system.*;
	import flash.ui.*;
	import flash.utils.*;
	import org.tuio.*;
	import org.tuio.adapters.*;
	import org.tuio.connectors.TCPConnector;
	import org.tuio.debug.*;
	
	/**
	 * This class initializes TUIO. Declare tuio="true" in the main class or as an attribute in the CML root tag.
	 * TUIO currently only works in AIR, and the following import statement is required: import com.gestureworks.core.GestureWorksAIR; GestureWorksAIR;
	 * This statement loads the neccesary GestureWorks AIR exclusive classes.
	 */	
	public class TUIOManager extends Sprite
	{
		private static var gwTUIOMngr:TUIOManager;
		
		private var connector:*;	
		
		private var _tuioManager:*;
		public function get tuioManager():* { return _tuioManager; }
		
		private var _tuioClient:TuioClient;
		public function get tuioClient():TuioClient { return _tuioClient;}		

		private var _tuioDebug:TuioDebug;
		public function get tuioDebug():TuioDebug { return _tuioDebug; }	
	
		gw_public static function initialize():void
		{			
			// create gestureworks TUIOManager
			if(!gwTUIOMngr){
				gwTUIOMngr = new TUIOManager(Capabilities.playerType == "Desktop");
				GestureWorks.application.addChild(gwTUIOMngr); 
			}
			
			// tuio is now active
			GestureWorks.activeTUIO = true;
			trace("TUIO is active - native touch is no longer automically disabled");
		}			

		/**
		 * Constructor
		 * @param	air - flag indicating AIR runtime or flash
		 */
		public function TUIOManager(air:Boolean = true) 
		{			
			super();

			if(air){
				try {
					var UDPConnector:Class = getDefinitionByName("org.tuio.connectors.UDPConnector") as Class;
					connector = new UDPConnector();
				}
				catch (e:Error) {
					throw new Error("If you are trying to utilize TUIO in AIR, please make sure that you have included this statement into your Main Document class:  'import com.gestureworks.core.GestureWorksAIR; GestureWorksAIR;'. ");
				}
			}
			else {
				connector = new TCPConnector("127.0.0.1", 3000); 
			}
			
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		
		private function init(event:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			_tuioClient = new TuioClient(connector);
			//flosc
			//TuioLegacyListener.init(stage, _tuioClient);
			//_tuioManager = TuioLegacyListener.getInstance();
			_tuioManager = TuioManager.init(stage);
			_tuioDebug = TuioDebug.init(stage);
			_tuioClient.addListener(_tuioManager);
			_tuioClient.addListener(_tuioDebug);
			_tuioManager.addEventListener(TuioEvent.UPDATE, onUpdate);
			_tuioManager.addEventListener(TuioEvent.REMOVE, onRemove);
		}
				
		
		private function onUpdate(e:TuioEvent):void
		{						
			var event:GWTouchEvent = new GWTouchEvent(null, e.type, e.bubbles, e.cancelable, e.tuioContainer.sessionID);
			event.stageX = e.tuioContainer.x * stage.stageWidth;
			event.stageY = e.tuioContainer.y * stage.stageHeight;
			TouchManager.onTouchMove(event);
		}
		
		
		private function onRemove(e:TuioEvent):void
		{
			TouchManager.onTouchUp(new GWTouchEvent(null, e.type, e.bubbles, e.cancelable, e.tuioContainer.sessionID));				
		}
				

	}
}