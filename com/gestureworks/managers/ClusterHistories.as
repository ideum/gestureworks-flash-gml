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
	import flash.utils.Dictionary;
	
	public class ClusterHistories 
	{
		//////////////////////////////////////////////////////
		// based on a cluster move event
		//////////////////////////////////////////////////////
		
		public static function historyQueue(clusterObject:ClusterObject):void//ClusterID:Object//event:ClusterEvent
		{
			//var clusterObject:ClusterObject = GestureGlobals.gw_public::clusters[ClusterID]
			
			//var history:Vector.<ClusterObject> = clusterObject.history;
			
			clusterObject.history.unshift(historyObject(clusterObject));
			
			if (clusterObject.history.length-1>=GestureGlobals.clusterHistoryCaptureLength)
			{
				clusterObject.history.pop();
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
				
				if (object.position)
				{
				object.position.x = clusterObject.position.x;
				object.position.y = clusterObject.position.y;
				object.position.z = clusterObject.position.z; //-
				}
				
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
				//object.iPointArray2D = clusterObject.iPointArray2D;
				
				// aggregate values
				//objec.velocity = clusterObject.velocity;
				//objec.acceleration = clusterObject.acceleration;
				//object.jolt = clusterObject.jolt;
				
				object.handList = clusterObject.handList;
				
				
				//object.iPointClusterList = new Dictionary ();//clusterObject.iPointClusterList
				clusterObject.iPointClusterList = GestureGlobals.gw_public::iPointClusterLists[clusterObject.id]
				
				//trace("calling hist",clusterObject.iPointClusterList,clusterObject.iPointClusterList["pinch"] );

				for each (var iPointCluster in clusterObject.iPointClusterList) 
				{
					
					var index:String = iPointCluster.type; 
					//trace("history",index);
					
					//object.iPointClusterList.index = iPointCluster;
					
					if (iPointCluster.active)
					{
						object.iPointClusterList.index = new ipClusterObject()//clusterObject.finger_cO;
					
						object.iPointClusterList.index.ipn = iPointCluster.ipn;
						object.iPointClusterList.index.ipnk = iPointCluster.ipnk;
						object.iPointClusterList.index.ipnk0 = iPointCluster.ipnk0;
						object.iPointClusterList.index.dipn = iPointCluster.dipn;

						object.iPointClusterList.index.position.x = iPointCluster.position.x;
						object.iPointClusterList.index.position.y = iPointCluster.position.y;
						object.iPointClusterList.index.position.z = iPointCluster.position.z;
						
						object.iPointClusterList.index.radius = iPointCluster.radius;
						object.iPointClusterList.index.width = iPointCluster.width;
						object.iPointClusterList.index.height = iPointCluster.height;
						object.iPointClusterList.index.length = iPointCluster.length;
						
						object.iPointClusterList.index.rotation = iPointCluster.rotation;
						object.iPointClusterList.index.rotationX = iPointCluster.rotationX;
						object.iPointClusterList.index.rotationY = iPointCluster.rotationY;
						object.iPointClusterList.index.rotationZ = iPointCluster.rotationZ;
						
						object.iPointClusterList.index.separation = iPointCluster.separation;
						object.iPointClusterList.index.separationX = iPointCluster.separationX;
						object.iPointClusterList.index.separationY = iPointCluster.separationY;
						object.iPointClusterList.index.separationZ =iPointCluster.separationZ;
						
						
						object.iPointClusterList.index.dx = iPointCluster.dx;
						object.iPointClusterList.index.dy =iPointCluster.dy;
						object.iPointClusterList.index.dz = iPointCluster.dz;
						
						object.iPointClusterList.index.ds = iPointCluster.ds;
						object.iPointClusterList.index.dsx = iPointCluster.dsx;
						object.iPointClusterList.index.dsy = iPointCluster.dsy;
						object.iPointClusterList.index.dsz = iPointCluster.dsz;
						
						object.iPointClusterList.index.dtheta = iPointCluster.dtheta;
						object.iPointClusterList.index.dthetaX = iPointCluster.dthetaX;
						object.iPointClusterList.index.dthetaY = iPointCluster.dthetaY;
						object.iPointClusterList.index.dthetaZ = iPointCluster.dthetaZ;
						
						// aggregate values
						object.iPointClusterList.index.velocity = iPointCluster.velocity;
						object.iPointClusterList.index.acceleration = iPointCluster.acceleration;
						object.iPointClusterList.index.jolt = iPointCluster.jolt;
						
						object.iPointClusterList.index.rotationList = iPointCluster.rotationList;
					}
				}	
				
				//Gesture Points DATA simple timeline
				object.gPointArray = clusterObject.gPointArray;
				
				//trace("cluster history push")

			return object;
		}
		
	}

}