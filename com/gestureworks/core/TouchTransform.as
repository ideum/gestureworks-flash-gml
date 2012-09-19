﻿////////////////////////////////////////////////////////////////////////////////
//
//  IDEUM
//  Copyright 2011-2012 Ideum
//  All Rights Reserved.
//
//  GestureWorks
//
//  File:    .as
//  Authors:  Ideum
//             
//  NOTICE: Ideum permits you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////
package com.gestureworks.core
{
	//import flash.display.DisplayObject;
	import flash.geom.Point;
	import flash.geom.Matrix;
	import flash.geom.Transform;
	
	//import flash.geom.* ;
	//import flash.geom.Matrix3D;
	//import flash.geom.Vector3D;
	//import flash.geom.PerspectiveProjection;
	//import flash.filters.ColorMatrixFilter;
	
	import com.gestureworks.events.GWTransformEvent;
	import com.gestureworks.events.GWEvent;
	
	//import com.gestureworks.objects.ClusterObject;
	//import com.gestureworks.objects.GestureObject;
	import com.gestureworks.objects.TimelineObject;
	import com.gestureworks.objects.TransformObject;
	
	import flash.display.StageDisplayState;
	
	public class TouchTransform //extends DisplayObject //TouchSpriteBase//TouchSpriteGesture
	{
		// private
		private static const RAD_DEG:Number = 180 / Math.PI;
		private static const DEG_RAD:Number = Math.PI / 180 ;
		public var affine_modifier:Matrix;
		//private var affine_modifier3D:Matrix3D;
		public var parent_modifier:Matrix;
	
		// private //local merged display object properties
		/*
		private var _x:Number = 0;
		private var _y:Number = 0;
		private var _scaleX:Number = 1;
		private var _scaleY:Number = 1;
		private var _rotation:Number = 0;
		private var _width:Number = 0;
		private var _height:Number = 0;
		*/
		private var t_x:Number = 0;
		private var t_y:Number =  0;
		
		// 3d
		private var _rotationX:Number = 0;
		private var _rotationY:Number = 0;
		private var _rotationZ:Number = 0;
		
		// private	// differentials
		private var dx:Number = 0;
		private var dy:Number =  0;
		private var ds:Number = 0;
		private var dsx:Number =  0;
		private var dsy:Number =  0;
		private var dtheta:Number =  0;
		
		// 3d
		//private var dthetaX:Number =  0;
		//private var dthetaY:Number =  0;
		//private var dthetaZ:Number =  0;
		
		//private var transform_3d:Boolean = true;
		
		private var centerTransform:Boolean = false;
		
		private var ts:Object;
		//private var gO:GestureObject;
		//private var cO:ClusterObject
		private var tiO:TimelineObject
		private var trO:TransformObject;
		
		private var id:int;
		
		public function TouchTransform(touchObjectID:int):void
		{
            //super();
			id = touchObjectID;
			ts = GestureGlobals.gw_public::touchObjects[id];
			//cO = ts.cO;
			trO = ts.trO;
			
			initTransform();
          }
		  
		// initializers    
         public function initTransform():void 
         {
			//if(trace_debug_mode) trace("create touchsprite transform");
			affine_modifier = new Matrix();// init display object transformation operator
			
			//affine_modifier3D = new Matrix3D()
			
			trO.transformPointsOn = true;
			pre_InitTransformPoints();
			
			
		}
		/**
		* @private
		*/
		// update local properties
		public function updateLocalProperties():void
		{
			//_x = super.x;
			//_y = super.y;
			//_scaleX = super.scaleX;
			//_scaleY = super.scaleY;//0.5;
			//_rotation = super.rotation//45;	
			//_width = super.width;
			//_height = super.height;
			
			ts.__x = ts.x;
			ts.__y = ts.y;
			ts.__scaleX = ts.scaleX;
			ts.__scaleY = ts.scaleY;//0.5;
			ts.__rotation = ts.rotation//45;	
			ts.__width = ts.width;
			ts.__height = ts.height;
			
			//3d
			//_rotationX = super.rotationX;
			//_rotationY = super.rotationY;
			//_rotationZ = super.rotationZ;
			
			
			// update transform object properties
			if (trO.transAffinePoints)
			{
				trO.obj_x = trO.transAffinePoints[4].x//_x
				trO.obj_y = trO.transAffinePoints[4].y//_y	
			}
			trO.obj_scaleX = ts.__scaleX;
			trO.obj_scaleY = ts.__scaleY;
			trO.obj_rotation = ts.__rotation;
			trO.obj_width = ts.__width;
			trO.obj_height = ts.__height;
			
			//trO.obj_rotationX = _rotationX;
			//trO.obj_rotationY = _rotationY;
			//trO.obj_rotationZ = _rotationZ;
		}

	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	// managers
	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	/**
	* @private
	*/
	public function updateTransformation():void 
	{
		transformManager();
		updateLocalProperties();
	}
	/**
	* @private
	*/
	public function transformManager():void 
	{
		//if (trace_debug_mode) trace("touch object transform");
				
				if (ts.N != 0)
				{
					if (!trO.init_center_point) initTransformPoints();
					
					centerTransform = false;
					
					if (ts.disableNativeTransform){
						if (!ts.disableAffineTransform) $applyTransform(true);
					}
					else applyNativeTransform(true);
					
					ts.transformComplete = false;
					ts.transformStart = true;
					if (ts.transformEvents) manageTransformEventDispatch();
					//if (ts.trace_debug_mode)trace("update", ts.touchObjectID)
				}
				
				else if ((ts.N == 0) && (ts.gestureTweenOn) && (ts.gestureReleaseInertia)) 
				{
					centerTransform = true;
					
					if (ts.disableNativeTransform) {
						if (!ts.disableAffineTransform) $applyTransform(true);	//false
					}
					else applyNativeTransform(true); // false
					
					ts.transformComplete = false;
					ts.transformStart = false;
					if (ts.transformEvents) manageTransformEventDispatch();
					//if (ts.trace_debug_mode)trace("inertia", ts.touchObjectID)
				}
				
				else if ((ts.N == 0) && (!ts.gestureTweenOn)&&(!ts.transformComplete)) 
				{
					ts.transformComplete = true;
					ts.transformStart = false;
					if (ts.transformEvents) manageTransformEventDispatch();
					//if (ts.trace_debug_mode)trace("none", ts.touchObjectID)
				}
				
				
	}
		
	////////////////////////////////////////////////////////////////////////////////
	// transforma propeties using native gml values
	////////////////////////////////////////////////////////////////////////////////
	/**
	* @private
	*/
	private function applyNativeTransform(affine:Boolean):void
		{
			///////////////////////////////////////////////////////////////////////////////////
			if (ts.nestedTransform)
			{
				// pre transfrom to compensate for parent transform
				//trace("parent transfrom", this.parent.transform.matrix);
				//trace(this.parent, this.parent.parent)	
				//var grand_parent_mod = this.parent.parent.transform.matrix.clone();
				//parent_modifier = this.transform.concatenatedMatrix.clone();//this.parent.transform.matrix.clone();
				//parent_modifier = transform.matrix.clone();//this.parent.transform.matrix.clone();
				//parent_modifier = this.parent.transform.matrix.clone();
				
				////////////////////////////////////////////////////////////////////////////////
				// gives root cocatenated transfrom
				//parent_modifier = this.transform.concatenatedMatrix.clone();
				
				// will give angle of rotation
				//angle = Math.acos(parent_modifier.a/parent_modifier.d)
				
				// gives scale
				//scalex = parent_modifier.a/Math.cos(angle)
				//scaley = parent_modifier.a/Math.cos(angle)
				///////////////////////////////////////////////////////////////////////////////
				
				//parent_modifier = parent.transform.matrix.clone();
				parent_modifier = ts.parent.transform.matrix.clone();
					//parent_modifier.concat(grand_parent_mod)
					parent_modifier.invert();
				var pt:Point //= parent_modifier.transformPoint(new Point(trO.x, trO.y));
				
				if (!centerTransform) pt = parent_modifier.transformPoint(new Point(trO.x, trO.y));
				else pt = new Point( trO.transAffinePoints[4].x,trO.transAffinePoints[4].y);
				
				
				var vector_mod:Matrix = new Matrix ();
				//var vdr:Number = -(this.parent.rotation)* DEG_RAD//+ this.parent.parent.rotation)* DEG_RAD
				//var vdsx:Number = 1 / (this.parent.scaleX)//*this.parent.parent.scaleX)
				//var vdsy:Number = 1 / (this.parent.scaleY)//*this.parent.parent.scaleY)
				var vdr:Number = -(ts.parent.rotation)* DEG_RAD//+ this.parent.parent.rotation)* DEG_RAD
				var vdsx:Number = 1 / (ts.parent.scaleX)//*this.parent.parent.scaleX)
				var vdsy:Number = 1 / (ts.parent.scaleY)//*this.parent.parent.scaleY)
				
					vector_mod.rotate(vdr);
					vector_mod.scale(vdsx ,vdsy);
				var tpt:Point = vector_mod.transformPoint(new Point(trO.dx, trO.dy));
			
					// translate center of transformation
					t_x =  pt.x;
					t_y =  pt.y;
					// rotate translation vector
					dx =   tpt.x;
					dy =   tpt.y;
			}
			else {	
					// do not pre transform
					if (centerTransform) 
					{
						t_x = trO.transAffinePoints[4].x
						t_y = trO.transAffinePoints[4].y
					}
					else {
						t_x = trO.x;
						t_y = trO.y;
					}
					dx =   trO.dx;
					dy =   trO.dy;
			}
			///////////////////////////////////////////////////////////////////////////////////
			
				// leave scalar values untouched
				//ds =  trO.dsx;
				dsx =  trO.dsx;
				dsy =  trO.dsy;// trO.dsy;
				dtheta = trO.dtheta * DEG_RAD;
				
				//dthetaX = trO.dthetaX //* DEG_RAD;
				//dthetaY = trO.dthetaY //* DEG_RAD;
				//dthetaZ = trO.dthetaZ //* DEG_RAD;
				
				///////////////////////////////////////////////////////////////////////////////////
				// 3d test
				///////////////////////////////////////////////////////////////////////////////////
				
				/*
				trace(t_x,t_y,dx,dy,dtheta,dsx,dsy,super.x,super.y);
				
				if (transform_3d) {
					
					
					//this.transform.perspectiveProjection = new PerspectiveProjection();
					//this.transform.perspectiveProjection.projectionCenter = new Point(trO.transAffinePoints[4].x, trO.transAffinePoints[4].y);
					//this.transform.perspectiveProjection.projectionCenter = new Point(0, 0);
					
					this.z = 0;
					
					var x_axis:Vector3D = new Vector3D(1,1,0);
					//trace(affine_modifier3D);
					
						affine_modifier3D = this.transform.matrix3D;
						
						trace(affine_modifier3D);
						trace(this.transform.perspectiveProjection);
						//affine_modifier3D.appendTranslation(-t_x+dx,-t_y+dy, 0)
						
						//affine_modifier3D.appendTranslation(-t_x,-t_y, 0)
						affine_modifier3D.appendRotation(dthetaX, x_axis);
						//affine_modifier3D.appendRotation(dthetaY, Vector3D.Y_AXIS);
						//affine_modifier3D.appendRotation(dthetaZ,Vector3D.Z_AXIS);
						//affine_modifier3D.appendScale(1 + dsx, 1 + dsy, 1);
						//affine_modifier3D.appendTranslation(t_x,t_y, 0)
					this.transform.matrix3D = affine_modifier3D
					//trace(this.perspectiveProjection.matrix3D
				}*/
				
				 if (affine) 
				 {
					//if (trace_debug_mode) trace("gesture affine transform",touchObjectID);
					//affine_modifier = this.transform.matrix;
					affine_modifier = ts.transform.matrix;
						affine_modifier.translate(-t_x+dx,-t_y+dy);
						affine_modifier.rotate(dtheta);
						affine_modifier.scale(1 + dsx, 1 + dsy);
						affine_modifier.translate(t_x, t_y);
					ts.transform.matrix = affine_modifier
					transformAffineDebugPoints();
				}
				else
				{
					///if (trace_debug_mode) trace("gesture tween non-affine transform",touchObjectID)
					//affine_modifier = this.transform.matrix;
						//affine_modifier.translate(-super.x,-super.y);
						//affine_modifier.rotate(dtheta);
						//affine_modifier.scale(1 + dsx, 1 + dsy);
						//affine_modifier.translate(super.x + dx, super.y + dy);
					//this.transform.matrix = affine_modifier
					affine_modifier = ts.transform.matrix;
						affine_modifier.translate(-ts.x,-ts.y);
						affine_modifier.rotate(dtheta);
						affine_modifier.scale(1 + dsx, 1 + dsy);
						affine_modifier.translate(ts.x + dx, ts.y + dy);
					ts.transform.matrix = affine_modifier
					transformAffineDebugPoints();
				}
				
				updateLocalProperties();
				
				//3d
				//this.rotationX += dthetaX;
				//this.rotationY += dthetaY;
				//this.rotationZ += dthetaZ;
			
		}
			 
		/////////////////////////////////////////////////////////////////////////
		// transform properties using $ values
		///////////////////////////////////////////////////////////////////////// 
		/**
		* @private
		*/
		public function $applyTransform(affine:Boolean):void
			{
				///////////////////////////////////////////////////////////////////////////////////
				if (ts.nestedTransform)
				{
					// pre transfrom to compensate for parent transforms
					//trace("parent transfrom", this.parent.transform.matrix);
					//parent_modifier = this.parent.transform.matrix.clone();
					parent_modifier = ts.parent.transform.matrix.clone();
						parent_modifier.invert();
						
					var $pt:Point = parent_modifier.transformPoint(new Point(trO.x, trO.y));
					
					var $r_mod:Matrix = new Matrix ();
						//$r_mod.rotate(-this.parent.rotation * DEG_RAD);
						//$r_mod.scale( 1 / this.parent.scaleX, 1 / this.parent.scaleY);
						
						$r_mod.rotate(-ts.parent.rotation * DEG_RAD);
						$r_mod.scale( 1 / ts.parent.scaleX, 1 / ts.parent.scaleY);
						
					//var $tpt:Point = $r_mod.transformPoint(new Point((_x - super.x), (_y - super.y)));
					var $tpt:Point = $r_mod.transformPoint(new Point((ts.__x - ts.x), (ts.__y - ts.y)));
				
						// translate center of transformation
						t_x =  $pt.x;
						t_y =  $pt.y;
						// rotate translation vector
						dx =   $tpt.x;
						dy =   $tpt.y;
				}
				else {	
						// do not pre transform // super override method
						
						if (centerTransform) {
							t_x = trO.transAffinePoints[4].x
							t_y = trO.transAffinePoints[4].y
						}
						else {
						t_x = trO.x;
						t_y = trO.y;
						}
						//dx = (_x - super.x);
						//dy = (_y - super.y);
						dx = (ts.__x - ts.x);
						dy = (ts.__y - ts.y);
				}
				///////////////////////////////////////////////////////////////////////////////////
				// leave scalar values untouched
				//ds = (_scaleX - super.scaleX);
				
				//dsx = (_scaleX - super.scaleX);
				dsx = (ts.__scaleX - ts.scaleX);
				dsy = dsx//(_scaleY - super.scaleY);
				
				//dtheta = (_rotation - super.rotation) * DEG_RAD;
				dtheta = (ts.__rotation - ts.rotation) * DEG_RAD;
				
			//	dthetaX = (_rotationX - super.rotationX) * DEG_RAD;
			//	dthetaY = (_rotationY - super.rotationY)* DEG_RAD;
			//	dthetaZ = (_rotationZ - super.rotationZ) * DEG_RAD;
				
				
				if (affine) 
				 {
					// if (trace_debug_mode) trace("trans $ affine",touchObjectID)
					//affine_modifier = this.transform.matrix;
					affine_modifier = ts.transform.matrix;
						affine_modifier.translate( - t_x, - t_y);
						affine_modifier.rotate(dtheta);
						affine_modifier.scale(1 + dsx, 1 + dsy);	
						affine_modifier.translate( dx + t_x, dy + t_y);
					//this.transform.matrix =  affine_modifier
					ts.transform.matrix =  affine_modifier
					transformAffineDebugPoints();
				 }
				 
				 else
				 {
					//if (trace_debug_mode) trace("tween trans $ non affine",touchObjectID)
					 affine_modifier = new Matrix;
						//affine_modifier.rotate(super.rotation* DEG_RAD + dtheta);
						//affine_modifier.scale(super.scaleX + ds, super.scaleY + ds);	
						//affine_modifier.translate( super.x + dx, super.y + dy);
					//this.transform.matrix =  affine_modifier
					affine_modifier.rotate(ts.rotation* DEG_RAD + dtheta);
						affine_modifier.scale(ts.scaleX + ds, ts.scaleY + ds);	
						affine_modifier.translate( ts.x + dx, ts.y + dy);
					ts.transform.matrix =  affine_modifier
					transformAffineDebugPoints();
				 }
				 
				 updateLocalProperties();
				 
				 // 3d
				 //rotationX += dthetaX;
				 //rotationY += dthetaY;
				// rotationZ += dthetaZ;
		}
		
		/////////////////////////////////////////////////////////////////////////////////////////////
		//
		/////////////////////////////////////////////////////////////////////////////////////////////
		
		/**
		* @private
		*/
		private function pre_InitTransformPoints():void
		{
			var points:Array = new Array();
				points[0] = new Point(0, 0);
				points[1] = new Point(0, 0);
				points[2] = new Point(0, 0);
				points[3] = new Point(0, 0);
				points[4] = new Point(0, 0);
				
			trO.affinePoints = points;	
			trO.transAffinePoints = points;
		}
		/**
		* @private
		*/
		private function initTransformPoints():void
		{
			
			if (trO.transformPointsOn)
				{	
				// takes the pre-transformed inial properties of the display object and seeds the debug points//317 ,241//250, 190
				//if(trace_debug_mode)trace("init center point", this.width,this.height);
				
				//var mem_modifier:Matrix = this.transform.matrix;
				var mem_modifier:Matrix = ts.transform.matrix;
				// revert initial transform
				//var _modifier:Matrix = this.transform.matrix;
						//_modifier.rotate(-this.rotation* DEG_RAD);
					//	_modifier.scale(1 / this.scaleX, 1 / this.scaleY);	
				//this.transform.matrix = _modifier
				
				var _modifier:Matrix = ts.transform.matrix;
						_modifier.rotate(-ts.rotation* DEG_RAD);
						_modifier.scale(1 / ts.scaleX, 1 / ts.scaleY);	
				ts.transform.matrix = _modifier
				
				// find orifinal width and height
				//trO.pre_init_width = this.width;
				//trO.pre_init_height = this.height;
				trO.pre_init_width = ts.width;
				trO.pre_init_height = ts.height;
				
				// revert back
				ts.transform.matrix = mem_modifier
				
				// create original point net
				var affine_points:Array = new Array();
					affine_points[0] = new Point(0, 0);
					affine_points[1] = new Point( trO.pre_init_width, trO.pre_init_height);
					affine_points[2] = new Point(trO.pre_init_width, 0);
					affine_points[3] = new Point(0,trO.pre_init_height);
					affine_points[4] = new Point( trO.pre_init_width / 2, trO.pre_init_height / 2); //center point
				trO.affinePoints = affine_points;
				trO.init_center_point = true;
			}
			
		}
		/**
		* @private
		*/
		private function transformAffineDebugPoints():void 
		{
			//trace("updating affine debug");
			
			if (trO.transformPointsOn)
				{	
					var modifier:Matrix = new Matrix();
					//var modifier:Matrix = this.transform.matrix;
					///////////////////////////////////////////////////////////////////////////////
					// DISAGREES WHEN TOUCHSPRITE NOT TOUCHMOVIECLIP
					// modifier = transform.concatenatedMatrix.clone()
					//////////////////////////////////////////////////////////////////////////////
					
					if (ts.nestedTransform) 
					{
						var invert_parent_modifier:Matrix = parent_modifier.clone();
						invert_parent_modifier.invert();
						
						modifier = affine_modifier.clone();
						modifier.concat(invert_parent_modifier);
					}
					else modifier = affine_modifier;
					
					
				// transform point net
				var trans_affine_points:Array = new Array();
					trans_affine_points[0] =  modifier.transformPoint(trO.affinePoints[0]);
					trans_affine_points[1] =  modifier.transformPoint(trO.affinePoints[1]);
					trans_affine_points[2] =  modifier.transformPoint(trO.affinePoints[2]);
					trans_affine_points[3] =  modifier.transformPoint(trO.affinePoints[3]);
					trans_affine_points[4] =  modifier.transformPoint(trO.affinePoints[4]); // trans formed center point
				trO.transAffinePoints = trans_affine_points;
				}
		}
		
		/**
		* @private
		*/
		private function manageTransformEventDispatch():void 
		{
			//if(trace_debug_mode) trace("transform event dispatch");
		
				if ((ts.transformStart) && (ts.transformEventStart)) {
					ts.dispatchEvent(new GWTransformEvent(GWTransformEvent.T_START,id));
					if((tiO.timelineOn)&&(tiO.transformEvents)) tiO.frame.transformEventArray.push(new GWTransformEvent(GWTransformEvent.T_START,id));
				}
				if ((ts.transformComplete) && (ts.transformEventComplete))  {
					ts.dispatchEvent(new GWTransformEvent(GWTransformEvent.T_COMPLETE,id));
					if((tiO.timelineOn)&&(tiO.transformEvents)) tiO.frame.transformEventArray.push(new GWTransformEvent(GWTransformEvent.T_COMPLETE,id));
				}
				
				if ((dx != 0) || (dy != 0) || (dsx != 0) || (dsy != 0) || (dtheta != 0)) {
					ts.dispatchEvent(new GWTransformEvent(GWTransformEvent.T_TRANSFORM, { dx:dx, dy:dy, dsx: dsx, dsy:dsy, dtheta:dtheta } ));
					if((tiO.timelineOn)&&(tiO.transformEvents)) tiO.frame.transformEventArray.push(new GWTransformEvent(GWTransformEvent.T_TRANSFORM, { dsx:dx, dy:dy, dsx: dsx, dsy:dsy, dtheta:dtheta }));
				}
				if ((dx != 0) || (dy != 0)) {
					ts.dispatchEvent(new GWTransformEvent(GWTransformEvent.T_TRANSLATE, { dx:dx, dy:dy } ));
					if((tiO.timelineOn)&&(tiO.transformEvents)) tiO.frame.transformEventArray.push(new GWTransformEvent(GWTransformEvent.T_TRANSLATE, { dx:dx, dy:dy } ));
				}
				if (dtheta != 0) {
					ts.dispatchEvent(new GWTransformEvent(GWTransformEvent.T_ROTATE, { dtheta:dtheta } ));
					if((tiO.timelineOn)&&(tiO.transformEvents)) tiO.frame.transformEventArray.push(new GWTransformEvent(GWTransformEvent.T_ROTATE, { dtheta:dtheta } ));
				}
				if ((dsx != 0) || (dsy != 0)) {
					ts.dispatchEvent(new GWTransformEvent(GWTransformEvent.T_SCALE, { dsx: dsx, dsy:dsy } ));
					if((tiO.timelineOn)&&(tiO.transformEvents)) tiO.frame.transformEventArray.push(new GWTransformEvent(GWTransformEvent.T_SCALE, { dsx: dsx, dsy:dsy } ));
				}
		}
	}
}