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
		// separation------------------
		private var _separationY:Number = 0;
		public function get separationY():Number
		{
			return _separationY;
		}
		public function set separationY(value:Number):void
		{
			_separationY = value;
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
		///////////////////////////////////////////////

		//pointArray
		private var _pointArray:Array = new Array();
		public function get pointArray():Array
		{
			return _pointArray;
		}
		public function set pointArray(value:Array):void
		{
			_pointArray = value;
		}	
			
		// cluster history
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