////////////////////////////////////////////////////////////////////////////////
//
//  IDEUM
//  Copyright 2011-2012 Ideum
//  All Rights Reserved.
//
//  GestureWorks
//
//  File:   DebugClusterWeb.as
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

	public class DebugClusterWeb extends Shape
	{	
		private static var cml:XMLList;
		private var obj:Object;
		private var clusterObject:Object;
		private var pointList:Array;
		private var NumPoints:Number;
		private var id:Number = 0;
		private var n:Number = 0;
		
		
		public function DebugClusterWeb(ID:Number)
		{
			//trace("init cluster web");
			id = ID;
			clusterObject = GestureGlobals.gw_public::clusters[id];
			
			
			/////////////////////////////////////////////
			// set default style 
			/////////////////////////////////////////////

			obj = new Object
				obj.displayOn = false;
			
				obj.stroke_thickness = 4;
				obj.stroke_color = 0xFFAE1F;
				obj.stroke_alpha = 0.9;
				obj.shape = "starweb";
				obj.filter = "glow";
				obj.line_type = "solid";
		}
			
	
	public function drawWeb():void
	{
			pointList = clusterObject.pointArray
			NumPoints = pointList.length
			n = NumPoints
			
			//if(obj.displayOn=="true"){
			
			var x:Number = clusterObject.x;
			var y:Number = clusterObject.y;
		
			///////////////////////////////////
			// init draw 	
			///////////////////////////////////
		
			graphics.clear();
			graphics.lineStyle(obj.stroke_thickness,obj.stroke_color,obj.stroke_alpha);
		

			if (obj.shape == "ringweb") {
				//trace("ringweb");
			}
			
			if (obj.shape == "fullweb") {
				//trace("fullweb");
				if(obj.line_type =="dashed"){
					for (var i:int=0; i<n; i++){
							for (var j:int=0; j<n; j++){
								if(i!=j){
									//trace(i,j)
									DrawDashLine(5, 5, pointList[i].x, pointList[i].y, pointList[j].x, pointList[j].y, obj.stroke_thickness, obj.stroke_color, obj.stroke_alpha);
								}
							}
					}
				}
				else if(obj.line_type =="solid"){
					for (var k:int=0; k<n; k++){
							for (var l:int=0; l<n; l++){
								if(k!=l){
									//trace(i,j)
										graphics.moveTo(pointList[k].x,pointList[k].y);
										graphics.lineTo(pointList[l].x, pointList[l].y);
								}
							}
					}
			}
			}
			
			if (obj.shape == "starweb") {
				//trace("starweb");
				if(obj.line_type =="dashed"){
					for (var m:int = 0; m < n; m++) 
					{
						DrawDashLine(5, 5, x, y, pointList[m].x, pointList[m].y, obj.stroke_thickness, obj.stroke_color, obj.stroke_alpha);
					}	
				}
				if(obj.line_type =="solid"){
					for (var p:int = 0; p < n; p++) {
							graphics.moveTo(x,y);
							graphics.lineTo(pointList[p].x, pointList[p].y);
						}
				}
		}
	}
	//}
	
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
			
			if (type == "cluster_web") {
			//	obj.displayOn = cml.DebugKit.DebugLayer[i].attribute("displayOn")//3;
				
				//obj.stroke_thickness = cml.DebugKit.DebugLayer[i].attribute("stroke_thickness")//3;
				//obj.stroke_color = cml.DebugKit.DebugLayer[i].attribute("stroke_color")//0xFFFFFF;
				//obj.stroke_alpha = cml.DebugKit.DebugLayer[i].attribute("stroke_alpha")//1;
				//obj.stroke_shape = cml.DebugKit.DebugLayer[i].attribute("shape")//1;
				//obj.filter = cml.DebugKit.DebugLayer[i].attribute("filter")//"glow";
				//obj.shape = cml.DebugKit.DebugLayer[i].attribute("shape")//"glow";
				//obj.line_type = cml.DebugKit.DebugLayer[i].attribute("line_type")//"glow";
			}
		}
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