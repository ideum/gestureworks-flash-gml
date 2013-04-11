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
	/*	
		IMPORTANT NOTE TO DEVELOPER **********************************************
		 
		PlEASE DO NOT ERASE OR DEVALUE ANYTHING WHITHIN THIS CLASS IF YOU DO NOT UNDERSTAND IT'S CURRENT VALUE OR PLACE... PERIOD...
		IF YOU HAVE ANY QUESTIONS, ANY AT ALL. PLEASE ASK PAUL LACEY (paul@ideum.com) ABOUT IT'S IMPORTATANCE.
		IF PAUL IS UNABLE TO HELP YOU UNDERSTAND, THEN PLEASE LOOK AND READ THE ACTUAL CODE FOR IT'S PATH.
		SOMETHINGS AT FIRST MAY NOT BE CLEAR AS TO WHAT THE ACTUAL PURPOSE IS, BUT IT IS VALUABLE AND IS USED IF IT IS CURRENTLY WRITTTEN HERE.
		DO NOT TAKE CODE OUT UNLESS YOUR CHANGES ARE VERIEFIED, TESTED AND CONTINUE TO WORK WITH LEGACY BUILDS !
		
	*/
		
	import com.gestureworks.core.*;
	import com.gestureworks.managers.*;
	import com.gestureworks.utils.*;
	import flash.display.*;
	import flash.events.*;
	import flash.ui.*;
	import flash.utils.*;
	
	
	public class GestureWorksCore extends Sprite
	{		
		private var fontManager:FontManager;		
		private var modeManager:ModeManager;
		private var modeManagerInit:Boolean = true;		
		private var _root:* = root;
		private var cmlDisplays:Array;
		
		public function GestureWorksCore()
		{
			super();
			fontManager = new FontManager;			
			modeManager = new ModeManager;
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		/**
		 * Returns whether your device currently has touch support available.
		 */
		protected static var _supportsTouch:Boolean;
		
		/**
		 * Returns whether gestureworks has initialized. 
		 */
		protected var initialized:Boolean = false;
		
		
		private var _gml:String;
		/**
		 * Sets gml file path. Path is relevant to application.
		 */
		public function get gml():String{return _gml;}
		public function set gml(value:String):void
		{
			if (_gml == value) return;
			_gml = value;
			
			if (_gml)
				startGmlParse();
		}		
		
		
		private var _cml:String;
		/**
		 * Sets cml file path. Path is relevant to application.
		 */
		public function get cml():String{return _cml;}
		public function set cml(value:String):void
		{
			if (_cml == value) return;
			if (value == "") return;
			_cml = value;
			
			if (_cml) {
				if (!cmlDisplays) cmlDisplays = [];
				startCmlParse();
			}
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
		
		
		private var _key:String = "";
		/**
		 * Deprecated: No longer requires a key.
		 */
		[Deprecated(replacement = "none")]	
		public function get key():String{return _key;}
		public function set key(value:String):void
		{
			if (key == value) return;
			_key = value;
		}
		
		private var _auto:Boolean = false;
		/**
		 * Attempts to auto-select input type. Used to revert to the mouse
		 * simulator when a touch device can not be found.
		 * @default false
		 */
		public function get auto():Boolean { return _auto; }
		public function set auto(value:Boolean):void
		{
			if (_auto == value) return;
			_auto = value;
			
			if (_auto && !GestureWorks.supportsTouch) 
				simulator = true;			
		}			
		
		private var _nativeTouch:Boolean = true;
		/**
		 * Overrides native touch input
		 * @default true
		 */
		public function get nativeTouch():Boolean { return _nativeTouch; }
		public function set nativeTouch(value:Boolean):void
		{
			if (_nativeTouch == value) return;
			_nativeTouch = value;
			
			GestureWorks.activeNativeTouch = _nativeTouch;
			
			if (!_nativeTouch)
				Multitouch.inputMode = MultitouchInputMode.NONE;
			else
				Multitouch.inputMode = MultitouchInputMode.TOUCH_POINT;	
				
			updateTouchObjects();
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
				Simulator.gw_public::initialize();
				
			updateTouchObjects();
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
				TUIOManager.gw_public::initialize();
				
			updateTouchObjects();
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
			
			if (_sensor) 
				SensorManager.gw_public::initialize();
		}
		
		private var _leap2D:Boolean = false;
		/**
		 * Turns leap 2D motion input on
		 * @default false
		 */
		public function get leap2D():Boolean { return _leap2D; }
		public function set leap2D(value:Boolean):void
		{
			if (_leap2D == value) return;
			_leap2D = value;
			
			if (_leap2D){
				MotionManager.leapmode = "2d";
				motion = true;
			}
		}
		
		private var _leap3D:Boolean = false;
		/**
		 * Turns leap 3D motion input on
		 * @default false
		 */
		public function get leap3D():Boolean { return _leap3D; }
		public function set leap3D(value:Boolean):void
		{
			if (_leap3D == value) return;
			_leap3D = value;
			
			if (_leap3D){
				MotionManager.leapmode = "3d";
				motion = true;
			}
		}
		
		/**
		 * Updates event listeners depending on the active modes
		 */
		protected function updateTouchObjects():void
		{
			for each(var obj:* in GestureGlobals.gw_public::touchObjects) {
				if (obj is TouchSprite)
					TouchSprite(obj).updateListeners();
			}				
		}
		
		
		// private methods //
		
		
		
		// INITIALIZATION METHOD
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			Multitouch.inputMode = MultitouchInputMode.TOUCH_POINT;
			_supportsTouch = Multitouch.supportsTouchEvents;			
			
			GestureWorks.activeNativeTouch = _supportsTouch;
			GestureWorks.application = stage;
			
			loadModeManager();
			
			initialized = true;			
			
			dispatchEvent(new Event(GestureWorks.GESTUREWORKS_COMPLETE));			
			gestureworksInit();			
		}		
		
		// loads the mode manager
		private function loadModeManager():void
		{			
			addChild(modeManager);
		}			
		
		// loads current cml file
		private function startCmlParse():void
		{
			CMLLoader.getInstance(cml).load(cml);
			CMLLoader.getInstance(cml).addEventListener(CMLLoader.COMPLETE, CMLLoaderComplete);			
		}
		
		// loads current gml file
		private function startGmlParse():void
		{			
			GMLParser.settingsPath = gml;
			GMLParser.addEventListener(GMLParser.settingsPath, gmlParserComplete);
		}
		
		// parse loaded cml file
		private function CMLLoaderComplete(event:Event):void
		{			
			CML.Objects = CMLLoader.getInstance(cml).data;
				
			if (CML.Objects.@simulator == "true") 
				simulator = true;
			
			if (CML.Objects.@tuio == "true") 
				tuio = true;

			if (CML.Objects.@fullscreen == "true") 
				fullscreen = true;	
				
			if (CML.Objects.@leap2D == "true") 
				leap2D = true;
			
			if (CML.Objects.@leap3D == "true") 
				leap3D = true;
			
			try {
				var CMLDisplay:Class = getDefinitionByName("com.gestureworks.cml.core.CMLDisplay") as Class;
				var tmp:* = new CMLDisplay;
				addChild(tmp);
				tmp.init(CMLLoader.getInstance(cml).data);	
				cmlDisplays.push(tmp);
				
			}
			catch (e:Error) {
				trace(e);
				throw new Error("CML has not been properly intialized. You must make a renference to the CMLParser. ( e.g. CMLParser.addEventListener(CMLParser.COMPLETE, cmlInit); )");
			}
							
			if (!gml && CML.Objects.@gml) {
				_gml = CML.Objects.@gml;				
				startGmlParse();
			}
		}
		
		// parse loaded gml file
		private function gmlParserComplete(event:Event=null):void
		{
			GML.Gestures = GMLParser.settings;
			
			// defined global settings for GML
			//if (GML.Gestures.gloabl_settings.input.@motion == "true") 
				//motion = true;
				
			//if (GML.Gestures.gloabl_settings.input.@sensor == "true") 
				//sensor = true;
			
		}
		
		protected function gestureworksInit():void{}
	}
}