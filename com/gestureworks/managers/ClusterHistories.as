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
				//object.handednes = clusterObject.handednes; //for 2D HAND
				//object.pivot_dtheta = clusterObject.pivot_dtheta; 
		
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
				
				// aggregate values
				//objec.velocity = clusterObject.velocity;
				//objec.acceleration = clusterObject.acceleration;
				//object.jolt = clusterObject.jolt;
				
				
				var sipn:int = clusterObject.mSubClusterArray.length
				//trace("hist", sipn);
				
				for (var i:uint = 0; i < sipn; i++) 
						{
					
					object.mSubClusterArray[i] = new ipClusterObject()//clusterObject.finger_cO;
				
					object.mSubClusterArray[i].ipn = clusterObject.mSubClusterArray[i].ipn;
					object.mSubClusterArray[i].ipnk = clusterObject.mSubClusterArray[i].ipnk;
					object.mSubClusterArray[i].ipnk0 = clusterObject.mSubClusterArray[i].ipnk0;
					object.mSubClusterArray[i].dipn = clusterObject.mSubClusterArray[i].dipn;
					
					object.mSubClusterArray[i].x = clusterObject.mSubClusterArray[i].x;
					object.mSubClusterArray[i].y = clusterObject.mSubClusterArray[i].y;
					object.mSubClusterArray[i].z = clusterObject.mSubClusterArray[i].z;
					
					object.mSubClusterArray[i].radius = clusterObject.mSubClusterArray[i].radius;
					object.mSubClusterArray[i].width = clusterObject.mSubClusterArray[i].width;
					object.mSubClusterArray[i].height = clusterObject.mSubClusterArray[i].height;
					object.mSubClusterArray[i].length = clusterObject.mSubClusterArray[i].length;
					
					object.mSubClusterArray[i].rotation = clusterObject.mSubClusterArray[i].rotation;
					object.mSubClusterArray[i].rotationX = clusterObject.mSubClusterArray[i].rotationX;
					object.mSubClusterArray[i].rotationY = clusterObject.mSubClusterArray[i].rotationY;
					object.mSubClusterArray[i].rotationZ = clusterObject.mSubClusterArray[i].rotationZ;
					
					object.mSubClusterArray[i].separation = clusterObject.mSubClusterArray[i].separation;
					object.mSubClusterArray[i].separationX = clusterObject.mSubClusterArray[i].separationX;
					object.mSubClusterArray[i].separationY = clusterObject.mSubClusterArray[i].separationY;
					object.mSubClusterArray[i].separationZ = clusterObject.mSubClusterArray[i].separationZ;
					
					
					object.mSubClusterArray[i].dx = clusterObject.mSubClusterArray[i].dx;
					object.mSubClusterArray[i].dy = clusterObject.mSubClusterArray[i].dy;
					object.mSubClusterArray[i].dz = clusterObject.mSubClusterArray[i].dz;
					
					object.mSubClusterArray[i].ds = clusterObject.mSubClusterArray[i].ds;
					object.mSubClusterArray[i].dsx = clusterObject.mSubClusterArray[i].dsx;
					object.mSubClusterArray[i].dsy = clusterObject.mSubClusterArray[i].dsy;
					object.mSubClusterArray[i].dsz = clusterObject.mSubClusterArray[i].dsz;
					
					object.mSubClusterArray[i].dtheta = clusterObject.mSubClusterArray[i].dtheta;
					object.mSubClusterArray[i].dthetaX = clusterObject.mSubClusterArray[i].dthetaX;
					object.mSubClusterArray[i].dthetaY = clusterObject.mSubClusterArray[i].dthetaY;
					object.mSubClusterArray[i].dthetaZ = clusterObject.mSubClusterArray[i].dthetaZ;
					
					// aggregate values
					object.mSubClusterArray[i].velocity = clusterObject.mSubClusterArray[i].velocity;
					object.mSubClusterArray[i].acceleration = clusterObject.mSubClusterArray[i].acceleration;
					object.mSubClusterArray[i].jolt = clusterObject.mSubClusterArray[i].jolt;
					
					object.mSubClusterArray[i].rotationList = clusterObject.mSubClusterArray[i].rotationList;
					
				}
				
				//SENSOR ACCELEROMETER DATA
				//object.sensorArray = clusterObject.sensorArray;
				
				
				
				//Gesture Points DATA simple timeline
				object.gPointArray = clusterObject.gPointArray;
				
				//trace("cluster history push")

			return object;
		}
		
	}

}