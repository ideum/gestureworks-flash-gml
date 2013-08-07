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
		public var id:int;

		// touchPointID
		public var touchPointID:Number;

		
		/////////////////////////////////////////////
		// x
		public var x:Number;

		// y
		public var y:Number;

		// Z //-3d
		//public var _z:Number = 0;

		
		// width
		public var w:Number;

		// height
		public var h:Number;

		//////////////////////////////////////////////
		
		// dx
		public var dx:Number;

		// dy
		public var dy:Number;

		
		// dz
		//public var _dz:Number = 0;

		                                                                                                                                                                                                  
		// DX
		public var DX:Number;

		// DY
		public var DY:Number;

		
		// frameID
		public var frameID:int;

		
		// move count
		// number move updates for point in frame
		public var moveCount:int;

		
		
		//////////////////////////////////////////////////
		// MAY NEED TO MOVE TO CLUSTER
		/////////////////////////////////////////////////
		// hold monitor 
		public var holdMonitorOn:Boolean;

		// hold count
		// number frames passed hold test
		public var holdCount:int;

		// hold lock 
		public var holdLock:Boolean;

		
		
		
		// MAY NEED REMOVE
		// event
		public var event:TouchEvent;

		
		///////////////////////////////////////////////////
		// DIRECT REFERENCE TO THE TOUCH OBJECT THAT "OWNS" THE TOUCH POINT
		// primary touch object (should be target)
		//////////////////////////////////////////////////
		// object
		public var object:DisplayObject;

		
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
		public var history:Vector.<PointObject> = new Vector.<PointObject>();

		
	}
}