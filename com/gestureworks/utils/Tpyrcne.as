////////////////////////////////////////////////////////////////////////////////
//
//  IDEUM
//  Copyright 2011-2012 Ideum
//  All Rights Reserved.
//
//  GestureWorks
//
//  File:    Tpyrcne.as
//  Authors:  Ideum
//             
//  NOTICE: Ideum permits you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////
package com.gestureworks.utils 
{
	import com.gestureworks.utils.Base64;
	
	/* 
		
		IMPORTANT NOTE TO DEVELOPER **********************************************
		 
		PlEASE DO NOT ERASE OR DEVALUE ANYTHING WHITHIN THIS CLASS IF YOU DO NOT UNDERSTAND IT'S CURRENT VALUE OR PLACE... PERIOD...
		IF YOU HAVE ANY QUESTIONS, ANY AT ALL. PLEASE ASK PAUL LACEY (paul@ideum.com) ABOUT IT'S IMPORTATANCE.
		IF PAUL IS UNABLE TO HELP YOU UNDERSTAND, THEN PLEASE LOOK AND READ THE ACTUAL CODE FOR IT'S PATH.
		SOMETHINGS AT FIRST MAY NOT BE CLEAR AS TO WHAT THE ACTUAL PURPOSE IS, BUT IT IS VALUABLE AND IS USED IF IT IS CURRENTLY WRITTTEN HERE.
		DO NOT TAKE CODE OUT UNLESS YOUR CHANGES ARE VERIEFIED, TESTED AND CONTINUE TO WORK WITH LEGACY BUILDS !
		
		*/
	
	public class Tpyrcne 
	{
		public static function e(str:String, key:String = '%key&'):String
		{
			var result:String = '';
			for (var i:int = 0; i < str.length; i++)
			{
				var char:String = str.substr(i, 1);
				var keychar:String = key.substr((i % key.length) - 1, 1);
				var ordChar:int = char.charCodeAt(0);
				var ordKeychar:int = keychar.charCodeAt(0);
				var sum:int = ordChar + ordKeychar;
				char = String.fromCharCode(sum);
				result = result + char;
			}
			return Base64.encode(result);
		}
		
		public static function d(str:String, key:String = '%key&'):String
		{
			var result:String = '';
			var str:String = Base64.decode(str);
			
			for (var i:int = 0; i < str.length; i++)
			{
				var char:String = str.substr(i, 1);
				var keychar:String = key.substr((i % key.length) - 1, 1);
				var ordChar:int = char.charCodeAt(0);
				var ordKeychar:int = keychar.charCodeAt(0);
				var sum:int = ordChar - ordKeychar;
				char = String.fromCharCode(sum);
				result = result + char;
			}
			return result;
		}
	}
}