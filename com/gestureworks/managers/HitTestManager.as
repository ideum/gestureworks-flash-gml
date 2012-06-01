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
		private var debug:Boolean = false;
		
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
				
		public function hitTest(container:DisplayObjectContainer, hitX:int, hitY:int, type:String="down"):DisplayObject
		{
			
			var child:DisplayObject;
			var hitObject:DisplayObject = null;
			
			recursion(container);
			
			function recursion(container:DisplayObjectContainer):void
			{
				for (var i:int=0; i<container.numChildren; i++)
				{
					child = container.getChildAt(i);
										
					if (type=="down" && child is TouchSprite && child.hitTestPoint(hitX, hitY))
					{
						hitObject = child;
					}
			
					if (child is DisplayObjectContainer)
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