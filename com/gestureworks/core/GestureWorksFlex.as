////////////////////////////////////////////////////////////////////////////////
//
//  IDEUM
//  Copyright 2011-2012 Ideum
//  All Rights Reserved.
//
//  GestureWorks
//
//  File:    GestureWorksFlex.as
//  Authors:  Ideum
//             
//  NOTICE: Ideum permits you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////
package com.gestureworks.core
{
	import flash.display.Stage;
	import flash.events.Event;
	import com.gestureworks.utils.CMLLoader;
	import com.gestureworks.utils.GMLParser;
	import com.gestureworks.managers.ModeManager;
	import com.gestureworks.utils.Simulator;
	//import com.gestureworks.utils.TUIO;
	import com.gestureworks.tuio.TuioLink;
	import com.gestureworks.cml.components.CMLDisplay;
	import com.gestureworks.utils.Yolotzin;
	import flash.utils.ByteArray;
		
	public class GestureWorksFlex extends GestureWorksCoreFlex
	{
		public static var version:String = "3.0.4";
		public static var copyright:String = "© 2009-2012 Ideum Inc.\nAll Rights Reserved";
		public static var GESTUREWORKS_COMPLETE:String = "gestureworks complete";
		public static var isRunTime:Boolean;
		public static var application:Stage;
		public static var supportsTouch:Boolean;
		public static var activeTUIO:Boolean;  
		public static var currentKeyCode:int;
		public static var isShift:Boolean;
		//public static var touchMoveMarshall:Boolean = false;
		public static var fileName:String="app:/key";
		private var modeManager:ModeManager;
		private var componentDisplay:CMLDisplay;
		private var _gwComplete:Boolean;
		private var _root:* = root;
		public static var hasCML:Boolean;
		
						
		public function GestureWorksFlex(cmlSettingsPath:String = null)
		{
			super();
			if(cmlSettingsPath) settingsPath = cmlSettingsPath;
		}
		
		public function get gwComplete():Boolean{return _gwComplete;}
		public function set gwComplete(value:Boolean):void
		{
			_gwComplete = value;
						
			componentDisplay = new CMLDisplay();
			addChild(componentDisplay);
		}
		
		public function set writeComplete(value:Boolean):void
		{
			dispatchEvent(new Event(GestureWorks.GESTUREWORKS_COMPLETE));
			gestureworksInit();
		}
		
		override protected function create():void 
		{
			if (!settingsPath)
			{				
				loadModeManager();
			}
			else
			{
				hasCML = true;
				
				CMLLoader.settingsPath = settingsPath;
				CMLLoader.addEventListener(CMLLoader.settingsPath, CMLLoaderComplete);
			}
		}
		
		private function CMLLoaderComplete(event:Event):void
		{
			CML.Objects = CMLLoader.settings;
			startGmlParse();
			var simString:String = CML.Objects.@simulator;
			
			key = CMLLoader.settings.@key;
			
			if (CML.Objects.@simulator == "true") Simulator.initialize();
			if (CML.Objects.@tuio == "true") TuioLink.initialize(stage);
		}
		
		private function startGmlParse():void
		{
			var gmlPath:String = CML.Objects.@gml;
			
			if (gmlPath == "")
			{
				loadModeManager();
				return;
			}
			
			GMLParser.settingsPath = gmlPath;
			GMLParser.addEventListener(GMLParser.settingsPath, gmlParserComplete);
		}
		
		private function gmlParserComplete(event:Event):void
		{
			GML.Gestures = GMLParser.settings;
			loadModeManager();
		}
		
		private function loadModeManager():void
		{
			if (parent.toString() != "[Object Stage]") _root = parent.root;
			modeManager = new ModeManager(_root, key)
			addChild(modeManager);
		}
		
	}
}