﻿////////////////////////////////////////////////////////////////////////////////
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
	//import flash.display.DisplayObject;
	//import flash.events.TouchEvent;
	import flash.geom.Matrix;
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
		
		// move count 
		// number move updates for point in frame
		public var moveCount:int = 0;
		
		// handID // parent hand ID (if type finger)
		public var handID:int = 0;
		
		//TEMP//////////////////////////////////////////
		// pairArray 
		public var pairArray:Array = new Array();
			
		
		// nnID // parent hand ID (if type finger)
		public var nnID:int = 0;
		
		// nndID // parent hand ID (if type finger)
		public var nndID:int = 0;
		
		// nndaID // parent hand ID (if type finger)
		public var nndaID:int = 0;
		
		// nndaID // parent hand ID (if type finger)
		public var nnpaID:int = 0;
		
		// nnID // parent hand ID (if type finger)
		public var nnprobID:int = 0;
		
		///////////////////////////////////////////////
			
		
		// handID // parent hand ID (if type finger)
		public var pairedPointID:int = 0;
		
		
		//position/////////////////////////////////////////////x,y,x
		public var position:Vector3D = new Vector3D ();//--
		public var screen_position:Vector3D = new Vector3D ();
		public var positionCached:Vector3D = new Vector3D ();
		public var planePositionCached:Vector3D = new Vector3D ();
		public var relativePositionCached:Vector3D = new Vector3D ();
		
		//direction////////////////////////
		public var direction:Vector3D = new Vector3D ();//--
		public var screen_direction:Vector3D = new Vector3D ();
		public var directionCached:Vector3D = new Vector3D ();
		public var projected_finger_direction:Vector3D = new Vector3D ();
		
		//
		public var palmplane_finger_knuckle_direction:Vector3D = new Vector3D ();
		
		//normal/////////////////////////
		public var normal:Vector3D = new Vector3D ();//--
		public var screen_normal:Vector3D = new Vector3D ();
		
		//rotation/////////////////////////////////////////////x,y,x
		public var rotation:Matrix //= new Matrix ();
		
		//palm plane position/////////////////////////////////////////////x,y,x
		public var palmplane_position:Vector3D = new Vector3D ();//--
		// palm plane line position
		public var palmplaneline_position:Vector3D = new Vector3D ();//--
		
		//palm finger direction vectors
		public var palm_finger_direction:Vector3D = new Vector3D ();
		public var projected_palm_finger_direction:Vector3D = new Vector3D ();
		
		
		//joints////////////////////////////////////////////////////////
		//public var joint_0:Vector3D = new Vector3D ();
		//public var joint_1:Vector3D = new Vector3D ();
		//public var joint_2:Vector3D = new Vector3D ();
		//public var joint_3:Vector3D = new Vector3D ();
		
		/*
		//size///////////////////////////////////////////w,h,l
		public var size:Vector3D = new Vector3D ();
		*/
		
		//width
		public var width:Number = 0;
		
		//width
		public var radius:Number = 0;

		//length
		public var length:Number = 0;

		//min length of this motion point for sesioon
		public var min_length:Number = 100000000;

		//max length of this motion for session
		public var max_length:Number = 0;
		
		//min width of this motion point for sesioon
		public var min_width:Number = 100000000;

		//max width of this motion for session
		public var max_width:Number = 0;

		//max width:length of this motion for session
		public var max_width_length_ratio:Number = 0;

		
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

		
		//normalized_width based on other fingers in local hand
		public var normalized_width:Number = 0;
		//normalized_length based on other fingers in local hand
		public var normalized_length:Number = 0;
		
		public var normalized_max_length:Number = 0;
		public var normalized_max_width:Number = 0;
		
		//normalized_dAngle based on other fingers in local hand
		public var normalized_palmAngle:Number = 0;
		// normalized max width to length ratio
		public var normalized_mwlr:Number = 0;
		
		
		// hand structure probs
		public var thumb_prob:Number = 0;
		// hand structure probs
		public var mean_thumb_prob:Number = 0;

		
		// could move in size??
		//palm radius
		public var sphereRadius:Number = 0;
		// sphere center
		public var sphereCenter:Vector3D //= new Vector3D ();
		
	
		//velocity//////////////////////////////////////////// //dx,dy,dz
		public var velocity:Vector3D //= new Vector3D ();
		//frameVelocity//////////////////////////////////////////// //DX,DX,DY
		public var frameVelocity:Vector3D //= new Vector3D ();
		

		///////////////////////////////////////////////////////////////////
		// history/////////////////////////////////////////////////////////
		//public var history:Vector.<MotionPointObject> = new Vector.<MotionPointObject>();
	}
}