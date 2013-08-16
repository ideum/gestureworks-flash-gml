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
	import com.gestureworks.objects.InteractionPointObject;
	import flash.geom.Vector3D;
	
	public class ipClusterObject extends Object 
	{
		// ID
		public var id:int;
	
		// cluster type
		public var type:String;
		
		///////////////////////////////////////
		// cluster properties//////////////////
		///////////////////////////////////////
		// number of points---------------------
		private var n:int = 0;
	
		// number of hands---------------------
		private var hn:int = 0;
		
		// number of fingers---------------------
		private var fn:int = 0;
		
		
		// number of derived interactive points---------------------
		public var ipn:int = 0;
		public var ipnk:Number = 0;
		public var ipnk0:Number = 0;
		
		// CHANGE IN NUMBER OF INTERACTION POINTS
		public var dipn:int = 0;
		
		
		
		
		/////////////////////////////////
		// frame count
		public var count:int;
		
		// x---------------------
		public var x:Number = 0;
		// y---------------------
		public var y:Number = 0;
		// z---------------------
		public var z:Number = 0;
		
		
		// width----------------------
		public var width:Number = 0;
		// height---------------------
		public var height:Number = 0;
		// length---------------------
		public var length:Number = 0;
		// radius---------------------
		public var radius:Number = 0;
	
		
		// separation------------------
		public var separation:Number = 0;
		// separation------------------
		public var separationX:Number = 0;
		// separationY------------------
		public var separationY:Number = 0;
		// separationZ------------------
		public var separationZ:Number = 0;
	
		
		// rotation---------------------
		public var rotation:Number = 0;
		// rotationX---------------------
		public var rotationX:Number = 0;
		// rotation---------------------
		public var rotationY:Number = 0;
		// rotationZ---------------------
		public var rotationZ:Number = 0;
		
		
		// mean position
		// mx---------------------
		public var mx:Number = 0;
		// my---------------------
		public var my:Number = 0;
		// mz---------------------
		public var mz:Number = 0;
		
		
		/////////////////////////////////////////////////
		// velocities
		/////////////////////////////////////////////////
		// dx---------------------
		public var dx:Number = 0;
		// dy---------------------
		public var dy:Number = 0;
		// dz---------------------
		public var dz:Number = 0;
		
		
		// size veloctiy
		// dw---------------------
		public var dw:Number = 0;
		// dh---------------------
		public var dh:Number = 0;
		// dr---------------------
		public var dr:Number = 0;

		
		///////////////////////////////////////////////////////////////////////////////
		// scale velocity
		///////////////////////////////////////////////////////////////////////////////
		// dsx---------------------
		public var ds:Number = 0;
		// dsx---------------------
		public var dsx:Number = 0;
		// dsy---------------------
		public var dsy:Number = 0;
		// dsz---------------------
		public var dsz:Number = 0;
		
		///////////////////////////////////////////////////////////////////////////////
		//rotational velocity
		///////////////////////////////////////////////////////////////////////////////
		// dtheta ------------------
		public var dtheta:Number = 0;
		
		// dthetax ------------------
		public var dthetaX:Number = 0;
		
		// dthetay ------------------
		public var dthetaY:Number = 0;
		
		// dthetaZ ------------------
		public var dthetaZ:Number = 0;
		
		// pivot_dtheta ------------------
		public var pivot_dtheta:Number = 0;
	
	
		///////////////////////////////////////////////////////////////////////////////
		//mean velocity
		///////////////////////////////////////////////////////////////////////////////
		// mdx---------------------
		private var _mdx:Number = 0;
		public function get mdx():Number{return _mdx;}
		public function set mdx(value:Number):void{_mdx = value;}
		// mdy---------------------
		private var _mdy:Number = 0;
		public function get mdy():Number{	return _mdy;}
		public function set mdy(value:Number):void{	_mdy = value;}
		// mdz---------------------
		private var _mdz:Number = 0;
		public function get mdz():Number{	return _mdz;}
		public function set mdz(value:Number):void{	_mdz = value;}
		
		//////////////////////////////////////////////
		// accelerations
		//////////////////////////////////////////////
		// ddx ------------------
		private var _ddx:Number = 0;
		public function get ddx():Number{	return _ddx;}
		public function set ddx(value:Number):void{	_ddx = value;}
		// ddy ------------------
		private var _ddy:Number = 0;
		public function get ddy():Number{	return _ddy;}
		public function set ddy(value:Number):void{	_ddy = value;}
		// ddz ------------------
		private var _ddz:Number = 0;
		public function get ddz():Number{	return _ddz;}
		public function set ddz(value:Number):void{	_ddz = value;}
		
		///////////////////////////////////////////////////////////////////////////////
		// rotational acceleration
		///////////////////////////////////////////////////////////////////////////////
		// ddtheta ------------------
		private var _ddtheta:Number = 0;
		public function get ddtheta():Number{	return _ddtheta;}
		public function set ddtheta(value:Number):void	{	_ddtheta = value; }
		
		////////////////////////////////////////////////////////////////////////////////
		// separation acceleration
		////////////////////////////////////////////////////////////////////////////////
		// ddsx ------------------
		private var _ddsx:Number = 0;
		public function get ddsx():Number{	return _ddsx;}
		public function set ddsx(value:Number):void{	_ddsx = value;}
		// ddsy ------------------
		private var _ddsy:Number = 0;
		public function get ddsy():Number{	return _ddsy;}
		public function set ddsy(value:Number):void{	_ddsy = value;}
		// ddsz ------------------
		private var _ddsz:Number = 0;
		public function get ddsz():Number{	return _ddsz;}
		public function set ddsz(value:Number):void{	_ddsz = value;}
		// dds ------------------
		private var _dds:Number = 0;
		public function get dds():Number{	return _dds;}
		public function set dds(value:Number):void{	_dds = value;}
		// dds3d ------------------
		private var _dds3d:Number = 0;
		public function get dds3d():Number{	return _dds3d; }
		public function set dds3d(value:Number):void{_dds3d = value;}
		
		///////////////////////////////////////////////////////////////////////////////
		// estimated total mean acceleration
		///////////////////////////////////////////////////////////////////////////////
		// etm_ddx ------------------
		private var _etm_dx:Number = 0;
		public function get etm_dx():Number{	return _etm_dx;}
		public function set etm_dx(value:Number):void{	_etm_dx = value;}
		// etm ddy ------------------
		private var _etm_dy:Number = 0;
		public function get etm_dy():Number{	return _etm_dy;}
		public function set etm_dy(value:Number):void{	_etm_dy = value;}
		// etm ddz ------------------
		private var _etm_dz:Number = 0;
		public function get etm_dz():Number{	return _etm_dz;}
		public function set etm_dz(value:Number):void{	_etm_dz = value;}
		// etm_ddx ------------------
		private var _etm_ddx:Number = 0;
		public function get etm_ddx():Number{	return _etm_ddx;}
		public function set etm_ddx(value:Number):void{	_etm_ddx = value;}
		// etm_ddy ------------------
		private var _etm_ddy:Number = 0;
		public function get etm_ddy():Number{	return _etm_ddy;}
		public function set etm_ddy(value:Number):void{_etm_ddy = value;}
		// etm_ddz ------------------
		private var _etm_ddz:Number = 0;
		public function get etm_ddz():Number{return _etm_ddz;}
		public function set etm_ddz(value:Number):void{_etm_ddz = value;}
		
		
		///////////////////////////////////////////////////////////////////////////////
		// 2d/3d hand surface profile / data structure
		///////////////////////////////////////////////////////////////////////////////
		
		// become handList //NO NEED AS ANY CLUSTER CAN BE A HAND 2D OR 3D
		// ANY CLUSTER CAN SUBCLUSTER INTO TWO HANDS OR SUBLISTS OF PREANALYZED POINTS
		private var _handList:Vector.<HandObject> = new Vector.<HandObject>;
		public function get handList():Vector.<HandObject>{return _handList;}
		public function set handList(value:Vector.<HandObject>):void{_handList = value;}
			/// INSIDE 3D HAND Object
				//--width
				//--length
				//--thumb
				//--fingerlist
				//-- handednes / left /right :uint 0-left 1-right 2-bimanual
				//-- orientation vector :Vector3D
				//-- orintationAngle 
				//-- thumb id/x/yz
				//-- hand finger list id/x/y/z
				//-- fingers id :int
				//-- mean finger velocity :Vector3D
				//-- mean finger acceleration :Vector3D
				//-- palm radius :Number
				//-- palm center :Vector3D
				//-- palm velocity :Vector3D
		
		/// 
		// thumbID ------------------ FOR 2D STUFF (NEEDS TO MOVE TO 2D HAND OBJECT)
		private var _thumbID:int = 0;
		public function get thumbID():int{return _thumbID;}
		public function set thumbID(value:int):void { _thumbID = value; }
		// orientationAngle---------------------
		private var _orientation:Number = 0;
		public function get orientation():Number{return _orientation;}
		public function set orientation(value:Number):void{_orientation = value;}
		// orient_dx---------------------
		private var _orient_dx:Number = 0;
		public function get orient_dx():Number{return _orient_dx;}
		public function set orient_dx(value:Number):void{_orient_dx = value;}
		// orient_dy---------------------
		private var _orient_dy:Number = 0;
		public function get orient_dy():Number {	return _orient_dy; }
		public function set orient_dy(value:Number):void { _orient_dy = value; }
		// orient_dz---------------------
		private var _orient_dz:Number = 0;
		public function get orient_dz():Number {	return _orient_dz; }
		public function set orient_dz(value:Number):void { _orient_dz = value; }
		
		// private var _holdPoint:Vector3D = new Vector3D(); 
		// hold_x---------------------//remove
		private var _hold_x:Number = 0;
		public function get hold_x():Number{return _hold_x;}
		public function set hold_x(value:Number):void{_hold_x = value;}
		// hold_y---------------------remove
		private var _hold_y:Number = 0;
		public function get hold_y():Number{return _hold_y;}
		public function set hold_y(value:Number):void{_hold_y = value;}
		// hold_z---------------------remove
		private var _hold_z:Number = 0;
		public function get hold_z():Number{return _hold_z;}
		public function set hold_z(value:Number):void{_hold_z = value;}
		// c_locked---------------------remove
		private var _hold_n:int = 0;
		public function get hold_n():int{return _hold_n;}
		public function set hold_n(value:int):void{_hold_n = value;}
		
	
		
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////
		// refactor out ----------------------------------------------------------------------------------------------
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
		
		///////////////////////////////////////////////
		// CLUSTER EVENT LOGIC
		///////////////////////////////////////////////
		
		// add point
		private var _point_add:Boolean = false;
		public function get point_add():Boolean{return _point_add;}
		public function set point_add(value:Boolean):void{_point_add = value;}
		// remove point
		private var _point_remove:Boolean = false;
		public function get point_remove():Boolean{return _point_remove;}
		public function set point_remove(value:Boolean):void{_point_remove = value;}
		// add cluster
		private var _add:Boolean = false;
		public function get add():Boolean{return _add;}
		public function set add(value:Boolean):void{_add = value;}
		// remove cluster
		private var _remove:Boolean = false;
		public function get remove():Boolean{return _remove;}
		public function set remove(value:Boolean):void{_remove = value;}
		

		/////////////////////////////////////////////////////////////////////////
		//default cluster level RAW data structures
		/////////////////////////////////////////////////////////////////////////
		// surface point data list----------------
		private var _pointArray:Vector.<PointObject> = new Vector.<PointObject>();
		public function get pointArray():Vector.<PointObject>{return _pointArray;}
		public function set pointArray(value:Vector.<PointObject>):void { _pointArray = value; }
		// motion point data list
		private var _motionArray:Vector.<MotionPointObject> = new Vector.<MotionPointObject>();
		public function get motionArray():Vector.<MotionPointObject>{return _motionArray;}
		public function set motionArray(value:Vector.<MotionPointObject>):void { _motionArray = value; }
		
		// motion point data list
		private var _motionArray2D:Vector.<MotionPointObject> = new Vector.<MotionPointObject>();
		public function get motionArray2D():Vector.<MotionPointObject>{return _motionArray2D;}
		public function set motionArray2D(value:Vector.<MotionPointObject>):void{_motionArray2D = value;}
		
		// sensor point data list----------------
		private var _sensorArray:Vector.<Number> = new Vector.<Number>();//<SensorPointObject>();
		public function get sensorArray():Vector.<Number>{return _sensorArray;}
		public function set sensorArray(value:Vector.<Number>):void { _sensorArray = value; }
		
		
		/////////////////////////////////////////////////////////////////////////////
		// cluster Interaction Point list
		/////////////////////////////////////////////////////////////////////////////
		// DERIVED POINT LIST BASED ON PRIMARY INTERACTION CRITERIA
		// GENERATED FROM PRIMARY CLUSTER ANALYSIS FROM RAW POINT DATA
		// CLASIFIED BY TYPE INTO SINGLE LIST
		// type // PINCH POINT // TAP POINT// HOLD POINT // TRIGGER POINT // PALM POINT
		private var _iPointArray:Vector.<InteractionPointObject> = new Vector.<InteractionPointObject>();
		public function get iPointArray():Vector.<InteractionPointObject>{ return _iPointArray;}
		public function set iPointArray(value:Vector.<InteractionPointObject>):void	{ _iPointArray = value; }
		
		private var _iPointArray2D:Vector.<InteractionPointObject> = new Vector.<InteractionPointObject>();
		public function get iPointArray2D():Vector.<InteractionPointObject>{ return _iPointArray2D;}
		public function set iPointArray2D(value:Vector.<InteractionPointObject>):void	{_iPointArray2D = value;}
		
		
		
		
		////////////////////////////////////////
		//1 DEFINE A SET OF INTERACTION POINTS
		//2 MATCH TO INTERACTION POINT HAND CONFIG (GEOMETRIC)
		//3 HIT TEST QUALIFIED TO TARGET
		//4 ANALYZE RELATIVE INTERACTION POINT CHANGES AND PROPERTIES 
		//5 MATCH MOTION (KINEMETRIC)
		//6 PUSH GESTURE POINT
		//7 PROCESS GESTURE POINT FILTERS
		//8 APPLY INTERNAL NATIVE TRANSFORMS
		//9 ADD TO TIMELINE
		//10 DISPTACH GESTURE EVENT
		////////////////////////////////////////
			
		//E.G BIMANUAL HOLD & MANIPULATE
			//FIND HOLD POINT LIST
			//FIND MANIP POINT LIST 
			// FIND AVERAGE HOLD POINT XY FIND HOLD TIME
			// FIND DRAG,SCALE,ROTATE
			// UPDATE PARENT CLUSTER WITH DELTAS
			// UPDATE GESTURE PIPELINE
			
		///////////////////////////////////////////////////////////////////////////////////
		// GESTURE POINTS
		private var _gPointArray:Vector.<GesturePointObject> = new Vector.<GesturePointObject>();
		public function get gPointArray():Vector.<GesturePointObject>{ return _gPointArray;}
		public function set gPointArray(value:Vector.<GesturePointObject>):void	{_gPointArray = value;}
		
	
		/////////////////////////////////////////////////////////////////////////
		// cluster history
		/////////////////////////////////////////////////////////////////////////
		private var _history:Vector.<ClusterObject> = new Vector.<ClusterObject>();
		public function get history():Vector.<ClusterObject>{return _history;}
		public function set history(value:Vector.<ClusterObject>):void{_history = value;}
	}
}