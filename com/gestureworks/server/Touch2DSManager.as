package com.gestureworks.server 
{
	import com.gestureworks.objects.TouchPointObject;
	import com.gestureworks.managers.TouchManager;
	import com.gestureworks.events.GWTouchEvent;
	import com.gestureworks.managers.InteractionPointTracker;
	import com.gestureworks.managers.InteractionManager;
	import com.gestureworks.objects.InteractionPointObject;
	import com.gestureworks.core.gw_public;
	import com.gestureworks.core.GestureGlobals;
	
	import flash.utils.Dictionary;
	
	import flash.geom.Vector3D;
	/**
	 * The Touch2DSManager handles the parsing of touch type points socket frame data from the device server.
	 * Generic touch points a split by type into finger, stylus, fiducial and shape.
	 * 
	 * @author Ideum
	 *
	 */
	public class Touch2DSManager
	{
		private static var frame:XML
		private static var message:Object
		private static var inputType:String
		private static var frameId:int; 
		private static var timestamp:int; 
		
		private static var fingercount:int;
		private static var styluscount:int;
		private static var fiducialcount:int;
		private static var shapecount:int;
		
		private static var debug:Boolean = false;
		
		public static var stylusOn:Boolean = true;
		public static var tagOn:Boolean = true;
		public static var fingerOn:Boolean = true;
		public static var shapeOn:Boolean = false;
		
		public static var interactionPoints:Dictionary = new Dictionary();

		
		public static function initialize():void 
		{
			trace("touch 2d server manager constructor");
			
			interactionPoints = GestureGlobals.gw_public::interactionPoints;
		}
	
		
		public static function processTouch2DSocketData(xmlList:XMLList):void //:XML//message:XML
		{
			var id_shift:int = 200;

			fingercount = int(xmlList.Finger.length());
			styluscount = int(xmlList.Stylus.length());
			fiducialcount = int(xmlList.Fiducial.length());
			shapecount = int(xmlList.Shape.length());
				
				//trace("inside touch2d server parser", fingercount);
				
				//FINGER
				if (xmlList.Finger && fingerOn) 
				{
					// CREATE finger Touch POINTS
					for (var k:int = 0; k < fingercount; k++)
					{
						//trace(xmlList.Finger,xmlList.Finger[k], fingercount,xmlList.Finger[k].@id,xmlList.Finger[k].@x)
						//var f =  message.InputPoint.Values.Surface.Point[k];
						var finger =  xmlList.Finger[k];//message.InputPoint.Values.Eye[k];
						var ptf:InteractionPointObject = new InteractionPointObject();

							ptf.interactionPointID = int(finger.@id) + id_shift; 
							ptf.rootPointID = int(finger.@id); 
							ptf.source = "native"//"server";
							ptf.mode = "touch";
							ptf.type = "finger"//must be dynamic to show in debugger
							ptf.phase = finger.@phase; //need phase
							ptf.radius = finger.@radius;
							ptf.pressure = finger.@pressure;
							ptf.theta = finger.@theta; 
							ptf.position = new Vector3D(finger.@x, finger.@y, 0);
							ptf.size = new Vector3D(finger.@width, finger.@height, 0);
							
						//trace(ptf.id,ptf.source,ptf.type, ptf.phase, ptf.position)
						
						InteractionPointTracker.framePoints.push(ptf);
						
						//if (ptf.phase == "begin"|| ptf.phase == "touch_down") 		InteractionManager.onInteractionBeginPoint(ptf);
						//else if (ptf.phase == "update"|| ptf.phase == "touch_move")	InteractionManager.onInteractionUpdatePoint(ptf);
						//else if (ptf.phase == "end"|| ptf.phase == "touch_up")		InteractionManager.onInteractionEndPoint(ptf);
					}
				}
				
				//STYLUS/PEN/BRUSH (position, radius,width,height, name, theta)
				if (xmlList.Stylus && stylusOn) 
				{
					// CREATE pen Touch POINTS
					for (var ks:int = 0; ks < styluscount; ks++)
					{
						var stylus:Object =  xmlList.Stylus[ks];
						var pts:InteractionPointObject = new InteractionPointObject();
						
							pts.id = int(stylus.@id) + id_shift;
							pts.source = "native"//"server";
							pts.mode = "touch";
							pts.type = "finger"//"stylus";
							pts.phase = stylus.@phase;
							//pts.pressure = stylus.@pressure;
							pts.radius = stylus.@radius;
							pts.position = new Vector3D(stylus.@x,stylus.@y,0);
							pts.size = new Vector3D(stylus.@width, stylus.@height, 0);
							
						InteractionPointTracker.framePoints.push(pts);
						//if (pts.phase == "begin"|| pts.phase == "touch_down") 		InteractionManager.onInteractionBeginPoint(pts);
						//else if (pts.phase == "update"|| pts.phase == "touch_move")	InteractionManager.onInteractionUpdatePoint(pts);
						//else if (pts.phase == "end"|| pts.phase == "touch_up")		InteractionManager.onInteractionEndPoint(pts);
					}
				}
				
				//OBJECT/FIDUCIAL/TAG (position, point number,width,height,name, theta)
				if (xmlList.Fiducial && tagOn) 
				{
					//trace("tag parser",fiducialcount);
					
					// CREATE tag Touch POINTS
					for (var ko:int = 0; ko < fiducialcount; ko++)
					{
						//var f =  message.InputPoint.Values.Surface.Point[k];
						var tag:Object =  xmlList.Fiducial[ko];//message.InputPoint.Values.Eye[k];
						var ptt:InteractionPointObject = new InteractionPointObject();
						
							ptt.interactionPointID = int(tag.@id) + id_shift; 
							ptt.rootPointID = int(tag.@id); 
							ptt.source = "server";
							ptt.mode = "touch";
							ptt.type = "tag";
							ptt.name = tag.name;// or ref
							ptt.tagn = tag.numPoints; // point number
							ptt.theta = tag.@theta;
							ptt.dtheta = tag.@dtheta;
							ptt.radius = tag.@radius;
							//pto.pressure = tag.@pressure
							ptt.position = new Vector3D(tag.@x,tag.@y,0); 
							ptt.size = new Vector3D(tag.@width, tag.@height, 0);
						
						//trace(xmlList);
						trace("tag-----------------------------",ptt.interactionPointID,ptt.rootPointID ,ptt.source,ptt.name ,ptt.type, ptt.phase)
							
						//InteractionPointTracker.framePoints.push(pto);
						
						if (ptt.phase == "") InteractionManager.onInteractionBeginPoint(ptt);
						
						if (ptt.phase == "begin"|| ptt.phase == "touch_down") 		InteractionManager.onInteractionBeginPoint(ptt);
						else if (ptt.phase == "update"|| ptt.phase == "touch_move")	InteractionManager.onInteractionUpdatePoint(ptt);
						else if (ptt.phase == "end"|| ptt.phase == "touch_up")		InteractionManager.onInteractionEndPoint(ptt);
					}
				}
				
				//SHAPE (position, radius,width,height,name, theta)
				if (xmlList.Shape && shapeOn) 
				{
					// CREATE shape Touch POINTS
					for (var ksh:int = 0; ksh < shapecount; ksh++)
					{
						//var f =  message.InputPoint.Values.Surface.Point[k];
						var shape:Object = xmlList.Shape[ksh];//message.InputPoint.Values.Eye[k];
						var ptsh:InteractionPointObject = new InteractionPointObject();
							ptsh.id = int(shape.@id) + id_shift;
							ptsh.source = "server";
							ptsh.mode = "touch";
							ptsh.type = "shape"
							ptsh.name = shape.name;
							ptsh.theta = shape.@theta;
							ptsh.dtheta = shape.@dtheta;
							ptsh.radius = shape.@radius;
							//ptsh.pressure = shape.@pressure;
							ptsh.position = new Vector3D(shape.@x,shape.@y,0); 
							ptsh.size = new Vector3D(shape.@width, shape.@height, 0);
							
						//InteractionPointTracker.framePoints.push(ptsh);
						if (ptsh.phase == "begin"|| ptsh.phase == "touch_down") 		InteractionManager.onInteractionBeginPoint(ptsh);
						else if (ptsh.phase == "update"|| ptsh.phase == "touch_move")	InteractionManager.onInteractionUpdatePoint(ptsh);
						else if (ptsh.phase == "end"|| ptsh.phase == "touch_up")		InteractionManager.onInteractionEndPoint(ptsh);
					}
				}

		}
		
	}
}
