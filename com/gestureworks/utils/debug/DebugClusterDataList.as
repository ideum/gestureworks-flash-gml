////////////////////////////////////////////////////////////////////////////////
//
//  IDEUM
//  Copyright 2011-2012 Ideum
//  All Rights Reserved.
//
//  GestureWorks
//
//  File:    DebugClusterDataList.as
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
	
	import com.gestureworks.core.CML;
	import com.gestureworks.utils.AddSimpleText;

	import com.gestureworks.core.GestureGlobals;
	import com.gestureworks.core.gw_public;
	
	import com.gestureworks.objects.ClusterObject;

	public class DebugClusterDataList extends Sprite
	{	
		private static var cml:XMLList;
		private var obj:Object;
		private var clusterObject:ClusterObject;
		private var pointList:Object;
		private var NumPoints:Number;
		private var id:Number = 0;
	
		private var listHolder:Sprite = new Sprite();
		private var listObject:Object = new Object();
		
		private var idOn:Boolean = true;
		private var posOn:Boolean = true;
		private var dimOn:Boolean = true;
		private var rotOn:Boolean = true;
		private var sepOn:Boolean = true;
		private var velOn:Boolean = true;
		private var accelOn:Boolean = true;
		private var indicatorsOn:Boolean = true;	
		
		// cluster dynamic vars
		private var _x:Number = 0;
		private var _y:Number = 0;
		private var w:Number = 0;
		private var h:Number = 0;
		private var r:Number = 0;
		private var sep:Number = 0;
		private var sepx:Number = 0;
		private var sepy:Number = 0;
		private var rot:Number = 0;
		private var orientation:Number = 0;
		private var dx:Number = 0;
		private var dy:Number = 0;
		private var dw:Number = 0;
		private var dh:Number = 0;
		private var dr:Number = 0;
		private var ds:Number = 0;
		private var dtheta:Number = 0;
		private var ddx:Number = 0;
		private var ddy:Number = 0;
		//var ddw:Number = 0;
		//var ddh:Number = 0;
		//var ddr:Number = 0;
		private var dds:Number = 0;
		private var ddtheta:Number = 0;
		
		//data list vars
		private var n:Number = 0;
		private var dist:Number = 0;
		//private var rad:Number = 15;
		
		// thresholds
		private var x_max:Number = 400;
		private var y_max:Number = 400;
		private var w_max:Number = 400;
		private var h_max:Number = 400;
		private var r_max:Number = 400;
		private var sepx_max:Number = 400;
		private var sepy_max:Number = 400;
		private var rot_max:Number = 2*Math.PI;
		private var dx_max:Number = 0.5;
		private var dy_max:Number = 0.5;
		private var ds_max:Number = 0.5;
		private var dtheta_max:Number = 0.5;
		private var ddx_max:Number = 0.5;
		private var ddy_max:Number = 0.5;
		private var dds_max:Number = 0.5;
		private var ddtheta_max:Number = 0.5;
		private var x_min:Number = 20;
		private var y_min:Number = 20;
		private var w_min:Number = 20;
		private var h_min:Number = 20;
		private var r_min:Number = 20;
		private var sepx_min:Number = 20;
		private var sepy_min:Number = 20;
		private var rot_min:Number = 0;
		private var dx_min:Number = 0.001;
		private var dy_min:Number = 0.001;
		private var ds_min:Number = 0.001;
		private var dtheta_min:Number = 0.001;
		private var ddx_min:Number = 0.001;
		private var ddy_min:Number = 0.001;
		private var dds_min:Number = 0.001;
		private var ddtheta_min:Number = 0.001;

		// dynamic value formatting
		private var black:String = "0x000000";
		private var red:String = "0xFF0000";
		private var amber:String = "0xFFFF00";
		private var green:String = "0x00FF00";
		private var blue:String = "0x0000FF";
		private var white:String = "0xFFFFFF";
		
		public function DebugClusterDataList(touchObjectID:Number)
		{
			//trace("init cluster box");
			id = touchObjectID;
			
			/////////////////////////////////////////////
			// set default style 
			/////////////////////////////////////////////

			obj = new Object
				obj.displayOn = false;
			
				obj.stroke_thickness = 10;
				obj.stroke_color = 0xFFFFFF;
				obj.stroke_alpha = 1;
				
				obj.fill_color = 0xFFFFFF;
				obj.fill_alpha = 0.2;
				
				obj.text_color = 0xFF0000;
				obj.text_size = 12;
				obj.text_alpha = 1;
				
				obj.indicators = true;
				obj.radius = 10;
				
				//trace("constructor");
		}
			
		public function init():void
		{
			//trace("init")
			clusterObject = GestureGlobals.gw_public::clusters[id];
			pointList = clusterObject.pointArray
			NumPoints = pointList.length;
			
			//if(obj.displayOn=="true"){

				// local logic init
				if (posOn) n++
				if (dimOn) n++
				if (sepOn) n++
				if (rotOn) n++
				if (velOn) n++
				if (accelOn) n++
				
				// local vars
				var linet:Number = 30;
				var m:int = 0;
				var tw:Number = 50;
				var th:Number = 20;
				var des_w:Number = 40;
				var var_w:Number = 40;
				var data_w:Number = 40;
				var c:int = 4;
				var w:Number = des_w + c * var_w + c * data_w // panel width
				var shiftx:Number = 5;
				var shifty:Number = 5;
				 
			
				if (n > 0) {
				
					// draw background
						listHolder.graphics.lineStyle(obj.stroke_thickness,obj.stroke_color,obj.stroke_alpha);
						listHolder.graphics.beginFill(obj.fill_color, obj.fill_alpha);
						listHolder.graphics.drawRoundRect(0,0, w, n*linet, obj.radius);
						listHolder.graphics.endFill();
						listHolder.visible = false;
					addChild(listHolder);
					
					var name_w:Number = 120;
					
					if (idOn) {
						var lineHolder0:Sprite = new Sprite();
							lineHolder0.graphics.lineStyle(obj.stroke_thickness,obj.stroke_color,obj.stroke_alpha);
							lineHolder0.graphics.drawRect(0,0, w, 30);
							lineHolder0.x = 0;
							lineHolder0.y = linet * m;
						listHolder.addChild(lineHolder0);
						
						var txt_name:AddSimpleText = new AddSimpleText(name_w+10,th,"left", obj.text_color, obj.text_size);
							txt_name.textCont = "Cluster Properties:";
							txt_name.x = shiftx;
							txt_name.y = 5;
						lineHolder0.addChild(txt_name);
						
						var txt_id:AddSimpleText = new AddSimpleText(var_w,th,"right",  obj.text_color, obj.text_size);
							txt_id.textCont = "ID: ";
							txt_id.x = name_w;
							txt_id.y = 5;
						lineHolder0.addChild(txt_id);

						var txt_n:AddSimpleText = new AddSimpleText(var_w,th,"right",  obj.text_color, obj.text_size);
							txt_n.textCont = "N: ";
							txt_n.x = name_w + var_w + data_w;
							txt_n.y = 5;
						lineHolder0.addChild(txt_n);
						
						// dynamic values
						var txt_id_value:AddSimpleText = new AddSimpleText(data_w,th, "left",  obj.text_color, obj.text_size);
							txt_id_value.x = name_w + var_w;
							txt_id_value.y = 5;
						lineHolder0.addChild(txt_id_value);
						
						var txt_n_value:AddSimpleText = new AddSimpleText(data_w,th, "left",  obj.text_color, obj.text_size);
							txt_n_value.x = name_w + 2*var_w + data_w;
							txt_n_value.y = 5;
						lineHolder0.addChild(txt_n_value);
						
						// pass refence to object
						listObject.id_value = txt_id_value;
						listObject.n_value = txt_n_value;
						
						m++;
					}
					
					if (posOn) {
						var lineHolder1:Sprite = new Sprite();
							lineHolder1.graphics.lineStyle(obj.stroke_thickness,obj.stroke_color,obj.stroke_alpha);
							lineHolder1.graphics.drawRect(0,0, w, 30);
							lineHolder1.x = 0;
							lineHolder1.y = linet * m;
						listHolder.addChild(lineHolder1);
						
						var txt_position:AddSimpleText = new AddSimpleText(des_w,th,"left", obj.text_color, obj.text_size);
							txt_position.textCont = "Pos:";
							txt_position.x = shiftx;
							txt_position.y = 5;
						lineHolder1.addChild(txt_position);
						
						var txt_x:AddSimpleText = new AddSimpleText(var_w,th,"right",  obj.text_color, obj.text_size);
							txt_x.textCont = "x: ";
							txt_x.x = des_w;
							txt_x.y = 5;
						lineHolder1.addChild(txt_x);

						var txt_y:AddSimpleText = new AddSimpleText(var_w,th,"right",  obj.text_color, obj.text_size);
							txt_y.textCont = "y: ";
							txt_y.x = des_w + var_w + data_w;
							txt_y.y = 5;
						lineHolder1.addChild(txt_y);
						/*
						if(indicatorsOn){
							var txt_x_box:DrawBox = new DrawBox(des_w, 5, 10, 10);
							lineHolder1.addChild(txt_x_box);
							var txt_y_box:DrawBox = new DrawBox(des_w + var_w + data_w, 5, 10, 10);
							lineHolder1.addChild(txt_y_box);
						}*/
						
						// dynamic values
						var txt_x_value:AddSimpleText = new AddSimpleText(data_w,th, "left",  obj.text_color, obj.text_size);
							txt_x_value.x = des_w + var_w;
							txt_x_value.y = 5;
						lineHolder1.addChild(txt_x_value);
						
						var txt_y_value:AddSimpleText = new AddSimpleText(data_w,th, "left",  obj.text_color, obj.text_size);
							txt_y_value.x = des_w + 2*var_w + data_w;
							txt_y_value.y = 5;
						lineHolder1.addChild(txt_y_value);
						
						// pass refence to object
						listObject.x_value = txt_x_value;
						listObject.y_value = txt_y_value;
						/*
						if(indicatorsOn){
							listObject.x_box = txt_x_box;
							listObject.y_box = txt_y_box;
						}*/
						
						m++;
					}
					
					if (dimOn) {
						var lineHolder2:Sprite = new Sprite();
							lineHolder2.graphics.lineStyle(obj.stroke_thickness,obj.stroke_color,obj.stroke_alpha);
							lineHolder2.graphics.drawRect(0,0, w, 30);
							lineHolder2.x = 0;
							lineHolder2.y = linet * m;
						listHolder.addChild(lineHolder2);
						
						var txt_dimension:AddSimpleText = new AddSimpleText(des_w,th,"left",  obj.text_color, obj.text_size);
							txt_dimension.textCont = "Dim:";
							txt_dimension.x = shiftx;
							txt_dimension.y = 5;
						lineHolder2.addChild(txt_dimension);
						
						var txt_w :AddSimpleText= new AddSimpleText(var_w,th,"right",  obj.text_color, obj.text_size);
							txt_w.textCont = "w: ";
							txt_w.x = des_w;
							txt_w.y = 5;
						lineHolder2.addChild(txt_w);
						
						var txt_h:AddSimpleText = new AddSimpleText(var_w,th,"right",  obj.text_color, obj.text_size);
							txt_h.textCont = "h: ";
							txt_h.x = des_w + var_w + data_w;
							txt_h.y = 5;
						lineHolder2.addChild(txt_h);

						var txt_r:AddSimpleText = new AddSimpleText(var_w,th,"right",  obj.text_color, obj.text_size);
							txt_r.textCont = "r: ";
							txt_r.x = des_w + 2*var_w + 2*data_w;
							txt_r.y = 5;
						lineHolder2.addChild(txt_r);
						
						/*
						if(indicatorsOn){
							var txt_w_box:DrawBox = new DrawBox(des_w, 5, 10, 10);
							lineHolder2.addChild(txt_w_box);
							var txt_h_box:DrawBox = new DrawBox(des_w + var_w + data_w, 5, 10, 10);
							lineHolder2.addChild(txt_h_box);
							var txt_r_box:DrawBox = new DrawBox(des_w + 2*var_w + 2*data_w, 5, 10, 10);
							lineHolder2.addChild(txt_r_box);
						}
						*/
						
						// dynamic values
						var txt_w_value:AddSimpleText = new AddSimpleText(data_w,th, "left", obj.text_color, obj.text_size);
							txt_w_value.x = des_w + var_w ;
							txt_w_value.y = 5;
						lineHolder2.addChild(txt_w_value);
						
						var txt_h_value:AddSimpleText = new AddSimpleText(data_w,th, "left",  obj.text_color, obj.text_size);
							txt_h_value.x = des_w + 2*var_w + data_w;
							txt_h_value.y = 5;
						lineHolder2.addChild(txt_h_value);
						
						var txt_r_value:AddSimpleText = new AddSimpleText(data_w,th, "left",  obj.text_color, obj.text_size);
							txt_r_value.x = des_w + 3*var_w + 2*data_w;
							txt_r_value.y = 5;
						lineHolder2.addChild(txt_r_value);
						
						// pass refence to object
						listObject.w_value = txt_w_value;
						listObject.h_value = txt_h_value;
						listObject.r_value = txt_r_value;
						/*
						if(indicatorsOn){
							listObject.w_box = txt_w_box;
							listObject.h_box = txt_h_box;
							listObject.r_box = txt_r_box;
						}*/
						m++;
					}
					if (sepOn) {
						var lineHolder3:Sprite = new Sprite();
							lineHolder3.graphics.lineStyle(obj.stroke_thickness,obj.stroke_color,obj.stroke_alpha);
							lineHolder3.graphics.drawRect(0,0, w, 30);
							lineHolder3.x = 0;
							lineHolder3.y = linet * m;
						listHolder.addChild(lineHolder3);
						
						var txt_separation:AddSimpleText = new AddSimpleText(des_w,th,"left",  obj.text_color, obj.text_size);
							txt_separation.textCont = "Sep:";
							txt_separation.x = shiftx;
							txt_separation.y = shifty;
						lineHolder3.addChild(txt_separation);
						
						var txt_scalex:AddSimpleText = new AddSimpleText(var_w,th,"right",  obj.text_color, obj.text_size);
							txt_scalex.textCont = "sx: ";
							txt_scalex.x = des_w ;
							txt_scalex.y = shifty;
						lineHolder3.addChild(txt_scalex);

						var txt_scaley:AddSimpleText = new AddSimpleText(var_w,th,"right",  obj.text_color, obj.text_size);
							txt_scaley.textCont = "sy: ";
							txt_scaley.x = des_w + var_w + data_w;
							txt_scaley.y = shifty;
						lineHolder3.addChild(txt_scaley);
						
						/*
						if(indicatorsOn){
							var txt_sepx_box:DrawBox = new DrawBox(des_w, 5, 10, 10);
							lineHolder3.addChild(txt_sepx_box);
							var txt_sepy_box:DrawBox = new DrawBox(des_w + var_w + data_w, 5, 10, 10);
							lineHolder3.addChild(txt_sepy_box);
						}
						*/
						
						// dynamic values
						var txt_scalex_value:AddSimpleText = new AddSimpleText(data_w,th, "left",  obj.text_color, obj.text_size);
							txt_scalex_value.x = des_w + var_w;
							txt_scalex_value.y = shifty;
						lineHolder3.addChild(txt_scalex_value);
						
						var txt_scaley_value:AddSimpleText = new AddSimpleText(data_w,th, "left",  obj.text_color, obj.text_size);
							txt_scaley_value.x = des_w + 2*var_w + data_w;
							txt_scaley_value.y = shifty;
						lineHolder3.addChild(txt_scaley_value);
						
						// pass refence to object
						listObject.scalex_value = txt_scalex_value;
						listObject.scaley_value = txt_scaley_value;
						/*
						if(indicatorsOn){
							listObject.sepx_box = txt_sepx_box;
							listObject.sepy_box = txt_sepy_box;
						}*/
						m++;
					}
					
					if (rotOn) {
						var lineHolder4:Sprite = new Sprite();
							lineHolder4.graphics.lineStyle(obj.stroke_thickness,obj.stroke_color,obj.stroke_alpha);
							lineHolder4.graphics.drawRect(0,0, w, 30);
							lineHolder4.x = 0;
							lineHolder4.y = linet * m;
						listHolder.addChild(lineHolder4);
						
						var txt_rotation:AddSimpleText = new AddSimpleText(des_w,th,"left",  obj.text_color, obj.text_size);
							txt_rotation.textCont = "Rot:";
							txt_rotation.x = shiftx;
							txt_rotation.y = shifty;
						lineHolder4.addChild(txt_rotation);
						
						var txt_rotation_sgn:AddSimpleText = new AddSimpleText(var_w,th,"right",  obj.text_color, obj.text_size);
							txt_rotation_sgn.textCont = "θ";//δ Ψ
							txt_rotation_sgn.x = des_w ;
							txt_rotation_sgn.y = shifty;
						lineHolder4.addChild(txt_rotation_sgn);
						
						/*
						if(indicatorsOn){
							var txt_rot_box:DrawBox = new DrawBox(des_w, 5, 10, 10);
							lineHolder4.addChild(txt_rot_box);
						}*/
						
						// dynamic values
						var txt_rotation_value:AddSimpleText = new AddSimpleText(data_w,th, "left",  obj.text_color, obj.text_size);
							txt_rotation_value.x = des_w + var_w;
							txt_rotation_value.y = shifty;
						lineHolder4.addChild(txt_rotation_value);
						
						// pass refence to object
						listObject.rotation_value = txt_rotation_value;
						/*
						if(indicatorsOn){
							listObject.rot_box = txt_rot_box;
						}*/

						m++;
					}
					
					////////////////////////////////////////////////////////
					if (velOn) {
						var lineHolder5:Sprite = new Sprite();
							lineHolder5.graphics.lineStyle(obj.stroke_thickness,obj.stroke_color,obj.stroke_alpha);
							lineHolder5.graphics.drawRect(0,0, w, 30);
							lineHolder5.x = 0;
							lineHolder5.y = linet * m;
						listHolder.addChild(lineHolder5);
						
						var txt_velocity:AddSimpleText = new AddSimpleText(des_w,th,"left",  obj.text_color, obj.text_size);
							txt_velocity.textCont = "Vel:";
							txt_velocity.x = shiftx;
							txt_velocity.y = shifty;
						lineHolder5.addChild(txt_velocity);
						
						var txt_dx:AddSimpleText = new AddSimpleText(var_w,th,"right",  obj.text_color, obj.text_size);
							txt_dx.textCont = "δx";
							txt_dx.x = des_w ;
							txt_dx.y = shifty;
						lineHolder5.addChild(txt_dx);
						
						var txt_dy:AddSimpleText = new AddSimpleText(var_w,th,"right",  obj.text_color, obj.text_size);
							txt_dy.textCont = "δy";
							txt_dy.x = des_w + var_w + data_w ;
							txt_dy.y = shifty;
						lineHolder5.addChild(txt_dy);

						var txt_dtheta:AddSimpleText = new AddSimpleText(var_w,th,"right",  obj.text_color, obj.text_size);
							txt_dtheta.textCont = "δθ";
							txt_dtheta.x = des_w + 2*var_w + 2*data_w;
							txt_dtheta.y = shifty;
						lineHolder5.addChild(txt_dtheta);

						var txt_ds:AddSimpleText = new AddSimpleText(var_w,th,"right",  obj.text_color, obj.text_size);
							txt_ds.textCont = "δs";
							txt_ds.x = des_w + 3*var_w + 3*data_w ;
							txt_ds.y = shifty;
						lineHolder5.addChild(txt_ds);
						
						/*
						if(indicatorsOn){
							var txt_dx_box:DrawBox = new DrawBox(des_w, 5, 10, 10);
							lineHolder5.addChild(txt_dx_box);
							var txt_dy_box:DrawBox = new DrawBox(des_w + var_w + data_w, 5, 10, 10);
							lineHolder5.addChild(txt_dy_box);
							var txt_dtheta_box:DrawBox = new DrawBox(des_w + 2*var_w + 2*data_w, 5, 10, 10);
							lineHolder5.addChild(txt_dtheta_box);
							var txt_ds_box:DrawBox = new DrawBox(des_w + 3*var_w + 3*data_w, 5, 10, 10);
							lineHolder5.addChild(txt_ds_box);
						}*/
						
						// dynamic values
						var txt_dx_value:AddSimpleText = new AddSimpleText(data_w,th, "left",  obj.text_color, obj.text_size);
							txt_dx_value.x = des_w + var_w;
							txt_dx_value.y = shifty;
						lineHolder5.addChild(txt_dx_value);
						
						var txt_dy_value:AddSimpleText = new AddSimpleText(data_w,th, "left",  obj.text_color, obj.text_size);
							txt_dy_value.x = des_w + 2*var_w + data_w;
							txt_dy_value.y = shifty;
						lineHolder5.addChild(txt_dy_value);
						
						var txt_dtheta_value:AddSimpleText = new AddSimpleText(data_w,th, "left",  obj.text_color, obj.text_size);
							txt_dtheta_value.x = des_w + 3*var_w + 2*data_w;
							txt_dtheta_value.y = shifty;
						lineHolder5.addChild(txt_dtheta_value);
						
						var txt_ds_value:AddSimpleText = new AddSimpleText(data_w,th, "left",  obj.text_color, obj.text_size);
							txt_ds_value.x = des_w + 4*var_w + 3*data_w;
							txt_ds_value.y = shifty;
						lineHolder5.addChild(txt_ds_value);
						
						// pass refence to object
						listObject.dx_value = txt_dx_value;
						listObject.dy_value = txt_dy_value;
						listObject.dtheta_value = txt_dtheta_value;
						listObject.ds_value = txt_ds_value;
						
						/*
						if(indicatorsOn){
							listObject.dx_box = txt_dx_box;
							listObject.dy_box = txt_dy_box;
							listObject.dtheta_box = txt_dtheta_box;
							listObject.ds_box = txt_ds_box;
						}
						*/
						m++;
					}
					if (accelOn) {
						var lineHolder6:Sprite = new Sprite();
							lineHolder6.graphics.lineStyle(obj.stroke_thickness,obj.stroke_color,obj.stroke_alpha);
							lineHolder6.graphics.drawRect(0,0, w, 30);
							lineHolder6.x = 0;
							lineHolder6.y = linet * m;
						listHolder.addChild(lineHolder6);
						
						var txt_acceleration:AddSimpleText = new AddSimpleText(des_w,th,"left",  obj.text_color, obj.text_size);
							txt_acceleration.textCont = "Accel:";
							txt_acceleration.x = shiftx;
							txt_acceleration.y = shifty;
						lineHolder6.addChild(txt_acceleration);
						
						var txt_ddx:AddSimpleText = new AddSimpleText(var_w,th,"right",  obj.text_color, obj.text_size);
							txt_ddx.textCont = "δδx";
							txt_ddx.x = des_w ;
							txt_ddx.y = shifty;
						lineHolder6.addChild(txt_ddx);

						var txt_ddy:AddSimpleText = new AddSimpleText(var_w,th,"right",  obj.text_color, obj.text_size);
							txt_ddy.textCont = "δδy";
							txt_ddy.x = des_w + var_w + data_w ;
							txt_ddy.y = shifty;
						lineHolder6.addChild(txt_ddy);
						
						var txt_ddtheta:AddSimpleText = new AddSimpleText(var_w,th,"right",  obj.text_color, obj.text_size);
							txt_ddtheta.textCont = "δδθ";
							txt_ddtheta.x = des_w + 2*var_w + 2*data_w;
							txt_ddtheta.y = shifty;
						lineHolder6.addChild(txt_ddtheta);
						
						var txt_dds:AddSimpleText = new AddSimpleText(var_w,th,"right",  obj.text_color, obj.text_size);
							txt_dds.textCont = "δδs";
							txt_dds.x = des_w + 3*var_w + 3*data_w ;
							txt_dds.y = shifty;
						lineHolder6.addChild(txt_dds);
						
						/*
						if(indicatorsOn){
							var txt_ddx_box:DrawBox = new DrawBox(des_w , 5, 10, 10);
							lineHolder6.addChild(txt_ddx_box);
							var txt_ddy_box:DrawBox = new DrawBox(des_w + var_w + data_w , 5, 10, 10);
							lineHolder6.addChild(txt_ddy_box);
							var txt_ddtheta_box:DrawBox = new DrawBox(des_w + 2*var_w + 2*data_w , 5, 10, 10);
							lineHolder6.addChild(txt_ddtheta_box);
							var txt_dds_box:DrawBox = new DrawBox(des_w + 3*var_w + 3*data_w  , 5, 10, 10);
							lineHolder6.addChild(txt_dds_box);
						}
						*/
						
						// dynamic values
						var txt_ddx_value:AddSimpleText = new AddSimpleText(data_w,th, "left",  obj.text_color, obj.text_size);
							txt_ddx_value.x = des_w + var_w;
							txt_ddx_value.y = shifty;
						lineHolder6.addChild(txt_ddx_value);
						
						var txt_ddy_value:AddSimpleText = new AddSimpleText(data_w,th, "left",  obj.text_color, obj.text_size);
							txt_ddy_value.x = des_w + 2*var_w + data_w;
							txt_ddy_value.y = shifty;
						lineHolder6.addChild(txt_ddy_value);
						
						var txt_ddtheta_value:AddSimpleText = new AddSimpleText(data_w,th, "left",  obj.text_color, obj.text_size);
							txt_ddtheta_value.x = des_w + 3*var_w + 2*data_w;
							txt_ddtheta_value.y = shifty;
						lineHolder6.addChild(txt_ddtheta_value);
						
						var txt_dds_value:AddSimpleText = new AddSimpleText(data_w,th, "left", obj.text_color, obj.text_size);
							txt_dds_value.x = des_w + 4*var_w + 3*data_w;
							txt_dds_value.y = shifty;
						lineHolder6.addChild(txt_dds_value);
						
						// pass refence to object
						listObject.ddx_value = txt_ddx_value;
						listObject.ddy_value = txt_ddy_value;
						listObject.ddtheta_value = txt_ddtheta_value;
						listObject.dds_value = txt_dds_value;
						
						/*
						if(indicatorsOn){
							listObject.ddx_box = txt_ddx_box;
							listObject.ddy_box = txt_ddy_box;
							listObject.ddtheta_box = txt_ddtheta_box;
							listObject.dds_box = txt_dds_box;
						}*/
						m++;
					}
				}
			}
	//	}
			
	public function drawDataList():void
	{	
		//setStyles();
		
		//if(obj.displayOn=="true"){
		
		// dynamic vars
		id = clusterObject.id;
		NumPoints = clusterObject.n;
		_x = clusterObject.x;
		_y = clusterObject.y;
		w = clusterObject.width;
		h = clusterObject.height;
		r = clusterObject.radius; 
		sep = clusterObject.separation
		sepx = clusterObject.separation
		sepy = clusterObject.separation
		rot = clusterObject.rotation; 
		orientation = clusterObject.orientation; 
		dx = clusterObject.dx;
		dy = clusterObject.dy;
		dw = clusterObject.dw;
		dh = clusterObject.dh;
		dr = clusterObject.dr; 
		ds = clusterObject.ds
		dtheta = clusterObject.dtheta / 4;
		ddx = clusterObject.ddx;
		ddy = clusterObject.ddy;
		// ddw: = clusterObject.dw;
		// ddh:Number = clusterObject.dh;
		// ddr:Number = clusterObject.dr; 
		dds = clusterObject.dds
		ddtheta = clusterObject.ddtheta / 4;
		dist = (r + 150) * (1 / Math.sqrt(2));
		
		// set list holder properties
		listHolder.visible = true;
		listHolder.x = _x + dist;
		listHolder.y = _y - dist;
		
		////////////////////////////////////////////////////////////////////////
		// not put threshold state logic into cluster analysis
		/////////////////////////////////////////////////////////////////////
		if (idOn) {
			listObject.id_value.textCont = id//Math.round(100*x)*0.01;
			listObject.n_value.textCont = NumPoints;
		}
		
		
		// set position values
		if (posOn) {
			listObject.x_value.textCont = Math.round(x)//Math.round(100*x)*0.01;
			listObject.y_value.textCont = Math.round(y);
			
			/*
			if(indicatorsOn){
				if ((x < x_max)&&(x>x_min))		listObject.x_box.boxColor = green;
				else if (Math.abs(x) < x_min)	listObject.x_box.boxColor = blue;
				else if (Math.abs(x) > x_max)	listObject.x_box.boxColor = red;
				else if (x == 0)				listObject.x_box.boxColor = white;
				//else if (x == undefined)		listObject.x_box.boxColor = black;
				
				
				if ((y < y_max)&&(y>y_min))		listObject.y_box.boxColor = green;
				else if (Math.abs(y) < y_min)	listObject.y_box.boxColor = blue;
				else if (Math.abs(y) >y_max)	listObject.y_box.boxColor = red;
				else if (y == 0)				listObject.y_box.boxColor = white;
				//else if (y == undefined)		listObject.y_box.boxColor = black;
			}*/
		}
		
		if (dimOn) {
			listObject.w_value.textCont = Math.round(w);
			listObject.h_value.textCont = Math.round(h);
			listObject.r_value.textCont = Math.round(r);
			
			/*
			if(indicatorsOn){
				if ((w < w_max)&&(w>w_min))		listObject.w_box.boxColor = green;
				else if (Math.abs(w) < w_min)	listObject.w_box.boxColor = blue;
				else if (Math.abs(w) >w_max)	listObject.w_box.boxColor = red;
				else if (w == 0)				listObject.w_box.boxColor = white;
				//else if (w == undefined)		listObject.w_box.boxColor = black;
				
				if ((h < h_max)&&(h>h_min))		listObject.h_box.boxColor = green;
				else if (Math.abs(h) < h_min)	listObject.h_box.boxColor = blue;
				else if (Math.abs(h) >h_max)	listObject.h_box.boxColor = red;
				else if (h == 0)				listObject.h_box.boxColor = white;
				//else if (h == undefined)		listObject.h_box.boxColor = black;
				
				if ((r < r_max)&&(r>r_min))		listObject.r_box.boxColor = green;
				else if (Math.abs(r) < r_min)	listObject.r_box.boxColor = blue;
				else if (Math.abs(r) >r_max)	listObject.r_box.boxColor = red;
				else if (r == 0)				listObject.r_box.boxColor = white;
				//else if (r == undefined)		listObject.r_box.boxColor = black;
			}*/
			
		}
		if (sepOn) {
			listObject.scalex_value.textCont = sep;//Math.round(separation);
			listObject.scaley_value.textCont = sep;//Math.round(separation);
			
			/*
			if(indicatorsOn){
				if ((sepx < sepx_max)&&(sepx>sepx_min))		listObject.sepx_box.boxColor = green;
				else if (Math.abs(sepx) < sepx_min)		listObject.sepx_box.boxColor = blue;
				else if (Math.abs(sepx) >sepx_max)		listObject.sepx_box.boxColor = red;
				else if (sepx == 0)						listObject.sepx_box.boxColor = white;
				//else if (sepx == undefined)				listObject.sepx_box.boxColor = black;
				
				if ((sepy < sepy_max)&&(sepy>sepy_min))		listObject.sepy_box.boxColor = green;
				else if (Math.abs(sepy) < sepy_min)		listObject.sepy_box.boxColor = blue;
				else if (Math.abs(sepy) >sepy_max)		listObject.sepy_box.boxColor = red;
				else if (sepy == 0)						listObject.sepy_box.boxColor = white;
				//else if (sepy == undefined)				listObject.sepy_box.boxColor = black;
			}*/
		}
		if (rotOn) {
			listObject.rotation_value.textCont = rot//Math.round(rotation);
			
			/*
			if(indicatorsOn){
				if ((rot < rot_max)&&(rot>rot_min))		listObject.rot_box.boxColor = green;
				else if (Math.abs(rot) < rot_min)		listObject.rot_box.boxColor = blue;
				else if (Math.abs(rot) >rot_max)		listObject.rot_box.boxColor = red;
				else if (rot == 0)						listObject.rot_box.boxColor = white;
				//else if (rot == undefined)				listObject.rot_box.boxColor = black;
			}*/
			
		}
		if (velOn) {
			// velocity values
			listObject.dx_value.textCont = dx//Math.round(dx);
			listObject.dy_value.textCont = dy//Math.round(dy);
			listObject.ds_value.textCont = ds//Math.round(ds);
			listObject.dtheta_value.textCont = dtheta//Math.round(dtheta);
			
			/*
			if(indicatorsOn){
				// color code values
				if ((dx < dx_max)&&(dx>dx_min))		listObject.dx_box.boxColor = green;
				else if (Math.abs(dx) < dx_min)		listObject.dx_box.boxColor = blue;
				else if (Math.abs(dx) >dx_max)		listObject.dx_box.boxColor = red;
				else if (dx == 0)					listObject.dx_box.boxColor = white;
				//else if (dx == undefined)			listObject.dx_box.boxColor = black;
				
				if ((dy < dy_max)&&(dy>dy_min))		listObject.dy_box.boxColor = green;
				else if (Math.abs(dy) < dy_min)		listObject.dy_box.boxColor = blue;
				else if (Math.abs(dy) >dy_max)		listObject.dy_box.boxColor = red;
				else if (dy == 0)					listObject.dy_box.boxColor = white;
				//else if (dy == undefined)			listObject.dy_box.boxColor = black;
				
				if ((ds < ds_max)&&(ds>ds_min))		listObject.ds_box.boxColor = green;
				else if (Math.abs(ds) < ds_min)		listObject.ds_box.boxColor = blue;
				else if (Math.abs(ds) > ds_max)		listObject.ds_box.boxColor = red;
				else if (ds == 0)					listObject.ds_box.boxColor = white;
				//else if (ds == undefined)			listObject.ds_box.boxColor = black;
				
				if ((dtheta < dtheta_max)&&(dtheta>dtheta_min))		listObject.dtheta_box.boxColor = green;
				else if (Math.abs(dtheta) < dtheta_min)				listObject.dtheta_box.boxColor = blue;
				else if (Math.abs(dtheta) >dtheta_max)				listObject.dtheta_box.boxColor = red;
				else if (dtheta == 0)								listObject.dtheta_box.boxColor = white;
				//else if (dtheta == undefined)						listObject.dtheta_box.boxColor = black;
			}*/
			
		}
		if (accelOn) {
			listObject.ddx_value.textCont = Math.round(ddx*100)*0.01;
			listObject.ddy_value.textCont = Math.round(ddy*100)*0.01;
			listObject.dds_value.textCont = Math.round(dds*100)*0.01;
			listObject.ddtheta_value.textCont = Math.round(ddtheta*100)*0.01;
			/*
			if(indicatorsOn){
				// color code values
				if ((ddx < ddx_max)&&(ddx>ddx_min))		listObject.ddx_box.boxColor = green;
				else if (Math.abs(dx) < dx_min)			listObject.ddx_box.boxColor = blue;
				else if (Math.abs(dx) > dx_max)			listObject.ddx_box.boxColor = red;
				else if (dx == 0)						listObject.ddx_box.boxColor = white;
				//else if (dx == undefined)				listObject.ddx_box.boxColor = black;
				
				if ((ddy < ddy_max)&&(ddy>ddy_min))		listObject.ddy_box.boxColor = green;
				else if (Math.abs(ddy) < ddy_min)		listObject.ddy_box.boxColor = blue;
				else if (Math.abs(ddy) > ddy_max)		listObject.ddy_box.boxColor = red;
				else if (ddy == 0)						listObject.ddy_box.boxColor = white;
				//else if (ddy == undefined)				listObject.ddy_box.boxColor = black;
				
				if ((dds < dds_max)&&(dds>dds_min))		listObject.dds_box.boxColor = green;
				else if (Math.abs(dds) < dds_min)		listObject.dds_box.boxColor = blue;
				else if (Math.abs(dds) > dds_max)		listObject.dds_box.boxColor = red;
				else if (dds == 0)						listObject.dds_box.boxColor = white;
				//else if (dds == undefined)				listObject.dds_box.boxColor = black;
				
				if ((ddtheta < ddtheta_max)&&(dtheta>ddtheta_min))		listObject.ddtheta_box.boxColor = green;
				else if (Math.abs(ddtheta) < ddtheta_min)				listObject.ddtheta_box.boxColor = blue;
				else if (Math.abs(ddtheta) > ddtheta_max)				listObject.ddtheta_box.boxColor = red;
				else if (ddtheta == 0)									listObject.ddtheta_box.boxColor = white;
				//else if (ddtheta == undefined)							listObject.ddtheta_box.boxColor = black;
			}
			*/
		}
	}
	//}

	public function clear():void
	{
		listHolder.visible = false;
		//listHolder.lineHolder.graphics.clear();
		//dataDisplay.removeChild(listHolder)
		//listHolder.removeChild(dataDisplay)
	}
	public function setStyles():void
	{
		cml = new XMLList(CML.Objects)
		var numLayers:int = cml.DebugKit.DebugLayer.length()
		
		for (var i:int = 0; i < numLayers; i++) {
			var type:String = cml.DebugKit.DebugLayer[i].attribute("type")
			
			if (type == "cluster_data_list") {
				//trace("cluster data list")
			//	obj.displayOn = cml.DebugKit.DebugLayer[i].attribute("displayOn")//3;
				obj.stroke_thickness = cml.DebugKit.DebugLayer[i].attribute("stroke_thickness")//3;
				obj.stroke_color = cml.DebugKit.DebugLayer[i].attribute("stroke_color")//0xFFFFFF;
				obj.stroke_alpha = cml.DebugKit.DebugLayer[i].attribute("stroke_alpha")//1;
				obj.fill_color = cml.DebugKit.DebugLayer[i].attribute("fill_color")//0xFFFFFF;
				obj.fill_alpha = cml.DebugKit.DebugLayer[i].attribute("fill_alpha")//1;
				obj.text_color = cml.DebugKit.DebugLayer[i].attribute("text_color")//0xFFFFFF;
				obj.text_size = cml.DebugKit.DebugLayer[i].attribute("text_size")//12;
				obj.text_alpha = cml.DebugKit.DebugLayer[i].attribute("text_alpha")//1;
				obj.indicators = cml.DebugKit.DebugLayer[i].attribute("indicators")//"true";
				obj.radius = cml.DebugKit.DebugLayer[i].attribute("radius");
			}
		}
	}
	
	public function setOptions():void
	{
		posOn = true;
		dimOn = true;
		rotOn = true;
		sepOn = true;
		velOn = true;
		accelOn = true;
		indicatorsOn = true;
	}
	
	
}
}