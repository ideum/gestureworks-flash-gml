﻿////////////////////////////////////////////////////////////////////////////////
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
package com.gestureworks.utils
{
	import flash.display.Sprite;
	import flash.geom.Vector3D;
	
	import com.gestureworks.core.CML;
	import com.gestureworks.core.GestureGlobals;
	import com.gestureworks.core.gw_public;
	import com.gestureworks.objects.PointObject;
	import com.gestureworks.objects.ClusterObject;
	import com.gestureworks.objects.TransformObject;
	import com.gestureworks.objects.StrokeObject;
	import com.gestureworks.objects.MotionPointObject;
	

	public class GestureVisualizer extends Sprite
	{	
		private static var cml:XMLList;
		private var style:Object;
		private var ts:Object;
		private var cO:ClusterObject;
		private var sO:StrokeObject;
		private var trO:TransformObject;
		private var id:Number = 0;
		private var pointList:Vector.<PointObject>
		private var N:int = 0;
		private var path_data:Array = new Array();
		
		public function GestureVisualizer(ID:Number)
		{
			trace("gesture visualizer");
			id = ID;
			
			/////////////////////////////////////////////
			// set default style 
			/////////////////////////////////////////////

			style = new Object
				style.stroke_thickness = 4;
				style.stroke_color = 0x9BD6EA;
				style.stroke_alpha = 0.9;
				style.fill_color = 0x9BD6EA;
				style.fill_alpha = 0.1;
				style.text_color = 0xFFFFFF;
				style.text_size = 12;
				style.text_alpha = 1;
				style.indicators = true;
				style.radius = 10;
				style.indicators = true;
				style.radius = 10;
				style.line_type = "dashed"
		}
			
		public function init():void
		{
			//trace("init")
			ts = GestureGlobals.gw_public::touchObjects[id]; // CHANGE TO TRANSFORMATION OBJECT CENTER POINT
			trO = ts.trO;// points to sprite
			sO = ts.sO
			cO = ts.cO;
		}
			
	public function draw():void
	{	
		pointList = cO.pointArray;
		N = pointList.length;
		path_data = sO.path_data 
		
		
		setStyles();
		graphics.clear();
		
		// draw
		draw_touch_cluster();
		draw_motion_cluster();
		//draw_sensor_cluster();
		
	}
	
	private function draw_touch_cluster():void
	{
		/////////////////////////////////////////////////////////////////////////////////
		// draw pivot gesture vector
		/////////////////////////////////////////////////////////////////////////////////
		if (N)
		{
			if ((ts.trO.init_center_point) && (ts.trO.transformPointsOn))
			{
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
			
			
			/////////////////////////////////////////////////////////////////////////////////
			// draws transfromation vectors
			// transformed points in touch object
			// draw key points of touch object display
			/////////////////////////////////////////////////////////////////////////////////
			
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
		
		///////////////////////////////////////////////////////////////////////////////////
		// draw orientation data
		///////////////////////////////////////////////////////////////////////////////////
			
			/////////////////////////////////////////////////////////////////////////////
			// draw orientation		
			if (N == 5)
			{
				// draw thimb ring
				graphics.lineStyle(style.t_stroke_thickness,style.t_stroke_color, style.t_stroke_alpha);
				
					//trace("thumb",cO.thumbID)
					for (var i:int = 0; i < N; i++) 
						{
						if (pointList[i].id == cO.thumbID) graphics.drawCircle(pointList[i].x, pointList[i].y, 40);
						}
						
				// draw orientation vector based on 4 fingers / draw hand vector
				graphics.moveTo(cO.x, cO.y);
				graphics.lineTo(cO.x + cO.orient_dx * 3, cO.y + cO.orient_dy * 3);
			}
			
			
			///////////////////////////////////////////////////////////////////////////////////
			// draw stroke data
			///////////////////////////////////////////////////////////////////////////////////
			///////////////////////////////////////////////////////////////////////////////////////
						
				// draw stroke
				if((N)&&(path_data)){
						
				//trace("drawVectors stroke",path_data[0].x, path_data[0].y)
							
					// SAMPLE PATH
						if (path_data[0])
							{
							graphics.moveTo(path_data[0].x, path_data[0].y)
							
							
							for (var p:int = 0; p < path_data.length ; p++) 
							{
								var t:Number = 3//0.1*(path_data[p].w + path_data[p].h) * 0.5 -5
								//style.stroke_thickness
								//trace(t)
								//trace(path_data[p].w , path_data[p].h);
								graphics.lineStyle(t, style.stroke_color, style.stroke_alpha);
								graphics.lineTo(path_data[p].x, path_data[p].y);
							}
							
							// REFERNCE PATHS//////////////////////////////////////
							var gn:int = ts.gO.pOList.length
							var a:Number = 0.15;
							var d:Number = 35;
							
							for (var b:int = 0; b < gn; b++ )
							{
								var ref_path:Array = ts.gO.pOList[b].gmlPath
								//var ref_path:Array = ts.cO.path_data;
								
								if (ref_path[0])
								{
									graphics.moveTo(a*ref_path[0].x, a*ref_path[0].y+d*b)
									graphics.lineStyle(1, 0xFF0000, style.stroke_alpha);
								
									for (var q:int = 0; q < ref_path.length ; q++) 
									{
										graphics.lineTo(a*ref_path[q].x, a*ref_path[q].y+d*b);
									}
								}
							}
							///////////////////////////////////////////////////////
							}
				}
		}
			
			
	private function draw_motion_cluster():void 
	{	
		//trace("MOTION CLUSTER DRAW");
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
					
					//trace("pair list length",lines,cO.pairList.length)
					
					if (lines <= cO.pairList.length)
					{
						//trace("ggg");
						for (var pn:int = 0; pn < lines; pn++) //5
						//for (var pn:int = 0; pn < cO.motionArray.length-2; pn++) //4
						{
							var pA:MotionPointObject = cO.pairList[pn].pointA;
							var pB:MotionPointObject = cO.pairList[pn].pointB;
							
							//trace(pA,pB);
							
							if ((pA!=undefined) && (pB!=undefined))
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
						for (var pn:int = 0; pn < cO.iPointArray.length; pn++) 
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