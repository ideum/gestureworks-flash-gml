////////////////////////////////////////////////////////////////////////////////
//
//  IDEUM
//  Copyright 2011-2012 Ideum
//  All Rights Reserved.
//
//  GestureWorks
//
//  File:    DMLParsers.as
//  Authors:  Ideum
//             
//  NOTICE: Ideum permits you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////
package com.gestureworks.utils
{
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.events.Event;
	import flash.events.EventDispatcher;

	/**
	 * This is the DML Parser class.
	 */
	public class DMLParser extends EventDispatcher
	{
		public static var settings:*;
		private static var _settingsPath:String="";
		private static var settingsLoader:URLLoader;
		protected static var dispatch:EventDispatcher;
		public static var content:Array = new Array();
		public static const COMPLETE:String = "COMPLETE";
		private static var dmlPaths:Array;

		public static function get settingsPath():String
		{
			return _settingsPath;
		}

		public static function set settingsPath(value:String):void
		{
			if (_settingsPath==value)
				return;

			settings = null;
			settingsLoader = new URLLoader();
			settingsLoader.addEventListener(Event.COMPLETE, settingsLoader_completeHandler);
			_settingsPath = value;
			dmlPaths = _settingsPath.split(",");
			loadPaths();
		}
		
		private static function loadPaths():void {
			if(dmlPaths.length){
				settingsLoader.load(new URLRequest(StringUtils.trim(dmlPaths[0])));
				dmlPaths.shift();
			}
			else {
				dispatchEvent(new Event(settingsPath));
				settingsLoader.removeEventListener(Event.COMPLETE, settingsLoader_completeHandler);
				settingsLoader = null;
				dispatchEvent(new Event(DMLParser.COMPLETE, true, true));	
				dmlPaths = null;
			}
		}

		private static function settingsLoader_completeHandler(event:Event):void
		{
			if(!settings)
				settings = new XML(settingsLoader.data);						
			else {
				for each (var node:XML in XML(settingsLoader.data).*)
					settings.appendChild(node);
			}
			loadPaths();
		}

		public static function addEventListener(p_type:String, p_listener:Function, p_useCapture:Boolean=false, p_priority:int=0, p_useWeakReference:Boolean=false):void
		{
			if (dispatch==null)
				dispatch = new EventDispatcher();
			dispatch.addEventListener(p_type, p_listener, p_useCapture, p_priority, p_useWeakReference);
		}

		public static function removeEventListener(p_type:String, p_listener:Function, p_useCapture:Boolean=false):void
		{
			if (dispatch==null)
				return;
			dispatch.removeEventListener(p_type, p_listener, p_useCapture);
		}

		public static function dispatchEvent(event:Event):void
		{
			if (dispatch==null)
				return;
			dispatch.dispatchEvent(event);
		}

	}
}