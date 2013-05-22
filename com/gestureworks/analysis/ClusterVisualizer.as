﻿////////////////////////////////////////////////////////////////////////////////
//
//  IDEUM
//  Copyright 2011-2012 Ideum
//  All Rights Reserved.
//
//  GestureWorks
//
//  File:    DebugClusterCenter.as
//  Authors:  Ideum
//             
//  NOTICE: Ideum permits you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////
package com.gestureworks.analysis
{
	import flash.display.Shape;
	import flash.geom.Vector3D;
	
	import com.gestureworks.core.CML;
	import com.gestureworks.core.GestureGlobals;
	import com.gestureworks.core.gw_public;
	
	import com.gestureworks.objects.PointObject;
	import com.gestureworks.objects.MotionPointObject;
	import com.gestureworks.objects.ClusterObject;
	
	public class ClusterVisualizer extends Shape
	{
		private static const RAD_DEG:Number = 180 / Math.PI;
		
		private static var cml:XMLList;
		public var style:Object;
		private var cO:ClusterObject;
		private var pointList:Vector.<PointObject>;
		private var n:Number;
		private var id:Number = 0;

		
		private var _x:Number = 0;
		private var _y: Number = 0;
		private var _width:Number = 0;
		private var _height: Number = 0;
		private var x0:Number = 0;
		private var y0:Number = 0;
		
		// rotation
		private var _radius:Number = 200
		private var _rotation:Number = 0
		private var _orientation:Number = 0
		private var _dtheta:Number = 0
		private var _ds:Number = 0
		
		private var step:Number =  0
		private var percent:Number = 0
		private var r2:Number = 0
		private var r1:Number = 0
		private var sA:Number = 0
		private var eA:Number = 0
		private var numSteps:Number = 0
		
			
		public function ClusterVisualizer(touchObjectID:Number)
		{
			//trace("init cluster visualizer");
			id = touchObjectID;
			
			/////////////////////////////////////////////
			// set default style 
			/////////////////////////////////////////////

			style = new Object
				style.stroke_thickness = 4;
				style.stroke_color = 0xFFAE1F;
				style.stroke_alpha = 0.9;
				style.fill_color = 0xFFAE1F;
				style.fill_alpha = 0.9;
				style.radius = 20;
				
				// circle
				style.c_stroke_thickness = 16;
				style.c_stroke_alpha = 0.6;
				
				//web
				style.web_shape = "starweb";

				//orientation
				//style.t_stroke_thickness = 10;
				//style.t_stroke_color = 0xFF0000;
				//style.t_stroke_alpha = 0.5;
				
				// rotation
				style.a_stroke_thickness = 2;
				style.a_stroke_color = 0x4B7BCC;
				style.a_stroke_alpha = 0.8;
				style.a_fill_color = 0x9BD6EA;
				style.a_fill_alpha = 0.3;
				style.b_stroke_thickness = 2;
				style.b_stroke_color = 0xFF0000;
				style.b_stroke_alpha = 0.2;
				style.b_fill_color = 0xFF0000;
				style.b_fill_alpha = 0.3;
				style.rotation_shape = "segment";
				style.rotation_radius = 200;	
				style.percent = 0.7
				
		}
	public function init():void
	{
		//trace("init")
		cO = GestureGlobals.gw_public::clusters[id];
	}
	
	public function draw():void
	{
		drawTouch();
		drawMotion();
		//drawSensor();
	}
	
	private function drawTouch():void
	{	
		if (cO.pointArray)
			{
			pointList = cO.pointArray;
			n = pointList.length;
		
			_x = cO.x;
			_y = cO.y;
			_width = cO.width;
			_height = cO.height;
			_radius = cO.radius;
			_rotation = cO.rotation; 
			_orientation = cO.orientation; 
			_dtheta = cO.dtheta / 4;
			_ds = cO.ds*10;
			
			step =  0.01;
			percent = style.percent;
			numSteps = Math.abs(Math.round(_dtheta / step));
			r2 = _radius * percent;
			r1 = _radius * (percent + 0.2);
						
			if(Math.abs(_orientation)>=360){
				_orientation = 0;
			}
			sA = _orientation/RAD_DEG
			eA = _orientation / RAD_DEG + _dtheta;
			
			x0 = 0
			y0 = 0

			

			///////////////////////////////////////////////////////////////////////////////////
			// 	DRAW SHAPES
			///////////////////////////////////////////////////////////////////////////////////
		
			// init
			graphics.clear();
			
			if(_drawRadius){
			// draw bounding circle
			graphics.lineStyle(style.c_stroke_thickness,style.stroke_color,style.c_stroke_alpha);
			graphics.drawCircle(_x, _y, _radius);
			}
			
			// set line style
			graphics.lineStyle(style.stroke_thickness,style.stroke_color,style.stroke_alpha);
			
			if(_drawCenter){
			// draw cluster center position
			graphics.drawCircle(_x, _y, style.radius);
			}
			
			if(_drawBisector){
			// draw bi-sectors
			graphics.moveTo(_x,_y+_height/2);
			graphics.lineTo(_x,_y-_height/2);
			graphics.moveTo(_x-_width/2,_y);
			graphics.lineTo(_x + _width / 2, _y);
			}
			
			if(_drawBox){
			// draw bunding box
			graphics.drawRect(_x - _width / 2, _y - _height / 2, _width, _height);
			}
			
			if(_drawWeb){
			// draw web links tyo center
			if (style.web_shape == "fullweb") {
					for (var k:int=0; k<n; k++){
							for (var l:int=0; l<n; l++){
								if(k!=l){
									//trace(i,j)
									graphics.moveTo(pointList[k].x,pointList[k].y);
									graphics.lineTo(pointList[l].x, pointList[l].y);
								}
							}
					}
			}
			if (style.web_shape == "starweb") {
				//trace("starweb");
				for (var p:int = 0; p < n; p++) {
						graphics.moveTo(_x,_y);
						graphics.lineTo(pointList[p].x, pointList[p].y);
					}
			}
			}
			
			if(_drawRotation){
			//////////////////////////////////////////////////////////////////////////////////
			// draw rotation
			//////////////////////////////////////////////////////////////////////////////////
			if (style.rotation_shape == "segment") {

						//trace("redraw segment",orientation);
						//counter clockwise
						if (_dtheta < 0) {
							
							//needs work to get counting correct--------------------------------------//
							graphics.lineStyle(style.a_stroke_thickness, style.a_stroke_color, style.a_stroke_alpha);
							
							graphics.moveTo(_x + r2 * Math.cos(sA), _y + r2 * Math.sin(sA));
							graphics.lineTo(_x + r1 * Math.cos(sA), _y + r1 * Math.sin(sA));
							graphics.beginFill(style.a_fill_color,style.a_fill_alpha);
							
							for (var theta0:Number = sA; theta0 > eA; theta0 -= step) 
							{
								graphics.lineTo(_x + r1*Math.cos(theta0), _y + r1*Math.sin(theta0));
							}
							graphics.lineTo(_x + r2*Math.cos(eA), _y + r2*Math.sin(eA));
						
							for (var theta:Number = eA; theta < sA; theta += step) 
								{
								graphics.lineTo(_x + r2*Math.cos(theta), _y + r2*Math.sin(theta));
							}
							graphics.endFill();
						}
						
						// clockwise
						if (_dtheta > 0) {
							graphics.lineStyle(style.b_stroke_thickness, style.b_stroke_color, style.b_stroke_alpha);
							
							graphics.moveTo(_x + r2 * Math.cos(sA), _y + r2 * Math.sin(sA));
							graphics.lineTo(_x + r1 * Math.cos(sA),_y + r1 * Math.sin(sA));
							graphics.beginFill(style.b_fill_color,style.b_fill_alpha);
							
							for (var i:int = 0; i < numSteps; i++) {
								var theta1:Number = i*step + sA;
								graphics.lineTo(_x + r1*Math.cos(theta1), _y + r1*Math.sin(theta1));
							}
							graphics.lineTo(_x + r1*Math.cos(eA), _y + r1*Math.sin(eA));
							graphics.lineTo(_x + r2*Math.cos(eA), _y + r2*Math.sin(eA));
						
							for (var j:int = 0; j < numSteps; j++) {
								var theta2:Number = -j*step + eA;
								graphics.lineTo(_x + r2*Math.cos(theta2), _y + r2*Math.sin(theta2));
							}
							graphics.lineTo(_x + r2 * Math.cos(sA), _y + r2 * Math.sin(sA));
							graphics.endFill();
						}
			}
			
			if (style.rotation_shape == "slice") {
					
					//trace("redraw slice", rotation, dtheta);
					if (_dtheta < 0)
					{
						graphics.lineStyle(style.a_stroke_thickness, style.a_stroke_color, style.a_stroke_alpha);
						graphics.beginFill(style.a_fill_color, style.a_fill_alpha);
						
						graphics.moveTo(x, y);
						graphics.lineTo(_x + _radius * Math.cos(sA), _y + _radius * Math.sin(sA));
						
						for (var theta3:Number = sA; theta > eA; theta -= step) {
							graphics.lineTo(_x + _radius * Math.cos(theta3), _y + _radius * Math.sin(theta3));
						}
						graphics.lineTo(_x, _y);
						graphics.endFill();
					}
					
					if (_dtheta > 0)
					{
						graphics.lineStyle(style.b_stroke_thickness, style.b_stroke_color, style.b_stroke_alpha);
						graphics.beginFill(style.b_fill_color,style.b_fill_alpha);
					
						graphics.moveTo(_x, _y);
						graphics.lineTo(_x + _radius * Math.cos(sA), _y + _radius * Math.sin(sA));
						
						for (var theta4:Number = sA; theta < eA; theta += step) {
							graphics.lineTo(_x + _radius * Math.cos(theta4), _y + _radius * Math.sin(theta4));
						}
						graphics.lineTo(_x, _y);
						graphics.endFill();
					}
				}	
			}
			
			
			
			if (_drawSeparation)
			{
			
				trace(_ds)
			
				if (_ds < -0.1) // contract
				{
				graphics.lineStyle(style.c_stroke_thickness-20 +20*Math.abs(5*_ds) ,style.a_stroke_color,0.3);
				graphics.drawCircle(_x, _y, _radius +20);
				}
				else if (_ds > 0.1) //expand
				{
					graphics.lineStyle(style.c_stroke_thickness-20 +20*Math.abs(5*_ds) ,style.b_stroke_color,0.3);
					graphics.drawCircle(_x, _y, _radius +20);
				}
			}
			//////////////////////////////////////////////////////////////////////////////////////////////////////////
			
		}
	}
	
	private function drawMotion():void
		{
		var mpn:int = cO.motionArray.length;

				for (var i:int = 0; i < mpn; i++) 
					{
							var mp:MotionPointObject = cO.motionArray[i];
								
								if (_drawWeb)
								{	
									var pmp:MotionPointObject = GestureGlobals.gw_public::motionPoints[mp.handID]											
									if (pmp)
									{
										// draw line to palm point
										graphics.lineStyle(2, 0xFF0000, style.stroke_alpha);
										graphics.moveTo(mp.position.x , mp.position.y);
										graphics.lineTo(pmp.position.x , pmp.position.y);
									}
								}	
									
								// draw thumb
								if ((_drawThumb)&&(mp.fingertype == "thumb")) 
									{
									///////////////////////////////////////////////////////
									// draw thumb
									///////////////////////////////////////////////////////
									var w:int = 50;
									graphics.lineStyle(4, 0xFF0000, style.stroke_alpha);
									//graphics.drawCircle(mp.position.x , mp.position.y, style.radius + 10);
									graphics.drawRect(mp.position.x - w, mp.position.y - w, 2 * w, 2 * w);
								}
		
								
								if ((_drawPalm)&&(mp.type == "palm"))
									{
										var hz:Number = mp.position.z
										var hr:Number = mp.sphereRadius * 0.5 + hz;
										var sq_width:Number = 5;
											
										/////////////////// move to cluster
										// palm radius 
										graphics.lineStyle(4, 0x716BE3, style.stroke_alpha);
										graphics.drawCircle(mp.position.x , mp.position.y, hr);
										
										//sphere
										//graphics.lineStyle(4, 0xFF0000, style.stroke_alpha);
										//graphics.drawCircle(mp.sphereCenter.x , mp.sphereCenter.y, mp.sphereRadius);
									}
								
								
					}
			
					
					
					
					////////////////////////////////////////////////////////////////
					// motion point piars 
					///////////////////////////////////////////////////////////////
					if(_drawPairs){
					var lines:int = cO.pairList.length//cO.motionArray.length
					
						//trace("pair list length",lines,cO.pairList.length)
						if (lines <= cO.pairList.length)
						{
							//trace("ggg");
							for (var pn:int = 0; pn < lines; pn++) //5
							//for (var pn:int = 0; pn < cO.motionArray.length-2; pn++) //4
							{
								var pA:MotionPointObject = cO.pairList[pn].pointA;
								var pB:MotionPointObject = cO.pairList[pn].pointB;
								
								//trace(pA,pB);
								
								if ((pA!=null) && (pB!=null))
								{
									var mpA:Vector3D = pA.position;
									var mpB:Vector3D = pB.position;
							
										graphics.lineStyle(4, 0x0000FF, 0.5);
										graphics.moveTo (mpA.x, mpA.y);
										graphics.lineTo (mpB.x, mpB.y);
										
										//trace(mpB.x,mpB.y,mpB.x,mpA.y)
								}
							}
						}
					}
					/////////////////////////////////////////////////////////////////////
	}

	public function clear():void
	{
		graphics.clear();
	}
	

	
	/**
	* @private
	*/
	private var _drawBisector:Boolean = true;
	/**
	* draw cluster bisectors.
	*/
	public function get drawBisector():Boolean { return _drawBisector; }
	public function set drawBisector(value:Boolean):void { _drawBisector = value; }
	/**
	* @private
	*/
	private var _drawRadius:Boolean = true;
	/**
	* draw cluster radius.
	*/
	public function get drawRadius():Boolean { return _drawRadius; }
	public function set drawRadius(value:Boolean):void { _drawRadius = value; }
	/**
	* @private
	*/
	private var _drawCenter:Boolean = true;
	/**
	* draw draw center.
	*/
	public function get drawCenter():Boolean { return _drawCenter; }
	public function set drawCenter(value:Boolean):void { _drawCenter = value; }
	/**
	* @private
	*/
	private var _drawBox:Boolean = true;
	/**
	* draw draw bounding box.
	*/
	public function get drawBox():Boolean { return _drawBox; }
	public function set drawBox(value:Boolean):void { _drawBox = value; }
	
	/**
	* @private
	*/
	private var _drawWeb:Boolean = true;
	/**
	* draw draw bounding Web.
	*/
	public function get drawWeb():Boolean { return _drawWeb; }
	public function set drawWeb(value:Boolean):void { _drawWeb = value; }
	
	/**
	* @private
	*/
	private var _drawRotation:Boolean = true;
	/**
	* draw draw rotation.
	*/
	public function get drawRotation():Boolean { return _drawRotation; }
	public function set drawRotation(value:Boolean):void { _drawRotation = value; }
	
	/**
	* @private
	*/
	private var _drawSeparation:Boolean = true;
	/**
	* draw draw Separation.
	*/
	public function get drawSeparation():Boolean { return _drawSeparation; }
	public function set drawSeparation(value:Boolean):void { _drawSeparation = value; }
	
	
	/**
	* @private
	*/
	private var _drawPairs:Boolean = true;
	/**
	* draw point Pairs.
	*/
	public function get drawPairs():Boolean { return _drawPairs; }
	public function set drawPairs(value:Boolean):void { _drawPairs = value; }
	
	/**
	* @private
	*/
	private var _drawThumb:Boolean = true;
	/**
	* draw thumb.
	*/
	public function get drawThumb():Boolean { return _drawThumb; }
	public function set drawThumb(value:Boolean):void { _drawThumb = value; }
	
	
	/**
	* @private
	*/
	private var _drawPalm:Boolean = true;
	/**
	* draw Palm.
	*/
	public function get drawPalm():Boolean { return _drawPalm; }
	public function set drawPalm(value:Boolean):void { _drawPalm = value; }
	
	
	
	
	
	
	
	
	
	
	
	
	
	
}
}