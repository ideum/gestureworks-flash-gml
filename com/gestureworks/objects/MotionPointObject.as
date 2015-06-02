////////////////////////////////////////////////////////////////////////////////
//
//  IDEUM
//  Copyright 2011-2012 Ideum
//  All Rights Reserved.
//
//  GestureWorks
//
//  File:    MotionPointObject.as
//  Authors:  Ideum
//             
//  NOTICE: Ideum permits you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////
package com.gestureworks.objects 
{
	import flash.geom.Vector3D;
	
	public class MotionPointObject extends Object 
	{	
		// ID
		public var id:int;
		//determins is clasified and tracked
		public var isValid:Boolean;
		// motionPointID
		public var motionPointID:int;
		// motion point type // finger, tool, palm
		public var type:String = new String();
		//////////////////////////////////////////////////
		// device type (temp for realsense fix)
		public var deviceType:String = new String();
		//////////////////////////////////////////////////////////////
		//fingertype thumb, index, middle,....
		public var fingertype:String = new String();
		// event phase
		public var phase:String="";
		// frameID
		public var frameID:int;
		// motionID
		public var motionFrameID:int;
		//match, flaggged when tip is matched to motion point type
		public var match:Boolean;
		// move count // number move updates for point in frame
		public var moveCount:int = 0;
		// handID // parent hand ID (if type finger)
		public var handID:int = 0;
		//position/////////////////////////////////////////////x,y,x
		public var position:Vector3D = new Vector3D ();//--
		public var screen_position:Vector3D = new Vector3D ();
		//direction////////////////////////
		public var direction:Vector3D = new Vector3D ();//--
		public var screen_direction:Vector3D = new Vector3D ();
		//normal/////////////////////////
		public var normal:Vector3D = new Vector3D ();//--
		public var screen_normal:Vector3D = new Vector3D ();
		//palm plane position/////////////////////////////////////////////x,y,x
		public var palmplane_position:Vector3D = new Vector3D ();//--
		//width
		public var width:Number = 0;
		//hidth
		public var radius:Number = 0;
		//length
		public var length:Number = 0;
		//extension percentage based on max and min length for session
		public var extension:Number = 0;
		//favdist
		public var favdist:Number = 0;
		//normalized_favdist
		public var normalized_favdist:Number = 0;
		//orientation
		public var orientation:String = "";
		//handside
		public var handside:String = "";
		//palmAngle
		public var palmAngle:Number = 0;

		//velocity//////////////////////////////////////////// //dx,dy,dz
		public var velocity:Vector3D //= new Vector3D ();
		//frameVelocity//////////////////////////////////////////// //DX,DX,DY
		public var frameVelocity:Vector3D //= new Vector3D ();
		// jolt
		
	}
}