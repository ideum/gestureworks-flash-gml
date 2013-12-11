package com.gestureworks.managers {
	
	import com.gestureworks.core.GestureGlobals;
	import com.gestureworks.objects.ClusterObject;
	
	/**
	 * Manages object pooling to recycle objects opposed to performance intensive allocation (instantiation)
	 * and deallocation (garbage collection)
	 * @author Ideum
	 */
	public class PoolingManager {
		
		//cluster object pool
		private static var cOPool:Vector.<ClusterObject> = new Vector.<ClusterObject>();
		
		//number of registered touch objects
		private static var objCnt:int;
		
		//variable to store the pool sizes
		private static var poolSize:int;
		
		/**
		 * Populate object pools based on object count
		 */
		public static function registerPools():void {
			objCnt = GestureGlobals.objectCount;
			
			updateCOPool();
		}
		
		/**
		 * Decrease the sizes of the object pools
		 */
		public static function unregisterPools():void {
			objCnt = GestureGlobals.objectCount;
			
			updateCOPool();
		}
		
		/**
		 * Increase/decrease the size of the pool depending on the number of touch objects
		 */
		private static function updateCOPool():void {
			poolSize = objCnt * GestureGlobals.clusterHistoryCaptureLength;
			
			for (var i:int = cOPool.length; i < poolSize; i++)
				cOPool.push(new ClusterObject());
				
			if (poolSize < cOPool.length)
				cOPool.splice(poolSize, cOPool.length-1);
		}
		
		/**
		 * Shift the top ClusterObject to the bottom of the queue then return it
		 * @return the top ClusterObject
		 */
		public static function get clusterObject():ClusterObject {
			var co:ClusterObject = cOPool.shift();
			co.reset();
			cOPool.push(co);
			return co;
		}
		
	}

}