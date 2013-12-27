package com.gestureworks.managers 
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.events.DataEvent;
	
	import flash.net.XMLSocket;
	import flash.display.Sprite;
    import flash.events.*;
	
	import com.gestureworks.core.GestureWorks;
	import com.gestureworks.core.TouchSprite;
	import com.gestureworks.events.GWMotionEvent;
	import com.gestureworks.objects.MotionPointObject;
	import flash.geom.Vector3D;
	import flash.geom.Matrix;
	
	
	import flash.display.DisplayObject;
	import flash.events.TouchEvent;
	import flash.geom.Point;
	
	
	

	/**
	 * The DeviceServerManager class handles the communication via an XML Socket.
	 *
	 * @author Ideum
	 *
	 */
	public class DeviceServerManager extends Sprite
	{
		private var socket:XMLSocket;
		private var currentState:int;
		private var host:String = "127.0.0.1"//"localhost";
		private var port:int = 49191;
		
		private var _isConnected:Boolean = false;
		
		private var XMLFrame:XML;
		private var _frame:Object;
		
		private var activePoints:Array;
		
		public function DeviceServerManager():void
		{
			initXMLSocket();
			activePoints = new Array();
		}
		
		
		
		public function initXMLSocket():void
		{
			
			socket = new XMLSocket();
			socket.connect(host, port);

			socket.addEventListener( Event.CONNECT, onSocketConnectHandler );
			socket.addEventListener( Event.CLOSE, onSocketCloseHandler );
			socket.addEventListener( DataEvent.DATA, onSocketDataHandler);
			socket.addEventListener( ProgressEvent.PROGRESS, progressHandler);
			socket.addEventListener( IOErrorEvent.IO_ERROR, onIOErrorHandler );
			socket.addEventListener( SecurityErrorEvent.SECURITY_ERROR, onSecurityErrorHandler );
			
		}

		private function onSocketConnectHandler(event:Event):void
		{
			_isConnected = true;
			trace("xml socket connected", event)
		}

		private function onIOErrorHandler( event:IOErrorEvent ):void
		{
			_isConnected = false;
			trace("xml scoket IO error", event);
		}

		private function onSecurityErrorHandler( event:SecurityErrorEvent ):void
		{
			_isConnected = false;
			trace("xml socket security error", event);
		}

		private function onSocketCloseHandler( event:Event ):void
		{
			_isConnected = false;
			trace("xml socket closed", event)
		}
		private function progressHandler(event:DataEvent):void
		{
			trace("process handler");
		}

		private function onSocketDataHandler(event:DataEvent):void
		{
			trace("handling xml socket data", event.data);
			//trace("handling xml socket data", event.data);
			//trace("-------------------------");
			
			
			/*
			_isConnected = true;

			var data:XML = new XML (event.data);
			_frame = data.Frame.Messages.Message;
			
			var deviceType:String = data.Frame.Messages.Message.InputPoint.@deviceType;
			var inputType:String = data.Frame.Messages.Message.InputPoint.InputTypes.InputTypes[0].@input
			var frameId = data.Frame.@id;
			var timestamp = data.Frame.@timestamp;
			
			var fingerCount = _frame.InputPoint.Values.Hands.length;
			var fingerCount = _frame.InputPoint.Values.Hands.Hand[0].@fingerCount;
			var objectCount = _frame.InputPoint.Values.Hands.Hand[0].@ObjectCount
			
			trace(frameId,timestamp, data.Frame.@source)
			trace(deviceType,inputType );
			trace(fingerCount, objectCount);
			
			//if ((deviceType=="LeapMotion")&&(inputType=="Hands3d")) processLeap3DPoints();
			*/
			
			/*
			//palm
			trace(data.Frame.Messages.Message.InputPoint.Values.Hands.Hand[0].palm.position.@x);
			trace(data.Frame.Messages.Message.InputPoint.Values.Hands.Hand[0].palm.position.@y);
			trace(data.Frame.Messages.Message.InputPoint.Values.Hands.Hand[0].palm.position.@z);
			
			trace(data.Frame.Messages.Message.InputPoint.Values.Hands.Hand[0].palm.normal.@x);
			trace(data.Frame.Messages.Message.InputPoint.Values.Hands.Hand[0].palm.normal.@y);
			trace(data.Frame.Messages.Message.InputPoint.Values.Hands.Hand[0].palm.normal.@z);
			
			trace(data.Frame.Messages.Message.InputPoint.Values.Hands.Hand[0].palm.direction.@x);
			trace(data.Frame.Messages.Message.InputPoint.Values.Hands.Hand[0].palm.direction.@y);
			trace(data.Frame.Messages.Message.InputPoint.Values.Hands.Hand[0].palm.direction.@z);
			
			
			//finger
			trace(data.Frame.Messages.Message.InputPoint.Values.Hands.Hand[0].finger[0].position.@x);
			trace(data.Frame.Messages.Message.InputPoint.Values.Hands.Hand[0].finger[0].position.@y);
			trace(data.Frame.Messages.Message.InputPoint.Values.Hands.Hand[0].finger[0].position.@z);
			
			trace(data.Frame.Messages.Message.InputPoint.Values.Hands.Hand[0].finger[0].direction.@x);
			trace(data.Frame.Messages.Message.InputPoint.Values.Hands.Hand[0].finger[0].direction.@y);
			trace(data.Frame.Messages.Message.InputPoint.Values.Hands.Hand[0].finger[0].direction.@z);
			
			trace(data.Frame.Messages.Message.InputPoint.Values.Hands.Hand[0].finger[0].@width);
			trace(data.Frame.Messages.Message.InputPoint.Values.Hands.Hand[0].finger[0].@length);
			
			
			//tool
			
			//trace(data.Frame.Messages.Message.InputPoint.Values.Hands.Hand[0].object.@type); pen/
			trace(data.Frame.Messages.Message.InputPoint.Values.Hands.Hand[0].object.position.@x);
			trace(data.Frame.Messages.Message.InputPoint.Values.Hands.Hand[0].object.position.@y);
			trace(data.Frame.Messages.Message.InputPoint.Values.Hands.Hand[0].object.position.@z);
			
			trace(data.Frame.Messages.Message.InputPoint.Values.Hands.Hand[0].object.direction.@x);
			trace(data.Frame.Messages.Message.InputPoint.Values.Hands.Hand[0].object.direction.@y);
			trace(data.Frame.Messages.Message.InputPoint.Values.Hands.Hand[0].object.direction.@z);
			
			trace(data.Frame.Messages.Message.InputPoint.Values.Hands.Hand[0].object.@width);
			trace(data.Frame.Messages.Message.InputPoint.Values.Hands.Hand[0].object.@length);
			trace(data.Frame.Messages.Message.InputPoint.Values.Hands.Hand[0].object.@height);
			*/
		}
		
		
		/**
		 * Process points
		 * @param	event
		 */
		private function processLeap3DPoints():void 
		{
			
			//store frame's point ids
			var pids:Array = new Array();
			
			var f = _frame;
			var hn:int = f.InputPoint.Values.Hands.length;
			var fn:int = f.InputPoint.Values.Hands.Hand[0].@fingerCount;
			var on:int = f.InputPoint.Values.Hands.Hand[0].@ObjectCount
			//trace(hn,fn,on);
			
			
			
			//CREATE HANDS THEN... FINGERS AND TOOLS
			for (var i:int = 0; i < hn; i++)
			{
				// palm point
				pids.push(f.InputPoint.Values.Hands.Hand[i].palm.@id) 
				 
				//finger points
				for (var j:int = 0; j < fn; j++)
				{
					pids.push(f.InputPoint.Values.Hands.Hand[i].finger[j].@id) 
				}
					
				//object points //tools
				for (var k:int = 0; k < on; k++)
				{
					pids.push(f.InputPoint.Values.Hands.Hand[i].object[k].@id) 
				}
			}
			//trace("pids",pids.length,"active points", activePoints.length)
			
			/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
			//POINT REMOVAL//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
			var temp:Array = activePoints;  //prevent concurrent mods
			
			for each(var aid:Number in activePoints) 
			{
				if (pids.indexOf(aid) == -1) {
					
					// remove ref from activePoints list
					temp.splice(temp.indexOf(aid), 1);
					
					
					
						var mp:MotionPointObject = new MotionPointObject();
							mp.motionPointID = aid;
							mp.type = "tool";

						/////////////////////////////////////////
						//create palm point
						if (mp.type == "palm") 
						{	
							//mp.handID = event.frame.hand[i].id;
							//mp.position = new Vector3D( event.frame.hands[i].palmPosition.x, event.frame.hands[i].palmPosition.y, event.frame.hands[i].palmPosition.z * -1);
							//mp.direction = new Vector3D(event.frame.hands[i].direction.x, event.frame.hands[i].direction.y, event.frame.hands[i].direction.z*-1);
							//mp.normal = new Vector3D(event.frame.hands[i].palmNormal.x, event.frame.hands[i].palmNormal.y, event.frame.hands[i].palmNormal.z*-1);
						}
						//////////////////////////////////////////
						//create finger or tool type
						if ((mp.type == "finger") || (mp.type == "tool"))
						{
							//mp.handID = event.frame.pointable(aid).hand.id
							//mp.position = new Vector3D(event.frame.pointable(aid).tipPosition.x, mp.position.y = event.frame.pointable(aid).tipPosition.y, mp.position.z = event.frame.pointable(aid).tipPosition.z*-1);
							//mp.direction = new Vector3D(event.frame.pointable(aid).direction.x, event.frame.pointable(aid).direction.y, event.frame.pointable(aid).direction.z*-1);
							//mp.width = event.frame.pointable(aid).width;
							//mp.length = event.frame.pointable(aid).length;
						}
						
						
					MotionManager.onMotionEnd(new GWMotionEvent(GWMotionEvent.MOTION_END,mp, true,false));
					//if(debug)
						//trace("REMOVED:",mp.id, mp.motionPointID, aid, event.frame.pointable(aid));					
				}
			}
			activePoints = temp;

			///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
			//point addition and update////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
			for each(var pid:Number in pids) 
			{
				
				
					mp = new MotionPointObject();
						mp.motionPointID = pid;
						mp.type = "finger";
					
					// create palm point
					if (mp.type == "palm") 
					{		
						//mp.handID = event.frame.hands[k].id;
						//mp.position = new Vector3D( event.frame.hands[k].palmPosition.x, event.frame.hands[k].palmPosition.y, event.frame.hands[k].palmPosition.z * -1);
						//mp.direction = new Vector3D(event.frame.hands[k].direction.x, event.frame.hands[k].direction.y, event.frame.hands[k].direction.z*-1);
						//mp.normal = new Vector3D(event.frame.hands[k].palmNormal.x, event.frame.hands[k].palmNormal.y, event.frame.hands[k].palmNormal.z*-1);	
					}
					
					// create finger or tool point
					if ((mp.type == "finger") || (mp.type == "tool"))
					{
						//mp.handID = event.frame.pointable(pid).hand.id
						//mp.position = new Vector3D( event.frame.pointable(pid).tipPosition.x, event.frame.pointable(pid).tipPosition.y, event.frame.pointable(pid).tipPosition.z*-1);
						//mp.direction = new Vector3D(event.frame.pointable(pid).direction.x, event.frame.pointable(pid).direction.y, event.frame.pointable(pid).direction.z*-1);
						//mp.width = event.frame.pointable(pid).width;
						//mp.length = event.frame.pointable(pid).length;
						//trace("width",mp.width,mp.length);
					}
					//trace("type manager", mp.type);
					
					

				if (activePoints.indexOf(pid) == -1) 
				{
					activePoints.push(pid);	
					MotionManager.onMotionBegin(new GWMotionEvent(GWMotionEvent.MOTION_BEGIN, mp, true, false));
						
					//if(debug)
						//trace("ADDED:",mp.id, mp.motionPointID, pid, event.frame.pointable(pid));	
				}
				else {
					MotionManager.onMotionMove(new GWMotionEvent(GWMotionEvent.MOTION_MOVE,mp, true, false));
					//if(debug)
						//trace("UPDATE:",mp.id, mp.motionPointID, pid);	
				}
			}	
			
			//trace("leap 3d motion frame processing");
		}

		
		
		public function get isConnected():Boolean
		{
			return _isConnected;
		}
		public function get frame():Object
		{
			return _frame;
		}
		
		public function dispose():void 
		{
			socket.removeEventListener( Event.CONNECT, onSocketConnectHandler );
			socket.removeEventListener( Event.CLOSE, onSocketCloseHandler );
			socket.removeEventListener( DataEvent.DATA, onSocketDataHandler);
			socket.removeEventListener( IOErrorEvent.IO_ERROR, onIOErrorHandler );
			socket.removeEventListener( SecurityErrorEvent.SECURITY_ERROR, onSecurityErrorHandler );
		}

	}
}
