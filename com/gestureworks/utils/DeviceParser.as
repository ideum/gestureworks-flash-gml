////////////////////////////////////////////////////////////////////////////////
//
//  IDEUM
//  Copyright 2011-2012 Ideum
//  All Rights Reserved.
//
//  GestureWorks
//
//  File:    GestureParser.as
//  Authors:  Ideum
//             
//  NOTICE: Ideum permits you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////
package com.gestureworks.utils
{
	import flash.geom.Point;
	
	import com.gestureworks.core.GestureWorks;
	import com.gestureworks.core.GestureGlobals;
	import com.gestureworks.core.gw_public;
	import com.gestureworks.core.DML;
	//import com.gestureworks.managers.TouchManager;
	
	//import com.gestureworks.objects.DimensionObject;
	//import com.gestureworks.objects.GestureObject;
	//import com.gestureworks.objects.GestureListObject;
	
	//import com.gestureworks.events.GWGestureEvent;
	
	public class DeviceParser
	{
		//public var gOList:GestureListObject;
		public var deviceList:Object;
		public var deviceTypeList:Object;
		//private var dList:Vector.<GestureObject>;
		public var dml:XMLList;
		
		public function GestureParser():void
		{
			init();
        }
		
		public function init():void 
         {
		 //ID = touchSpriteID;
		 }
		
		/////////////////////////////////////////////////////////////////////
		// GML
		/////////////////////////////////////////////////////////////////////
        public function parse(ID:int):void 
         {
			//GWGestureEvent.CUSTOM.NEW_GESTURE = "new-gesture";
			//trace("parsing gml");
			
			//gOList = GestureGlobals.gw_public::gestures[ID];
			gml = new XMLList(DML.Gestures);
			//gList = new Vector.<GestureObject>;
			
			//trace(gml)
			deviceTypeList = { 
								"wiimote":true, 
								"kinect":true, 
								"accelerometer":true, 
								"arduio":true
							};		

						
						
						/*	
									
						var gestureSetNum:int = gml.devices.length();
						
						for (var g:int = 0; g < gestureSetNum; g++) 
							{
						
							var gestureNum:int = gml.Gesture_set[g].Gesture.length();
							
							//trace("gesture number",gestureNum)
						
							for (var i:int = 0; i < gestureNum; i++) 
							{
								var gesture_id:String = String(gml.Gesture_set[g].Gesture[i].attribute("id"));
								var gesture_set_id:String = String(gml.Gesture_set[g].attribute("id"));
								var propertyNum:int = int(gml.Gesture_set[g].Gesture[i].analysis.algorithm.returns.property.length());
								
								
								//trace("gesture id",gesture_id,"gesture set id",gesture_set_id)
								///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
								// properties of the gesture 
								///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
								
								// check to see if in the gesture list for this touch object
								var key:String;
								var type:String;
								
								// 	for all gestures listed for touchspriteID
								for (key in gestureList)
								{
								//trace("key", key, gesture_id, gesture_set_id);
								
								// check for key match in gml // gesture sets set match
								
								if ((gesture_id == key)||(gesture_set_id == key)) 
								{	
									var gtype:String = String(gml.Gesture_set[g].Gesture[i].attribute("type"));
									
									//trace("gtype-----------------------------",gtype);
									
									// for all matches in cml gesturelist and gml 
									for (type in gestureTypeList)
										{
										//trace(type, gtype)
										// check tha type is allowable 
										if (type == gtype)
										{
											//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
											// create new gesture object for handling gesture data structure
											//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
											
											var gO:GestureObject = new GestureObject();

											
											// PUSH GESTURE OBJECT INTO GESTURE LIST VECTOR
											gList.push(gO);
										}
									}
											//////////////////////////////////////////////////////////////////////////////////
											//////////////////////////////////////////////////////////////////////////////////
									}
									
								}
							} // gestures
						}// gesture sets
						
							gOList.pOList = gList;
							
			*/			
				
				//traceDeviceList()
		}
		////////////////////////////////////////////////////////////////////////////
		
		public function traceDeviceList():void
		{
			//trace("new display object created in gesture parser util");
			var gn:uint = gOList.pOList.length;
			
			for (var i:uint = 0; i < gn; i++ )
				{
					//trace("	new gesture object:--------------------------------");
					//trace("g xml....."+"\n",gOList.pOList[i].gesture_xml)
					var dn:uint = gOList.pOList[i].dList.length;

				}
				//trace("gesture object parsing complete");
		}
	}
}