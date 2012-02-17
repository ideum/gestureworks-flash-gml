////////////////////////////////////////////////////////////////////////////////
//
//  IDEUM
//  Copyright 2011-2012 Ideum
//  All Rights Reserved.
//
//  GestureWorks
//
//  File:    TouchSpriteProcessor.as
//  Authors:  Ideum
//             
//  NOTICE: Ideum permits you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////
package com.gestureworks.core
{
	import com.gestureworks.utils.NoiseFilter;
	import com.gestureworks.objects.PropertyObject;
	
	public class TouchSpriteProcessor extends TouchSpriteCluster
	{
		/**
		* @private
		*/
		private var init:Boolean = false;
		/**
		* @private
		*/
		private var i:String;
		/**
		* @private
		*/
		private var j:String;
		
		///////////////////////////////////////////
		// public override
		///////////////////////////////////////////
		public var deltaFilterOn:Boolean = true;
		public var inertialDampingOn:Boolean = false;
		
		public function TouchSpriteProcessor():void
		{
			super();
			//initProcessing();
        }
		// internal public
		public function initProcessing():void
			{
				if(trace_debug_mode)trace("init touchsprite processor")
				
				for (i in gO.pOList)
				{
					for (j in gO.pOList[i])
					{
					if (gO.pOList[i][j] is PropertyObject)
					{
						if (gO.pOList[i][j].filterOn) 
						{
							if (gO.pOList[i][j].filterOn) gO.pOList[i][j].noise_filterMatrix = new NoiseFilter();
							if(trace_debug_mode) trace("created filter object for:",j)
						}
					}
					}
				}
			}
		/**
		* @private
		*/
		public function updateProcessing():void 
		{
			if (!init) 
			{
				if (trace_debug_mode) trace("init processing attempt");
				initProcessing();
				init = true;
			}
			
				applyNoiseSuppression();
				//applyInertialDampening();
		}
		
		////////////////////////////////////////////////////////////
		// Methods: private
		////////////////////////////////////////////////////////////
		/**
		* @private
		*/
		public function applyNoiseSuppression():void 
		{
			if (deltaFilterOn)
			{	
				// property list loop
				for (i in gO.pOList)
				{
					if (gestureList[i]) // check if corospnding gesture is active in gestureList
					{
						for (j in gO.pOList[i])
						{
							if (gO.pOList[i][j] is PropertyObject)
							{
								if (gO.pOList[i][j].filterOn)
								{
									var estDelta:Number = gO.pOList[i][j].noise_filterMatrix.next(gO.pOList[i][j].clusterDelta);
									gO.pOList[i][j].processDelta = gO.pOList[i][j].filter_factor * estDelta + (1 - gO.pOList[i][j].filter_factor) * gO.pOList[i][j].clusterDelta;
									if(trace_debug_mode) trace("	applying filter:",i,j, "	cluster delta:",gO.pOList[i][j].clusterDelta, "	estinmated delta:",estDelta, "	filter factor:",gO.pOList[i][j].filter_factor)
								}
								else gO.pOList[i][j].processDelta = gO.pOList[i][j].clusterDelta;
								if (trace_debug_mode) trace("process data ", i, j, gO.pOList[i][j].clusterDelta,gO.pOList[i][j].processDelta);
							}
						}
					}
				}
			}
			else {
				// property list loop
				for (i in gO.pOList)
				{
						if (gestureList[i])// check if corospnding gesture is active in gestureList
						{
						for (j in gO.pOList[i])
						{
							if (gO.pOList[i][j] is PropertyObject)
							{
								gO.pOList[i][j].processDelta = gO.pOList[i][j].clusterDelta;
								if (trace_debug_mode) trace("process data ", i, j, gO.pOList[i][j].clusterDelta,gO.pOList[i][j].processDelta);
							}
						}
					}
				}
			}
		}
		
		////////////////////////////////////////////////////////////
		// Methods: private
		////////////////////////////////////////////////////////////
		/**
		* @private
		*/
		public function applyInertialDampening():void
		{
			/*
			if (inertialDampingOn) 
			{
				trace("inertial dampening")
				for (i in gO.pOList)
				{
					for (j in gO.pOList[i])
					{
						var InertiaOn:Boolean = gO.pOList[i][j].InertiaOn;
						if (InertiaOn) 
						{
							//trace("filter")
							var estDelta:Number = gO.pOList[i][j].filterMatrix.next(gO.pOList[i][j].processDelta);
							gO.pOList[i][j].processDelta = estDelta;
						}
						else gO.pOList[i][j].processDelta = gO.pOList[i][j].processDelta
					}
				}
					//trace("frame-------------------------")
			}
			else {
				// property list loop
				for (i in gO.pOList)
				{
					for (j in gO.pOList[i])
					{
						gO.pOList[i][j].processDelta = gO.pOList[i][j].processDelta;
					}
				}
			}
			*/
		}
		
	}
}