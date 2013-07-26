////////////////////////////////////////////////////////////////////////////////
//
//  IDEUM
//  Copyright 2011-2012 Ideum
//  All Rights Reserved.
//
//  GestureWorks
//
//  File:    VirtualTouchObject.as
//  Authors:  Ideum
//             
//  NOTICE: Ideum permits you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////
package com.gestureworks.core
{
	import com.gestureworks.core.TouchSprite;
	import flash.geom.Transform;
	
	/**
	 * <p>The VirtualTouchObject class allows you to apply manipulations and transformations to an object 
	 * that doesn't extend TouchSprite or TouchMovieClip. Pass to the constructor, the target 
	 * that you ultimately want to be transformed. The class will attempt to adapt the display object's 
	 * current transform matrix. If native transformations are enabled (disableNativeTransform="false"),
	 * then it will attempt to automatically apply the updated transforms. If using gestureEvents, simply
	 * apply the return values to the object that you want to transform, instead of the VirtualTouchObject 
	 * itself.</p> 
	 * 
	 * <p>If your target class doesn't support the AS3 tranform class, then you should extend this class 
	 * and add in the neccesary hooks, generally converting the AS3 transform return values to the 
	 * required format.</p> 
	 */
	public class VirtualTouchObject extends TouchSprite
	{	
		public var target:*;		
		
		public function VirtualTouchObject(target:*):void
		{
			super();				
			
			this.target = target;			
					
			// set transform to target
			if ("transform" in target && target.transform is Transform)
				transform.matrix = target.transform.matrix;				
        }
	}
}