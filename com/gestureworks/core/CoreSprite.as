////////////////////////////////////////////////////////////////////////////////
//
//  IDEUM
//  Copyright 2011-2012 Ideum
//  All Rights Reserved.
//
//  GestureWorks
//
//  File:    TouchSprite.as
//  Authors:  Ideum
//             
//  NOTICE: Ideum permits you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////
package com.gestureworks.core
{
	
	import com.gestureworks.core.GestureWorks;
	import com.gestureworks.core.TouchCluster;
	import com.gestureworks.core.TouchGesture;
	import com.gestureworks.core.TouchPipeline;
	import com.gestureworks.core.TouchTransform;
	import com.gestureworks.core.TouchVisualizer;
	import com.gestureworks.events.GWGestureEvent;
	import com.gestureworks.events.GWTouchEvent;
	import com.gestureworks.interfaces.ITouchObject;
	//import com.gestureworks.managers.TouchManager;
	import com.gestureworks.managers.InteractionManager;
	import com.gestureworks.objects.ClusterObject;
	import com.gestureworks.objects.GestureListObject;
	import com.gestureworks.objects.TouchPointObject;
	import com.gestureworks.objects.StrokeObject;
	import com.gestureworks.objects.TimelineObject;
	import com.gestureworks.objects.TransformObject;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Matrix;
	import flash.geom.Matrix3D;
	import flash.geom.Point;
	import flash.geom.Transform;
	import flash.utils.Dictionary;
	
	
	
	//import com.gestureworks.objects.PointPairObject;

	
	public class CoreSprite extends Sprite 
	{
		public function CoreSprite():void
		{
			super();
			debugDisplay = false;
        }
		
		private var _N:int = 0; 
		/**
		 * @inheritDoc
		 */
		public function get N():int { return _N; }
		public function set N(n:int):void { _N = n; }
		
		private var _index:int = 0; 
		/**
		 * @inheritDoc
		 */
		public function get index():int { return _index; }
		public function set index(n:int):void { _index = n; }
		
		private var _hn:int = 0; 
		/**
		 * @inheritDoc
		 */
		public function get hn():int { return _hn; }
		public function set hn(n:int):void { _hn = n; }
		
		private var _fn:int = 0; 
		/**
		 * @inheritDoc
		 */
		public function get fn():int { return _fn; }
		public function set fn(n:int):void { _fn = n; }
		
		
		private var _tpn:int = 0; 
		/**
		 * @inheritDoc
		 */
		public function get tpn():int { return _tpn; }
		public function set tpn(n:int):void { _tpn = n; }
		
		private var _ipn:int = 0; 
		/**
		 * @inheritDoc
		 */
		public function get ipn():int { return _ipn; }
		public function set ipn(n:int):void { _ipn = n; }
		
		private var _mpn:int = 0; 
		/**
		 * @inheritDoc
		 */
		public function get mpn():int { return _mpn; }
		public function set mpn(n:int):void { _mpn = n; }
		
		private var _spn:int = 0; 
		/**
		 * @inheritDoc
		 */
		public function get spn():int { return _spn; }
		public function set spn(n:int):void { _spn = n; }
				
		private var _dN:Number = 0; 
		/**
		 * @inheritDoc
		 */
		public function get dN():Number { return _dN; }
		public function set dN(n:Number):void { _dN = n; }	
		
		private var _cc:CoreCluster;
		/**
		 * @inheritDoc
		 */
		public function get cc():CoreCluster { return _cc; }
		public function set cc(obj:CoreCluster):void { _cc = obj; }
		
				
		private var _cv:CoreVisualizer;		
		/**
		 * @inheritDoc
		 */
		public function get cv():CoreVisualizer { return _cv; }
		public function set cv(obj:CoreVisualizer):void { _cv = obj; }		
		
		private var _traceDebugMode:Boolean = false;
		/**
		 * @inheritDoc
		 */
		public function get traceDebugMode():Boolean{return _traceDebugMode;}
		public function set traceDebugMode(value:Boolean):void{	_traceDebugMode=value;}
		
		private var _touchPointCount:int;
		/**
		 * @inheritDoc
		 */
		public function get touchPointCount():int{return _touchPointCount;}
		public function set touchPointCount(value:int):void {	_touchPointCount = value; }
		
		private var _motionPointCount:int;
		/**
		 * @inheritDoc
		 */
		public function get motionPointCount():int{return _motionPointCount;}
		public function set motionPointCount(value:int):void {	_motionPointCount = value; }
		
		private var _sensorPointCount:int;
		/**
		 * @inheritDoc
		 */
		public function get sensorPointCount():int{return _sensorPointCount;}
		public function set sensorPointCount(value:int):void {	_sensorPointCount = value; }
		
		private var _interactionPointCount:int;
		/**
		 * @inheritDoc
		 */
		public function get interactionPointCount():int{return _interactionPointCount;}
		public function set interactionPointCount(value:int):void{	_interactionPointCount=value;}

		private var _debugDisplay:Boolean = false;
		/**
		 * @inheritDoc
		 */
		public function get debugDisplay():Boolean { return _debugDisplay;}	
		public function set debugDisplay(value:Boolean):void { _debugDisplay = value;}
		
	}
}