////////////////////////////////////////////////////////////////////////////////
//
//  IDEUM
//  Copyright 2011-2012 Ideum
//  All Rights Reserved.
//
//  GestureWorks
//
//  File:    TouchObject.as
//  Authors:  Ideum
//             
//  NOTICE: Ideum permits you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////
package com.gestureworks.objects 
{	
	/**
	 * The TouchObject class is the base class for all touch enabled DisplayObjects. It
	 * provides basic implementations for priortized gesture and touch processing as well as 
	 * properties to dictate tactual object ownership and targeting. This object inherits
	 * the Player default Sprite functionality.
	 * 
	 * <p>All TouchObjects are provided with a static reference to the global blob manager
	 * at runtime. A DataProvider to the blob manager is established upon Application 
	 * instantiation by the developer.</p>
	 * 
	 */
	public class TouchObject extends Object 
	{
		// ID
		private var _id:int;
		public function get id():int{	return _id;}
		public function set id(value:int):void{	_id = value;}
		
		//////////////////////////////////////////////
		// debug points 
		private var _affinePoints:Array;
		public function get affinePoints():Array{	return _affinePoints;}
		public function set affinePoints(value:Array):void{	_affinePoints= value;}
		// transformed debug points 
		private var _transAffinePoints:Array;
		public function get transAffinePoints():Array{	return _transAffinePoints;}
		public function set transAffinePoints(value:Array):void{	_transAffinePoints= value;}
	}
}