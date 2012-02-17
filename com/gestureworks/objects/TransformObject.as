////////////////////////////////////////////////////////////////////////////////
//
//  IDEUM
//  Copyright 2011-2012 Ideum
//  All Rights Reserved.
//
//  GestureWorks
//
//  File:    TransformObject.as
//  Authors:  Ideum
//             
//  NOTICE: Ideum permits you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////
package com.gestureworks.objects 
{
	
	public class TransformObject extends Object 
	{
		// ID
		private var _id:int;
		public function get id():int
		{
			return _id;
		}
		public function set id(value:int):void
		{
			_id = value;
		}
		
		// x---------------------
		private var _x:Number = 0;
		public function get x():Number
		{
			return _x;
		}
		public function set x(value:Number):void
		{
			_x = value;
		}
		// y---------------------
		private var _y:Number = 0;
		public function get y():Number
		{
			return _y;
		}
		public function set y(value:Number):void
		{
			_y = value;
		}
		// z---------------------
		private var _z:Number = 0;
		public function get z():Number
		{
			return _z;
		}
		public function set z(value:Number):void
		{
			_z = value;
		}
		
		// radius---------------------
		private var _radius:Number = 0;
		public function get radius():Number
		{
			return _radius;
		}
		public function set radius(value:Number):void
		{
			_radius = value;
		}
		
		// width----------------------
		private var _width:Number = 0;
		public function get width():Number
		{
			return _width;
		}
		public function set width(value:Number):void
		{
			_width = value;
		}
		// height---------------------
		private var _height:Number = 0;
		public function get height():Number
		{
			return _height;
		}
		public function set height(value:Number):void
		{
			_height = value;
		}
		
		// scale------------------
		private var _scale:Number = 0;
		public function get scale():Number
		{
			return _scale;
		}
		public function set scale(value:Number):void
		{
			_scale = value;
		}
		// scaleX------------------
		private var _scaleX:Number = 0;
		public function get scaleX():Number
		{
			return _scaleX;
		}
		public function set scaleX(value:Number):void
		{
			_scaleX = value;
		}
		// scaleY------------------
		private var _scaleY:Number = 0;
		public function get scaleY():Number
		{
			return _scaleY;
		}
		public function set scaleY(value:Number):void
		{
			_scaleY = value;
		}
		// rotation---------------------
		private var _rotation:Number = 0;
		public function get rotation():Number
		{
			return _rotation;
		}
		public function set rotation(value:Number):void
		{
			_rotation = value;
		}
		
		// orientation---------------------
		private var _orientation:Number = 0;
		public function get orientation():Number
		{
			return _orientation;
		}
		public function set orientation(value:Number):void
		{
			_orientation = value;
		}
		
		// alpha---------------------
		private var _alpha:Number = 0;
		public function get alpha():Number
		{
			return _alpha;
		}
		public function set alpha(value:Number):void
		{
			_alpha = value;
		}
		
		
		// rotation3D---------------------
		private var _rotationX:Number = 0;
		public function get rotationX():Number
		{
			return _rotationX;
		}
		public function set rotationX(value:Number):void
		{
			_rotationX = value;
		}
		
		private var _rotationY:Number = 0;
		public function get rotationY():Number
		{
			return _rotationY;
		}
		public function set rotationY(value:Number):void
		{
			_rotationY = value;
		}
		private var _rotationZ:Number = 0;
		public function get rotationZ():Number
		{
			return _rotationZ;
		}
		public function set rotationZ(value:Number):void
		{
			_rotationZ = value;
		}
		/////////////////////////////////////////////////
		// object properties
		/////////////////////////////////////////////////
		// x---------------------
		private var _obj_x:Number = 0;
		public function get obj_x():Number
		{
			return _obj_x;
		}
		public function set obj_x(value:Number):void
		{
			_obj_x = value;
		}
		// y---------------------
		private var _obj_y:Number = 0;
		public function get obj_y():Number
		{
			return _obj_y;
		}
		public function set obj_y(value:Number):void
		{
			_obj_y = value;
		}
		// z---------------------
		private var _obj_z:Number = 0;
		public function get obj_z():Number
		{
			return _obj_z;
		}
		public function set obj_z(value:Number):void
		{
			_obj_z = value;
		}
		
		// width----------------------
		private var _obj_width:Number = 0;
		public function get obj_width():Number
		{
			return _obj_width;
		}
		public function set obj_width(value:Number):void
		{
			_obj_width = value;
		}
		// height---------------------
		private var _obj_height:Number = 0;
		public function get obj_height():Number
		{
			return _obj_height;
		}
		public function set obj_height(value:Number):void
		{
			_obj_height = value;
		}
		
		// scaleX------------------
		private var _obj_scaleX:Number = 0;
		public function get obj_scaleX():Number
		{
			return _obj_scaleX;
		}
		public function set obj_scaleX(value:Number):void
		{
			_obj_scaleX = value;
		}
		// scaleY------------------
		private var _obj_scaleY:Number = 0;
		public function get obj_scaleY():Number
		{
			return _obj_scaleY;
		}
		public function set obj_scaleY(value:Number):void
		{
			_obj_scaleY = value;
		}
		// rotation---------------------
		private var _obj_rotation:Number = 0;
		public function get obj_rotation():Number
		{
			return _obj_rotation;
		}
		public function set obj_rotation(value:Number):void
		{
			_obj_rotation = value;
		}
		
		// rotationX---------------------
		private var _obj_rotationX:Number = 0;
		public function get obj_rotationX():Number
		{
			return _obj_rotationX;
		}
		public function set obj_rotationX(value:Number):void
		{
			_obj_rotationX = value;
		}
		// rotationY---------------------
		private var _obj_rotationY:Number = 0;
		public function get obj_rotationY():Number
		{
			return _obj_rotationY;
		}
		public function set obj_rotationY(value:Number):void
		{
			_obj_rotationY = value;
		}
		// rotationZ---------------------
		private var _obj_rotationZ:Number = 0;
		public function get obj_rotationZ():Number
		{
			return _obj_rotationZ;
		}
		public function set obj_rotationZ(value:Number):void
		{
			_obj_rotationZ = value;
		}
		
		/////////////////////////////////////////////////
		// velocities
		/////////////////////////////////////////////////
		
		// dx---------------------
		private var _dx:Number = 0;
		public function get dx():Number
		{
			return _dx;
		}
		public function set dx(value:Number):void
		{
			_dx = value;
		}
		
		// dy---------------------
		private var _dy:Number = 0;
		public function get dy():Number
		{
			return _dy;
		}
		public function set dy(value:Number):void
		{
			_dy = value;
		}
		
		// dw---------------------
		private var _dw:Number = 0;
		public function get dw():Number
		{
			return _dw;
		}
		public function set dw(value:Number):void
		{
			_dw = value;
		}
		// dh---------------------
		private var _dh:Number = 0;
		public function get dh():Number
		{
			return _dh;
		}
		public function set dh(value:Number):void
		{
			_dh = value;
		}
		
		// dsx---------------------
		private var _ds:Number = 0;
		public function get ds():Number
		{
			return _ds;
		}
		public function set ds(value:Number):void
		{
			_ds = value;
		}
		
		// dsx---------------------
		private var _dsx:Number = 0;
		public function get dsx():Number
		{
			return _dsx;
		}
		public function set dsx(value:Number):void
		{
			_dsx = value;
		}
		
		// dsy---------------------
		private var _dsy:Number = 0;
		public function get dsy():Number
		{
			return _dsy;
		}
		public function set dsy(value:Number):void
		{
			_dsy = value;
		}
		// dtheta ------------------
		private var _dtheta:Number = 0;
		public function get dtheta():Number
		{
			return _dtheta;
		}
		public function set dtheta(value:Number):void
		{
			_dtheta = value;
		}
		// dthetaX ------------------
		private var _dthetaX:Number = 0;
		public function get dthetaX():Number
		{
			return _dthetaX;
		}
		public function set dthetaX(value:Number):void
		{
			_dthetaX = value;
		}
		// dthetaY ------------------
		private var _dthetaY:Number = 0;
		public function get dthetaY():Number
		{
			return _dthetaY;
		}
		public function set dthetaY(value:Number):void
		{
			_dthetaY = value;
		}
		// dthetaZ ------------------
		private var _dthetaZ:Number = 0;
		public function get dthetaZ():Number
		{
			return _dthetaZ;
		}
		public function set dthetaZ(value:Number):void
		{
			_dthetaZ = value;
		}
		// dalpha ------------------
		private var _dalpha:Number = 0;
		public function get dalpha():Number
		{
			return _dalpha;
		}
		public function set dalpha(value:Number):void
		{
			_dalpha = value;
		}
		///////////////////////////////////////////////
		// pre_init_height ------------------
		private var _pre_init_height:Number = 0;
		public function get pre_init_height():Number
		{
			return _pre_init_height;
		}
		public function set pre_init_height(value:Number):void
		{
			_pre_init_height = value;
		}
		// pre_init_width ------------------
		private var _pre_init_width:Number = 0;
		public function get pre_init_width():Number
		{
			return _pre_init_width;
		}
		public function set pre_init_width(value:Number):void
		{
			_pre_init_width = value;
		}
		
		// transformPointOn ------------------
		private var _init_center_point:Boolean = false;
		public function get init_center_point():Boolean
		{
			return _init_center_point;
		}
		public function set init_center_point(value:Boolean):void
		{
			_init_center_point = value;
		}
		
		// transformPointOn ------------------
		private var _transformPointsOn:Boolean = false;
		public function get transformPointsOn():Boolean
		{
			return _transformPointsOn;
		}
		public function set transformPointsOn(value:Boolean):void
		{
			_transformPointsOn = value;
		}
		
		// debug points 
		private var _affinePoints:Array;
		public function get affinePoints():Array
		{
			return _affinePoints;
		}
		public function set affinePoints(value:Array):void
		{
			_affinePoints= value;
		}
		
		// transformed debug points 
		private var _transAffinePoints:Array;
		public function get transAffinePoints():Array
		{
			return _transAffinePoints;
		}
		public function set transAffinePoints(value:Array):void
		{
			_transAffinePoints= value;
		}
			
		// transform history
		private var _history:Array = new Array();
		public function get history():Array
		{
			return _history;
		}
		public function set history(value:Array):void
		{
			_history = value;
		}
	}
}