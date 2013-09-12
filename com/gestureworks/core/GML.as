////////////////////////////////////////////////////////////////////////////////
//
//  IDEUM
//  Copyright 2011-2012 Ideum
//  All Rights Reserved.
//
//  GestureWorks
//
//  File:    GML.as
//  Authors:  Ideum
//             
//  NOTICE: Ideum permits you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

// DEFAULT INTERNAL GML
// WHEN NO EXTERNAL GML DETECTED CAN BE LOADED TO ENABLE GESTURE ANALTYSIS
// MAKE SURE IS UP TO DATE WITH STANDARD MY_GESTURE.GML FILE

package com.gestureworks.core
{
	public class GML
	{
		public static var Gestures:XML =
		
	<Gestures>
		
	<Gesture_set gesture_set_name="basic-core-gestures">
				
					<comment>The 'basic-core-gestures' are the simple form of the classic roate scale and drag gestures commonly used to manipulate touch objects.</comment>
		
					<Gesture id="n-drag" type="drag">
						<comment>The 'n-drag' gesture can be activated by any number of touch points between 1 and 10. When a touch down is recognized on a touch object the position
						of the touch point is tracked. This change in the position of the touch point is mapped directly to the position of the touch object.</comment>
						<match>
							<action>
								<initial>
									<cluster point_number="0" point_number_min="1" point_number_max="10"/>
								</initial>
							</action>
						</match>	
						<analysis>
							<algorithm class="kinemetric" type="continuous">
								<library module="drag"/>
								<returns>
									<property id="drag_dx" result="dx"/>
									<property id="drag_dy" result="dy"/>
								</returns>
							</algorithm>
						</analysis>	
						<mapping>
							<update dispatch_type="continuous">
								<gesture_event  type="drag">
									<property ref="drag_dx" target="x"/>
									<property ref="drag_dy" target="y"/>
								</gesture_event>
							</update>
						</mapping>
					</Gesture>
			
					<Gesture id="n-rotate" type="rotate">
					<comment>The 'n-rotate' gesture can be activated by any number of touch points between 2 and 10. When two or more touch points are recognized on a touch object the relative orientation
						of the touch points are tracked and grouped into a cluster. This change in the orientation of the cluster is mapped directly to the rotation of the touch object.</comment>
					
						<match>
							<action>
								<initial>
									<cluster point_number="0" point_number_min="2" point_number_max="10"/>
								</initial>
							</action>
						</match>
						<analysis>
							<algorithm class="kinemetric" type="continuous">
								<library module="rotate"/>
								<returns>
									<property id="rotate_dtheta" result="dtheta"/>
								</returns>
							</algorithm>
						</analysis>	
						<mapping>
							<update dispatch_type="continuous">
								<gesture_event type="rotate">
									<property ref="rotate_dtheta" target="rotate"/>
								</gesture_event>
							</update>
						</mapping>
					</Gesture>
					
					<Gesture id="n-scale" type="scale">
					
						<comment>The 'n-scale' gesture can be activated by any number of touch points between 2 and 10. When two or more touch points are recognized on a touch object the relative separation
						of the touch points are tracked and grouped into a cluster. Changes in the separation of the cluster are mapped directly to the scale of the touch object.</comment>
						
						<match>
							<action>
								<initial>
									<cluster point_number="0" point_number_min="2" point_number_max="10"/>
								</initial>
							</action>
						</match>
						<analysis>
							<algorithm class="kinemetric" type="continuous">
								<library module="scale"/>
								<returns>
									<property id="scale_dsx" result="ds"/>
									<property id="scale_dsy" result="ds"/>
								</returns>
							</algorithm>
						</analysis>	
						<mapping>
							<update dispatch_type="continuous">
								<gesture_event  type="scale">
									<property ref="scale_dsx" target="scaleX"/>
									<property ref="scale_dsy" target="scaleY"/>
								</gesture_event>
							</update>
						</mapping>
					</Gesture>

		</Gesture_set>	
			
			
			
			
			
			
			
			
			
			
			
		<Gesture_set gesture_set_name="inertial-core-gestures">
		
				<Gesture id="n-drag-inertia" type="drag">
						<comment>The 'n-drag' gesture can be activated by any number of touch points. When a touch down is recognized on a touch object the position
						of the touch point is tracked. This change in the position of the touch point is mapped directly to the position of the touch object.</comment>
						<match>
							<action>
								<initial>
									<cluster point_number="0" point_number_min="1" point_number_max="10"/>
								</initial>
							</action>
						</match>	
						<analysis>
							<algorithm class="kinemetric" type="continuous">
								<library module="drag"/>
								<returns>
									<property id="drag_dx" result="dx"/>
									<property id="drag_dy" result="dy"/>
								</returns>
							</algorithm>
						</analysis>	
						<processing>
							<inertial_filter>
								<property ref="drag_dx" active="true" friction="0.9"/>
								<property ref="drag_dy" active="true" friction="0.9"/>
							</inertial_filter>
							<delta_filter>
								<property ref="drag_dx" active="true" delta_min="0.05" delta_max="500"/>
								<property ref="drag_dy" active="true" delta_min="0.05" delta_max="500"/>
							</delta_filter>
						</processing>
						<mapping>
							<update dispatch_type="continuous">
								<gesture_event type="drag">
									<property ref="drag_dx" target="x"/>
									<property ref="drag_dy" target="y"/>
								</gesture_event>
							</update>
						</mapping>
					</Gesture>
					
					<Gesture id="n-rotate-inertia" type="rotate">
						<match>
							<action>
								<initial>
									<cluster point_number="0" point_number_min="2" point_number_max="10"/>
								</initial>
							</action>
						</match>
						<analysis>
							<algorithm class="kinemetric" type="continuous">
								<library module="rotate"/>
								<returns>
									<property id="rotate_dtheta" result="dtheta"/>
								</returns>
							</algorithm>
						</analysis>	
						<processing>
							<inertial_filter>
								<property ref="rotate_dtheta" active="true" friction="0.9"/>
							</inertial_filter>
							<delta_filter>
								<property ref="rotate_dtheta" active="true" delta_min="0.01" delta_max="20"/>
							</delta_filter>
						</processing>
						<mapping>
							<update dispatch_type="continuous">
								<gesture_event type="rotate">
									<property ref="rotate_dtheta" target="rotate"/>
								</gesture_event>
							</update>
						</mapping>
					</Gesture>
					
					<Gesture id="n-scale-inertia" type="scale">
						<match>
							<action>
								<initial>
									<cluster point_number="0" point_number_min="2" point_number_max="10"/>
								</initial>
							</action>
						</match>
						<analysis>
							<algorithm class="kinemetric" type="continuous">
								<library module="scale"/>
								<returns>
									<property id="scale_dsx" result="ds"/>
									<property id="scale_dsy" result="ds"/>
								</returns>
							</algorithm>
						</analysis>	
						<processing>
							<inertial_filter>
								<property ref="scale_dsx" active="true" friction="0.9"/>
								<property ref="scale_dsy" active="true" friction="0.9"/>
							</inertial_filter>
							<delta_filter>
								<property ref="scale_dsx" active="true" delta_min="0.0005" delta_max="0.5"/>
								<property ref="scale_dsy" active="true" delta_min="0.0005" delta_max="0.5"/>
							</delta_filter>
						</processing>
						<mapping>
							<update dispatch_type="continuous">
								<gesture_event type="scale">
									<property ref="scale_dsx" target="scaleX"/>
									<property ref="scale_dsy" target="scaleY"/>
								</gesture_event>
							</update>
						</mapping>
					</Gesture>
					
					
			</Gesture_set>		
					
					
					
					
					
					
			<Gesture_set gesture_set_name="custom-core-gestures">		
					
			
						<Gesture id="n_what" type="drag">
							<comment>The 'n-what' gesture can be activated by any number of touch points. When a touch down is recognized on a touch object the position
							of the touch point is tracked. This change in the position of the touch point is mapped directly to the position of the touch object.</comment>
							<match>
								<action>
									<initial>
										<cluster point_number="0" point_number_min="1" point_number_max="10" translation_min="0"/>
									</initial>
								</action>
							</match>	
							<analysis>
								<algorithm class="kinemetric" type="continuous">
									<library module="drag"/>
									<returns>
										<property id="dx" result="dx"/>
										<property id="dy" result="dy"/>
									</returns>
								</algorithm>
							</analysis>	
							<mapping>
								<update dispatch_type="continuous">
									<gesture_event type="custom">
										<property ref="dx" target=""/>
										<property ref="dy" target=""/>
									</gesture_event>
								</update>
							</mapping>
						</Gesture>
						
						
						<Gesture id="n-drag-x" type="drag">
							<match>
								<action>
									<initial>
										<cluster point_number="0" point_number_min="1" point_number_max="5"/>
									</initial>
								</action>
							</match>	
							<analysis>
								<algorithm class="kinemetric" type="continuous">
									<library module="drag"/>
									<returns>
										<property id="drag_dx" result="dx"/>
									</returns>
								</algorithm>
							</analysis>	
							<mapping>
								<update dispatch_type="continuous">
									<gesture_event type="drag">
										<property ref="drag_dx" target="x"/>
									</gesture_event>
								</update>
							</mapping>
						</Gesture>
																			
						<Gesture id="1-finger-drag" type="drag">
							<comment></comment>
							<match>
								<action>
									<initial>
										<cluster point_number="1"/>
									</initial>
								</action>
							</match>	
							<analysis>
								<algorithm class="kinemetric" type="continuous">
									<library module="drag"/>
									<returns>
										<property id="drag_dx" result="dx"/>
										<property id="drag_dy" result="dy"/>
									</returns>
								</algorithm>
							</analysis>						
							<mapping>
								<update dispatch_type="continuous">
									<gesture_event type="drag">
										<property ref="drag_dx" target="x"/>
										<property ref="drag_dy" target="y"/>										
									</gesture_event>
								</update>
							</mapping>
						</Gesture>	
						
						<Gesture id="2-finger-drag" type="drag">
							<comment></comment>
							<match>
								<action>
									<initial>
										<cluster point_number="2"/>
									</initial>
								</action>
							</match>	
							<analysis>
								<algorithm class="kinemetric" type="continuous">
									<library module="drag"/>
									<returns>
										<property id="drag_dx" result="dx"/>
										<property id="drag_dy" result="dy"/>
									</returns>
								</algorithm>
							</analysis>						
							<mapping>
								<update dispatch_type="continuous">
									<gesture_event type="drag">
										<property ref="drag_dx" target="x"/>
										<property ref="drag_dy" target="y"/>										
									</gesture_event>
								</update>
							</mapping>
						</Gesture>	
						
						<Gesture id="4-finger-drag" type="drag">
							<match>
								<action>
									<initial>
										<cluster point_number="4" point_number_min="2" point_number_max="5"/>
									</initial>
								</action>
							</match>	
							<analysis>
								<algorithm>
									<library module="translate"/>
									<returns>
										<property id="drag_dx" result="dx"/>
										<property id="drag_dy" result="dy"/>
									</returns>
								</algorithm>
							</analysis>	
							<mapping>
								<update dispatch_type="continuous">
									<gesture_event type="drag">
										<property ref="drag_dx" target="x"/>
										<property ref="drag_dy" target="y"/>
									</gesture_event>
								</update>
							</mapping>
						</Gesture>
						
						
						<Gesture id="n-rotate-noise-filter" type="rotate">
							<match>
								<action>
									<initial>
										<cluster point_number="0" point_number_min="2" point_number_max="10"/>
									</initial>
								</action>
							</match>
							<analysis>
								<algorithm class="kinemetric" type="continuous">
									<library module="rotate"/>
									<returns>
										<property id="rotate_dtheta" result="dtheta"/>
									</returns>
								</algorithm>
							</analysis>	
							<processing>
								<mean_filter>
									<property ref="rotate_dtheta" active="true" frames="6"/>
								</mean_filter>
								<delta_filter>
									<property ref="rotate_dtheta" active="true" delta_min="0.01" delta_max="20"/>
								</delta_filter>
							</processing>
							<mapping>
								<update dispatch_type="continuous">
									<gesture_event  type="rotate">
										<property ref="rotate_dtheta" target="rotate"/>
									</gesture_event>
								</update>
							</mapping>
						</Gesture>
						
						<Gesture id="2-finger-rotate" type="rotate">
							<match>
								<action>
									<initial>
										<cluster point_number="2"/>
									</initial>
								</action>
							</match>
							<analysis>
								<algorithm>
									<library module="rotate"/>
									<returns>
										<property id="rotate_dtheta" result="dtheta"/>
									</returns>
								</algorithm>
							</analysis>	
							<mapping>
								<update dispatch_type="continuous">
									<gesture_event  type="rotate">
										<property ref="rotate_dtheta" target="rotate"/>
									</gesture_event>
								</update>
							</mapping>
						</Gesture>
						
						<Gesture id="3-finger-rotate" type="rotate">
							<match>
								<action>
									<initial>
										<cluster point_number="3"/>
									</initial>
								</action>
							</match>
							<analysis>
								<algorithm>
									<library module="rotate"/>
									<returns>
										<property id="rotate_dtheta" result="dtheta"/>
									</returns>
								</algorithm>
							</analysis>	
							<mapping>
								<update>
									<gesture_event  type="rotate">
										<property ref="rotate_dtheta" target="rotate"/>
									</gesture_event>
								</update>
							</mapping>
						</Gesture>
						
						
						<Gesture id="4-finger-rotate" type="rotate">
							<match>
								<action>
									<initial>
										<cluster point_number="4"/>
									</initial>
								</action>
							</match>
							<analysis>
								<algorithm>
									<library module="rotate"/>
									<returns>
										<property id="rotate_dtheta" result="dtheta"/>
									</returns>
								</algorithm>
							</analysis>	
							<mapping>
								<update dispatch_type="continuous">
									<gesture_event  type="rotate">
										<property ref="rotate_dtheta" target="rotate"/>
									</gesture_event>
								</update>
							</mapping>
						</Gesture>
			
						<Gesture id="2-finger-scale" type="scale">
							<match>
								<action>
									<initial>
										<cluster point_number="2"/>
									</initial>
								</action>
							</match>
							<analysis>
								<algorithm>
									<library module="scale"/>
									<returns>
										<property ref="scale_dsx" result="ds"/>
										<property ref="scale_dsy" result="ds"/>
									</returns>
								</algorithm>
							</analysis>	
							<mapping>
								<update>
									<gesture_event  type="scale">
										<property ref="scale_dsx" target="scaleX"/>
										<property ref="scale_dsy" target="scaleY"/>
									</gesture_event>
								</update>
							</mapping>
						</Gesture>
						
						<Gesture id="5-finger-scale" type="scale">
							<match>
								<action>
									<initial>
										<cluster point_number="5"/>
									</initial>
								</action>
							</match>
							<analysis>
								<algorithm>
									<library module="scale"/>
									<returns>
										<property ref="scale_dsx" result="ds"/>
										<property ref="scale_dsy" result="ds"/>
									</returns>
								</algorithm>
							</analysis>	
							<mapping>
								<update>
									<gesture_event  type="scale">
										<property ref="scale_dsx" target="scaleX"/>
										<property ref="scale_dsy" target="scaleY"/>
									</gesture_event>
								</update>
							</mapping>
						</Gesture>
								
					<Gesture id="1-finger-drag-inertia" type="drag">
						<match>
							<action>
								<initial>
									<cluster point_number="1"/>
								</initial>
							</action>
						</match>	
						<analysis>
							<algorithm class="kinemetric" type="continuous">
								<library module="drag"/>
								<returns>
									<property id="drag_dx" result="dx"/>
									<property id="drag_dy" result="dy"/>
								</returns>
							</algorithm>
						</analysis>	
						<processing>
							<inertial_filter>
								<property ref="drag_dx" active="true" friction="0.9"/>
								<property ref="drag_dy" active="true" friction="0.9"/>
							</inertial_filter>
							<delta_filter>
								<property ref="drag_dx" active="true" delta_min="0.05" delta_max="500"/>
								<property ref="drag_dy" active="true" delta_min="0.05" delta_max="500"/>
							</delta_filter>
						</processing>
						<mapping>
							<update dispatch_type="continuous">
								<gesture_event type="drag">
									<property ref="drag_dx" target="x"/>
									<property ref="drag_dy" target="y"/>
								</gesture_event>
							</update>
						</mapping>
					</Gesture>								
	
	</Gesture_set>
	
	
	
	
	
	
		
			
		
	<Gesture_set gesture_set_name="optimized-manipulations">
			
						<Gesture id="n-manipulate" type="manipulate">
							<match>
								<action>
									<initial>
										<cluster point_number="0" point_number_min="1" point_number_max="10"/>
									</initial>
								</action>
							</match>	
							<analysis>
								<algorithm class="kinemetric" type="continuous">
									<library module="manipulate"/>
									<returns>
										<property id="dx" result="dx"/>
										<property id="dy" result="dy"/>
										<property id="dsx" result="ds"/>
										<property id="dsy" result="ds"/>
										<property id="dtheta" result="dtheta"/>
									</returns>
								</algorithm>
							</analysis>	
							<processing>
								<multiply_filter>
									<property ref="dx" active="false"/>
									<property ref="dy" active="false"/>
									<property ref="dsx" active="false" func="linear" factor="0.0044"/>
									<property ref="dsy" active="false" func="linear" factor="0.0044"/>
									<property ref="dtheta" active="false"/>
								</multiply_filter>
							</processing>
							<mapping>
								<update dispatch_type="continuous">
									<gesture_event  type="manipulate">
										<property ref="dx" target="x"/>
										<property ref="dy" target="y"/>
										<property ref="dsx" target="scaleX"/>
										<property ref="dsy" target="scaleY"/>
										<property ref="dtheta" target="rotation"/>
									</gesture_event>
								</update>
							</mapping>
						</Gesture>
						
						
						
						<Gesture id="n-manipulate-inertia" type="manipulate">
							<match>
								<action>
									<initial>
										<cluster point_number="0" point_number_min="1" point_number_max="10"/>
									</initial>
								</action>
							</match>	
							<analysis>
								<algorithm class="kinemetric" type="continuous">
									<library module="manipulate"/>
									<returns>
										<property id="dx" result="dx"/>
										<property id="dy" result="dy"/>
										<property id="dsx" result="ds"/>
										<property id="dsy" result="ds"/>
										<property id="dtheta" result="dtheta"/>
									</returns>
								</algorithm>
							</analysis>	
							<processing>
								<inertial_filter>
									<property ref="dx" active="true" friction="0.9"/>
									<property ref="dy" active="true" friction="0.9"/>
									<property ref="dsx" active="true" friction="0.9"/>
									<property ref="dsy" active="true" friction="0.9"/>
									<property ref="dtheta" active="true" friction="0.9"/>
								</inertial_filter>
								<delta_filter>
									<property ref="dx" delta_filter="false" delta_min="0.01" delta_max="100"/>
									<property ref="dy" delta_filter="false" delta_min="0.01" delta_max="100"/>
									<property ref="dsx" delta_filter="false" delta_min="0.0001" delta_max="1"/>
									<property ref="dsy" delta_filter="false" delta_min="0.0001" delta_max="1"/>
									<property ref="dtheta" delta_filter="false" delta_min="0.01" delta_max="20"/>
								</delta_filter>
							</processing>
							<mapping>
								<update dispatch_type="continuous">
									<gesture_event  type="manipulate">
										<property ref="dx" target="x"/>
										<property ref="dy" target="y"/>
										<property ref="dsx" target="scaleX"/>
										<property ref="dsy" target="scaleY"/>
										<property ref="dtheta" target="rotation"/>
									</gesture_event>
								</update>
							</mapping>
						</Gesture>
						
						
						
						<Gesture id="n-manipulate-inertia-boundary" type="manipulate">
							<match>
								<action>
									<initial>
										<cluster point_number="0" point_number_min="1" point_number_max="10"/>
									</initial>
								</action>
							</match>	
							<analysis>
								<algorithm class="kinemetric" type="continuous">
									<library module="manipulate"/>
									<returns>
										<property id="dx" result="dx"/>
										<property id="dy" result="dy"/>
										<property id="dsx" result="ds"/>
										<property id="dsy" result="ds"/>
										<property id="dtheta" result="dtheta"/>
									</returns>
								</algorithm>
							</analysis>	
							<processing>
								<inertial_filter>
									<property ref="dx" active="true" friction="0.9"/>
									<property ref="dy" active="true" friction="0.9"/>
									<property ref="dsx" active="true" friction="0.9"/>
									<property ref="dsy" active="true" friction="0.9"/>
									<property ref="dtheta" active="true" friction="0.9"/>
								</inertial_filter>
								<delta_filter>
									<property ref="dx" active="true" delta_min="0.05" delta_max="50"/>
									<property ref="dy" active="true" delta_min="0.05" delta_max="50"/>
									<property ref="dsx" active="true" delta_min="0.0001" delta_max="0.5"/>
									<property ref="dsy" active="true" delta_min="0.0001" delta_max="0.5"/>
									<property ref="dtheta" active="false" delta_min="0.01" delta_max="20"/>
								</delta_filter>
								<boundary_filter>
									<property ref="dx" active="true" boundary_min="200" boundary_max="1000"/>
									<property ref="dy" active="true" boundary_min="200" boundary_max="600"/>
									<property ref="dsx" active="true" boundary_min="0.8" boundary_max="2.5"/>
									<property ref="dsy" active="true" boundary_min="0.8" boundary_max="2.5"/>
									<property ref="dtheta" active="false"/>
								</boundary_filter>
							</processing>
							<mapping>
								<update dispatch_type="continuous">
									<gesture_event  type="manipulate">
										<property ref="dx" target="x"/>
										<property ref="dy" target="y"/>
										<property ref="dsx" target="scaleX"/>
										<property ref="dsy" target="scaleY"/>
										<property ref="dtheta" target="rotation"/>
									</gesture_event>
								</update>
							</mapping>
						</Gesture>
			
		</Gesture_set>
			
		
		
		
		
		
		
		
		
		
		
		
		
		
		
			
		<Gesture_set gesture_set_name="conditonal-manipulations">
			
		
									<Gesture id="n-flick" type="flick">
										<comment>The 'n-flick' gesture can be activated by any number of touch points. When a touch down is recognized on a touch object, the velocity and 
										acceleration of the touch points are tracked. If acceleration of the cluster is above the acceleration threshold a flick event is dispatched.</comment>
										<match>
											<action>
												<initial>
													<cluster point_number="0" point_number_min="1" point_number_max="5" acceleration_min="0.5"/>
													<event touch_event="gwTouchEnd"/>
												</initial>
											</action>
										</match>
										<analysis>
											<algorithm class="kinemetric" type="continuous">
												<library module="flick"/>
												<variables>
													<property id="flick_dx" var="etm_ddx" return="etm_dx" var_min="2"/>
													<property id="flick_dy" var="etm_ddy" return="etm_dy" var_min="2"/>
												</variables>
												<returns>
													<property id="flick_dx" result="etm_dx"/>
													<property id="flick_dy" result="etm_dy"/>
												</returns>
											</algorithm>
										</analysis>	
										<mapping>
											<update dispatch_type="discrete" dispatch_mode="cluster_remove" dispatch_reset="cluster_remove">
												<gesture_event  type="flick">
													<property ref="flick_dx" target=""/>
													<property ref="flick_dy" target=""/>
												</gesture_event>
											</update>
										</mapping>
									</Gesture>
									
									
									<Gesture id="n-swipe" type="swipe">
										<comment>The 'n-swipe' gesture can be activated by any number of touch points. When a touch down is recognized on a touch object, the velocity and 
										acceleration of the touch points are tracked. If acceleration of the cluster is below the acceleration threshold a swipe event is dispatched.</comment>
										<match>
											<action>
												<initial>
													<cluster point_number="0" point_number_min="1" point_number_max="5" acceleration_max="0.5"/>
													<event touch_event="gwTouchEnd"/>
												</initial>
											</action>
										</match>
										<analysis>
											<algorithm class="kinemetric" type="continuous">
												<library module="swipe" />
												
												<variables>
													<property id="swipe_dx" var="etm_ddx" return="etm_dx" var_max="1"/>
													<property id="swipe_dy" var="etm_ddy" return="etm_dy" var_max="1"/>
												</variables>
												<returns>
													<property id="swipe_dx" result="etm_dx"/>
													<property id="swipe_dy" result="etm_dy"/>
												</returns>
											</algorithm>
										</analysis>	
										<mapping>
											<update dispatch_type="discrete" dispatch_mode="cluster_remove" dispatch_reset="cluster_remove">
												<gesture_event  type="swipe">
													<property ref="swipe_dx" target=""/>
													<property ref="swipe_dy" target=""/>
												</gesture_event>
											</update>
										</mapping>
									</Gesture>
									
									
									<Gesture id="n-scroll" type="scroll">
									<comment>The 'n-scroll' gesture can be activated by any number of touch points. When a touch down is recognized on a touch object, 
									the average velocity of the touch points are tracked. If velocity of the cluster is above the translation threshold a scroll event 
									is continuously dispatched with inertia.</comment>
										<match>
											<action>
												<initial>
													<cluster point_number="0" point_number_min="0" point_number_max="5" translation_min="1"/>
												</initial>
											</action>
										</match>
										<analysis>
											<algorithm class="kinemetric" type="continuous">
												<library module="scroll"/>
												<variables>
													<property id="scroll_dx" return="etm_dx" var="etm_dx" var_min="1"/>
													<property id="scroll_dy" return="etm_dy" var="etm_dy" var_min="1"/>
												</variables>
												<returns>
													<property id="scroll_dx" result="etm_dx"/>
													<property id="scroll_dy" result="etm_dy"/>
												</returns>
											</algorithm>
										</analysis>	
										<processing>
											<inertial_filter>
												<property ref="scroll_dx" active="true" friction="0.94"/>
												<property ref="scroll_dy" active="true" friction="0.94"/>
											</inertial_filter>
											<delta_filter>
												<property ref="scroll_dx" active="true" delta_min="0.5" delta_max="30"/>
												<property ref="scroll_dy" active="true" delta_min="0.5" delta_max="30"/>
											</delta_filter>
										</processing>
										<mapping>
											<update dispatch_type="continuous">
												<gesture_event  type="scroll">
													<property ref="scroll_dx" target=""/>
													<property ref="scroll_dy" target=""/>
												</gesture_event>
											</update>
										</mapping>
									</Gesture>
	</Gesture_set>
	
	
	
	
	
	
	
	
	
	
	
									
	<Gesture_set gesture_set_name="special-manipulations">		
									
									<Gesture id="3-finger-tilt" type="tilt">
										<match>
											<action>
												<initial>
													<cluster point_number="3" point_number_min="" point_number_max=""/>
												</initial>
											</action>
										</match>
										<analysis>
											<algorithm class="kinemetric" type="continuous">
												<library module="tilt"/>
												<variables>
													<property id="tilt_dx" return="dsx" var="dsx" var_min="0.01"/>
													<property id="tilt_dy" return="dsy" var="dsy" var_min="0.01"/>
												</variables>
												<returns>
													<property id="tilt_dx" result="dsx"/>
													<property id="tilt_dy" result="dsy"/>
												</returns>
											</algorithm>
										</analysis>	
										<mapping>
											<update dispatch_type="continuous">
												<gesture_event  type="tilt">
													<property ref="tilt_dx" target=""/>
													<property ref="tilt_dy" target=""/>
												</gesture_event>
											</update>
										</mapping>
									</Gesture>
									
									
									
									<Gesture id="1-finger-pivot" type="pivot">
										<match>
											<action>
												<initial>
													<cluster point_number="1" point_number_min="1" point_number_max="1"/>
												</initial>
											</action>
										</match>
										<analysis>
											<algorithm class="kinemetric" type="continuous">
												<library module="pivot"/>
												<returns>
													<property id="pivot_dtheta" result="pivot_dtheta"/>
												</returns>
											</algorithm>
										</analysis>	
										<processing>
											<delta_filter>
												<property ref="pivot_dtheta" active="false" delta_min="0.0001" delta_max="1"/>
											</delta_filter>
										</processing>
										<mapping>
											<update dispatch_type="continuous">
												<gesture_event  type="pivot">
													<property ref="pivot_dtheta" target="rotate"/>
												</gesture_event>
											</update>
										</mapping>
									</Gesture>
									
									<Gesture id="1-finger-pivot-inertia" type="pivot">
										<match>
											<action>
												<initial>
													<cluster point_number="1" point_number_min="1" point_number_max="1"/>
												</initial>
											</action>
										</match>
										<analysis>
											<algorithm class="kinemetric" type="continuous">
												<library module="pivot"/>
												<returns>
													<property id="pivot_dtheta" result="pivot_dtheta"/>
												</returns>
											</algorithm>
										</analysis>	
										<processing>
											<inertial_filter>
												<property ref="pivot_dtheta" active="true" friction="0.9"/>
											</inertial_filter>
											<delta_filter>
												<property ref="pivot_dtheta" active="false" delta_min="0.0001" delta_max="1"/>
											</delta_filter>
										</processing>
										<mapping>
											<update dispatch_type="continuous">
												<gesture_event  type="pivot">
													<property ref="pivot_dtheta" target="rotate"/>
												</gesture_event>
											</update>
										</mapping>
									</Gesture>
									
									
									
									<Gesture id="5-finger-orient" type="orient">
										<match>
											<action>
												<initial>
													<cluster point_number="5" point_number_min="" point_number_max=""/>
												</initial>
											</action>
										</match>
										<analysis>
											<algorithm class="kinemetric" type="continuous">
												<library module="orient"/>
												<returns>
													<property id="dx" result="orient_dx"/>
													<property id="dy" result="orient_dy"/>
													<property id="orient_hand" result="hand"/>
													<property id="orient_thumbID" result="thumbID"/>
												</returns>
											</algorithm>
										</analysis>	
										<mapping>
											<update dispatch_type="continuous">
												<gesture_event type="orient">
													<property ref="orient_dx"/>
													<property ref="orient_dy"/>
													<property ref="orient_hand"/>
													<property ref="orient_thumbID"/>
												</gesture_event>
											</update>
										</mapping>
									</Gesture>
			
	</Gesture_set>	
			
	
	
	
	
	
	

	
	<Gesture_set gesture_set_name="n-timeline">
						
						<Gesture id="n-hold" type="hold">
							<match>
								<action>
									<initial>
										<point event_duration_min="500" translation_max="2"/>
										<cluster point_number="0" point_number_min="1" point_number_max="5"/>
									</initial>
								</action>
							</match>	
							<analysis>
								<algorithm>
									<library module="hold"/>
									<returns>
										<property id="hold_x" result="x"/>
										<property id="hold_y" result="y"/>
										<property id="hold_n" result="n"/>
									</returns>
								</algorithm>
							</analysis>	
							<mapping>
								<update dispatch_type="discrete" dispatch_reset="cluster_remove">
									<gesture_event  type="hold">
										<property ref="hold_x"/>
										<property ref="hold_y"/>
										<property ref="hold_n"/>
									</gesture_event>
								</update>
							</mapping>
						</Gesture>
						
						<Gesture id="n-tap" type="tap">
							<match>
								<action>
									<initial>
										<point event_duration_max="200" translation_max="10"/>
										<cluster point_number="0"/>
										<event touch_event="gwTouchEnd"/>
									</initial>
								</action>
							</match>	
							<analysis>
								<algorithm class="temporalmetric" type="discrete">
									<library module="tap"/>
									<returns>
										<property id="tap_x" result="x"/>
										<property id="tap_y" result="y"/>
										<property id="tap_n" result="n"/>
									</returns>
								</algorithm>
							</analysis>	
							<mapping>
								<update dispatch_type="discrete" dispatch_mode="batch" dispatch_interval="200">
									<gesture_event  type="tap">
										<property ref="tap_x"/>
										<property ref="tap_y"/>
										<property ref="tap_n"/>
									</gesture_event>
								</update>
							</mapping>
						</Gesture>
						
						<Gesture id="n-double_tap" type="double_tap">
							<match>
								<action>
									<initial>
										<point event_duration_max="300" interevent_duration_max="300" translation_max="20"/>
										<cluster point_number="0"/>
										<event gesture_event="tap"/>
									</initial>
								</action>
							</match>	
							<analysis>
								<algorithm class="temporalmetric" type="discrete">
									<library module="double_tap"/>
									<returns>
										<property id="double_tap_x" result="x"/>
										<property id="double_tap_y" result="y"/>
										<property id="double_tap_n" result="n"/>
									</returns>
								</algorithm>
							</analysis>	
							<mapping>
								<update dispatch_type="discrete" dispatch_mode="batch" dispatch_interval="200">
									<gesture_event  type="double_tap">
										<property ref="double_tap_x"/>
										<property ref="double_tap_y"/>
										<property ref="double_tap_n"/>
									</gesture_event>
								</update>
							</mapping>
						</Gesture>
						
						<Gesture id="n-triple_tap" type="triple_tap">
							<match>
								<action>
									<initial>
										<point event_duration_max="300" interevent_duration_max="300" translation_max="20"/>
										<cluster point_number="0"/>
										<event gesture_event="tap" />
									</initial>
								</action>
							</match>	
							<analysis>
								<algorithm class="temporalmetric" type="discrete">
									<library module="triple_tap"/>
									<returns>
										<property id="triple_tap_x" result="x"/>
										<property id="triple_tap_y" result="y"/>
										<property id="triple_tap_n" result="n"/>
									</returns>
								</algorithm>
							</analysis>
							<mapping>
								<update dispatch_type="discrete" dispatch_mode="batch" dispatch_interval="200">
									<gesture_event  type="tripple_tap">
										<property ref="triple_tap_x"/>
										<property ref="triple_tap_y"/>
										<property ref="triple_tap_n"/>
									</gesture_event>
								</update>
							</mapping>
						</Gesture>

		</Gesture_set>
			
		
		
		
		
		
		
		<Gesture_set gesture_set_name="custom-timeline">
						
						<Gesture id="3-finger-hold" type="hold">
							<match>
								<action>
									<initial>
										<point event_duration_min="500" translation_max="2"/>
										<cluster point_number="3"/>
									</initial>
								</action>
							</match>	
							<analysis>
								<algorithm>
									<library module="hold"/>
									<returns>
										<property id="hold_x" result="x"/>
										<property id="hold_y" result="y"/>
										<property id="hold_n" result="n"/>
									</returns>
								</algorithm>
							</analysis>	
							<mapping>
								<update dispatch_type="discrete" dispatch_reset="cluster_remove">
									<gesture_event type="hold">
										<property ref="hold_x"/>
										<property ref="hold_y"/>
										<property ref="hold_n"/>
									</gesture_event>
								</update>
							</mapping>
						</Gesture>
						
						<Gesture id="3-finger-tap" type="tap">
							<match>
								<action>
									<initial>
										<point event_duration_max="200" translation_max="10"/>
										<cluster point_number="3"/>
										<event touch_event="gwTouchEnd"/>
									</initial>
								</action>
							</match>	
							<analysis>
								<algorithm class="temporalmetric" type="discrete">
									<library module="tap"/>
									<returns>
										<property id="tap_x" result="x"/>
										<property id="tap_y" result="y"/>
										<property id="tap_n" result="n"/>
									</returns>
								</algorithm>
							</analysis>	
							<mapping>
								<update dispatch_type="discrete">
									<gesture_event type="tap">
										<property ref="tap_x"/>
										<property ref="tap_y"/>
										<property ref="tap_n"/>
									</gesture_event>
								</update>
							</mapping>
						</Gesture>
						
						<Gesture id="1-finger-double_tap" type="double_tap">
							<match>
								<action>
									<initial>
										<point event_duration_max="300" interevent_duration_max="300" translation_max="20"/>
										<cluster point_number="1"/>
										<event gesture_event="tap"/>
									</initial>
								</action>
							</match>	
							<analysis>
								<algorithm class="temporalmetric" type="discrete">
									<library module="double_tap"/>
									<returns>
										<property id="double_tap_x" result="x"/>
										<property id="double_tap_y" result="y"/>
										<property id="double_tap_n" result="n"/>
									</returns>
								</algorithm>
							</analysis>	
							<mapping>
								<update dispatch_type="discrete" dispatch_mode="batch" dispatch_interval="200">
									<gesture_event type="double_tap">
										<property ref="double_tap_x"/>
										<property ref="double_tap_y"/>
										<property ref="double_tap_n"/>
									</gesture_event>
								</update>
							</mapping>
						</Gesture>
						
						<Gesture id="triple_tap" type="triple_tap">
							<match>
								<action>
									<initial>
										<point event_duration_max="300" interevent_duration_max="300" translation_max="20"/>
										<event gesture_event="tap"/>
									</initial>
								</action>
							</match>	
							<analysis>
								<algorithm class="temporalmetric" type="discrete">
									<library module="triple_tap"/>
									<returns>
										<property id="triple_tap_x" result="x"/>
										<property id="triple_tap_y" result="y"/>
										<property id="triple_tap_n" result="n"/>
									</returns>
								</algorithm>
							</analysis>
							<mapping>
								<update dispatch_type="discrete" dispatch_mode="batch" dispatch_interval="200">
									<gesture_event type="triple_tap">
										<property ref="triple_tap_x"/>
										<property ref="triple_tap_y"/>
										<property ref="triple_tap_n"/>
									</gesture_event>
								</update>
							</mapping>
						</Gesture>
						
						<Gesture id="1-finger-triple_tap" type="triple_tap">
							<match>
								<action>
									<initial>
										<point event_duration_max="300" interevent_duration_max="300" translation_max="20"/>
										<cluster point_number="1"/>
										<event gesture_event="tap"/>
									</initial>
								</action>
							</match>	
							<analysis>
								<algorithm class="temporalmetric" type="discrete">
									<library module="triple_tap"/>
									<returns>
										<property id="triple_tap_x" result="x"/>
										<property id="triple_tap_y" result="y"/>
										<property id="triple_tap_n" result="n"/>
									</returns>
								</algorithm>
							</analysis>
							<mapping>
								<update dispatch_type="discrete" dispatch_mode="batch" dispatch_interval="200">
									<gesture_event type="triple_tap">
										<property ref="triple_tap_x"/>
										<property ref="triple_tap_y"/>
										<property ref="triple_tap_n"/>
									</gesture_event>
								</update>
							</mapping>
						</Gesture>
			
		</Gesture_set>
	
	</Gestures>;

	}

}