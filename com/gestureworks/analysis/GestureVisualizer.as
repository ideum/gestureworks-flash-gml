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
	import com.gestureworks.objects.StrokeObject;
	
	

	public class GestureVisualizer extends Shape
	{	
		private static var cml:XMLList;
		public var style:Object;
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
				style.fill_alpha = 0.1;
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
		
		// clear
		graphics.clear();
		
		// draw
		draw_touch_gesture();
		draw_motion_gesture();
		//draw_sensor_gesture();
		
	}
	
	private function draw_touch_gesture():void
	{
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
				
				////////////////////////////////////////////////////////////////////////////////////////////
				//discrete drawing methods
				//appear then fade out
				
				// 1 create on gesture event draw on gesture coordinates
				// 2 track no move redraw (make reusable stack)
				// 3 fade out / animate riple
				
				
				// draw flick (5)
				
				// draw swipe (5)
				
				// draw scroll // vert/horiz
				
				
				// draw tap (10)
			
				// draw double tap (10)
				
				// draw hold 
				
				
				//sequence 
				// draw hold tap
				// draw hold flick
				
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
						
						/*
						if (cO.history) {
							
							if (cO.history[h].ipointArray[0])
							{
							graphics.moveTo (cO.history[0].ipointArray[0].x, cO.history[0].ipointArray[0].x);

							for (var h:int = 1; h < cO.history.length; h++) 
									{
									graphics.lineTo (cO.history[h].ipointArray[0].x, cO.history[h].ipointArray[0].y);
									//trace("velocity", cO.dx, cO.dy, cO.dz)
									}
							}
						}*/
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
	private var _drawPivot:Boolean = true;
	/**
	* draw Rotation.
	*/
	public function get drawPivot():Boolean { return _drawPivot; }
	public function set drawPivot(value:Boolean):void { _drawPivot = value; }
	
	
	
}
}