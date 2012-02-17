////////////////////////////////////////////////////////////////////////////////
//
//  IDEUM
//  Copyright 2011-2012 Ideum
//  All Rights Reserved.
//
//  GestureWorks
//
//  File:    DebugClusterCircle.as
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

	public class DebugClusterCircle extends Shape
	{
		private static var cml:XMLList;
		private var obj:Object;
		private var cO:Object;
		private var id:Number = 0;
		
		private var _x:Number = 0
		private var _y:Number = 0
		private var _radius:Number = 0
			
			
		public function DebugClusterCircle(ID:Number)
		{
			//trace("init cluster circle");
			id = ID;
			cO = GestureGlobals.gw_public::clusters[id];
			
			/////////////////////////////////////////////
			// set default style 
			/////////////////////////////////////////////

			obj = new Object
				obj.displayOn = false;
				obj.stroke_thickness = 16;
				obj.stroke_color = 0xFFAE1F;
				obj.stroke_alpha = 0.6;
				obj.filter = "glow";
		}
			
	
	public function drawCircle():void
	{
		//pointList = clusterObject.pointArray
		//NumPoints = pointList.length
		
		//if(obj.displayOn=="true"){
		
			_x = cO.x;
			_y = cO.y;
			_radius = cO.radius;
				
			///////////////////////////////////
			// init draw 	
			///////////////////////////////////
			
			graphics.clear();
			graphics.lineStyle(obj.stroke_thickness,obj.stroke_color,obj.stroke_alpha);
			graphics.drawCircle(_x, _y, _radius);
		//}
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
			
			if (type == "cluster_circle") {
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