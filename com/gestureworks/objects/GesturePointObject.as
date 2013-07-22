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
	import flash.geom.Matrix;
	import flash.geom.Vector3D;
	
	public class GesturePointObject extends Object 
	{	
		// ID
		private var _id:int;
		public function get id():int{	return _id;}
		public function set id(value:int):void{	_id = value;}
		
		// gesturePointID
		private var _gesturePointID:int;
		public function get gesturePointID():int{	return _gesturePointID;}
		public function set gesturePointID(value:int):void {	_gesturePointID = value; }
		
		// gesture point type /tap
		private var _type:String = new String();
		public function get type():String{	return _type;}
		public function set type(value:String):void {	_type = value; }
		
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
		
		//velocity//////////////////////////////////////////////dx,dy,dz
		private var _velocity:Vector3D = new Vector3D ();
		public function get velocity():Vector3D{	return _velocity;}
		public function set velocity(value:Vector3D):void {	_velocity = value; }
		
		//accleration//////////////////////////////////////////////ddx,ddy,ddz
		private var _acceleration:Vector3D = new Vector3D ();
		public function get acceleration():Vector3D{	return _acceleration;}
		public function set acceleration(value:Vector3D):void {	_acceleration = value; }
		
		//jolt//////////////////////////////////////////////ddx,ddy,ddz
		private var _jolt:Vector3D = new Vector3D ();
		public function get jolt():Vector3D{	return _jolt;}
		public function set jolt(value:Vector3D):void {	_jolt = value; }

		//width
		private var _width:Number = 0;
		public function get width():Number{	return _width;}
		public function set width(value:Number):void {	_width = value; }
		//length
		private var _length:Number = 0;
		public function get length():Number{	return _length;}
		public function set length(value:Number):void {	_length = value; }
		
		//rotation/////////////////////////////////////////////x,y,x
		private var _rotation:Matrix = new Matrix ();
		public function get rotation():Matrix{	return _rotation;}
		public function set rotation(value:Matrix):void {	_rotation = value; }

	}
}