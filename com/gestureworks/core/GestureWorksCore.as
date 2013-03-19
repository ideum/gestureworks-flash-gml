////////////////////////////////////////////////////////////////////////////////
//
//  IDEUM
//  Copyright 2011-2012 Ideum
//  All Rights Reserved.
//
//  GestureWorks
//
//  File:    GestureWorksCore.as
//  Authors:  Ideum
//             
//  NOTICE: Ideum permits you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

package com.gestureworks.core
{
	import com.gestureworks.managers.MotionManager;
	import flash.ui.*;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.display.StageScaleMode;
	import flash.display.StageAlign;
	import flash.display.StageDisplayState;
	import com.gestureworks.text.DefaultFonts;
	import flash.utils.setInterval;
	import flash.utils.clearInterval;
	import com.gestureworks.utils.Simulator;
	import com.gestureworks.tuio.TUIO;
	
	/* 
		
		IMPORTANT NOTE TO DEVELOPER **********************************************
		 
		PlEASE DO NOT ERASE OR DEVALUE ANYTHING WHITHIN THIS CLASS IF YOU DO NOT UNDERSTAND IT'S CURRENT VALUE OR PLACE... PERIOD...
		IF YOU HAVE ANY QUESTIONS, ANY AT ALL. PLEASE ASK PAUL LACEY (paul@ideum.com) ABOUT IT'S IMPORTATANCE.
		IF PAUL IS UNABLE TO HELP YOU UNDERSTAND, THEN PLEASE LOOK AND READ THE ACTUAL CODE FOR IT'S PATH.
		SOMETHINGS AT FIRST MAY NOT BE CLEAR AS TO WHAT THE ACTUAL PURPOSE IS, BUT IT IS VALUABLE AND IS USED IF IT IS CURRENTLY WRITTTEN HERE.
		DO NOT TAKE CODE OUT UNLESS YOUR CHANGES ARE VERIEFIED, TESTED AND CONTINUE TO WORK WITH LEGACY BUILDS !
		
		*/
		
	public class GestureWorksCore extends Sprite
	{		
		protected var initialized:Boolean;
		private var timeInterval:uint;
		
		public function GestureWorksCore()
		{
			super();
			
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		

		private var _gml:String;
		/**
		 * Sets gml file path. Path is relevant to application.
		 */
		public function get gml():String{return _gml;}
		public function set gml(value:String):void
		{
			if (_gml == value) return;
			_gml = value;
		}		
		
		
		private var _cml:String;
		/**
		 * Sets gml file path. Path is relevant to application.
		 */
		public function get cml():String{return _cml;}
		public function set cml(value:String):void
		{
			if (_cml == value) return;
			if (value == "") {
				_cml = value;
				return;
			}
			
			_cml = value;
			_settingsPath = value;
			if (initialized) create();
		}
		
		
		private var _settingsPath:String;
		[Deprecated(replacement="cml")] 		
		public function get settingsPath():String{return _cml;}
		public function set settingsPath(value:String):void
		{
			cml = value;
		}		
		
		
		private var _fullscreen:Boolean = false;
		/**
		 * Sets the application to fullscreen
		 * @default false
		 */
		public function get fullscreen():Boolean{return _fullscreen;}
		public function set fullscreen(value:Boolean):void
		{
			if (_fullscreen == value) return;
			
			_fullscreen = value;
			
			if (! fullscreen) return;
			
			stage.scaleMode=StageScaleMode.NO_SCALE;
			stage.displayState=StageDisplayState.FULL_SCREEN;
			stage.align = StageAlign.TOP_LEFT;
		}
		
		
		private var _key:String;
		/**
		 * Sets GestureWorks or OpenExhibits license key
		 */
		public function get key():String{return _key;}
		public function set key(value:String):void
		{
			if (key == value) return;
			_key = value;
		}
		
		
		private var _simulator:Boolean = false;
		/**
		 * Turns on the mouse simulator.
		 * @default false
		 */
		public function get simulator():Boolean{return _simulator;}
		public function set simulator(value:Boolean):void
		{
			if (simulator == value) return;
			_simulator = value;
			
			if (simulator)
				Simulator.initialize(simulator);
		}
		
		
		private var _tuio:Boolean = false;
		/**
		 * Turns TUIO input on. Currently only supported in AIR.
		 * @default false
		 */
		public function get tuio():Boolean{return _tuio;}
		public function set tuio(value:Boolean):void
		{
			if (tuio == value) return;
			_tuio = value;
			
			if (_tuio) 
				TUIO.initialize();
		}
		
		
		
		private var _motion:Boolean = false;
		/**
		 * Turns motion input on.Currently only supports Leap
		 * @default false
		 */
		public function get motion():Boolean{return _motion;}
		public function set motion(value:Boolean):void
		{
			if (motion == value) return;
			_motion = value;
			
			if (_motion) 
				MotionManager.gw_public::initialize();
		}
		
		
		private var _sensor:Boolean = false;
		/**
		 * Turns sensor input on. Currently only supports Accelerometer in Air.
		 * @default false
		 */
		public function get sensor():Boolean{return _sensor;}
		public function set sensor(value:Boolean):void
		{
			if (sensor == value) return;
			_sensor = value;
			
			//trace("init accelerometer in GestureWorksCore.as");
			//if (_sensor) 
				//Acceelerometer.initialize();
		}
		
		
		
		
		// private methods //
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			var df:DefaultFonts = new DefaultFonts();
			
			graphics.beginFill(0xFFFFFF,0);
			graphics.drawRect(0, 0, stage.stageWidth, stage.stageHeight);
			graphics.endFill(); 
			
			//Multitouch.inputMode = MultitouchInputMode.NONE;
			Multitouch.inputMode = MultitouchInputMode.TOUCH_POINT;
			GestureWorks.supportsTouch = Multitouch.supportsTouchEvents;
			
			GestureWorks.application = stage;
			initialized = true;
			
			if (cml) create();
			else timeInterval = setInterval(timerComplete, 500);
		}
		
		private function timerComplete():void
		{
			clearInterval(timeInterval);
			create();
		}
		
		
		// protected //
		
		protected function create():void{}
		protected function gestureworksInit():void{}
	}
}