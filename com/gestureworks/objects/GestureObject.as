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
		
		///////////////////////////////////////////////////
		// GESTURE EVENT LOGIC
		///////////////////////////////////////////////////
		
		// start
		private var _start:Boolean = false;
		public function get start():Boolean
		{
			return _start;
		}
		public function set start(value:Boolean):void
		{
			_start = value;
		}
		
		// active // uses active touch data to esablish gesture object values
		private var _active:Boolean = false;
		public function get active():Boolean
		{
			return _active;
		}
		public function set active(value:Boolean):void
		{
			_active = value;
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
		
		// passive // easing and other passive processes that use cached gesture object values
		private var _passive:Boolean = false;
		public function get passive():Boolean
		{
			return _passive;
		}
		public function set passive(value:Boolean):void
		{
			_passive = value;
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

	}

}