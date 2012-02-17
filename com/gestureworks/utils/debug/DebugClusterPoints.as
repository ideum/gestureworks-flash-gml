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
		public var obj:Object; // public allows ovveride of cml values
		private var cO:Object;
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

			obj = new Object
				obj.displayOn = false;
				
				obj.stroke_thickness = 6;
				obj.stroke_color = 0xFFAE1F;
				obj.stroke_alpha = 0.9;
				obj.fill_color = 0xFFAE1F;
				obj.fill_alpha = 0.9;
				obj.fill_type = "solid";
				obj.shape = "ring";
				obj.radius = 12;
				obj.height = 20;
				obj.width = 20;
				obj.filter = "glow";
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
			graphics.lineStyle(obj.stroke_thickness, obj.stroke_color, obj.stroke_alpha);
				
				
				
				for (var i:int = 0; i < NumPoints; i++) 
				{
					var x:Number = pointList[i].point.x
					var y:Number = pointList[i].point.y
				
					//////////////////////////////////////////////////////////////////////
					// shape outlines
					//////////////////////////////////////////////////////////////////////
					
					if (obj.shape == "square") {
						//trace("square");
							graphics.drawRect(x-obj.width,y-obj.width,2*obj.width, 2*obj.width);
					}
					if (obj.shape == "ring") {
						//trace("ring");
							graphics.drawCircle(x, y, obj.radius);
					}
					if (obj.shape == "cross") {
						//trace("cross");
							graphics.moveTo (x - obj.radius, y);
							graphics.lineTo (x + obj.radius , y);
							graphics.moveTo (x, y - obj.radius);
							graphics.lineTo (x, y + obj.radius);
					}
					if (obj.shape == "triangle") {
						//trace("triangle");
							graphics.moveTo (x - obj.radius, y -obj.radius);
							graphics.lineTo (x, obj.pointList[i].point.y + obj.radius);
							graphics.lineTo (x + obj.radius, y - obj.radius);
							graphics.lineTo (x - obj.radius, y -obj.radius);
						
					}
					//////////////////////////////////////////////////////////////////
					// filled shapes
					//////////////////////////////////////////////////////////////////
					
					if (obj.shape == "circle-fill") {
						//trace("circle draw");
							graphics.beginFill(obj.fill_color, obj.fill_alpha);
							graphics.drawCircle(x, y, obj.radius);
							graphics.endFill();
					}
					if (obj.shape == "triangle-fill") {
						//trace("triangle fill");
							graphics.beginFill(obj.fill_color, obj.fill_alpha);
							graphics.moveTo (x - obj.width, y -obj.width);
							graphics.lineTo (x, y + obj.width);
							graphics.lineTo (x + obj.width, y - obj.width);
							graphics.lineTo (x - obj.width, y -obj.width);
							graphics.endFill();
					
					}
					if (obj.shape == "square-fill") {
						//trace("square");
							graphics.beginFill(obj.color, obj.fill_alpha);
							graphics.drawRect(x - obj.width, y - obj.width, 2 * obj.width, 2 * obj.width);
							graphics.endFill();
					}
				
				}
		}
	//}
	
public function setStyles():void
	{
		cml = new XMLList(CML.Objects)
		var numLayers:int = cml.DebugKit.DebugLayer.length()
		
		for (var i:int = 0; i < numLayers; i++) {
			var type:String = String(cml.DebugKit.DebugLayer[i].attribute("type"));
			var path:Object = cml.DebugKit.DebugLayer[i]
		
			if (type == "point_shapes") {
				//trace("point display style");
				if (path.attribute("stroke_thickness")!=undefined) obj.stroke_thickness = int(path.attribute("stroke_thickness"))//3;
				if (path.attribute("stroke_color")!=undefined) obj.stroke_color = String(path.attribute("stroke_color"))//0xFFFFFF;
				if (path.attribute("stroke_alpha")!=undefined) obj.stroke_alpha = Number(path.attribute("stroke_alpha"))//1;
				if (path.attribute("fill_color")!=undefined) obj.fill_color = String(path.attribute("fill_color"))//0xFFFFFF;
				if (path.attribute("fill_alpha")!=undefined) obj.fill_alpha = Number(path.attribute("fill_alpha"))//1;
				if (path.attribute("fill_type")!=undefined) obj.fill_type = String(path.attribute("fill_type"))//"solid";
				if (path.attribute("shape")!=undefined) obj.shape = String(path.attribute("shape"))//"circle-fill";
				if (path.attribute("radius")!=undefined) obj.radius = Number(path.attribute("radius"))//20;
				if (path.attribute("height")!=undefined) obj.height = Number(path.attribute("height"))//20;
				if (path.attribute("width")!=undefined) obj.width = Number(path.attribute("width"))//20;
				if (path.attribute("filter")!=undefined) obj.filter = String(path.attribute("filter"))//"glow";
				
				//trace(obj.filter)
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