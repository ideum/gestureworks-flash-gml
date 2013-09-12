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
	import flash.geom.Point;
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
		
	
		gw_public static function initialize(host:String="127.0.0.1", port:int = NaN, protocol:String=null):void		
		{			
			// create gestureworks TUIOManager
			if(!gwTUIOMngr){
				gwTUIOMngr = new TUIOManager(Capabilities.playerType == "Desktop", host, port, protocol);
				GestureWorks.application.addChild(gwTUIOMngr); 
			}
		}			

		/**
		 * Constructor
		 * @param	air   Flag indicating AIR runtime or flash
		 * @param	host  The id of the tracker or bridge
		 * @param	port  The port on which the tracker or bridge sends the TUIO tracking data.
		 * @param	protocol The name of the protocol (udp, tcp, or flosc)
		 */
		public function TUIOManager(air:Boolean = true, host:String="127.0.0.1", port:int=NaN, protocol:String=null) 
		{			
			super();
			protocol = protocol ? protocol : air ? "udp" : "tcp";
			port = port ? port : protocol == "udp" ? 3333 : 3000;	

			if(air){
				try {
					if(protocol == "udp"){
						var UDPConnector:Class = getDefinitionByName("org.tuio.connectors.UDPConnector") as Class;
						connector = new UDPConnector(host, port);
					}
					else 
						connector = new TCPConnector(host, port, protocol == "flosc");
				}
				catch (e:Error) {
					throw new Error("If you are trying to utilize TUIO in AIR, please make sure that you have included this statement into your Main Document class:  'import com.gestureworks.core.GestureWorksAIR; GestureWorksAIR;'. ");
				}
			}
			else {
				if (protocol == "udp")
					throw new Error("Flash does not support UDP");
				connector = new TCPConnector(host, port, protocol=="flosc"); 
			}
			
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		
		private function init(event:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			_tuioClient = new TuioClient(connector);
			_tuioManager = TuioManager.init(stage);
			_tuioDebug = TuioDebug.init(stage);
			_tuioClient.addListener(_tuioManager);
			_tuioClient.addListener(_tuioDebug);
			_tuioManager.addEventListener(TuioEvent.ADD, onAdd);
			_tuioManager.addEventListener(TuioEvent.UPDATE, onUpdate);
			_tuioManager.addEventListener(TuioEvent.REMOVE, onRemove);
		}
				
		private function onAdd(e:TuioEvent):void {
			var event:GWTouchEvent = new GWTouchEvent(null, e.type, e.bubbles, e.cancelable, e.tuioContainer.sessionID);
			event.stageX = e.tuioContainer.x * stage.stageWidth;
			event.stageY = e.tuioContainer.y * stage.stageHeight;
			event.target = getTopDisplayObjectUnderPoint(new Point(event.stageX, event.stageY));
			event.eventPhase = 3;
			if (event.target is Stage)
				return;
				
			TouchManager.onTouchDown(event);
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
		
		/**
		 * Hit test
		 * @param	point
		 * @return
		*/ 
		private function getTopDisplayObjectUnderPoint(point:Point):DisplayObject {
			var targets:Array =  stage.getObjectsUnderPoint(point);
			var item:DisplayObject = (targets.length > 0) ? targets[targets.length - 1] : stage;
			item = resolveTarget(item);
									
			return item;
		}	
		
		/**
		 * Determines the hit target based on mouseChildren settings of the ancestors
		 * @param	target
		 * @return
		 */
		private function resolveTarget(target:DisplayObject):DisplayObject {
			var ancestors:Array = targetAncestors(target, new Array(target));			
			var trueTarget:DisplayObject = target;
			
			for each(var t:DisplayObject in ancestors) {
				if (t is DisplayObjectContainer && !DisplayObjectContainer(t).mouseChildren)
				{
					trueTarget = t;
					break;
				}
			}
			
			return trueTarget;
		}
				
		/**
		 * Returns a list of the supplied target's ancestors sorted from highest to lowest
		 * @param	target
		 * @param	ancestors
		 * @return
		 */
		private function targetAncestors(target:DisplayObject, ancestors:Array = null):Array {
			
			if (!ancestors)
				ancestors = new Array();
				
			if (!target.parent || target.parent == target.root)
				return ancestors;
			else {
				ancestors.unshift(target.parent);
				ancestors = targetAncestors(target.parent, ancestors);
			}
			
			return ancestors;
		}		

	}
}