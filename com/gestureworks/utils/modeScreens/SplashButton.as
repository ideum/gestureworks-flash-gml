////////////////////////////////////////////////////////////////////////////////
//
//  IDEUM
//  Copyright 2011-2012 Ideum
//  All Rights Reserved.
//
//  GestureWorks
//
//  File:   SplashButton.as
//  Authors:  Ideum
//             
//  NOTICE: Ideum permits you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////
package com.gestureworks.utils.modeScreens
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	public class SplashButton extends Sprite
	{
		private var _url:String;
		
		public function SplashButton(w:Number, h:Number, a:Number=0, url:String = null)
		{
			_url = url;
			
			graphics.beginFill(0xffffff, a);
			graphics.drawRect(0, 0, w, h);
			graphics.endFill();
			
			addEventListener(MouseEvent.CLICK, clickEvent);
		}
		
		private function clickEvent(event:MouseEvent):void
		{
			if (!_url) _url = "https://gestureworks.com/download-process/";
			
			var request:URLRequest = new URLRequest(_url);
			navigateToURL(request, "_blank");
		}
	}
}