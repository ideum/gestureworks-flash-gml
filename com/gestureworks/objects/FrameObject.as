////////////////////////////////////////////////////////////////////////////////
//
//  IDEUM
//  Copyright 2011-2012 Ideum
//  All Rights Reserved.
//
//  GestureWorks
//
//  File:    FrameObject.as
//  Authors:  Ideum
//             
//  NOTICE: Ideum permits you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////
package com.gestureworks.objects 
{
	
	public class FrameObject extends Object 
	{
		// ID
		public var id:int;
		
		///////////////////////////////////////////////
		// UPDATE TO VECTORS
		//pointEventArray
		public var pointEventArray:Array = new Array();

		//clusterEventArray
		public var clusterEventArray:Array = new Array();

		//gestureEventArray
		public var gestureEventArray:Array = new Array();

		//transformEventArray
		public var transformEventArray:Array = new Array();
	}
}