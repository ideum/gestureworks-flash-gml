////////////////////////////////////////////////////////////////////////////////
//
//  IDEUM
//  Copyright 2011-2012 Ideum
//  All Rights Reserved.
//
//  GestureWorks
//
//  File:    DebugClusterPoints.as
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

	public class DebugClusterPoints extends Shape
	{
		private static var cml:XMLList;
		public var style:Object; // public allows override of cml values
		private var cO:Object;
		//private var ts:Object;
		private var pointList:Object;
		private var NumPoints:Number;
		private var id:Number = 0;
			
		public function DebugClusterPoints(ID:Number)
		{
			id = ID;
			cO = GestureGlobals.gw_public::clusters[id];
			
			//super();
			//trace("init cluster points");
			
			/////////////////////////////////////////////
			// set default style 
			/////////////////////////////////////////////

			style = new Object
				style.displayOn = false;
				
				style.stroke_thickness = 6;
				style.stroke_color = 0xFFAE1F;
				style.stroke_alpha = 0.9;
				style.fill_color = 0xFFAE1F;
				style.fill_alpha = 1;
				style.fill_type = "solid";
				style.shape = "ring";
				style.radius = 12;
				style.height = 20;
				style.width = 20;
				style.filter = "glow";
		}
			
	
	public function drawPoints():void
	{
		pointList = cO.pointArray
		NumPoints = pointList.length
		
		//if(obj.displayOn=="true"){
			
		
			///////////////////////////////////
			// init draw 	
			///////////////////////////////////
				
			graphics.clear();
			graphics.lineStyle(style.stroke_thickness, style.stroke_color, style.stroke_alpha);
				
				
				
				for (var i:int = 0; i < NumPoints; i++) 
				{
					//var x:Number = pointList[i].point.x
					//var y:Number = pointList[i].point.y
					
					var x:Number = pointList[i].x
					var y:Number = pointList[i].y
				
					//////////////////////////////////////////////////////////////////////
					// shape outlines
					//////////////////////////////////////////////////////////////////////
					
					if (style.shape == "square") {
						//trace("square");
							graphics.drawRect(x-style.width,y-style.width,2*style.width, 2*style.width);
					}
					if (style.shape == "ring") {
						//trace("ring");
							graphics.drawCircle(x, y, style.radius);
					}
					if (style.shape == "cross") {
						//trace("cross");
							graphics.moveTo (x - style.radius, y);
							graphics.lineTo (x + style.radius , y);
							graphics.moveTo (x, y - style.radius);
							graphics.lineTo (x, y + style.radius);
					}
					if (style.shape == "triangle") {
						//trace("triangle");
							graphics.moveTo (x - style.radius, y -style.radius);
							graphics.lineTo (x, style.pointList[i].y + style.radius);
							graphics.lineTo (x + style.radius, y - style.radius);
							graphics.lineTo (x - style.radius, y -style.radius);
						
					}
					//////////////////////////////////////////////////////////////////
					// filled shapes
					//////////////////////////////////////////////////////////////////
					
					if (style.shape == "circle-fill") {
						//trace("circle draw");
							graphics.beginFill(style.fill_color, style.fill_alpha);
							graphics.drawCircle(x, y, style.radius);
							graphics.endFill();
					}
					if (style.shape == "triangle-fill") {
						//trace("triangle fill");
							graphics.beginFill(style.fill_color, style.fill_alpha);
							graphics.moveTo (x - style.width, y -style.width);
							graphics.lineTo (x, y + style.width);
							graphics.lineTo (x + style.width, y - style.width);
							graphics.lineTo (x - style.width, y -style.width);
							graphics.endFill();
					
					}
					if (style.shape == "square-fill") {
						//trace("square");
							graphics.beginFill(style.color, style.fill_alpha);
							graphics.drawRect(x - style.width, y - style.width, 2 * style.width, 2 * style.width);
							graphics.endFill();
					}
				
				}
		}
	//}
	
public function setStyles():void
	{
		if (CML.Objects != null)
		{
			cml = new XMLList(CML.Objects)
			var numLayers:int = cml.DebugKit.DebugLayer.length()
			
			for (var i:int = 0; i < numLayers; i++) {
				var type:String = String(cml.DebugKit.DebugLayer[i].attribute("type"));
				var path:Object = cml.DebugKit.DebugLayer[i]
			
				if (type == "point_shapes") {
					//trace("point display style");
					if (path.attribute("stroke_thickness")!=undefined) 	style.stroke_thickness = int(path.attribute("stroke_thickness"))//3;
					if (path.attribute("stroke_color")!=undefined)		style.stroke_color = String(path.attribute("stroke_color"))//0xFFFFFF;
					if (path.attribute("stroke_alpha")!=undefined) 		style.stroke_alpha = Number(path.attribute("stroke_alpha"))//1;
					if (path.attribute("fill_color")!=undefined) 		style.fill_color = String(path.attribute("fill_color"))//0xFFFFFF;
					if (path.attribute("fill_alpha")!=undefined) 		style.fill_alpha = Number(path.attribute("fill_alpha"))//1;
					if (path.attribute("fill_type")!=undefined) 		style.fill_type = String(path.attribute("fill_type"))//"solid";
					if (path.attribute("shape")!=undefined) 			style.shape = String(path.attribute("shape"))//"circle-fill";
					if (path.attribute("radius")!=undefined) 			style.radius = Number(path.attribute("radius"))//20;
					if (path.attribute("height")!=undefined) 			style.height = Number(path.attribute("height"))//20;
					if (path.attribute("width")!=undefined) 			style.width = Number(path.attribute("width"))//20;
					if (path.attribute("filter")!=undefined) 			style.filter = String(path.attribute("filter"))//"glow";
					
					//trace(obj.filter)
				}
			}
		}
	}
	
	
public function clear():void
	{
		//trace("trying to clear");
		graphics.clear();
	}
	
}
}