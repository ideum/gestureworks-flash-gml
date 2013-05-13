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
	//import flash.display.DisplayObject;
	//import flash.events.TouchEvent;
	
	import flash.geom.Vector3D;
	
	public class MotionPointObject extends Object 
	{	
		// ID
		private var _id:int;
		public function get id():int{	return _id;}
		public function set id(value:int):void{	_id = value;}
		
		// motionPointID
		private var _motionPointID:int;
		public function get motionPointID():int{	return _motionPointID;}
		public function set motionPointID(value:int):void {	_motionPointID = value; }
		
		// motion point type // finger, tool, palm
		private var _type:String = new String();
		public function get type():String{	return _type;}
		public function set type(value:String):void {	_type = value; }
		
		//fingertype thumb, index, middle,....
		private var _fingertype:String = new String();
		public function get fingertype():String{	return _fingertype;}
		public function set fingertype(value:String):void{	_fingertype = value;}
		
		// frameID
		private var _frameID:int;
		public function get frameID():int{	return _frameID;}
		public function set frameID(value:int):void {	_frameID = value; }
		
		// motionID
		private var _motionFrameID:int;
		public function get motionFrameID():int{	return _motionFrameID;}
		public function set motionFrameID(value:int):void{	_motionFrameID = value;}
		
		// move count 
		// number move updates for point in frame
		private var _moveCount:int =0;
		public function get moveCount():int{	return _moveCount;}
		public function set moveCount(value:int):void {	_moveCount = value; }
		
		// handID // parent hand ID (if type finger)
		private var _handID:int = 0;
		public function get handID():int{	return _handID;}
		public function set handID(value:int):void{	_handID = value;}
		
		//TEMP//////////////////////////////////////////
		// pairArray 
		private var _pairArray:Array = new Array();
		public function get pairArray():Array{	return _pairArray;}
		public function set pairArray(value:Array):void {	_pairArray = value; }
		
		
		
		// nnID // parent hand ID (if type finger)
		private var _nnID:int = 0;
		public function get nnID():int{	return _nnID;}
		public function set nnID(value:int):void {	_nnID = value; }
		
		// nndID // parent hand ID (if type finger)
		private var _nndID:int = 0;
		public function get nndID():int{	return _nndID;}
		public function set nndID(value:int):void {	_nndID = value; }
		
		// nndaID // parent hand ID (if type finger)
		private var _nndaID:int = 0;
		public function get nndaID():int{	return _nndaID;}
		public function set nndaID(value:int):void {	_nndaID = value; }
		
		// nndaID // parent hand ID (if type finger)
		private var _nnpaID:int = 0;
		public function get nnpaID():int{	return _nnpaID;}
		public function set nnpaID(value:int):void {	_nnpaID = value; }
		
		// nnID // parent hand ID (if type finger)
		private var _nnprobID:int = 0;
		public function get nnprobID():int{	return _nnprobID;}
		public function set nnprobID(value:int):void {	_nnprobID = value; }
		
		///////////////////////////////////////////////
		
		
		
		// handID // parent hand ID (if type finger)
		private var _pairedPointID:int = 0;
		public function get pairedPointID():int{	return _pairedPointID;}
		public function set pairedPointID(value:int):void{	_pairedPointID = value;}
		
		
		
		
		
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
		
		/*
		//size///////////////////////////////////////////w,h,l
		private var _size:Vector3D = new Vector3D ();
		public function get size():Vector3D{	return _size;}
		public function set size(value:Vector3D):void {	_size = value; }
		*/
		//width
		private var _width:Number = 0;
		public function get width():Number{	return _width;}
		public function set width(value:Number):void {	_width = value; }
		//length
		private var _length:Number = 0;
		public function get length():Number{	return _length;}
		public function set length(value:Number):void {	_length = value; }
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
		
		
		//palmAngle
		private var _palmAngle:Number = 0;
		public function get palmAngle():Number{	return _palmAngle;}
		public function set palmAngle(value:Number):void {	_palmAngle = value; }
		
		//normalized_width based on other fingers in local hand
		private var _normalized_width:Number = 0;
		public function get normalized_width():Number{	return _normalized_width;}
		public function set normalized_width(value:Number):void {	_normalized_width = value; }
		//normalized_length based on other fingers in local hand
		private var _normalized_length:Number = 0;
		public function get normalized_length():Number{	return _normalized_length;}
		public function set normalized_length(value:Number):void {	_normalized_length = value; }
		//normalized_dAngle based on other fingers in local hand
		private var _normalized_palmAngle:Number = 0;
		public function get normalized_palmAngle():Number{	return _normalized_palmAngle;}
		public function set normalized_palmAngle(value:Number):void {	_normalized_palmAngle = value; }
		
		
		// hand structure probs
		private var _thumb_prob:Number = 0;
		public function get thumb_prob():Number{	return _thumb_prob;}
		public function set thumb_prob(value:Number):void {	_thumb_prob = value; }
		// hand structure probs
		private var _mean_thumb_prob:Number = 0;
		public function get mean_thumb_prob():Number{	return _mean_thumb_prob;}
		public function set mean_thumb_prob(value:Number):void {	_mean_thumb_prob = value; }
		
		
		
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

		
	
		
		
		///////////////////////////////////////////////////////////////////
		// history/////////////////////////////////////////////////////////
		private var _history:Vector.<MotionPointObject> = new Vector.<MotionPointObject>();
		public function get history():Vector.<MotionPointObject>{	return _history;}
		public function set history(value:Vector.<MotionPointObject>):void{	_history = value;}
		///////////////////////////////////////////////////////////////////
	}
}