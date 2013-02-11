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
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TouchEvent;
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
			
			addEventListener(Event.ADDED_TO_STAGE, onAdd);	
			addEventListener(Event.REMOVED_FROM_STAGE, onRemove);	
		}
		
		private function clickEvent(event:*):void
		{
			if (!_url) {
				//_url = "https://gestureworks.com/download-process/";
				_url = "http://gestureworks.com/collections/all";
			}
			var request:URLRequest = new URLRequest(_url);
			navigateToURL(request, "_blank");
		}
		
		private function onAdd(e:Event):void
		{
			stage.addEventListener(MouseEvent.MOUSE_DOWN, clickEvent);
			stage.addEventListener(TouchEvent.TOUCH_BEGIN, clickEvent);			
			e.target.removeEventListener(Event.ADDED_TO_STAGE, onAdd);			
		}
		
		private function onRemove(e:Event):void
		{
			stage.removeEventListener(MouseEvent.MOUSE_DOWN, clickEvent);
			stage.removeEventListener(TouchEvent.TOUCH_BEGIN, clickEvent);			
			e.target.removeEventListener(Event.ADDED_TO_STAGE, onRemove);		
		}		
	
	}
}