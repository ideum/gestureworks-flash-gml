////////////////////////////////////////////////////////////////////////////////
//
//  IDEUM
//  Copyright 2011-2012 Ideum
//  All Rights Reserved.
//
//  GestureWorks
//
//  File:    TouchSpriteGestureFlex.as
//  Authors:  Ideum
//             
//  NOTICE: Ideum permits you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////
package com.gestureworks.core
{
	import flash.events.TouchEvent;
	
	import com.gestureworks.events.GWEvent;
	import com.gestureworks.events.GWGestureEvent;
	import com.gestureworks.analysis.gestureContinuous;
	import com.gestureworks.analysis.gestureDiscrete;
	
	import com.gestureworks.managers.TimelineHistories;
	import com.gestureworks.objects.FrameObject; 
	
	public class TouchSpriteGestureFlex extends TouchSpriteProcessorFlex
	{
		/**
		* @private
		*/
		//internal public
		public var gesture_cont:gestureContinuous;
		/**
		* @private
		*/
		public var gesture_disc:gestureDiscrete;
		/**
		* @private
		*/
		private var contGesturemetricsOn:Boolean = true;
		/**
		* @private
		*/
		private var discGesturemetricsOn:Boolean = true;
		/**
		* @private
		*/
		private var key:String;
		/////////////////////////////////////////////////////////
		
		public function TouchSpriteGestureFlex():void
		{
			super();
			initGesture();
         }
		 
		// initializers   
         public function initGesture():void 
         {
			if(trace_debug_mode) trace("create touchsprite gesture");
			
			initGestureVars();
			initGestureAnalysis();
		}
		
		/**
		* @private
		*/
		public function initGestureVars():void 
		{
			// set constructor logic with GML
			contGesturemetricsOn = true;
			discGesturemetricsOn = true;
		}
		/**
		* @private
		*/
		public function initGestureAnalysis():void //clusterObject:Object
		{
			if (trace_debug_mode) trace("init gesture analysis", touchObjectID);

			// analyze for continuous gesturing
			if(contGesturemetricsOn){
				gesture_cont = new gestureContinuous(touchObjectID);
				//gesture_cont.init();
             }
			// analyze for descrete gesture sequence/series
			if(discGesturemetricsOn){
				gesture_disc = new gestureDiscrete(touchObjectID);
				//initTimeline();
			}
			// analyze for gesture conflict/compliment
					
		}
		/**
		* @private
		*/
		public function initTimeline():void
		{
			//trace("framerate",GestureWorks.application.frameRate)
			
			if (!tiO.timelineInit){
				
				if ((gestureList["hold"]) || (gestureList["tap"]) || (gestureList["double_tap"]) || (gestureList["triple_tap"])) 
				{
					tiO.timelineOn = true;
					tiO.pointEvents = true;
				}
				else {
					tiO.timelineOn = false;
					tiO.pointEvents = false;
				}
				
				if (tiO.timelineOn)
				{
					var frames:int = 0;
					if ((gO.pOList["tap"]) && (gestureList["tap"])) frames = 0;
					if ((gO.pOList["hold"]) && (gestureList["hold"])) frames = 40;
					if ((gO.pOList["double_tap"]) && (gestureList["double_tap"])) frames = 60;
					if ((gO.pOList["triple_tap"])&&(gestureList["triple_tap"])) frames = 80;
					
					GestureGlobals.timelineHistoryCaptureLength = frames;
					
					if (trace_debug_mode) trace("init timeline set length:", frames);
				}
			
				// init listners
				// NOTE: ONENTERFRAME ONLY SEEMS TO FIRE WHEN MOVE DETECTED IN DEBUG MODE
				if (tiO.timelineOn) GestureWorks.application.addEventListener(GWEvent.ENTER_FRAME, onGestureEnterFrame);
				if ((GestureWorks.supportsTouch)&&(tiO.timelineOn)) addEventListener(TouchEvent.TOUCH_BEGIN, onTouchHoldDown);
				if ((GestureWorks.supportsTouch) && (tiO.timelineOn)) addEventListener(TouchEvent.TOUCH_TAP, onTouchTap);
				
				tiO.timelineInit = true;
			}
		}
		/**
		* @private
		*/
		//////////////////////////////////////////////////////
		// currently not used
		// intended for non tap gestures that require timline 
		// analysis like gesture sequencing
		//////////////////////////////////////////////////////
		private function updateTimelineGestureAnalysis():void
		{
			//trace("update timeline gesture analysis");
			if ((discGesturemetricsOn) && (tiO.timelineOn)) 
			{
					gesture_disc.findTimelineGestures();
			}
		}
		/**
		* @private
		*/
		public function updateGestureAnalysis():void
		{
			
			if ((N) || (!gO.gestureTweenOn)) 
			{
				if (trace_debug_mode) trace("update gesture analysis");
				if (contGesturemetricsOn)
				{
					gesture_cont.findGestures();
					if (_gestureEvents)manageGestureEventDispatch();
				}
			}
			
			if (!tiO.timelineInit) initTimeline();
			//updateTimelineGestureAnalysis();
		}
		/**
		* @private
		*/
		public function updateGestureValues():void
		{
			if (gestureReleaseInertia)
			{
				if(trace_debug_mode) trace("update gesture values");
				if ((gO.gestureTweenOn)&&(gO.gestureRelease))
				{
					if (contGesturemetricsOn)
					{
						gesture_cont.applyGestureValueTween(); 			// decay gesture deltas
						//gesture_cont.limitGestureProperties();			// ensure limits are not exceeded
						
						//////////////////////////////////
						// test
						gesture_cont.mapTransformLimits();
						gesture_cont.limitGestureValues();
						/////////////////////////////////
						
						gesture_cont.mapTransformProperties();
						//gesture_cont.limitTransformProperties();
						if (_gestureEvents) manageGestureEventDispatch();		// dispatch gesture events
					}
				}
			}
		}
		/**
		* @private
		*/
		public function restartGestureTween():void
		{
			if (contGesturemetricsOn) gesture_cont.restartGestureTween();
		}
		/**
		* @private
		*/
		public function resetGestureTween():void
		{
			if (contGesturemetricsOn) gesture_cont.resetGestureTween();
		}
		/**
		* @private
		*/
		private function manageGestureEventDispatch():void 
		{
				gestureObjectEventDispatch();
				gestureContinuousEventDispatch();
		}
		
		
		////////////////////////////////////////////////////////////////////////////////////
		///////////////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////////
		
		/**
		* @private
		*/
		public function onTouchHoldDown(event:TouchEvent):void
		{
			if (trace_debug_mode) trace("Touch DOWN gesture analysis", event.touchPointID, event.stageX, event.stageY);
			if ((gO.pOList["hold"])&&(gestureList["hold"]))					gesture_disc.findTimelineHoldEvent(event);
		}
		/**
		* @private
		*/	
		public function onTouchTap(event:TouchEvent):void
		{
			if((tiO.timelineOn)&&(tiO.pointEvents))tiO.frame.pointEventArray.push(event);
			if (trace_debug_mode)trace("Touch TAP gesture analysis", event.touchPointID, event.stageX, event.stageY);	

			if ((gO.pOList["tap"])&&(gestureList["tap"]))					gesture_disc.findTimelineTapEvent(event);
			if ((gO.pOList["double_tap"])&&(gestureList["double_tap"])) 	gesture_disc.findTimelineDoubleTapEvent(event);
			if ((gO.pOList["triple_tap"])&&(gestureList["triple_tap"]))		gesture_disc.findTimelineTripleTapEvent(event);
			
		}
		/**
		* @private
		*/
		public function onGestureEnterFrame(event:GWEvent):void
		{
			// MANAGE TIMELINE
			if (tiO.timelineOn) 
			{
				if (trace_debug_mode) trace("timeline frame update");
				// push histories 
				TimelineHistories.historyQueue(clusterID);
				// create new timline frame //trace("manage timeline");
				tiO.frame = new FrameObject();
				
				// UPDATE HOLD
				if ((gO.pOList["hold"]) && (gestureList["hold"])) 			gesture_disc.holdMonitor();
			}
		}
		
		//////////////////////////////////////////////////////////////////////////////////////
		/////////////////////////////////////////////////////////////////////////////////////
		///////////////////////////////////////////////////////////////////////////////////////
		/**
		* @private
		*/
		private function gestureObjectEventDispatch():void 
		{
			if (trace_debug_mode) trace("gestureObject event dispatch");
			
			/////////////////////////////////////////////////////////////////////////////////////////////////
			// Core GestureEvent Dispatch Manager
			/////////////////////////////////////////////////////////////////////////////////////////////////
		
				// start gesture
				if ((gO.start)&&(_gestureEventStart))
				{
						dispatchEvent(new GWGestureEvent(GWGestureEvent.START, gO.id));
						if((tiO.timelineOn)&&(tiO.gestureEvents))	tiO.frame.gestureEventArray.push(new GWGestureEvent(GWGestureEvent.START, gO.id));
						gO.start = false;
						//trace("start fired");
				}
				// release gesture
				if ((gO.release)&&(_gestureEventRelease))
				{
						dispatchEvent(new GWGestureEvent(GWGestureEvent.RELEASE, gO.id));
						if((tiO.timelineOn)&&(tiO.gestureEvents))	tiO.frame.gestureEventArray.push(new GWGestureEvent(GWGestureEvent.RELEASE, gO.id));
						gO.release = false;
						//trace("release fired");
				}
				// gesture complete event
				if ((gO.complete)&&(_gestureEventComplete))
				{
						dispatchEvent(new GWGestureEvent(GWGestureEvent.COMPLETE, gO.id));
						if((tiO.timelineOn)&&(tiO.gestureEvents))	tiO.frame.gestureEventArray.push(new GWGestureEvent(GWGestureEvent.COMPLETE, gO.id));
						gO.complete = false;
						//trace("complete fired");
				}		
		}
		/**
		* @private
		*/
		public function gestureContinuousEventDispatch():void 
		{	
			if (trace_debug_mode) trace("continuous gesture event dispatch");
			
			for (key in gO.pOList) 
			{	
				// drag gesture
				if (gO.pOList[key].gesture_type == "drag")
				{
					if ((gO.pOList[key])&&(gestureList[key]))
					{
						var drag_dx:Number = gO.pOList[key]["drag_dx"].gestureDelta;
						var drag_dy:Number = gO.pOList[key]["drag_dy"].gestureDelta;
						
						//var b:String = "GWGestureEvent.DRAG"
						
						if (trace_debug_mode)trace("drag", drag_dx, drag_dy);

						if ((drag_dx)||(drag_dy)) 
						{
							if (trace_debug_mode) trace("drag", drag_dx, drag_dy);
							
							dispatchEvent(new GWGestureEvent(GWGestureEvent.DRAG, {dx: drag_dx, dy: drag_dy, n:N}));
							if((tiO.timelineOn)&&(tiO.gestureEvents))	tiO.frame.gestureEventArray.push(new GWGestureEvent(GWGestureEvent.DRAG, {dx:drag_dx, dy:drag_dy, n:N}));
						}
					}
				}

				// rotation gesture
				if (gO.pOList[key].gesture_type == "rotate")
				{
					if ((gO.pOList[key])&&(gestureList[key]))
					{
						var rotate_dtheta:Number = gO.pOList[key]["rotate_dtheta"].gestureDelta;
						
						if (trace_debug_mode) trace("rotate_dtheta",rotate_dtheta);
						
						if (rotate_dtheta)
						{
							dispatchEvent(new GWGestureEvent(GWGestureEvent.ROTATE, {dtheta: rotate_dtheta, n:N}));
							if((tiO.timelineOn)&&(tiO.gestureEvents))	tiO.frame.gestureEventArray.push(new GWGestureEvent(GWGestureEvent.ROTATE, {dtheta:rotate_dtheta, n:N}));
						}
					}
				}
				// scale gesture
				if (gO.pOList[key].gesture_type == "scale")
				{
					if ((gO.pOList[key])&&(gestureList[key]))
					{
						var scale_dsx:Number = gO.pOList[key]["scale_dsx"].gestureDelta;
						var scale_dsy:Number = gO.pOList[key]["scale_dsy"].gestureDelta;
						
						if ((scale_dsx)||(scale_dsy)) 
						{
							dispatchEvent(new GWGestureEvent(GWGestureEvent.SCALE, {dsx: scale_dsx, dsy: scale_dsy, n:N}));
							if((tiO.timelineOn)&&(tiO.gestureEvents))	tiO.frame.gestureEventArray.push(new GWGestureEvent(GWGestureEvent.SCALE, {dsx:scale_dsx, dsy:scale_dsy, n:N}));
						}
					}
				}
				
				
				// pivot gesture
				if (gO.pOList[key].gesture_type == "pivot")
				{
					if ((gO.pOList[key])&&(gestureList[key]))
					{
						var pivot_dtheta:Number = gO.pOList[key]["pivot_dtheta"].gestureDelta;
						
						if (pivot_dtheta)
						{
							dispatchEvent(new GWGestureEvent(GWGestureEvent.PIVOT, {dtheta: pivot_dtheta, n:N}));
							if((tiO.timelineOn)&&(tiO.gestureEvents))	tiO.frame.gestureEventArray.push(new GWGestureEvent(GWGestureEvent.PIVOT, {pivot_dtheta:pivot_dtheta, n:N}));
						}
					}
				}
				
				//orient gesture
				if (gO.pOList[key].gesture_type == "orient")
				{
					if ((gO.pOList[key])&&(gestureList[key]))
					{
						//trace("orient")
						var orient_dx:Number = gO.pOList[key]["orient_dx"].gestureDelta;
						var orient_dy:Number = gO.pOList[key]["orient_dy"].gestureDelta;
						
						if ((orient_dx) || (orient_dy)) 
						{
							dispatchEvent(new GWGestureEvent(GWGestureEvent.SCROLL, {dx: orient_dx, dy: orient_dy, n:N}));
							if((tiO.timelineOn)&&(tiO.gestureEvents))	tiO.frame.gestureEventArray.push(new GWGestureEvent(GWGestureEvent.SCROLL, {dx:orient_dx, dy:orient_dy, n:N}));
						}
					}
				}
				
				//scroll gesture
				if (gO.pOList[key].gesture_type == "scroll")
				{
					if ((gO.pOList[key])&&(gestureList[key]))
					{
						//trace("scroll")	
						var scroll_dx:Number = gO.pOList[key]["scroll_dx"].gestureDelta;
						var scroll_dy:Number = gO.pOList[key]["scroll_dy"].gestureDelta;
						
						if ((scroll_dx) || (scroll_dy)) 
						{
							dispatchEvent(new GWGestureEvent(GWGestureEvent.SCROLL, {dx: scroll_dx, dy: scroll_dy, n:N}));
							if((tiO.timelineOn)&&(tiO.gestureEvents))	tiO.frame.gestureEventArray.push(new GWGestureEvent(GWGestureEvent.SCROLL, {dx:scroll_dx, dy:scroll_dy, n:N}));
						}
					}
				}
				
				// flick gesture
				if (gO.pOList[key].gesture_type == "flick")
				{
					if ((gO.pOList[key])&&(gestureList[key]))
					{
						var flick_dx:Number = gO.pOList[key]["flick_dx"].gestureDelta;
						var flick_dy:Number = gO.pOList[key]["flick_dy"].gestureDelta;
						
						// flickx
						if ((flick_dx) || (flick_dy))
						{
							dispatchEvent(new GWGestureEvent(GWGestureEvent.FLICK, {dx: flick_dx, dy: flick_dy, n:N}));
							if((tiO.timelineOn)&&(tiO.gestureEvents))	tiO.frame.gestureEventArray.push(new GWGestureEvent(GWGestureEvent.FLICK, {dx:flick_dx, dy:flick_dy, n:N}));
						}
					}
				}

				// swipe gesture
				if (gO.pOList[key].gesture_type == "swipe")
				{
					if ((gO.pOList[key])&&(gestureList[key]))
					{
						var swipe_dx:Number = gO.pOList[key]["swipe_dx"].gestureDelta;
						var swipe_dy:Number = gO.pOList[key]["swipe_dy"].gestureDelta;
						
						if ((swipe_dx) || (swipe_dy))
						{
							dispatchEvent(new GWGestureEvent(GWGestureEvent.SWIPE, {dx:swipe_dx, dy:swipe_dy, n:N}));
							if((tiO.timelineOn)&&(tiO.gestureEvents))tiO.frame.gestureEventArray.push(new GWGestureEvent(GWGestureEvent.SWIPE, {dx:swipe_dx, dy:swipe_dy, n:N}));
						}
					}
				}
				
				// 3d tilt gesture
				if (gO.pOList[key].gesture_type == "tilt")
				{
					if ((gO.pOList[key])&&(gestureList[key]))
					{
						var tilt_dx:Number = gO.pOList[key]["tilt_dx"].gestureDelta;
						var tilt_dy:Number = gO.pOList[key]["tilt_dy"].gestureDelta;
						
						if ((tilt_dx)||(tilt_dy))
						{
							dispatchEvent(new GWGestureEvent(GWGestureEvent.TILT,{dx: tilt_dx, dy: tilt_dy, n:N}));
							if((tiO.timelineOn)&&(tiO.gestureEvents))	tiO.frame.gestureEventArray.push(new GWGestureEvent(GWGestureEvent.SWIPE, {dx:tilt_dx, dy:tilt_dy, n:N}));
						}
					}
				}
				

			}

				/////// split
				
				/////// anchor
		}	
		
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		//public  read / write
		////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		/**
		* @private
		*/
		//public read write
		private var _gestureEventStart:Boolean = true;
		/**
		* Indicates whether gestureEvents have been started on the touchSprite.
		*/
		public function get gestureEventStart():Boolean{return _gestureEventStart;}
		public function set gestureEventStart(value:Boolean):void
		{
			_gestureEventStart=value;
		}
		
		
		/**
		* @private
		*/
		private var _gestureEventComplete:Boolean = true;
		/**
		* Indicates whether gestureEvents have been completed on the touchSprite.
		*/
		public function get gestureEventComplete():Boolean{return _gestureEventComplete;}
		public function set gestureEventComplete(value:Boolean):void
		{
			_gestureEventComplete=value;
		}
		
		/**
		* @private
		*/
		private var _gestureEventRelease:Boolean = true;
		/**
		* Indicates whether gestureEvents have been released on the touchSprite.
		*/
		public function get gestureEventRelease():Boolean{return _gestureEventRelease;}
		public function set gestureEventRelease(value:Boolean):void
		{
			_gestureEventRelease=value;
		}
		
		/**
		* @private
		*/
		private var _gestureEvents:Boolean = false;
		/**
		* Determins whether gestureEvents are processed on the touchSprite.
		*/
		public function get gestureEvents():Boolean{return _gestureEvents;}
		public function set gestureEvents(value:Boolean):void
		{
			_gestureEvents=value;
		}
		
		/**
		* @private
		*/
		private var _gestureTouchInertia:Boolean = false;
		/**
		* Determins whether touch inertia is processed on the touchSprite.
		*/
		public function get gestureTouchInertia():Boolean{return _gestureTouchInertia;}
		public function set gestureTouchInertia(value:Boolean):void
		{
			_gestureTouchInertia=value;
		}
		
		/**
		* @private
		*/
		public var _gestureReleaseInertia:Boolean = true;	// gesture release inertia switch
		/**
		* Determins whether release inertia is given to gestureEvents on the touchSprite.
		*/
		public function get gestureReleaseInertia():Boolean{return _gestureReleaseInertia;}
		public function set gestureReleaseInertia(value:Boolean):void
		{
			_gestureReleaseInertia=value;
		}
	}
}