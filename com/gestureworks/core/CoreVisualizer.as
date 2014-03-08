////////////////////////////////////////////////////////////////////////////////
//
//  IDEUM
//  Copyright 2011-2012 Ideum
//  All Rights Reserved.
//
//  GestureWorks
//
//  File:    TouchSpriteDebugDisplay.as
//  Authors:  Ideum
//             
//  NOTICE: Ideum permits you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////
package com.gestureworks.core
{
	import flash.events.Event;
	import flash.display.Sprite;
	
	import com.gestureworks.visualizer.CorePointVisualizer;
	//import com.gestureworks.visualizer.ClusterVisualizer;
	//import com.gestureworks.visualizer.GestureVisualizer;
	import com.gestureworks.objects.SensorPointObject;
	import com.gestureworks.objects.MotionPointObject;
	import com.gestureworks.objects.TouchPointObject;
	
	import com.gestureworks.managers.ClusterHistories;
	import com.gestureworks.managers.TransformHistories;

	public class CoreVisualizer
	{
		/**
		* @private
		*/
		private var gs:CoreSprite;//TouchSprite;
		/**
		* @private
		*/
		private var id:uint
		/**
		* displays touch cluster and gesture visulizations on the touchSprite.
		*/
		public var debug_display:Sprite;
		/**
		* @private
		*/
		public var point:CorePointVisualizer;
		/**
		* @private
		*/
		private var viewAlwaysOn:Boolean = false;
		/**
		* @private
		*/
		private var _pointDisplay:Boolean = true;
		/**
		* activates point visualization methods.
		*/
		public function get pointDisplay():Boolean { return _pointDisplay; }
		public function set pointDisplay(value:Boolean):void{_pointDisplay = value;}
		
		private var touchArray:Vector.<TouchPointObject>;
		private var motionArray:Vector.<MotionPointObject>;
		private var sensorArray:Vector.<SensorPointObject>;
		
		
		public function CoreVisualizer():void
		{
			//trace("preinit core vizualizer");
			gs = GestureGlobals.gw_public::core;
			touchArray = GestureGlobals.gw_public::touchArray;
			motionArray = GestureGlobals.gw_public::motionArray;
			sensorArray = GestureGlobals.gw_public::sensorArray;
			
			
			//ADD POINT DISPLAY TO STAGE
			point = new CorePointVisualizer();
			point.init();
			GestureWorks.application.stage.addChild(point)
        }

	/**
	* @private
	*/
	public function updateDebugDisplay():void
	{
		//if (debug_display)
		//trace("updating core viz display", point);
		if (point)
		{
			
			point.clear();
			point.draw();
		}
	}
	//////////////////////////////////////////////////////////////////////////////////////////	
	
	}
}