////////////////////////////////////////////////////////////////////////////////
//
//  IDEUM
//  Copyright 2011-2012 Ideum
//  All Rights Reserved.
//
//  GestureWorks
//
//  File:    TimeCompare.as
//  Authors:  Ideum
//             
//  NOTICE: Ideum permits you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////
package com.gestureworks.utils 
{
	public class TimeCompare 
	{
		public static function of(date1:Date, date2:Date):Number
		{
			var date1Timestamp:Number = date1.getTime();
			var date2Timestamp:Number = date2.getTime();
			var result:Number = -1;

			if (date1Timestamp == date2Timestamp) result = 0;
			else if (date1Timestamp > date2Timestamp) result = 1;
						
			return result;
		}
		
		public static function diff(startTime:Date, endTime:Date):int
		{			
			var aTms:Number = Math.floor(endTime.valueOf() - startTime.valueOf());
			return int(aTms / (24 * 60 * +60 * 1000));
		}

	}
}