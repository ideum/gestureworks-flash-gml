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
	/* 
		
		IMPORTANT NOTE TO DEVELOPER **********************************************
		 
		PlEASE DO NOT ERASE OR DEVALUE ANYTHING WHITHIN THIS CLASS IF YOU DO NOT UNDERSTAND IT'S CURRENT VALUE OR PLACE... PERIOD...
		IF YOU HAVE ANY QUESTIONS, ANY AT ALL. PLEASE ASK PAUL LACEY (paul@ideum.com) ABOUT IT'S IMPORTATANCE.
		IF PAUL IS UNABLE TO HELP YOU UNDERSTAND, THEN PLEASE LOOK AND READ THE ACTUAL CODE FOR IT'S PATH.
		SOMETHINGS AT FIRST MAY NOT BE CLEAR AS TO WHAT THE ACTUAL PURPOSE IS, BUT IT IS VALUABLE AND IS USED IF IT IS CURRENTLY WRITTTEN HERE.
		DO NOT TAKE CODE OUT UNLESS YOUR CHANGES ARE VERIEFIED, TESTED AND CONTINUE TO WORK WITH LEGACY BUILDS !
		
		*/
		
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