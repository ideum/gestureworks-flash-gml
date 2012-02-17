////////////////////////////////////////////////////////////////////////////////
//
//  IDEUM
//  Copyright 2011-2012 Ideum
//  All Rights Reserved.
//
//  GestureWorks
//
//  File:    GestureObject.as
//  Authors:  Ideum
//             
//  NOTICE: Ideum permits you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////
package com.gestureworks.objects 
{
		
	public class GestureObject extends Object 
	{
		////////////////////////////////////////////////////////////////////
		// holds all gestures performed on a touch object in a single frame
		// is alot like the cluster object but data is contextualized and 
		// qualified as a gesture event 
		////////////////////////////////////////////////////////////////////
		
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
		
		//////////////////////////////////////////////////
		// GESTURE PROPERTIES
		//////////////////////////////////////////////////
		
		private var _gestureRelease:Boolean = true;
		public function get gestureRelease():Boolean
		{
			return _gestureRelease;
		}
		public function set gestureRelease(value:Boolean):void
		{
			_gestureRelease = value;
		}

		
		//////////////////////////////////////////////////
		// OBJECT PROPERTIES
		//////////////////////////////////////////////////
		
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
		// rotationX---------------------
		private var _rotationX:Number = 0;
		public function get rotationX():Number
		{
			return _rotationX;
		}
		public function set rotationX(value:Number):void
		{
			_rotationX = value;
		}
		// rotationY---------------------
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
		
		//////////////////////////////////////////////////
		// VELOCITIES
		//////////////////////////////////////////////////
		
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
		
		
		////////////////////////////////////////////////////
		// OVERRIDE LOGIC
		////////////////////////////////////////////////////
		
		//gestures tweening
		private var _gestureTweenOn:Boolean;
		public function get gestureTweenOn():Boolean
		{
			return _gestureTweenOn;
		}
		public function set gestureTweenOn(value:Boolean):void
		{
			_gestureTweenOn = value;
		}
		
		//gesture transform
		private var _gestureTransformOn:Boolean;
		public function get gestureTransformOn():Boolean
		{
			return _gestureTransformOn;
		}
		public function set gestureTransformOn(value:Boolean):void
		{
			_gestureTransformOn = value;
		}
		
		///////////////////////////////////////////////////
		// GESTURE EVENT LOGIC
		///////////////////////////////////////////////////
		
		// complete
		private var _start:Boolean = false;
		public function get start():Boolean
		{
			return _start;
		}
		public function set start(value:Boolean):void
		{
			_start = value;
		}
		
		// complete
		private var _complete:Boolean = false;
		public function get complete():Boolean
		{
			return _complete;
		}
		public function set complete(value:Boolean):void
		{
			_complete = value;
		}
		// release
		private var _release:Boolean = false;
		public function get release():Boolean
		{
			return _release;
		}
		public function set release(value:Boolean):void
		{
			_release = value;
		}
		
		//////////////////////////////////////////////////////////////
		// a list of dynamic GML cnofigfured gesture property objects
		// for the touchsprite
		//////////////////////////////////////////////////////////////
		
		//property Object List
		private var _pOList:Object = new Object();
		public function get pOList():Object
		{
			return _pOList;
		}
		public function set pOList(value:Object):void
		{
			_pOList = value;
		}
		
		//////////////////////////////////////////////////////////////
		//
		/////////////////////////////////////////////////////////////
		
		// gesture object history array
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