////////////////////////////////////////////////////////////////////////////////
//
//  IDEUM
//  Copyright 2011-2012 Ideum
//  All Rights Reserved.
//
//  GestureWorks
//
//  File:    DebugClusterCenter.as
//  Authors:  Ideum
//             
//  NOTICE: Ideum permits you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////
package com.gestureworks.visualizer
{
	import com.gestureworks.objects.ipClusterObject;
	import flash.display.Shape;
	import flash.geom.Vector3D;
	import flash.display.Sprite;
	import flash.utils.Dictionary;

	import com.gestureworks.core.GestureGlobals;
	import com.gestureworks.core.gw_public;
	import com.gestureworks.objects.InteractionPointObject;
	import com.gestureworks.objects.ClusterObject;
	import com.gestureworks.utils.AddSimpleText;
	
	public class ClusterVisualizer extends Shape//Sprite
	{
		private static const RAD_DEG:Number = 180 / Math.PI;
		public var style:Object;
		private var id:Number = 0;
		
		private var _x:Number = 0;
		private var _y:Number = 0;
		private var _width:Number = 0;
		private var _height: Number = 0;
		private var x0:Number = 0;
		private var y0:Number = 0;
		
		// rotation
		private var _radius:Number = 200
		private var _rotation:Number = 0
		private var _orientation:Number = 0
		private var _dtheta:Number = 0
		private var _ds:Number = 0
		
		private var step:Number =  0
		private var percent:Number = 0
		private var r2:Number = 0
		private var r1:Number = 0
		private var sA:Number = 0
		private var eA:Number = 0
		private var numSteps:Number = 0
		
		private var tpn:uint = 0;
		private var ipn:uint = 0;
		public var maxPoints:int = 20;
		
		private var iptext_array:Array = new Array();
		private var iPointClusterList:Dictionary = new Dictionary();
		private var cO:ClusterObject
			
		public function ClusterVisualizer(ID:Number)
		{
			//trace("init cluster visualizer");
			id = ID;
			cO = GestureGlobals.gw_public::clusters[id];
			iPointClusterList = GestureGlobals.gw_public::iPointClusterLists[id];
			
			/////////////////////////////////////////////
			// set default style 
			/////////////////////////////////////////////

			style = new Object
				style.stroke_thickness = 3;
				style.stroke_color = 0xFFAE1F;
				style.stroke_alpha = 0.8;
				style.fill_color = 0xFFAE1F;
				style.fill_alpha = 0.8;
				style.radius = 20;
				
				// circle
				style.c_stroke_thickness = 16;
				style.c_stroke_alpha = 0.6;
				
				//web
				style.web_shape = "starweb";

				//orientation
				//style.t_stroke_thickness = 10;
				//style.t_stroke_color = 0xFF0000;
				//style.t_stroke_alpha = 0.5;
				
				// rotation
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
				
				
				/*
			// create text fields
			for (var i:uint = 0; i < maxPoints; i++) 
			{
				iptext_array[i] = new AddSimpleText(500, 100, "left", style.motion_text_color, 12, "left");
					iptext_array[i].visible = false;
					iptext_array[i].mouseEnabled = false;
				addChild(iptext_array[i]);
			}*/
				
		}
	
	public function clear():void
	{
		graphics.clear();
		//for (var i:uint = 0; i < iptext_array.length; i++) iptext_array[i].visible = false;
	}
	
	public function draw():void
	{
		//ipn = cO.iPointArray.length;
		graphics.clear();
		drawRootClusterDims(); // for center trans viz
		drawInteractionPoints();
		drawSubClusterDims();
		//trace("draw", tpn,ipn, ts.ipn, cO.ipn,cO.iPointArray2D.length);
	}
	
	
	private function drawRootClusterDims():void
	{	
		if (cO.ipn)
			{
			style.stroke_color = 0xFFAE1F;
			_x = cO.position.x;
			_y = cO.position.y;
			_width = cO.size.x-2;
			_height = cO.size.y-2;
			_radius = cO.radius+5;
			
			if(_drawRadius){
				// draw bounding circle
				graphics.lineStyle(style.c_stroke_thickness,style.stroke_color,style.c_stroke_alpha);
				graphics.drawCircle(_x, _y, _radius);
			}
			
			// set line style
			graphics.lineStyle(style.stroke_thickness,style.stroke_color,style.stroke_alpha);
			
			if(_drawCenter){
				// draw cluster center position
				graphics.drawCircle(_x, _y, style.radius);
			}
			
			if(_drawBisector){
				// draw bi-sectors
				graphics.moveTo(_x,_y+_height/2);
				graphics.lineTo(_x,_y-_height/2);
				graphics.moveTo(_x-_width/2,_y);
				graphics.lineTo(_x + _width / 2, _y);
			}
			
			if(_drawBox){
			// draw bunding box
			graphics.drawRect(_x - _width / 2, _y - _height / 2, _width, _height);
			}
			
			if(_drawWeb){
					// draw web links tyo center
					for (var k:int = 0; k < tpn; k++) {
						for (var l:int=0; l<tpn; l++){
							if (k != l) {
								graphics.lineStyle(3, style.stroke_color, style.stroke_alpha);
								graphics.moveTo(cO.iPointArray[k].position.x,cO.iPointArray[k].position.y);
								graphics.lineTo(cO.iPointArray[l].position.x,cO.iPointArray[l].position.y);
							}
						}
					}
			}
			
			
			}
	}
	
	private function drawInteractionPoints():void
	{
		//trace("viz interaction pt",ipn, cO.ipn,cO.iPointArray.length);
		//if (ipn)
		for each (var iPointCluster:ipClusterObject in iPointClusterList) 
		
			var ipn:int = iPointCluster.ipn;
			{
				for (var i:uint = 0; i < ipn; i++) 
					{
						var ipt:InteractionPointObject = iPointCluster.iPointArray[i] as InteractionPointObject;
						
						//INTERACTIONPOINT TEXT DATA
						
						/*
						if (iptext_array[i])
						{
							iptext_array[i].textCont = "IP ID: " + ipt.interactionPointID;
							if (ipt.mode=="motion"){
								iptext_array[i].x = ipt.screen_position.x - iptext_array[i].width / 2;
								iptext_array[i].y = ipt.screen_position.y - 55;
							}
							else {
								iptext_array[i].x = ipt.position.x - iptext_array[i].width / 2;
								iptext_array[i].y = ipt.position.y - 55;
							}
							iptext_array[i].visible = true;
							iptext_array[i].textColor = style.touch_text_color;
						}*/
						

						if (ipt.mode == "motion")
						{
								if (_drawWeb)
								{	
									for (var j:uint = 0; j < i+1; j++) 
									{
										if (i != j)
										{
											var ipt2:InteractionPointObject = iPointCluster.iPointArray[j] as InteractionPointObject;
											// draw line to palm point
											graphics.lineStyle(3, style.stroke_color, style.stroke_alpha);
											graphics.moveTo(ipt.screen_position.x ,ipt.screen_position.y);
											graphics.lineTo(ipt2.screen_position.x , ipt2.screen_position.y);
										}
									}
									
								}	
								// draw finger
								if (ipt.type == "finger")
								{
									graphics.lineStyle(3, 0x00FF00, style.stroke_alpha);
									graphics.drawCircle(ipt.screen_position.x , ipt.screen_position.y, style.radius + 10);
								}
								// draw thumb
								if (ipt.type == "thumb")
								{
									graphics.lineStyle(3, 0xFF0000, style.stroke_alpha);
									graphics.drawCircle(ipt.screen_position.x , ipt.screen_position.y, style.radius + 10);
								}
								// palm point and radius 
								if (ipt.type == "palm")
								{
									var hr:Number = ipt.radius * 0.5 + ipt.position.z;
									graphics.lineStyle(3, 0xFFFFFF, style.stroke_alpha);
									graphics.drawCircle(ipt.screen_position.x , ipt.screen_position.y, hr);
								}
								// draw pinch
								if (ipt.type == "pinch") 
								{
									graphics.lineStyle(3, 0x00FFFF, style.stroke_alpha);
									graphics.drawCircle(ipt.screen_position.x, ipt.screen_position.y, style.radius);
								}
							
								// for trigger
								if (ipt.type == "trigger") //PURPLE 0xc44dbe
								{
									var tgr:Number = 30;
									var triggerThreshold:Number = 0.5
									// set style
									graphics.lineStyle(3, 0xc44dbe, style.stroke_alpha);
									// draw cross
									graphics.moveTo (ipt.screen_position.x - tgr, ipt.screen_position.y);
									graphics.lineTo (ipt.screen_position.x + tgr , ipt.screen_position.y);
									graphics.moveTo (ipt.screen_position.x, ipt.screen_position.y- tgr);
									graphics.lineTo (ipt.screen_position.x,ipt.screen_position.y + tgr);
									//draw cricle
									graphics.drawCircle(ipt.screen_position.x, ipt.screen_position.y, tgr - 10);

									// check extension
									if (ipt.extension < triggerThreshold) {
										graphics.drawCircle(ipt.screen_position.x, ipt.screen_position.y, style.radius+20);
									}
								}
								
								// draw PUSH
								if (ipt.type == "fist") //grey //
								{
									graphics.lineStyle(3, 0x777777, style.stroke_alpha);
									graphics.drawCircle(ipt.screen_position.x, ipt.screen_position.y, style.radius);
								}
								
								// draw PUSH
								if (ipt.type == "push") //yellow 0xFFFF00 //
								{
									graphics.lineStyle(3, 0xFFFF00, style.stroke_alpha);
									graphics.drawCircle(ipt.screen_position.x, ipt.screen_position.y, style.radius);
								}
								
								// draw FRAME
								if (ipt.type == "frame") //0xE3716B; //
								{
									graphics.lineStyle(3, 0xE3716B, style.stroke_alpha);
									graphics.drawCircle(ipt.screen_position.x, ipt.screen_position.y, style.radius);
								}
								// draw HOOK
								if (ipt.type == "hook") //0x0000FF //blue
								{
									graphics.lineStyle(3, 0x0000FF, style.stroke_alpha);
									graphics.drawCircle(ipt.screen_position.x, ipt.screen_position.y, style.radius);
								}
								//draw TOOL
								if (ipt.type == "tool") //0xE3716B; //
								{
									graphics.lineStyle(3, 0xFFFF00, style.stroke_alpha);
									graphics.drawCircle(ipt.screen_position.x, ipt.screen_position.y, style.radius);
								}
								// draw finger average
								if (ipt.type == "finger_average") //0x000000; //black
								{
									graphics.lineStyle(3, 0x000000, style.stroke_alpha);
									graphics.drawCircle(ipt.screen_position.x, ipt.screen_position.y, style.radius);
								}
								
								////////////////////////////////////////////////////////
								//FACE
								if (ipt.type == "gaze") //0x000000; //black
								{
									graphics.lineStyle(3, 0x000000, style.stroke_alpha);
									graphics.drawCircle(ipt.screen_position.x, ipt.screen_position.y, style.radius);
								}
								if (ipt.type == "eye") //0x000000; //black and blue
								{
									trace("drawing eye interaciton point");
									graphics.lineStyle(20, 0x000000, style.stroke_alpha);
									graphics.drawCircle(ipt.screen_position.x, ipt.screen_position.y, style.radius);
									graphics.lineStyle(10, 0x000066, style.stroke_alpha);
									graphics.drawCircle(ipt.screen_position.x, ipt.screen_position.y, style.radius+20);
								}
								
								
						}
						
						else if (ipt.mode == "touch")
						{
								if (_drawWeb)
								{	
									for (var j:uint = 0; j < i+1; j++) 
									{
										if (i != j)
										{
											var ipt2:InteractionPointObject = iPointCluster.iPointArray[j] as InteractionPointObject//cO.iPointArray2D[j];
											// draw line to palm point
											graphics.lineStyle(3, 0xFF0000, style.stroke_alpha);
											graphics.moveTo(ipt.position.x ,ipt.position.y);
											graphics.lineTo(ipt2.position.x , ipt2.position.y);
										}
									}
									
								}	
								
								//trace("Cluster ip vis", ipt.type)
								
								if ( ipt.type == "finger")//finger
								{
									// sensor center
									graphics.lineStyle(2, 0xFFFFFF, style.stroke_alpha);
									graphics.beginFill(0xFF0000, style.fill_alpha);
									graphics.drawCircle(ipt.position.x, ipt.position.y, style.radius);
									graphics.endFill();
									
								}
								else if (ipt.type == "pen")
								{
									// sensor center
									graphics.lineStyle(2, 0xFFFFFF, style.stroke_alpha);
									graphics.beginFill(0x00FFFF, style.fill_alpha);
									graphics.drawCircle(ipt.position.x, ipt.position.y, style.radius-10);
									graphics.endFill();
								}
								
								else if (ipt.type == "tag")
								{
									// sensor center
									graphics.lineStyle(2, 0xFFFFFF, style.stroke_alpha);
									graphics.beginFill(0xFF0000, style.fill_alpha);
									graphics.drawCircle(ipt.position.x, ipt.position.y, style.radius+10);
									graphics.endFill();
								}
						}
						
						else if (ipt.mode == "sensor")
						{
							//accelelrometer
							if (ipt.type == "accelerometer")//finger
							{
							
							}
							//controller
							if (ipt.type == "controller")//finger
							{
									
							}
						}

					}
			}
	}
	
	
	private function drawSubClusterDims():void
	{	
		//trace("draw",ipn,scn)
		for each (var iPointCluster:ipClusterObject in iPointClusterList) 
				{
				if (iPointCluster.mode=="motion" && iPointCluster.active)
				{
						var sub_cO:ipClusterObject = iPointCluster; //= cO.finger_cO;
						var sipn:int = sub_cO.ipn;
			
						// DO FOR EACH EXISTING NONZERO SUBCLUSTER
						if ((sipn!=0)&&(sub_cO))
							{
							//trace("hello",sub_cO.type);	
							
						
									if (sub_cO.type == "finger") style.stroke_color = 0x00FF00;//0x00FFFF;
									if (sub_cO.type == "thumb") style.stroke_color = 0xFF0000;//0x00FFFF;
									if (sub_cO.type == "digit") style.stroke_color = 0x4B7BCC;
									if (sub_cO.type == "palm") style.stroke_color = 0xFFFFFF;
									if (sub_cO.type == "finger_average") style.stroke_color = 0x000000;
							
									if (sub_cO.type == "trigger") style.stroke_color = 0xc44dbe;//0x00FFFF;
									if (sub_cO.type == "pinch") style.stroke_color = 0x00FFFF;//0x00FFFF;
									if (sub_cO.type == "frame") style.stroke_color = 0xE3716B;//0x00FFFF;
									if (sub_cO.type == "push") style.stroke_color = 0xFFFF00;//0x00FFFF;
									if (sub_cO.type == "hook") style.stroke_color = 0x0000FF;
									if (sub_cO.type == "fist") style.stroke_color = 0x777777;
									
									//if (sub_cO.type == "tool") style.stroke_color = 0x0000FF;
									
									
									_x = sub_cO.position.x;
									_y = sub_cO.position.y;
									_width = sub_cO.size.x;
									_height = sub_cO.size.y;
									
									_radius = sub_cO.radius-50 -i*10;
									_rotation = sub_cO.rotation; 
						 
									_dtheta = sub_cO.dtheta / 4;
									_ds = sub_cO.ds*10;
									
									x0 = 0
									y0 = 0
									
									step =  0.01;
									percent = style.percent;
									numSteps = Math.abs(Math.round(_dtheta / step));
									r2 = _radius * percent;
									r1 = _radius * (percent + 0.2);
									
									if(Math.abs(_orientation)>=360){
										_orientation = 0;
									}
									sA = _orientation/RAD_DEG
									eA = _orientation/RAD_DEG + _dtheta;

									///////////////////////////////////////////////////////////////////////////////////
									// 	DRAW SHAPES
									///////////////////////////////////////////////////////////////////////////////////
								
									if(_drawRadius){
										// draw bounding circle
										graphics.lineStyle(style.c_stroke_thickness,style.stroke_color,style.c_stroke_alpha);
										graphics.drawCircle(_x, _y, _radius);
									}
									
									// set line style
									graphics.lineStyle(style.stroke_thickness,style.stroke_color,style.stroke_alpha);
									
									if(_drawCenter){
										// draw cluster center position
										graphics.drawCircle(_x, _y, style.radius-5);
									}
									
									if(_drawBisector){
										// draw bi-sectors
										graphics.moveTo(_x,_y+_height/2);
										graphics.lineTo(_x,_y-_height/2);
										graphics.moveTo(_x-_width/2,_y);
										graphics.lineTo(_x + _width / 2, _y);
									}
									
									if(_drawBox){
									// draw bunding box
									//graphics.drawRect(_x - _width / 2, _y - _height / 2, _width, _height);
									}
									
									/*
									if(_drawWeb){
									// draw web links tyo center
									if (style.web_shape == "fullweb") {
											for (var k:int = 0; k < tpn; k++) {
												
												var pt:TouchPointObject = sub_cO.iPointArray[k]//touchArray[k];
												
													for (var l:int=0; l<tpn; l++){
														if (k != l) {
															var pt1:TouchPointObject = sub_cO.iPointArray[l]//touchArray[l];
															//trace(i,j)
															graphics.moveTo(pt.position.x,pt.position.y);
															graphics.lineTo(pt1.position.x,pt1.position.y);
														}
													}
											}
									}
									}*/
									
									
										
									
							if (_drawRotation) {
								
								//	trace("vis rotation", cO.dtheta);
								//////////////////////////////////////////////////////////////////////////////////
								// draw rotation
								//////////////////////////////////////////////////////////////////////////////////
								if (style.rotation_shape == "segment") {

											//trace("redraw segment",orientation);
											//counter clockwise
											if (_dtheta < 0) {
												
												//needs work to get counting correct--------------------------------------//
												graphics.lineStyle(style.a_stroke_thickness, style.a_stroke_color, style.a_stroke_alpha);
												
												graphics.moveTo(_x + r2 * Math.cos(sA), _y + r2 * Math.sin(sA));
												graphics.lineTo(_x + r1 * Math.cos(sA), _y + r1 * Math.sin(sA));
												graphics.beginFill(style.a_fill_color,style.a_fill_alpha);
												
												for (var theta0:Number = sA; theta0 > eA; theta0 -= step) 
												{
													graphics.lineTo(_x + r1*Math.cos(theta0), _y + r1*Math.sin(theta0));
												}
												graphics.lineTo(_x + r2*Math.cos(eA), _y + r2*Math.sin(eA));
											
												for (var theta:Number = eA; theta < sA; theta += step) 
													{
													graphics.lineTo(_x + r2*Math.cos(theta), _y + r2*Math.sin(theta));
												}
												graphics.endFill();
											}
											
											// clockwise
											if (_dtheta > 0) {
												graphics.lineStyle(style.b_stroke_thickness, style.b_stroke_color, style.b_stroke_alpha);
												
												graphics.moveTo(_x + r2 * Math.cos(sA), _y + r2 * Math.sin(sA));
												graphics.lineTo(_x + r1 * Math.cos(sA),_y + r1 * Math.sin(sA));
												graphics.beginFill(style.b_fill_color,style.b_fill_alpha);
												
												for (var i:int = 0; i < numSteps; i++) {
													var theta1:Number = i*step + sA;
													graphics.lineTo(_x + r1*Math.cos(theta1), _y + r1*Math.sin(theta1));
												}
												graphics.lineTo(_x + r1*Math.cos(eA), _y + r1*Math.sin(eA));
												graphics.lineTo(_x + r2*Math.cos(eA), _y + r2*Math.sin(eA));
											
												for (var j:int = 0; j < numSteps; j++) {
													var theta2:Number = -j*step + eA;
													graphics.lineTo(_x + r2*Math.cos(theta2), _y + r2*Math.sin(theta2));
												}
												graphics.lineTo(_x + r2 * Math.cos(sA), _y + r2 * Math.sin(sA));
												graphics.endFill();
											}
								}
							}
							
							
							
							if (_drawSeparation)
							{
							//	trace("vis scale",_ds)
							
								if (_ds < -0.1) // contract
								{
									graphics.lineStyle(style.c_stroke_thickness-20 +20*Math.abs(5*_ds) ,style.a_stroke_color,0.3);
									graphics.drawCircle(_x, _y, _radius +20);
								}
								else if (_ds > 0.1) //expand
								{
									graphics.lineStyle(style.c_stroke_thickness-20 +20*Math.abs(5*_ds) ,style.b_stroke_color,0.3);
									graphics.drawCircle(_x, _y, _radius +20);
								}
							}		
						
					}			
			}
			
		if (iPointCluster.mode=="touch" && iPointCluster.active)
				{
					//var ctype:String = cO.tsubClusterArray[c].type
						var sub_cO:ipClusterObject = iPointCluster; //= cO.finger_cO;
						var sipn:int = sub_cO.ipn;
			
						// DO FOR EACH EXISTING NONZERO SUBCLUSTER
						if ((sipn!=0)&&(sub_cO))
							{
							//trace("hello",sub_cO.type);	
							
									if (sub_cO.type == "finger") style.stroke_color = 0xFF0000;//0x00FFFF;
									if (sub_cO.type == "pen") style.stroke_color = 0x00FF00;//0x00FFFF;
									if (sub_cO.type == "tag") style.stroke_color = 0x0000FF;//0x00FFFF;
									
							
									_x = sub_cO.position.x;
									_y = sub_cO.position.y;
									_width = sub_cO.size.x;
									_height = sub_cO.size.y;
									_radius = sub_cO.radius;
									_rotation = sub_cO.rotation; 
						 
									_dtheta = sub_cO.dtheta / 4;
									_ds = sub_cO.ds*10;
									
									x0 = 0
									y0 = 0
									
									step =  0.01;
									percent = style.percent;
									numSteps = Math.abs(Math.round(_dtheta / step));
									r2 = _radius * percent;
									r1 = _radius * (percent + 0.2);
									
									if(Math.abs(_orientation)>=360){
										_orientation = 0;
									}
									sA = _orientation/RAD_DEG
									eA = _orientation/RAD_DEG + _dtheta;

									///////////////////////////////////////////////////////////////////////////////////
									// 	DRAW SHAPES
									///////////////////////////////////////////////////////////////////////////////////
								
									if(_drawRadius){
										// draw bounding circle
										graphics.lineStyle(style.c_stroke_thickness,style.stroke_color,style.c_stroke_alpha);
										graphics.drawCircle(_x, _y, _radius);
									}
									
									// set line style
									graphics.lineStyle(style.stroke_thickness,style.stroke_color,style.stroke_alpha);
									
									if(_drawCenter){
										// draw cluster center position
										graphics.drawCircle(_x, _y, style.radius-5);
									}
									
									if(_drawBisector){
										// draw bi-sectors
										graphics.moveTo(_x,_y+_height/2);
										graphics.lineTo(_x,_y-_height/2);
										graphics.moveTo(_x-_width/2,_y);
										graphics.lineTo(_x + _width / 2, _y);
									}
									
									if(_drawBox){
									// draw bunding box
									graphics.drawRect(_x - _width / 2, _y - _height / 2, _width, _height);
									}
									
									/*
									if(_drawWeb){
									// draw web links tyo center
									if (style.web_shape == "fullweb") {
											for (var k:int = 0; k < tpn; k++) {
												
												var pt:TouchPointObject = sub_cO.iPointArray[k]//touchArray[k];
												
													for (var l:int=0; l<tpn; l++){
														if (k != l) {
															var pt1:TouchPointObject = sub_cO.iPointArray[l]//touchArray[l];
															//trace(i,j)
															graphics.moveTo(pt.position.x,pt.position.y);
															graphics.lineTo(pt1.position.x,pt1.position.y);
														}
													}
											}
									}
									}*/
									
									
										
									
							if (_drawRotation) {
								
								//	trace("vis rotation", cO.dtheta);
								//////////////////////////////////////////////////////////////////////////////////
								// draw rotation
								//////////////////////////////////////////////////////////////////////////////////
								if (style.rotation_shape == "segment") {

											//trace("redraw segment",orientation);
											//counter clockwise
											if (_dtheta < 0) {
												
												//needs work to get counting correct--------------------------------------//
												graphics.lineStyle(style.a_stroke_thickness, style.a_stroke_color, style.a_stroke_alpha);
												
												graphics.moveTo(_x + r2 * Math.cos(sA), _y + r2 * Math.sin(sA));
												graphics.lineTo(_x + r1 * Math.cos(sA), _y + r1 * Math.sin(sA));
												graphics.beginFill(style.a_fill_color,style.a_fill_alpha);
												
												for (var theta0:Number = sA; theta0 > eA; theta0 -= step) 
												{
													graphics.lineTo(_x + r1*Math.cos(theta0), _y + r1*Math.sin(theta0));
												}
												graphics.lineTo(_x + r2*Math.cos(eA), _y + r2*Math.sin(eA));
											
												for (var theta:Number = eA; theta < sA; theta += step) 
													{
													graphics.lineTo(_x + r2*Math.cos(theta), _y + r2*Math.sin(theta));
												}
												graphics.endFill();
											}
											
											// clockwise
											if (_dtheta > 0) {
												graphics.lineStyle(style.b_stroke_thickness, style.b_stroke_color, style.b_stroke_alpha);
												
												graphics.moveTo(_x + r2 * Math.cos(sA), _y + r2 * Math.sin(sA));
												graphics.lineTo(_x + r1 * Math.cos(sA),_y + r1 * Math.sin(sA));
												graphics.beginFill(style.b_fill_color,style.b_fill_alpha);
												
												for (var i:int = 0; i < numSteps; i++) {
													var theta1:Number = i*step + sA;
													graphics.lineTo(_x + r1*Math.cos(theta1), _y + r1*Math.sin(theta1));
												}
												graphics.lineTo(_x + r1*Math.cos(eA), _y + r1*Math.sin(eA));
												graphics.lineTo(_x + r2*Math.cos(eA), _y + r2*Math.sin(eA));
											
												for (var j:int = 0; j < numSteps; j++) {
													var theta2:Number = -j*step + eA;
													graphics.lineTo(_x + r2*Math.cos(theta2), _y + r2*Math.sin(theta2));
												}
												graphics.lineTo(_x + r2 * Math.cos(sA), _y + r2 * Math.sin(sA));
												graphics.endFill();
											}
								}
							}
							
							
							
							if (_drawSeparation)
							{
							//	trace("vis scale",_ds)
							
								if (_ds < -0.1) // contract
								{
									graphics.lineStyle(style.c_stroke_thickness-20 +20*Math.abs(5*_ds) ,style.a_stroke_color,0.3);
									graphics.drawCircle(_x, _y, _radius +20);
								}
								else if (_ds > 0.1) //expand
								{
									graphics.lineStyle(style.c_stroke_thickness-20 +20*Math.abs(5*_ds) ,style.b_stroke_color,0.3);
									graphics.drawCircle(_x, _y, _radius +20);
								}
							}		
						
					}
				}
				
				
		}
	}
	

	
	/**
	* @private
	*/
	private var _drawBisector:Boolean = true;
	/**
	* draw cluster bisectors.
	*/
	public function get drawBisector():Boolean { return _drawBisector; }
	public function set drawBisector(value:Boolean):void { _drawBisector = value; }
	/**
	* @private
	*/
	private var _drawRadius:Boolean = true;
	/**
	* draw cluster radius.
	*/
	public function get drawRadius():Boolean { return _drawRadius; }
	public function set drawRadius(value:Boolean):void { _drawRadius = value; }
	/**
	* @private
	*/
	private var _drawCenter:Boolean = true;
	/**
	* draw draw center.
	*/
	public function get drawCenter():Boolean { return _drawCenter; }
	public function set drawCenter(value:Boolean):void { _drawCenter = value; }
	/**
	* @private
	*/
	private var _drawBox:Boolean = true;
	/**
	* draw draw bounding box.
	*/
	public function get drawBox():Boolean { return _drawBox; }
	public function set drawBox(value:Boolean):void { _drawBox = value; }
	
	/**
	* @private
	*/
	private var _drawWeb:Boolean = true;
	/**
	* draw draw bounding Web.
	*/
	public function get drawWeb():Boolean { return _drawWeb; }
	public function set drawWeb(value:Boolean):void { _drawWeb = value; }
	
	/**
	* @private
	*/
	private var _drawRotation:Boolean = true;
	/**
	* draw draw rotation.
	*/
	public function get drawRotation():Boolean { return _drawRotation; }
	public function set drawRotation(value:Boolean):void { _drawRotation = value; }
	
	/**
	* @private
	*/
	private var _drawSeparation:Boolean = true;
	/**
	* draw draw Separation.
	*/
	public function get drawSeparation():Boolean { return _drawSeparation; }
	public function set drawSeparation(value:Boolean):void { _drawSeparation = value; }
	
	
	/**
	* @private
	*/
	private var _drawPairs:Boolean = true;
	/**
	* draw point Pairs.
	*/
	public function get drawPairs():Boolean { return _drawPairs; }
	public function set drawPairs(value:Boolean):void { _drawPairs = value; }
	
	/**
	* @private
	*/
	private var _drawThumb:Boolean = true;
	/**
	* draw thumb.
	*/
	public function get drawThumb():Boolean { return _drawThumb; }
	public function set drawThumb(value:Boolean):void { _drawThumb = value; }
	
	
	/**
	* @private
	*/
	private var _drawPalm:Boolean = true;
	/**
	* draw Palm.
	*/
	public function get drawPalm():Boolean { return _drawPalm; }
	public function set drawPalm(value:Boolean):void { _drawPalm = value; }
	

}
}