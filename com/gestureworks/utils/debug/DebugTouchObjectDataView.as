////////////////////////////////////////////////////////////////////////////////
//
//  IDEUM
//  Copyright 2011-2012 Ideum
//  All Rights Reserved.
//
//  GestureWorks
//
//  File:    DebugTouchObjectDataView.as
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
	
	import com.gestureworks.core.GestureGlobals;
	import com.gestureworks.core.gw_public;
	import com.gestureworks.core.CML;
	
	import com.gestureworks.utils.AddSimpleText;

	public class DebugTouchObjectDataView extends Sprite
	{	
		private static var cml:XMLList;
		private var obj:Object;
		private var trO:Object;
		private var ts:Object;
		private var pointList:Object;
		private var id:Number = 0;
		private var hist:int = 1;
	
		private var listHolder:Sprite = new Sprite();
		private var listObject:Object = new Object();
		private var chartHolder:Sprite  = new Sprite();
		private var chart_transform_delta:Sprite = new Sprite();
		private var line_transform_delta:Sprite = new Sprite();
		
		private var headerOn:Boolean = true;
		private var positionOn:Boolean = true;
		private var sizeOn:Boolean = true;
		private var rotationOn:Boolean = true;
		private var scaleOn:Boolean = true;
		private var indicatorsOn:Boolean = true;	
		private var chartOn:Boolean = true;
		private var valueChartOn:Boolean = true;
		private var deltaChartOn:Boolean = true;
		
		// cluster dynamic vars
		private var _x:Number = 0;
		private var _y:Number = 0;
		private var _w:Number = 0;
		private var _h:Number = 0;
		private var _r:Number = 0;
		private var sep:Number = 0;
		private var sepx:Number = 0;
		private var sepy:Number = 0;
		private var rot:Number = 0;
		
		//data list vars
		private var n:Number = 0;
		private var dist:Number = 0;
		
		// thresholds
		private var x_max:Number = 400;
		private var y_max:Number = 400;
		private var w_max:Number = 400;
		private var h_max:Number = 400;
		private var sepx_max:Number = 400;
		private var sepy_max:Number = 400;
		private var rot_max:Number = 2*Math.PI;
		private var dx_max:Number = 0.5;
		private var dy_max:Number = 0.5;
		private var ds_max:Number = 0.5;
		private var dtheta_max:Number = 0.5;
		private var x_min:Number = 20;
		private var y_min:Number = 20;
		private var w_min:Number = 20;
		private var h_min:Number = 20;
		private var sepx_min:Number = 20;
		private var sepy_min:Number = 20;
		private var rot_min:Number = 0;
		private var dx_min:Number = 0.001;
		private var dy_min:Number = 0.001;
		private var ds_min:Number = 0.001;
		private var dtheta_min:Number = 0.001;

		// dynamic value formatting
		private var black:String = "0x000000";
		private var red:String = "0xFF4500";
		private var green:String = "0x98FF98";
		private var blue:String = "0x00bbFF";
		private var white:String = "0xFFFFFF";
		
		private var dx_color:uint = 0xff0000; // red
		private var dy_color:uint = 0xffff00; // yellow
		private var dsx_color:uint = 0x0000ff; // dark blue
		private var dsy_color:uint = 0x00ffff; // light blue
		private var dtheta_color:uint = 0x00ff00; // green
		
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
		
		public function DebugTouchObjectDataView(touchObjectID:Number)
		{
			//trace("init cluster box");
			id = touchObjectID;
			
			/////////////////////////////////////////////
			// set default style 
			/////////////////////////////////////////////

			obj = new Object
				obj.displayOn = false;
			
				obj.stroke_thickness = 4;
				obj.stroke_color = 0x777777;
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
				
				obj.chart_history = 60;
				//trace("constructor");
	
		}
			
		public function init():void
		{
			//trace("init")
			ts = GestureGlobals.gw_public::touchObjects[id];
			trO = ts.trO;
			
			////////////////////////////////////////////////////////
			// set transform hsitory capture length
			////////////////////////////////////////////////////////
			GestureGlobals.transformHistoryCaptureLength = obj.chart_history 
			hist = GestureGlobals.transformHistoryCaptureLength;
			
			w0 = obj.width;
			h0 = obj.chart_height;
			
			// local logic init
			if (headerOn) n++
			if (positionOn) n++
			if (sizeOn) n++
			if (scaleOn) n++
			if (rotationOn) n++
				
			//////////////////////////////////////////////////////////////////////////////////////////////
			
				
					// draw background
						listHolder.graphics.lineStyle(obj.stroke_thickness,obj.stroke_color,obj.stroke_alpha);
						listHolder.graphics.beginFill(obj.fill_color, obj.fill_alpha);
						listHolder.graphics.drawRoundRect(0,0, obj.width, n*linet + h0 + header_h+5, obj.radius);
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
							txt_name.textCont = "Display Properties";
							txt_name.x = shiftx;
							txt_name.y = 0;
						lineHolder0.addChild(txt_name);
						m++;
					}
					
					if (positionOn) {
						var lineHolder1:Sprite = new Sprite();
							lineHolder1.graphics.lineStyle(obj.stroke_thickness,obj.stroke_color,obj.stroke_alpha);
							lineHolder1.graphics.drawRect(0,0, w, header_h);
							lineHolder1.x = 0;
							lineHolder1.y = linet * m;
						listHolder.addChild(lineHolder1);
						
						var txt_position:AddSimpleText = new AddSimpleText(des_w,th,"right", obj.text_color, obj.text_size);
							txt_position.textCont = "POSITION";
							txt_position.x = shiftx;
							txt_position.y = 5;
						lineHolder1.addChild(txt_position);
						
						var txt_x:AddSimpleText = new AddSimpleText(var_w,th,"right",  obj.text_color, obj.text_size);
							txt_x.textCont = "X ";
							txt_x.x = des_w;
							txt_x.y = 5;
						lineHolder1.addChild(txt_x);

						var txt_y:AddSimpleText = new AddSimpleText(var_w,th,"right",  obj.text_color, obj.text_size);
							txt_y.textCont = "Y ";
							txt_y.x = des_w + var_w + data_w;
							txt_y.y = 5;
						lineHolder1.addChild(txt_y);
						
						// dynamic values
						var txt_x_value:AddSimpleText = new AddSimpleText(data_w,th, "right",  obj.text_color, obj.text_size);
							txt_x_value.textFont = "OpenSansBold";
							txt_x_value.x = des_w + var_w;
							txt_x_value.y = 5;
						lineHolder1.addChild(txt_x_value);
						
						var txt_y_value:AddSimpleText = new AddSimpleText(data_w,th, "right",  obj.text_color, obj.text_size);
							txt_y_value.textFont = "OpenSansBold";
							txt_y_value.x = des_w + 2*var_w + data_w;
							txt_y_value.y = 5;
						lineHolder1.addChild(txt_y_value);
						
						// pass refence to object
						listObject.x_value = txt_x_value;
						listObject.y_value = txt_y_value;
						if(indicatorsOn){
							listObject.txt_x = txt_x;
							listObject.txt_y = txt_y;
						}
						
						m++;
					}
					
					if (sizeOn) {
						var lineHolder2:Sprite = new Sprite();
							lineHolder2.graphics.lineStyle(obj.stroke_thickness,obj.stroke_color,obj.stroke_alpha);
							lineHolder2.graphics.drawRect(0,0, w, header_h);
							lineHolder2.x = 0;
							lineHolder2.y = linet * m;
						listHolder.addChild(lineHolder2);
						
						var txt_dimension:AddSimpleText = new AddSimpleText(des_w,th,"right",  obj.text_color, obj.text_size);
							txt_dimension.textCont = "SIZE";
							txt_dimension.x = shiftx;
							txt_dimension.y = 5;
						lineHolder2.addChild(txt_dimension);
						
						var txt_w :AddSimpleText= new AddSimpleText(var_w,th,"right",  obj.text_color, obj.text_size);
							txt_w.textCont = "W ";
							txt_w.x = des_w;
							txt_w.y = 5;
						lineHolder2.addChild(txt_w);
						
						var txt_h:AddSimpleText = new AddSimpleText(var_w,th,"right",  obj.text_color, obj.text_size);
							txt_h.textCont = "H ";
							txt_h.x = des_w + var_w + data_w;
							txt_h.y = 5;
						lineHolder2.addChild(txt_h);
						
						// dynamic values
						var txt_w_value:AddSimpleText = new AddSimpleText(data_w,th, "right", obj.text_color, obj.text_size);
							txt_w_value.textFont = "OpenSansBold";
							txt_w_value.x = des_w + var_w ;
							txt_w_value.y = 5;
						lineHolder2.addChild(txt_w_value);
						
						var txt_h_value:AddSimpleText = new AddSimpleText(data_w,th, "right",  obj.text_color, obj.text_size);
							txt_h_value.textFont = "OpenSansBold";
							txt_h_value.x = des_w + 2*var_w + data_w;
							txt_h_value.y = 5;
						lineHolder2.addChild(txt_h_value);
						
						// pass refence to object
						listObject.w_value = txt_w_value;
						listObject.h_value = txt_h_value;
						
						m++;
					}
					
					if (scaleOn) {
						var lineHolder3:Sprite = new Sprite();
							lineHolder3.graphics.lineStyle(obj.stroke_thickness,obj.stroke_color,obj.stroke_alpha);
							lineHolder3.graphics.drawRect(0,0, w, header_h);
							lineHolder3.x = 0;
							lineHolder3.y = linet * m;
						listHolder.addChild(lineHolder3);
						
						var txt_separation:AddSimpleText = new AddSimpleText(des_w,th,"right",  obj.text_color, obj.text_size);
							txt_separation.textCont = "SCALE";
							txt_separation.x = shiftx;
							txt_separation.y = shifty;
						lineHolder3.addChild(txt_separation);
						
						var txt_scalex:AddSimpleText = new AddSimpleText(var_w,th,"right",  obj.text_color, obj.text_size);
							txt_scalex.textCont = "SX ";
							txt_scalex.x = des_w ;
							txt_scalex.y = shifty;
						lineHolder3.addChild(txt_scalex);

						var txt_scaley:AddSimpleText = new AddSimpleText(var_w,th,"right",  obj.text_color, obj.text_size);
							txt_scaley.textCont = "SY ";
							txt_scaley.x = des_w + var_w + data_w;
							txt_scaley.y = shifty;
						lineHolder3.addChild(txt_scaley);
						
						// dynamic values
						var txt_scalex_value:AddSimpleText = new AddSimpleText(data_w,th, "right",  obj.text_color, obj.text_size);
							txt_scalex_value.textFont = "OpenSansBold";
							txt_scalex_value.x = des_w + var_w;
							txt_scalex_value.y = shifty;
						lineHolder3.addChild(txt_scalex_value);
						
						var txt_scaley_value:AddSimpleText = new AddSimpleText(data_w,th, "right",  obj.text_color, obj.text_size);
							txt_scaley_value.textFont = "OpenSansBold";
							txt_scaley_value.x = des_w + 2*var_w + data_w;
							txt_scaley_value.y = shifty;
						lineHolder3.addChild(txt_scaley_value);
						
						// pass refence to object
						listObject.scalex_value = txt_scalex_value;
						listObject.scaley_value = txt_scaley_value;
						
						m++;
					}
					
					if (rotationOn) {
						var lineHolder4:Sprite = new Sprite();
							lineHolder4.graphics.lineStyle(obj.stroke_thickness,obj.stroke_color,obj.stroke_alpha);
							lineHolder4.graphics.drawRect(0,0, w, header_h);
							lineHolder4.x = 0;
							lineHolder4.y = linet * m;
						listHolder.addChild(lineHolder4);
						
						var txt_rotation:AddSimpleText = new AddSimpleText(des_w,th,"right",  obj.text_color, obj.text_size);
							txt_rotation.textCont = "ROTATION";
							txt_rotation.x = shiftx;
							txt_rotation.y = shifty;
						lineHolder4.addChild(txt_rotation);
						
						var txt_rotation_sgn:AddSimpleText = new AddSimpleText(var_w,th,"right",  obj.text_color, obj.text_size);
							txt_rotation_sgn.textCont = "th";//δ Ψ
							txt_rotation_sgn.x = des_w ;
							txt_rotation_sgn.y = shifty;
						lineHolder4.addChild(txt_rotation_sgn);
						
						// dynamic values
						var txt_rotation_value:AddSimpleText = new AddSimpleText(data_w,th, "right",  obj.text_color, obj.text_size);
							txt_rotation_value.textFont = "OpenSansBold";
							txt_rotation_value.x = des_w + var_w;
							txt_rotation_value.y = shifty;
						lineHolder4.addChild(txt_rotation_value);
						
						// pass refence to object
						listObject.rotation_value = txt_rotation_value;
			
						m++;
					}
					
					if (deltaChartOn)
						{
							//n_chart++;
								// position chart
								chart_transform_delta.x = 0//margin/ 2;
								chart_transform_delta.y = n*linet+5;
							
								// draw header
								chart_transform_delta.graphics.lineStyle(obj.stroke_thickness, obj.stroke_color, obj.stroke_alpha);
								chart_transform_delta.graphics.beginFill(fillColorB, obj.fill_alpha);
								chart_transform_delta.graphics.drawRect(0,0, obj.width, header_h);
								chart_transform_delta.graphics.endFill();
								
								// add header text field
								var txt_chart_name:AddSimpleText = new AddSimpleText(obj.width,th+4,"center", obj.text_color, int(obj.text_size)+4);
									txt_chart_name.textCont = "Display Deltas";
									txt_chart_name.x = shiftx;
									txt_chart_name.y = 0;
								chart_transform_delta.addChild(txt_chart_name);
								
								// draw back ground
								chart_transform_delta.graphics.beginFill(fillColorB, obj.fill_alpha);
								chart_transform_delta.graphics.drawRoundRect(margin*0.5, header_h + margin*0.5, w0-margin, h0-margin,0);
								chart_transform_delta.graphics.endFill();
								
								//draw axis horizontal
								chart_transform_delta.graphics.lineStyle(1, 0xFFFFFF, 1);
								chart_transform_delta.graphics.moveTo(w0-(margin*0.5)-key_width,header_h+(h0*0.5));
								chart_transform_delta.graphics.lineTo(margin * 0.5, header_h + (h0 * 0.5));
								//draw axis vertical
								chart_transform_delta.graphics.moveTo(margin*0.5 + origin_shift,header_h+margin*0.5);
								chart_transform_delta.graphics.lineTo(margin * 0.5 + origin_shift, header_h + h0 - margin*0.5);
								// set origin value
								var txt_orign:AddSimpleText = new AddSimpleText(var_w,th,"left", obj.text_color, obj.text_size-3);
									txt_orign.textCont = "0";
									txt_orign.x = margin*0.5;
									txt_orign.y = header_h + h0*0.5;
								chart_transform_delta.addChild(txt_orign);
								
								// position chart line object
								line_transform_delta.y = header_h; 
								line_transform_delta.x = margin*0.5 + origin_shift;
								chart_transform_delta.addChild(line_transform_delta);
								
								// create chart key 
								var txt_dx:AddSimpleText = new AddSimpleText(var_w,th,"left", obj.text_color, obj.text_size-3);
									txt_dx.textCont = "dx";
									txt_dx.x = w0-(margin*0.5)-key_text_width;
									txt_dx.y = header_h + 0*shift_key + margin*0.5;
								chart_transform_delta.addChild(txt_dx);
								
								var txt_dy:AddSimpleText = new AddSimpleText(var_w,th,"left", obj.text_color, obj.text_size-3);
									txt_dy.textCont = "dy";
									txt_dy.x = w0-(margin*0.5)-key_text_width;
									txt_dy.y = header_h + 1*shift_key + margin*0.5;
								chart_transform_delta.addChild(txt_dy);
								
								var txt_dsx:AddSimpleText = new AddSimpleText(var_w,th,"left", obj.text_color, obj.text_size-3);
									txt_dsx.textCont = "dsx";
									txt_dsx.x = w0-(margin*0.5)-key_text_width;
									txt_dsx.y = header_h + 2*shift_key + margin*0.5;
								chart_transform_delta.addChild(txt_dsx);
								
								var txt_dsy:AddSimpleText = new AddSimpleText(var_w,th,"left", obj.text_color, obj.text_size-3);
									txt_dsy.textCont = "dsy";
									txt_dsy.x = w0-(margin*0.5)-key_text_width;
									txt_dsy.y = header_h + 3*shift_key + margin*0.5;
								chart_transform_delta.addChild(txt_dsy);
								
								var txt_dtheta:AddSimpleText = new AddSimpleText(var_w,th,"left", obj.text_color, obj.text_size-3);
									txt_dtheta.textCont = "dth";
									txt_dtheta.x = w0-(margin*0.5)-key_text_width;
									txt_dtheta.y = header_h + 4*shift_key + margin*0.5;
								chart_transform_delta.addChild(txt_dtheta);
								
								// create key lines
								
								chart_transform_delta.graphics.lineStyle(1, dx_color, 1);
								chart_transform_delta.graphics.moveTo(w0-(margin*0.5)-key_width + 10, header_h + 0.6*shift_key + margin*0.5);
								chart_transform_delta.graphics.lineTo(w0 - (margin * 0.5)-key_text_width, header_h + 0.6*shift_key + margin*0.5);
								
								chart_transform_delta.graphics.lineStyle(1, dy_color, 1);
								chart_transform_delta.graphics.moveTo(w0-(margin*0.5)-key_width + 10 ,header_h + 1.6*shift_key+ margin*0.5);
								chart_transform_delta.graphics.lineTo(w0 - (margin * 0.5)-key_text_width, header_h + 1.6*shift_key + margin*0.5);
								
								chart_transform_delta.graphics.lineStyle(1, dsx_color, 1);
								chart_transform_delta.graphics.lineStyle(1, dsx_color, 1);
								chart_transform_delta.graphics.moveTo(w0-(margin*0.5)-key_width + 10 ,header_h + 2.6*shift_key+ margin*0.5);
								chart_transform_delta.graphics.lineTo(w0 - (margin * 0.5)-key_text_width, header_h + 2.6*shift_key+ margin*0.5 );
								
								chart_transform_delta.graphics.lineStyle(1, dsy_color, 1);
								chart_transform_delta.graphics.moveTo(w0-(margin*0.5)-key_width+ 10 ,header_h + 3.6*shift_key+ margin*0.5);
								chart_transform_delta.graphics.lineTo(w0 - (margin * 0.5)-key_text_width, header_h + 3.6*shift_key+ margin*0.5 );
								
								chart_transform_delta.graphics.lineStyle(1, dtheta_color, 1);
								chart_transform_delta.graphics.moveTo(w0 - (margin * 0.5) - key_width + 10 , header_h + 4.6*shift_key+ margin*0.5);
								chart_transform_delta.graphics.lineTo(w0-(margin*0.5)-key_text_width, header_h + 4.6*shift_key + margin*0.5);
								
							listHolder.addChild(chart_transform_delta);	
						}
	}
			
	public function drawDataView():void
	{	
		
		// core vars
		_x = trO.x;
		_y = trO.y;
		_r = trO.radius;
		
		//object vars
		var ts_x:Number = ts.x;
		var ts_y:Number = ts.y;
		var ts_w:Number = ts.width;
		var ts_h:Number = ts.height;
		var ts_scalex:Number = ts.scaleX;
		var ts_scaley:Number = ts.scaleY;
		var ts_rotation:Number = ts.rotation;
		
		
		dist = (_r + displayRadius) * (1 / Math.sqrt(2));
		
		// set list holder properties
		listHolder.visible = true;
		listHolder.x = _x + dist;
		listHolder.y = (_y - dist) - 160;
		
		
		//dynamic deltas
		//dx = tO.dx;
		//dy = tO.dy;
		//dw = tO.dw;
		//dh = tO.dh;
		//ds = tO.ds
		//dsx = tO.dsx
		//dsy = tO.dsy
		//dtheta = tO.dtheta / 4;
		
			
		////////////////////////////////////////////////////////////////////////
		// not put threshold state logic into cluster analysis
		/////////////////////////////////////////////////////////////////////
			
		var yscale:Number = 2;
		var xscale:Number = (w0-margin-key_width-origin_shift)/hist;
		var ymax:Number = (h0 - margin) * 0.5
			
		var k:int;
		var q:int;
		var j:int;
		var y0:Number;
		var y1:Number;		
		
		
		
		// set position values
		if (positionOn) {
			listObject.x_value.textCont = Math.round(ts_x);
			listObject.y_value.textCont = Math.round(ts_y);
			
			if(indicatorsOn){
				if ((_x < x_max)&&(_x>x_min))		listObject.x_value.textColor = green;
				else if (Math.abs(_x) < x_min)	listObject.x_value.textColor = blue;
				else if (Math.abs(_x) > x_max)	listObject.x_value.textColor = red;
				else if (_x == 0)				listObject.x_value.textColor = white;
				//else if (x == undefined)		listObject.x_value.textColor = black;
				
				if ((_y < y_max)&&(_y>y_min))		listObject.y_value.textColor = green;
				else if (Math.abs(_y) < y_min)	listObject.y_value.textColor = blue;
				else if (Math.abs(_y) >y_max)	listObject.y_value.textColor = red;
				else if (_y == 0)				listObject.y_value.textColor = white;
				//else if (_y == undefined)		listObject.y_value.textColor = black;
			}
		}
		
		if (sizeOn) {
			listObject.w_value.textCont = Math.round(ts_w);
			listObject.h_value.textCont = Math.round(ts_h);
			
			if(indicatorsOn){
				if ((_w < w_max)&&(_w>w_min))		listObject.w_value.textColor = green;
				else if (Math.abs(_w) < w_min)	listObject.w_value.textColor = blue;
				else if (Math.abs(_w) >w_max)	listObject.w_value.textColor = red;
				else if (_w == 0)				listObject.w_value.textColor = white;
				//else if (_w == undefined)		listObject.w_value.textColor = black;
				
				if ((_h < h_max)&&(_h>h_min))		listObject.h_value.textColor= green;
				else if (Math.abs(_h) < h_min)	listObject.h_value.textColor = blue;
				else if (Math.abs(_h) >h_max)	listObject.h_value.textColor = red;
				else if (_h == 0)				listObject.h_value.textColor = white;
				//else if (_h == undefined)		listObject.h_value.textColor = black;
			}
			
		}
		if (scaleOn) {
			listObject.scalex_value.textCont =  Math.round(100*ts_scalex)/100;//Math.round(separation);
			listObject.scaley_value.textCont =  Math.round(100*ts_scaley)/100;//Math.round(separation);
			
			
			if(indicatorsOn){
				if ((sepx < sepx_max)&&(sepx>sepx_min))		listObject.scalex_value.textColor = green;
				else if (Math.abs(sepx) < sepx_min)		listObject.scalex_value.textColor = blue;
				else if (Math.abs(sepx) >sepx_max)		listObject.scalex_value.textColor= red;
				else if (sepx == 0)						listObject.scalex_value.textColor = white;
				//else if (sepx == undefined)				listObject.scalex_value.textColor = black;
				
				if ((sepy < sepy_max)&&(sepy>sepy_min))		listObject.scaley_value.textColor = green;
				else if (Math.abs(sepy) < sepy_min)		listObject.scaley_value.textColor = blue;
				else if (Math.abs(sepy) >sepy_max)		listObject.scaley_value.textColor = red;
				else if (sepy == 0)						listObject.scaley_value.textColor = white;
				//else if (sepy == undefined)				listObject.scaley_box.boxColor = black;
			}
		}
		if (rotationOn) {
			listObject.rotation_value.textCont =  Math.round(ts_rotation);//Math.round(rotation);
			
			
			if(indicatorsOn){
				if ((rot < rot_max)&&(rot>rot_min))		listObject.rotation_value.textColor = green;
				else if (Math.abs(rot) < rot_min)		listObject.rotation_value.textColor = blue;
				else if (Math.abs(rot) >rot_max)		listObject.rotation_value.textColor = red;
				else if (rot == 0)						listObject.rotation_value.textColor = white;
				//else if (rot == undefined)				listObject.rotation_box.boxColor = black;
			}
		}
		
		if (deltaChartOn) {
			//////////////////////////////////////////////////////////////////////////////////////////////////////
			// cluster object delta data
			//////////////////////////////////////////////////////////////////////////////////////////////////////
			
					line_transform_delta.graphics.clear();
					
					// draw cluster data dx
					line_transform_delta.graphics.lineStyle(1, dx_color, 1);
					line_transform_delta.graphics.moveTo(0, h0 / 2);
					
					for (q = 0; q < hist; q++) {
						if (trO.history[q+1]) 
						{
							y0 = yscale * trO.history[q].dx
							y1 = yscale * trO.history[q + 1].dx
							
							if (Math.abs(y0) > ymax){
									if (y0 > 0) y0 = ymax;
									if (y0 < 0) y0 = -ymax;
							}
							if (Math.abs(y1) > ymax) {
									if (y1 > 0) y1 = ymax;
									if (y1 < 0) y1 = -ymax;
							}
							
							line_transform_delta.graphics.lineTo( q * xscale,  y0 +(h0*0.5));
							line_transform_delta.graphics.lineTo( (q+1) * xscale, y1 + (h0*0.5));
						}
					}
					
					// draw cluster data dy
					line_transform_delta.graphics.lineStyle(1, dy_color, 1);
					line_transform_delta.graphics.moveTo(0, h0 *0.5);
					
					for (q = 0; q < hist; q++) {
						if (trO.history[q+1]) 
						{
							y0 = yscale * trO.history[q].dy
							y1 = yscale * trO.history[q + 1].dy
							
							if (Math.abs(y0) > ymax){
									if (y0 > 0) y0 = ymax;
									if (y0 < 0) y0 = -ymax;
							}
							if (Math.abs(y1) > ymax) {
									if (y1 > 0) y1 = ymax;
									if (y1 < 0) y1 = -ymax;
							}
							
							line_transform_delta.graphics.lineTo( q * xscale ,  y0 + (h0*0.5));
							line_transform_delta.graphics.lineTo( (q+1) * xscale, y1 + (h0*0.5));
						}
					}
					
					// draw cluster data dsx
					line_transform_delta.graphics.lineStyle(1,dsx_color, 1);
					line_transform_delta.graphics.moveTo(0, h0*0.5);
					
					for (q = 0; q < hist; q++) {
						if (trO.history[q+1]) 
						{
							y0 = yscale * trO.history[q].dsx 
							y1 = yscale * trO.history[q + 1].dsx
							
							if (Math.abs(y0) > ymax){
									if (y0 > 0) y0 = ymax;
									if (y0 < 0) y0 = -ymax;
							}
							if (Math.abs(y1) > ymax) {
									if (y1 > 0) y1 = ymax;
									if (y1 < 0) y1 = -ymax;
							}
							
							line_transform_delta.graphics.lineTo( q * xscale ,  y0 + (h0*0.5));
							line_transform_delta.graphics.lineTo( (q+1) * xscale , y1 + (h0*0.5));
						}
					}
					
					// draw cluster data dsy
					line_transform_delta.graphics.lineStyle(1, dsy_color, 1);
					line_transform_delta.graphics.moveTo(0, h0 *0.5);
					
					for (q = 0; q < hist; q++) {
						if (trO.history[q+1]) 
						{
							y0 = yscale * trO.history[q].dsy
							y1 = yscale * trO.history[q + 1].dsy
							
							if (Math.abs(y0) > ymax){
									if (y0 > 0) y0 = ymax;
									if (y0 < 0) y0 = -ymax;
							}
							if (Math.abs(y1) > ymax) {
									if (y1 > 0) y1 = ymax;
									if (y1 < 0) y1 = -ymax;
							}
							
							line_transform_delta.graphics.lineTo( q * xscale ,  y0 + h0 / 2);
							line_transform_delta.graphics.lineTo( (q+1) * xscale , y1 + h0 / 2);
						}
					}
					
					// draw cluster data dtheta
					line_transform_delta.graphics.lineStyle(1, dtheta_color, 1);
					line_transform_delta.graphics.moveTo(0, h0*0.5);
					
					for (q = 0; q < hist; q++) {
						if (trO.history[q+1]) 
						{
							y0 = yscale * trO.history[q].dtheta 
							y1 = yscale * trO.history[q + 1].dtheta
							
							if (Math.abs(y0) > ymax){
									if (y0 > 0) y0 = ymax;
									if (y0 < 0) y0 = -ymax;
							}
							if (Math.abs(y1) > ymax) {
									if (y1 > 0) y1 = ymax;
									if (y1 < 0) y1 = -ymax;
							}
							
							line_transform_delta.graphics.lineTo( q * xscale ,  y0 + h0 / 2);
							line_transform_delta.graphics.lineTo( (q+1) * xscale , y1 + h0 / 2);
						}
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
			
			if (type == "cluster_data_view") {
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
				
				//obj.chart_history = cml.DebugKit.DebugLayer[i].attribute("history");
			}
		}
	}
	
	public function setOptions():void
	{
		// data tables values
		positionOn = true;
		sizeOn = true;
		rotationOn = true;
		scaleOn = true;
		indicatorsOn = true;
	}
	
	
}
}