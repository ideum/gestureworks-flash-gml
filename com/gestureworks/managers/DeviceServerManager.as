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
	import com.gestureworks.objects.SensorPointObject;
	import com.gestureworks.core.gw_public;
	
	import com.gestureworks.server.Motion3DSManager;
	import com.gestureworks.server.Touch2DSManager;
	import com.gestureworks.server.Eye2DSManager;
	import com.gestureworks.server.AndroidSensorManager;
	import com.gestureworks.server.ControllerSensorManager;

	/**
	 * The DeviceServerManager class handles the communication via an XML Socket.
	 *
	 * @author Ideum
	 *
	 */
	public class DeviceServerManager //extends //Sprite
	{
		private static var socket:Socket;
		private static var currentState:int;
		private static var _isConnected:Boolean = false;
		
		public static var _host:String = "127.0.0.1"//"localhost";
		public static var _port:int = 49191;
		
		private static var XMLFrameList:XMLList;
		
		private static var touchManagerSocket:Touch2DSManager;
		
		private static var motionManagerSocket:Motion3DSManager;
		private static var eyeManagerSocket:Eye2DSManager;
		
		private static var androidSensorManagerSocket:AndroidSensorManager;
		private static var controllerSensorManagerSocket:ControllerSensorManager;
		
		
		
		public function DeviceServerManager():void
		{
			trace("device server manager constructor");
		}
		
		gw_public static function initialize():void
		{
			trace("device server manager init");
			init();
		}

		//public function init():void
		public static function init():void
		//gw_public static function init():void
		{
			trace("device server manager init",GestureWorks.activeTouch,GestureWorks.activeMotion,GestureWorks.activeSensor );
			
			//////////////////////////////////////////////////
			if (GestureWorks.activeTouch) 
			{
				//touchManagerSocket = new Touch2DSManager(); 
			}
			if (GestureWorks.activeMotion)
			{
				motionManagerSocket = new Motion3DSManager();
				//eyeManagerSocket = new Eye2DSManager();
			}
			//if (GestureWorks.activeSensor)
			//{
				trace("Sensor classes init");
				//androidSensorManagerSocket = new AndroidSensorManager();
				//controllerSensorManagerSocket = new ControllerSensorManager();
			//}
			
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
				
					if (dfrn!=0){
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
							
							//trace("inout mode",inputMode);
							
							if (message.InputPoint.InputTypes.InputType.length()>0) inputType = message.InputPoint.InputTypes.InputType[0].@input;// simplify as likely use different output in seperate message
							else inputType = "unknown"
							
							//trace("data types",deviceType,inputType, inputMode)
							

							if (GestureWorks.activeTouch)
							{
							//if (inputMode=="touch"){
							///////////////////////////////////////////////////////////////
							// TOUCH //////////////////////////////////////////////////////
							
								//PQ /////////////////////////////////////////////////
								if ((deviceType == "PQ") && (inputType == "Points2d")) {
									//trace(message.InputPoint.Values.Finger);
									//trace("pq finger", message.InputPoint.Values.Finger);//FINGER
									//trace("pq stylus", message.InputPoint.Values.Stylus);//PEN/STYLUS
									//trace("pq fiducial", message.InputPoint.Values.Fiducial);//FIDUCIAL /OBJECT
									
									//trace(message.InputPoint.Values);
									//touchManagerSocket.processTouch2DSocketData(message.InputPoint.Values);
									Touch2DSManager.processTouch2DSocketData(message.InputPoint.Values);
									//trace("in pq")
								}
								//3M////////////////////////////////////////////////////////
								if ((deviceType == "3M") && (inputType == "Points2d")) {
									trace("3m finger", message.InputPoint.Values.Finger);//FINGER
									trace("3m stylus", message.InputPoint.Values.Stylus);//PEN/STYLUS
									trace("3m fiducial", message.InputPoint.Values.Fiducial);//FIDUCIAL /OBJECT
									
									//touchManagerSocket.processTouch2DSocketData(message.InputPoint.Values);
									Touch2DSManager.processTouch2DSocketData(message.InputPoint.Values);
									
								}
								
								//ZYTRONIC//////////////////////////////////////////////////
								//if (deviceType == "LeapMotion" && inputType == "Points2d"){}//touchManagerSocket.processTouch2DSocketData(message);
								
								if (deviceType == "Android" && inputType == "Points2d"){//WORKS
									//trace("Android finger touch", message.InputPoint.Values.Finger);
									//touchManagerSocket.processTouch2DSocketData(message.InputPoint.Values);
								}
							}
							
							if (GestureWorks.activeMotion){//
							//if (inputMode=="motion"){
							//////////////////////////////////////////////////////////////
							//MOTION//////////////////////////////////////////////////////
							//////////////////////////////////////////////////////////////
							
							//trace("motion",deviceType,inputType);
							
							////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
							///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
							trace(message);
							
								//HAND/FINGER TRACKING////////////////////////////////////////
								if ((deviceType == "LeapMotion") && (inputType == "Hands3d")) motionManagerSocket.processMotion3DSocketData(message.InputPoint.Values.Hand);
								if ((deviceType == "RealSense") && (inputType == "Hands3d")) motionManagerSocket.processMotion3DSocketData(message.InputPoint.Values.Hand);
								//if ((deviceType == "DUO3D") && (inputType == "Hands3d")) motionManagerSocket.processMotion3DSocketData(message.InputPoint.Values.Hand);

								//BODY TRACKING
									//KINECT
									//XITION
									//SOFKINECTIC
									
								//FACE TRACKING
									//SOKINECTIC
									//REALSENSE//////////////////////////////////////////////////////////////////////////
									
									
									// EYE TRACKING////////////////////////////////////////////////////////////////////
										if ((deviceType == "Eyetribe") && (inputType == "Eyes3d")) { //WORKS
											trace(deviceType, ": ", inputType);
											eyeManagerSocket.processEye2DSocketData(message.InputPoint.Values);
										}
										if ((deviceType == "Tobii") && (inputType == "Eyes2d")){
											trace(deviceType, ": ", inputType);
											eyeManagerSocket.processEye2DSocketData(message.InputPoint.Values.Eye);
										}
							}
							
							if (GestureWorks.activeSensor)
							{
							//trace("active sensor in device socket parser");
							//if (inputMode=="sensor"){
							///////////////////////////////////////////////////////////////
							// SENSOR //////////////////////////////////////////////////////
							
								//ARDUINO//////////////////////////////////////////////////////////////
								//if ((deviceType == "Arduino") && (inputType == "Sensor6d")) tt.processSensorArduinoSocketData(message);
								
								//ACCELEROMETERS//////////////////////////////////////////////////////
								if ((deviceType == "Android") && (inputType == "Sensor6d")) 
								{
									//trace("android sensors", message.InputPoint.Values.AndroidDevice);
									//trace(message.InputPoint.Values.AndroidDevice.Acceleration, message.InputPoint.Values.AndroidDevice.RotationSpeed)
									androidSensorManagerSocket.processAndroidSensorSocketData(message.InputPoint.Values.AndroidDevice)
								}
								if ((deviceType == "MUSE") && (inputType == "Accel3d")) trace(deviceType, ": ", inputType);
								
								if ((deviceType == "MYO") && (inputType == "Accel3d")) {
									trace(deviceType, ": ", inputType);
								}
								if ((deviceType == "NOD") && (inputType == "Accel3d")) {
									trace(deviceType, ": ", inputType);
								}
								
								//GPS
								//MAGNOMETER
								//GYROMETER
								//IR SENSOR
							
								// CONTROLLERS////////////////////////////////////////////
								if ((deviceType == "WiiMote") && (inputType == "Sensor6d"))//Controller
								{
									//trace(deviceType, ": ", inputType);
									//trace(message.InputPoint.Values)
									controllerSensorManagerSocket.processControllerSensorSocketData(message.InputPoint.Values,deviceType);
								}
								
								//MYO//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
									if ((deviceType == "MYO") && (inputType == "EMG")) {
									trace(deviceType, ": ", inputType);
								}
								//NOD//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
								if ((deviceType == "NOD") && (inputType == "Sensor6D")) {
									trace(deviceType, ": ", inputType);
								}
								
								//OLD SCHOOL CONTROLLERS/////////////////////////////////////////////////////////////////////////////////////////////////////////
								if ((deviceType == "SNES") && (inputType == "Controller"))		//sensorManagerSocket.processSensorControllerSocketData(message);
								if ((deviceType == "NES") && (inputType == "Controller"))		//sensorManagerSocket.processSensorControllerSocketData(message);
								if ((deviceType == "PS3") && (inputType == "Controller"))		//sensorManagerSocket.processSensorControllerSocketData(message);
								if ((deviceType == "PS3_MOVE") && (inputType == "Controller"))	//sensorManagerSocket.processSensorControllerSocketData(message);
								
								
								//BCI DEVICES///////////////////////////////////////////////////////////////////////////////////////////////////////////////
								if ((deviceType == "MUSE") && (inputType == "EEG")) trace(deviceType, ": ", inputType);
								if ((deviceType == "INSIGHT") && (inputType == "EEG")) trace(deviceType, ": ", inputType);
								

								
							}
					}
				}
				}
				else{
					
					trace("null frame");
					
				}
			}
			}
			else trace("xml frame parsing error",lg,start,end);

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
