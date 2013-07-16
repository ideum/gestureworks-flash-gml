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
		private var _id:int;
		public function get id():int{	return _id;}
		public function set id(value:int):void{	_id = value;}
		
		// motionPointID
		private var _handID:int;
		public function get handID():int{	return _handID;}
		public function set handID(value:int):void {	_handID = value; }
		
		// motion point type // left / right
		private var _type:String = new String();
		public function get type():String{	return _type;}
		public function set type(value:String):void {	_type = value; }
		
		/////////////////////////////////////////////////////////////////////////////////////////
		
		// fingerArray 
		private var _fingerList:Vector.<MotionPointObject> = new Vector.<MotionPointObject>();
		public function get fingerList():Vector.<MotionPointObject>{	return _fingerList;}
		public function set fingerList(value:Vector.<MotionPointObject>):void {	_fingerList = value; }
		
		// thumb
		private var _thumb:MotionPointObject = new MotionPointObject();
		public function get thumb():MotionPointObject{	return _thumb;}
		public function set thumb(value:MotionPointObject):void {	_thumb = value; }
		
		// palm
		private var _palm:MotionPointObject = new MotionPointObject();
		public function get palm():MotionPointObject{	return _palm;}
		public function set palm(value:MotionPointObject):void {	_palm = value; }
		
		////////////////////////////////////////////////////////////////////////////////////////////
		
		//position/////////////////////////////////////////////x,y,x
		private var _position:Vector3D = new Vector3D ();
		public function get position():Vector3D{	return _position;}
		public function set position(value:Vector3D):void {	_position = value; }
		
		//direction////////////////////////
		private var _direction:Vector3D = new Vector3D ();
		public function get direction():Vector3D{	return _direction;}
		public function set direction(value:Vector3D):void {	_direction = value; }
		
		//normal/////////////////////////
		private var _normal:Vector3D = new Vector3D ();
		public function get normal():Vector3D{	return _normal;}
		public function set normal(value:Vector3D):void {	_normal = value; }
		
		
		//width
		private var _width:Number = 0;
		public function get width():Number{	return _width;}
		public function set width(value:Number):void {	_width = value; }
		//length
		private var _length:Number = 0;
		public function get length():Number{	return _length;}
		public function set length(value:Number):void {	_length = value; }
		
		
		// could move in size??
		//palm radius
		private var _sphereRadius:Number = 0;
		public function get sphereRadius():Number{	return _sphereRadius;}
		public function set sphereRadius(value:Number):void{	_sphereRadius = value;}
		
		// sphere center
		private var _sphereCenter:Vector3D = new Vector3D ();
		public function get sphereCenter():Vector3D{	return _sphereCenter;}
		public function set sphereCenter(value:Vector3D):void {	_sphereCenter = value; }
		
		//velocity//////////////////////////////////////////// //dx,dy,dz
		private var _velocity:Vector3D = new Vector3D ();
		public function get velocity():Vector3D{	return _velocity;}
		public function set velocity(value:Vector3D):void {	_velocity = value; }
		
		//frameVelocity//////////////////////////////////////////// //DX,DX,DY
		private var _frameVelocity:Vector3D = new Vector3D ();
		public function get frameVelocity():Vector3D{	return _frameVelocity;}
		public function set frameVelocity(value:Vector3D):void {	_frameVelocity = value; }
		
		
		//finger average position//////////////////////////////////////////// //dx,dy,dz
		private var _fingerAveragePosition:Vector3D = new Vector3D ();
		public function get fingerAveragePosition():Vector3D{	return _fingerAveragePosition;}
		public function set fingerAveragePosition(value:Vector3D):void {	_fingerAveragePosition = value; }
		
		//pure finger average position//////////////////////////////////////////// //dx,dy,dz
		private var _pureFingerAveragePosition:Vector3D = new Vector3D ();
		public function get pureFingerAveragePosition():Vector3D{	return _pureFingerAveragePosition;}
		public function set pureFingerAveragePosition(value:Vector3D):void {	_pureFingerAveragePosition = value; }
		
		
		//pair table/////////////////////////////////////////////x,y,x
		private var _pair_table:Array = new Array ();
		public function get pair_table():Array{	return _pair_table;}
		public function set pair_table(value:Array):void {	_pair_table = value; }

	}
}