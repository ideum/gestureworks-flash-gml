////////////////////////////////////////////////////////////////////////////////
//
//  IDEUM
//  Copyright 2011-2012 Ideum
//  All Rights Reserved.
//
//  GestureWorks
//
//  File:    GestureWorksCoreFlex.as
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
	import com.gestureworks.tuio.TuioLink;
	import spark.core.SpriteVisualElement;
		
	public class GestureWorksCoreFlex extends SpriteVisualElement
	{		
		protected var flex_initialized:Boolean;
		private var timeInterval:uint;
		
		public function GestureWorksCoreFlex()
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
			if(flex_initialized) create();
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
			
			Multitouch.inputMode = MultitouchInputMode.TOUCH_POINT;
			GestureWorks.supportsTouch = Multitouch.supportsTouchEvents;
			GestureWorksFlex.supportsTouch = Multitouch.supportsTouchEvents;
			
			GestureWorks.application = stage;
			GestureWorksFlex.application = stage;
			
			flex_initialized = true;
			
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