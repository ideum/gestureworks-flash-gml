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
	import com.gestureworks.interfaces.ITouchObject;
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
			if (stage) setApplication();
			else addEventListener(Event.ADDED_TO_STAGE, setApplication);
		}
		
		private function setApplication(event:Event = null):void {
			GestureWorks.application = stage;	
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
		
		private var _dml:String;
		/**
		 * Sets dml file path. Path is relevant to application.
		 */
		public function get dml():String{return _dml;}
		public function set dml(value:String):void
		{
			if (_dml == value) return;
			if (value == "") return;
			_dml = value;
			
			if (_dml)startDmlParse();
		
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
			stage.displayState = StageDisplayState.FULL_SCREEN_INTERACTIVE;
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
			if (_key == value) return;
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
		
		private var _nativeTouch:Boolean = false; // if default true will not init properly
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
			//trace("gw core ",GestureWorks.activeNativeTouch,_nativeTouch)
			
			if (_nativeTouch) 
			{
				Multitouch.inputMode = MultitouchInputMode.TOUCH_POINT;	
				TouchManager.gw_public::initialize();
				InteractionManager.gw_public::initialize(); // NEED NOW FOR 
				trace("native touch is on");
			}
			else {
				Multitouch.inputMode = MultitouchInputMode.NONE;
				TouchManager.gw_public::deInitialize();				
				trace("native touch is off");
			}
		}
		
		private var _nativeAccel:Boolean = true;
		/**
		 * Overrides native accel input
		 * @default true
		 */
		public function get nativeAccel():Boolean { return _nativeAccel; }
		public function set nativeAccel(value:Boolean):void
		{
			if (_nativeAccel == value) return;
			_nativeAccel = value;
			
			GestureWorks.activeNativeAccel = _nativeAccel;	
			
			if(_nativeAccel) {
				//Multitouch.inputMode = MultitouchInputMode.TOUCH_POINT;	
				//TouchManager.gw_public::initialize();
				//trace("native touch is on");
				
			}
			else {
				//Multitouch.inputMode = MultitouchInputMode.NONE;
				//TouchManager.gw_public::deInitialize();				
				//trace("native touch is off");
			}
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
			
			GestureWorks.activeSim = _simulator;
			if (_simulator){
				Simulator.gw_public::initialize();
				trace("simulator is on");
			}
			else{
				Simulator.gw_public::deInitialize();
				trace("simulator is off");
			}
				
			updateTouchObjects();
		}
		
		private var _tuio:* = false;
		/**
		 * Enables tuio input. To apply default settings, assign "true" to this flag. TUIO settings can be modified through the tuio variable 
		 * with the following syntax: tuio = "host:host id, port:port#, protocol:protocol name". The supported protocols are UDP, TCP, and FLOSC. By default,
		 * AIR applications use UDP on port 3333 and Flash applications use TCP on port 3000.
		 *
		 * @default false
		 */
		public function get tuio():*{return _tuio;}
		public function set tuio(value:*):void
		{
			if (tuio == value) return;
			_tuio = value;
									
			var host:String = "127.0.0.1";
			var port:int;
			var protocol:String;			
			
			//parse string for TUIO arguments
			if (value is String) {
				for each(var arg:String in String(_tuio).split(",")) {
					var keyVal:Array = arg.split(":");
					var prop:String = StringUtils.trim(keyVal[0]).toLowerCase(); 
					var val:String = StringUtils.trim(keyVal[1]).toLowerCase(); 

					switch(prop) {
						case "host":
							host = val;
							break;
						case "port":
							port = int(val);
							break;
						case "protocol":
							protocol = val;
							break;
						default:
							break;
					}
				}
					
				_tuio = true;
			}
			
			GestureWorks.activeTUIO = _tuio;
			if (_tuio) {
				TUIOManager.gw_public::initialize(host, port, protocol);						
				trace("TUIO is on");			
			}
			else {
				TUIOManager.gw_public::deInitialize();						
				trace("TUIO is off");
			}
				
			updateTouchObjects();				
		}
		private var _touch:Boolean = false;
		/**
		 * Turns touch input on 
		 * @default false
		 */
		public function get touch():Boolean{return _touch;}
		public function set touch(value:Boolean):void
		{
			if (touch == value) return;
			_touch = value;
			
			GestureWorks.activeTouch = _touch;
			if (_touch) {
				Multitouch.inputMode = MultitouchInputMode.TOUCH_POINT;	
				TouchManager.gw_public::initialize();
				InteractionManager.gw_public::initialize();
				trace("touch active")
			}
			else
				TouchManager.gw_public::deInitialize();
		}	
		
		private var _motion:Boolean = false;
		/**
		 * Turns motion input on. Currently only supports Leap
		 * @default false
		 */
		public function get motion():Boolean{return _motion;}
		public function set motion(value:Boolean):void
		{
			if (motion == value) return;
			_motion = value;
			
			GestureWorks.activeMotion = _motion;
			if (_motion) {
				MotionManager.gw_public::initialize();
				InteractionManager.gw_public::initialize();
			}
			else
				MotionManager.gw_public::deInitialize();
		}	
				
		private var _sensor:Boolean = false;
		/**
		 * Turns sensor input on.
		 * @default false
		 */
		public function get sensor():Boolean{return _sensor;}
		public function set sensor(value:Boolean):void
		{
			if (sensor == value) return;
			_sensor = value;
			
			GestureWorks.activeSensor = _sensor;
			if (_sensor) {
				SensorManager.gw_public::initialize();
				InteractionManager.gw_public::initialize();
			}
			else
				SensorManager.gw_public::deInitialize();
		}
		
		
		private var _wiimote:Boolean = false;
		/**
		 * Turns wiimote sensor input on.
		 * @default false
		 */
		public function get wiimote():Boolean{return _wiimote;}
		public function set wiimote(value:Boolean):void
		{
			if (wiimote == value) return;
			_wiimote = value;
			
			GestureWorks.activeSensor = _wiimote;
			if (_wiimote){
				SensorManager.wiimoteEnabled = true;
				sensor = true;
			}
			else
				sensor = false;
		}
		
		private var _voice:Boolean = false;
		/**
		 * Turns voice sensor input on.
		 * @default false
		 */
		public function get voice():Boolean{return _voice;}
		public function set voice(value:Boolean):void
		{
			if (voice == value) return;
			_voice = value;
			
			GestureWorks.activeSensor = _voice;
			if (_voice){
				SensorManager.voiceEnabled = true;
				sensor = true;
			}
			else
				sensor = false;
		}
		private var _arduino:Boolean = false;
		/**
		 * Turns arduino sensor input on.
		 * @default false
		 */
		public function get arduino():Boolean{return _arduino;}
		public function set arduino(value:Boolean):void
		{
			if (arduino == value) return;
			_arduino = value;
			
			GestureWorks.activeSensor = _arduino;
			if (_wiimote){
				SensorManager.arduinoEnabled = true;
				sensor = true;
			}
			else
				sensor = false;
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
			
			if (_leap2D) {
				MotionManager.leapEnabled = true;
				MotionManager.leapmode = "2d";
				motion = true;
			}
			else
				motion = false;
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
			
			if (_leap3D) {
				MotionManager.leapEnabled = true;
				MotionManager.leapmode = "3d";
				motion = true;
			}
			else
				motion = false;
		}
		
		private var _deviceServer:Boolean = false;
		/**
		 * Turns leap 3D motion input on
		 * @default false
		 */
		public function get deviceServer():Boolean { return _deviceServer; }
		public function set deviceServer(value:Boolean):void
		{
			if (_deviceServer == value) return;
			_deviceServer = value;
			
			if (_deviceServer) {
				
				DeviceServerManager.gw_public::initialize();
				
				MotionManager.leapEnabled = true;
				MotionManager.leapmode = "3d_ds";
				motion = true;
			}
			else
				motion = false;
		}
		
			
		/**
		 * Updates event listeners depending on the active modes
		 */
		protected function updateTouchObjects(obj:* = null):void
		{
			var i:int;
			
			if (!obj)
				obj = this;
				
			if (obj is ITouchObject)
				ITouchObject(obj).updateListeners();							
			else if (!obj.hasOwnProperty("numChildren"))
				return;
				
			for (i = 0; i < obj.numChildren; i++) 
				updateTouchObjects(obj.getChildAt(i));
		}
		
		
		// private methods //
		
		
		
		// INITIALIZATION METHOD
		private function init(e:Event = null):void 
		{		
			if (initialized) return;
			Multitouch.inputMode = MultitouchInputMode.TOUCH_POINT;
			_supportsTouch = Multitouch.supportsTouchEvents;			
			
			GestureWorks.activeNativeTouch = _supportsTouch;
			
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
			
			//trace("start gml parse",gml,GMLParser.settingsPath)
		}
		
		// loads current dml file
		private function startDmlParse():void
		{			
			DMLParser.settingsPath = dml;
			DMLParser.addEventListener(DMLParser.settingsPath, dmlParserComplete);
			
			//trace("start gml parse",gml,GMLParser.settingsPath)
		}
		
		/**
		 * Loads a dml file
		 * @param	dml The gml file path
		 */
		public function loadDML(dml:String):void {
			if (this.dml)
				this.dml += "," + dml;
			else
				this.dml = dml;
		}
		
		
		
		/**
		 * Loads a gml file
		 * @param	gml The gml file path
		 */
		public function loadGML(gml:String):void {
			if (this.gml)
				this.gml += "," + gml;
			else
				this.gml = gml;
		}
		
		/**
		 * Unloads a gml file
		 * @param	gml The gml file path
		 */
		public function unloadGML(gml:String):void {
			if (this.gml) {
				var gmlNew:String;
				var paths:Array = this.gml.split(",");
				paths.splice(paths.indexOf(StringUtils.trim(gml)), 1);
				for each(var path:String in paths) {
					if (gmlNew)
						gmlNew += "," + path;
					else
						gmlNew = path;
				}
				this.gml = gmlNew;
			}
		}
		
		// parse loaded cml file
		private function CMLLoaderComplete(event:Event):void
		{			
			CML.Objects = CMLLoader.getInstance(cml).data;
				
			if (CML.Objects.@nativeTouch == "false")
				nativeTouch = false;
			
			if (CML.Objects.@simulator == "true") 
				simulator = true;
			
			if (CML.Objects.@tuio == "true") 
				tuio = true;
			else if (CML.Objects.@tuio != undefined && CML.Objects.@tuio != "false")
				tuio = CML.Objects.@tuio.toString();

			if (CML.Objects.@fullscreen == "true") 
				fullscreen = true;	
				
			if (CML.Objects.@leap2D == "true") 
				leap2D = true;
			
			if (CML.Objects.@leap3D == "true") 
				leap3D = true;
				
				//NOTE NEED REDUNDANT OPTIONS FROM DML
				// NATIVE ACCELEROMETER	
				// WIIMOTE INIT
				// VOICE INIT
				// KINECT
				// ARDUINO
			
			try {
				var CMLDisplay:Class = getDefinitionByName("com.gestureworks.cml.core.CMLDisplay") as Class;
				var tmp:* = new CMLDisplay;
				addChild(tmp);
				tmp.initialize(CMLLoader.getInstance(cml).data);	
				cmlDisplays.push(tmp);
				
			}
			catch (e:Error) {
				trace(e);
			}
							
			if (!gml && CML.Objects.@gml) {
				_gml = CML.Objects.@gml;				
				startGmlParse();
				//trace("init no gml", gml)
			}
			
		}
		
		// parse loaded dml file
		private function dmlParserComplete(event:Event):void
		{
			DML.Devices = DMLParser.settings;
			
			DeviceManager.callDeviceParser();
		}
		
		// parse loaded gml file
		private function gmlParserComplete(event:Event):void
		{
			GML.Gestures = GMLParser.settings;
			init();
			reapplyGestures();
		}
		
		/**
		 * Reapply gestures per gml assignment
		 */
		private function reapplyGestures():void{ 
			for each(var obj:* in GestureGlobals.gw_public::touchObjects) {
				if (obj is ITouchObject)
					ITouchObject(obj).gestureList = ITouchObject(obj).gestureList;
			}	
		}
		
		protected function gestureworksInit():void{}
	}
}