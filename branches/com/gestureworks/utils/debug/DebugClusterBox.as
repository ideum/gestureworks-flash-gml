////////////////////////////////////////////////////////////////////////////////
//
//  IDEUM
//  Copyright 2011-2012 Ideum
//  All Rights Reserved.
//
//  GestureWorks
//
//  File:    DebugClusterBox.as
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

	public class DebugClusterBox extends Shape
	{
	private static var cml:XMLList;
	private var obj:Object;
	private var cO:Object;
	//private var ts:Object;
	private var pointList:Object;
	private var NumPoints:Number;
	private var id:Number = 0;
	
	private var _x:Number = 0
	private var _y:Number = 0
	private var _width:Number = 0
	private var _height:Number = 0
	
			
	public function DebugClusterBox(ID:Number)
		{
			id = ID;
			cO = GestureGlobals.gw_public::clusters[id];
			
			/////////////////////////////////////////////
			// set default style 
			/////////////////////////////////////////////

			obj = new Object ();
				obj.displayOn = false;
				obj.stroke_thickness = 4;
				obj.stroke_color = 0xFFAE1F;
				obj.stroke_alpha = 0.9;
				obj.filter = "glow";
		}
			
	public function drawBox():void
	{
		pointList = cO.pointArray

		_x = cO.x;
		_y = cO.y;
		_width = cO.width;
		_height = cO.height;
			
		///////////////////////////////////
		// init draw 	
		///////////////////////////////////
			
		graphics.clear();
		graphics.lineStyle(obj.stroke_thickness,obj.stroke_color,obj.stroke_alpha);
		graphics.drawRect(_x - _width / 2, _y - _height / 2, _width, _height);
	}

	public function clear():void
	{
		graphics.clear();
	}
	
	public function setStyles():void
	{
		cml = new XMLList(CML.Objects)
		var numLayers:int = cml.DebugKit.DebugLayer.length()
		
		for (var i:int = 0; i < numLayers; i++) {
			var type:String = cml.DebugKit.DebugLayer[i].attribute("type")
		
			if (type == "cluster_box") {
				//obj.displayOn = cml.DebugKit.DebugLayer[i].attribute("displayOn")//3;
				
				//obj.stroke_thickness = cml.DebugKit.DebugLayer[i].attribute("stroke_thickness")//3;
				//obj.stroke_color = cml.DebugKit.DebugLayer[i].attribute("stroke_color")//0xFFFFFF;
				//obj.stroke_alpha = cml.DebugKit.DebugLayer[i].attribute("stroke_alpha")//1;
				//obj.filter = cml.DebugKit.DebugLayer[i].attribute("filter")//"glow";
			}
		}
	}
	
	
}
}