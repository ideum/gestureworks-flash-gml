////////////////////////////////////////////////////////////////////////////////
//
//  IDEUM
//  Copyright 2011-2012 Ideum
//  All Rights Reserved.
//
//  GestureWorks
//
//  File:    DebugGestureDataView.as
//  Authors:  Ideum
//             
//  NOTICE: Ideum permits you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////
package com.gestureworks.utils.debug
{
	import flash.display.Sprite;
	import flash.text.*;
	//import flash.display.Loader;
	//import flash.net.URLRequest;
	import flash.display.Bitmap;
	
	import com.gestureworks.core.GestureGlobals;
	import com.gestureworks.core.gw_public;
	import com.gestureworks.core.CML;
	//import com.gestureworks.objects.ClusterObject;
	//import com.gestureworks.objects.GestureObject;
	import com.gestureworks.objects.DimensionObject;
	import com.gestureworks.utils.AddSimpleText;

	public class DebugGestureDataView extends Sprite
	{	
		private static var cml:XMLList;
		private var obj:Object;
		//private var cO:ClusterObject;
		//private var gO:GestureObject;
		private var ts:Object;
		private var pointList:Object;
		private var id:Number = 0;
		
		private var i:String;
		private var j:String;
		
		private var key:uint;
		private var DIM:uint;
		
		private var gestureEventList:Array;
	
		
		private var listHolder:Sprite = new Sprite();
		private var listObject:Object = new Object();
		private var txt_g_value:AddSimpleText; 
		private var iconList:Array = new Array();
		
		private var headerOn:Boolean = true;
		private var positionOn:Boolean = true;
		private var dimentionOn:Boolean = true;
		private var rotationOn:Boolean = true;
		private var separationOn:Boolean = true;
		private var indicatorsOn:Boolean = true;	
		
		// cluster dynamic vars
		private var _n:Number = 0;
		private var _x:Number = 0;
		private var _y:Number = 0;
		private var _r:Number = 0;
		
		private var dx:Number = 0;
		private var dy:Number = 0;
		private var dw:Number = 0;
		private var dh:Number = 0;
		private var ds:Number = 0;
		private var dsx:Number = 0;
		private var dsy:Number = 0;
		private var dtheta:Number = 0;
		
		//data list vars
		private var n:Number = 6; // number of lines
		private var dist:Number = 0;

		// dynamic value formatting
		private var black:String = "0x000000";
		private var red:String = "0xFF4500";
		
		private var green:String = "0x98FF98";
		private var blue:String = "0x00bbFF";
		private var white:String = "0xFFFFFF";
		
		private var orange:uint = 0xFFAE1F;
		
		private var margin:Number = 25;
		private var h0:Number = 150;
		private var w0:Number = 360;
		
		// local vars
		private var linet:Number = 28;
		private var m:int = 0;
		private var tw:Number = 50;
		private var th:Number = 20;
		private var des_w:Number = 100; //width of description text field
		private var var_w:Number = 30; // width of varible text field
		private var data_w:Number = 40; // width of data text fieled
		private var c:int = 4;
		private var w:Number = des_w + c * var_w + c * data_w // panel width
		private var shiftx:Number = 5;
		private var shifty:Number = 5;
		
		private var header_h:int = 30;
		
		// char key variables
		private var key_width:int = 50;
		private var key_height:int;
		private var shift_key:int = 15;
		private var key_text_width:int = 20;	
		private var origin_shift:int = 10;
				 
		private var fillColorB:uint = 0x444444;

		public var displayRadius:int = 200;
		
		//gesture list vars
		private var list_width:int = 110; //w0*0.5 -shiftx;
		
		
		[Embed(source = "../../../../../lib/assets/GW-debug_hand1.png")] private var hand1:Class;
		[Embed(source = "../../../../../lib/assets/GW-debug_hand2.png")] private var hand2:Class;
		[Embed(source = "../../../../../lib/assets/GW-debug_hand3.png")] private var hand3:Class;
		[Embed(source = "../../../../../lib/assets/GW-debug_hand4.png")] private var hand4:Class;
		[Embed(source = "../../../../../lib/assets/GW-debug_hand5.png")] private var hand5:Class;
		
		public function DebugGestureDataView(touchObjectID:Number)
		{
			//trace("init cluster box");
			id = touchObjectID;
			
			/////////////////////////////////////////////
			// set default style 
			/////////////////////////////////////////////

			obj = new Object
				obj.displayOn = false;
			
				obj.stroke_thickness = 4;
				obj.stroke_color =0x777777;
				obj.stroke_alpha = 0;
				
				obj.fill_color = 0x222222;
				obj.fill_alpha = 0.8;
				
				obj.text_color = 0xFFFFFF;
				obj.text_size = 14;
				obj.text_alpha = 1;
				
				obj.indicators = true;
				obj.radius = 10;
				obj.width = 260;
				
				obj.chart_height = 100;
				obj.chart_width = 100;
				//trace("constructor");
	
		}
			
		public function init():void
		{
			//trace("init")
			ts = GestureGlobals.gw_public::touchObjects[id];
			//gO = ts.gO;
			//cO = ts.cO;
			
			w0 = obj.width;
			h0 = obj.chart_height;
				
			//////////////////////////////////////////////////////////////////////////////////////////////
			
				
					// draw background
						listHolder.graphics.lineStyle(obj.stroke_thickness,obj.stroke_color,obj.stroke_alpha);
						listHolder.graphics.beginFill(obj.fill_color, obj.fill_alpha);
						listHolder.graphics.drawRoundRect(0,0, obj.width, n*linet, obj.radius);
						listHolder.graphics.endFill();
						listHolder.visible = false;
					addChild(listHolder);
					
					var name_w:Number = 120;
					
					if (headerOn) {
						var lineHolder0:Sprite = new Sprite();
							lineHolder0.graphics.lineStyle(obj.stroke_thickness, obj.stroke_color, obj.stroke_alpha);
							lineHolder0.graphics.beginFill(fillColorB, obj.fill_alpha);
							//lineHolder0.graphics.drawRect(0, 0, w, 30);
							lineHolder0.graphics.drawRoundRect(0,0, obj.width, header_h, obj.radius);
							lineHolder0.graphics.endFill();
							lineHolder0.x = 0;
							lineHolder0.y = linet * m;
						listHolder.addChild(lineHolder0);
						
						var txt_name:AddSimpleText = new AddSimpleText(obj.width,th+4,"center", obj.text_color, int(obj.text_size)+4);
							txt_name.textCont = "Gesture Analysis";
							txt_name.x = shiftx;
							txt_name.y = 0;
						lineHolder0.addChild(txt_name);
						m++;
					}
					
					//if (pointsOn) {
						var lineHolder1:Sprite = new Sprite();
							lineHolder1.graphics.lineStyle(obj.stroke_thickness,obj.stroke_color,obj.stroke_alpha);
							lineHolder1.graphics.drawRect(0,0, w, header_h);
							lineHolder1.x = 0;
							lineHolder1.y = linet * m;
						listHolder.addChild(lineHolder1);
						
						var txt_position:AddSimpleText = new AddSimpleText(des_w,th,"center", obj.text_color, obj.text_size);
							txt_position.textCont = "POINTS";
							txt_position.x = shiftx;
							txt_position.y = 5;
						lineHolder1.addChild(txt_position);
						
						/////////////////////////////////////////////////////
						// CLEAN OUT OF MEMORY ONCE LOADED
						/////////////////////////////////////////////////////
						var imgy:Number = 30;
						var imgx:Number = (w0 * 0.25) - 45;
						
						//var imgLoader1:Loader = new Loader();
							//imgLoader1.load(new URLRequest("../lib/assets/debug/GW-debug_hand1.png"));
							
						var H1:Bitmap = new hand1();
							H1.cacheAsBitmap = true;
							H1.visible = false;
							H1.x = imgx;
							H1.y = imgy;
						lineHolder1.addChild(H1);
						iconList[0] = H1;
						
						var H2:Bitmap = new hand2();
							H2.cacheAsBitmap = true;
							H2.x = imgx;
							H2.y = imgy;
							H2.visible = false;
						lineHolder1.addChild(H2);
						iconList[1] = H2;
						
						var H3:Bitmap = new hand3();
							H3.cacheAsBitmap = true;
							H3.x = imgx;
							H3.y = imgy;
							H3.visible = false;
						lineHolder1.addChild(H3);
						iconList[2] = H3;
						
						var H4:Bitmap = new hand4();
							H4.cacheAsBitmap = true;
							H4.x = imgx;
							H4.y = imgy;
							H4.visible = false;
						lineHolder1.addChild(H4);
						iconList[3] = H4;
						
						var H5:Bitmap = new hand5();
							H5.cacheAsBitmap = true;
							H5.x = imgx;
							H5.y = imgy;
							H5.visible = false;
						lineHolder1.addChild(H5);
						iconList[4] = H5;
						
						// add icon display
					//}
					
					//if (gesturesOn) {
						var lineHolder2:Sprite = new Sprite();
							lineHolder2.graphics.lineStyle(obj.stroke_thickness,obj.stroke_color,obj.stroke_alpha);
							lineHolder2.graphics.drawRect(0,0, w, header_h);
							lineHolder2.x = 0;
							lineHolder2.y = linet * m;
						listHolder.addChild(lineHolder2);
						
						var txt_dimension:AddSimpleText = new AddSimpleText(des_w,th,"left",  obj.text_color, obj.text_size);
							txt_dimension.textCont = "GestureEvents";
							txt_dimension.x = shiftx + w0*0.5; // mid point of 
							txt_dimension.y = 5;
						lineHolder2.addChild(txt_dimension);
						
						txt_g_value = new AddSimpleText(list_width,5*th, "left",  orange, obj.text_size);
							txt_g_value.textFont = "OpenSansBold";
							txt_g_value.x = shiftx + w0*0.5;
							txt_g_value.y = 5 + linet;
							txt_g_value.textWrap = true;
						lineHolder2.addChild(txt_g_value);
						
						//txt_g_value.textCont = "gesturnt0gestureeve	geent2	gestureevent3.......--.";
					//}
	}
	
	public function drawDataView():void
	{	
		
		// dynamic cluster vars
		_n = ts.cO.n;
		_x = ts.cO.x;
		_y = ts.cO.y;
		_r = ts.cO.radius;
		
		dist = (_r + displayRadius) * (1 / Math.sqrt(2));
		
		//NEED A BETTER GLOBAL POSITIONING SYSTEM FOR DEBUG
		
		// set list holder properties
		listHolder.visible = true;
		listHolder.x = _x + dist;
		listHolder.y = (_y - dist) + 130;
		
		//////////////////////////////////////////
		// adjust and flip
		//////////////////////////////////////////
		//if ((_y - dist + 130) > stage.stageHeight) listHolder.y =(_y + dist) + 130;
		if ((_x + dist + obj.width) > stage.stageWidth) listHolder.x = _x - dist-obj.width;
		
		//if ((_y - dist + 130) < 0) listHolder.y =(_y + dist) + 130;
		//if ((_x + 2*dist)< 0) listHolder.x = _x - 2*dist;
		
		/////////////////////////////////////////////////////////
		// look for gesture events by scanning property object
		// could look for gesture events in the timeline but 
		//would require gesture events to be set to true
		/////////////////////////////////////////////////////////
		var gestureString:String = "";
		gestureEventList = new Array();
		
		
		
		var n:uint = ts.gO.pOList.length;
		// look for active gestures
			
			for (key = 0; key < n; key++)
			//for (i in ts.gO.pOList)
				{
					var traceGesture:Boolean = false;
					var dn:uint = ts.gO.pOList[key].dList.length;
					
					for (DIM = 0; DIM < dn; DIM++)
					//for (j in ts.gO.pOList[i])
					{
						//if ((ts.gO.pOList[i][j] is DimensionObject) && (ts.gO.pOList[i]dList[j].gestureDelta != 0)) traceGesture = true;
						if (ts.gO.pOList[key].dList[DIM].gestureDelta != 0) traceGesture = true;
					}
					if (traceGesture) gestureEventList.push(ts.gO.pOList[key].gesture_id);
					
					traceGesture = false;
					
					//trace("--",key);
				}
		// remove duplicate entries for gestures with multitple properties
		removeDuplicate(gestureEventList);
				
			for (var k:int = 0; k < gestureEventList.length; k++)
				{
				gestureString += gestureEventList[k] + "\n";
				}			
			txt_g_value.textCont = gestureString;
				
				
		// loop through icons and activate
			for (var z:int = 0; z < 5; z++)
			{
				iconList[z].visible = false;
				if (_n == (z+1)) iconList[z].visible = true;
			}
	}
	
	private function removeDuplicate(arr:Array):void
	{
		for (var t:int = 0; t < arr.length - 1; t++)
		{
			for (var q:int = t + 1; q < arr.length; q++)
			{
				if (arr[t] === arr[q]) arr.splice(q, 1);
			}
		}
	}
			

	public function clear():void
	{
		listHolder.visible = false;
	}
	public function setStyles():void
	{
		cml = new XMLList(CML.Objects)
		var numLayers:int = cml.DebugKit.DebugLayer.length()
		
		for (var i:int = 0; i < numLayers; i++) {
			var type:String = cml.DebugKit.DebugLayer[i].attribute("type")
			
			if (type == "gesture_data_view") {
				//trace("cluster data list")
			//	obj.displayOn = cml.DebugKit.DebugLayer[i].attribute("displayOn")//3;
				
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
				//obj.width = cml.DebugKit.DebugLayer[i].attribute("width");
				
				//obj.chart_width = cml.DebugKit.DebugLayer[i].attribute("chart_width");
				//obj.chart_height = cml.DebugKit.DebugLayer[i].attribute("chart_height");
			}
		}
	}
	
	public function setOptions():void
	{
		// data tables values
		//positionOn = true;
		//dimentionOn = true;
	
	}
	
	
}
}