package com.gestureworks.server 
{
	import com.gestureworks.objects.TouchPointObject;
	import com.gestureworks.managers.TouchManager;
	import com.gestureworks.events.GWTouchEvent;
	import com.gestureworks.managers.InteractionPointTracker;
	import com.gestureworks.objects.InteractionPointObject;
	
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
		
		public var stylusOn:Boolean = false;
		public var tagOn:Boolean = false;
		public var fingerOn:Boolean = false;
		public var shapeOn:Boolean = false;

		
		public function Touch2DSManager(); 
		{
			trace("touch 2d server manager constructor");
		}
	
		
		public function processTouch2DSocketData(xmlList:XMLList):void //:XML//message:XML
		{
			//trace("inside");
	
				fingercount = int(xmlList.Finger.length());
				styluscount = int(xmlList.Stylus.length());
				fiducialcount = int(xmlList.Fiducial.length());
				shapecount = int(xmlList.Shape.length());
				
				
				//FINGER
				if (xmlList.Finger && fingerOn) 
				{
					// CREATE finger Touch POINTS
					for (var k:int = 0; k < fingercount; k++)
					{
						//trace(xmlList.Finger,xmlList.Finger[k], fingercount,xmlList.Finger[k].@id,xmlList.Finger[k].@x)
						//var f =  message.InputPoint.Values.Surface.Point[k];
						var finger:Object =  xmlList.Finger[k];//message.InputPoint.Values.Eye[k];
						var ptf:InteractionPointObject = new InteractionPointObject();
						
							ptf.id = finger.@id; 
							ptf.type = "finger"
							ptf.phase = finger.@phase;
							//ptf.pressure = finger.@pressure;
							ptf.theta = finger.@theta;
							if (!ptf.position) ptf.position = new Vector3D(finger.@x,finger.@y,0);
							if (!ptf.size) ptf.size = new Vector3D(finger.@width, finger.@height, 0);
							
						InteractionPointTracker.framePoints.push(ptf);
					}
				}
				
				//STYLUS/PEN/BRUSH (position, radius,width,height, name, theta)
				if (xmlList.Stylus && stylusOn) 
				{
					// CREATE finger Touch POINTS
					for (var ks:int = 0; ks < styluscount; ks++)
					{
						var stylus:Object =  xmlList.Stylus[ks];
						var pts:InteractionPointObject = new InteractionPointObject();
							pts.id = stylus.@id;
							pts.type = "stylus";
							pts.phase = stylus.@phase;
							//pts.pressure = stylus.@pressure;
							if (!pts.position) pts.position = new Vector3D(stylus.@x,stylus.@y,0);
							if (!pts.size) pts.size = new Vector3D(stylus.@width, stylus.@height, 0);
							
							
						InteractionPointTracker.framePoints.push(pts);
					}
				}
				
				//OBJECT/FIDUCIAL/TAG (position, point number,width,height,name, theta)
				if (xmlList.Fiducial && tagOn) 
				{
					// CREATE finger Touch POINTS
					for (var ko:int = 0; ko < fiducialcount; ko++)
					{
						//var f =  message.InputPoint.Values.Surface.Point[k];
						var tag:Object =  xmlList.Fiducial[ko];//message.InputPoint.Values.Eye[k];
						var pto:InteractionPointObject = new InteractionPointObject();
							pto.id = tag.@id; 
							pto.type = "tag";
							pto.name = tag.name;// or ref
							pto.tagn = tag.n; // point number
							ptf.theta = finger.@theta;
							ptf.dtheta = finger.@dtheta;
							//pto.pressure = tag.@pressure
							if(pto.position) pto.position = new Vector3D(tag.@x,tag.@y,0); 
							if (pto.size) pto.size = new Vector3D(tag.@width, tag.@height, 0);
							
						InteractionPointTracker.framePoints.push(pto);
					}
				}
				
				//SHAPE (position, radius,width,height,name, theta)
				if (xmlList.Shape && shapeOn) 
				{
					// CREATE finger Touch POINTS
					for (var ksh:int = 0; ksh < shapecount; ksh++)
					{
						//var f =  message.InputPoint.Values.Surface.Point[k];
						var shape:Object = xmlList.Shape[ksh];//message.InputPoint.Values.Eye[k];
						var ptsh:InteractionPointObject = new InteractionPointObject();
							ptsh.id = shape.@id; 
							ptsh.type = "shape"
							ptsh.name = shape.name;
							ptf.theta = finger.@theta;
							ptf.dtheta = finger.@dtheta;
							//ptsh.pressure = shape.@pressure;
							if(ptsh.position) ptsh.position = new Vector3D(shape.@x,shape.@y,0); 
							if (ptsh.size) ptsh.size = new Vector3D(shape.@width, shape.@height, 0);
							
						InteractionPointTracker.framePoints.push(ptsh);
					}
				}

		}
		
	}
}
