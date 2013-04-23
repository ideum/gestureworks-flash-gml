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
	import flash.display.DisplayObject;
	import flash.events.TouchEvent;
	
	import com.gestureworks.objects.PointObject;
	
	public class PointPairObject extends Object 
	{	
		// PointPair ID
		private var _id:int;
		public function get id():int{	return _id;}
		public function set id(value:int):void {	_id = value; }
		// Point A
		private var _idA:int;
		public function get idA():int{	return _idA;}
		public function set idA(value:int):void {	_idA = value; }
		// Point B
		private var _idB:int;
		public function get idB():int{	return _idB;}
		public function set idB(value:int):void{	_idB = value;}
		/////////////////////////////////////////////////////////////////////////
		
		// radius
		private var _r:Number = 0;
		public function get r():Number{	return _r;}
		public function set r(value:Number):void{	_r = value;}
		// width
		private var _w:Number = 0;
		public function get w():Number{	return _w;}
		public function set w(value:Number):void{	_w = value;}
		// height
		private var _h:Number = 0;
		public function get h():Number{	return _h;}
		public function set h(value:Number):void {	_h = value; }
		// length
		private var _l:Number = 0;
		public function get l():Number{	return _l;}
		public function set l(value:Number):void {	_l = value; }
		
		// rotation
		private var _rotation:Number = 0;
		public function get rotation():Number{	return _rotation;}
		public function set rotation(value:Number):void {	_rotation = value; }
		// rotationX
		private var _rotationX:Number = 0;
		public function get rotationX():Number{	return _rotationX;}
		public function set rotationX(value:Number):void {	_rotationX = value; }
		// rotationY
		private var _rotationY:Number = 0;
		public function get rotationY():Number{	return _rotationY;}
		public function set rotationY(value:Number):void {	_rotationY = value; }
		// rotationZ
		private var _rotationZ:Number = 0;
		public function get rotationZ():Number{	return _rotationZ;}
		public function set rotationZ(value:Number):void {	_rotationZ = value; }
		
		// separation
		private var _separation:Number = 0;
		public function get separation():Number{	return _separation;}
		public function set separation(value:Number):void {	_separation = value; }
		// separationX
		private var _separationX:Number = 0;
		public function get separationX():Number{	return _separationX;}
		public function set separationX(value:Number):void {	_separationX = value; }
		// separationY
		private var _separationY:Number = 0;
		public function get separationY():Number{	return _separationY;}
		public function set separationY(value:Number):void {	_separationY = value; }
		// separationZ
		private var _separationZ:Number = 0;
		public function get separationZ():Number{	return _separationZ;}
		public function set separationZ(value:Number):void {	_separationZ = value; }
		
		//////////////////////////////////////////////
		// dr
		private var _dr:Number = 0;
		public function get dr():Number{	return _dr;}
		public function set dr(value:Number):void{	_dr = value;}
		// dx
		private var _dx:Number = 0;
		public function get dx():Number{	return _dx;}
		public function set dx(value:Number):void{	_dx = value;}
		// dy
		private var _dy:Number = 0;
		public function get dy():Number{	return _dy;}
		public function set dy(value:Number):void {	_dy = value; }
		// dz
		private var _dz:Number = 0;
		public function get dz():Number{	return _dz;}
		public function set dz(value:Number):void {	_dz = value; }
		
		// ds//2d
		private var _ds:Number = 0;
		public function get ds():Number{	return _ds;}
		public function set ds(value:Number):void{	_ds = value;}
		// dsx
		private var _dsx:Number = 0;
		public function get dsx():Number{	return _dsx;}
		public function set dsx(value:Number):void{	_dsx = value;}
		// dsy
		private var _dsy:Number = 0;
		public function get dsy():Number{	return _dsy;}
		public function set dsy(value:Number):void {	_dsy = value; }
		// dsz
		private var _dsz:Number = 0;
		public function get dsz():Number{	return _dsz;}
		public function set dsz(value:Number):void {	_dsz = value; }
		
		// dtheta
		private var _dtheta:Number = 0;
		public function get dtheta():Number{	return _dtheta;}
		public function set dtheta(value:Number):void{	_dtheta = value;}
		// dthetax
		private var _dthetax:Number = 0;
		public function get dthetax():Number{	return _dthetax;}
		public function set dthetax(value:Number):void{	_dthetax = value;}
		// dthetay
		private var _dthetay:Number = 0;
		public function get dthetay():Number{	return _dthetay;}
		public function set dthetay(value:Number):void {	_dthetay = value; }
		// dthetaz
		private var _dthetaz:Number = 0;
		public function get dthetaz():Number{	return _dthetaz;}
		public function set dthetaz(value:Number):void{	_dthetaz = value;}
		
		// DX
		private var _DX:Number = 0;
		public function get DX():Number{	return _DX;}
		public function set DX(value:Number):void{	_DX = value;}
		// DY
		private var _DY:Number = 0;
		public function get DY():Number{	return _DY;}
		public function set DY(value:Number):void {	_DY = value; }
		// DZ
		private var _DZ:Number = 0;
		public function get DZ():Number{	return _DZ;}
		public function set DZ(value:Number):void{	_DZ = value;}
		

		// history
		private var _history:Vector.<PointPairObject> = new Vector.<PointPairObject>();
		public function get history():Vector.<PointPairObject>{	return _history;}
		public function set history(value:Vector.<PointPairObject>):void{	_history = value;}
		
	}
}