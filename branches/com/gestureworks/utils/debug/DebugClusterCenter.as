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
package com.gestureworks.utils.debug
{
	import flash.display.Shape;
	import com.gestureworks.core.CML;
	
	import com.gestureworks.core.GestureGlobals;
	import com.gestureworks.core.gw_public;
	
	
	public class DebugClusterCenter extends Shape
	{
		private static var cml:XMLList;
		private var obj:Object;
		private var cO:Object;
		private var pointList:Array;
		private var NumPoints:Number;
		private var id:Number = 0;
		
		private var centerPos:Boolean = true;
		private var centerRot:Boolean = false;
		private var centerSca:Boolean = false;
		
		private var _x:Number = 0;
		private var _y: Number = 0;
		private var _width:Number = 0;
		private var _height: Number = 0;
		private var x0:Number = 0;
		private var y0:Number = 0;
		
			
		public function DebugClusterCenter(touchObjectID:Number)
		{
			//trace("init cluster center");
			id = touchObjectID;
			
			/////////////////////////////////////////////
			// set default style 
			/////////////////////////////////////////////

			obj = new Object
				obj.displayOn = false;
				
				obj.stroke_thickness = 4;
				obj.stroke_color = 0xFFAE1F;
				obj.stroke_alpha = 0.9;
				obj.fill_color = 0xFFAE1F;
				obj.fill_alpha = 0.9;
				//obj.fill_type = "solid";
			//	obj.shape = "circle-fill";
				obj.radius = 20;
				obj.height = 20;
				obj.width = 20;
				//obj.filter = "glow";
		}
	public function init():void
	{
		//trace("init")
		cO = GestureGlobals.gw_public::clusters[id];
	}		
	
	public function drawCenter():void
	{
		//if(obj.displayOn=="true"){
			
			_x = cO.x;
			_y = cO.y;
			_width = cO.width;
			_height = cO.height;
			x0 = 0//cO.x
			y0 = 0//cO.y
		
			graphics.clear();
			graphics.lineStyle(obj.stroke_thickness,obj.stroke_color,obj.stroke_alpha);
			
			if(centerPos){
				// draw cluster center position
				graphics.drawCircle(_x,_y,obj.radius);
				// draw bi-sectors
				graphics.moveTo(_x,_y+_height/2);
				graphics.lineTo(_x,_y-_height/2);
				graphics.moveTo(_x-_width/2,_y);
				graphics.lineTo(_x+_width/2,_y);
			}
			
			if(centerSca){
				// cluster center scale
				graphics.drawRect(_x - obj.width / 2, _y - obj.height / 2, obj.width, obj.height);
				// draw bi-sectors
				graphics.moveTo(_x,_y+_height/2);
				graphics.lineTo(_x,_y-_height/2);
				graphics.moveTo(_x-_width/2,_y);
				graphics.lineTo(_x+_width/2,_y);
			}
			
			if(centerRot){
				// draw cluster center rotate
				graphics.moveTo(_x,_y+obj.height/2);
				graphics.lineTo(_x+obj.width/2, _y-obj.height/2);
				graphics.lineTo(_x-obj.width/2, _y-obj.height/2);
				graphics.lineTo(_x,_y+obj.height/2);
				// draw bi-sectors
				graphics.moveTo(_x,_y+_height/2);
				graphics.lineTo(_x,_y-_height/2);
				graphics.moveTo(_x-_width/2,_y);
				graphics.lineTo(_x+_width/2,_y);
			}
		}
		
	//}
	
	
	public function setStyles():void
	{
		cml = new XMLList(CML.Objects)
		var numLayers:int = cml.DebugKit.DebugLayer.length()
		
		for (var i:int = 0; i < numLayers; i++) {
			var type:String = cml.DebugKit.DebugLayer[i].attribute("type")
			
			if (type == "cluster_center") {
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