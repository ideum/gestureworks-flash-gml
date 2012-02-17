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