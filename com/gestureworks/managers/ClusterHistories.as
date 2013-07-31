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
	import com.gestureworks.objects.ipClusterObject;
	
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
				object.ipn = clusterObject.ipn;
				
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
				object.dz = clusterObject.dz; //3d
				
				object.ds = clusterObject.ds;
				//object.d3ds = clusterObject.d3ds; //3d chang in sep
				object.dsx = clusterObject.dsx;
				object.dsy = clusterObject.dsy;
				object.dsz = clusterObject.dsz; //-3d
				
				object.dtheta = clusterObject.dtheta;
				object.dthetaX = clusterObject.dthetaX;
				object.dthetaY = clusterObject.dthetaY;
				object.dthetaZ = clusterObject.dthetaZ;
				
				// second order primary deltas
				object.ddx = clusterObject.ddx;
				object.ddy = clusterObject.ddy;
				object.ddz = clusterObject.ddz;//-3d
				
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
				//object.path_data = clusterObject.path_data;
				
				//trace(object.path_data)
				//trace(clusterObject.pointArray[0].x)
				
				//object.handList = clusterObject.handList; 
				//MOTION FRAME DATA
				//object.motionArray = clusterObject.motionArray;
				
				//interaction DATA///////////////////////////////////////////
				object.iPointArray = clusterObject.iPointArray;
				object.iPointArray2D = clusterObject.iPointArray2D;
				//InteractionPoint subcluster matrix
				object.pinch_cO = clusterObject.pinch_cO;
				object.trigger_cO = clusterObject.trigger_cO;
				
				
				//object.finger_cO = clusterObject.finger_cO;
				object.finger_cO = new ipClusterObject()//clusterObject.finger_cO;
				
					object.finger_cO.ipn = clusterObject.finger_cO.ipn;
					object.finger_cO.x = clusterObject.finger_cO.x;
					object.finger_cO.y = clusterObject.finger_cO.y;
					object.finger_cO.z = clusterObject.finger_cO.z;
					
					object.finger_cO.radius = clusterObject.finger_cO.radius;
					object.finger_cO.width = clusterObject.finger_cO.width;
					object.finger_cO.height = clusterObject.finger_cO.height;
					object.finger_cO.length = clusterObject.finger_cO.length;
					
					object.finger_cO.rotation = clusterObject.finger_cO.rotation;
					object.finger_cO.rotationX = clusterObject.finger_cO.rotationX;
					object.finger_cO.rotationY = clusterObject.finger_cO.rotationY;
					object.finger_cO.rotationZ = clusterObject.finger_cO.rotationZ;
					
					object.finger_cO.separation = clusterObject.finger_cO.separation;
					object.finger_cO.separationX = clusterObject.finger_cO.separationX;
					object.finger_cO.separationY = clusterObject.finger_cO.separationY;
					object.finger_cO.separationZ = clusterObject.finger_cO.separationZ;
					
					//object.finger_cO.dipn = clusterObject.finger_cO.dipn;
					object.finger_cO.dx = clusterObject.finger_cO.dx;
					object.finger_cO.dy = clusterObject.finger_cO.dy;
					object.finger_cO.dz = clusterObject.finger_cO.dz;
					
					object.finger_cO.dtheta = clusterObject.finger_cO.dtheta;
				
				
				//SENSOR ACCELEROMETER DATA
				//object.sensorArray = clusterObject.sensorArray;
				
				
				
				//Gesture Points DATA simple timeline
				object.gPointArray = clusterObject.gPointArray;
				
				//trace("cluster history push")

			return object;
		}
		
	}

}