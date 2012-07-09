////////////////////////////////////////////////////////////////////////////////
//
//  IDEUM
//  Copyright 2011-2012 Ideum
//  All Rights Reserved.
//
//  GestureWorks
//
//  File:     Yolotzin.as
//  Author:   Ideum
//
//  NOTICE: Ideum permits you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

package com.gestureworks.utils 
{
	import flash.display.Loader;
	import flash.display.Sprite;
	import com.gestureworks.utils.CompileDate; //-no longer used, c.veasey 7/6/12
	import com.gestureworks.utils.SwfByteLoader; //-no longer used, c.veasey 7/6/12
	import com.gestureworks.events.BinaryEvent;
	import com.gestureworks.core.CML;
	import com.gestureworks.utils.Tpyrcne;
	import com.gestureworks.core.DisplayList;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import com.gestureworks.core.GestureWorks;
	import com.gestureworks.utils.TimeCompare;
	
	/* 
		
		IMPORTANT NOTE TO DEVELOPER **********************************************
		 
		PlEASE DO NOT ERASE OR DEVALUE ANYTHING WHITHIN THIS CLASS IF YOU DO NOT UNDERSTAND IT'S CURRENT VALUE OR PLACE... PERIOD...
		IF YOU HAVE ANY QUESTIONS, ANY AT ALL. PLEASE ASK PAUL LACEY (paul@ideum.com) ABOUT IT'S IMPORTATANCE.
		IF PAUL IS UNABLE TO HELP YOU UNDERSTAND, THEN PLEASE LOOK AND READ THE ACTUAL CODE FOR IT'S PATH.
		SOMETHINGS AT FIRST MAY NOT BE CLEAR AS TO WHAT THE ACTUAL PURPOSE IS, BUT IT IS VALUABLE AND IS USED IF IT IS CURRENTLY WRITTTEN HERE.
		DO NOT TAKE CODE OUT UNLESS YOUR CHANGES ARE VERIEFIED, TESTED AND CONTINUE TO WORK WITH LEGACY BUILDS !
		
		*/
	
	public class Yolotzin extends Sprite
	{
		public static var mode:int;
		public static var clear:Boolean;
		public static var installDate:String;
		public static var trialValue:Number;
		public static var trialLeft:int;
		public static var vn:*;
		private static var _:Boolean;
		private static var r:*;
		private static var k:*;
		private static var s:*;
		private static var p:*;
		private static var c:*;
		public static var o:*;
		
		public function Yolotzin() { super();}
		
		tgrqzd function qftgtopiuqewer(ro:*, ke:*, se:*):void
		{
			if (_) return;
			_ = !_;
			r = ro;
			k = ke;
			s = se;
		
			testCompileDate(ke);
		}
		
		public function set completed(value:Boolean):void
		{			
			if (!value) return;
						
			var p:* = parent;
			p.complete();
		}
		
		public function set writeCompleted(value:Boolean):void
		{			
			if (!value) return;
						
			var p:* = parent;
			p.wComplete();
		}
		
		private var inRunTime:Boolean;
		
		
		private function testCompileDate(keyString:String):void
		{
			if (keyString == "")
			{
				mode = -2;
				completed = true;
				return;
			}
						
			c = CompileDate.from(r);
			
			var cDate:Date;
			
			if (CompileDate.isFlash)
			{
				var date:String = c;				
				var year:String = date.slice(0, 4);
				var month:String = (int(date.slice(5, 7)) - 1).toString();
				var day:String = date.slice(8, 10);
				var hours:String = date.slice(11, 13);
				var minutes:String = date.slice(14, 16);
				var seconds:String = date.slice(17, 19);
				cDate = new Date(year, month, day, hours, minutes, seconds);
				trace("isFlash:",year, month, day, hours, minutes, seconds)
			}
			else
			{
				cDate = new Date(c);
			}
			
			var todaysDate:Date = new Date();
			var dateDifference:Number = todaysDate.valueOf() - cDate.valueOf();
			//trace("c:",c, "\n  dateDifference:", dateDifference, "\n  cDate:", cDate, "\n  todaysDate:", todaysDate);
			
			if (dateDifference > 30000) inRunTime = true;
			var dencrpyt:* = Tpyrcne.d(keyString, "gestureworks");
			var ya:Array = dencrpyt.toString().split("*");			
			mode = ya[0] == 10 ? 0 : ya[0] == 12 ? 1 : ya[0];
			GestureWorks.isOpenExibits = ya[0].toString().length == 2 ? true : false;
			
			if (inRunTime)
			{
				GestureWorks.isRunTime = true;
				clear = true;
				completed = true;
			}
			else
			{
				var trialDate:Date = new Date(ya[1]);
				trialValue = TimeCompare.of(todaysDate, trialDate);
				
				if (trialValue == 1)
				{
					trialLeft = 30 - TimeCompare.diff(trialDate, new Date());
				}
				else
				{
					mode = -1;
				}
				
				completed = true;
			}
		}
		
	}
}