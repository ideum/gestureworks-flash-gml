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
			var history:Vector.<ClusterObject> = GestureGlobals.gw_public::clusters[ClusterID].history;
			var clusterObject:ClusterObject = GestureGlobals.gw_public::clusters[ClusterID]
		
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
				object.x = clusterObject.x;
				object.y = clusterObject.y;
				object.width = clusterObject.width;
				object.height = clusterObject.height;
				object.radius = clusterObject.radius;
				object.orientation = clusterObject.orientation;
				object.rotation = clusterObject.rotation;
				object.separation = clusterObject.separation;
				object.thumbID = clusterObject.thumbID;
				
				// first order primary deltas
				object.dx = clusterObject.dx;
				object.dy = clusterObject.dy;
				object.ds = clusterObject.ds;
				object.dsx = clusterObject.dsx;
				object.dsy = clusterObject.dsy;
				object.dtheta = clusterObject.dtheta;
				
				// second order primary deltas
				object.ddx = clusterObject.ddx;
				object.ddy = clusterObject.ddy;
				
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
				
				//object.pointArray = [2, 3]//;
				
				// STROKE DATA
				object.path_data = clusterObject.path_data;
				
				//trace(object.path_data)
				//trace(clusterObject.pointArray[0].x)

			return object;
		}
		
	}

}