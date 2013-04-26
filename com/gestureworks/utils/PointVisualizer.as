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
package com.gestureworks.utils
{
	import com.gestureworks.managers.MotionPointHistories;
	import flash.display.Shape;
	import com.gestureworks.core.CML;
	import flash.geom.Vector3D;
	import flash.display.Sprite;
	import flash.text.*;
	
	
	import com.gestureworks.core.GestureGlobals;
	import com.gestureworks.core.gw_public;
	import com.gestureworks.objects.MotionPointObject;
	import com.gestureworks.objects.ClusterObject;
	import com.gestureworks.objects.PointObject;
	import com.gestureworks.utils.AddSimpleText;
	
	
	import com.leapmotion.leap.events.LeapEvent;
	import com.leapmotion.leap.LeapMotion;
	import com.leapmotion.leap.*;
	import com.leapmotion.leap.events.*;
	import com.leapmotion.leap.util.*;
	
	

	public class PointVisualizer extends Sprite//Shape
	{
		private static var cml:XMLList;
		public var style:Object; // public allows override of cml values
		private var id:Number = 0;
		
		private var cO:ClusterObject;
		
		private var pointList:Vector.<PointObject>;
		private var ts:Object;
		private var N:int = 0;
		private var mptext_array:Array = new Array();
		private var tptext_array:Array = new Array();
		private var i:int
		private var hist:int = 0;
		
			
		public function PointVisualizer(ID:Number)
		{
			//super();
			//trace("points visualizer");
			
			id = ID;
			ts = GestureGlobals.gw_public::touchObjects[id];
			cO = ts.cO;
			
			hist = 8;
			
			
			/////////////////////////////////////////////
			// set default style 
			/////////////////////////////////////////////

			style = new Object

				//points
				style.stroke_thickness = 6;
				style.stroke_color = 0xFFAE1F;
				style.stroke_alpha = 0.9;
				style.fill_color = 0xFFAE1F;
				style.fill_alpha = 0.8;
				style.fill_type = "solid";
				style.shape = "circle-fill";
				//style.shape = "ring";
				style.radius = 20;
				style.height = 20;
				style.width = 20;
				style.filter = "glow";
				style.trail_shape = "curve";
				
				
				// create text fields
				for (var i:int = 0; i < 12; i++) 
				{
					mptext_array[i] = new AddSimpleText(200, 100, "left", 0x777777, 18);
						//mptext_array[i].mouseChildren = true;
					tptext_array[i] = new AddSimpleText(200, 100, "left", 0x000000, 18);
						//tptext_array[i].mouseChildren = true;
					addChild(tptext_array[i]);
					addChild(mptext_array[i]);
				}
		}
			
	
	public function draw():void
	{
		pointList = cO.pointArray
		N = pointList.length
			
		
		// clar graphics
		graphics.clear();
		
		// draw
		draw_touchPoints();
		draw_motionPoints();
		//draw_sensorPoints();
	}
		
		
		
		public function draw_touchPoints():void
		{
		
			// clear text
			for (i = 0; i < 12; i++) tptext_array[i].visible = false;
			
				for (i = 0; i < N; i++) 
				{
					///////////////////////////////////////////////////////////////////
					// Point positons and shapes
					///////////////////////////////////////////////////////////////////
					
					var x:Number = pointList[i].x
					var y:Number = pointList[i].y
					
					
					///////////////////////////////////////////////////////////////////
					//
					///////////////////////////////////////////////////////////////////
					tptext_array[i].textCont = "Point: " + "ID" + String(pointList[i].touchPointID) + "    id" + String(pointList[i].id);
					tptext_array[i].x = x;
					tptext_array[i].y = y - 50;
					tptext_array[i].visible = true;
				
					//////////////////////////////////////////////////////////////////////
					// shape outlines
					//////////////////////////////////////////////////////////////////////
					
					if (style.shape == "square") {
						//trace("square");
							graphics.lineStyle(style.stroke_thickness, style.stroke_color, style.stroke_alpha);
							graphics.drawRect(x-style.width,y-style.width,2*style.width, 2*style.width);
					}
					if (style.shape == "ring") {
						//trace("ring");
							graphics.lineStyle(style.stroke_thickness, style.stroke_color, style.stroke_alpha);
							graphics.drawCircle(x, y, style.radius);
					}
					if (style.shape == "cross") {
						//trace("cross");
							graphics.lineStyle(style.stroke_thickness, style.stroke_color, style.stroke_alpha);
							graphics.moveTo (x - style.radius, y);
							graphics.lineTo (x + style.radius , y);
							graphics.moveTo (x, y - style.radius);
							graphics.lineTo (x, y + style.radius);
					}
					if (style.shape == "triangle") {
						//trace("triangle");
							graphics.lineStyle(style.stroke_thickness, style.stroke_color, style.stroke_alpha);
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
					

					/////////////////////////////////////////////////////////////////
					// point vectors
					/////////////////////////////////////////////////////////////////
					
					//define vector pint style
					//graphics.lineStyle(style.v_stroke,style.color,style.alpha);
					hist  = pointList[i].history.length-1;
					var alpha:Number = 0;
					
						if (style.trail_shape == "line")
						{
									alpha = 0.08*(hist-j)
									graphics.lineStyle(style.stroke_thickness, style.stroke_color, alpha);
									graphics.moveTo(pointList[i].history[0].x, pointList[i].history[0].y);
									graphics.lineTo(pointList[i].history[hist].x, pointList[i].history[hist].y);
								
							}
						if (style.trail_shape == "curve") {
							
									for (var j:int = 0; j < hist; j++) 
									{
										if (j + 1 <= hist) {
											alpha = 0.08 * (hist - j)
											graphics.lineStyle(style.stroke_thickness, style.stroke_color, alpha);
											graphics.moveTo(pointList[i].history[j].x, pointList[i].history[j].y);
											graphics.lineTo(pointList[i].history[j + 1].x, pointList[i].history[j + 1].y);
										}
									}
						}
						if (style.trail_shape == "ring") {
								
									for (var k:int = 0; k < hist; k++) 
									{
										alpha = 0.08 * (hist - j)
										graphics.lineStyle(style.stroke_thickness, style.stroke_color,alpha);
										graphics.drawCircle(pointList[i].history[j].x, pointList[i].history[j].y, style.radius);
									}
						}
						
				}
		}		
				
				

		private function draw_motionPoints():void
		{
				/////////////////////////////////////////////////////////////////////
				// motion points
				///////////////////////////////////////////////////////////////////
				//if (cO.fn != 0)
				//{
				
				// clear text
				for (i = 0; i < 12; i++) mptext_array[i].visible = false;
					
					//var frame:Frame = cO.motionArray;
					var mpn:int = cO.motionArray.length;

								// Calculate the hand's average finger tip position
								for (i = 0; i < mpn; i++) 
								{
								var mp:MotionPointObject = cO.motionArray[i];
								//trace("----finger--",finger.id,finger.motionPointID, finger.x,finger.y);	
								//trace("type visualizer",mp.type)
								
								
									if (mp.type == "finger")
									{
										var zm:Number = mp.position.z * 0.2;
										var wm:Number = (mp.width) *10;
										//trace("length", finger.length);
										//trace("width", finger.width);

											
											//  draw point 
											graphics.lineStyle(4, 0x6AE370, style.stroke_alpha);
											graphics.drawCircle(mp.position.x ,mp.position.y, style.radius + 20 + zm);	
											graphics.beginFill(0x6AE370, style.fill_alpha);
											graphics.drawCircle(mp.position.x, mp.position.y, style.radius);
											graphics.endFill();
											
											//drawPoints ID of point
											mptext_array[i].textCont = "Finger: " + "ID" + String(mp.motionPointID) + "    id" + String(mp.id);
											mptext_array[i].x = mp.position.x;
											mptext_array[i].y = mp.position.y - 50;
											mptext_array[i].visible = true;
											
											
											
											// SHOULD MOVE TO CLUSTER
											var pmp:MotionPointObject = GestureGlobals.gw_public::motionPoints[mp.handID]											
											if (pmp){
												// draw line to palm point
												graphics.lineStyle(2, 0xFF0000, style.stroke_alpha);
												graphics.moveTo(mp.position.x , mp.position.y);
												graphics.lineTo(pmp.position.x , pmp.position.y);
											}
									}
									
									
									if (mp.type == "palm")
									{
										////////////////////////////////////////////////////
										//// draw hand data
										////////////////////////////////////////////////////
										
										var hz:Number = mp.position.z
										var hr:Number = mp.sphereRadius * 0.5 + hz;
										var sq_width:Number = 5;
										
											// palm radius
											graphics.lineStyle(4, 0x716BE3, style.stroke_alpha);
											graphics.drawCircle(mp.position.x , mp.position.y, hr);
											// palm center
											graphics.lineStyle(2, 0x716BE3, style.stroke_alpha);
											graphics.drawRect(mp.position.x - sq_width, mp.position.y - sq_width, 2 * sq_width, 2 * sq_width);
											
											//sphere
											//graphics.lineStyle(4, 0xFF0000, style.stroke_alpha);
											//graphics.drawCircle(mp.sphereCenter.x , mp.sphereCenter.y, mp.sphereRadius);
											
											//drawPoints ID of point
											mptext_array[i].textCont = "Palm: " + "ID" + String(mp.motionPointID) + "    id" + String(mp.id);
											mptext_array[i].x = mp.position.x;
											mptext_array[i].y = mp.position.y - 50;
											mptext_array[i].visible = true;
									}
									
									if (mp.fingertype == "thumb") 
									{
										///////////////////////////////////////////////////////
										// draw thumb
										///////////////////////////////////////////////////////
										
										var w:int = 50;
										graphics.lineStyle(4, 0xFF0000, style.stroke_alpha);
										//graphics.drawCircle(mp.position.x , mp.position.y, style.radius + 10);
										graphics.drawRect(mp.position.x - w, mp.position.y - w, 2 * w, 2 * w);
									}
									
								}
		
		}

		private function draw_sensorPoints():void 
		{
				////////////////////////////////////////////////////////////////
				// sensor points
				////////////////////////////////////////////////////////////////
				
				
				
			
		}

	
public function setStyles():void
	{
		if (CML.Objects != null)
		{
			cml = new XMLList(CML.Objects)
			var numLayers:int = cml.DebugKit.DebugLayer.length()
			
			for (i = 0; i < numLayers; i++) {
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
		
		//text clear
	for (i = 0; i < 12; i++){
		tptext_array[i].visible = false;
		mptext_array[i].visible = false;
	}
	}
	
}
}