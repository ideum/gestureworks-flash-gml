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
	import com.gestureworks.managers.MotionPointHistories;
	import flash.display.Shape;
	import com.gestureworks.core.CML;
	import flash.geom.Vector3D;
	import flash.display.Sprite;
	import flash.text.*;
	
	import com.gestureworks.core.GestureGlobals;
	import com.gestureworks.core.gw_public;
	import com.gestureworks.objects.MotionPointObject;
	import com.gestureworks.utils.AddSimpleText;
	
	import com.leapmotion.leap.events.LeapEvent;
	import com.leapmotion.leap.LeapMotion;
	import com.leapmotion.leap.*;
	import com.leapmotion.leap.events.*;
	import com.leapmotion.leap.util.*;

	public class DebugClusterPoints extends Sprite//Shape
	{
		private static var cml:XMLList;
		public var style:Object; // public allows override of cml values
		private var cO:Object;
		//private var ts:Object;
		private var pointList:Object;
		private var NumPoints:Number;
		private var id:Number = 0;
		private var text_array:Array = new Array();
			
		public function DebugClusterPoints(ID:Number)
		{
			id = ID;
			cO = GestureGlobals.gw_public::clusters[id];
			
			//super();
			trace("init debug cluster points");
			
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
				
				
				// create text fields
				for (var i:int = 0; i < 12; i++) 
				{
					text_array[i] = new AddSimpleText(200, 100, "left", 0x777777, 18);
					addChild(text_array[i]);
				}
		}
			
	
	public function drawPoints():void
	{
		pointList = cO.pointArray
		NumPoints = pointList.length
		var i:int;
		
		//trace("draw motion points");
		
		//if(obj.displayOn=="true"){
			
		
			///////////////////////////////////
			// init draw 	
			///////////////////////////////////
				
			graphics.clear();
			
			// clear text
			for (i = 0; i < 12; i++) text_array[i].visible = false;

			graphics.lineStyle(style.stroke_thickness, style.stroke_color, style.stroke_alpha);
				
				
				
				for (i = 0; i < NumPoints; i++) 
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
				//if (cO.fn != 0)
				//{
					
					//var frame:Frame = cO.motionArray;
					var mpn:int = cO.motionArray.length;
					//var cn:int = cO.motionArray.length;
					//trace("--debugframe----------------------------------",fn);
					//if ( frame.hands.length != 0 )
					//{
					//for (var h:int = 0; h < frame.hands.length; h++) {
						
							//var hand:Hand = frame.hands[h];
							// Check if the hand has any fingers
							//var fingers:Vector.<Finger> = hand.fingers;
							//var fingers:MotionPointObject = hand.fingers;
							
							// push fingers to points list
							//if (fn)
							//{
								// Calculate the hand's average finger tip position
								for (i=0; i < mpn; i++) 
								{
								var mp:MotionPointObject = cO.motionArray[i];
								//trace("----finger--",finger.id,finger.motionPointID, finger.x,finger.y);	
								//trace("type visualizer",mp.type)
									if (mp.type=="finger"){
										
										var zm:Number = mp.position.z * 0.2;
										var wm:Number = (mp.width) *10;
										//trace("length", finger.length);
										//trace("width", finger.width);

											//if (style.shape == "ring") {
												//trace("ring");
													graphics.lineStyle(4, 0x6AE370, style.stroke_alpha);
													graphics.drawCircle(mp.position.x ,mp.position.y, style.radius + 20 + zm);
													
													graphics.beginFill(0x6AE370, style.fill_alpha);
													graphics.drawCircle(mp.position.x, mp.position.y, style.radius);
													graphics.endFill();
											//}
											
											var pmp:MotionPointObject = GestureGlobals.gw_public::motionPoints[mp.handID]
											
											if (pmp){
												// draw line to palm point
												graphics.lineStyle(2, 0xFF0000, style.stroke_alpha);
												graphics.moveTo(mp.position.x , mp.position.y);
												graphics.lineTo(pmp.position.x , pmp.position.y);
											}
											
											
											//drawPoints ID of point
											text_array[i].textCont = "Finger: " + "ID" + String(mp.motionPointID) + "    id" + String(mp.id);
											text_array[i].x = mp.position.x;
											text_array[i].y = mp.position.y - 50;
											text_array[i].visible = true;
									
									}
									
									
									if(mp.type=="palm"){
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
											text_array[i].textCont = "Palm: " + "ID" + String(mp.motionPointID) + "    id" + String(mp.id);
											text_array[i].x = mp.position.x;
											text_array[i].y = mp.position.y - 50;
											text_array[i].visible = true;
									}
									
									if (mp.fingertype == "thumb") {
										var w:int = 50;
											graphics.lineStyle(2, 0xFF0000, style.stroke_alpha);
											//graphics.drawCircle(mp.position.x , mp.position.y, style.radius + 10);
											
											graphics.drawRect(mp.position.x - w, mp.position.y - w, 2 * w, 2 * w);
									}
									
								}
								
								
							//}
					//}
					
					/*
					// point pairs
					for (var pn:int = 0; pn < cO.motionArray.length; pn++) 
						{
							if (cO.motionArray[pn].type == "finger")
								{
								var mp:MotionPointObject = cO.motionArray[pn];
								var nnd_mp:MotionPointObject = GestureGlobals.gw_public::motionPoints[mp.nndID];
								var nnda_mp:MotionPointObject = GestureGlobals.gw_public::motionPoints[mp.nndaID];
								//var nnda_mp:MotionPointObject = GestureGlobals.gw_public::motionPoints[mp.nnpaID];
								var nnp_mp:MotionPointObject = GestureGlobals.gw_public::motionPoints[mp.nnprobID];
								
								var mpv:Vector3D = mp.position;
								
								
								if (nnp_mp){ // white prob
									
									var nnp_mpv:Vector3D = nnp_mp.position;
									
									// dist based point pair
									graphics.lineStyle(4, 0xF0F0F0, 0.5);
									graphics.moveTo (mpv.x, mpv.y);
									graphics.lineTo (nnp_mpv.x , nnp_mpv.y);							
								}
								
								// light blue
								//graphics.lineStyle(4, 0x00FFFF, 0.5);
								
								if (nnd_mp){ // dark blue
									var nnd_mpv:Vector3D = nnd_mp.position;

									// dist based point pair
									graphics.lineStyle(4, 0x0000FF, 0.5);
									//graphics.moveTo (mpv.x + 100, mpv.y+100);
									//graphics.lineTo (nnd_mpv.x +100, nnd_mpv.y + 100);
									
									graphics.moveTo (mpv.x, mpv.y);
									graphics.lineTo (nnd_mpv.x, nnd_mpv.y);
								}
								
								if (nnda_mp){ //pink
									var nnda_mpv:Vector3D = nnda_mp.position;
									
									// dist based point pair
									graphics.lineStyle(4, 0xF000F0, 0.5);
									graphics.moveTo (mpv.x + 50, mpv.y + 50);
									graphics.lineTo (nnda_mpv.x+50 , nnda_mpv.y+50);
								}
							}
						}*/
						
						
						//for (var pn:int = 0; pn < cO.pairList.length; pn++) //10
						
					//
					var lines:int = cO.pairList.length//cO.motionArray.length
					var pn:int;
					
					//trace("pair list length",lines,cO.pairList.length)
					
					if (lines <= cO.pairList.length)
					{
						//trace("ggg");
						for (pn = 0; pn < lines; pn++) //5
						//for (var pn:int = 0; pn < cO.motionArray.length-2; pn++) //4
						{
							var pA:MotionPointObject = cO.pairList[pn].pointA;
							var pB:MotionPointObject = cO.pairList[pn].pointB;
							
							//trace(pA,pB);
							
							if ((pA!=null) && (pB!=null))
							{
								var mpA:Vector3D = pA.position;
								var mpB:Vector3D = pB.position;
						
									graphics.lineStyle(4, 0x0000FF, 0.5);
									graphics.moveTo (mpA.x, mpA.y);
									graphics.lineTo (mpB.x, mpB.y);
									
									//trace(mpB.x,mpB.y,mpB.x,mpA.y)
							}
						}
					}
					
					
					
					//////////////////////////////////////////////////////////////
					// bimanual manipulation data 
					// interaction point cluster manipulatio data	
					
					if(cO.iPointArray.length){
					////////////////////////////////////////////////////////////
						
						//trace("ipointArray",cO.iPointArray.length)
					
						// draw all pinch points
						for (pn = 0; pn < cO.iPointArray.length; pn++) 
						{
							//trace("ipoint type",cO.iPointArray[pn].type)
							//PINK 0xE3716B // for pinch
							if (cO.iPointArray[pn].type == "pinch") graphics.lineStyle(4, 0xE3716B, style.stroke_alpha);
							//PURPLE 0xc44dbe // for trigger
							if (cO.iPointArray[pn].type == "trigger") graphics.lineStyle(4, 0xc44dbe, style.stroke_alpha);
							
							graphics.drawCircle(cO.iPointArray[pn].position.x, cO.iPointArray[pn].position.y, 8);
						}
						
						// only 2 points and must be from different hands
						//if ((cO.iPointArray.length == 2) && (cO.iPointArray[0].w != cO.iPointArray[1].w))
						if (cO.iPointArray.length == 2)
						{
							// draw mid point//0xFAAFBE,
							graphics.drawCircle(cO.x, cO.y, 5);
					
							//draw pinch line
							graphics.moveTo (cO.iPointArray[0].position.x, cO.iPointArray[0].position.y);
							graphics.lineTo (cO.iPointArray[1].position.x , cO.iPointArray[1].position.y);
						}
						
						}
					
					
					//}	
				//}
				
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