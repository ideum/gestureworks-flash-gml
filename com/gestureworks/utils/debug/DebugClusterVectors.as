////////////////////////////////////////////////////////////////////////////////
//
//  IDEUM
//  Copyright 2011-2012 Ideum
//  All Rights Reserved.
//
//  GestureWorks
//
//  File:    DebugClusterVectors.as
//  Authors:  Ideum
//             
//  NOTICE: Ideum permits you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////
package com.gestureworks.utils.debug
{
	import flash.display.Shape;
	import com.gestureworks.core.gw_public;
	import com.gestureworks.core.CML;
	
	import com.gestureworks.core.GestureGlobals;
	import com.gestureworks.core.gw_public;

	public class DebugClusterVectors extends Shape
	{
		private static var cml:XMLList;
		private var obj:Object;
		private var clusterObject:Object;
		private var pointList:Object;
		private var path_data:Array = new Array();
		private var N:int;
		private var touchObjectID:int = 0;
		private var hist:int = 0;
		private var ts:Object;
			
		public function DebugClusterVectors(_id:Number)
		{
			//trace("init cluster point vectors");
			touchObjectID = _id;
			clusterObject = GestureGlobals.gw_public::clusters[touchObjectID];
			
			ts = GestureGlobals.gw_public::touchObjects[touchObjectID];
			
			hist = 15;

			/////////////////////////////////////////////
			// set default style 
			/////////////////////////////////////////////

			obj = new Object
				obj.displayOn = false;
	
				obj.stroke_thickness = 3;
				obj.stroke_color = 0xFFAE1F;
				obj.stroke_alpha = 1;
				obj.fill_color = 0xFFFFFF;
				obj.fill_alpha = 1;
				obj.fill_type = "solid";
				obj.shape = "ring";
				obj.radius = 20;
				obj.height = 20;
				obj.width = 20;
				obj.filter = "glow";
		}
			
	
	public function drawVectors():void
	{
		//trace("drawing point vectors");
		
		path_data = clusterObject.path_data 
		pointList = clusterObject.pointArray
		N = pointList.length

		graphics.clear();
		graphics.lineStyle(obj.stroke,obj.color,obj.alpha);
		
		//if(obj.displayOn=="true"){
			
		for (var i:int = 0; i < N; i++) 
			{
			var available:Boolean = pointList[i].history[hist]
	
			if (obj.shape == "line") {
					if (available) {

						obj.stroke_alpha = 0.08*(hist-j)
						graphics.lineStyle(obj.stroke_thickness, obj.stroke_color, obj.stroke_alpha);
						graphics.moveTo(pointList[i].history[0].x, pointList[i].history[0].y);
						graphics.lineTo(pointList[i].history[hist].x, pointList[i].history[hist].y);
					}
				}
			if (obj.shape == "curve") {
					if (available) {

						for (var j:int = 0; j < hist; j++) 
						{
							if (j + 1 <= hist) {
								obj.stroke_alpha = 0.08 * (hist - j)
								graphics.lineStyle(obj.stroke_thickness, obj.stroke_color, obj.stroke_alpha);
								graphics.moveTo(pointList[i].history[j].x, pointList[i].history[j].y);
								graphics.lineTo(pointList[i].history[j + 1].x, pointList[i].history[j + 1].y);
							}
						}
				}
			}
			if (obj.shape == "ring") {
					if (available) {
						
						for (var k:int = 0; k < hist; k++) 
						{
							obj.stroke_alpha = 0.08 * (hist - j)
							graphics.lineStyle(obj.stroke_thickness, obj.stroke_color,obj.stroke_alpha);
							graphics.drawCircle(pointList[i].history[j].x, pointList[i].history[j].y, obj.radius);
						}
					}
				}
			}
			if (obj.shape == "square") {
					if (available) {
						
						for (var l:int = 0; l < hist; l++) 
						{
							obj.stroke_alpha = 0.08 * (hist - j)
							graphics.lineStyle(obj.stroke_thickness, obj.stroke_color, obj.stroke_alpha);
							graphics.drawRect(pointList[i].history[j].x, pointList[i].history[j].y, obj.width, obj.width);
						}
					}
				}
				
				if((N)&&(path_data[0])){
				// draw srtoke
				//trace("drawVectors stroke",path_data[0].x, path_data[0].y)
				
					graphics.moveTo(path_data[0].x, path_data[0].y)
					graphics.lineStyle(obj.stroke_thickness, obj.stroke_color, obj.stroke_alpha);
					
					for (var p:int = 0; p < path_data.length ; p++) 
					{
						graphics.lineTo(path_data[p].x, path_data[p].y);
					}
					
					// reference path
					var ref_path:Array = ts.gO.pOList["stroke"].path
					graphics.moveTo(ref_path[0].x, ref_path[0].y)
					graphics.lineStyle(obj.stroke_thickness, 0xFF0000, obj.stroke_alpha);
					
					for (var q:int = 0; q < ref_path.length ; q++) 
					{
						graphics.lineTo(ref_path[q].x, ref_path[q].y);
					}
					
				}
				
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
			
			if (type == "point_vectors") {
				//trace("vector display style");
				
				//obj.displayOn = cml.DebugKit.DebugLayer[i].attribute("displayOn")//3;
				//obj.stroke_thickness = cml.DebugKit.DebugLayer[i].attribute("stroke_thickness")//3;
				//obj.stroke_color = cml.DebugKit.DebugLayer[i].attribute("stroke_color")//0xFFFFFF;
				//obj.stroke_alpha = cml.DebugKit.DebugLayer[i].attribute("stroke_alpha")//1;
				obj.fill_color = cml.DebugKit.DebugLayer[i].attribute("fill_color")//0xFFFFFF;
				obj.fill_alpha = cml.DebugKit.DebugLayer[i].attribute("fill_alpha")//1;
				obj.fill_type = cml.DebugKit.DebugLayer[i].attribute("fill_type")//"solid";
				obj.shape = cml.DebugKit.DebugLayer[i].attribute("shape")//"circle-fill";
				obj.radius = cml.DebugKit.DebugLayer[i].attribute("radius")//20;
				obj.height = cml.DebugKit.DebugLayer[i].attribute("height")//20;
				obj.width = cml.DebugKit.DebugLayer[i].attribute("width")//20;
				obj.filter = cml.DebugKit.DebugLayer[i].attribute("filter")//"glow";
			}
		}
	}
	
}
}