////////////////////////////////////////////////////////////////////////////////
//
//  IDEUM
//  Copyright 2011-2012 Ideum
//  All Rights Reserved.
//
//  GestureWorks
//
//  File:    HandObject.as
//  Authors:  Ideum
//             
//  NOTICE: Ideum permits you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////
package com.gestureworks.objects 
{
	import flash.geom.Vector3D;
	import com.gestureworks.objects.MotionPointObject;
	
	public class HandObject extends Object 
	{	
		// ID
		public var id:int;
		
		// motionPointID
		public var motionPointID:int;
		
		public var handID:int;
		
		
		// hand type // left / right
		public var type:String = new String("undefined");
	
		// hand orientation // up/down
		public var orientation:String = new String("undefined");
		
		//flatness
		public var flatness:Number = 0;
		
		//splay
		public var splay:Number = 0;
		
		public var IPState:String = "";
		public var IPPosition:Vector3D = new Vector3D ();
		public var IPScreenPosition:Vector3D = new Vector3D ();
		
		// fingerArray 
		public var fingerList:Vector.<MotionPointObject> = new Vector.<MotionPointObject>();
		
		// thumb
		public var thumb:MotionPointObject = new MotionPointObject();
		
		// index finger
		public var index:MotionPointObject = new MotionPointObject();
		
		// middle finger
		public var middle:MotionPointObject = new MotionPointObject();
		
		// fing finger
		public var ring:MotionPointObject = new MotionPointObject();
		
		// pinky finger
		public var pinky:MotionPointObject = new MotionPointObject();
		
		// palm
		public var palm:MotionPointObject = new MotionPointObject();
		
		////////////////////////////////////////////////////////////////////////////////////////////
		
		//position/////////////////////////////////////////////x,y,x
		//public var position:Vector3D = new Vector3D ();
		//public var positionCached:Vector3D = new Vector3D ();
		
		//direction////////////////////////
		//public var direction:Vector3D = new Vector3D ();
		// direction from classified fingers only
		//public var direction_finger:Vector3D = new Vector3D ();
		
		//normal/////////////////////////
		//public var normal:Vector3D = new Vector3D ();
		
		//width
		public var width:Number = 0;
		
		//length
		public var length:Number = 0;
		
		//palm radius
		public var radius:Number = 0;
		public var favlength:Number = 0;
		public var max_favlength:Number = 0;
		
		// sphere center
		public var sphereCenter:Vector3D = new Vector3D ();
		
		//velocity//////////////////////////////////////////// //dx,dy,dz
		public var velocity:Vector3D = new Vector3D ();
		
		//frameVelocity//////////////////////////////////////////// //DX,DX,DY
		public var frameVelocity:Vector3D = new Vector3D ();
		
		
		//finger average position//////////////////////////////////////////// //dx,dy,dz
		public var fingerAveragePosition:Vector3D = new Vector3D ();
		
		//finger average position//////////////////////////////////////////// //dx,dy,dz
		public var projectedFingerAveragePosition:Vector3D = new Vector3D ();
		
		//pure finger average position//////////////////////////////////////////// //dx,dy,dz
		public var pureFingerAveragePosition:Vector3D = new Vector3D ();
		
		public var projectedPureFingerAveragePosition:Vector3D = new Vector3D ();
		
		public var d_n_crossproduct:Vector3D = new Vector3D ();
		
		//TODO: REMOVE
		//pair table/////////////////////////////////////////////x,y,x
		//public var pair_table:Array = new Array();
	}
}