////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
//
//  IDEUM
//  Copyright 2011-2012 Ideum
//  All Rights Reserved.
//
//  GestureWorks
//
//  File:    DebugTouchObjectTransform.as
//  Authors:  Ideum
//             
//  NOTICE: Ideum permits you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////
package com.gestureworks.utils.debug
{
	import flash.display.Sprite;
	import flash.geom.Point;

	import com.gestureworks.core.CML;
	import com.gestureworks.core.GestureGlobals;
	import com.gestureworks.core.gw_public;

	import com.gestureworks.objects.TransformObject;
	

	public class DebugTouchObjectTransform extends Sprite
	{
		private static var cml:XMLList;
		private var obj:Object;
		private var id:Number = 0;
		private var trO:TransformObject;

		public function DebugTouchObjectTransform(ID:Number)
		{
			//trace("init cluster vector");
			id = ID;
			trO = GestureGlobals.gw_public::transforms[id];  // points to sprite
			
			/////////////////////////////////////////////
			// set default style 
			/////////////////////////////////////////////

			obj = new Object
				obj.displayOn = false;
				
				obj.stroke_thickness = 10;
				obj.stroke_color = 0x9BD6EA;
				obj.stroke_alpha = 0.9;
				
				obj.fill_color = 0x9BD6EA;
				obj.fill_alpha = 0.1;
				
				obj.text_color = 0xFF0000;
				obj.text_size = 12;
				obj.text_alpha = 1;
				
				obj.indicators = true;
				obj.radius = 10;
				obj.line_type = "dashed"
	}
	
	
	public function drawTransform():void 
	{
		graphics.clear();
		
			////////////////////////////////////////////////////////////
			// transformed points in touch object
			// draw key points of touch object display
			///////////////////////////////////////////////////////////
			if((trO.transAffinePoints)&&(trO.transformPointsOn)){
				// draw affine transformation debug wire frame
				// center
				graphics.lineStyle(3, 0xFFFFFF, 0.8);
				graphics.drawCircle(trO.transAffinePoints[0].x, trO.transAffinePoints[0].y, 10);
				// top left
				graphics.lineStyle(3, 0xFF0000, 0.8);
				graphics.drawCircle(trO.transAffinePoints[2].x, trO.transAffinePoints[2].y, 10);
				//top right
				graphics.lineStyle(3, 0xFFFF00, 0.8);
				graphics.drawCircle(trO.transAffinePoints[1].x, trO.transAffinePoints[1].y, 10);
				//bottom left 
				graphics.lineStyle(3, 0x00FF00, 0.8);
				graphics.drawCircle(trO.transAffinePoints[4].x, trO.transAffinePoints[4].y, 10);
				//bottom right
				graphics.lineStyle(3, 0x0000FF, 0.8);
				graphics.drawCircle(trO.transAffinePoints[3].x, trO.transAffinePoints[3].y, 10);

				// diagonal 
				graphics.lineStyle(3, 0xFFFFFF, 0.8);
				graphics.moveTo(trO.transAffinePoints[2].x, trO.transAffinePoints[2].y);
				graphics.lineTo(trO.transAffinePoints[3].x, trO.transAffinePoints[3].y);
				graphics.moveTo(trO.transAffinePoints[1].x, trO.transAffinePoints[1].y);
				graphics.lineTo(trO.transAffinePoints[0].x, trO.transAffinePoints[0].y);
			}
		}
	
	
	public function clear():void
	{
		//trace("transform debug clear");
		graphics.clear();
	}
	
	public function setStyles():void
	{
		cml = new XMLList(CML.Objects)
		var numLayers:int = cml.DebugKit.DebugLayer.length()
		
		for (var i:int = 0; i < numLayers; i++) {
			var type:String = cml.DebugKit.DebugLayer[i].attribute("type")
			
			if (type == "touchobject_transform") {
				//trace("cluster data list")
				//obj.displayOn = cml.DebugKit.DebugLayer[i].attribute("displayOn")//3;
				
				//obj.stroke_thickness = cml.DebugKit.DebugLayer[i].attribute("stroke_thickness")//3;
				//obj.stroke_color = cml.DebugKit.DebugLayer[i].attribute("stroke_color")//0xFFFFFF;
				//obj.stroke_alpha = cml.DebugKit.DebugLayer[i].attribute("stroke_alpha")//1;
				
				//obj.fill_color = cml.DebugKit.DebugLayer[i].attribute("fill_color")//0xFFFFFF;
				//obj.fill_alpha = cml.DebugKit.DebugLayer[i].attribute("fill_alpha")//1;
				
				//obj.text_color = cml.DebugKit.DebugLayer[i].attribute("text_color")//0xFFFFFF;
				//obj.text_size = cml.DebugKit.DebugLayer[i].attribute("text_size")//12;
				//obj.text_alpha = cml.DebugKit.DebugLayer[i].attribute("text_alpha")//1;
				
				//obj.indicators = cml.DebugKit.DebugLayer[i].attribute("indicators")
				//obj.radius =cml.DebugKit.DebugLayer[i].attribute("radius")
				//obj.line_type = cml.DebugKit.DebugLayer[i].attribute("line_type")
			}
		}
	}
	
}
}