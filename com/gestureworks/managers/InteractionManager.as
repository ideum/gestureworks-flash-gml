////////////////////////////////////////////////////////////////////////////////
//
//  IDEUM
//  Copyright 2011-2012 Ideum
//  All Rights Reserved.
//
//  GestureWorks
//
//  File:    MotionManager.as
//  Authors:  Ideum
//             
//  NOTICE: Ideum permits you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////
package com.gestureworks.managers
{
	import flash.utils.Dictionary;
	
	import com.gestureworks.core.GestureWorks;
	import com.gestureworks.core.GestureWorksCore;
	import com.gestureworks.core.GestureGlobals;
	import com.gestureworks.core.GestureWorks;
	import com.gestureworks.core.gw_public;
	
	import com.gestureworks.core.TouchSprite;
	import com.gestureworks.events.GWEvent;
	import com.gestureworks.events.GWInteractionEvent;
	import com.gestureworks.objects.InteractionPointObject;
	import com.gestureworks.managers.InteractionPointTracker;
	
	public class InteractionManager 
	{	
		public static var ipoints:Dictionary = new Dictionary();
		//public static var touchObjects:Dictionary = new Dictionary();
		private static var gms:TouchSprite;
		
		gw_public static function initialize():void

		{
			//trace("interaction manager init");
			///////////////////////////////////////////////////////////////////////////////////////
			// ref gloabl motion point list
			ipoints = GestureGlobals.gw_public::interactionPoints;
			//touchObjects = GestureGlobals.gw_public::touchObjects;
			
			// init interaction point manager
			InteractionPointTracker.initialize();
			
			gms = GestureGlobals.gw_public::touchObjects[GestureGlobals.motionSpriteID];

			/////////////////////////////////////////////////////////////////////////////////////////
			//DRIVES UPDATES ON POINT LIFETIME
			//GestureWorks.application.addEventListener(GWInteractionEvent.INTERACTION_END, onInteractionEnd);
			//GestureWorks.application.addEventListener(GWInteractionEvent.INTERACTION_BEGIN, onInteractionBegin);
			//GestureWorks.application.addEventListener(GWInteractionEvent.INTERACTION_UPDATE, onInteractionUpdate);
		}
		
		gw_public static function deInitialize():void
		{
			//GestureWorks.application.removeEventListener(GWInteractionEvent.INTERACTION_END, onInteractionEnd);
			//GestureWorks.application.removeEventListener(GWInteractionEvent.INTERACTION_BEGIN, onInteractionBegin);
			//GestureWorks.application.removeEventListener(GWInteractionEvent.INTERACTION_UPDATE, onInteractionUpdate);
		}

		
		
		// registers touch point via touchSprite
		public static function registerInteractionPoint(ipo:InteractionPointObject):void
		{
			ipo.history.unshift(InteractionPointHistories.historyObject(ipo))
		}
		
		
		public static function onInteractionBegin(event:GWInteractionEvent):void
		{			
			//trace("interaction point begin, interactionManager",event.value.interactionPointID);
			
			//NEED IP COUNT FOR ID
			//for each(var tO:Object in touchObjects)
			//{
				// DUPE CORE IP LIST FOR NOW
				// create new interaction point clone for each interactive display object 
				var ipO:InteractionPointObject  = new InteractionPointObject();	
				
						ipO.id = gms.interactionPointCount; // NEEDED FOR THUMBID
						ipO.interactionPointID = event.value.interactionPointID;
						ipO.handID = event.value.handID;
						ipO.type = event.value.type;
						
						ipO.position = event.value.position;
						ipO.direction = event.value.direction;
						ipO.normal = event.value.normal;
						ipO.velocity = event.value.velocity;

						ipO.sphereCenter = event.value.sphereCenter;
						ipO.sphereRadius = event.value.sphereRadius;
						
						ipO.length = event.value.length;
						ipO.width = event.value.width;
						
	
				//ADD TO LOCAL Interaction POINT LIST
				gms.cO.iPointArray.push(ipO);
				// update local touch object point count
				gms.interactionPointCount++;

				///////////////////////////////////////////////////////////////////////////
				// ASSIGN POINT OBJECT WITH GLOBAL POINT LIST DICTIONARY
				GestureGlobals.gw_public::interactionPoints[event.value.interactionPointID] = ipO;
					
				////////////////////////////////////////////////////////////////////////////
				// REGISTER TOUCH POINT WITH TOUCH MANAGER
				registerInteractionPoint(ipO);
			//}
			
			//trace("gms ipointArray length",gms.cO.iPointArray.length,ipO.position )
		}
		
		
		// stage motion end
		public static function onInteractionEnd(event:GWInteractionEvent):void
		{
			
			var iPID:int = event.value.interactionPointID;
			var ipointObject:InteractionPointObject = ipoints[iPID];
			//trace("Motion point End, motionManager", iPID)
			
			if (ipointObject)
			{
					// REMOVE POINT FROM LOCAL LIST
					gms.cO.iPointArray.splice(ipointObject.id, 1);
					
					// REDUCE LOACAL POINT COUNT
					gms.interactionPointCount--;
					
					// UPDATE POINT ID 
					for (var i:int = 0; i < gms.cO.iPointArray.length; i++)
					{
						gms.cO.iPointArray[i].id = i;
					}
				
					// DELETE FROM GLOBAL POINT LIST
					delete ipoints[event.value.interactionPointID];
			}
			
			//trace("interaction point end",gms.interactionPointCount)
		}
		
	
		// the Stage TOUCH_MOVE event.	// DRIVES POINT PATH UPDATES
		public static function onInteractionUpdate(event:GWInteractionEvent):void
		{			
			//  CONSOLODATED UPDATE METHOD FOR POINT POSITION AND TOUCH OBJECT CALCULATIONS
			var ipO:InteractionPointObject = ipoints[event.value.interactionPointID];
			
			//trace("interaction move event, interactionsManager", event.value.interactionPointID);
			
				if (ipO)
				{	
					//mpO = event.value;
					ipO.interactionPointID  = event.value.interactionPointID;
					ipO.position = event.value.position;
					ipO.direction = event.value.direction;
					ipO.normal = event.value.normal;
					ipO.velocity = event.value.velocity;
					
					ipO.sphereRadius = event.value.sphereRadius;
					ipO.sphereCenter = event.value.sphereCenter;
					
					ipO.length = event.value.length;
					ipO.width = event.value.width;
					
					//mpO.handID = event.value.handID;
					//ipO.moveCount ++;
					
					//trace("gms ipointArray length",gms.cO.iPointArray.length,ipO.position )
				}
				

				// UPDATE POINT HISTORY 
				InteractionPointHistories.historyQueue(event);
		}	
	
		
		
		
		
		
	}
}