////////////////////////////////////////////////////////////////////////////////
//
//  IDEUM
//  Copyright 2011-2012 Ideum
//  All Rights Reserved.
//
//  GestureWorks
//
//  File:    TouchUpdateManager.as
//  Authors:  Ideum
//             
//  NOTICE: Ideum permits you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////
package com.gestureworks.managers
{
	import flash.events.TouchEvent;
	import flash.events.Event;
	import flash.utils.Dictionary;
	import com.gestureworks.core.GestureWorks;
	import com.gestureworks.core.GestureGlobals;
	import com.gestureworks.core.gw_public;
	import com.gestureworks.managers.PointHistories;
	import com.gestureworks.managers.ClusterHistories;
	import com.gestureworks.managers.TransformHistories;
	import com.gestureworks.objects.ClusterObject;
	import com.gestureworks.events.GWGestureEvent;
	
	/* 
		
		IMPORTANT NOTE TO DEVELOPER **********************************************
		 
		PlEASE DO NOT ERASE OR DEVALUE ANYTHING WHITHIN THIS CLASS IF YOU DO NOT UNDERSTAND IT'S CURRENT VALUE OR PLACE.
		IF YOU HAVE ANY QUESTIONS, ANY AT ALL. PLEASE ASK PAUL LACEY (paul@ideum.com) ABOUT IT'S IMPORTATANCE.
		IF PAUL IS UNABLE TO HELP YOU UNDERSTAND, THEN PLEASE LOOK AND READ THE ACTUAL CODE FOR IT'S PATH.
		SOMETHINGS AT FIRST MAY NOT BE CLEAR AS TO WHAT THE ACTUAL PURPOSE IS, BUT IT IS VALUABLE AND IS USED IF IT IS CURRENTLY WRITTTEN HERE.
		DO NOT TAKE CODE OUT UNLESS YOUR CHANGES ARE VERIEFIED, TESTED AND CONTINUE TO WORK WITH LEGACY BUILDS !
		
		*/
	
	public class TouchUpdateManager
	{
		//public static var pointMoveQueue:Dictionary = new Dictionary();
		gw_public static function initialize():void{}
		
		/*
		public static function touchFrameHandler():void
		{
			//trace("=================================== touch frame handler");
			
			for (var key:Object in pointMoveQueue)
			{
				//trace("touch frame keys",key)
				if (GestureGlobals.gw_public::points[pointMoveQueue[key].touchPointID])
				{
					// send event to history queue
					//PointHistories.historyQueue(pointMoveQueue[key]);
					moving(pointMoveQueue[key]);
					updateTouchObject(pointMoveQueue[key]);
					trace("point move que update");
				}
				delete pointMoveQueue[key];
			}
		}
		
		public static function moving(event:TouchEvent):void
		{
			// update point positions
			//trace("updating point data in moving", event.touchPointID, event.stageX, event.stageY);
			
		
			var pointObject:Object = GestureGlobals.gw_public::points[event.touchPointID];
			
			if (!GestureWorks.supportsTouch || GestureWorks.activeTUIO)
			{
				pointObject.point.x = event.localX;
				pointObject.point.y = event.localY;
				return;
			}
			pointObject.point.y = event.stageY;
			pointObject.point.x = event.stageX;
			
			//pointObject.point.y = event.localY;
			//pointObject.point.x = event.localX;
			
			//trace("moving object cluster moving touchupdate manager",event.target.name, pointObject.object.clusterID,pointObject.object.name);
			
			///////////////////////////////////
			//3.1//event.stopImmediatePropagation();
			///////////////////////////////////
		}
			
			
			public static function updateTouchObject(event:TouchEvent):void
			{
				//if (trace_debug_mode) trace("update Touch Object");
				
				/////////////////////////////////////////////////////////////////////////////////////////////
				// update touch object
				/////////////////////////////////////////////////////////////////////////////////////////////
				if (GestureGlobals.gw_public::points[event.touchPointID]) 
					{
					var clusterID:Object = GestureGlobals.gw_public::points[event.touchPointID].object.clusterID;
					var tO:Object = GestureGlobals.gw_public::touchObjects[clusterID];//
							tO.updateClusterAnalysis();
							tO.updateProcessing();
							tO.updateGestureAnalysis();
							tO.updateTransformation();
							//tO.updateDebugDisplay(); // resource intensive
						}
				//////////////////////////////////
				//event.stopPropagation();
				//3.1//event.stopImmediatePropagation();
				/////////////////////////////////
			}
			*/
	}
}