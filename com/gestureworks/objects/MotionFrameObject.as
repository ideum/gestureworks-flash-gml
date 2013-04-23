////////////////////////////////////////////////////////////////////////////////
//
//  IDEUM
//  Copyright 2011-2012 Ideum
//  All Rights Reserved.
//
//  GestureWorks
//
//  File:    TimelineObject.as
//  Authors:  Ideum
//             
//  NOTICE: Ideum permits you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////
package com.gestureworks.objects 
{
	import com.leapmotion.leap.Frame 
	//import com.gestureworks.objects.MotionFrameObject;
	
	public class MotionFrameObject extends Object 
	{
		// ID
		private var _id:int;
		public function get id():int{	return _id;}
		public function set id(value:int):void{	_id = value;}
		
		//frame count
		private var _frameCount:int = 0;
		public function get frameCount():int{	return _frameCount;}
		public function set frameCount(value:int):void {	_frameCount = value; }
		
		//frame object
		private var _frame:Frame = new Frame();
		public function get frame():Frame{	return _frame;}
		public function set frame(value:Frame):void{	_frame = value;}
		
		// motion frame history
		private var _history:Vector.<MotionFrameObject> = new Vector.<MotionFrameObject>();
		public function get history():Vector.<MotionFrameObject>{return _history;}
		public function set history(value:Vector.<MotionFrameObject>):void{_history = value;}
	}
}