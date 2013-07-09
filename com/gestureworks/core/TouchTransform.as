////////////////////////////////////////////////////////////////////////////////
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
	import com.gestureworks.events.GWTransformEvent;
	import com.gestureworks.objects.TransformObject;
	import flash.geom.*;
	
	public class TouchTransform
	{
		// private
		private static const RAD_DEG:Number = 180 / Math.PI;
		private static const DEG_RAD:Number = Math.PI / 180 ;
		public var affine_modifier:Matrix;
		private var affine_modifier3D:Matrix3D;
		public var parent_modifier:Matrix;
		public var ref_frame_angle:Number = 0; 
	
		// private //local merged display object properties
		private var t_x:Number = 0;
		private var t_y:Number =  0;
		private var t_z:Number =  0;
		
		// private	// differentials
		private var dx:Number = 0;
		private var dy:Number =  0;
		private var dz:Number =  0;//3d--
		private var ds:Number = 0;
		private var dsx:Number =  0;
		private var dsy:Number =  0;
		private var dsz:Number =  0;//3d--
		private var dtheta:Number =  0;
		
		// 3d
		private var dthetaX:Number =  0;//3d--
		private var dthetaY:Number =  0;//3d--
		private var dthetaZ:Number =  0;//3d--
			
		private var centerTransform:Boolean = false;
		
		private var ts:Object;
		private var trO:TransformObject;
		private var id:int;
		
		private var focalLength:Number;
		private var ratio:Number;

		
		public function TouchTransform(touchObjectID:int):void
		{
            //super();
			id = touchObjectID;
			ts = GestureGlobals.gw_public::touchObjects[id];
			trO = ts.trO;
			
			initTransform();
        }
		 
		
		// initializers    
        public function initTransform():void 
        {
			//if(trace_debug_mode) trace("create touchsprite transform");
			affine_modifier = new Matrix();// init display object transformation operator
			
			affine_modifier3D = new Matrix3D()

			trO.transformPointsOn = true;
			pre_InitTransformPoints();
		}
		
		
		/**
		* @private
		*/
		// update local properties
		public function updateLocalProperties():void
		{
			ts._$x = ts.x;
			ts._$y = ts.y;
			ts._$z = ts.z;//3d--
			ts._$scaleX = ts.scaleX;
			ts._$scaleY = ts.scaleY;//0.5;
			ts._$rotation = ts.rotation//45;	
			ts._$width = ts.width;
			ts._$height = ts.height;
			
			//3d
			ts._$rotationX = ts.rotationX;//3d--
			ts._$rotationY = ts.rotationY;//3d--
			ts._$rotationZ = ts.rotationZ;//3d--
			
			// update transform object properties
			if (trO.transAffinePoints) {
				trO.obj_x = trO.transAffinePoints[4].x//_x
				trO.obj_y = trO.transAffinePoints[4].y//_y	
			}
			
			trO.obj_scaleX = ts._$scaleX;
			trO.obj_scaleY = ts._$scaleY;
			trO.obj_rotation = ts._$rotation;
			trO.obj_width = ts._$width;
			trO.obj_height = ts._$height;
			
			trO.obj_rotationX = ts._$rotationX;//3d--
			trO.obj_rotationY = ts._$rotationY;//3d--
			trO.obj_rotationZ = ts._$rotationZ;//3d-
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
	}
	/**
	* @private
	*/
	public function transformManager():void 
	{
		//if (trace_debug_mode) trace("touch object transform");
		
		// active point(s) transform
		if ((ts.N != 0)||(ts.cO.fn!=0))
		{
			if (!trO.init_center_point) 
				initTransformPoints();
			
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
		// release inertia transform
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
		// end transform
		else if ((ts.N == 0) && (!ts.gestureTweenOn)&&(!ts.transformComplete)) 
		{
			ts.transformComplete = true;
			ts.transformStart = false;
			if (ts.transformEvents) manageTransformEventDispatch();
			//if (ts.trace_debug_mode)trace("none", ts.touchObjectID)
		}		
	}
		
	////////////////////////////////////////////////////////////////////////////////
	// transforms properties using native gml values
	////////////////////////////////////////////////////////////////////////////////
	/**
	* @private
	*/
	private function applyNativeTransform(affine:Boolean):void
	{
		if ((ts.parent) && (ts.transformGestureVectors))
		//if (ts.parent)
			{
			//trace("native parent")
			// gives root cocatenated transfrom of parent space
			parent_modifier = ts.parent.transform.concatenatedMatrix.clone();
			parent_modifier.invert();

			var angle:Number = -(Math.atan(parent_modifier.c / parent_modifier.a))//Math.acos(parent_modifier.a)
			
			//var angle:Number = -calcAngle(parent_modifier.a , parent_modifier.c) * DEG_RAD;
			
			ref_frame_angle = angle;
			var scalex:Number = parent_modifier.a/Math.cos(angle)
			var scaley:Number = parent_modifier.a/Math.cos(angle)
			
			//TRANSFORM CENTER POINT OF TRANSFORMATION
			var pt:Point
			if (!centerTransform) 
				pt = parent_modifier.transformPoint(new Point(trO.x, trO.y));
			else 
				pt = new Point( trO.transAffinePoints[4].x,trO.transAffinePoints[4].y);
			
			
			// TRANSFORM TRANSFORMATION VECTOR
			var vector_mod:Matrix = new Matrix();
				vector_mod.rotate(angle);
				vector_mod.scale(scalex ,scaley);
			var tpt:Point = vector_mod.transformPoint(new Point(trO.dx, trO.dy));
			//trace(ag,parent_modifier.a,parent_modifier.b,parent_modifier.c,parent_modifier.d, vdr)
			
			// translate center of transformation
				t_x =  pt.x;
				t_y =  pt.y;
			// rotate translation vector
				dx =  tpt.x;
				dy =  tpt.y;
			}
			
			else {	
				//trace("native")
					// do not pre transform // super override method
					if (centerTransform) {
						t_x = trO.transAffinePoints[4].x
						t_y = trO.transAffinePoints[4].y
					}
					else {
						t_x = trO.x;
						t_y = trO.y;
					}
					dx = trO.dx;
					dy = trO.dy;
			}
			
			

			//var local_pt:Point = ts.globalToLocal(new Point(trO.x,trO.y));
				//trO.localx = local_pt.x;
				//trO.localy = local_pt.y;
			
			//var local_pt:Point = ts.globalToLocal(trO.x,trO.y);
				//trO.localx = local_pt.x;
				//trO.localy = local_pt.y;
				
			if(!ts.broadcastTarget){
				//trO.localx = trO.x-ts.x;
				//trO.localy = trO.y-ts.y;
				//trace("pad",trO.x,trO.y,trO.localx,trO.localy,ts.x,ts.y);
			}
				
				
			// broadcast center of trans
			else
			{
				t_x = trO.localx //+ ts.x;
				t_y = trO.localy //+ ts.y;
				//trace("target",trO.x,trO.y,trO.localx,trO.localy,ts.x,ts.y);
			}
			
			///////////////////////////////////////////////////////////////////////////////////
			// lock properties from transform
			if (ts.x_lock) { dx = 0 };
			if (ts.y_lock) { dy = 0 };
			
			// leave scalar values untouched
			dsx =  trO.dsx;
			dsy =  trO.dsy;// trO.dsy;
			//dsZ =  trO.dsz;// trO.dsy;
			
			
			// check for 3D
			if (ts.transform.matrix3D) {
				// 3D matrix uses degrees
				dtheta = trO.dtheta;
				
				// get the projection offset created by the z-position	
				if (ts.transform.perspectiveProjection) // ts can define location projection
					focalLength = ts.transform.perspectiveProjection.focalLength;
				else // use global projection from root
					focalLength = ts.root.transform.perspectiveProjection.focalLength;
				ratio = focalLength / (focalLength + ts.z);
				
				// modify transform
				if (affine) {
					affine_modifier3D = ts.transform.matrix3D.clone();
						affine_modifier3D.appendTranslation(-t_x, -t_y, 0);
						affine_modifier3D.appendRotation(dtheta, Vector3D.Z_AXIS); 	
						affine_modifier3D.appendScale(1 + dsx, 1 + dsy, 1); 		
						affine_modifier3D.appendTranslation(t_x + dx/ratio, t_y + dy/ratio, 0);
					ts.transform.matrix3D = affine_modifier3D;					
				}
				else {
					affine_modifier3D = ts.transform.matrix3D.clone();
						affine_modifier3D.appendTranslation(-ts.x, -ts.y, 0);
						affine_modifier3D.appendRotation(dtheta, Vector3D.Z_AXIS); 	
						affine_modifier3D.appendScale(1 + dsx, 1 + dsy, 1); 		
						affine_modifier3D.appendTranslation(ts.x + dx/ratio, ts.y + dy/ratio, 0);
					ts.transform.matrix3D = affine_modifier3D;
				}
			}
			// default to 2D
			else {
				// 2D matrix uses radians
				dtheta = trO.dtheta * DEG_RAD;
				
				if (affine) {
					affine_modifier = ts.transform.matrix;
						affine_modifier.translate(-t_x+dx,-t_y+dy);
						affine_modifier.rotate(dtheta);
						affine_modifier.scale(1 + dsx, 1 + dsy);
						affine_modifier.translate(t_x, t_y);
					ts.transform.matrix = affine_modifier;
					transformAffineDebugPoints();
				}
				else {
					affine_modifier = ts.transform.matrix;
						affine_modifier.translate(-ts.x,-ts.y);
						affine_modifier.rotate(dtheta);
						affine_modifier.scale(1 + dsx, 1 + dsy);
						affine_modifier.translate(ts.x + dx, ts.y + dy);
					ts.transform.matrix = affine_modifier;
					transformAffineDebugPoints();
				}
			}
			
			updateLocalProperties();
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
				if ((ts.parent)&&(ts.transformGestureVectors))
				//if (ts.parent)
				{
					//trace("$transform parent")
					// pre transfrom to compensate for parent transforms
					parent_modifier = ts.parent.transform.concatenatedMatrix.clone();
					parent_modifier.invert();
					
					//var $angle:Number = -(Math.atan(parent_modifier.c / parent_modifier.a))//Math.acos(parent_modifier.a)
					var $angle:Number = calcAngle(parent_modifier.a , parent_modifier.c) * DEG_RAD;
					
					
					ref_frame_angle = $angle;
					var $scalex:Number = parent_modifier.a/Math.cos($angle)
					var $scaley:Number = parent_modifier.a/Math.cos($angle)
					
					// TRANSFORM AFFINE POINT
					var $pt:Point;
					if (!centerTransform) $pt = parent_modifier.transformPoint(new Point(trO.x, trO.y));
					else $pt = new Point( trO.transAffinePoints[4].x,trO.transAffinePoints[4].y);
					
					// TRANSFORM VECTOR
					var $r_mod:Matrix = new Matrix ();
						$r_mod.rotate($angle);
						$r_mod.scale($scalex ,$scaley);
					var $tpt:Point = $r_mod.transformPoint(new Point((ts._$x - ts.x), (ts._$y - ts.y)));
				
						// translate center of transformation
						t_x =  $pt.x;
						t_y =  $pt.y;
						// rotate translation vector
						dx =   $tpt.x;
						dy =   $tpt.y;
				}
				else {	
					//trace("$transform")
						// do not pre transform // super override method
						if (centerTransform) {
							t_x = trO.transAffinePoints[4].x
							t_y = trO.transAffinePoints[4].y
						}
						else {
						t_x = trO.x;
						t_y = trO.y;
						}
						dx = (ts._$x - ts.x);
						dy = (ts._$y - ts.y);
				}
				
				
				//////////////////////////////////////////////////
				// property transform lock
				if (ts.x_lock) { dx = 0 };
				if (ts.y_lock) { dy = 0 };
				
				///////////////////////////////////////////////////////////////////////////////////
				// leave scalar values untouched
				dsx = (ts._$scaleX - ts.scaleX);
				dsy = (ts._$scaleY - ts.scaleY);//dsx
				dtheta = (ts._$rotation - ts.rotation) * DEG_RAD;
				
				dthetaX = (ts._$rotationX - ts.rotationX) * DEG_RAD;//3d--
				dthetaY = (ts._$rotationY - ts.rotationY) * DEG_RAD;//3d--
				dthetaZ = (ts._$rotationZ - ts.rotationZ) * DEG_RAD;//3d--
				
				//trace(ts.x, ts.y,trO.x, trO.y,ts.__x, ts.__y,t_x,t_y)
				
				//////////////////////////////////////////////////////
				// 3d
				if (ts.transform.matrix3D) // check for 3D transform matrix, only enabled if user sets 3D properties 
				{
					ts.rotationX += dthetaX;//3d--
					ts.rotationY += dthetaY;//3d--
					ts.rotationZ += dthetaZ;//3d--
				}
			
				//////////////////////////////////////////////////////
				// 2d
				if (affine) 
				 {
					//trace("$transforming");
					// if (trace_debug_mode) 
					//trace("trans $ affine")
					affine_modifier = ts.transform.matrix;
						affine_modifier.translate( - t_x, - t_y);
						affine_modifier.rotate(dtheta);
						affine_modifier.scale(1 + dsx, 1 + dsy);	
						affine_modifier.translate( dx + t_x, dy + t_y);
					ts.transform.matrix =  affine_modifier
					transformAffineDebugPoints();
				 }
				 
				 else
				 {
					//if (trace_debug_mode) 
					//trace("tween trans $ non affine")
					affine_modifier = new Matrix;
					affine_modifier.rotate(ts.rotation* DEG_RAD + dtheta);
						affine_modifier.scale(ts.scaleX + ds, ts.scaleY + ds);	
						affine_modifier.translate( ts.x + dx, ts.y + dy);
					ts.transform.matrix =  affine_modifier
					transformAffineDebugPoints();
				 }
				 
				 updateLocalProperties();
				 
				 
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
				
				// check for 3D transform matrix, only enabled if user sets 3D properties
				if (ts.transform.matrix3D) { 
					var original:Matrix3D = ts.transform.matrix3D.clone();
					
					affine_modifier3D = ts.transform.matrix3D.clone();
						affine_modifier3D.appendRotation(-ts.rotation, Vector3D.Z_AXIS); 	
						affine_modifier3D.appendScale(1 / ts.scaleX, 1 / ts.scaleY, 1);		
					ts.transform.matrix3D = affine_modifier3D;
					
					trO.pre_init_width = ts.width;
					trO.pre_init_height = ts.height;
					
					// revert back
					ts.transform.matrix3D = original;
				}	
				// default to 2D
				else {	
					var mem_modifier:Matrix = ts.transform.matrix;
					var _modifier:Matrix = ts.transform.matrix;
							_modifier.rotate(-ts.rotation* DEG_RAD);
							_modifier.scale(1 / ts.scaleX, 1 / ts.scaleY);	
					ts.transform.matrix = _modifier
				
					trO.pre_init_width = ts.width;
					trO.pre_init_height = ts.height;
				
					// revert back
					ts.transform.matrix = mem_modifier;
				}
				
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
					//var modifier:Matrix = new Matrix();
					//var modifier:Matrix = ts.transform.matrix;
					///////////////////////////////////////////////////////////////////////////////
					var modifier:Matrix = ts.transform.concatenatedMatrix.clone()
					//////////////////////////////////////////////////////////////////////////////
					/*
					if (ts.nestedTransform) 
					{
						var invert_parent_modifier:Matrix = parent_modifier.clone();
						invert_parent_modifier.invert();
						
						modifier = affine_modifier.clone();
						modifier.concat(invert_parent_modifier);
					}
					else modifier = affine_modifier;
					*/
					
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
					if((ts.tiO)&&(ts.tiO.timelineOn)&&(ts.tiO.transformEvents)) ts.tiO.frame.transformEventArray.push(new GWTransformEvent(GWTransformEvent.T_START,id));
				}
				if ((ts.transformComplete) && (ts.transformEventComplete))  {
					ts.dispatchEvent(new GWTransformEvent(GWTransformEvent.T_COMPLETE,id));
					if((ts.tiO)&&(ts.tiO.timelineOn)&&(ts.tiO.transformEvents)) ts.tiO.frame.transformEventArray.push(new GWTransformEvent(GWTransformEvent.T_COMPLETE,id));
				}
				
				if ((dx != 0) || (dy != 0) || (dsx != 0) || (dsy != 0) || (dtheta != 0)) {
					ts.dispatchEvent(new GWTransformEvent(GWTransformEvent.T_TRANSFORM, { dx:dx, dy:dy, dsx: dsx, dsy:dsy, dtheta:dtheta } ));
					if((ts.tiO)&&(ts.tiO.timelineOn)&&(ts.tiO.transformEvents)) ts.tiO.frame.transformEventArray.push(new GWTransformEvent(GWTransformEvent.T_TRANSFORM, { dsx:dx, dy:dy, dsx: dsx, dsy:dsy, dtheta:dtheta }));
				}
				if ((dx != 0) || (dy != 0)) {
					ts.dispatchEvent(new GWTransformEvent(GWTransformEvent.T_TRANSLATE, { dx:dx, dy:dy } ));
					if((ts.tiO)&&(ts.tiO.timelineOn)&&(ts.tiO.transformEvents)) ts.tiO.frame.transformEventArray.push(new GWTransformEvent(GWTransformEvent.T_TRANSLATE, { dx:dx, dy:dy } ));
				}
				if (dtheta != 0) {
					ts.dispatchEvent(new GWTransformEvent(GWTransformEvent.T_ROTATE, { dtheta:dtheta } ));
					if((ts.tiO)&&(ts.tiO.timelineOn)&&(ts.tiO.transformEvents)) ts.tiO.frame.transformEventArray.push(new GWTransformEvent(GWTransformEvent.T_ROTATE, { dtheta:dtheta } ));
				}
				if ((dsx != 0) || (dsy != 0)) {
					ts.dispatchEvent(new GWTransformEvent(GWTransformEvent.T_SCALE, { dsx: dsx, dsy:dsy } ));
					if((ts.tiO)&&(ts.tiO.timelineOn)&&(ts.tiO.transformEvents)) ts.tiO.frame.transformEventArray.push(new GWTransformEvent(GWTransformEvent.T_SCALE, { dsx: dsx, dsy:dsy } ));
				}
		}
		
		private static function calcAngle(adjacent:Number, opposite:Number):Number
			{
				if (adjacent == 0) return opposite < 0 ? 270 : 90 ;
				if (opposite == 0) return adjacent < 0 ? 180 : 0 ;
				
				if(opposite > 0) return adjacent > 0 ? 360 + Math.atan(opposite / adjacent) * RAD_DEG : 180 - Math.atan(opposite / -adjacent) * RAD_DEG ;
				else return adjacent > 0 ? 360 - Math.atan( -opposite / adjacent) * RAD_DEG : 180 + Math.atan( opposite / adjacent) * RAD_DEG ;
				
				//if(opposite > 0) return adjacent > 0 ? Math.atan(opposite / adjacent) * RAD_DEG : 180 - Math.atan(opposite / -adjacent) * RAD_DEG ;
				//else return adjacent > 0 ? 360 - Math.atan( -opposite / adjacent) * RAD_DEG : Math.atan( opposite / adjacent) * RAD_DEG ;
				
				return 0;
		}
	}
}