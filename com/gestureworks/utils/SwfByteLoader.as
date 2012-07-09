////////////////////////////////////////////////////////////////////////////////
//
//  IDEUM
//  Copyright 2011-2012 Ideum
//  All Rights Reserved.
//
//  GestureWorks
//
//  File:    SwfByteLoader.as
//  Authors:  Ideum
//             
//  NOTICE: Ideum permits you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////
package com.gestureworks.utils
{
	import com.gestureworks.events.BinaryEvent;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.system.LoaderContext;
	import flash.utils.ByteArray;
	import flash.display.Loader;
	import flash.net.*
	import com.gestureworks.utils.Tpyrcne;
	
	public class SwfByteLoader extends Sprite
	{
		private var _configFile:String;
		public static var mode:int;
		public static var byteString:String;
		public static var installDate:String;
		public static var serialNumber:String;
		
		public function SwfByteLoader(cf:String)
		{
			_configFile = cf;
			
			var request:URLRequest = new URLRequest(cf);
			var binaryURLLoader:URLLoader = new URLLoader();
			binaryURLLoader.dataFormat = URLLoaderDataFormat.BINARY;
			binaryURLLoader.addEventListener(Event.COMPLETE, completeHandler);
			binaryURLLoader.load(request);
		}
		
		public function loadBytes(data:String):void
		{
			var bytes:ByteArray = new ByteArray();
			var byteLoaderContext:LoaderContext = new LoaderContext();
			var data1:Array = data.split("");
			var data2:Array = [];
			
			for (var i:int = 0; i < data1.length; i += 2) data2.push("0x" + data1[i] + data1[i + 1]);
				
			for (var j:int = 0; j < data2.length; j++) bytes[j] = data2[j];
				
			var byteLoader:Loader = new Loader();
			byteLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, byteLoaderCompleteHandler);
			byteLoaderContext.allowCodeImport = true;
			byteLoader.loadBytes(bytes, byteLoaderContext);
		}

		private function completeHandler(event:Event):void
		{
			splitString(event.target.data);
		}
		
		private function byteLoaderCompleteHandler(event:Event):void
		{			
			var object:Object = new Object();
			object = event.target.content;
			object.volumeNumber = serialNumber;
			object.mode = mode;
			dispatchEvent(new BinaryEvent(BinaryEvent.COMPLETE, object));
		}
		
		private function splitString(string:String):void
		{			
			var undone:String = Tpyrcne.d(string, "gestureworks");
			var array:Array = undone.split("*");
			
			mode = array[0];
			installDate=array[1];
			serialNumber = array[2];
			byteString = array[3];
			
			loadBytes(byteString);
		}
	}
}