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
				
				object.position.x = clusterObject.position.x;
				object.position.y = clusterObject.position.y;
				object.position.z = clusterObject.position.z; //-
				
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
				
				object.handList = clusterObject.handList;
				
				
				
				///////////////////////////////////////////////////////////////
				//MOTION SUBCLUSTERS
				/////////////////////////////////////////////////////////////////
				var sipn:int = clusterObject.mSubClusterArray.length
			//	trace("hist motion subclusters", sipn);
				
				for (var i:uint = 0; i < sipn; i++) 
						{
					if (clusterObject.mSubClusterArray[i].active)	
						{
						object.mSubClusterArray[i] = new ipClusterObject()//clusterObject.finger_cO;
					
						object.mSubClusterArray[i].ipn = clusterObject.mSubClusterArray[i].ipn;
						object.mSubClusterArray[i].ipnk = clusterObject.mSubClusterArray[i].ipnk;
						object.mSubClusterArray[i].ipnk0 = clusterObject.mSubClusterArray[i].ipnk0;
						object.mSubClusterArray[i].dipn = clusterObject.mSubClusterArray[i].dipn;
						
						object.mSubClusterArray[i].position.x = clusterObject.mSubClusterArray[i].position.x;
						object.mSubClusterArray[i].position.y = clusterObject.mSubClusterArray[i].position.y;
						object.mSubClusterArray[i].position.z = clusterObject.mSubClusterArray[i].position.z;
						
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
				}
				
				///////////////////////////////////////////////////////////////
				//TOUCH SUBCLUSTERS
				/////////////////////////////////////////////////////////////////
				var tipn:int = clusterObject.tSubClusterArray.length
				//trace("hist touch subclusters", tipn);
				
				for (var i:uint = 0; i < tipn; i++) 
						{
					//trace("touch history active",clusterObject.tSubClusterArray[i].active);
					if (clusterObject.tSubClusterArray[i].active)	
						{	
						object.tSubClusterArray[i] = new ipClusterObject()//clusterObject.finger_cO;
						
						object.tSubClusterArray[i].ipn = clusterObject.tSubClusterArray[i].ipn;
						object.tSubClusterArray[i].ipnk = clusterObject.tSubClusterArray[i].ipnk;
						object.tSubClusterArray[i].ipnk0 = clusterObject.tSubClusterArray[i].ipnk0;
						object.tSubClusterArray[i].dipn = clusterObject.tSubClusterArray[i].dipn;
						
						object.tSubClusterArray[i].position.x = clusterObject.tSubClusterArray[i].position.x;
						object.tSubClusterArray[i].position.y = clusterObject.tSubClusterArray[i].position.y;
						object.tSubClusterArray[i].position.z = clusterObject.tSubClusterArray[i].position.z;
						
						object.tSubClusterArray[i].radius = clusterObject.tSubClusterArray[i].radius;
						object.tSubClusterArray[i].width = clusterObject.tSubClusterArray[i].width;
						object.tSubClusterArray[i].height = clusterObject.tSubClusterArray[i].height;
						object.tSubClusterArray[i].length = clusterObject.tSubClusterArray[i].length;
						
						object.tSubClusterArray[i].rotation = clusterObject.tSubClusterArray[i].rotation;
						object.tSubClusterArray[i].rotationX = clusterObject.tSubClusterArray[i].rotationX;
						object.tSubClusterArray[i].rotationY = clusterObject.tSubClusterArray[i].rotationY;
						object.tSubClusterArray[i].rotationZ = clusterObject.tSubClusterArray[i].rotationZ;
						
						object.tSubClusterArray[i].separation = clusterObject.tSubClusterArray[i].separation;
						object.tSubClusterArray[i].separationX = clusterObject.tSubClusterArray[i].separationX;
						object.tSubClusterArray[i].separationY = clusterObject.tSubClusterArray[i].separationY;
						object.tSubClusterArray[i].separationZ = clusterObject.tSubClusterArray[i].separationZ;
						
						
						object.tSubClusterArray[i].dx = clusterObject.tSubClusterArray[i].dx;
						object.tSubClusterArray[i].dy = clusterObject.tSubClusterArray[i].dy;
						object.tSubClusterArray[i].dz = clusterObject.tSubClusterArray[i].dz;
						
						object.tSubClusterArray[i].ds = clusterObject.tSubClusterArray[i].ds;
						object.tSubClusterArray[i].dsx = clusterObject.tSubClusterArray[i].dsx;
						object.tSubClusterArray[i].dsy = clusterObject.tSubClusterArray[i].dsy;
						object.tSubClusterArray[i].dsz = clusterObject.tSubClusterArray[i].dsz;
						
						object.tSubClusterArray[i].dtheta = clusterObject.tSubClusterArray[i].dtheta;
						object.tSubClusterArray[i].dthetaX = clusterObject.tSubClusterArray[i].dthetaX;
						object.tSubClusterArray[i].dthetaY = clusterObject.tSubClusterArray[i].dthetaY;
						object.tSubClusterArray[i].dthetaZ = clusterObject.tSubClusterArray[i].dthetaZ;
						
						// aggregate values
						object.tSubClusterArray[i].velocity = clusterObject.tSubClusterArray[i].velocity;
						object.tSubClusterArray[i].acceleration = clusterObject.tSubClusterArray[i].acceleration;
						object.tSubClusterArray[i].jolt = clusterObject.tSubClusterArray[i].jolt;
						
						object.tSubClusterArray[i].rotationList = clusterObject.tSubClusterArray[i].rotationList;
						}
				}
				
				///////////////////////////////////////////////////////////////
				//SENSOR SUBCLUSTERS
				/////////////////////////////////////////////////////////////////
				var sipn:int = clusterObject.sSubClusterArray.length
				//trace("hist sensor subcluster", sipn);
				
				for (var i:uint = 0; i < sipn; i++) 
						{
					if (clusterObject.sSubClusterArray[i].active) 
						{
						object.sSubClusterArray[i] = new ipClusterObject()//clusterObject.finger_cO;
					
						object.tSubClusterArray[i].ipn = clusterObject.sSubClusterArray[i].ipn;
						object.sSubClusterArray[i].ipnk = clusterObject.sSubClusterArray[i].ipnk;
						object.sSubClusterArray[i].ipnk0 = clusterObject.sSubClusterArray[i].ipnk0;
						object.sSubClusterArray[i].dipn = clusterObject.sSubClusterArray[i].dipn;
						
						object.sSubClusterArray[i].position.x = clusterObject.sSubClusterArray[i].position.x;
						object.sSubClusterArray[i].position.y = clusterObject.sSubClusterArray[i].position.y;
						object.sSubClusterArray[i].position.z = clusterObject.sSubClusterArray[i].position.z;
						
						object.sSubClusterArray[i].radius = clusterObject.sSubClusterArray[i].radius;
						object.sSubClusterArray[i].width = clusterObject.sSubClusterArray[i].width;
						object.sSubClusterArray[i].height = clusterObject.sSubClusterArray[i].height;
						object.sSubClusterArray[i].length = clusterObject.sSubClusterArray[i].length;
						
						object.sSubClusterArray[i].rotation = clusterObject.sSubClusterArray[i].rotation;
						object.sSubClusterArray[i].rotationX = clusterObject.sSubClusterArray[i].rotationX;
						object.sSubClusterArray[i].rotationY = clusterObject.sSubClusterArray[i].rotationY;
						object.sSubClusterArray[i].rotationZ = clusterObject.sSubClusterArray[i].rotationZ;
						
						object.sSubClusterArray[i].separation = clusterObject.sSubClusterArray[i].separation;
						object.sSubClusterArray[i].separationX = clusterObject.sSubClusterArray[i].separationX;
						object.sSubClusterArray[i].separationY = clusterObject.sSubClusterArray[i].separationY;
						object.sSubClusterArray[i].separationZ = clusterObject.sSubClusterArray[i].separationZ;
						
						
						object.sSubClusterArray[i].dx = clusterObject.sSubClusterArray[i].dx;
						object.sSubClusterArray[i].dy = clusterObject.sSubClusterArray[i].dy;
						object.sSubClusterArray[i].dz = clusterObject.sSubClusterArray[i].dz;
						
						object.sSubClusterArray[i].ds = clusterObject.sSubClusterArray[i].ds;
						object.sSubClusterArray[i].dsx = clusterObject.sSubClusterArray[i].dsx;
						object.sSubClusterArray[i].dsy = clusterObject.sSubClusterArray[i].dsy;
						object.sSubClusterArray[i].dsz = clusterObject.sSubClusterArray[i].dsz;
						
						object.sSubClusterArray[i].dtheta = clusterObject.sSubClusterArray[i].dtheta;
						object.sSubClusterArray[i].dthetaX = clusterObject.sSubClusterArray[i].dthetaX;
						object.sSubClusterArray[i].dthetaY = clusterObject.sSubClusterArray[i].dthetaY;
						object.sSubClusterArray[i].dthetaZ = clusterObject.sSubClusterArray[i].dthetaZ;
						
						// aggregate values
						object.sSubClusterArray[i].velocity = clusterObject.sSubClusterArray[i].velocity;
						object.sSubClusterArray[i].acceleration = clusterObject.sSubClusterArray[i].acceleration;
						object.sSubClusterArray[i].jolt = clusterObject.sSubClusterArray[i].jolt;
						
						object.sSubClusterArray[i].rotationList = clusterObject.sSubClusterArray[i].rotationList;
						}
				}
				
				
				
				//Gesture Points DATA simple timeline
				object.gPointArray = clusterObject.gPointArray;
				
				//trace("cluster history push")

			return object;
		}
		
	}

}