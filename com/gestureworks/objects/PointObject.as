////////////////////////////////////////////////////////////////////////////////
//
//  IDEUM
//  Copyright 2011-2012 Ideum
//  All Rights Reserved.
//
//  GestureWorks
//
//  File:    PointObject.as
//  Authors:  Ideum
//             
//  NOTICE: Ideum permits you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////
package com.gestureworks.objects 
{
	import flash.display.DisplayObject;
	import flash.events.TouchEvent;
	
	public class PointObject extends Object 
	{	
		// ID
		private var _id:int;
		public function get id():int{	return _id;}
		public function set id(value:int):void{	_id = value;}
		// touchPointID
		private var _touchPointID:Number;
		public function get touchPointID():Number{	return _touchPointID;}
		public function set touchPointID(value:Number):void{	_touchPointID = value;}
		
		/////////////////////////////////////////////
		// x
		private var _x:Number = 0;
		public function get x():Number{	return _x;}
		public function set x(value:Number):void{	_x = value;}
		// y
		private var _y:Number = 0;
		public function get y():Number{	return _y;}
		public function set y(value:Number):void{	_y = value;}
		// Z //-3d
		//private var _z:Number = 0;
		//public function get z():Number{	return _z;}
		//public function set z(value:Number):void{	_z = value;}
		
		// width
		private var _w:Number = 0;
		public function get w():Number{	return _w;}
		public function set w(value:Number):void{	_w = value;}
		// height
		private var _h:Number = 0;
		public function get h():Number{	return _h;}
		public function set h(value:Number):void{	_h = value;}
		//////////////////////////////////////////////
		
		// dx
		private var _dx:Number = 0;
		public function get dx():Number{	return _dx;}
		public function set dx(value:Number):void{	_dx = value;}
		// dy
		private var _dy:Number = 0;
		public function get dy():Number{	return _dy;}
		public function set dy(value:Number):void {	_dy = value; }
		
		// dz
		//private var _dz:Number = 0;
		//public function get dz():Number{	return _dz;}
		//public function set dz(value:Number):void{	_dz = value;}
		                                                                                                                                                                                                  
		// DX
		private var _DX:Number = 0;
		public function get DX():Number{	return _DX;}
		public function set DX(value:Number):void{	_DX = value;}
		// DY
		private var _DY:Number = 0;
		public function get DY():Number{	return _DY;}
		public function set DY(value:Number):void{	_DY = value;}
		
		// frameID
		private var _frameID:int;
		public function get frameID():int{	return _frameID;}
		public function set frameID(value:int):void{	_frameID = value;}
		
		// move count
		// number move updates for point in frame
		private var _moveCount:int =0;
		public function get moveCount():int{	return _moveCount;}
		public function set moveCount(value:int):void{	_moveCount = value;}
		
		
		//////////////////////////////////////////////////
		// MAY NEED TO MOVE TO CLUSTER
		/////////////////////////////////////////////////
		// hold monitor 
		private var _holdMonitorOn:Boolean = false;
		public function get holdMonitorOn():Boolean{	return _holdMonitorOn;}
		public function set holdMonitorOn(value:Boolean):void{	_holdMonitorOn = value;}
		// hold count
		// number frames passed hold test
		private var _holdCount:int;
		public function get holdCount():int{	return _holdCount;}
		public function set holdCount(value:int):void{	_holdCount = value;}
		// hold lock 
		private var _holdLock:Boolean = false;
		public function get holdLock():Boolean{	return _holdLock;}
		public function set holdLock(value:Boolean):void{	_holdLock = value;}
		
		
		
		// MAY NEED REMOVE
		// event
		private var _event:TouchEvent;
		public function get event():TouchEvent{	return _event;}
		public function set event(value:TouchEvent):void{	_event = value;}
		
		///////////////////////////////////////////////////
		// DIRECT REFERENCE TO THE TOUCH OBJECT THAT "OWNS" THE TOUCH POINT
		// primary touch object (should be target)
		//////////////////////////////////////////////////
		// object
		private var _object:DisplayObject;
		public function get object():DisplayObject{	return _object;}
		public function set object(value:DisplayObject):void{	_object = value;}
		
		///////////////////////////////////////////////////////
		// list of objects that are given copy of touch point
		// touch object in nested stack or in cluster broadcast
		///////////////////////////////////////////////////////
		
		//  objectList
		// UPDATE TO VECTOR
		private var _objectList:Array = [];
		/**
		 * Returns a pointClusterList.
		 */
		public function get objectList():Array{	return _objectList;}
		/**
		 * Sets a objectList.
		 */
		public function set objectList(value:Array):void{	_objectList=value;}
		
		// UPDATE TO VECTOR
		private var _clusterList:Array = [];
		/**
		 * Returns a pointClusterList.
		 */
		public function get clusterList():Array{	return _clusterList;}
		/**
		 * Sets a pointClusterList.
		 */
		public function set clusterList(value:Array):void{	_clusterList=value;}
		
		
		// history
		private var _history:Vector.<PointObject> = new Vector.<PointObject>();
		public function get history():Vector.<PointObject>{	return _history;}
		public function set history(value:Vector.<PointObject>):void{	_history = value;}
		
	}
}