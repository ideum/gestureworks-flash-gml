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
package com.gestureworks.visualizer
{
	
	import com.gestureworks.core.GestureWorks;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.display.DisplayObjectContainer;
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.events.Event;
	import flash.geom.Matrix;
	import flash.utils.Dictionary;
	
	import flash.geom.Vector3D;
	import flash.text.*;
	

	import com.gestureworks.core.GestureGlobals;
	import com.gestureworks.core.CoreSprite;
	import com.gestureworks.core.gw_public;
	
	
	import com.gestureworks.objects.SensorPointObject;
	import com.gestureworks.objects.MotionPointObject;
	import com.gestureworks.objects.TouchPointObject;
	
	
	import com.gestureworks.utils.AddSimpleText;
	


	public class CorePointVisualizer extends Shape//Container//Sprite
	{
		public var style:Object; // public allows override of cml values
		private var touchArray:Vector.<TouchPointObject>;
		private var motionArray:Vector.<MotionPointObject>;
		private var sensorArray:Vector.<SensorPointObject>;
		
		private var gs:CoreSprite;
		private var tpn:uint = 0;
		private var mpn:uint = 0;
		private var spn:uint = 0;
		//private var ipn:uint = 0;
		
		
		private var mptext_array:Array = new Array();
		private var tptext_array:Array = new Array();
		private var i:int
		private var hist:int = 0;
		
		//private var _minX:Number = -180;
		//private var _maxX:Number = 180;
		
		//private var _minY:Number = 75;
		//private var _maxY:Number = 270;
		
		//private var _minZ:Number = -110;
		//private var _maxZ:Number = 200;
		private var trails:Array = [];
		
		public var maxTrails:int = 50;
		public var maxPoints:int = 10;
		
		private var motionPoints:Dictionary = new Dictionary();
	
		
		public function CorePointVisualizer():void
		{			
			//trace("points visualizer");	
			touchArray = GestureGlobals.gw_public::touchArray;
			motionArray = GestureGlobals.gw_public::motionArray;
			sensorArray = GestureGlobals.gw_public::sensorArray;
			
			motionPoints = GestureGlobals.gw_public::motionPoints;
			//hist = 8;
			
			
			// set default style 
			style = new Object;
				//points
				style.stroke_thickness = 10;
				//style.stroke_color = 0xFFAE1F;
				//style.stroke_color = 0x107591;
				//style.stroke_color = 0x9BD6EA;
				style.stroke_color = 0xAADDFF;
				style.stroke_alpha = 0.9;
				//style.fill_color = 0xFFAE1F;
				//style.fill_color = 0x107591;
				//style.fill_color = 0x9BD6EA;
				style.fill_color = 0xAADDFF;
				style.fill_alpha = 0.6;
				style.radius = 20;
				style.height = 20;
				style.width = 20;
				style.shape = "circle-fill";
				style.trail_shape = "curve";
				style.motion_text_color = 0x777777;
				style.touch_text_color = 0x000000;
				
		}
		
		public function init():void
		{
			/*
			var i:int = 0;
			mptext_array[i];		
			tptext_array = [];
			trails = [];
			
			// create text fields
			for (i = 0; i < maxPoints; i++) 
			{
				mptext_array[i] = new AddSimpleText(500, 100, "left", style.motion_text_color, 12, "left");
					mptext_array[i].visible = false;
					mptext_array[i].mouseEnabled = false;
				tptext_array[i] = new AddSimpleText(200, 100, "left", style.touch_text_color, 12, "left");
					tptext_array[i].visible = false;
					tptext_array[i].mouseEnabled = false;
				addChild(tptext_array[i]);
				addChild(mptext_array[i]);
			}*/
		}
		
		
		public function draw():void
		{
			if (touchArray) tpn = touchArray.length;
			else tpn = 0;
			
			if (motionArray) mpn = motionArray.length;
			else mpn = 0;
			
			if (sensorArray) spn = sensorArray.length;
			else spn = 0;
			
			// clear graphics
			graphics.clear();
			
			//DRAW
			if (GestureWorks.activeTouch && tpn)		draw_touchPoints();
			if (GestureWorks.activeMotion && mpn)		draw_motionPoints();
			if (GestureWorks.activeSensor && spn)		draw_sensorPoints();

		}
		
		
		////////////////////////////////////////////////////////////
		// touch points
		////////////////////////////////////////////////////////////
		public function draw_touchPoints():void
		{
			// clear text
			//for (i = 0; i < maxPoints; i++) tptext_array[i].visible = false;
			
				var n:int = (tpn <= maxPoints) ? tpn : maxPoints;
			
				for (var i:uint = 0; i < n; i++) 
				{
					var pt:TouchPointObject = touchArray[i] as TouchPointObject;
					///////////////////////////////////////////////////////////////////
					// Point positons and shapes
					///////////////////////////////////////////////////////////////////
					
					var x:Number = pt.position.x;
					var y:Number = pt.position.y;
					
					/*
					if (_drawText)
					{
						///////////////////////////////////////////////////////////////////
						//
						///////////////////////////////////////////////////////////////////
						
						tptext_array[i].textCont = "TP ID: " + String(pt.id); //+ "    id" + String(pt.touchPointID);
						tptext_array[i].x = x - tptext_array[i].width / 2;
						tptext_array[i].y = y- 70;
						tptext_array[i].visible = true;
						tptext_array[i].textColor = style.touch_text_color;
					}*/
					
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
						else if (style.shape == "ring") {
							//trace("ring");
								graphics.lineStyle(style.stroke_thickness, style.stroke_color, style.stroke_alpha);
								graphics.drawCircle(x, y, style.radius);
						}
						else if (style.shape == "cross") {
							//trace("cross");
								graphics.lineStyle(style.stroke_thickness, style.stroke_color, style.stroke_alpha);
								graphics.moveTo (x - style.radius, y);
								graphics.lineTo (x + style.radius , y);
								graphics.moveTo (x, y - style.radius);
								graphics.lineTo (x, y + style.radius);
						}
						else if (style.shape == "triangle") {
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
						
						else if (style.shape == "circle-fill") {
							//trace("circle draw");
								graphics.lineStyle(style.stroke_thickness, style.stroke_color, style.stroke_alpha);							
								graphics.beginFill(style.fill_color, style.fill_alpha);
								graphics.drawCircle(x, y, style.radius);
								graphics.endFill();
						}
						else if (style.shape == "triangle-fill") {
							//trace("triangle fill");
								graphics.beginFill(style.fill_color, style.fill_alpha);
								graphics.moveTo (x - style.width, y -style.width);
								graphics.lineTo (x, y + style.width);
								graphics.lineTo (x + style.width, y - style.width);
								graphics.lineTo (x - style.width, y -style.width);
								graphics.endFill();
						
						}
						else if (style.shape == "square-fill") {
							//trace("square");
								graphics.beginFill(style.color, style.fill_alpha);
								graphics.drawRect(x - style.width, y - style.width, 2 * style.width, 2 * style.width);
								graphics.endFill();
						}
					
					}	
				}
		}		
			
		/////////////////////////////////////////////////////////////////////
		// motion points
		///////////////////////////////////////////////////////////////////
		public function draw_motionPoints():void
		{
					// clear text
					//if (_drawText)	for (i = 0; i < maxPoints; i++) mptext_array[i].visible = false;
				
					//trace("visualixer mpn",mpn,_drawText,cO.motionArray2D.length,cO.motionArray.length)
						
					// Calculate the hand's average finger tip position
					for (var i:uint = 0; i < mpn; i++) 
					//for (var key in motionPoints) 
								{
								var mp:MotionPointObject = motionArray[i] as MotionPointObject;
								//var mp:MotionPointObject = motionPoints[key];
								
								//trace(mp);
								
								if (mp)//&& mp.screen_position
								{
									/*
									if (_drawText)
									{
										//NOTE NEED MORE TEXT FIELDS
										if((mp)&&(tptext_array[i])){
										tptext_array[i].textCont = "MP ID: " + String(mp.motionPointID); //+ "    id" + String(pt.touchPointID);
										tptext_array[i].x = mp.screen_position.x - tptext_array[i].width / 2;
										tptext_array[i].y = mp.screen_position.y - 40;
										tptext_array[i].visible = true;
										tptext_array[i].textColor = style.touch_text_color;
									}
									}*/
								
									if (mp.type == "finger")
									{
										var zm:Number = mp.position.z * 0.2;
										var wm:Number = (mp.width) *10;
										//trace("length", finger.length);
										//trace("width", finger.width);
											
											if (_drawShape)
											{
												if (mp.fingertype == "thumb") 
												{
													//  draw finger point 
													graphics.lineStyle(4, 0xFF0000, style.stroke_alpha);
													graphics.drawCircle(mp.screen_position.x ,mp.screen_position.y, style.radius + 20 + zm);	
													
													graphics.beginFill(0xFF0000, style.fill_alpha);
													graphics.drawCircle(mp.screen_position.x, mp.screen_position.y, style.radius);
													graphics.endFill();
												}
												
												else
												{
													//  draw finger point 
													graphics.lineStyle(4, 0x6AE370, style.stroke_alpha);
													graphics.drawCircle(mp.screen_position.x ,mp.screen_position.y, style.radius + 20 + zm);	
													graphics.beginFill(0x6AE370, style.fill_alpha);
													graphics.drawCircle(mp.screen_position.x, mp.screen_position.y, style.radius);
													graphics.endFill();
												}
											}
											
											/*
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
											}	*/
									}
									
									
									if (mp.type == "palm")
									{
										////////////////////////////////////////////////////
										//// draw hand data
										////////////////////////////////////////////////////
										if (_drawShape)
											{
												// palm center
												graphics.lineStyle(2, 0xFFFFFF, style.stroke_alpha);
												graphics.drawCircle(mp.screen_position.x, mp.screen_position.y, style.radius+10+ mp.screen_position.z * 0.2);
												graphics.beginFill(0xFFFFFF, style.fill_alpha);
												graphics.drawCircle(mp.screen_position.x, mp.screen_position.y, style.radius-10);
												graphics.endFill();
												
												//normal
												graphics.lineStyle(2, 0xFF0000, style.stroke_alpha);
												graphics.moveTo(mp.screen_position.x,mp.screen_position.y);
												graphics.lineTo(mp.screen_position.x + 50 * mp.screen_normal.x, mp.screen_position.y + 50 * mp.screen_normal.y);
												
												//trace(mp.normal.x,mp.position.x,mp.direction.x)
											}
											
											/*
											if (_drawText)
											{
												//drawPoints ID of point
												mptext_array[i].textCont = "Palm: " + "ID" + String(mp.motionPointID) + "    id" + String(mp.id);
												mptext_array[i].x = mp.position.x;
												mptext_array[i].y = mp.position.y - 50;
												mptext_array[i].visible = true;
											}*/
									}
									
									
									
									if (mp.type == "eye")
									{
										if (_drawShape)
										{
											//trace("DRAWING EYE",mp.position);
											//draw finger point 
											graphics.lineStyle(4, 0x0000FF, style.stroke_alpha);
											graphics.drawCircle(mp.screen_position.x ,mp.screen_position.y, style.radius + 20);	
											
											
											graphics.lineStyle(4, 0x000000, style.stroke_alpha);
											graphics.beginFill(0x000000, style.fill_alpha);
											graphics.drawCircle(mp.screen_position.x, mp.screen_position.y, style.radius);
											graphics.endFill();
										}
									}
									if (mp.type == "gaze")
									{
										if (_drawShape)
										{
											//trace("DRAWING GAZE",mp.position);
											//draw finger point 
											graphics.lineStyle(4, 0xFFFFFF, style.stroke_alpha);
											graphics.drawCircle(mp.screen_position.x ,mp.screen_position.y, style.radius + 20);	
											
											graphics.beginFill(0x000000, style.fill_alpha);
											graphics.drawCircle(mp.screen_position.x, mp.screen_position.y, style.radius);
											graphics.endFill();
										}
									}		
									
									
								}
									
									
								}
					
	}

		
		
		////////////////////////////////////////////////////////////////
		// sensor points // eye tracking / accelerometer / myo
		////////////////////////////////////////////////////////////////
	public function draw_sensorPoints():void
		{
			//trace("drawing sensor points", spn);
				
			for (var i:uint = 0; i < spn; i++) 
					{
					var sp:SensorPointObject = sensorArray[i] as SensorPointObject;

					//trace("sensor type",sp.type, sp.devicetype, sp.acceleration.x);
					
					///////////////////////////////////////////
					// DRAW WII CONTROLLER POINT
					if (sp.type == "wiimote")
						{
							if (_drawShape)
							{
								// sensor center
								graphics.lineStyle(2, 0xFFFFFF, style.stroke_alpha);
								graphics.drawCircle(sp.position.x, sp.position.y, style.radius+10+ sp.position.z * 0.2);
								graphics.beginFill(0xFFFFFF, style.fill_alpha);
								graphics.drawRect(sp.position.x-style.radius+4,sp.position.y-style.radius+4,2*style.radius-8, 2*style.radius-8);
								graphics.endFill();
							}
						}
					
					//////////////////////////////////////////
					// DRAW NATIVE ACCELEROMETER
					if (sp.type == "nativeAccel")
					{	
						// draw virtual accelerometer point
						if (_drawShape)
						{
							// sensor center
							graphics.lineStyle(2, 0xFFFFFF, style.stroke_alpha);
							graphics.drawCircle(sp.position.x, sp.position.y, style.radius+10+ sp.position.z * 0.2);
							graphics.beginFill(0xFFFF00, style.fill_alpha);
							graphics.drawRect(sp.position.x-style.radius+4,sp.position.y-style.radius+4,2*style.radius-8, 2*style.radius-8);
							graphics.endFill();
						}
					}
						
					///////////////////////////////////////////
					// DRAW MYO CONTROLLER POINT
					if (sp.type == "myo")
						{
							if (_drawShape)
							{
								// sensor center
								graphics.lineStyle(2, 0xFFFFFF, style.stroke_alpha);
								graphics.drawCircle(sp.position.x, sp.position.y, style.radius+10+ sp.position.z * 0.2);
								graphics.beginFill(0x00FFFF, style.fill_alpha);
								graphics.drawRect(sp.position.x-style.radius+4,sp.position.y-style.radius+4,2*style.radius-8, 2*style.radius-8);
								graphics.endFill();
							}
						}
						
					}
	}
			
	public function clear():void
	{
			//trace("trying to clear");
			graphics.clear();
		
			/*
			//text clear
			for (i = 0; i < tptext_array.length; i++){
				tptext_array[i].visible = false;
			}
			for (i = 0; i < mptext_array.length; i++){
				mptext_array[i].visible = false;
			}	*/		
	}
	

	private var _drawShape:Boolean = true;
	/**
	* activates gesture point shape visualization methods.
	*/
	public function get drawShape():Boolean { return _drawShape; }
	public function set drawShape(value:Boolean):void { _drawShape = value; }
	

	private var _drawVector:Boolean = false;
	/**
	* activates gesture point shape visualization methods.
	*/
	public function get drawVector():Boolean { return _drawVector; }
	public function set drawVector(value:Boolean):void { _drawVector = value; }
	

	private var _drawText:Boolean = true;
	/**
	* activates gesture point shape visualization methods.
	*/
	public function get drawText():Boolean { return _drawText; }
	public function set drawText(value:Boolean):void{_drawText = value;}


}
}