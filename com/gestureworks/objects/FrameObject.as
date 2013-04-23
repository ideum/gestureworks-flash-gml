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
		private var _id:int;
		public function get id():int {	return _id; }
		public function set id(value:int):void{	_id = value;}
		
		///////////////////////////////////////////////
		// UPDATE TO VECTORS
		//pointEventArray
		private var _pointEventArray:Array = new Array();
		public function get pointEventArray():Array{	return _pointEventArray;}
		public function set pointEventArray(value:Array):void{	_pointEventArray = value;}
		//clusterEventArray
		private var _clusterEventArray:Array = new Array();
		public function get clusterEventArray():Array{	return _clusterEventArray;}
		public function set clusterEventArray(value:Array):void{	_clusterEventArray = value;}	
		//gestureEventArray
		private var _gestureEventArray:Array = new Array();
		public function get gestureEventArray():Array{	return _gestureEventArray;}
		public function set gestureEventArray(value:Array):void{	_gestureEventArray = value;}	
		//transformEventArray
		private var _transformEventArray:Array = new Array();
		public function get transformEventArray():Array	{	return _transformEventArray;}
		public function set transformEventArray(value:Array):void{	_transformEventArray = value;
		}	
	}
}