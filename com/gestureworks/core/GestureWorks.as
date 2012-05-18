////////////////////////////////////////////////////////////////////////////////
//
//  IDEUM
//  Copyright 2011-2012 Ideum
//  All Rights Reserved.
//
//  GestureWorks
//
//  File:    GestureWorks.as
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
	import com.gestureworks.tuio.TUIO;
	import com.gestureworks.core.CML;
	import com.gestureworks.utils.Yolotzin;
	import flash.utils.ByteArray;
	import flash.utils.getDefinitionByName;
		
	/**
		 * The GestureWorks class is the core class that can be accessed from all classes within.
		 * It can be initialized as a super class, or as an instantiation; var gestureworks:GestureWorks = new GestureWorks();
		 * You can add a .cml settings path;  settingsPath = ""; or  new GestureWorks("pathToCml");
		 * 
		 * Gestureworks.application = stage;
		 * GestureWorks.supportsTouch;
		 * GestureWorks.activeTUIO;
		 * 
		 * package
		 * {
		 * 		import com.gestureworks.core.GestureWorks;
		 * 		import flash.events.Event;
		 * 		public class Main extends GestureWorks
		 * 		{
		 * 			super();
		 * 			settingsPath = "library/cml/my_application_4.cml";
		 * 			fullscreen = true;
		 * 		}
		 * 
		 * 		override protected function gestureworksInit():void
		 * 		{
		 * 			trace("GestureWorks has intialized");
		 * 		}
		 * 		}
		 * 	}
		 * 
		 */
	
		 
		/* 
		
		IMPORTANT NOTE TO DEVELOPER **********************************************
		 
		PlEASE DO NOT ERASE OR DEVALUE ANYTHING WHITHIN THIS CLASS IF YOU DO NOT UNDERSTAND IT'S CURRENT VALUE OR PLACE... PERIOD...
		IF YOU HAVE ANY QUESTIONS, ANY AT ALL. PLEASE ASK PAUL LACEY (paul@ideum.com) ABOUT IT'S IMPORTATANCE.
		IF PAUL IS UNABLE TO HELP YOU UNDERSTAND, THEN PLEASE LOOK AND READ THE ACTUAL CODE FOR IT'S PATH.
		SOMETHINGS AT FIRST MAY NOT BE CLEAR AS TO WHAT THE ACTUAL PURPOSE IS, BUT IT IS VALUABLE AND IS USED IF IT IS CURRENTLY WRITTTEN HERE.
		DO NOT TAKE CODE OUT UNLESS YOUR CHANGES ARE VERIEFIED, TESTED AND CONTINUE TO WORK WITH LEGACY BUILDS !
		
		*/
	
	public class GestureWorks extends GestureWorksCore
	{
		/**
		 * Returns the current version of GestureWorks.
		 */
		public static var version:String = "3.6.0";
		/**
		 * Returns the current copyright information for GestureWorks.
		 */
		public static var copyright:String = "© 2009-2012 Ideum Inc.\nAll Rights Reserved";
		/**
		 * String is the dispatcher for GestureWorks framework.
		 */
		public static var GESTUREWORKS_COMPLETE:String = "gestureworks complete";
		/**
		 * @private
		 */
		public static var isRunTime:Boolean;
		/**
		 * Var = stage.
		 */
		public static var application:Stage;
		/**
		 * Returns weather your device currently has touch support available.
		 */
		public static var supportsTouch:Boolean;
		/**
		 * Returns weather TUIO is activated.
		 */
		public static var activeTUIO:Boolean;
		/**
		 * @private
		 */
		public static var currentKeyCode:int;
		/**
		 * Determines if Shift key is down or Up.  For use with simulator.
		 */
		public static var isShift:Boolean;
		/**
		 * Returns if the GestureWorks framework has an accessed .cml.
		 */
		public static var hasCML:Boolean;
		/**
		 * @private
		 */
		public static var fileName:String = "app:/key";
		/**
		 * @private
		 */
		public static var isOpenExibits:Boolean;
		
		private var modeManager:ModeManager;
		private var _gwComplete:Boolean;
		private var _root:* = root;
		
		
		/**
		 * 
		 * The GestureWorks constructor.
		 * var gestureworks:GestureWorks = new GestureWorks();
		 * 
		 */
		public function GestureWorks(cmlSettingsPath:String = null)
		{
			super();
			
			if (cmlSettingsPath) settingsPath = cmlSettingsPath;
			
			if (!supportsTouch) simulator = true;
		}
		
		/**
		 * @private
		 */
		public function get gwComplete():Boolean
		{
			return _gwComplete;
		}
		/**
		 * @private
		 */
		public function set gwComplete(value:Boolean):void
		{
			_gwComplete = value;
			
			if (hasCML)
			{
				try
				{
					var CMLDisplay:Class = getDefinitionByName("com.gestureworks.components.CMLDisplay") as Class;
					var componentDisplay:* = new CMLDisplay();
					addChild(componentDisplay);
				}
				catch (e:Error)
				{
					throw new Error("if you are trying to utilize CML and/or have included a settingsPath in your Main doc class, please make sure that you have included this statement into your Main Document class:  ' import com.gestureworks.components.CMLDisplay; CMLDisplay; '. ");
				}
			}
			else
			{
				writeComplete = true;
			}
		}
		/**
		 * @private
		 */
		public function set writeComplete(value:Boolean):void
		{
			dispatchEvent(new Event(GestureWorks.GESTUREWORKS_COMPLETE));
			
			gestureworksInit();
		}
		
		/**
		 * 
		 * protected function create().
		 * this is where the gestureworks begin it's intialization.
		 * 
		 */
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
			key = CMLLoader.settings.@key;
			if (CML.Objects.@simulator == "true") Simulator.initialize();
			if (CML.Objects.@tuio == "true") TUIO.initialize();
			startGmlParse();
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