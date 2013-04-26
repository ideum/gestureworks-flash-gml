////////////////////////////////////////////////////////////////////////////////
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
package com.gestureworks.utils
{
	import flash.display.Shape;
	import com.gestureworks.core.CML;
	
	import com.gestureworks.core.GestureGlobals;
	import com.gestureworks.core.gw_public;
	import com.gestureworks.objects.PointObject;
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
				style.height = 20;
				style.width = 20;
				
				// circle
				style.c_stroke_thickness = 16;
				style.c_stroke_alpha = 0.6;
				
				//web
				style.web_shape = "starweb";

				//orientation
				style.t_stroke_thickness = 10;
				style.t_stroke_color = 0xFF0000;
				style.t_stroke_alpha = 0.5;
				
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
			
			// draw bounding circle
			graphics.lineStyle(style.c_stroke_thickness,style.stroke_color,style.c_stroke_alpha);
			graphics.drawCircle(_x, _y, _radius);
			
			
			// set line style
			graphics.lineStyle(style.stroke_thickness,style.stroke_color,style.stroke_alpha);
			
			// draw cluster center position
			graphics.drawCircle(_x, _y, style.radius);
			
			// draw bi-sectors
			graphics.moveTo(_x,_y+_height/2);
			graphics.lineTo(_x,_y-_height/2);
			graphics.moveTo(_x-_width/2,_y);
			graphics.lineTo(_x + _width / 2, _y);
			
			
			// draw bunding box
			graphics.drawRect(_x - _width / 2, _y - _height / 2, _width, _height);
			
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
	}
		

	
	
	public function setStyles():void
	{
		cml = new XMLList(CML.Objects)
		var numLayers:int = cml.DebugKit.DebugLayer.length()
		
		for (var i:int = 0; i < numLayers; i++) {
			var type:String = cml.DebugKit.DebugLayer[i].attribute("type")
			
			if (type == "cluster_display") {
				//trace("point display style");
				//obj.displayOn = cml.DebugKit.DebugLayer[i].attribute("displayOn")//3;
				
				//obj.stroke_thickness = cml.DebugKit.DebugLayer[i].attribute("stroke_thickness")//3;
				//obj.stroke_color = cml.DebugKit.DebugLayer[i].attribute("stroke_color")//0xFFFFFF;
				//obj.stroke_alpha = cml.DebugKit.DebugLayer[i].attribute("stroke_alpha")//1;
				//obj.radius = cml.DebugKit.DebugLayer[i].attribute("radius")//20;
				//obj.height = cml.DebugKit.DebugLayer[i].attribute("height")//20;
				//obj.width = cml.DebugKit.DebugLayer[i].attribute("width")//20;
				//obj.width = cml.DebugKit.DebugLayer[i].attribute("shape")//20;

				//trace(obj.filter)
			}
		}
	}
	

	public function clear():void
	{
		graphics.clear();
	}
	

	
}
}