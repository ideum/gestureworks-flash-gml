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
	
		public var active:Boolean = false;
		// cluster type
		public var type:String;
		// cluster ip point mode type
		public var mode:String;
		
		public var point_add:Boolean = false;
		
		public var point_remove:Boolean = false;
		
		public var add:Boolean = false;
		
		public var remove:Boolean = false;
		// frame count
		public var count:int;
		
		///////////////////////////////////////
		// cluster properties//////////////////
		///////////////////////////////////////
		// number of points---------------------
		private var n:int = 0;
		// number of hands---------------------
		private var hn:int = 0;
		// number of fingers---------------------
		private var fn:int = 0;
		// number of touch points
		public var tpn:int = 0;
		// number of motion points
		public var mpn:int = 0;
		// number of sensor points
		public var spn:int = 0;
		// number of derived interactive points---------------------
		public var ipn:int = 0;
		public var ipnk:Number = 0;
		public var ipnk0:Number = 0;
		// CHANGE IN NUMBER OF INTERACTION POINTS
		public var dipn:int = 0;


		//radius ------------------
		public var radius:Number = 0;
		// size---------------------
		public var size:Vector3D //= new Vector3D(); //(width/height/length)as(x/y/z)
		// position---------------------
		public var position:Vector3D //= new Vector3D();
		// separation-----------------2d
		public var separation:Number = 0;
		// separation-----------------3d
		public var separation3D:Vector3D //= new Vector3D();
		// rotation--------------------2d
		public var rotation:Number = 0;
		// rotation--------------------3d
		public var rotation3D:Vector3D //= new Vector3D;
		public var rotationList:Vector.<Vector3D> = new Vector.<Vector3D>;

		//inst velocity//////////////////////////////////////////////dx,dy,dz
		public var velocity:Vector3D //= new Vector3D ();
		//inst acceleration//////////////////////////////////////////////ddx,ddy,ddz
		public var acceleration:Vector3D //= new Vector3D ();
		//inst jolt//////////////////////////////////////////////ddx,ddy,ddz
		public var jolt:Vector3D //= new Vector3D ();
	
		// position_delta
		// dx---------------------
		public var dx:Number = 0;
		// dy---------------------
		public var dy:Number = 0;
		// dz---------------------
		public var dz:Number = 0;
		
		// size_delta
		// size veloctiy
		// dw---------------------
		public var dw:Number = 0;
		// dh---------------------
		public var dh:Number = 0;
		// dr---------------------
		public var dr:Number = 0;

		//separation_delta
		// scale velocity
		// dsx---------------------
		public var ds:Number = 0;
		// dsx---------------------
		public var dsx:Number = 0;
		// dsy---------------------
		public var dsy:Number = 0;
		// dsz---------------------
		public var dsz:Number = 0;
		
		//rotation_delta
		//rotational velocity
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
		// 2d/3d hand surface profile / data structure
		///////////////////////////////////////////////////////////////////////////////
		// thumbID ------------------ FOR 2D STUFF (NEEDS TO MOVE TO 2D HAND OBJECT)
		public var thumbID:int = 0;
		//handednes-------------------- //left//right
		public var handednes:String = "none";
		// orientationAngle---------------------
		public var orientation:Number = 0;
		// orient_dx---------------------
		public var orient_dx:Number = 0;
		// orient_dy---------------------
		public var orient_dy:Number = 0;
		// orient_dz---------------------
		public var orient_dz:Number = 0;
		
		
	
		// public var holdPoint:Vector3D = new Vector3D(); 
		// hold_x---------------------//remove
		public var hold_x:Number = 0;
		// hold_y---------------------remove
		public var hold_y:Number = 0;
		// hold_z---------------------remove
		public var hold_z:Number = 0;
		// c_locked---------------------remove
		public var hold_n:int = 0;
		

		// cluster Interaction Point list
		public var iPointArray:Vector.<InteractionPointObject> = new Vector.<InteractionPointObject>();
		
		/**
		 * Reset attributes to initial values
		 */
		public function reset():void {
			active = true; // may need to be false
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
		//	dn=0;
			dipn = 0;
			count = 0;
			
			
			
			
			
			
			dr = 0;
			ds = 0;
			dtheta = 0;
			pivot_dtheta = 0;
			
			dx=0;
			dy=0;
			dz = 0;
			dw=0;
			dh = 0;
			dsx=0;
			dsy=0;
			dsz=0;
			dthetaX=0;
			dthetaY=0;
			dthetaZ=0;
			
			

			thumbID = 0;
			handednes = "none";
			orientation = 0;
			orient_dx = 0;
			orient_dy = 0;
			orient_dz = 0;
			hold_x = 0;
			hold_y = 0;
			hold_z = 0;
			hold_n = 0;		
			
			
			
			radius=0;
			size.setTo(0, 0, 0);
			position.setTo(0, 0, 0);
			separation = 0;
			separation3D.setTo(0, 0, 0);
			rotation=0;
			rotation3D.setTo(0, 0, 0);
			
			//direction.setTo(0,0,0);
			//scaleDelta.setTo(0,0,0);
			//rotationDelta.setTo(0,0,0);
			velocity.setTo(0,0,0);
			acceleration.setTo(0,0,0);
			jolt.setTo(0,0,0);
			iPointArray.length = 0;
		}

	}
}