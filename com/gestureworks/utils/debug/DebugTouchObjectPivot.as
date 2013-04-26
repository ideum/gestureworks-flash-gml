////////////////////////////////////////////////////////////////////////////////
//
//  IDEUM
//  Copyright 2011-2012 Ideum
//  All Rights Reserved.
//
//  GestureWorks
//
//  File:    DebugTouchObjectPivot.as
//  Authors:  Ideum
//             
//  NOTICE: Ideum permits you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////
package com.gestureworks.utils.debug
{
	import flash.display.Sprite;
	
	import com.gestureworks.core.CML;
	import com.gestureworks.core.GestureGlobals;
	import com.gestureworks.core.gw_public;

	public class DebugTouchObjectPivot extends Sprite
	{	
		private static var cml:XMLList;
		private var obj:Object;
		private var ts:Object;
		private var id:Number = 0;
		
		public function DebugTouchObjectPivot(touchObjectID:Number)
		{
			id = touchObjectID;
			
			/////////////////////////////////////////////
			// set default style 
			/////////////////////////////////////////////

			obj = new Object
				obj.stroke_thickness = 4;
				obj.stroke_color = 0x9BD6EA;
				obj.stroke_alpha = 0.9;
				obj.fill_color = 0x9BD6EA;
				obj.fill_alpha = 0.1;
				obj.text_color = 0xFFFFFF;
				obj.text_size = 12;
				obj.text_alpha = 1;
				obj.indicators = true;
				obj.radius = 10;
		}
			
		public function init():void
		{
			//trace("init")
			ts = GestureGlobals.gw_public::touchObjects[id]; // CHANGE TO TRANSFORMATION OBJECT CENTER POINT
		}
			
	public function drawVectors():void
	{	
		setStyles();
		graphics.clear();	
		
		if((ts.trO.init_center_point)&&(ts.trO.transformPointsOn)){
			if ((ts.cO.x != 0) && (ts.cO.y != 0) && (ts.cO.dx != 0) && (ts.cO.dy != 0)) {
			
			var x_c:Number = 0;
			var y_c:Number = 0;
			
			if (ts.trO.transAffinePoints) 
			{
				x_c = ts.trO.transAffinePoints[4].x
				y_c = ts.trO.transAffinePoints[4].y	
			}
				
				graphics.lineStyle(3, 0xFFFFFF, 0.8);
				//graphics.moveTo(tO.x, tO.y);
				graphics.moveTo(x_c, y_c);
				graphics.lineTo(ts.cO.x, ts.cO.y);
				
				graphics.lineStyle(3, 0xFF0000, 0.8);
				graphics.moveTo(ts.cO.x, ts.cO.y);
				graphics.lineTo(ts.cO.x + ts.cO.dx, ts.cO.y + ts.cO.dy);
				
				graphics.lineStyle(3, 0x00FF00, 0.8);
				//graphics.moveTo(tO.x, tO.y);
				graphics.moveTo(x_c, y_c);
				graphics.lineTo(ts.cO.x + ts.cO.dx, ts.cO.y + ts.cO.dy);
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
			
			if (type == "touchobject_pivot") {
				//trace("touch object pivot")
				
				//obj.stroke_thickness = cml.DebugKit.DebugLayer[i].attribute("stroke_thickness")//3;
				//obj.stroke_color = cml.DebugKit.DebugLayer[i].attribute("stroke_color")//0xFFFFFF;
				//obj.stroke_alpha = cml.DebugKit.DebugLayer[i].attribute("stroke_alpha")//1;
				//obj.fill_color = cml.DebugKit.DebugLayer[i].attribute("fill_color")//0xFFFFFF;
				//obj.fill_alpha = cml.DebugKit.DebugLayer[i].attribute("fill_alpha")//1;
				//obj.text_color = cml.DebugKit.DebugLayer[i].attribute("text_color")//0xFFFFFF;
				//obj.text_size = cml.DebugKit.DebugLayer[i].attribute("text_size")//12;
				//obj.text_alpha = cml.DebugKit.DebugLayer[i].attribute("text_alpha")//1;
				//obj.indicators = cml.DebugKit.DebugLayer[i].attribute("indicators")//"true";
				//obj.radius = cml.DebugKit.DebugLayer[i].attribute("radius");
			}
		}
	}
	
	
}
}