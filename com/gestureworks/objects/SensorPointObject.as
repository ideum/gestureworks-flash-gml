////////////////////////////////////////////////////////////////////////////////
//
//  IDEUM
//  Copyright 2011-2012 Ideum
//  All Rights Reserved.
//
//  GestureWorks
//
//  File:    SensorObject.as
//  Authors:  Ideum
//             
//  NOTICE: Ideum permits you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////
package com.gestureworks.objects 
{
	//import flash.geom.Matrix;
	import flash.geom.Vector3D;
	
	public class SensorPointObject extends Object 
	{	
		// ID /////////////////////////////////////////////////////
		public var id:int;
		// motionPointID
		public var sensorPointID:int;
		// sensor point type // wiimote
		public var type:String = new String();
		//devicetype controller
		public var devicetype:String = new String();
		// frameID
		public var frameID:int;
		// event phase
		public var phase:String="";
		
		
		//position/////////////////////////////////////////////x,y,x
		public var position:Vector3D; //= new Vector3D ();
		//direction////////////////////////
		public var direction:Vector3D; //= new Vector3D ();
		//normal/////////////////////////
		public var normal:Vector3D; //= new Vector3D ();
		
		//rotation/////////////////////////////////////////////x,y,x
		//public var rotation:Matrix = new Matrix ();
		public var rotation:Vector3D; //= new Vector3D ();
		public var orientation:Vector3D; //= new Vector3D ();
		//public var pitch:Number = 0;
		//public var yaw:Number = 0;
		//public var roll:Number = 0;
		
		//size
		public var size:Vector3D; 
		//width
		//public var width:Number = 0;
		//length
		//public var length:Number = 0;
		
		//velocity//////////////////////////////////////////// //dx,dy,dz
		public var velocity:Vector3D; //= new Vector3D ();
		
		public var acceleration:Vector3D; //= new Vector3D ();
		
		public var jolt:Vector3D; //= new Vector3D ();
		
		public var snap:Vector3D; //= new Vector3D ();
		
		public var crackle:Vector3D; //= new Vector3D ();
		
		public var pop:Vector3D; //= new Vector3D ();
		
		//public var buttons:Vector.<Object> //= new Vector.<Object>;
		public var buttons:Object //= new Vector.<Object>;
		
		//public var nunchuck:Object;
		
		//public var balanceboard:Object;
		
		///////////////////////////////////////////////////////////////////
		// history/////////////////////////////////////////////////////////
		//public var history:Vector.<SensorPointObject> = new Vector.<SensorPointObject>();
	}
}