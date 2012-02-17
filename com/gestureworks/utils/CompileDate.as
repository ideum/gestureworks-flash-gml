////////////////////////////////////////////////////////////////////////////////
//
//  IDEUM
//  Copyright 2011-2012 Ideum
//  All Rights Reserved.
//
//  GestureWorks
//
//  File:    CompileDate.as
//  Authors:  Ideum
//             
//  NOTICE: Ideum permits you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////
package com.gestureworks.utils 
{
	import com.codeazur.as3swf.SWF;
	import com.codeazur.as3swf.SWFData;
	import com.codeazur.as3swf.data.SWFRawTag;
	import com.codeazur.as3swf.data.SWFRecordHeader;
	import com.codeazur.as3swf.tags.TagEnd;
	import com.codeazur.as3swf.tags.TagProductInfo;
	import com.codeazur.as3swf.tags.TagMetadata;
	
	public class CompileDate 
	{		
		public static var COMPLETE:String = "complete";
		public static var compileDate:String;
		public static var isFlash:Boolean;
		
		public static function from(r:*):String
		{			
			var swf:SWF = new SWF(r.loaderInfo.bytes);
			
			for (var i:uint = 0; i < swf.tags.length; i++)
			{
				if (swf.tags[i] is TagMetadata)
				{
					var product:TagMetadata = swf.tags[i] as TagMetadata;
					var XMLNS:Namespace = new Namespace("http://www.w3.org/1999/02/22-rdf-syntax-ns#");
					var XMP:Namespace = new Namespace("http://ns.adobe.com/xap/1.0/");
					var DC:Namespace = new Namespace("http://ns.adobe.com/xap/1.0/");
					var string:String = product.toString();
					var array:Array = string.split("Metadata]  ");
					var xml:XML = XML(array[1]);
					var description:XMLList = xml.XMLNS::Description;
					
					compileDate = description[0].XMP::ModifyDate;
					
					isFlash =  true;
				}
				
				if (swf.tags[i] is TagProductInfo)
				{
					var productInfo:TagProductInfo = swf.tags[i] as TagProductInfo;
					
					compileDate = productInfo.compileDate.toString();
					
					isFlash =  false;
				}
				
			}
			
			return compileDate;
		}
	}
}