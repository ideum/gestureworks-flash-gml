////////////////////////////////////////////////////////////////////////////////
//
//  IDEUM
//  Copyright 2011-2012 Ideum
//  All Rights Reserved.
//
//  GestureWorks
//
//  File:    ClusterHistories.as
//  Authors:  Ideum
//             
//  NOTICE: Ideum permits you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////
package com.gestureworks.managers 
{
	/**
	 * ...
	 * @author Paul Lacey
	 */
	
	import com.gestureworks.core.GestureGlobals;
	import com.gestureworks.core.gw_public;
	import com.gestureworks.objects.ClusterObject;
	
	public class ClusterHistories 
	{
		//////////////////////////////////////////////////////
		// based on a cluster move event
		//////////////////////////////////////////////////////
		
		public static function historyQueue(ClusterID:Object):void//event:ClusterEvent
		{
			var clusterObject:ClusterObject = GestureGlobals.gw_public::clusters[ClusterID]
			var history:Vector.<ClusterObject> = clusterObject.history;
			
			history.unshift(historyObject(clusterObject));
			
			if (history.length-1>=GestureGlobals.clusterHistoryCaptureLength)
			{
				history.pop();
			}
		}
		
		// loads history object and returns value.
		public static function historyObject(clusterObject:ClusterObject):Object
		{
			var object:ClusterObject = new ClusterObject();
				
				// native properties
				object.n = clusterObject.n;
				object.fn = clusterObject.fn;//- total motion finger number
				object.rhfn = clusterObject.rhfn;//- right hand finger number
				object.lhfn = clusterObject.lhfn;//- left hand finger number
				
				object.x = clusterObject.x;
				object.y = clusterObject.y;
				object.z = clusterObject.z; //-
				
				object.width = clusterObject.width;
				object.height = clusterObject.height;
				object.length = clusterObject.length;//-
				
				object.radius = clusterObject.radius;
				object.orientation = clusterObject.orientation;
				
				object.rotation = clusterObject.rotation;
				object.separation = clusterObject.separation;
				
				object.thumbID = clusterObject.thumbID; //for 2D HAND
				
				// first order primary deltas
				object.dx = clusterObject.dx;
				object.dy = clusterObject.dy;
				object.dy = clusterObject.dz;
				
				object.ds = clusterObject.ds;
				//object.d3ds = clusterObject.d3ds; //3d chang in sep
				object.dsx = clusterObject.dsx;
				object.dsy = clusterObject.dsy;
				object.dsz = clusterObject.dsz; //-
				
				object.dtheta = clusterObject.dtheta;
				
				// second order primary deltas
				object.ddx = clusterObject.ddx;
				object.ddy = clusterObject.ddy;
				object.ddz = clusterObject.ddz;//-
				
				// core cluster events
				//object.add = clusterObject.add;
				//object.remove = clusterObject.remove;
				//object.point_add = clusterObject.point_add;
				//object.point_remove = clusterObject.point_remove;
				//object.translate = clusterObject.translate;
				//object.rotate = clusterObject.rotate;
				//object.separate = clusterObject.separate;
				//object.resize = clusterObject.resize;
				//object.acclerate = clusterObject.acclerate;
				//object.jolt = clusterObject.jolt;
				//object.split= clusterObject.split;
				//object.merge = clusterObject.merge;
				
				// STANDARD CLUSTER CALCS
				object.orient_dx = clusterObject.orient_dx;
				object.orient_dy = clusterObject.orient_dy;
				//object.orient_dz = clusterObject.orient_dz; // 
				
				
				// STROKE DATA
				object.path_data = clusterObject.path_data;
				
				//trace(object.path_data)
				//trace(clusterObject.pointArray[0].x)
				
				object.handList = clusterObject.handList; 
				
				//MOTION FRAME DATA
				//object.iPointArray = clusterObject.iPointArray;
				
				//MOTION FRAME DATA
				//object.motionArray = clusterObject.motionArray;
				
				//SENSOR ACCELEROMETER DATA
				//object.sensorArray = clusterObject.sensorArray;
				
				//trace("cluster history push")

			return object;
		}
		
	}

}