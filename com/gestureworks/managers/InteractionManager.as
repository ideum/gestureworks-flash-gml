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
		
		
		gw_public static function initialize():void

		{
			trace("interaction manager init");
			///////////////////////////////////////////////////////////////////////////////////////
			// ref gloabl motion point list
			ipoints = GestureGlobals.gw_public::interactionPoints;
			
			// init interaction point manager
			InteractionPointTracker.initialize();

			/////////////////////////////////////////////////////////////////////////////////////////
			//DRIVES UPDATES ON POINT LIFETIME
			GestureWorks.application.addEventListener(GWInteractionEvent.INTERACTION_END, onInteractionEnd);
			GestureWorks.application.addEventListener(GWInteractionEvent.INTERACTION_BEGIN, onInteractionBegin);
			GestureWorks.application.addEventListener(GWInteractionEvent.INTERACTION_UPDATE, onInteractionUpdate);
		}
		
		gw_public static function deInitialize():void
		{
			GestureWorks.application.removeEventListener(GWInteractionEvent.INTERACTION_END, onInteractionEnd);
			GestureWorks.application.removeEventListener(GWInteractionEvent.INTERACTION_BEGIN, onInteractionBegin);
			GestureWorks.application.removeEventListener(GWInteractionEvent.INTERACTION_UPDATE, onInteractionUpdate);
		}

		
		
		// registers touch point via touchSprite
		public static function registerInteractionPoint(ipo:InteractionPointObject):void
		{
			ipo.history.unshift(InteractionPointHistories.historyObject(ipo))
		}
		
		
		public static function onInteractionBegin(event:GWInteractionEvent):void
		{			
			//trace("motion point begin, motionManager",event.value.motionPointID);
			
			// create new interaction point clone for each display object 
			
			
				// create new point object
				var ipO:InteractionPointObject  = new InteractionPointObject();	

						//ipO.id = motionSprite.interactionPointCount; // NEEDED FOR THUMBID
						//ipO.motionPointID = event.value.interactionPointID;
						ipO.type = event.value.type;
						
						ipO.position = event.value.position;
						ipO.direction = event.value.direction;
						ipO.normal = event.value.normal;
						ipO.velocity = event.value.velocity;

						ipO.sphereCenter = event.value.sphereCenter;
						ipO.sphereRadius = event.value.sphereRadius;
						
						ipO.length = event.value.length;
						ipO.width = event.value.width;
					
					
					
					
					
			//ADD TO LOCAL POINT LIST
			//tO.cO.interactionArray.push(ipointObject);
			// update local touch object point count
			//tO.InteractionPointCount++;
				
			
			///////////////////////////////////////////////////////////////////////////
			// ASSIGN POINT OBJECT WITH GLOBAL POINT LIST DICTIONARY
			GestureGlobals.gw_public::interactionPoints[event.value.interactionPointID] = ipO;
				
			////////////////////////////////////////////////////////////////////////////
			// REGISTER TOUCH POINT WITH TOUCH MANAGER
			registerInteractionPoint(ipO);
			
		}
		
		
		// stage motion end
		public static function onInteractionEnd(event:GWInteractionEvent):void
		{
			//trace("Motion point End, motionManager", event.value.motionPointID)
			var InteractionPointID:int = event.value.InteractionPointID;
			var ipointObject:InteractionPointObject = ipoints[InteractionPointID];
		
			
			if (ipointObject)
			{
					//motionSprite.cO.motionArray.splice(event.value.motionPointID, 1);
					// REMOVE POINT FROM LOCAL LIST
					//motionSprite.cO.interactionArray.splice(pointObject.id, 1);
					//test motionSprite.cO.motionArray.splice(pointObject.motionPointID, 1);
					
					// REDUCE LOACAL POINT COUNT
					//motionSprite.interactionPointCount--;
					
					// UPDATE POINT ID 
					//for (var i:int = 0; i < motionSprite.cO.interactionArray.length; i++)
					//{
						//motionSprite.cO.InteractionArray[i].id = i;
					//}
				
					// DELETE FROM GLOBAL POINT LIST
					delete ipoints[event.value.interactionPointID];
			}
			
			//trace("motion point tot",motionSprite.motionPointCount)
		}
		
	
		// the Stage TOUCH_MOVE event.	// DRIVES POINT PATH UPDATES
		public static function onInteractionUpdate(event:GWInteractionEvent):void
		{			
			//  CONSOLODATED UPDATE METHOD FOR POINT POSITION AND TOUCH OBJECT CALCULATIONS
			var ipO:InteractionPointObject = ipoints[event.value.interactionPointID];
			
			//trace("motion move event, motionManager", event.value.motionPointID);
			
				if (ipO)
				{	
					//mpO = event.value;
					//mpO.id  = event.value.id;
					//mpO.motionPointID  = event.value.motionPointID;
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
				}
				
				
				
				// UPDATE POINT HISTORY 
				InteractionPointHistories.historyQueue(event);
		}	
	
		
		
		
		
		
	}
}