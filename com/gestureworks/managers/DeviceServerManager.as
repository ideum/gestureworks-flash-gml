package com.gestureworks.managers 
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.events.DataEvent;
	
	import flash.net.Socket;
	import flash.display.Sprite;
    import flash.events.*;
	
	import flash.geom.Vector3D;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.display.DisplayObject;
	import flash.events.TouchEvent;
	
	import com.gestureworks.core.GestureGlobals;
	import com.gestureworks.core.GestureWorks;
	import com.gestureworks.core.TouchSprite;
	import com.gestureworks.events.GWMotionEvent;
	import com.gestureworks.objects.MotionPointObject;
	import com.gestureworks.core.gw_public;
	import com.gestureworks.managers.Leap3DSManager;

	/**
	 * The DeviceServerManager class handles the communication via an XML Socket.
	 *
	 * @author Ideum
	 *
	 */
	public class DeviceServerManager extends Sprite
	{
		private static var socket:Socket;
		private static var currentState:int;
		private static var _isConnected:Boolean = false;
		
		public static var _host:String = "127.0.0.1"//"localhost";
		public static var _port:int = 49191;
		
		
		private static var XMLFrameList:XMLList;
		
		//private static var leapsocket2DMgr:Leap2DSManager
		private static var leapsocket3DMgr:Leap3DSManager
		
		
		public function DeviceServerManager():void
		{
			trace("device server manager constructor");
			
		}
		
		gw_public static function initialize():void
		{
			trace("device server manager init");
			
			//////////////////////////////////////////////////
			leapsocket3DMgr = new Leap3DSManager();
			initXMLSocket();
		}
		
		public function init():void
		{
			trace("device server manager init");
			
			//////////////////////////////////////////////////
			leapsocket3DMgr = new Leap3DSManager();
			
			//leapsocket2DMgr = new Leap2DSManager();
			
			
			initXMLSocket();
		}
		
		
		public static function initXMLSocket():void
		{
			socket = new Socket(host, port);
			socket.addEventListener(Event.CLOSE, handleSocketClosed);
			socket.addEventListener(Event.OPEN, handleSocketOpen);
			socket.addEventListener(Event.CONNECT, handleSocketConnected);
			socket.addEventListener(ProgressEvent.SOCKET_DATA, onSocketDataHandler); 
			socket.addEventListener(IOErrorEvent.IO_ERROR, handleIOError);
			socket.addEventListener(SecurityErrorEvent.SECURITY_ERROR, handleSecurityError);
		}

		// press key to send test message
		private static function handleSocketOpen(event:Event):void {
			trace("socket open",event);
		}
		
		private static function handleSocketConnected(event:Event):void {
			trace("socket connected",event);
		}
		
		// socket io error handler
		private static function handleIOError(event:IOErrorEvent):void {
			trace("IO error",event);
		}
		
		// socket security error handler
		
		private static function handleSecurityError(event:SecurityErrorEvent):void {
			trace("security error",event);
		}
		
		// socket closed handler
		private static function handleSocketClosed(event:Event):void {
			trace("closed",event);			
		}

		private static function onSocketDataHandler(event:ProgressEvent):void
		{
			//trace("message", event, event.bytesLoaded, event.bytesTotal);
			var str:String = socket.readUTFBytes(socket.bytesAvailable);
			var lg:int = str.length;
			var start:String = str.substr(0,6)
			var end:String = str.substr(lg - 8, 8)
			//trace(str)
			//trace(lg,start,end);
			
			// SIMPLE FRAME COMPLETENES CHECK
			if ((start =="<Frame") && (end =="</Frame>"))
			{
				XMLFrameList = new XMLList(str);
				//trace("----------------------------")
			
				if (XMLFrameList) 
				{
					var dfrn:int = int(XMLFrameList.length());
					var deviceType:String
					var inputType:String
					var frameId:int 
					var timestamp:int 
					var frame:XML
				
					for (var i:int = 0; i < dfrn; i++ )
					{
						frame = XMLFrameList[i]
						deviceType = frame.Messages.Message.InputPoint.@deviceType;
						inputType = frame.Messages.Message.InputPoint.InputTypes.InputType[0].@input;
						//trace("data types",deviceType,inputType)

						if ((deviceType == "LeapMotion") && (inputType == "Hands3d")) leapsocket3DMgr.processLeap3DSocketData(frame);
						//if ((deviceType =="LeapMotion")&&(inputType=="Hands2d")) leapsocket2DMgr.processLeap2DSocketData(frame);
					}
				}
			}
			else trace("xml frame parsing error");
		}	
		
		public static function get host():String{return _host;}
		public static function set host(value:String):void {	_host = value; }
		
		public static function get port():int { return _port; }
		public static function set port(value:int):void {	_port = value; }
		
		
		public function get isConnected():Boolean
		{
			return _isConnected;
		}
		
		
		public function dispose():void 
		{
			//socket.removeEventListener( Event.CONNECT, onSocketConnectHandler );
			//socket.removeEventListener( Event.CLOSE, onSocketCloseHandler );
			//socket.removeEventListener( DataEvent.DATA, onSocketDataHandler);
			//socket.removeEventListener( IOErrorEvent.IO_ERROR, onIOErrorHandler );
			//socket.removeEventListener( SecurityErrorEvent.SECURITY_ERROR, onSecurityErrorHandler );
		}

	}
}
