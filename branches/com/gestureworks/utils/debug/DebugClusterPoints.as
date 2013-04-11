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
	
	import com.leapmotion.leap.events.LeapEvent;
	import com.leapmotion.leap.LeapMotion;
	
	import com.leapmotion.leap.*;
	import com.leapmotion.leap.events.*;
	import com.leapmotion.leap.util.*;

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
		
		//trace("draw motion points");
		
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
				
				
				/////////////////////////////////////////////////////////////////////
				// motion points
				///////////////////////////////////////////////////////////////////
				if (cO.fn != 0)
				{
					//trace("--frame----------------------------------");
					var frame:Frame = cO.motionArray;
					
					if ( frame.hands.length != 0 )
					{
					for (var h:int = 0; h < frame.hands.length; h++) {
						
							var hand:Hand = frame.hands[h];
							// Check if the hand has any fingers
							var fingers:Vector.<Finger> = hand.fingers;
							
							// push fingers to points list
							if ( fingers.length != 0 )
							{
								// Calculate the hand's average finger tip position
								for each ( var finger:Finger in fingers )
								{
								//trace("----finger--");	
								var xm:Number = (finger.tipPosition.x) + stage.stageWidth*0.5;
								var ym:Number = -(finger.tipPosition.y) + stage.stageHeight*0.5;
								var zm:Number = (finger.tipPosition.z) * 0.2;
								
								var wm:Number = 1//(finger.width) *10;
								//trace("length", finger.length);
								//trace("width", finger.width);

									if (style.shape == "ring") {
										//trace("ring");
											graphics.lineStyle(style.stroke_thickness, 0xFFFFFF, style.stroke_alpha);
											graphics.drawCircle(xm ,ym, style.radius + 20 + zm);
											
											graphics.beginFill(0xFFFFFF, style.fill_alpha);
											graphics.drawCircle(xm, ym, style.radius);
											graphics.endFill();
									}
								}	
								
								////////////////////////////////////////////////////
								//// draw hand data
								////////////////////////////////////////////////////
								var hx:Number = hand.palmPosition.x + stage.stageWidth*0.5;
								var hy:Number = -(hand.palmPosition.y) + stage.stageHeight * 0.5;
								var hz:Number = (hand.palmPosition.z) * 0.2;
								var hr:Number = hand.sphereRadius * 0.5 + hz;
								var sq_width:Number = 5;
								
									// palm radius
									graphics.lineStyle(3, 0xFFFFFF, style.stroke_alpha);
									graphics.drawCircle(hx , hy, hr);
									// palm center
									graphics.lineStyle(1, 0xFFFFFF, style.stroke_alpha);
									graphics.drawRect(hx-sq_width,hy-sq_width,2*sq_width, 2*sq_width);
							}
					}
					}	
				}
				
				////////////////////////////////////////////////////////////////
				// sensor points
				////////////////////////////////////////////////////////////////
				
				
				
				
				
				/////////////////////////////////////////////////////////////////
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