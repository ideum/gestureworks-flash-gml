////////////////////////////////////////////////////////////////////////////////
//
//  IDEUM
//  Copyright 2011-2012 Ideum
//  All Rights Reserved.
//
//  GestureWorks
//
//  File:    AddSimpleText.as
//  Authors:  Ideum
//             
//  NOTICE: Ideum permits you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////
package com.gestureworks.utils
{	
	//import flash.geom.*;
	import flash.display.*;
//	import flash.net.*;
	import flash.text.*;
	//import flash.xml.*;

	public class AddSimpleText extends  Sprite {
		private var mytext:TextField;
		private var format:TextFormat;
		private var wNum:Number;
		private var hNum:Number;
			
		public function AddSimpleText(W:Number, H:Number,align:String, color:Number, size:Number) {
			wNum = W;
			hNum = H;
			
			mytext = new TextField();
				mytext.embedFonts = true;
				mytext.selectable = false;
				mytext.wordWrap = false;
				mytext.mouseEnabled = false;
				mytext.antiAliasType = AntiAliasType.ADVANCED;
				//mytext.blendMode = BlendMode.LAYER;
				//mytext.autoSize = align;
				//mytext.cacheAsBitmap = true;
				//mytext.alpha = 0.5;

				format = new TextFormat();
					format.color = color;
					format.size = size;
					format.font = "OpenSansRegular";
					//format.font = "ArialFont";
					format.align = align;
				mytext.setTextFormat(format);
				
			this.addChild(mytext);
		}
		
		public function set textCont(txt:String):void{
			mytext.htmlText = txt;
			mytext.setTextFormat(format);
			mytext.width = wNum;
			mytext.height = hNum;
		}
		/*
		public function set textContSymbol(txt:uint):void{
			mytext.htmlText = txt;
			mytext.setTextFormat(format);
			mytext.width = wNum;
			mytext.height = hNum;
		}*/
		
		public function set textColor(color:Number):void{
			format.color = color;
			mytext.setTextFormat(format);
		}
		
		public function set textFont(name:String):void{
			format.font = name;
			mytext.setTextFormat(format);
		}
		
		public function set textWrap(w:Boolean):void{
			mytext.wordWrap = w;
		}
		
	}
}