////////////////////////////////////////////////////////////////////////////////
//
//  IDEUM
//  Copyright 2011-2012 Ideum
//  All Rights Reserved.
//
//  GestureWorks
//
//  File:    TouchObject.as
//  Authors:  Ideum
//             
//  NOTICE: Ideum permits you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////
package com.gestureworks.objects 
{
	//import flash.display.DisplayObject;
	//import flash.events.TouchEvent;
	//import flash.geom.Point;
	
	public class TouchObject extends Object 
	{
		// ID
		private var _id:int;
		public function get id():int{	return _id;}
		public function set id(value:int):void{	_id = value;}
		
		//////////////////////////////////////////////
		// debug points 
		private var _affinePoints:Array;
		public function get affinePoints():Array{	return _affinePoints;}
		public function set affinePoints(value:Array):void{	_affinePoints= value;}
		// transformed debug points 
		private var _transAffinePoints:Array;
		public function get transAffinePoints():Array{	return _transAffinePoints;}
		public function set transAffinePoints(value:Array):void{	_transAffinePoints= value;}
	}
}