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
package com.gestureworks.analysis
{
	
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.display.DisplayObjectContainer;
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	
	import flash.geom.Vector3D;
	import flash.text.*;
	
	import com.gestureworks.managers.MotionPointHistories;
	import com.gestureworks.core.CML;
	import com.gestureworks.core.GestureGlobals;
	import com.gestureworks.core.gw_public;
	
	import com.gestureworks.objects.MotionPointObject;
	import com.gestureworks.objects.PointObject;
	import com.gestureworks.objects.ClusterObject;
	
	import com.gestureworks.utils.AddSimpleText;
	


	public class PointVisualizer extends Sprite//Shape//Container
	{
		private static var cml:XMLList;
		public var style:Object; // public allows override of cml values
		private var id:Number = 0;
		
		private var cO:ClusterObject;
		private var ts:Object;
		private var N:int = 0;
		private var mptext_array:Array = new Array();
		private var tptext_array:Array = new Array();
		private var i:int
		private var hist:int = 0;
		
		
		public function PointVisualizer(ID:Number)
		{
			//trace("points visualizer");	
			id = ID;
			ts = GestureGlobals.gw_public::touchObjects[id];
			cO = ts.cO;
			hist = 8;
			
			
			// set default style 
			style = new Object
				//points
				style.stroke_thickness = 6;
				style.stroke_color = 0xFFAE1F;
				style.stroke_alpha = 0.9;
				style.fill_color = 0xFFAE1F;
				style.fill_alpha = 0.6;
				style.radius = 20;
				style.height = 20;
				style.width = 20;
				style.shape = "circle-fill";
				style.trail_shape = "curve";
				
				
				
				// create text fields
				for (var i:int = 0; i < 12; i++) 
				{
					mptext_array[i] = new AddSimpleText(500, 100, "left", 0x777777, 12);
						//mptext_array[i].mouseChildren = true;
					tptext_array[i] = new AddSimpleText(200, 100, "left", 0x000000, 12);
						//tptext_array[i].mouseChildren = true;
					addChild(tptext_array[i]);
					addChild(mptext_array[i]);
				}
		}
			
	
	public function draw():void
	{
		//update data
		N = cO.pointArray.length
		
		// clar graphics
		graphics.clear();
		
		// draw
		draw_touchPoints();
		draw_motionPoints();
		//draw_sensorPoints();
	}
		
		
		////////////////////////////////////////////////////////////
		// touch points
		////////////////////////////////////////////////////////////
		public function draw_touchPoints():void
		{
			
			// clear text
			for (i = 0; i < 12; i++) tptext_array[i].visible = false;
			
				for (i = 0; i < N; i++) 
				{
					var pt:PointObject = cO.pointArray[i]
					///////////////////////////////////////////////////////////////////
					// Point positons and shapes
					///////////////////////////////////////////////////////////////////
					
					var x:Number = pt.x
					var y:Number = pt.y
					
					if (_drawText)
					{
						///////////////////////////////////////////////////////////////////
						//
						///////////////////////////////////////////////////////////////////
						tptext_array[i].textCont = "Point: " + "ID" + String(pt.touchPointID) + "    id" + String(pt.id);
						tptext_array[i].x = x;
						tptext_array[i].y = y - 50;
						tptext_array[i].visible = true;
					}
					
					if (_drawShape)
					{
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
					
					}
					/////////////////////////////////////////////////////////////////
					// point vectors
					/////////////////////////////////////////////////////////////////
					
					if (_drawVector)
					{
						//define vector pint style
						//graphics.lineStyle(style.v_stroke,style.color,style.alpha);
						hist  = pt.history.length - 1;
						if (hist < 0) hist = 0;
						var alpha:Number = 0;
						
							if (style.trail_shape == "line")
							{
										alpha = 0.08*(hist-j)
										graphics.lineStyle(style.stroke_thickness, style.stroke_color, alpha);
										graphics.moveTo(pt.history[0].x, pt.history[0].y);
										graphics.lineTo(pt.history[hist].x,pt.history[hist].y);
									
								}
							if (style.trail_shape == "curve") {
								
										for (var j:int = 0; j < hist; j++) 
										{
											if (j + 1 <= hist) {
												alpha = 0.08 * (hist - j)
												graphics.lineStyle(style.stroke_thickness, style.stroke_color, alpha);
												graphics.moveTo(pt.history[j].x, pt.history[j].y);
												graphics.lineTo(pt.history[j + 1].x, pt.history[j + 1].y);
											}
										}
							}
							if (style.trail_shape == "ring") {
									
										for (var k:int = 0; k < hist; k++) 
										{
											alpha = 0.08 * (hist - j)
											graphics.lineStyle(style.stroke_thickness, style.stroke_color,alpha);
											graphics.drawCircle(pt.history[j].x, pt.history[j].y, style.radius);
										}
							}
						}
						///////////////////////////////////////////////////////////////////////
						
					}
		}		
				
				
		/////////////////////////////////////////////////////////////////////
		// motion points
		///////////////////////////////////////////////////////////////////
		private function draw_motionPoints():void
		{
				
					// clear text
					if (_drawText)	for (i = 0; i < 12; i++) mptext_array[i].visible = false;
				
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

											if (_drawShape)
											{
												//  draw point 
												graphics.lineStyle(4, 0x6AE370, style.stroke_alpha);
												graphics.drawCircle(mp.position.x ,mp.position.y, style.radius + 20 + zm);	
												graphics.beginFill(0x6AE370, style.fill_alpha);
												graphics.drawCircle(mp.position.x, mp.position.y, style.radius);
												graphics.endFill();
												
												graphics.lineStyle(4, 0xFFFFFF, style.stroke_alpha);
												graphics.drawCircle(mp.palmplane_position.x ,mp.palmplane_position.y, style.radius + 20 + zm);	
												
											}
											if (_drawText)
											{
												//drawPoints ID of point
												mptext_array[i].x = mp.position.x + 50;
												mptext_array[i].y = mp.position.y - 50;
												mptext_array[i].visible = true;
												mptext_array[i].textCont = String(mp.fingertype) + ": ID:" + String(mp.motionPointID) + "\n"
																		+ "Thumb prob: " + (Math.round(1 * mp.thumb_prob)) +  "\n" 
																		+ "N length: " + (Math.round(100 * mp.normalized_length)) * 0.01 + " length: " + (Math.round(mp.length)) + "\n"
																		+ "N palm angle: " + (Math.round(100 * mp.normalized_palmAngle)) * 0.01 + " palm angle: " + (Math.round(100 * mp.palmAngle)) * 0.01 +"\n"
																		+ "max_length: " + Math.round(mp.max_length) + " min_length: "+ Math.round(mp.min_length) + " length: "+ Math.round(mp.length) + " Extension: " + mp.extension + "%"; 
																		//" width: "+ Math.round(100*mp.width)*0.01 +
											}	
									}
									
									
									if (mp.type == "palm")
									{
										////////////////////////////////////////////////////
										//// draw hand data
										////////////////////////////////////////////////////
										if (_drawShape)
											{
												var hz:Number = mp.position.z
												var sq_width:Number = 5;

												// palm center
												graphics.lineStyle(2, 0x716BE3, style.stroke_alpha);
												graphics.drawRect(mp.position.x - sq_width, mp.position.y - sq_width, 2 * sq_width, 2 * sq_width);
												
												graphics.lineStyle(2, 0xFFFFFF, style.stroke_alpha);
												
												//trace(mp.direction)
												var pt1:Vector3D = mp.direction.crossProduct(mp.normal);
												
												//palm plane
												graphics.moveTo(mp.position.x,mp.position.y);
												graphics.lineTo(mp.position.x + pt1.x, mp.position.y + pt1.y);
												
												//normal
												graphics.moveTo(mp.position.x,mp.position.y);
												graphics.lineTo(mp.position.x + 50*mp.normal.x, mp.position.y + 50*mp.normal.y);
											}

											if (_drawText)
											{
												//drawPoints ID of point
												mptext_array[i].textCont = "Palm: " + "ID" + String(mp.motionPointID) + "    id" + String(mp.id);
												mptext_array[i].x = mp.position.x;
												mptext_array[i].y = mp.position.y - 50;
												mptext_array[i].visible = true;
											}
									}
							}
		}

////////////////////////////////////////////////////////////////
// sensor points
////////////////////////////////////////////////////////////////
private function draw_sensorPoints():void 
	{
	
	// draw virtual accelerometer point
	
		// draw shape
		// draw vector
	
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
	
	
	/**
	* @private
	*/
	private var _drawShape:Boolean = true;
	/**
	* activates gesture point shape visualization methods.
	*/
	public function get drawShape():Boolean { return _drawShape; }
	public function set drawShape(value:Boolean):void { _drawShape = value; }
	
	/**
	* @private
	*/
	private var _drawVector:Boolean = false;
	/**
	* activates gesture point shape visualization methods.
	*/
	public function get drawVector():Boolean { return _drawVector; }
	public function set drawVector(value:Boolean):void { _drawVector = value; }
	
	/**
	* @private
	*/
	private var _drawText:Boolean = true;
	/**
	* activates gesture point shape visualization methods.
	*/
	public function get drawText():Boolean { return _drawText; }
	public function set drawText(value:Boolean):void{_drawText = value;}

}
}