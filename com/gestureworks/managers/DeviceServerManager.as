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
	
	import com.gestureworks.managers.Motion3DSManager;
	import com.gestureworks.managers.Touch2DSManager;

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
		
		
		private static var motionManagerSocket:Motion3DSManager;
		private static var touchManagerSocket:Touch2DSManager;
		//private static var sensorManagerSocket:SensorSManager;
		
		
		public function DeviceServerManager():void
		{
			trace("device server manager constructor");
			
		}
		
		gw_public static function initialize():void
		{
			trace("device server manager init");
			
			//////////////////////////////////////////////////
			motionManagerSocket = new Motion3DSManager();
			//leapsocket2DMgr = new Leap2DSManager();
			
			touchManagerSocket = new Touch2DSManager();
			
			
			//sensorManagerSocket = new SensorSManager();
			
			
			
			initXMLSocket();
		}
		
		public function init():void
		{
			trace("device server manager init");
			
			//////////////////////////////////////////////////
			motionManagerSocket = new Motion3DSManager();
			
			touchManagerSocket = new Touch2DSManager(); 
			
			//sensorManagerSocket = new SensorSManager(); 
			
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
			var start:String = str.substr(0,6)//str.substr(0,6)
			var end:String = str.substr(lg - 8, 8)//str.substr(lg - 10, 8)
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
					var deviceType:String;
					var inputType:String;
					var inputMode:String;
					var frameId:int; 
					var timestamp:int; 
					var frame:XML;
					var message:XML;
					var mn:int;
				
					for (var i:int = 0; i < dfrn; i++ )
					{
						frame = XMLFrameList[i]
						mn = frame.Messages.length();
						
						//trace("message length",mn);
						
						for (var j:int = 0; j< mn; j++ )
						{
							message = frame.Messages.Message[j]
							deviceType = message.InputPoint.@deviceType;
							inputMode = message.InputPoint.@deviceMode;
							inputType = message.InputPoint.InputTypes.InputType[0].@input;// simplify as likely use different output in seperate message
							//trace("data types",deviceType,inputType)
							
							//if (inputMode=="motion"){
							//////////////////////////////////////////////////////////////
							//MOTION//////////////////////////////////////////////////////
							//////////////////////////////////////////////////////////////
							
								//HAND/FINGER TRACKING////////////////////////////////////////
								if (deviceType == "LeapMotion")
								{
									if (inputType == "Hands3d") 
									{
										//trace(deviceType,": ", inputType);
										motionManagerSocket.processMotion3DSocketData(message);
									}
									if (inputType == "Hands2d") 
									{
										//trace(deviceType,": ", inputType);
										//leapsocket2DMgr.processLeap2DSocketData(frame);
									}
								}
								//if ((deviceType == "Creative_Senz3d") && (inputType == "Hands3d")) leapsocket3DMgr.processLeap3DSocketData(frame);
								//if ((deviceType == "PMD_Nano") && (inputType == "Hands3d")) leapsocket3DMgr.processLeap3DSocketData(frame);
								//if ((deviceType == "occipital_Structure") && (inputType == "Hands3d")) leapsocket3DMgr.processLeap3DSocketData(frame);
								
								// EYE TRACKING////////////////////////////////////////////////////////////////////
									// mouse position // left or right or both
										// left click (left wink)
										// right click (right wink)
										// hold (stare/gaze lock)
										// (flare)
										// pupil size (presure dist??)
								if ((deviceType == "EYETRIBE") && (inputType == "Eyes2d"))trace(deviceType,": ", inputType);
								if ((deviceType == "TOBII") && (inputType == "Eyes2d"))trace(deviceType,": ", inputType);
							
								//BODY TRACKING
									//KINECT
									//XITION
									//SOFKINECTIC
									
								//FACE TRACKING
									//SOKINECTIC
							
							
							//if (inputMode=="touch"){
							///////////////////////////////////////////////////////////////
							// TOUCH //////////////////////////////////////////////////////
								if ((deviceType == "PQ") && (inputType == "Points2D"))
								{
									trace(deviceType,": ", inputType);
									//touchManagerSocket.processTouch2DSocketData(message);
								}
								//3M
								//ZYTRONIC
								
								if ((deviceType == "LeapMotion")&&(inputType == "Points2D"))
								{
									trace(deviceType,": ", inputType);
									//leapsocket2DMgr.processLeap2DSocketData(frame);
								}
								if ((deviceType == "Android")&&(inputType == "Points2D")) // touch input from Android remote device
								{
									trace(deviceType,": ", inputType);
									//leapsocket2DMgr.processLeap2DSocketData(frame);
								}
							
							//if (inputMode=="sensor"){
							///////////////////////////////////////////////////////////////
							// SENSOR //////////////////////////////////////////////////////
							
								
								if ((deviceType == "Arduino") && (inputType == ""))
								{
									trace(deviceType,": ", inputType);
									//tt.processSensorArduinoSocketData(message);
								}
								
								//ACCELEROMETER
								if ((deviceType == "Android")&&(inputType == "Accel3D")) // accel input from Android remote device
								{
									trace(deviceType,": ", inputType);
									//leapsocket2DMgr.processLeap2DSocketData(frame);
								}
								if ((deviceType == "MUSE") && (inputType == "Accel3D")) trace(deviceType, ": ", inputType);
								
								//GPS
								//MAGNOMETER
								//GYROMETER
								//IR SENSOR
							
								// CONTROLLERS
								if ((deviceType == "Wiimote") && (inputType == "Controller"))
								{
									trace(deviceType,": ", inputType);
									//tt.processSensorControllerSocketData(message);
								}
								if ((deviceType == "SNES") && (inputType == "Controller"))
								{
									trace(deviceType,": ", inputType);
									//tt.processSensorControllerSocketData(message);
								}
								if ((deviceType == "NES") && (inputType == "Controller"))
								{
									trace(deviceType,": ", inputType);
									//tt.processSensorControllerSocketData(message);
								}
								//PS3 MOVE
								

								//BCI DEVICES////////////////////////////////////////////
								if ((deviceType == "MUSE") && (inputType == "EEG"))trace(deviceType, ": ", inputType);
								if ((deviceType == "INSIGHT") && (inputType == "EEG"))trace(deviceType, ": ", inputType);
								
								//MYO////////////////////////////////////////////////////
								if ((deviceType == "MYO") && (inputType == "EMG")) trace(deviceType, ": ", inputType);
								
								//VOICE
								
					}
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
