package com.gestureworks.managers 
{
	import com.gestureworks.core.*;
	import flash.display.*;
	import flash.events.*;
	
	/**
	 * ...
	 * @author Charles Veasey
	 */
	
	public class HitTestManager extends EventDispatcher
	{
		private var debug:Boolean = true;
		
		public function HitTestManager(enforcer:SingletonEnforcer) {}
		
		private static var _instance:HitTestManager;
		/*
		 * Returns singleton instance
		 */
		public static function get instance():HitTestManager 
		{ 
			if (_instance == null)
				_instance = new HitTestManager(new SingletonEnforcer());			
			return _instance; 
		}
				
		public function hitTest(container:DisplayObjectContainer, hitX:int, hitY:int):DisplayObject
		{			
			var child:DisplayObject;
			var hitObject:DisplayObject = null;
					
			recursion(container);
			
			function recursion(container:DisplayObjectContainer):void
			{
				for (var i:int=container.numChildren-1; i>=0; i--)
				{ 
					if (debug) trace(child, i);
					child = container.getChildAt(i);
							
					if (child is TouchSprite && !(child["mouseChildren"] || child["touchChildren"]) && child.hitTestPoint(hitX, hitY))
					{
						trace("touchsprite");
						hitObject = child;
						return;
					}
					else if (child.hasEventListener(MouseEvent.MOUSE_DOWN) && child.hitTestPoint(hitX, hitY))
					{
						trace("mouse");
						hitObject = child;
						hitObject.dispatchEvent(new MouseEvent(MouseEvent.MOUSE_DOWN, true, false));
						return;
					}
					else if (child.hasEventListener(TouchEvent.TOUCH_BEGIN) && child.hitTestPoint(hitX, hitY))
					{
						trace("touch");
						hitObject = child;
						hitObject.dispatchEvent(new MouseEvent(MouseEvent.MOUSE_DOWN, true, false));
						return;
					}
					else if (child is DisplayObjectContainer)
					{
						recursion(DisplayObjectContainer(child));
					}
				}	
			}			
			return hitObject;
		}
				
		
		public function traceDisplayList(container:DisplayObjectContainer, indentString:String=""):void 
		{ 
			var child:DisplayObject; 
			for (var i:int=0; i < container.numChildren; i++) 
			{ 
				child = container.getChildAt(i); 
				trace(indentString, child, child.name, i);  
				if (container.getChildAt(i) is DisplayObjectContainer) 
				{ 
					traceDisplayList(DisplayObjectContainer(child), indentString + "    ");
				} 
			} 
		}			
	
		
		
	}
}

class SingletonEnforcer{}