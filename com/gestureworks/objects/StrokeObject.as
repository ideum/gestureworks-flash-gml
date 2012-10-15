////////////////////////////////////////////////////////////////////////////////
//
//  IDEUM
//  Copyright 2011-2012 Ideum
//  All Rights Reserved.
//
//  GestureWorks
//
//  File:    StrokeObject.as
//  Authors:  Ideum
//             
//  NOTICE: Ideum permits you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////
package com.gestureworks.objects 
{
	
	public class StrokeObject extends Object 
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
		
		// NUMBER OF STROKES IN STROKE OBJECT
		private var _n:int = 0;
		public function get n():int
		{
			return _n;
		}
		public function set n(value:int):void
		{
			_n = value;
		}
		
		private var _path_collection:Vector.<Array> = new Vector.<Array>();
		public function get path_collection():Vector.<Array>
		{
			return _path_collection;
		}
		public function set path_collection(value:Vector.<Array>):void
		{
			_path_collection = value;
		}
		
		// path_data FOR UNISTROKES
		private var _path_data:Array = new Array();
		public function get path_data():Array
		{
			return _path_data;
		}
		public function set path_data(value:Array):void
		{
			_path_data = value;
		}
		// NORMALIZED PATH DATA FOR UNISTROKES
		private var _path_data_norm:Array = new Array();
		public function get path_data_norm():Array
		{
			return _path_data_norm;
		}
		public function set path_data_norm(value:Array):void
		{
			_path_data_norm = value;
		}
		
		//////////////////////kill
		private var _pathmap:Array = new Array();
		public function get pathmap():Array
		{
			return _pathmap;
		}
		public function set pathmap(value:Array):void
		{
			_pathmap = value;
		}
		////////////////////////
		
		// PATH DATA FOR MULTISTROKES
		private var _pathDataArray:Vector.<Array> = new Vector.<Array>();
		public function get pathDataArray():Vector.<Array>
		{
			return _pathDataArray;
		}
		public function set pathDataArray(value:Vector.<Array>):void
		{
			_pathDataArray = value;
		}
		
		
		// PATH MATCH PROBABILITY 
		private var _path_prob:Number = 0;
		public function get path_prob():Number
		{
			return _path_prob;
		}
		public function set path_prob(value:Number):void
		{
			_path_prob = value;
		}
		// NUMBER OF POINTS LENGTH
		private var _path_n:Number = 0;
		public function get path_n():Number
		{
			return _path_n;
		}
		public function set path_n(value:Number):void
		{
			_path_n = value;
		}
		// TIME TO DRAW PATH
		private var _path_time:Number = 0;
		public function get path_time():Number
		{
			return _path_time;
		}
		public function set path_time(value:Number):void
		{
			_path_time = value;
		}
		
		
		// AVERAGE PATH POSITION
		private var _path_x:Number = 0;
		public function get path_x():Number
		{
			return _path_x;
		}
		public function set path_x(value:Number):void
		{
			_path_x = value;
		}
		private var _path_y:Number = 0;
		public function get path_y():Number
		{
			return _path_y;
		}
		public function set path_y(value:Number):void
		{
			_path_y = value;
		}
		// STARTING POINT
		private var _path_x0:Number = 0;
		public function get path_x0():Number
		{
			return _path_x0;
		}
		public function set path_x0(value:Number):void
		{
			_path_x0 = value;
		}
		private var _path_y0:Number = 0;
		public function get path_y0():Number
		{
			return _path_y0;
		}
		public function set path_y0(value:Number):void
		{
			_path_y0 = value;
		}
		// END POINT
		private var _path_x1:Number = 0;
		public function get path_x1():Number
		{
			return _path_x1;
		}
		public function set path_x1(value:Number):void
		{
			_path_x1 = value;
		}
		private var _path_y1:Number = 0;
		public function get path_y1():Number
		{
			return _path_y1;
		}
		public function set path_y1(value:Number):void
		{
			_path_y1 = value;
		}
		
		// AVERAGE PATH WIDTH
		private var _path_width:Number = 0;
		public function get path_width():Number
		{
			return _path_width;
		}
		public function set path_width(value:Number):void
		{
			_path_width = value;
		}
		private var _path_height:Number = 0;
		public function get path_height():Number
		{
			return _path_height;
		}
		public function set path_height(value:Number):void
		{
			_path_height = value;
		}
		//////////////////////////////////////////////
		
		
		
		
		
		
	}
}