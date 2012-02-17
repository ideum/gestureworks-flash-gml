////////////////////////////////////////////////////////////////////////////////
//
//  IDEUM
//  Copyright 2011-2012 Ideum
//  All Rights Reserved.
//
//  GestureWorks
//
//  File:    Parser.as
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
	import com.gestureworks.events.CMLEvent;

	/**
	 * This is the Parser class.
	 * 
	 * @langversion 3.0
	 * @playerversion AIR 2
	 * @playerversion Flash 10
	 * @playerversion Flash Lite 4
	 * @productversion GestureWorks 2.0
	 */
	public class Parser extends EventDispatcher
	{
		public var settings:*;
		private var _settingsPath:String="";
		public var totalAmount:int;
		public var amountToShow:int;
		private var settingsLoader:URLLoader;
		protected var dispatch:EventDispatcher;
		public var content:Array = new Array();
		
		public function Parser(rendererPath:String) 
		{
			super();
			
			settingsPath=rendererPath;
		}

		public function get settingsPath():String
		{
			return _settingsPath;
		}

		public function set settingsPath(value:String):void
		{
			if (_settingsPath==value)
			{
				return;
			}

			settingsLoader = new URLLoader();
			settingsLoader.addEventListener(Event.COMPLETE, settingsLoader_completeHandler);
			_settingsPath=value;
			settingsLoader.load(new URLRequest(_settingsPath));
		}

		private function settingsLoader_completeHandler(event:Event):void
		{
			settings=new XML(settingsLoader.data);
			
			amountToShow=settings.GlobalSettings.amountToShow;
			
			totalAmount=settings.Content.Source.length();
			
			if(!amountToShow)
			{
				amountToShow=totalAmount;
			}
			
			dispatchEvent(new CMLEvent(CMLEvent.COMPLETE));
			
			settingsLoader.removeEventListener(Event.COMPLETE, settingsLoader_completeHandler);
			settingsLoader=null;
		}
	}
}