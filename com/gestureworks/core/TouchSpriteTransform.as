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
	
	import flash.display.StageDisplayState;
	
	public class TouchSpriteTransform extends TouchSpriteGesture
	{
		// private
		private static const RAD_DEG:Number = 180 / Math.PI;
		private static const DEG_RAD:Number = Math.PI / 180 ;
		private var affine_modifier:Matrix;
		//private var affine_modifier3D:Matrix3D;
		private var parent_modifier:Matrix;
	
		// private //local merged display object properties
		private var _x:Number = 0;
		private var _y:Number = 0;
		private var _scaleX:Number = 1;
		private var _scaleY:Number = 1;
		private var _rotation:Number = 0;
		private var _width:Number = 0;
		private var _height:Number = 0;
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
		private var dthetaX:Number =  0;
		private var dthetaY:Number =  0;
		private var dthetaZ:Number =  0;
		
		private var transform_3d:Boolean = true;
		
		
		public function TouchSpriteTransform():void
		{
            super();
			initTransform();
          }
		  
		// initializers    
         public function initTransform():void 
         {
			if(trace_debug_mode) trace("create touchsprite transform");
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
			_x = super.x;
			_y = super.y;
			_scaleX = super.scaleX;
			_scaleY = super.scaleY;//0.5;
			_rotation = super.rotation//45;	
			_width = super.width;
			_height = super.height;
			
			//3d
			_rotationX = super.rotationX;
			_rotationY = super.rotationY;
			_rotationZ = super.rotationZ;
			
			
			// update transform object properties
			trO.obj_x = trO.transAffinePoints[4].x//_x
			trO.obj_y = trO.transAffinePoints[4].y//_y
			trO.obj_scaleX = _scaleX;
			trO.obj_scaleY = _scaleY;
			trO.obj_rotation = _rotation;
			trO.obj_width = _width;
			trO.obj_height = _height;
			
			trO.obj_rotationX = _rotationX;
			trO.obj_rotationY = _rotationY;
			trO.obj_rotationZ = _rotationZ;
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

				if (_N != 0)
				{
					if (!trO.init_center_point) initTransformPoints();
					
					////////////////////////
					restartGestureTween();
					///////////////////////
					
					if (_disableNativeTransform){
						if (!_disableAffineTransform) $applyTransform(true);
					}
					else applyNativeTransform(true);
					
					_transformComplete = false;
					_transformStart = true;
					if (_transformEvents) manageTransformEventDispatch();
					if (trace_debug_mode)trace("update", _touchObjectID)
				}
				else if ((_N == 0) && (_gestureTweenOn)&&(_gestureReleaseInertia)) 
				{
					//////////////////////////
					//updateGestureValues();
					//updateGesturePipeline();
					///////////////////////////
					
					if (_disableNativeTransform) {
						if (!_disableAffineTransform) $applyTransform(false);	
					}
					else applyNativeTransform(false);
					
					_transformComplete = false;
					_transformStart = false;
					if (_transformEvents) manageTransformEventDispatch();
					if (trace_debug_mode)trace("inertia", _touchObjectID)
				}
				
				else if ((_N == 0) && (!_gestureTweenOn)&&(!_transformComplete)) 
				{
					_transformComplete = true;
					_transformStart = false;
					if (_transformEvents) manageTransformEventDispatch();
					if (trace_debug_mode)trace("none", _touchObjectID)
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
			if (_nestedTransform)
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
				
				parent_modifier = parent.transform.matrix.clone();
					//parent_modifier.concat(grand_parent_mod)
					parent_modifier.invert();
				var pt:Point = parent_modifier.transformPoint(new Point(trO.x, trO.y));
				
				var vector_mod:Matrix = new Matrix ();
				var vdr:Number = -(this.parent.rotation)* DEG_RAD//+ this.parent.parent.rotation)* DEG_RAD
				var vdsx:Number = 1 / (this.parent.scaleX)//*this.parent.parent.scaleX)
				var vdsy:Number = 1 / (this.parent.scaleY)//*this.parent.parent.scaleY)
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
					t_x =  trO.x;
					t_y =  trO.y;
					dx =   trO.dx;
					dy =   trO.dy;
			}
			///////////////////////////////////////////////////////////////////////////////////
			
				// leave scalar values untouched
				//ds =  trO.dsx;
				dsx =  trO.dsx;
				dsy =  trO.dsx;// trO.dsy;
				dtheta = trO.dtheta * DEG_RAD;
				
				dthetaX = trO.dthetaX //* DEG_RAD;
				dthetaY = trO.dthetaY //* DEG_RAD;
				dthetaZ = trO.dthetaZ //* DEG_RAD;
				
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
					if (trace_debug_mode) trace("gesture affine transform",touchObjectID);
					affine_modifier = this.transform.matrix;
						affine_modifier.translate(-t_x+dx,-t_y+dy);
						affine_modifier.rotate(dtheta);
						affine_modifier.scale(1 + dsx, 1 + dsy);
						affine_modifier.translate(t_x, t_y);
					this.transform.matrix = affine_modifier
					transformAffineDebugPoints();
				}
				else
				{
					if (trace_debug_mode) trace("gesture tween non-affine transform",touchObjectID)
					affine_modifier = this.transform.matrix;
						affine_modifier.translate(-super.x,-super.y);
						affine_modifier.rotate(dtheta);
						affine_modifier.scale(1 + dsx, 1 + dsy);
						affine_modifier.translate(super.x + dx, super.y + dy);
					this.transform.matrix = affine_modifier
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
				if (_nestedTransform)
				{
					// pre transfrom to compensate for parent transforms
					//trace("parent transfrom", this.parent.transform.matrix);
					parent_modifier = this.parent.transform.matrix.clone();
						parent_modifier.invert();
					var $pt:Point = parent_modifier.transformPoint(new Point(trO.x, trO.y));
					
					var $r_mod:Matrix = new Matrix ();
						$r_mod.rotate(-this.parent.rotation * DEG_RAD);
						$r_mod.scale( 1 / this.parent.scaleX, 1 / this.parent.scaleY);
						
					var $tpt:Point = $r_mod.transformPoint(new Point((_x - super.x), (_y - super.y)));
				
						// translate center of transformation
						t_x =  $pt.x;
						t_y =  $pt.y;
						// rotate translation vector
						dx =   $tpt.x;
						dy =   $tpt.y;
				}
				else {	
						// do not pre transform // super override method
						t_x = trO.x;
						t_y = trO.y;
						dx = (_x - super.x);
						dy = (_y - super.y);
				}
				///////////////////////////////////////////////////////////////////////////////////
				// leave scalar values untouched
				//ds = (_scaleX - super.scaleX);
				
				dsx = (_scaleX - super.scaleX);
				dsy = dsx//(_scaleY - super.scaleY);
				
				dtheta = (_rotation - super.rotation) * DEG_RAD;
				
			//	dthetaX = (_rotationX - super.rotationX) * DEG_RAD;
			//	dthetaY = (_rotationY - super.rotationY)* DEG_RAD;
			//	dthetaZ = (_rotationZ - super.rotationZ) * DEG_RAD;
				
				
				if (affine) 
				 {
					 if (trace_debug_mode) trace("trans $ affine",touchObjectID)
					affine_modifier = this.transform.matrix;
						affine_modifier.translate( - t_x, - t_y);
						affine_modifier.rotate(dtheta);
						affine_modifier.scale(1 + dsx, 1 + dsy);	
						affine_modifier.translate( dx + t_x, dy + t_y);
					this.transform.matrix =  affine_modifier
					transformAffineDebugPoints();
				 }
				 
				 else
				 {
					if (trace_debug_mode) trace("tween trans $ non affine",touchObjectID)
					 affine_modifier = new Matrix;
						affine_modifier.rotate(super.rotation* DEG_RAD + dtheta);
						affine_modifier.scale(super.scaleX + ds, super.scaleY + ds);	
						affine_modifier.translate( super.x + dx, super.y + dy);
					this.transform.matrix =  affine_modifier
					transformAffineDebugPoints();
				 }
				 
				 updateLocalProperties();
				 
				 // 3d
				 //rotationX += dthetaX;
				 //rotationY += dthetaY;
				// rotationZ += dthetaZ;
		}
		
		/////////////////////////////////////////////////////////////
		// $ affine transform methods
		/////////////////////////////////////////////////////////////
		// x property
		public function get $x():Number {return _x;}
		public function set $x(value:Number):void
		{
			_x = value;
		}
		// y property
		public function get $y():Number {return _y;}
		public function set $y(value:Number):void
		{
			_y = value;
		}
		// rotation property
		public function get $rotation():Number{return _rotation;}
		public function set $rotation(value:Number):void
		{
			_rotation = value;
		}
		// scaleX property
		public function get $scaleX():Number {return _scaleX;}
		public function set $scaleX(value:Number):void
		{
			_scaleX = value;
		}
		// scaleY property
		public function get $scaleY():Number {return _scaleY;}	
		public function set $scaleY(value:Number):void
		{
			_scaleY = value;
		}
		// affine transform point 
		public function get $transformPoint():Point { return new Point(trO.x, trO.y);} 
		public function set $transformPoint(pt:Point):void
		{
			var tpt:Point = affine_modifier.transformPoint(pt);
				trO.x = tpt.x;
				trO.y = tpt.y;
		}
		
		
		// rotationX property
		public function get $rotationX():Number{return _rotationX;}
		public function set $rotationX(value:Number):void
		{
			_rotationX = value;
		}
		// rotationY property
		public function get $rotationY():Number{return _rotationY;}
		public function set $rotationY(value:Number):void
		{
			_rotationY = value;
		}
		// rotationZ property
		public function get $rotationZ():Number{return _rotationZ;}
		public function set $rotationZ(value:Number):void
		{
			_rotationZ = value;
		}
		
		
		
		
		/**
		* @private
		*/
		// nested transfrom 
		private var _nestedTransform:Boolean = false;
		
		public function get nestedTransform():Boolean { return _nestedTransform} 
		public function set nestedTransform(value:Boolean):void
		{
			_nestedTransform = value
		}
		/**
		* @private
		*/
		private var _transformEvents:Boolean = false;
		/**
		* Determins whether transformEvents are processed and dispatched on the touchSprite.
		*/
		public function get transformEvents():Boolean{return _transformEvents;}
		public function set transformEvents(value:Boolean):void
		{
			_transformEvents=value;
		}
	
		/**
		* @private
		*/
		private var _transformComplete:Boolean = false;
		
		public function get transformComplete():Boolean { return _transformComplete; }	
		/**
		* @private
		*/
		private var _transformStart:Boolean = false;
		
		public function get transformStart():Boolean { return _transformStart; }
		
		
		/**
		* @private
		*/
		private var _transformEventStart:Boolean = true;
		
		public function get transformEventStart():Boolean{return _transformEventStart;}
		public function set transformEventStart(value:Boolean):void
		{
			_transformEventStart=value;
		}
		/**
		* @private
		*/
		private var _transformEventComplete:Boolean = true;
		
		public function get transformEventComplete():Boolean{return _transformEventComplete;}
		public function set transformEventComplete(value:Boolean):void
		{
			_transformEventComplete=value;
		}
		/**
		* @private
		*/
		// NOW SET TO TRUE BY DEFAULT FOR AS3 DEV 
		private var _disableNativeTransform:Boolean = true;
		/**
		* Determins whether transformations are handled internally (natively) on the touchSprite.
		*/
		public function get disableNativeTransform():Boolean{return _disableNativeTransform;}
		public function set disableNativeTransform(value:Boolean):void
		{
			_disableNativeTransform=value;
		}
		/**
		* @private
		*/
		// NOW SET TO TRUE BY DEFAULT FOR AS3 DEV 
		private var _disableAffineTransform:Boolean = true;
		/**
		* Determins whether internal (native) transformations are affine (dynamically centered) on the touchSprite.
		*/
		public function get disableAffineTransform():Boolean{return _disableAffineTransform;}
		public function set disableAffineTransform(value:Boolean):void
		{
			_disableAffineTransform=value;
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
				if(trace_debug_mode)trace("init center point", this.width,this.height);
				
				var mem_modifier:Matrix = this.transform.matrix;
				
				// revert initial transform
				var _modifier:Matrix = this.transform.matrix;
						_modifier.rotate(-this.rotation* DEG_RAD);
						_modifier.scale(1 / this.scaleX, 1 / this.scaleY);	
				this.transform.matrix = _modifier
				
				// find orifinal width and height
				trO.pre_init_width = this.width;
				trO.pre_init_height = this.height;
				
				// revert back
				this.transform.matrix = mem_modifier
				
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
					
					if (nestedTransform) 
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
					trans_affine_points[4] =  modifier.transformPoint(trO.affinePoints[4]);
				trO.transAffinePoints = trans_affine_points;
				}
		}
		
		/**
		* @private
		*/
		private function manageTransformEventDispatch():void 
		{
			if(trace_debug_mode) trace("transform event dispatch");
		
				if ((_transformStart) && (_transformEventStart)) {
					dispatchEvent(new GWTransformEvent(GWTransformEvent.T_START,touchObjectID));
					if((tiO.timelineOn)&&(tiO.transformEvents)) tiO.frame.transformEventArray.push(new GWTransformEvent(GWTransformEvent.T_START,touchObjectID));
				}
				if ((_transformComplete) && (_transformEventComplete))  {
					dispatchEvent(new GWTransformEvent(GWTransformEvent.T_COMPLETE,touchObjectID));
					if((tiO.timelineOn)&&(tiO.transformEvents)) tiO.frame.transformEventArray.push(new GWTransformEvent(GWTransformEvent.T_COMPLETE,touchObjectID));
				}
				
				if ((dx != 0) || (dy != 0) || (dsx != 0) || (dsy != 0) || (dtheta != 0)) {
					dispatchEvent(new GWTransformEvent(GWTransformEvent.T_TRANSFORM, { dx:dx, dy:dy, dsx: dsx, dsy:dsy, dtheta:dtheta } ));
					if((tiO.timelineOn)&&(tiO.transformEvents)) tiO.frame.transformEventArray.push(new GWTransformEvent(GWTransformEvent.T_TRANSFORM, { dsx:dx, dy:dy, dsx: dsx, dsy:dsy, dtheta:dtheta }));
				}
				if ((dx != 0) || (dy != 0)) {
					dispatchEvent(new GWTransformEvent(GWTransformEvent.T_TRANSLATE, { dx:dx, dy:dy } ));
					if((tiO.timelineOn)&&(tiO.transformEvents)) tiO.frame.transformEventArray.push(new GWTransformEvent(GWTransformEvent.T_TRANSLATE, { dx:dx, dy:dy } ));
				}
				if (dtheta != 0) {
					dispatchEvent(new GWTransformEvent(GWTransformEvent.T_ROTATE, { dtheta:dtheta } ));
					if((tiO.timelineOn)&&(tiO.transformEvents)) tiO.frame.transformEventArray.push(new GWTransformEvent(GWTransformEvent.T_ROTATE, { dtheta:dtheta } ));
				}
				if ((dsx != 0) || (dsy != 0)) {
					dispatchEvent(new GWTransformEvent(GWTransformEvent.T_SCALE, { dsx: dsx, dsy:dsy } ));
					if((tiO.timelineOn)&&(tiO.transformEvents)) tiO.frame.transformEventArray.push(new GWTransformEvent(GWTransformEvent.T_SCALE, { dsx: dsx, dsy:dsy } ));
				}
		}
	}
}