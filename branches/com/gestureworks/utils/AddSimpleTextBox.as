////////////////////////////////////////////////////////////////////////////////
//
//  IDEUM
//  Copyright 2011-2012 Ideum
//  All Rights Reserved.
//
//  GestureWorks
//
//  File:    AddSimpleTextBox.as
//  Authors:  Ideum
//             
//  NOTICE: Ideum permits you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////
package com.gestureworks.utils
{
	import flash.display.*;
	import flash.text.*;
	import flash.text.TextLineMetrics;

	public class AddSimpleTextBox extends Sprite {
		
			private var mytext:TextField;
			private var format:TextFormat;
			private var wNum:Number;
			private var hNum:Number;
			
		public function AddSimpleTextBox(W:Number, H:Number, align:String, color:Number, size:Number) {//
				
				wNum = W;
				hNum = H;
				
				mytext = new TextField();
					mytext.selectable = false;
					mytext.embedFonts = true;
					mytext.mouseEnabled = false;
					mytext.antiAliasType = AntiAliasType.ADVANCED;

				format = new TextFormat(); 
					//var arnorm:Font = new Font1();
					format.color = color;
					format.size = size;
					format.font = "Arial";
					format.align = align;
				//mytext.setTextFormat(format);
				
				this.addChild(mytext);
		}
		public function set textCont(txt:String):void
		{
			
			mytext.htmlText = txt;
			mytext.setTextFormat(format);
			mytext.width = wNum;
			mytext.height = hNum;
			mytext.wordWrap = true;
			//mytext.x = -mytext.width/2;
			//mytext.y = -mytext.height/2;
		}
		/*public function set vScroll(n:Number){
			trace(n);
			mytext.scrollV = n;
		}*/
	}
}