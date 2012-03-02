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
	import flash.ui.*;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.display.StageScaleMode;
	import flash.display.StageAlign;
	import flash.display.StageDisplayState;
	import com.gestureworks.text.DefaultFonts;
	import com.gestureworks.text.MyFonts;
	import flash.utils.setInterval;
	import flash.utils.clearInterval;
	import com.gestureworks.utils.Simulator;
	//import com.gestureworks.utils.TUIO;
	import com.gestureworks.tuio.TuioLink;
	
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
		
		private var _settingsPath:String;
		public function get settingsPath():String{return _settingsPath;}
		public function set settingsPath(value:String):void
		{
			if (_settingsPath == value) return;
			_settingsPath = value;
			if(initialized) create();
		}
		
		private var _fullscreen:Boolean;
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
		public function get key():String{return _key;}
		public function set key(value:String):void
		{
			if (key == value) return;
			_key = value;
		}
		
		private var _simulator:Boolean;
		public function get simulator():Boolean{return _simulator;}
		public function set simulator(value:Boolean):void
		{
			if (simulator == value) return;
			_simulator = value;
			Simulator.initialize(simulator);
		}
		
		private var _tuio:Boolean;
		public function get tuio():Boolean{return _tuio;}
		public function set tuio(value:Boolean):void
		{
			if (tuio == value) return;
			_tuio = value;
			TuioLink.initialize(stage);
		}
					
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			var df:DefaultFonts = new DefaultFonts();
			var mf:MyFonts = new MyFonts();
			
			graphics.beginFill(0xFFFFFF,0);
			graphics.drawRect(0, 0, stage.stageWidth, stage.stageHeight);
			graphics.endFill(); 
			
			//Multitouch.inputMode = MultitouchInputMode.NONE;
			Multitouch.inputMode = MultitouchInputMode.TOUCH_POINT;
			GestureWorks.supportsTouch = Multitouch.supportsTouchEvents;
			
			GestureWorks.application = stage;
			
			initialized = true;
			
			if (settingsPath) create();
			else timeInterval = setInterval(timerComplete, 500);
		}
		
		private function timerComplete():void
		{
			clearInterval(timeInterval);
			
			create();
		}
		
		protected function create():void{}
		protected function gestureworksInit():void{}
	}
}