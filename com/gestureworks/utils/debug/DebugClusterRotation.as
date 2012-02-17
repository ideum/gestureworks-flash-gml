////////////////////////////////////////////////////////////////////////////////
//
//  IDEUM
//  Copyright 2011-2012 Ideum
//  All Rights Reserved.
//
//  GestureWorks
//
//  File:    DebugClusterRotation.as
//  Authors:  Ideum
//             
//  NOTICE: Ideum permits you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////
package com.gestureworks.utils.debug
{
	import flash.display.Shape;
	import com.gestureworks.core.CML;
	
	import com.gestureworks.core.GestureGlobals;
	import com.gestureworks.core.gw_public;

	public class DebugClusterRotation extends Shape
	{
		private static var cml:XMLList;
		private var obj:Object;
		private var clusterObject:Object;
		
		private static const RAD_DEG:Number = 180 / Math.PI;
		
		private var _x:Number = 0
		private var _y:Number = 0
		private var _radius:Number = 0
		private var _rotation:Number = 0
		private var _orientation:Number = 0
		private var dtheta:Number = 0
		
		private var step:Number =  0
		private var percent:Number = 0
		private var r2:Number = 0
		private var r1:Number = 0
		private var sA:Number = 0
		private var eA:Number = 0
		private var numSteps:Number = 0
		
		public function DebugClusterRotation(ID:Number)
		{
			//trace("init cluster circle");
			clusterObject = GestureGlobals.gw_public::clusters[ID];
			
			/////////////////////////////////////////////
			// set default style 
			/////////////////////////////////////////////

			obj = new Object
				obj.displayOn = false;
			
				obj.a_stroke_thickness = 2;
				obj.a_stroke_color = 0x4B7BCC;
				obj.a_stroke_alpha = 0.8;
				obj.a_fill_color = 0x9BD6EA;
				obj.a_fill_alpha = 0.3;
				
				obj.b_stroke_thickness = 2;
				obj.b_stroke_color = 0xFF0000;
				obj.b_stroke_alpha = 0.2;
				obj.b_fill_color = 0xFF0000;
				obj.b_fill_alpha = 0.3;
				obj.shape = "segment";
				obj.percent = 0.7
		}
			
	
	public function drawRotation():void
	{	
		_x = clusterObject.x;
		_y = clusterObject.y; 
		_radius = clusterObject.radius;
		_rotation = clusterObject.rotation; 
		_orientation = clusterObject.orientation; 
		dtheta = clusterObject.dtheta / 4;
		
		step =  0.01;
		percent = obj.percent;
		numSteps = Math.abs(Math.round(dtheta / step));
		r2 = _radius * percent;
		r1 = _radius * (percent + 0.2);
					
		if(Math.abs(_orientation)>=360){
			_orientation = 0;
		}
		sA = _orientation/RAD_DEG
		eA = _orientation / RAD_DEG + dtheta;
		
		///////////////////
		// START DRAWING //
		///////////////////
		
		graphics.clear();
			
		if (obj.shape == "segment") {

						//trace("redraw segment",orientation);
						//counter clockwise
						if (dtheta < 0) {
							
							//needs work to get counting correct--------------------------------------//
							graphics.lineStyle(obj.a_stroke_thickness, obj.a_stroke_color, obj.a_stroke_alpha);
							
							graphics.moveTo(_x + r2 * Math.cos(sA), _y + r2 * Math.sin(sA));
							graphics.lineTo(_x + r1 * Math.cos(sA), _y + r1 * Math.sin(sA));
							graphics.beginFill(obj.a_fill_color,obj.a_fill_alpha);
							
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
						if (dtheta > 0) {
							graphics.lineStyle(obj.b_stroke_thickness, obj.b_stroke_color, obj.b_stroke_alpha);
							
							graphics.moveTo(_x + r2 * Math.cos(sA), _y + r2 * Math.sin(sA));
							graphics.lineTo(_x + r1 * Math.cos(sA),_y + r1 * Math.sin(sA));
							graphics.beginFill(obj.b_fill_color,obj.b_fill_alpha);
							
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
			
			if (obj.shape == "slice") {
					
					//trace("redraw slice", rotation, dtheta);
					if (dtheta < 0)
					{
						graphics.lineStyle(obj.a_stroke_thickness, obj.a_stroke_color, obj.a_stroke_alpha);
						graphics.beginFill(obj.a_fill_color, obj.a_fill_alpha);
						
						graphics.moveTo(x, y);
						graphics.lineTo(_x + _radius * Math.cos(sA), _y + _radius * Math.sin(sA));
						
						for (var theta3:Number = sA; theta > eA; theta -= step) {
							graphics.lineTo(_x + _radius * Math.cos(theta3), _y + _radius * Math.sin(theta3));
						}
						graphics.lineTo(_x, _y);
						graphics.endFill();
					}
					
					if (dtheta > 0)
					{
						graphics.lineStyle(obj.b_stroke_thickness, obj.b_stroke_color, obj.b_stroke_alpha);
						graphics.beginFill(obj.b_fill_color,obj.b_fill_alpha);
					
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
	
	public function setStyles():void
	{
		cml = new XMLList(CML.Objects)
		var numLayers:int = cml.DebugKit.DebugLayer.length()
		
		for (var i:int = 0; i < numLayers; i++) {
			var type:String = cml.DebugKit.DebugLayer[i].attribute("type")
		
			if (type == "cluster_rotation") {
				//trace("cluster rotation style");
				//obj.displayOn = cml.DebugKit.DebugLayer[i].attribute("displayOn")//3;
				
				//obj.a_stroke_thickness = cml.DebugKit.DebugLayer[i].attribute("a_stroke_thickness")//3;
				//obj.a_stroke_color = cml.DebugKit.DebugLayer[i].attribute("a_stroke_color")//0xFFFFFF;
				//obj.a_stroke_alpha = cml.DebugKit.DebugLayer[i].attribute("a_stroke_alpha")//1;
				//obj.a_fill_color = cml.DebugKit.DebugLayer[i].attribute("a_fill_color")//0xFFFFFF;
				//obj.a_fill_alpha = cml.DebugKit.DebugLayer[i].attribute("a_fill_alpha")//1;
				
				//obj.b_stroke_thickness = cml.DebugKit.DebugLayer[i].attribute("b_stroke_thickness")//3;
				//obj.b_stroke_color = cml.DebugKit.DebugLayer[i].attribute("b_stroke_color")//0xFFFFFF;
				//obj.b_stroke_alpha = cml.DebugKit.DebugLayer[i].attribute("b_stroke_alpha")//1;
				//obj.b_fill_color = cml.DebugKit.DebugLayer[i].attribute("b_fill_color")//0xFFFFFF;
				//obj.b_fill_alpha = cml.DebugKit.DebugLayer[i].attribute("b_fill_alpha")//1;
				
				//obj.percent = cml.DebugKit.DebugLayer[i].attribute("percent")//20;
				//obj.shape = cml.DebugKit.DebugLayer[i].attribute("shape")//20;
				
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