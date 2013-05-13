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
package com.gestureworks.analysis
{
	import flash.display.Shape;
	import flash.geom.Vector3D;
	
	import com.gestureworks.core.CML;
	import com.gestureworks.core.GestureGlobals;
	import com.gestureworks.core.gw_public;
	
	import com.gestureworks.objects.PointObject;
	import com.gestureworks.objects.MotionPointObject;
	//import com.gestureworks.objects.SensorPointObject;
	
	import com.gestureworks.objects.ClusterObject;
	import com.gestureworks.objects.TransformObject;
	import com.gestureworks.objects.GestureListObject;
	import com.gestureworks.objects.StrokeObject;
	
	

	public class GestureVisualizer extends Shape
	{	
		private static const RAD_DEG:Number = 180 / Math.PI;
		
		private static var cml:XMLList;
		public var style:Object;
		private var ts:Object;
		private var cO:ClusterObject;
		private var sO:StrokeObject;
		private var gO:GestureListObject;
		
		private var trO:TransformObject;
		private var id:Number = 0;
		private var pointList:Vector.<PointObject>
		private var N:int = 0;
		private var path_data:Array = new Array();
		private var gn:int = 0;
		
		
		private var orientation:Number = 0
		private var step:Number =  0
		private var percent:Number = 0
		private var r2:Number = 0
		private var r1:Number = 0
		private var sA:Number = 0
		private var eA:Number = 0
		private var numSteps:Number = 0
		
		
		public function GestureVisualizer(ID:Number)
		{
			//trace("gesture visualizer");
			id = ID;
			
			/////////////////////////////////////////////
			// set default style 
			/////////////////////////////////////////////

			style = new Object
				style.stroke_thickness = 4;
				style.stroke_color = 0x9BD6EA;
				style.stroke_alpha = 0.9;
				style.fill_color = 0x9BD6EA;
				style.fill_alpha = 0.4;
				style.radius = 10;
				style.width = 50;
				style.line_type = "dashed"
				
				style.a_stroke_thickness = 2;
				style.a_stroke_color = 0x4B7BCC;
				style.a_stroke_alpha = 0.8;
				style.a_fill_color = 0x9BD6EA;
				style.a_fill_alpha = 0.3;
				style.b_stroke_thickness = 2;
				style.b_stroke_color = 0xFF0000;
				style.b_stroke_alpha = 0.2;
				style.b_fill_color = 0xFF0000;
				style.b_fill_alpha = 0.3;
				style.rotation_shape = "segment";
				style.rotation_radius = 200;	
				style.percent = 0.7
				
				
		}
			
		public function init():void
		{
			//trace("init")
			ts = GestureGlobals.gw_public::touchObjects[id]; // CHANGE TO TRANSFORMATION OBJECT CENTER POINT
			trO = ts.trO;// points to sprite
			sO = ts.sO
			cO = ts.cO;
			gO = ts.gO;
			
			orientation = cO.orientation;
			
			
			
			
		}
			
	public function draw():void
	{	
		pointList = cO.pointArray;
		N = pointList.length;
		path_data = sO.path_data 
		gn = gO.pOList.length;
		
		// clear
		graphics.clear();
		
		// draw
		draw_touch_gesture();
		draw_motion_gesture();
		//draw_sensor_gesture();
		
	}
	
	private function draw_touch_gesture():void
	{
		
		var	gestureEventArray:Array = new Array();
		var	pointEventArray:Array = new Array();
				
		//trace("draw gesture", ts);
		
		/////////////////////////////////////////////////////////////////////////////////
		// draw pivot gesture vector
		/////////////////////////////////////////////////////////////////////////////////
		if (N)
		{
			
			
			if ((_drawPivot)&&(ts.trO.init_center_point) && (ts.trO.transformPointsOn))
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
			
				if((_drawTransformation)&&(trO.transAffinePoints)&&(trO.transformPointsOn)){
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
		
		
		///////////////////////////////////////////////////////////////////////////////////
		// draw orientation data
		///////////////////////////////////////////////////////////////////////////////////
			
			if ((_drawOrientation)&&(N == 5))
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

				if ((_drawStroke)&&(path_data))
				{	
				//trace("drawVectors stroke",path_data[0].x, path_data[0].y)
							
					// SAMPLE PATH
						if (path_data[0])
							{
							var t:Number = 2
							var rad:int = 2
							graphics.lineStyle(t, style.stroke_color, style.stroke_alpha);
							graphics.moveTo(path_data[0].x, path_data[0].y)
							
							for (var p:int = 0; p < path_data.length ; p++) 
							{
								//0.1*(path_data[p].w + path_data[p].h) * 0.5 -5
								//style.stroke_thickness
								//trace(t)
								//trace(path_data[p].w , path_data[p].h);
								
								graphics.lineTo(path_data[p].x, path_data[p].y);
								graphics.drawCircle(path_data[p].x, path_data[p].y, 2*rad);
								graphics.moveTo(path_data[p].x, path_data[p].y);
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
								
								//trace("gesture snippet",b, "\n\n\n",ts.gO.pOList[b].gesture_xml, "\n");
							}
							///////////////////////////////////////////////////////
							}
							
				}	
				
				
				
				
				
				/////////////////////////////////////////////////////////
				// draw continuous gesture events
				////////////////////////////////////////////////////////
				
				// based on timeline gesture events
				
					// gest current gesture event array from frame
					gestureEventArray = ts.tiO.frame.gestureEventArray;

					//if(gestureEventArray.length)trace("gesture event array--------------------------------------------",gestureEventArray.length);
							
						
								for (var j:uint = 0; j < gestureEventArray.length; j++) 
									{
									var x:Number = gestureEventArray[j].value.x;
									var y:Number = gestureEventArray[j].value.y;
									//trace("draw gesture event:",gestureEventArray[j],gestureEventArray[j].type, x, y);
									
									
									//if (gestureEventArray[j].type =="manipulate")
									//if (gestureEventArray[j].type =="rotate_scale")
									
									
									if (gestureEventArray[j].type =="drag")
										{
											var df:Number = 5;
											var dx:Number = gestureEventArray[j].value.drag_dx*df
											var dy:Number = gestureEventArray[j].value.drag_dy*df
											//trace("visualize gesture drag", x, y,dx,dy)
											
											graphics.lineStyle(10, style.stroke_color, style.stroke_alpha);
											graphics.moveTo(x, y);
											graphics.lineTo(x + dx, y + dy);
										}
										
									// draw scale
									if (gestureEventArray[j].type =="scale")
										{
											var scf:Number = 50;
											var ds:Number = gestureEventArray[j].value.scale_dsx * scf;
											//var dy:Number = gestureEventArray[j].value.scale_dsy * scf;
											
											///trace("visualize gesture scale", x,y, ds)
											
											if (ds < -0.1) // contract
											{
												graphics.lineStyle(30 +2*Math.abs(ds) ,0x9BD6EA,0.3);
												graphics.drawCircle(x, y, cO.radius +50);
											}
											else if (ds > 0.1) //expand
											{
												graphics.lineStyle(30 +2*Math.abs(ds) ,0xFF0000,0.3);
												graphics.drawCircle(x, y, cO.radius +50);
											}
											
											
										}
										
									// draw rotate
									if (gestureEventArray[j].type =="rotate")
									{
										var rf:Number = 10;
										var dtheta:Number = gestureEventArray[j].value.rotate_dtheta;
										var dx:Number = 50 * Math.cos(rf * dtheta); 
										var dy:Number = 50 * Math.sin(rf * dtheta);
										
										//if (style.rotation_shape == "slice") {
										
										step =  0.01;
										percent = style.percent;
										numSteps = Math.abs(Math.round(dtheta / step));
										r2 = cO.radius * percent;
										r1 = cO.radius * (percent + 0.2);
													
										if(Math.abs(orientation)>=360){
											orientation = 0;
										}
										sA = orientation/RAD_DEG
										eA = orientation / RAD_DEG + dtheta;
					
												//trace("redraw slice", rotation, dtheta);
												if (dtheta < 0)
												{
													graphics.lineStyle(style.a_stroke_thickness, style.a_stroke_color, style.a_stroke_alpha);
													graphics.beginFill(style.a_fill_color, style.a_fill_alpha);
													
													graphics.moveTo(x, y);
													graphics.lineTo(x + cO.radius * Math.cos(sA), y + cO.radius * Math.sin(sA));
													
													for (var theta3:Number = sA; theta3 > eA; theta3 -= step) {
														graphics.lineTo(x + cO.radius * Math.cos(theta3), y + cO.radius * Math.sin(theta3));
													}
													graphics.lineTo(x, y);
													graphics.endFill();
												}
												
												if (dtheta > 0)
												{
													graphics.lineStyle(style.b_stroke_thickness, style.b_stroke_color, style.b_stroke_alpha);
													graphics.beginFill(style.b_fill_color,style.b_fill_alpha);
												
													graphics.moveTo(x, y);
													graphics.lineTo(x + cO.radius * Math.cos(sA), y + cO.radius * Math.sin(sA));
													
													for (var theta4:Number = sA; theta4 < eA; theta4 += step) {
														graphics.lineTo(x + cO.radius * Math.cos(theta4), y + cO.radius * Math.sin(theta4));
													}
													graphics.lineTo(x, y);
													graphics.endFill();
												}
											//}	
										}
	
									// SYLE AS ARROW
									// draw scroll // vert/horiz
									if (gestureEventArray[j].type =="scroll")
									{
										var slf:Number = 10;
										var dx:Number = slf * gestureEventArray[j].value.scroll_dx; 
										var dy:Number = slf * gestureEventArray[j].value.scroll_dy;
										
										//trace("visualize gesture scroll", x,y,dx,dy)
										graphics.lineStyle(style.stroke_thickness, style.stroke_color, style.stroke_alpha);
										graphics.moveTo(x, y);
										graphics.lineTo(x + dx, y +dy);
									}
									
									}

		}
		
		
		////////////////////////////////////////////////////////////////////////////////////////////
				//discrete drawing methods
				//appear then fade out
				
				// 1 create on gesture event draw on gesture coordinates
				// 2 track no move redraw (make reusable stack)
				// 3 fade out / animate riple
				
				
				// SCAN TIMELINE
				// LOOK FOR GESTURE EVENTS
				// IF CONTINUOUS SHOW ONLY IF KEYFRAME
				// IF DISCRETE DISPLAY IF ON TIMELINE SEGMENT (500ms or 30 frames)
				// SEGMENT TIME IS LINGER TIME!!!!
				
				//var	gestureEventArray:Array = new Array();
				//var	pointEventArray:Array = new Array();
				var scan_time:int = 60; //1000ms
				var hold_linger:int = 30;
				var tap_linger:int = 30;
				
				ts.tiO.timelineOn = true;
				ts.tiO.gestureEvents = true;
				
				
				
				//trace("visulaize event frame",ts.tiO.timelineOn,ts.tiO.history.length,GestureGlobals.frameID);
				
				
				for (i = 0; i < scan_time; i++) 
					{
					if (ts.tiO.history[i])
						{
						gestureEventArray = ts.tiO.history[i].gestureEventArray;
						pointEventArray = ts.tiO.history[i].pointEventArray;

						//if(gestureEventArray.length)trace("gesture event array--------------------------------------------",gestureEventArray.length);
						//if(pointEventArray.length)trace("point event array--------------------------------------------",pointEventArray.length);
								
								/*
								for (var j:uint = 0; j < pointEventArray.length; j++) 
									{
										var px:Number = pointEventArray[j].stageX;
										var py:Number = pointEventArray[j].stageY;
										//trace("draw point event:", pointEventArray[j].type, px, py);
										
										if ((pointEventArray[j].type =="touchBegin")&&(i<tap_linger))
										{
											// tap gesture ring
											//graphics.lineStyle(style.stroke_thickness, style.stroke_color, style.stroke_alpha);
											//graphics.drawCircle(px, py, style.radius + 20);
										}
										
										if ((pointEventArray[j].type =="touchEnd")&&(i<tap_linger))
										{
											// tap gesture ring
											//graphics.lineStyle(style.stroke_thickness, style.stroke_color, style.stroke_alpha);
											//graphics.drawCircle(px, py, style.radius + 20);
										}
									
									}*/
						
								for (var j:uint = 0; j < gestureEventArray.length; j++) 
									{
										
									var x:Number = gestureEventArray[j].value.x;
									var y:Number = gestureEventArray[j].value.y;
									//trace("draw gesture event:",gestureEventArray[j].type, x, y, gestureEventArray[j].value.path_data);
									
									//object phase
									// start // active // release // passive // complete
									//if (gestureEventArray[j].type =="release")
									//if (gestureEventArray[j].type =="complete")
									
									if ((gestureEventArray[j].type =="tap")&&(i<tap_linger))
										{
											// tap gesture ring
											graphics.lineStyle(style.stroke_thickness+2, style.stroke_color, 0.35);
											graphics.drawCircle(x, y, style.radius + 15);
										}
									
										if ((gestureEventArray[j].type =="double_tap")&&(i<tap_linger))
										{
											// tap gesture ring
											graphics.lineStyle(style.stroke_thickness+3, style.stroke_color, 0.45);
											graphics.drawCircle(x, y, style.radius + 30);
										}
										
										if ((gestureEventArray[j].type =="triple_tap")&&(i<tap_linger))
										{
											// tap gesture ring
											graphics.lineStyle(style.stroke_thickness+4, style.stroke_color, 0.55);
											graphics.drawCircle(x, y, style.radius + 50);
										}
									
									
										if ((gestureEventArray[j].type =="hold")&&(i<hold_linger))
										{
											// hold gesture square
											graphics.lineStyle(style.stroke_thickness, style.stroke_color, style.stroke_alpha);
											graphics.beginFill(style.fill_color, style.fill_alpha);
											graphics.drawRect(x - style.width , y- style.width ,  2*style.width,  2*style.width);
											graphics.endFill();
										}
										// SYLE AS ARROW
										// draw flick
										if ((gestureEventArray[j].type =="flick")&&(i<tap_linger))
										{
											// flick gesture double headed arrow
											graphics.lineStyle(style.stroke_thickness+4, style.stroke_color, 0.55);
											//graphics.drawCircle(x, y, style.radius + 50);
											trace("visualize flick");
										}
										// SYLE AS ARROW
										// draw swipe
										if ((gestureEventArray[j].type =="swipe")&&(i<tap_linger))
										{
											// swipe gesture arrow
											graphics.lineStyle(style.stroke_thickness+4, style.stroke_color, 0.55);
											//graphics.drawCircle(x, y, style.radius + 50);
											trace("visualize swipe");
										}
										
										// draw stroke
										if ((gestureEventArray[j].type =="stroke")||(gestureEventArray[j].type =="stroke_symbol")||(gestureEventArray[j].type =="stroke_greek")||(gestureEventArray[j].type =="stroke_shape")||(gestureEventArray[j].type =="stroke_number")||(gestureEventArray[j].type =="stroke_letter"))
										{
											if (i < tap_linger)
											{
											var x0:Number = gestureEventArray[j].value.x0;
											var y0:Number = gestureEventArray[j].value.y0;
											var ref_path:Array = gestureEventArray[j].value.path;
												
											// stroke gesture normalized ref path
											graphics.lineStyle(style.stroke_thickness + 4, style.stroke_color, 0.55);
											
											// SELECTED REFERNCE PATH//////////////////////////////////////
												if (ref_path[0])
												{
													graphics.moveTo(x0, y0)
													
													for (var q:int = 0; q < ref_path.length ; q++) 
													{
														graphics.lineTo(x0 + ref_path[q].x, x0 + ref_path[q].y);
													}
												}
											}
										}
										
										//gesture sequences 
										// draw hold tap
										// draw hold dtap
										// draw hold flick
										// draw hold scale
										// draw hold rotate
									}
							}
						}
		
		
	}
			
	private function draw_motion_gesture():void 
	{	

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
							if (cO.iPointArray[pn].type == "pinch") {
								
								graphics.lineStyle(4, 0xE3716B, style.stroke_alpha);
								graphics.drawCircle(cO.iPointArray[pn].position.x, cO.iPointArray[pn].position.y, 8);
								
								}
						
							
							//PURPLE 0xc44dbe // for trigger
							if (cO.iPointArray[pn].type == "trigger") {
								
								var tgr:Number = 40;
								
								
								// set style
								graphics.lineStyle(4, 0xc44dbe, style.stroke_alpha);
								// draw cross
								graphics.moveTo (cO.iPointArray[pn].position.x - tgr, cO.iPointArray[pn].position.y);
								graphics.lineTo (cO.iPointArray[pn].position.x + tgr , cO.iPointArray[pn].position.y);
								graphics.moveTo (cO.iPointArray[pn].position.x, cO.iPointArray[pn].position.y- tgr);
								graphics.lineTo (cO.iPointArray[pn].position.x, cO.iPointArray[pn].position.y + tgr);
								//draw cricle
								graphics.drawCircle(cO.iPointArray[pn].position.x, cO.iPointArray[pn].position.y, tgr - 10);
								
								// get thum id
								// check extension
								
								if (cO.iPointArray[pn].extension < 40) {
									graphics.drawCircle(cO.iPointArray[pn].position.x, cO.iPointArray[pn].position.y, 50);
								}
						
							}
							
							//yellow 0xFFFF00 // for PUSH
							if (cO.iPointArray[pn].type == "push") 
							{
								graphics.lineStyle(4, 0xFFFF00, style.stroke_alpha);
								graphics.drawCircle(cO.iPointArray[pn].position.x, cO.iPointArray[pn].position.y, 8);
							}
							
							
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
						
						
						///////////////////////////////////////////////////////////////////////////////////////
						// draw interactionPoint path
						
						var hist = cO.history.length-1;
						
						//trace("hist",hist)
						//if (cO.iPointArray[pn].type == "pinch") graphics.lineStyle(1, 0xE3716B, style.stroke_alpha);
						//if (cO.iPointArray[pn].type == "trigger") graphics.lineStyle(1, 0xc44dbe, style.stroke_alpha);
						
						if (cO.history[0]) 
						{
							if (cO.history[0].iPointArray.length) 
							{
								if (cO.history[0])
								{
									
										
										/////////////////
										
										if ((cO.history[0].iPointArray.length) && (cO.history[0].iPointArray[0])) 
										{
											graphics.moveTo (cO.history[0].iPointArray[0].position.x, cO.history[0].iPointArray[0].position.y);
											graphics.drawCircle(cO.history[0].iPointArray[0].position.x, cO.history[0].iPointArray[0].position.y, 8);
										
											for (var h:int = 1; h < cO.history.length; h++) 
												{
												if ((cO.history[h].iPointArray.length) && (cO.history[h].iPointArray[0])) 
												{
													graphics.lineTo (cO.history[h].iPointArray[0].position.x, cO.history[h].iPointArray[0].position.y);
													//graphics.drawCircle(cO.history[h].iPointArray[0].position.x, cO.history[h].iPointArray[0].position.y, 8);
													//graphics.moveTo (cO.history[h].iPointArray[0].position.x, cO.history[h].iPointArray[0].position.y);
												//trace("velocity", cO.dx, cO.dy, cO.dz)
												}
											}
										}
										
										////////////////
										
								}
							}
						}
		}	
	

	public function clear():void
	{
		graphics.clear();
	}

	
	
	/**
	* @private
	*/
	private var _drawOrientation:Boolean = true;
	/**
	* draw Orientation.
	*/
	public function get drawOrientation():Boolean { return _drawOrientation; }
	public function set drawOrientation(value:Boolean):void { _drawOrientation = value; }
	
	/**
	* @private
	*/
	private var _drawTransformation:Boolean = true;
	/**
	* draw Transformation.
	*/
	public function get drawTransformation():Boolean { return _drawTransformation; }
	public function set drawTransformation(value:Boolean):void { _drawTransformation = value; }
	
	/**
	* @private
	*/
	private var _drawStroke:Boolean = true;
	/**
	* draw Stroke.
	*/
	public function get drawStroke():Boolean { return _drawStroke; }
	public function set drawStroke(value:Boolean):void { _drawStroke = value; }
	
	/**
	* @private
	*/
	private var _drawRotation:Boolean = true;
	/**
	* draw Rotation.
	*/
	public function get drawRotation():Boolean { return _drawRotation; }
	public function set drawRotation(value:Boolean):void { _drawRotation = value; }
	
	/**
	* @private
	*/
	private var _drawPivot:Boolean = false;
	/**
	* draw Rotation.
	*/
	public function get drawPivot():Boolean { return _drawPivot; }
	public function set drawPivot(value:Boolean):void { _drawPivot = value; }
	
	
	
}
}