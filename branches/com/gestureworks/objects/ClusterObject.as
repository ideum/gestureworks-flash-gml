////////////////////////////////////////////////////////////////////////////////
//
//  IDEUM
//  Copyright 2011-2012 Ideum
//  All Rights Reserved.
//
//  GestureWorks
//
//  File:    ClusterObject.as
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
	
	import com.leapmotion.leap.events.LeapEvent;
	import com.leapmotion.leap.LeapMotion;
	
	import com.leapmotion.leap.*;
	import com.leapmotion.leap.events.*;
	import com.leapmotion.leap.util.*;
	
	public class ClusterObject extends Object 
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
		
		private var _type:String;
		public function get type():String
		{
			return _type;
		}
		public function set type(value:String):void
		{
			_type = value;
		}
		///////////////////////////////////////
		// cluster properties//////////////////
		///////////////////////////////////////
		// number of points---------------------
		private var _n:int = 0;
		public function get n():int
		{
			return _n;
		}
		public function set n(value:int):void
		{
			_n = value;
		}
		
		// number of hands---------------------
		private var _hn:int = 0;
		public function get hn():int
		{
			return _hn;
		}
		public function set hn(value:int):void
		{
			_hn = value;
		}
		
		// number of fingers---------------------
		private var _fn:int = 0;
		public function get fn():int
		{
			return _fn;
		}
		public function set fn(value:int):void
		{
			_fn = value;
		}
		
		// number of fingers---------------------
		private var _lhfn:int = 0;
		public function get lhfn():int
		{
			return _lhfn;
		}
		public function set lhfn(value:int):void
		{
			_lhfn = value;
		}
		
		// number of fingers---------------------
		private var _rhfn:int = 0;
		public function get rhfn():int
		{
			return _rhfn;
		}
		public function set rhfn(value:int):void
		{
			_rhfn = value;
		}
		
		
		
		
		
		
		
		
		/////////////////////////////////
		
		private var _count:int;
		public function get count():int
		{
			return _count;
		}
		public function set count(value:int):void
		{
			_count = value;
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
		
		// length---------------------
		private var _length:Number = 0;
		public function get length():Number
		{
			return _length;
		}
		public function set length(value:Number):void
		{
			_length = value;
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
		// separation------------------
		private var _separation:Number = 0;
		public function get separation():Number
		{
			return _separation;
		}
		public function set separation(value:Number):void
		{
			_separation = value;
		}
		
		// separation------------------
		private var _separationX:Number = 0;
		public function get separationX():Number
		{
			return _separationX;
		}
		public function set separationX(value:Number):void
		{
			_separationX = value;
		}
		// separationY------------------
		private var _separationY:Number = 0;
		public function get separationY():Number
		{
			return _separationY;
		}
		public function set separationY(value:Number):void
		{
			_separationY = value;
		}
		// separationZ------------------
		private var _separationZ:Number = 0;
		public function get separationZ():Number
		{
			return _separationZ;
		}
		public function set separationZ(value:Number):void
		{
			_separationZ = value;
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
		
		// rotation---------------------
		private var _rotationX:Number = 0;
		public function get rotationX():Number
		{
			return _rotationX;
		}
		public function set rotationX(value:Number):void
		{
			_rotationX = value;
		}
		// rotation---------------------
		private var _rotationY:Number = 0;
		public function get rotationY():Number
		{
			return _rotationY;
		}
		public function set rotationY(value:Number):void
		{
			_rotationY = value;
		}
		// rotationZ---------------------
		private var _rotationZ:Number = 0;
		public function get rotationZ():Number
		{
			return _rotationZ;
		}
		public function set rotationZ(value:Number):void
		{
			_rotationZ = value;
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
		
		// x---------------------
		private var _mx:Number = 0;
		public function get mx():Number
		{
			return _mx;
		}
		public function set mx(value:Number):void
		{
			_mx = value;
		}
		// y---------------------
		private var _my:Number = 0;
		public function get my():Number
		{
			return _my;
		}
		public function set my(value:Number):void
		{
			_my = value;
		}
		// mz---------------------
		private var _mz:Number = 0;
		public function get mz():Number
		{
			return _mz;
		}
		public function set mz(value:Number):void
		{
			_mz = value;
		}
		
		
		// orient_dx---------------------
		private var _orient_dx:Number = 0;
		public function get orient_dx():Number
		{
			return _orient_dx;
		}
		public function set orient_dx(value:Number):void
		{
			_orient_dx = value;
		}
		
		// orient_dy---------------------
		private var _orient_dy:Number = 0;
		public function get orient_dy():Number
		{
			return _orient_dy;
		}
		public function set orient_dy(value:Number):void
		{
			_orient_dy = value;
		}
		
		// orient_dz---------------------
		private var _orient_dz:Number = 0;
		public function get orient_dz():Number
		{
			return _orient_dz;
		}
		public function set orient_dz(value:Number):void
		{
			_orient_dz = value;
		}
		
		
		// hold_x---------------------
		private var _hold_x:Number = 0;
		public function get hold_x():Number
		{
			return _hold_x;
		}
		public function set hold_x(value:Number):void
		{
			_hold_x = value;
		}
		// hold_y---------------------
		private var _hold_y:Number = 0;
		public function get hold_y():Number
		{
			return _hold_y;
		}
		public function set hold_y(value:Number):void
		{
			_hold_y = value;
		}
		
		// hold_z---------------------
		private var _hold_z:Number = 0;
		public function get hold_z():Number
		{
			return _hold_z;
		}
		public function set hold_z(value:Number):void
		{
			_hold_z = value;
		}
		
		// c_locked---------------------
		private var _hold_n:int = 0;
		public function get hold_n():int
		{
			return _hold_n;
		}
		public function set hold_n(value:int):void
		{
			_hold_n = value;
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
		
		// dz---------------------
		private var _dz:Number = 0;
		public function get dz():Number
		{
			return _dz;
		}
		public function set dz(value:Number):void
		{
			_dz = value;
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
		
		// dr---------------------
		private var _dr:Number = 0;
		public function get dr():Number
		{
			return _dr;
		}
		public function set dr(value:Number):void
		{
			_dr = value;
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
		// dsz---------------------
		private var _dsz:Number = 0;
		public function get dsz():Number
		{
			return _dsz;
		}
		public function set dsz(value:Number):void
		{
			_dsz = value;
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
		
		// dthetax ------------------
		private var _dthetaX:Number = 0;
		public function get dthetaX():Number
		{
			return _dthetaX;
		}
		public function set dthetaX(value:Number):void
		{
			_dthetaX = value;
		}
		
		// dthetay ------------------
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
		
		// pivot_dtheta ------------------
		private var _pivot_dtheta:Number = 0;
		public function get pivot_dtheta():Number
		{
			return _pivot_dtheta;
		}
		public function set pivot_dtheta(value:Number):void
		{
			_pivot_dtheta = value;
		}
		
		// mdx---------------------
		private var _mdx:Number = 0;
		public function get mdx():Number
		{
			return _mdx;
		}
		public function set mdx(value:Number):void
		{
			_mdx = value;
		}
		
		// mdy---------------------
		private var _mdy:Number = 0;
		public function get mdy():Number
		{
			return _mdy;
		}
		public function set mdy(value:Number):void
		{
			_mdy = value;
		}
		// mdz---------------------
		private var _mdz:Number = 0;
		public function get mdz():Number
		{
			return _mdz;
		}
		public function set mdz(value:Number):void
		{
			_mdz = value;
		}
		//////////////////////////////////////////////
		// accelerations
		//////////////////////////////////////////////
		
		// ddx ------------------
		private var _ddx:Number = 0;
		public function get ddx():Number
		{
			return _ddx;
		}
		public function set ddx(value:Number):void
		{
			_ddx = value;
		}
		// ddy ------------------
		private var _ddy:Number = 0;
		public function get ddy():Number
		{
			return _ddy;
		}
		public function set ddy(value:Number):void
		{
			_ddy = value;
		}
		
		// ddz ------------------
		private var _ddz:Number = 0;
		public function get ddz():Number
		{
			return _ddz;
		}
		public function set ddz(value:Number):void
		{
			_ddz = value;
		}
		
		// ddtheta ------------------
		private var _ddtheta:Number = 0;
		public function get ddtheta():Number
		{
			return _ddtheta;
		}
		public function set ddtheta(value:Number):void
		{
			_ddtheta = value;
		}
		// ddsx ------------------
		private var _ddsx:Number = 0;
		public function get ddsx():Number
		{
			return _ddsx;
		}
		public function set ddsx(value:Number):void
		{
			_ddsx = value;
		}
		// ddsy ------------------
		private var _ddsy:Number = 0;
		public function get ddsy():Number
		{
			return _ddsy;
		}
		public function set ddsy(value:Number):void
		{
			_ddsy = value;
		}
		
		// ddsz ------------------
		private var _ddsz:Number = 0;
		public function get ddsz():Number
		{
			return _ddsz;
		}
		public function set ddsz(value:Number):void
		{
			_ddsz = value;
		}
		// dds ------------------
		private var _dds:Number = 0;
		public function get dds():Number
		{
			return _dds;
		}
		public function set dds(value:Number):void
		{
			_dds = value;
		}
		
		// dds3d ------------------
		private var _dds3d:Number = 0;
		public function get dds3d():Number
		{
			return _dds3d;
		}
		public function set dds3d(value:Number):void
		{
			_dds3d = value;
		}
		
	
		// thumbID ------------------
		private var _thumbID:int = 0;
		public function get thumbID():int
		{
			return _thumbID;
		}
		public function set thumbID(value:int):void
		{
			_thumbID = value;
		}
		
		//hand profile
		private var _hand:Object = new Object();
		public function get hand():Object
		{
			return _hand;
		}
		public function set hand(value:Object):void
		{
			_hand = value;
		}
		
		
		// etm_ddx ------------------
		private var _etm_dx:Number = 0;
		public function get etm_dx():Number
		{
			return _etm_dx;
		}
		public function set etm_dx(value:Number):void
		{
			_etm_dx = value;
		}
		// etm ddy ------------------
		private var _etm_dy:Number = 0;
		public function get etm_dy():Number
		{
			return _etm_dy;
		}
		public function set etm_dy(value:Number):void
		{
			_etm_dy = value;
		}
		// etm ddz ------------------
		private var _etm_dz:Number = 0;
		public function get etm_dz():Number
		{
			return _etm_dz;
		}
		public function set etm_dz(value:Number):void
		{
			_etm_dz = value;
		}
		
		// etm_ddx ------------------
		private var _etm_ddx:Number = 0;
		public function get etm_ddx():Number
		{
			return _etm_ddx;
		}
		public function set etm_ddx(value:Number):void
		{
			_etm_ddx = value;
		}
		// ddy ------------------
		private var _etm_ddy:Number = 0;
		public function get etm_ddy():Number
		{
			return _etm_ddy;
		}
		public function set etm_ddy(value:Number):void
		{
			_etm_ddy = value;
		}
		
		// ddz ------------------
		private var _etm_ddz:Number = 0;
		public function get etm_ddz():Number
		{
			return _etm_ddz;
		}
		public function set etm_ddz(value:Number):void
		{
			_etm_ddz = value;
		}
		
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////
		// refactor out ----------------------------------------------------------------------------------------------
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
		// path_data
		private var _path_data:Array = new Array();
		public function get path_data():Array
		{
			return _path_data;
		}
		public function set path_data(value:Array):void
		{
			_path_data = value;
		}	
		
		
		///////////////////////////////////////////////
		// CLUSTER EVENT LOGIC
		///////////////////////////////////////////////
		
		// add point
		private var _point_add:Boolean = false;
		public function get point_add():Boolean
		{
			return _point_add;
		}
		public function set point_add(value:Boolean):void
		{
			_point_add = value;
		}
		// remove point
		private var _point_remove:Boolean = false;
		public function get point_remove():Boolean
		{
			return _point_remove;
		}
		public function set point_remove(value:Boolean):void
		{
			_point_remove = value;
		}
		// add cluster
		private var _add:Boolean = false;
		public function get add():Boolean
		{
			return _add;
		}
		public function set add(value:Boolean):void
		{
			_add = value;
		}
		// remove cluster
		private var _remove:Boolean = false;
		public function get remove():Boolean
		{
			return _remove;
		}
		public function set remove(value:Boolean):void
		{
			_remove = value;
		}
		
		
		//default cluster level data structures
		private var _pointArray:Vector.<PointObject> = new Vector.<PointObject>();
		public function get pointArray():Vector.<PointObject>
		{
			return _pointArray;
		}
		public function set pointArray(value:Vector.<PointObject>):void
		{
			_pointArray = value;
		}
		
		private var _motionArray:Frame = new Frame();
		public function get motionArray():Frame
		{
			return _motionArray;
		}
		public function set motionArray(value:Frame):void
		{
			_motionArray = value;
		}
		
		private var _sensorArray:Vector.<Number> = new Vector.<Number>();
		public function get sensorArray():Vector.<Number>
		{
			return _sensorArray;
		}
		public function set sensorArray(value:Vector.<Number>):void
		{
			_sensorArray = value;
		}
			
		
		// cluster history
		private var _history:Vector.<ClusterObject> = new Vector.<ClusterObject>();
		public function get history():Vector.<ClusterObject>
		{
			return _history;
		}
		public function set history(value:Vector.<ClusterObject>):void
		{
			_history = value;
		}
	}
}