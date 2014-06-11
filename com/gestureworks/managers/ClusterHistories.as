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
	import flash.geom.Vector3D;
	
	public class ClusterHistories 
	{
		//////////////////////////////////////////////////////
		// based on a cluster move event
		//////////////////////////////////////////////////////
		
		//var clusterObject:ClusterObject; 
		
		public static function historyQueue(clusterObject:ClusterObject):void//ClusterID:Object//event:ClusterEvent
		{
			//clusterObject = GestureGlobals.gw_public::Clusters[id]
			
			clusterObject.history.unshift(historyObject(clusterObject));
			
			if (clusterObject.history.length-1>=GestureGlobals.clusterHistoryCaptureLength)
			{
				clusterObject.history.pop();
			}
		}
		
		// loads history object and returns value.
		private static function historyObject(clusterObject:ClusterObject):Object
		{
			//clusterObject = GestureGlobals.gw_public::Clusters[id]
			clusterObject.iPointClusterList = GestureGlobals.gw_public::iPointClusterLists[clusterObject.id]

			var object:ClusterObject = new ClusterObject();
				
				// native properties
				object.n = clusterObject.n;
				object.fn = clusterObject.fn;//- total motion finger number
				object.ipn = clusterObject.ipn;
				
				object.radius = clusterObject.radius;
				if (clusterObject.size) object.position = new Vector3D(clusterObject.size.x, clusterObject.size.y, clusterObject.size.z);
				if (clusterObject.position) object.position = new Vector3D(clusterObject.position.x, clusterObject.position.y, clusterObject.position.z);

				//object.orientation = clusterObject.orientation;
				//object.rotation = clusterObject.rotation;
				///object.separation = clusterObject.separation;

				//interaction DATA///////////////////////////////////////////
				object.iPointArray = clusterObject.iPointArray;

				//trace("calling hist",clusterObject.iPointClusterList,clusterObject.iPointClusterList["pinch"] );

				//////////////////////////////////////////////////////////////////////////
				//CACHE VALUES FOR EACH ACTIVE SUBCLUSTER 
				for each (var iPointCluster:ipClusterObject in clusterObject.iPointClusterList) 
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

						if (iPointCluster.position) object.iPointClusterList.index.position = new Vector3D(iPointCluster.position.x,iPointCluster.position.y,iPointCluster.position.z);
					
						object.iPointClusterList.index.radius = iPointCluster.radius;
						if (iPointCluster.size) object.iPointClusterList.index.size = new Vector3D (iPointCluster.size.x,iPointCluster.size.y,iPointCluster.size.z);
					
						object.iPointClusterList.index.rotation = iPointCluster.rotation;
						if (iPointCluster.rotation3D) object.iPointClusterList.index.rotation3D = new Vector3D(iPointCluster.rotation3D.x,iPointCluster.rotation3D.y,iPointCluster.rotation3D.z);
					
						object.iPointClusterList.index.separation = iPointCluster.separation;
						if (iPointCluster.separation3D) object.iPointClusterList.index.separation3D = new Vector3D (iPointCluster.separation3D.x,iPointCluster.separation3D.y,iPointCluster.separation3D.z) ;
						
						
						
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