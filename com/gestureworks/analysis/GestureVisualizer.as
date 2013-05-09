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
		}
			
		public function init():void
		{
			//trace("init")
			ts = GestureGlobals.gw_public::touchObjects[id]; // CHANGE TO TRANSFORMATION OBJECT CENTER POINT
			trO = ts.trO;// points to sprite
			sO = ts.sO
			cO = ts.cO;
			gO = ts.gO;
			
			
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

					if(gestureEventArray.length)trace("gesture event array--------------------------------------------",gestureEventArray.length);
							
						
								for (var j:uint = 0; j < gestureEventArray.length; j++) 
									{
									var x:Number = gestureEventArray[j].value.x;
									var y:Number = gestureEventArray[j].value.y;
									trace("draw gesture event:",gestureEventArray[j].type, x, y);
									
									
									//if (gestureEventArray[j].type =="manipulate")
										
									
									
									if (gestureEventArray[j].type =="drag")
										{
											trace("visualizwe DRAG")
											graphics.lineStyle(style.stroke_thickness, style.stroke_color, style.stroke_alpha);
											graphics.moveTo(x, y);
											graphics.moveTo(x + gestureEventArray[j].value.dx*10, y + gestureEventArray[j].value.dy*10);
										}
										
										// draw scale
								if (gestureEventArray[j].type =="scale")
										{
											trace("visualize scale")
											graphics.lineStyle(style.stroke_thickness, style.stroke_color, style.stroke_alpha);
											graphics.moveTo(x, y);
											graphics.moveTo(x + gestureEventArray[j].value.dx*10, y + gestureEventArray[j].value.dy*10);
										}
										
										// draw rotate
										// draw scroll // vert/horiz
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

						if(gestureEventArray.length)trace("gesture event array--------------------------------------------",gestureEventArray.length);
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
									trace("draw gesture event:",gestureEventArray[j].type, x, y);
									
									//object phase
									// start // active // release // passive // complete
									
									
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
									
									
									//trace(gestureEventArray[j].type,event.value.gestureID,gestureEventArray[j].value.gestureID);
									if ((gestureEventArray[j].type =="hold")&&(i<hold_linger))
										{
											// hold gesture square
											graphics.lineStyle(style.stroke_thickness, style.stroke_color, style.stroke_alpha);
											graphics.beginFill(style.fill_color, style.fill_alpha);
											//graphics.drawRect(x - style.width, y - style.width, 2 * style.width, 2 * style.width);
											graphics.drawRect(x - style.width , y- style.width ,  2*style.width,  2*style.width);
											graphics.endFill();
										}
										

										// draw flick (5)
										// draw swipe (5)
										
										//sequence 
										// draw hold tap
										// draw hold flick
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
							if (cO.iPointArray[pn].type == "pinch") graphics.lineStyle(4, 0xE3716B, style.stroke_alpha);
							//PURPLE 0xc44dbe // for trigger
							if (cO.iPointArray[pn].type == "trigger") graphics.lineStyle(4, 0xc44dbe, style.stroke_alpha);
							//yellow 0xFFFF00 // for PUSH
							if (cO.iPointArray[pn].type == "push") graphics.lineStyle(4, 0xFFFF00, style.stroke_alpha);
							
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