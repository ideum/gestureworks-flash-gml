////////////////////////////////////////////////////////////////////////////////
//
//  IDEUM
//  Copyright 2011-2012 Ideum
//  All Rights Reserved.
//
//  GestureWorks
//
//  File:    DebugClusterOrientation.as
//  Authors:  Ideum
//             
//  NOTICE: Ideum permits you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////
package com.gestureworks.utils.debug
{
	import flash.display.Shape;
	import com.gestureworks.core.CML;
	
	import com.gestureworks.core.GestureGlobals;
	import com.gestureworks.core.gw_public;
	
	import com.gestureworks.objects.ClusterObject;

	public class DebugClusterOrientation extends Shape
	{
		private static var cml:XMLList;
		private var obj:Object;
		private var cO:ClusterObject;
		private var pointList:Object;
		private var NumPoints:Number;
		
		private var _x:Number = 0
		private var _y: Number = 0
		private var x0:Number = 0
		private var y0:Number = 0;
		private var theta:Number = 0
		
		public function DebugClusterOrientation(ID:Number)
		{
			//trace("init cluster center");
			cO = GestureGlobals.gw_public::clusters[ID];
			
			/////////////////////////////////////////////
			// set default style 
			/////////////////////////////////////////////

			obj = new Object
			obj.displayOn = "false";
				obj.stroke_thickness = 10;
				obj.stroke_color = 0xFF0000;
				obj.stroke_alpha = 0.5;
				obj.radius = 200;
		}
			
	
	public function drawOrientation():void
	{
		pointList = cO.pointArray
		NumPoints = pointList.length
		
		//////////////////////////////////////////////////////////////////////////////////////////////////
		// draw thimb ring
		//////////////////////////////////////////////////////////////////////////////////////////////////
					
		if(NumPoints==5){
			
			graphics.clear();
			graphics.lineStyle(obj.stroke_thickness,obj.stroke_color, obj.stroke_alpha);
			
			//trace("thumb",cO.thumbID)
					
					for (var i:int = 0; i < NumPoints; i++) 
						{
							if (pointList[i].id == cO.thumbID)
							{	
								graphics.drawCircle(pointList[i].point.x, pointList[i].point.y, 40);
							}
						}
					
		
		////////////////////////////////////////////////////////////////////////////////////////////////
		// draw orientation vector based on 4 fingers
		////////////////////////////////////////////////////////////////////////////////////////////////

		//graphics.lineStyle(obj.stroke_thickness,obj.stroke_color, obj.stroke_alpha);
		//trace("orient", cO.orient_dx, cO.orient_dy)	
		
		// draw hand vector
		graphics.moveTo(cO.x, cO.y);
		graphics.lineTo(cO.x + cO.orient_dx * 3, cO.y + cO.orient_dy * 3);
		
		//graphics.lineStyle(obj.stroke_thickness,0x00FF00, obj.stroke_alpha);
		//graphics.moveTo(clusterObject.x, clusterObject.y);
		//graphics.lineTo(clusterObject.x + clusterObject.o1_dx * 3, clusterObject.y + clusterObject.o1_dy * 3);
		
		//graphics.lineStyle(obj.stroke_thickness,0xFFFFFF, obj.stroke_alpha);
		//graphics.moveTo(clusterObject.x, clusterObject.y);
		//graphics.lineTo(clusterObject.x + clusterObject.o2_dx * 3, clusterObject.y + clusterObject.o2_dy * 3);
		
		}

	}
	
	public function setStyles():void
	{
		cml = new XMLList(CML.Objects)
		var numLayers:int = cml.DebugKit.DebugLayer.length()
		
		for (var i:int = 0; i < numLayers; i++) {
			var type:String = cml.DebugKit.DebugLayer[i].attribute("type")
		
			if (type == "cluster_orientation") {
				//trace("cluster orientation style");
				//obj.displayOn = cml.DebugKit.DebugLayer[i].attribute("displayOn")//3;
				
				//obj.stroke_thickness = cml.DebugKit.DebugLayer[i].attribute("stroke_thickness")//3;
				//obj.stroke_color = cml.DebugKit.DebugLayer[i].attribute("stroke_color")//0xFFFFFF;
				//obj.stroke_alpha = cml.DebugKit.DebugLayer[i].attribute("stroke_alpha")//1;
				//obj.radius = objectList.object[1].layer[8].attribute("radius")//20;
			}
		}
	}
	
	
	public function clear():void
	{
		graphics.clear();
	}
}
}