////////////////////////////////////////////////////////////////////////////////
//
//  IDEUM
//  Copyright 2011-2012 Ideum
//  All Rights Reserved.
//
//  GestureWorks
//
//  File:    TouchMovieClipCluster.as
//  Authors:  Ideum
//             
//  NOTICE: Ideum permits you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////
package com.gestureworks.core
{
	import com.gestureworks.events.GWClusterEvent;
	import com.gestureworks.analysis.clusterKinemetric;
	//import com.gestureworks.analysis.clusterVectormetric;
	
	public class TouchMovieClipCluster extends TouchMovieClipBase
	{
		/**
		* @private
		*/
		private var cluster_kinemetric:clusterKinemetric;
		//private var cluster_vectormetric:Vectormetric;
		/**
		* @private
		*/
		private var kinemetricsOn:Boolean = true;
		//private var vectoremetricsOn:Boolean = true;
		
		
		public function TouchMovieClipCluster():void
		{
			super();
			initCluster();
          }
		  
		/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		// initializers
		/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
         /**
		* @private
		*/
        private function initCluster():void 
        {	
				//trace("create touchsprite cluster analysis")
				initClusterVars();
				initClusterAnalysis();
				initClusterAnalysisConfig();
		}
		/**
		* @private
		*/
		private function initClusterVars():void 
			{
				// set constructor logic 
				kinemetricsOn = true;
				//vectormetricsOn = true;	
		}
		/**
		* @private
		*/
		private function initClusterAnalysis():void
			{
				//trace("init cluster analysis", touchSprite_id);
							
					// analyzes and characterizes multi-point motion
					if(kinemetricsOn)cluster_kinemetric = new clusterKinemetric(touchObjectID);

					// analyzes and characterizes multi-point paths to match against established strokes
					//if(vectormetricsOn)cluster_kinemetric = new Vectormetric(touchSpriteID);
		}
		/**
		* @private
		*/
		private function initClusterAnalysisConfig():void
			{
				// analyzes and characterizes multi-point motion
				if (kinemetricsOn)
				{
					// set cluster point numbers
					cluster_kinemetric.init();
				}			
		}
		/**
		* @private
		*/
		// internal public
		public function updateClusterCount():void 
		{
			// FIND CLUSTER COUNT
			cO.n = cO.pointArray.length
			_dN = cO.n - _N;
			_N = cO.n;
			
			// CLUSTER OBJECT UPDATE
			if (_dN < 0) cO.point_remove = true; 
			if (_dN > 0) cO.point_add = true; 
			if ((_dN < 0) && (_N == 0)) cO.remove = true; 
			if ((_dN > 0) && (_N == 1)) cO.add = true; 
			if ((_dN != 0)&&(_clusterEvents)) manageClusterEventDispatch();
			
			// GESTURE OBJECT UPDATE
			if ((_N == 0) && (_dN < 0)) gO.release = true;
		}
		/**
		* @private
		*/
		// internal public
		public function updateClusterAnalysis():void
			{
				//trace("update cluster analysis")
				updateClusterCount();
				if (kinemetricsOn) cluster_kinemetric.findCluster();
				//if(vectormetricsOn)cluster_vectormetric.findPath();
				if ((_clusterEvents)&&(_N)) manageClusterPropertyEventDispatch();
		}
		/**
		* @private
		*/
		// internal public
		private function manageClusterEventDispatch():void 
		{	
				// point added to cluster
				if (cO.point_add)
				{
						dispatchEvent(new GWClusterEvent(GWClusterEvent.C_POINT_ADD, cO.n));
						if((tiO.timelineOn)&&(tiO.clusterEvents)) tiO.frame.clusterEventArray.push(new GWClusterEvent(GWClusterEvent.C_POINT_ADD, cO.n));
						cO.point_add = false;
				}
				// point removed cluster
				if (cO.point_remove) 
				{
						dispatchEvent(new GWClusterEvent(GWClusterEvent.C_POINT_REMOVE, cO.n));
						if((tiO.timelineOn)&&(tiO.clusterEvents)) tiO.frame.clusterEventArray.push(new GWClusterEvent(GWClusterEvent.C_POINT_REMOVE, cO.n));
						cO.point_remove = false;
				}
				// cluster add
				if (cO.remove)
				{
						dispatchEvent(new GWClusterEvent(GWClusterEvent.C_REMOVE, cO.id));
						if((tiO.timelineOn)&&(tiO.clusterEvents))tiO.frame.clusterEventArray.push(new GWClusterEvent(GWClusterEvent.C_REMOVE, cO.id));
						cO.remove = false;
				}
				// cluster remove
				if (cO.add) 
				{
						dispatchEvent(new GWClusterEvent(GWClusterEvent.C_ADD, cO.id));
						if((tiO.timelineOn)&&(tiO.clusterEvents)) tiO.frame.clusterEventArray.push(new GWClusterEvent(GWClusterEvent.C_ADD, cO.id));
						cO.add = false;
				}	
		}
		/**
		* @private
		*/
		// internal public
		private function manageClusterPropertyEventDispatch():void 
		{
				// cluster translate
				if ((cO.dx!=0)||(cO.dy!=0)) 
				{
					dispatchEvent(new GWClusterEvent(GWClusterEvent.C_TRANSLATE, { dx:cO.dx, dy:cO.dy, n:cO.n }));
					if((tiO.timelineOn)&&(tiO.clusterEvents)) tiO.frame.clusterEventArray.push(new GWClusterEvent(GWClusterEvent.C_TRANSLATE, { dx:cO.dx, dy:cO.dy, n:cO.n }));
				}
				// cluster rotate
				if (cO.dtheta!=0)
				{
					dispatchEvent(new GWClusterEvent(GWClusterEvent.C_ROTATE, {dtheta:cO.dtheta, n:cO.n }));
					if((tiO.timelineOn)&&(tiO.clusterEvents)) tiO.frame.clusterEventArray.push(new GWClusterEvent(GWClusterEvent.C_ROTATE, {dtheta:cO.dtheta, n:cO.n}));
				}
				//cluster separate
				if ((cO.dsx!=0)||(cO.dsy!=0)) 
				{
					dispatchEvent(new GWClusterEvent(GWClusterEvent.C_SEPARATE, { dsx:cO.dsx, dsy: cO.dsy, n:cO.n }));
					if((tiO.timelineOn)&&(tiO.clusterEvents)) tiO.frame.clusterEventArray.push(new GWClusterEvent(GWClusterEvent.C_SEPARATE,{ dsx:cO.dsx, dsy:cO.dsy, n:cO.n }));
				}
				// cluster resize
				if ((cO.dw!=0)||(cO.dh!=0)) 
				{
					dispatchEvent(new GWClusterEvent(GWClusterEvent.C_RESIZE, { dw:cO.dw, dh: cO.dh, n:cO.n }));
					if((tiO.timelineOn)&&(tiO.clusterEvents)) tiO.frame.clusterEventArray.push(new GWClusterEvent(GWClusterEvent.C_RESIZE, { dw: cO.dw, dh: cO.dh, n:cO.n }));
				}
				/////////////////////////////////////////////////////////////////////////////
				// cluster accelerate
				if ((cO.ddx!=0)||(cO.ddy!=0))
				{
					dispatchEvent(new GWClusterEvent(GWClusterEvent.C_ACCELERATE, { ddx:cO.ddx, ddy:cO.ddy, n:cO.n }));
					if((tiO.timelineOn)&&(tiO.clusterEvents)) tiO.frame.clusterEventArray.push(new GWClusterEvent(GWClusterEvent.C_ACCELERATE, { ddx:cO.ddx, ddy:cO.ddy, n:cO.n }));
				}
		}	
		/**
		* @private
		*/
		private var _clusterEvents:Boolean = false;
		
		public function get clusterEvents():Boolean{return _clusterEvents;}
		public function set clusterEvents(value:Boolean):void
		{
			_clusterEvents=value;
		}
	}
}