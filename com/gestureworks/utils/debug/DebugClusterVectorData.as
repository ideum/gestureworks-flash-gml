////////////////////////////////////////////////////////////////////////////////
//
//  IDEUM
//  Copyright 2011-2012 Ideum
//  All Rights Reserved.
//
//  GestureWorks
//
//  File:    DebugClusterVectorData.as
//  Authors:  Ideum
//             
//  NOTICE: Ideum permits you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////
package com.gestureworks.utils.debug
{
	import flash.display.Sprite;
	import flash.text.*;

	import com.gestureworks.core.CML;
	//import com.gestureworks.utils.DrawDashLine;
	//import com.gestureworks.utils.DrawBox;
	import com.gestureworks.utils.AddSimpleText;
	import com.gestureworks.utils.AddSimpleTextBox;
	
	import com.gestureworks.core.GestureGlobals;
	import com.gestureworks.core.gw_public;
	

	public class DebugClusterVectorData extends Sprite
	{
		private static var cml:XMLList;
		private var obj:Object;
		private var textArray:Array = new Array();
		
		private var idOn:Boolean = true;
		private var positionOn:Boolean = true;
		private var distanceOn:Boolean = true;
		private var angleOn:Boolean = true;
		private var directionOn:Boolean = true;
		
		private var clusterObject:Object;
		private var pointList:Object;
		private var NumPoints:Number;
		private var id:Number = 0;
		
		private var pn:int =0
		private var n:int = 0;
		private var m:int = 0
		private var j:int = 0;
		private var r:Number = 0
		
		private var transformDebug:Boolean = false;
		
		public function DebugClusterVectorData(ID:Number)
		{
			//super();
			trace("init cluster vector");
			
			id = ID;
			clusterObject = GestureGlobals.gw_public::clusters[id];
			
			/////////////////////////////////////////////
			// set default style 
			/////////////////////////////////////////////

			obj = new Object
				obj.displayOn = false;
				
				obj.stroke_thickness = 10;
				obj.stroke_color = 0xFFFFFF;
				obj.stroke_alpha = 1;
				
				obj.fill_color = 0xFFFFFF;
				obj.fill_alpha = 0.2;
				
				obj.text_color = 0xFF0000;
				obj.text_size = 12;
				obj.text_alpha = 1;
				
				obj.indicators = true;
				obj.radius = 30;
				obj.line_type = "dashed"
	}
	
	public function drawVectorData():void {
	
	pointList = clusterObject.pointArray
	NumPoints = pointList.length
	
	pn = pointList.length;
	n = 0;
	m= textArray.length;
	j= 0;
	r = obj.radius;
	
	//if(obj.displayOn=="true"){
	
	// config
	if (idOn) n += pn;
	if (positionOn) n += pn;
	if (distanceOn) n += pn;
	if (angleOn) n += pn;
					
					
					///////////////////////////////////////////////////////////////////////////////////////////////////
					// data display
					///////////////////////////////////////////////////////////////////////////////////////////////////
					
					// make sure there are enough text fields in the object pool
					var diff:int = n - m
					if (diff < 0) diff = 0;
					
					//add as many as you need
					for (var i:int = 0; i < diff; i++) 
					{
						var t_field:AddSimpleText = new AddSimpleText(100,20, "left",  obj.text_color, obj.text_size);
							addChild(t_field);
						textArray.push(t_field);
					}
					
					// clean out values and turn off
					for (var j:int = 0; j < m; j++) 
					{
							textArray[j].textCont = "";
							textArray[j].visible = false;
					}
					//trace(n,m, diff);
	
					// fill the text field with data
					if (idOn) {
						for (var k:int = 0; k < pn; k++) 
						{
							//j = k;
						if(pointList[k]){	
							textArray[k].textCont = "id";
							textArray[k].x = pointList[k].point.x - r;
							textArray[k].y = pointList[k].point.y - r;
							textArray[k].visible = true;
							}
						}
					}
				
				
					if (positionOn) {
						for (var q:int = pn; q < 2*pn; q++) 
						{
							j = q - 1* pn;
						if(pointList[j]){	
							textArray[q].textCont = pointList[j].point.x + " , " + pointList[j].point.y
							textArray[q].x = pointList[j].point.x + r;
							textArray[q].y = pointList[j].point.y + r;
							textArray[q].visible = true;
							}
						}
					}
					
					if (distanceOn) {
						for (var s:int = 2*pn; s < 3*pn; s++) 
						{
							 j = s - 2 * pn;
						if(pointList[j]){	
							textArray[s].textCont = "distance";
							textArray[s].x = pointList[j].point.x;
							textArray[s].y = pointList[j].point.y - r;
							textArray[s].visible = true;
							}
						}
					}
					
					if (angleOn) {
						for (var t:int = 3*pn; t < 4*pn; t++) 
						{
							j = i - 3 * pn;
						if(pointList[j]){	
							textArray[t].textCont = "angle";
							textArray[t].x = pointList[j].point.x - r;
							textArray[t].y = pointList[j].point.y ;
							textArray[t].visible = true;
							}
						}
					}
	}
	//}
	public function calcAngle():void 
	{
		
	}
	public function calcDistance():void 
	{
		
	}
	
	
	public function clear():void
	{
		graphics.clear();
		
		
		for (var i:int = 0; i < textArray.length; i++) 
		{
			textArray[i].textCont = "";
			textArray[i].visible = false;
		}
		
	}
	
	public function setStyles():void
	{
		cml = new XMLList(CML.Objects)
		var numLayers:int = cml.DebugKit.DebugLayer.length()
		
		for (var i:int = 0; i < numLayers; i++) {
			var type:String = cml.DebugKit.DebugLayer[i].attribute("type")
			
			if (type == "cluster_vector_data") {
				//trace("cluster data list")
				//obj.displayOn = cml.DebugKit.DebugLayer[i].attribute("displayOn")//3;
				obj.stroke_thickness = cml.DebugKit.DebugLayer[i].attribute("stroke_thickness")//3;
				obj.stroke_color = cml.DebugKit.DebugLayer[i].attribute("stroke_color")//0xFFFFFF;
				obj.stroke_alpha = cml.DebugKit.DebugLayer[i].attribute("stroke_alpha")//1;
				
				obj.fill_color = cml.DebugKit.DebugLayer[i].attribute("fill_color")//0xFFFFFF;
				obj.fill_alpha = cml.DebugKit.DebugLayer[i].attribute("fill_alpha")//1;
				
				obj.text_color = cml.DebugKit.DebugLayer[i].attribute("text_color")//0xFFFFFF;
				obj.text_size = cml.DebugKit.DebugLayer[i].attribute("text_size")//12;
				obj.text_alpha = cml.DebugKit.DebugLayer[i].attribute("text_alpha")//1;
				
				obj.indicators = cml.DebugKit.DebugLayer[i].attribute("indicators")
				obj.radius =cml.DebugKit.DebugLayer[i].attribute("radius")
				obj.line_type = cml.DebugKit.DebugLayer[i].attribute("line_type")
			}
		}
	}
	
	public function setOptions():void
	{
		angleOn = true;
		distanceOn = true;
		directionOn = true;
	}
	
	
	private function DrawDashLine (dash:Number,space:Number, x1:Number, y1:Number, x2:Number, y2:Number,lineHeight:Number, lineColor:Number, lineAlpha:Number):void {
			
		var dx:Number = (x2-x1);
		var dy:Number = (y2-y1);
		var dist:Number = Math.sqrt(dx*dx + dy*dy);
		var num:Number = Math.floor(dist/(dash+space));
		var lamda:Number = Math.atan(dy/dx);
		var dashdx:Number = dash*Math.cos(lamda);
		var dashdy:Number = dash*Math.sin(lamda);
		var spdx:Number = space*Math.cos(lamda);
		var spdy:Number = space*Math.sin(lamda);
				
				graphics.lineStyle(lineHeight, lineColor, lineAlpha);
				
				for(var i:int=0; i<num; i++) {
					var xpos:Number = x1 + i*(dashdx + spdx);
					var ypos:Number = y1 + i*(dashdy + spdy);
				
					graphics.moveTo(xpos, ypos);
					graphics.lineTo((xpos + dashdx),(ypos + dashdy));
				}	
		}
	
	
	
}
}