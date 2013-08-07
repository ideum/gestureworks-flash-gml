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
	
	public class ClusterObject extends Object 
	{
		// ID
		public var id:int;

		// cluster type
		public var type:String;

		
		///////////////////////////////////////
		// cluster properties//////////////////
		///////////////////////////////////////
		// number of points---------------------
		public var n:int;

		// number of hands---------------------
		public var hn:int;

		// number of fingers---------------------
		public var fn:int;

		// number of derived interactive points---------------------
		public var ipn:int;
		
		// CHANGE IN NUMBER OF TOUCH POINTS
		public var dn:int;
		
		// CHANGE IN NUMBER OF INTERACTION POINTS
		public var dipn:int;
		
		/////////////////////////////////
		// frame count
		public var count:int;

		// x---------------------
		public var x:Number;

		// y---------------------
		public var y:Number;

		// z---------------------
		public var z:Number;

		// width----------------------
		public var width:Number;

		// height---------------------
		public var height:Number;

		// length---------------------
		public var length:Number;

		// radius---------------------
		public var radius:Number;
		
		// separation------------------
		public var separation:Number;

		// separation------------------
		public var separationX:Number;

		// separationY------------------
		public var separationY:Number;

		// separationZ------------------
		public var separationZ:Number;
		
		// rotation---------------------
		public var rotation:Number;

		// rotationX---------------------
		public var rotationX:Number;

		// rotation---------------------
		public var rotationY:Number;

		// rotationZ---------------------
		public var rotationZ:Number;

		
		// mean position
		// mx---------------------
		public var mx:Number;

		// my---------------------
		public var my:Number;

		// mz---------------------
		public var mz:Number;
		
		/////////////////////////////////////////////////
		// velocities
		/////////////////////////////////////////////////
		// dx---------------------
		public var dx:Number;

		// dy---------------------
		public var dy:Number;

		// dz---------------------
		public var dz:Number;
		
		// size veloctiy
		// dw---------------------
		public var dw:Number;

		// dh---------------------
		public var dh:Number;

		// dr---------------------
		public var dr:Number;

		
		///////////////////////////////////////////////////////////////////////////////
		// scale velocity
		///////////////////////////////////////////////////////////////////////////////
		// dsx---------------------
		public var ds:Number;

		// dsx---------------------
		public var dsx:Number;

		// dsy---------------------
		public var dsy:Number;

		// dsz---------------------
		public var dsz:Number;

		
		///////////////////////////////////////////////////////////////////////////////
		//rotational velocity
		///////////////////////////////////////////////////////////////////////////////
		// dtheta ------------------
		public var dtheta:Number;

		// dthetax ------------------
		public var dthetaX:Number;

		// dthetay ------------------
		public var dthetaY:Number;

		// dthetaZ ------------------
		public var dthetaZ:Number;

		// pivot_dtheta ------------------
		public var pivot_dtheta:Number;

	
		///////////////////////////////////////////////////////////////////////////////
		//mean velocity
		///////////////////////////////////////////////////////////////////////////////
		// mdx---------------------
		public var mdx:Number;

		// mdy---------------------
		public var mdy:Number;

		// mdz---------------------
		public var mdz:Number;
		
		//////////////////////////////////////////////
		// accelerations
		//////////////////////////////////////////////
		// ddx ------------------
		public var ddx:Number;

		// ddy ------------------
		public var ddy:Number;

		// ddz ------------------
		public var ddz:Number;
		
		///////////////////////////////////////////////////////////////////////////////
		// rotational acceleration
		///////////////////////////////////////////////////////////////////////////////
		// ddtheta ------------------
		public var ddtheta:Number;
		
		////////////////////////////////////////////////////////////////////////////////
		// separation acceleration
		////////////////////////////////////////////////////////////////////////////////
		// ddsx ------------------
		public var ddsx:Number;

		// ddsy ------------------
		public var ddsy:Number;

		// ddsz ------------------
		public var ddsz:Number;

		// dds ------------------
		public var dds:Number;

		// dds3d ------------------
		public var dds3d:Number;

		
		///////////////////////////////////////////////////////////////////////////////
		// estimated total mean acceleration
		///////////////////////////////////////////////////////////////////////////////
		// etm_ddx ------------------
		public var etm_dx:Number;

		// etm ddy ------------------
		public var etm_dy:Number;

		// etm ddz ------------------
		public var etm_dz:Number;

		// etm_ddx ------------------
		public var etm_ddx:Number;

		// etm_ddy ------------------
		public var etm_ddy:Number;

		// etm_ddz ------------------
		public var etm_ddz:Number;
		
		
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
		
		// path_data
		// need to update to vector 
		//private var _path_data:Array = new Array();
		//public function get path_data():Array{return _path_data;}
		//public function set path_data(value:Array):void{_path_data = value;}	
		
		// 3Dpath_data
		//private var _path_data3d:Vector.<Vector3d> = new Vector.<Vector3d>();
		//public function get path_data3d():Vector.<Vector3d>{return _path_data3d;}
		//public function set path_data3d(value:Vector.<Vector3d>):void{_path_data3d = value;}
		
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
		
		
		// SUBCLUSTER INTERACTION POINT CLUSTERS TO BE MOVED INTO MATRIX
		private var _pinch_cO:ipClusterObject = new ipClusterObject ();
		public function get pinch_cO():ipClusterObject { return _pinch_cO;}
		public function set pinch_cO(value:ipClusterObject ):void	{ _pinch_cO = value; }
		
		private var _trigger_cO:ipClusterObject = new ipClusterObject ();
		public function get trigger_cO():ipClusterObject { return _trigger_cO;}
		public function set trigger_cO(value:ipClusterObject ):void	{ _trigger_cO = value; }
		
		private var _finger_cO:ipClusterObject = new ipClusterObject ();
		public function get finger_cO():ipClusterObject { return _finger_cO;}
		public function set finger_cO(value:ipClusterObject ):void	{ _finger_cO = value; }
		
		
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