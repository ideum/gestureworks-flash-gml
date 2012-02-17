////////////////////////////////////////////////////////////////////////////////
//
//  IDEUM
//  Copyright 2011-2012 Ideum
//  All Rights Reserved.
//
//  GestureWorks
//
//  File:    ObjectManager.as
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
	import com.gestureworks.core.GestureGlobals;
	import flash.events.Event;
	import com.gestureworks.core.gw_public;
	//import com.gestureworks.core.TouchSpriteBase;
	
	public class ObjectManager 
	{
		private static var count:int;
		
		gw_public static function initialize():void{}
		
		public static function registerTouchObject(touchObject:Object):int //TouchSpriteBase
		{	
			touchObject.clusterID = count;
			
			GestureGlobals.gw_public::touchObjects[count] = touchObject;
			
			GestureGlobals.gw_public::objectCount++;
			
			count++;
			
			return touchObject.clusterID;
		}
		
		public static function unRegisterTouchObject(touchObject:Object):void//TouchSpriteBase
		{
			delete GestureGlobals.gw_public::touchObjects[count];
			
			count--;
			
			GestureGlobals.gw_public::objectCount--;
		}
		
	}
}