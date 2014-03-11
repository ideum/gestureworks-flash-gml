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
	
	import flash.geom.Vector3D;
	import flash.text.*;
	
	import com.gestureworks.managers.MotionPointHistories;
	import com.gestureworks.core.CML;
	import com.gestureworks.core.GestureGlobals;
	import com.gestureworks.core.gw_public;
	
	import com.gestureworks.objects.InteractionPointObject;
	import com.gestureworks.objects.SensorPointObject;
	import com.gestureworks.objects.MotionPointObject;
	import com.gestureworks.objects.TouchPointObject;
	import com.gestureworks.objects.ClusterObject;
	
	import com.gestureworks.utils.AddSimpleText;
	


	public class PointVisualizer extends Sprite//Shape//Container
	{
		private static var cml:XMLList;
		public var style:Object; // public allows override of cml values
		private var id:Number = 0;
		private var iPointArray;
		
		
		private var ts:Object;
		private var tpn:uint = 0;
		private var mpn:uint = 0;
		private var spn:uint = 0;
		private var ipn:uint = 0;
		private var mptext_array:Array = new Array();
		private var tptext_array:Array = new Array();
		private var i:int
		private var hist:int = 0;
		
		private var _minX:Number = -180;
		private var _maxX:Number = 180;
		
		private var _minY:Number = 75;
		private var _maxY:Number = 270;
		
		private var _minZ:Number = -110;
		private var _maxZ:Number = 200;
		private var trails:Array = [];
		
		public var maxTrails:int = 50;
		public var maxPoints:int = 10;
	
		
		public function PointVisualizer(ID:Number)
		{			
			//trace("points visualizer");	
			id = ID;
			ts = GestureGlobals.gw_public::touchObjects[id];
			iPointArray = GestureGlobals.gw_public::iPointArray;
			
			
			hist = 8;
			
			
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
			}
			
			
			// FIXME: lazy instantiate trails
			for (i = 0; i < maxPoints; i++) { 
				
				trails.push(new Array());
				
				for (var j:int = 0; j < maxTrails; j++) {
					var s:Sprite = new Sprite;
					s.graphics.lineStyle(style.stroke_thickness, style.stroke_color, style.stroke_alpha);							
					s.graphics.beginFill(style.fill_color, style.fill_alpha);
					s.graphics.drawCircle(style.radius+7, style.radius+7, style.radius);
					s.graphics.endFill();		
					//var b:Bitmap = toBitmap(s);
					trails[i].push(s);					
				}
			}
			//GestureWorks.application.addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		private function toBitmap(obj:DisplayObject, smoothing:Boolean=true):Bitmap 
		{
			var m:Matrix = new Matrix();
			
			var bmd:BitmapData = new BitmapData(obj.width, obj.height, true, 0x00000000);
			bmd.draw(DisplayObject(obj), m);
			
			var bitmap:Bitmap = new Bitmap(bmd);
			bitmap.smoothing = smoothing;
			
			return bitmap;
		}
		
		public function draw():void
		{
			if (iPointArray) ipn =  iPointArray.length;
			else ipn = 0;
			
			// clear graphics
			graphics.clear();
			if(ipn) draw_interactionPoints();
		}
		
		
		private function draw_interactionPoints():void
			{
			//trace("drawing interaction points",ts.touchObjectID, ipn);
			for (i = 0; i < iPointArray.length; i++) 
					{
					var sp:InteractionPointObject = iPointArray[i];
					//trace("sensor type",sp.type, sp.devicetype, sp.acceleration.x);
					
					if (sp)
					{
							//////////////////////////////////////////////////////////////////////////////
							// for all interaction points
							if (tptext_array[i])
							{
								tptext_array[i].textCont = "IP ID: " + sp.interactionPointID //+ "    id" + String(pt.touchPointID);
								tptext_array[i].x = sp.position.x - tptext_array[i].width / 2;
								tptext_array[i].y = sp.position.y - 55;
								tptext_array[i].visible = true;
								tptext_array[i].textColor = style.touch_text_color;
							}
							
							///////////////////////////////////////////
							// DRAW WII CONTROLLER POINT
							trace ("ip type",sp.type);
							
								if (sp.type == "finger_dynamic")//finger
								{
									if (_drawShape)
									{
										// sensor center
										graphics.lineStyle(2, 0xFFFFFF, style.stroke_alpha);
										graphics.beginFill(0xFF0000, style.fill_alpha);
										graphics.drawCircle(sp.position.x, sp.position.y, style.radius);
										graphics.endFill();
									}
								}
								else if (sp.type == "pen_dynamic")
								{
									if (_drawShape)
									{
										// sensor center
										graphics.lineStyle(2, 0xFFFFFF, style.stroke_alpha);
										graphics.beginFill(0x00FFFF, style.fill_alpha);
										graphics.drawCircle(sp.position.x, sp.position.y, style.radius-10);
										graphics.endFill();
									}
								}
								
								else if (sp.type == "tag_dynamic")
								{
									if (_drawShape)
									{
										// sensor center
										graphics.lineStyle(2, 0xFFFFFF, style.stroke_alpha);
										graphics.beginFill(0xFF0000, style.fill_alpha);
										graphics.drawCircle(sp.position.x, sp.position.y, style.radius+10);
										graphics.endFill();
									}
								}
						
					}
						
				}
	}

	
	public function clear():void
	{
			//trace("trying to clear");
			graphics.clear();
		
			//text clear
			for (i = 0; i < tptext_array.length; i++){
				tptext_array[i].visible = false;
			}
			for (i = 0; i < mptext_array.length; i++){
				mptext_array[i].visible = false;
			}			
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