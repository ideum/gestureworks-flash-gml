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
	//import com.gestureworks.interfaces.ITouchObject;
	//import flash.display.DisplayObject;
	//import flash.display.DisplayObjectContainer;
	//import flash.events.TouchEvent;
	import flash.geom.Vector3D;
	
	public class TouchPointObject extends Object 
	{	
		// ID
		public var id:int;
		// touchPointID
		public var touchPointID:int;
		public var tagID:int;
		// frameID
		public var frameID:int;
		// move count // number move updates for point in frame
		public var moveCount:int = 0;
		public var age:uint
		public var phase:String;
		
		public var position:Vector3D //= new Vector3D();
		public var size:Vector3D //= new Vector3D();
		public var pressure:Number = 0;
		public var area:Number = 0;
		public var radius:Number = 0;
		public var theta:Number = 0;
		public var n:int = 0;
		public var type:String = "";
		public var name:String = "";
		//////////////////////////////////////////////
		// dx
		public var dx:Number=0;
		// dy
		public var dy:Number=0;
		// dz
		public var dz:Number = 0;

		// DX
		public var DX:Number=0;
		// DY
		public var DY:Number=0;
		// DZ
		public var DZ:Number=0;		
		
		//////////////////////////////////////////////////
		// MAY NEED TO MOVE TO CLUSTER OR IP OBJECT
		/////////////////////////////////////////////////
		// hold monitor 
		public var holdMonitorOn:Boolean=false;
		// hold count // number frames passed hold test
		public var holdCount:int;
		// hold lock //
		public var holdLock:Boolean=false;

		
		//////////////////////////////////////////////////////////////////////////////
		// history
		//public var history:Vector.<TouchPointObject> //= new Vector.<TouchPointObject>();
	}
}