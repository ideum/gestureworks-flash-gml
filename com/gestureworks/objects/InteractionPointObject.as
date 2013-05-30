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
	
	import flash.geom.Vector3D;
	
	public class InteractionPointObject extends Object 
	{	
		// ID
		private var _id:int;
		public function get id():int{	return _id;}
		public function set id(value:int):void{	_id = value;}
		
		// interactionPointID
		private var _interactionPointID:int;
		public function get interactionPointID():int{	return _interactionPointID;}
		public function set interactionPointID(value:int):void {	_interactionPointID = value; }
		
		// interaction point type // tool/pen/brush/ pin/pinch/hook/trigger/
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
		
		//velocity//////////////////////////////////////////// //dx,dy,dz
		private var _velocity:Vector3D = new Vector3D ();
		public function get velocity():Vector3D{	return _velocity;}
		public function set velocity(value:Vector3D):void {	_velocity = value; }

	
		//width
		private var _width:Number = 0;
		public function get width():Number{	return _width;}
		public function set width(value:Number):void {	_width = value; }
		//length
		private var _length:Number = 0;
		public function get length():Number{	return _length;}
		public function set length(value:Number):void {	_length = value; }
		
		//palm radius
		private var _sphereRadius:Number = 0;
		public function get sphereRadius():Number{	return _sphereRadius;}
		public function set sphereRadius(value:Number):void{	_sphereRadius = value;}
		
		// sphere center
		private var _sphereCenter:Vector3D = new Vector3D ();
		public function get sphereCenter():Vector3D{	return _sphereCenter;}
		public function set sphereCenter(value:Vector3D):void {	_sphereCenter = value; }
		
		
		
		//min length of this motion point for sesioon
		private var _min_length:Number = 100000000;
		public function get min_length():Number{	return _min_length;}
		public function set min_length(value:Number):void {	_min_length = value; }
		//max length of this motion for session
		private var _max_length:Number = 0;
		public function get max_length():Number{	return _max_length;}
		public function set max_length(value:Number):void {	_max_length = value; }
		//extension percentage based on max and min length for session
		private var _extension:Number = 0;
		public function get extension():Number{	return _extension;}
		public function set extension(value:Number):void {	_extension = value; }
		
	
		
		
		
		

		
		///////////////////////////////////////////////////////////////////
		// history/////////////////////////////////////////////////////////
		private var _history:Vector.<MotionPointObject> = new Vector.<MotionPointObject>();
		public function get history():Vector.<MotionPointObject>{	return _history;}
		public function set history(value:Vector.<MotionPointObject>):void{	_history = value;}
		///////////////////////////////////////////////////////////////////
	}
}