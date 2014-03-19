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
	import com.gestureworks.objects.SensorPointObject;
	import flash.geom.Vector3D;
	import flash.utils.Dictionary;
	
	public class ClusterObject extends Object 
	{		
		// ID
		public var id:int;
		// cluster type
		public var type:String;

		// cluster properties//////////////////
		// number of points
		public var n:int = 0;
		// number of touch points
		public var tpn:int = 0;
		// number of motion points
		public var mpn:int = 0;
		//number of sensor points
		public var spn:int=0;
		
		
		// number of hands
		public var hn:int=0;
		// number of fingers
		public var fn:int=0;

		// number of derived interactive points
		public var ipn:int = 0;
		public var ipnk:Number = 0;
		public var ipnk0:Number = 0;
		// CHANGE IN NUMBER OF TOUCH POINTS
		public var dn:int=0;
		// CHANGE IN NUMBER OF INTERACTION POINTS
		public var dipn:int = 0;
		
		
		/////////////////////////////////
		// frame count
		public var count:int = 0;
		
		public var  point_add:Boolean = false;
		public var	point_remove:Boolean = false;
		public var	add:Boolean = false;
		public var	remove:Boolean = false;
		

		// size----------------------
		public var size:Vector3D;
		// radius---------------------
		public var radius:Number=0;

		//inst position//////////////////////////////////////////////x,y,z
		public var position:Vector3D //= new Vector3D ();
		//inst direction/orientation //////////////////////////////////////////////x,y,z
		//--public var direction:Vector3D //= new Vector3D ();
		//inst scale //////////////////////////////////////////////scaleX,scaleY,scaleZ
		//--public var scale:Vector3D //= new Vector3D ();
		//inst scale change //////////////////////////////////////////////rotationX,rotationY,rotationZ
		//--public var rotation:Vector3D = new Vector3D ();
		
		/////////////////////////////////////////////////////////////////////////////
		// DELTA PROPS
		//inst scale change//////////////////////////////////////////////dsx,dsy,dsz
		//public var scaleDelta:Vector3D //= new Vector3D ();
		//inst scale change //////////////////////////////////////////////dthetax,dthetay,dthetaz
		//public var rotationDelta:Vector3D //= new Vector3D ();
		//inst velocity//////////////////////////////////////////////dx,dy,dz
		//public var velocity:Vector3D //= new Vector3D ();
		//inst acceleration//////////////////////////////////////////////ddx,ddy,ddz
		//public var acceleration:Vector3D //= new Vector3D ();
		//inst jolt//////////////////////////////////////////////ddx,ddy,ddz
		//public var jolt:Vector3D //= new Vector3D ();
		

		// PRIME MULTIMODAL POINT ARRAY COPIED FROM CLOBAL REGISTERED CACHE
		public var mmPointArray:Array = new Array(); //USED FOR CLUSTER DIM ANALYSIS

		
//default cluster level RAW data structures////////////////////////////////////////////////////////////
		
		// surface point data list----------------
		public var touchArray:Vector.<TouchPointObject> //= new Vector.<TouchPointObject>();
		
		// motion point data list
		public var motionArray:Vector.<MotionPointObject> //= new Vector.<MotionPointObject>();
		
		// sensor point data list----------------
		public var sensorArray:Vector.<SensorPointObject> //= new Vector.<SensorPointObject>();
	
		// CLUSTER INTERACTION POINT LIST
		public var iPointArray:Vector.<InteractionPointObject> = new Vector.<InteractionPointObject>();

		//TOUCH OBJECT ARRAY A LIST OF TAGGING STRCTURES FOR 2D
		public var objectArray:Vector.<Object> //= new Vector.<Object>();
		
		// GESTURE POINTS
		public var gPointArray:Vector.<GesturePointObject> //= new Vector.<GesturePointObject>();
		
		//CURRENT INTERACTION POINT CLUSTER LIST REF
		public var iPointClusterList:Dictionary = new Dictionary();
		
		// CLUSTER HISTORY
		public var history:Vector.<ClusterObject> = new Vector.<ClusterObject>();
		
		/**
		 * Reset attributes to initial values
		 */
		public function reset():void {
			id = NaN;
			type = null;
			n = 0;
			tpn = 0;
			mpn = 0;
			spn=0;
			hn=0;
			fn=0;
			ipn = 0;
			ipnk = 0;
			ipnk0 = 0;
			dn=0;
			dipn = 0;
			count = 0;
			
			size.setTo(0,0,0);
			radius=0;		
			position.setTo(0,0,0);
			//direction.setTo(0,0,0);
			//scale.setTo(0,0,0);
			//scaleDelta.setTo(0,0,0);
			//rotationDelta.setTo(0,0,0);
			//velocity.setTo(0,0,0);
			//acceleration.setTo(0,0,0);
			//jolt.setTo(0,0,0);
			point_add = false;
			point_remove = false;
			add = false;
			remove = false;
			
			//mmPointArray.length = 0;
			//touchArray.length = 0;
			//motionArray.length = 0;
			//motionArray2D.length = 0;
			//sensorArray.length = 0;
			//iPointArray.length = 0;
			//iPointArray2D.length = 0;
			//tcO.reset();
			//tSubClusterArray.length = 0;
			//mcO.reset();
			//mSubClusterArray.length = 0;
			//scO.reset();
			//sSubClusterArray.length = 0;
			gPointArray.length = 0;
			history.length = 0;
		}
	}
}