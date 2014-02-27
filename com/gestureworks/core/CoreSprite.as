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
	
	
	
	/**
	 * The TouchSprite class is the base class for all touch and gestures enabled
	 * Sprites that require additional display list management. 
	 * 
	 * <pre>
	 * 		<b>Properties</b>
	 * 		mouseChildren="false"
	 *		touchChildren="false"
	 *		targetParent = "false"
	 *		nativeTransform = "false"
	 *		affineTransform = "false"
	 *		gestureEvents = "true"
	 *		clusterEvents = "false"
	 *		transformEvents = "false"
	 * </pre>
	 */
	
	public class CoreSprite extends Sprite implements ITouchObject
	{
		/**
		 * @private
		 */
		public var gml:XMLList;		
		public static var GESTRELIST_UPDATE:String = "gestureList update";
		
		//tracks event listeners
		private var _eventListeners:Array = [];
		private var gwTouchListeners:Dictionary = new Dictionary();

		public function TouchSprite(_vto:Object=null):void
		{
			super();
			mouseChildren = false; 
			debugDisplay = false;
			vto = _vto;
        }
		
		private var _active:Boolean = false;
		/**
		 * @inheritDoc
		 */
		public function get active():Boolean { return _active; }
		public function set active(a:Boolean):void {
			if (!_active && a) {
				_active = true;
				//TouchManager.preinitBase(this);
				InteractionManager.preinitBase(this);
			}
		}
		
		
		
		private var _nativeTouch:Boolean = false;
		/**
		 * @inheritDoc
		 */		
		public function get nativeTouch():Boolean { return _nativeTouch && GestureWorks.activeNativeTouch; }
		public function set nativeTouch(n:Boolean):void {
			if (_nativeTouch == n) return;
			_nativeTouch = n;
			updateListeners();
		}
		
		private var _serverTouch:Boolean = false;
		/**
		 * @inheritDoc
		 */		
		public function get serverTouch():Boolean { return _serverTouch && GestureWorks.activeServerTouch; }
		public function set serverTouch(n:Boolean):void {
			if (_serverTouch == n) return;
			_serverTouch = n;
			updateListeners();
		}
		
		private var _simulator:Boolean = false;
		/**
		 * @inheritDoc
		 */		
		public function get simulator():Boolean { return _simulator && GestureWorks.activeSim; }
		public function set simulator(s:Boolean):void {
			if (_simulator == s) return;
			_simulator = s;
			updateListeners();	
		}
		
		private var _tuio:Boolean = false;
		/**
		 * @inheritDoc
		 */		
		public function get tuio():Boolean { return _tuio && GestureWorks.activeTUIO; }
		public function set tuio(t:Boolean):void {
			if (_tuio == t) return;
			_tuio = t;
			updateListeners();
		}				
		
		private var _leap2D:Boolean = false;
		/**
		 * @inheritDoc
		 */		
		public function get leap2D():Boolean { return _leap2D && GestureWorks.activeMotion; }
		public function set leap2D(l:Boolean):void {
			if (_leap2D == l) return;
			_leap2D = l;
			updateListeners();
		}			
		
		/**
		 * @inheritDoc
		 */
		public function updateListeners():void {			
			for (var type:String in gwTouchListeners) {
				for each(var l:* in gwTouchListeners[type]) {
					if(l.type)
						removeEventListener(l.type, l.listener);
					else{
						removeEventListener(type, l.listener);
						addEventListener(type, l.listener);
					}
				}
			}
		}
	
		private var _touchObjectID:int = 0; // read only
		/**
		 * @inheritDoc
		 */
		public function get touchObjectID():int { return _touchObjectID; }
		public function set touchObjectID(id:int):void { _touchObjectID = id; }
		
		//private var _pointArray:Vector.<TouchPointObject> = new Vector.<TouchPointObject>(); // read only
		/**
		 * @inheritDoc
		 */
		//public function get pointArray():Vector.<TouchPointObject> { return _pointArray; }
		//public function set pointArray(pa:Vector.<TouchPointObject>):void { _pointArray = pa; }
		
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
		
		private var _cO:ClusterObject; 
		/**
		 * @inheritDoc
		 */
		public function get cO():ClusterObject { return _cO; }
		public function set cO(obj:ClusterObject):void { _cO = obj; }
				
		private var _sO:StrokeObject;
		/**
		 * @inheritDoc
		 */
		public function get sO():StrokeObject { return _sO; }
		public function set sO(obj:StrokeObject):void { _sO = obj; }
		
		private var _gO:GestureListObject;
		/**
		 * @inheritDoc
		 */
		public function get gO():GestureListObject { return _gO; }
		public function set gO(obj:GestureListObject):void { _gO = obj; }
		
		private var _tiO:TimelineObject;
		/**
		 * @inheritDoc
		 */
		public function get tiO():TimelineObject { return _tiO; }
		public function set tiO(obj:TimelineObject):void { _tiO = obj; }	
		
		private var _trO:TransformObject;
		/**
		 * @inheritDoc
		 */
		public function get trO():TransformObject { return _trO; }
		public function set trO(obj:TransformObject):void { _trO = obj; }		
		
		private var _tc:TouchCluster;
		/**
		 * @inheritDoc
		 */
		public function get tc():TouchCluster { return _tc; }
		public function set tc(obj:TouchCluster):void { _tc = obj; }
		
		private var _tp:TouchPipeline;
		/**
		 * @inheritDoc
		 */
		public function get tp():TouchPipeline { return _tp; }
		public function set tp(obj:TouchPipeline):void { _tp = obj; }
		
		private var _tg:TouchGesture;
		/**
		 * @inheritDoc
		 */
		public function get tg():TouchGesture { return _tg; }
		public function set tg(obj:TouchGesture):void { _tg = obj; }
		
		private var _tt:TouchTransform;
		/**
		 * @inheritDoc
		 */
		public function get tt():TouchTransform { return _tt; }
		public function set tt(obj:TouchTransform):void { _tt = obj; }	
				
		private var _visualizer:TouchVisualizer;		
		/**
		 * @inheritDoc
		 */
		public function get visualizer():TouchVisualizer { return _visualizer; }
		public function set visualizer(obj:TouchVisualizer):void { _visualizer = obj; }		
		
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
		
		private var _clusterID:int;
		/**
		 * @inheritDoc
		 */
		public function get clusterID():int{return _clusterID;}
		public function set clusterID(value:int):void {	_clusterID = value; }

		private var _touchEnabled:Boolean = true;
		/**
		 * @inheritDoc
		 */
		public function get touchEnabled():Boolean { return _touchEnabled; }
		public function set touchEnabled(t:Boolean):void {
			if (_touchEnabled == t) return;			
			_touchEnabled = t;
			
			var eCnt:int = _eventListeners.length;
			var e:*;
			for(var i:int = eCnt-1; i >= 0; i--) {
				e = _eventListeners[i];
				if (GWTouchEvent.isType(e.type) || GWGestureEvent.isType(e.type)) {
					if (_touchEnabled) {
						addGWTouch(e.type, e.listener, e.capture);
						super.addEventListener(e.type, e.listener, e.capture);
					}
					else {
						removeGWTouch(e.type);
						super.removeEventListener(e.type, e.listener, e.capture);
					}
				}
			}
		}	
		
		private var _motionEnabled:Boolean = false;
		/**
		 * @inheritDoc
		 */
		public function get motionEnabled():Boolean { return _motionEnabled; }
		public function set motionEnabled(value:Boolean):void {	_motionEnabled = value;}
		
		private var _sensorEnabled:Boolean = false;
		/**
		 * @inheritDoc
		 */
		public function get sensorEnabled():Boolean { return _sensorEnabled; }
		public function set sensorEnabled(value:Boolean):void {	_sensorEnabled = value;}
		

		/**
		 * @inheritDoc
		 */
		public function updateDebugDisplay():void
		{
			if(visualizer) visualizer.updateDebugDisplay()
		}
			
		private var _debugDisplay:Boolean = false;
		/**
		 * @inheritDoc
		 */
		public function get debugDisplay():Boolean { return _debugDisplay;}	
		public function set debugDisplay(value:Boolean):void {
			if (debugDisplay == value) return;
						
			_debugDisplay = value;
			if(visualizer)
				visualizer.initDebug();
		}
		
		
		// TRANSFORM 3D
		private var _transform3d:Boolean = false;
		/**
		 * @inheritDoc
		 */
		public function get transform3d():Boolean {return _transform3d;}	
		public function set transform3d(value:Boolean):void {	_transform3d = value; }
		
		
		
		private var _registerPoints:Boolean = true;
		/**
		 * @inheritDoc
		 */
		public function get registerPoints():Boolean { return _registerPoints} 
		public function set registerPoints(value:Boolean):void{	_registerPoints = value}		
		
	
		
		/**
		 * Overrides dispatch event to deconlfict duplicate device input 
		 * @param	event
		 * @return
		 */
		override public function dispatchEvent(event:Event):Boolean 
		{
			if (event is GWTouchEvent && duplicateDeviceInput(GWTouchEvent(event)))
				return false;
			return super.dispatchEvent(event);
		}		
		
		private static var input1:GWTouchEvent;
		/**
		 * Prioritizes native touch input over mouse input from the touch screen. Processing
		 * both inputs from the same device produces undesired results. Assumes touch events
		 * will precede mouse events.
		 * @param	event
		 * @return
		 */
		private static function duplicateDeviceInput(event:GWTouchEvent):Boolean {
			if (input1 && input1.source != event.source && (event.time - input1.time < 200))
				return true;
			input1 = event;
			return false;
		}		
		
		/**
		 * Calls the dispose method for each child, then removes all children, unregisters all events, and
		 * removes from global lists. This is the root destructor intended to be called by overriding dispose functions. 
		 */		
		public function dispose():void {
			
			//remove all children
			for (var i:int = numChildren - 1; i >= 0; i--)
			{
				var child:Object = getChildAt(i);
				if (child.hasOwnProperty("dispose"))
					child["dispose"]();
				removeChildAt(i);
			}	
			
			//unregister events
			removeAllListeners();
			
			//remove from master list
			delete GestureGlobals.gw_public::touchObjects[_touchObjectID];
			
			gml = null;
			gwTouchListeners = null;
			
			_cO = null;
			_sO = null;
			_tiO = null;
			_trO = null;
			_tc = null;
			_tp = null;
			_tg = null;
			_tt = null;
			_visualizer = null; 
			_gestureList = null;
			_vto = null;
			_view = null;
			transformPoint = null;
		}
		
	}
}