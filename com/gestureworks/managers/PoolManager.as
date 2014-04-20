package com.gestureworks.managers {
	
	import com.gestureworks.core.GestureGlobals;
	import com.gestureworks.objects.ClusterObject;
	import com.gestureworks.objects.FrameObject;
	
	/**
	 * Manages object pooling to recycle objects opposed to performance intensive allocation (instantiation)
	 * and deallocation (garbage collection)
	 * @author Ideum
	 */
	public class PoolManager {
		
		private static var instance:PoolManager
		
		public static function getInstance():PoolManager {
			if (!instance) {
				instance = new PoolManager;
			}
			return instance;
		}
		
		//cluster object pool
		private  var cOPool:Vector.<ClusterObject> = new Vector.<ClusterObject>();
		//frame object pool
		private  var framePool:Vector.<FrameObject> = new Vector.<FrameObject>();
		
		//number of registered touch objects
		private  var objCnt:int;		
		//variable to store the pool sizes
		private  var poolSize:int;
		
		/**
		 * Populate object pools based on object count
		 */
		public  function registerPools():void {
			objCnt = GestureGlobals.objectCount;
			
			updateCOPool();
			updateFramePool();
		}
		
		/**
		 * Decrease the sizes of the object pools
		 */
		public  function unregisterPools():void {
			objCnt = GestureGlobals.objectCount;
			
			updateCOPool();
			updateFramePool();
		}

		/********************ClusterObject********************/
		/**
		 * Updates the queue of the pool by shifting the top object to the bottom
		 * @return  The next object on top of the queue
		 */		
		private  function updateCOPool():void {
			poolSize = objCnt * GestureGlobals.clusterHistoryCaptureLength;
			
			for (var i:int = cOPool.length; i < poolSize; i++)
				cOPool.push(new ClusterObject());
				
			if (poolSize < cOPool.length)
				cOPool.splice(poolSize, cOPool.length-1);
		}
		
		/**
		 * Retrurn ClusterObject from pool
		 * @return the top ClusterObject
		 */
		public  function get clusterObject():ClusterObject {
			var cO:ClusterObject = cOPool.shift();
			cO.reset();
			cOPool.push(cO);			
			return cO;
		}
		
		
		/********************FrameObject********************/		
		/**
		 * Updates the queue of the pool by shifting the top object to the bottom
		 * @return  The next object on top of the queue
		 */				
		private  function updateFramePool():void {
			poolSize = objCnt * GestureGlobals.timelineHistoryCaptureLength;
			
			for (var i:int = framePool.length; i < poolSize; i++)
				framePool.push(new FrameObject());
				
			if (poolSize < framePool.length)
				framePool.splice(poolSize, framePool.length - 1);
		}
		
		/**
		 * Return FrameObject from pool
		 * @return the top FrameObject
		 */
		public  function get frameObject():FrameObject {
			var frame:FrameObject = framePool.shift();
			frame.reset();
			framePool.push(frame);			
			return frame;
		}
		
	}

}