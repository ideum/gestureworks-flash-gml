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
		
	<Gestures processing_rate="16.7" match_display_frame_rate="true">
	
	<Gesture_set gesture_set_name="n-manipulate">
		
			<Gesture id="n-drag" type="drag">
				<comment>The 'n-drag' gesture can be activated by any number of touch points. When a touch down is recognized on a touch object the position
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
							<property id="drag_dx" var="dx"/>
							<property id="drag_dy" var="dy"/>
						</returns>
					</algorithm>
				</analysis>	
				<processing>
					<noise_filter>
						<property ref="drag_dx" noise_filter="false" percent="80"/>
						<property ref="drag_dy" noise_filter="false" percent="80"/>
					</noise_filter>
					<inertial_filter>
						<property ref="drag_dx" release_inertia="true" friction="0.9"/>
						<property ref="drag_dy" release_inertia="true" friction="0.9"/>
					</inertial_filter>
					<delta_filter>
						<property ref="drag_dx" delta_threshold="false" delta_min="0.01" delta_max="500"/>
						<property ref="drag_dy" delta_threshold="false" delta_min="0.01" delta_max="500"/>
					</delta_filter>
				</processing>
				<mapping>
					<update dispatch_type="continuous">
						<gesture_event>
							<property ref="drag_dx" target="x"/>
							<property ref="drag_dy" target="y"/>
						</gesture_event>
					</update>
				</mapping>
			</Gesture>
			
			<Gesture id="n-drag-x" type="drag">
				<match>
					<action>
						<initial>
							<cluster point_number="0" point_number_min="1" point_number_max="5" translation_threshold="0"/>
						</initial>
					</action>
				</match>	
				<analysis>
					<algorithm class="kinemetric" type="continuous">
						<library module="drag"/>
						<returns>
							<property id="drag_dx" var="dx"/>
						</returns>
					</algorithm>
				</analysis>	
				<processing>
					<noise_filter>
						<property ref="drag_dx" noise_filter="false" percent="0"/>
					</noise_filter>
					<inertial_filter>
						<property ref="drag_dx" release_inertia="true" friction="0.996"/>
					</inertial_filter>
					<delta_filter>
						<property ref="drag_dx" delta_threshold="false" delta_min="0.01" delta_max="500"/>
					</delta_filter>
				</processing>
				<mapping>
					<update dispatch_type="continuous">
						<gesture_event>
							<property ref="drag_dx" target="x"/>
						</gesture_event>
					</update>
				</mapping>
			</Gesture>
			

			<Gesture id="n-drag-no-physics" type="drag">
				<comment>The 'n-drag' gesture can be activated by any number of touch points. When a touch down is recognized on a touch object the position
				of the touch point is tracked. This change in the position of the touch point is mapped directly to the position of the touch object.</comment>
				<match>
					<action>
						<initial>
							<cluster point_number="0" point_number_min="1" point_number_max="5" translation_min="0"/>
						</initial>
					</action>
				</match>	
				<analysis>
					<algorithm class="kinemetric" type="continuous">
						<library module="drag"/>
						<returns>
							<property id="drag_dx" var="dx"/>
							<property id="drag_dy" var="dy"/>
						</returns>
					</algorithm>
				</analysis>	
				<processing>
					<inertial_filter>
						<property ref="drag_dx" release_inertia="false"/>
						<property ref="drag_dy" release_inertia="false"/>
					</inertial_filter>
					<delta_filter>
						<property ref="drag_dx" delta_threshold="true" delta_min="0.01" delta_max="100"/>
						<property ref="drag_dy" delta_threshold="true" delta_min="0.01" delta_max="100"/>
					</delta_filter>
				</processing>
				<mapping>
					<update dispatch_type="continuous">
						<gesture_event>
							<property ref="drag_dx" target="x"/>
							<property ref="drag_dy" target="y"/>
						</gesture_event>
					</update>
				</mapping>
			</Gesture>			
			
			<Gesture id="2-finger-drag" type="drag">
				<match>
					<action>
						<initial>
							<cluster point_number="2" point_number_min="2" point_number_max="5" translation_threshold="0"/>
						</initial>
					</action>
				</match>	
				<analysis>
					<algorithm>
						<library module="translate"/>
						<returns>
							<property id="drag_dx" type="drag"/>
							<property id="drag_dy" type="drag"/>
						</returns>
					</algorithm>
				</analysis>	
				<processing>
					<noise_filter>
						<property ref="drag_dx" noise_filter="false" percent="0"/>
						<property ref="drag_dy" noise_filter="false" percent="0"/>
					</noise_filter>
					<inertial_filter>
						<property ref="drag_dx" touch_inertia="true" inertial_mass="3" release_inertia="true" friction="0.996"/>
						<property ref="drag_dy" touch_inertia="true" inertial_mass="3" release_inertia="true" friction="0.996"/>
					</inertial_filter>
				</processing>
				<mapping>
					<update dispatch_type="continuous">
						<gesture_event>
							<property ref="drag_dx" target="x" func="linear" factor="1" delta_threshold="true" delta_min="0.01" delta_max="100"/>
							<property ref="drag_dy" target="y" func="linear" factor="1" delta_threshold="true" delta_min="0.01" delta_max="100"/>
						</gesture_event>
					</update>
				</mapping>
			</Gesture>
			
			<Gesture id="1-finger-drag" type="drag">
				<match>
					<action>
						<initial>
							<cluster point_number="1" point_number_min="2" point_number_max="5" translation_threshold="0"/>
						</initial>
					</action>
				</match>	
				<analysis>
					<algorithm>
						<library module="translate"/>
						<returns>
							<property id="drag_dx" type="drag"/>
							<property id="drag_dy" type="drag"/>
						</returns>
					</algorithm>
				</analysis>	
				<processing>
					<noise_filter>
						<property ref="drag_dx" noise_filter="false" percent="0"/>
						<property ref="drag_dy" noise_filter="false" percent="0"/>
					</noise_filter>
					<inertial_filter>
						<property ref="drag_dx" touch_inertia="true" inertial_mass="3" release_inertia="true" friction="0.996"/>
						<property ref="drag_dy" touch_inertia="true" inertial_mass="3" release_inertia="true" friction="0.996"/>
					</inertial_filter>
				</processing>
				<mapping>
					<update dispatch_type="continuous">
						<gesture_event>
							<property ref="drag_dx" target="x" func="linear" factor="1" delta_threshold="true" delta_min="0.01" delta_max="100"/>
							<property ref="drag_dy" target="y" func="linear" factor="1" delta_threshold="true" delta_min="0.01" delta_max="100"/>
						</gesture_event>
					</update>
				</mapping>
			</Gesture>
			
			<Gesture id="4-finger-drag" type="drag">
				<match>
					<action>
						<initial>
							<cluster point_number="4" point_number_min="2" point_number_max="5" translation_threshold="0"/>
						</initial>
					</action>
				</match>	
				<analysis>
					<algorithm>
						<library module="translate"/>
						<returns>
							<property id="drag_dx" type="drag"/>
							<property id="drag_dy" type="drag"/>
						</returns>
					</algorithm>
				</analysis>	
				<processing>
					<noise_filter>
						<property ref="drag_dx" noise_filter="false" percent="0"/>
						<property ref="drag_dy" noise_filter="false" percent="0"/>
					</noise_filter>
					<inertial_filter>
						<property ref="drag_dx" touch_inertia="true" inertial_mass="3" release_inertia="true" friction="0.996"/>
						<property ref="drag_dy" touch_inertia="true" inertial_mass="3" release_inertia="true" friction="0.996"/>
					</inertial_filter>
				</processing>
				<mapping>
					<update dispatch_type="continuous">
						<gesture_event>
							<property ref="drag_dx" target="x" func="linear" factor="1" delta_threshold="true" delta_min="0.01" delta_max="100"/>
							<property ref="drag_dy" target="y" func="linear" factor="1" delta_threshold="true" delta_min="0.01" delta_max="100"/>
						</gesture_event>
					</update>
				</mapping>
			</Gesture>
			
			<Gesture id="n-rotate" type="rotate">
				<match>
					<action>
						<initial>
							<cluster point_number="0" point_number_min="2" point_number_max="10" rotatation_min="0"/>
						</initial>
					</action>
				</match>
				<analysis>
					<algorithm class="kinemetric" type="continuous">
						<library module="rotate"/>
						<returns>
							<property id="rotate_dtheta" var="dtheta"/>
						</returns>
					</algorithm>
				</analysis>	
				<processing>
					<noise_filter>
						<property ref="rotate_dtheta"  noise_filter="false" percent="80"/>
					</noise_filter>
					<inertial_filter>
						<property ref="rotate_dtheta" release_inertia="true" friction="0.9"/>
					</inertial_filter>
					<delta_filter>
						<property ref="rotate_dtheta" delta_threshold="false" delta_min="0.01" delta_max="20"/>
					</delta_filter>
				</processing>
				<mapping>
					<update dispatch_type="continuous">
						<gesture_event>
							<property ref="rotate_dtheta" target="rotate"/>
						</gesture_event>
					</update>
				</mapping>
			</Gesture>
			
			<Gesture id="2-finger-rotate" type="rotate">
				<match>
					<action>
						<initial>
							<cluster point_number="2" point_number_min="" point_number_max="" rotatation_threshold="0"/>
						</initial>
					</action>
				</match>
				<analysis>
					<algorithm>
						<library module="rotate"/>
						<returns>
							<property id="rotate_dtheta" var="dtheta"/>
						</returns>
					</algorithm>
				</analysis>	
				<processing>
					<noise_filter>
						<property ref="rotate_dtheta"  noise_filter="true" percent="100"/>
					</noise_filter>
					<inertial_filter>
						<property ref="rotate_dtheta" touch_inertia="true" inertial_mass="3" release_inertia="true" friction="0.996"/>
					</inertial_filter>
				</processing>
				<mapping>
					<update dispatch_type="continuous">
						<gesture_event>
							<property ref="rotate_dtheta" target="rotate" func="linear" factor="1" delta_threshold="true" delta_min="0.01" delta_max="10"/>
						</gesture_event>
					</update>
				</mapping>
			</Gesture>
			
			<Gesture id="3-finger-rotate" type="rotate">
				<match>
					<action>
						<initial>
							<cluster point_number="3" point_number_min="" point_number_max="" rotatation_threshold="0"/>
						</initial>
					</action>
				</match>
				<analysis>
					<algorithm>
						<library module="rotate"/>
						<returns>
							<property id="rotate_dtheta" var="dtheta"/>
						</returns>
					</algorithm>
				</analysis>	
				<processing>
					<noise_filter>
						<property ref="rotate_dtheta"  noise_filter="true" percent="100"/>
					</noise_filter>
					<inertial_filter>
						<property ref="rotate_dtheta" touch_inertia="true" inertial_mass="3" release_inertia="true" friction="0.996"/>
					</inertial_filter>
				</processing>
				<mapping>
					<update>
						<gesture_event>
							<property ref="rotate_dtheta" target="rotate" func="linear" factor="1" delta_threshold="true" delta_min="0.01" delta_max="10"/>
						</gesture_event>
					</update>
				</mapping>
			</Gesture>
			
			<Gesture id="4-finger-rotate" type="rotate">
				<match>
					<action>
						<initial>
							<cluster point_number="4" point_number_min="" point_number_max="" rotatation_threshold="0"/>
						</initial>
					</action>
				</match>
				<analysis>
					<algorithm>
						<library module="rotate"/>
						<returns>
							<property id="rotate_dtheta" var="dtheta"/>
						</returns>
					</algorithm>
				</analysis>	
				<processing>
					<noise_filter>
						<property ref="rotate_dtheta"  noise_filter="true" percent="100"/>
					</noise_filter>
					<inertial_filter>
						<property ref="rotate_dtheta" touch_inertia="true" inertial_mass="3" release_inertia="true" friction="0.996"/>
					</inertial_filter>
				</processing>
				<mapping>
					<update dispatch_type="continuous">
						<gesture_event>
							<property ref="rotate_dtheta" target="rotate" func="linear" factor="1" delta_threshold="true" delta_min="0.01" delta_max="10"/>
						</gesture_event>
					</update>
				</mapping>
			</Gesture>
			
			
			
			<Gesture id="n-scale" type="scale">
				<match>
					<action>
						<initial class="kinemetric" type="continuous">
							<cluster point_number="0" point_number_min="2" point_number_max="10" separation_min="0"/>
						</initial>
					</action>
				</match>
				<analysis>
					<algorithm>
						<library module="scale"/>
						<returns>
							<property id="scale_dsx" var="ds"/>
							<property id="scale_dsy" var="ds"/>
						</returns>
					</algorithm>
				</analysis>	
				<processing>
					<inertial_filter>
						<property ref="scale_dsx" release_inertia="true" friction="0.9"/>
						<property ref="scale_dsy" release_inertia="true" friction="0.9"/>
					</inertial_filter>
					<delta_filter>
						<property ref="scale_dsx" delta_threshold="false" delta_min="0.0001" delta_max="1"/>
						<property ref="scale_dsy" delta_threshold="false" delta_min="0.0001" delta_max="1"/>
					</delta_filter>
					<multiply_filter>
						<property ref="scale_dsx" multiply="false" func="linear" factor="0.0033"/>
						<property ref="scale_dsy" multiply="false" func="linear" factor="0.0033"/>
					</multiply_filter>
				</processing>
				<mapping>
					<update dispatch_type="continuous">
						<gesture_event>
							<property ref="scale_dsx" target="scaleX" func="linear" factor="0.0033"/>
							<property ref="scale_dsy" target="scaleY" func="linear" factor="0.0033"/>
						</gesture_event>
					</update>
				</mapping>
			</Gesture>
			
			<Gesture id="2-finger-scale" type="scale">
				<match>
					<action>
						<initial>
							<cluster point_number="2" point_number_min="" point_number_max="" separation_threshold="0"/>
						</initial>
					</action>
				</match>
				<analysis>
					<algorithm>
						<library module="scale"/>
						<returns>
							<property ref="scale_dsx" var="ds"/>
							<property ref="scale_dsy" var="ds"/>
						</returns>
					</algorithm>
				</analysis>	
				<processing>
					<noise_filter>
						<property ref="scale_dsx" noise_filter="false" percent="0"/>
						<property ref="scale_dsy" noise_filter="false" percent="0"/>
					</noise_filter>
					<inertial_filter>
						<property ref="scale_dsx" touch_inertia="true" inertial_mass="3" release_inertia="true" friction="0.99999"/>
						<property ref="scale_dsy" touch_inertia="true" inertial_mass="3" release_inertia="true" friction="0.99999"/>
					</inertial_filter>
				</processing>
				<mapping>
					<update>
						<gesture_event>
							<property ref="scale_dsx" target="scaleX" func="linear" factor="0.0033" delta_threshold="true" delta_min="0.0001" delta_max="1"/>
							<property ref="scale_dsy" target="scaleY" func="linear" factor="0.0033" delta_threshold="true" delta_min="0.0001" delta_max="1"/>
						</gesture_event>
					</update>
				</mapping>
			</Gesture>
			<Gesture id="5-finger-scale" type="scale">
				<match>
					<action>
						<initial>
							<cluster point_number="5" point_number_min="" point_number_max="" separation_threshold="0"/>
						</initial>
					</action>
				</match>
				<analysis>
					<algorithm>
						<library module="scale"/>
						<returns>
							<property ref="scale_dsx" var="ds"/>
							<property ref="scale_dsy" var="ds"/>
						</returns>
					</algorithm>
				</analysis>	
				<processing>
					<noise_filter>
						<property ref="scale_dsx" noise_filter="false" percent="0"/>
						<property ref="scale_dsy" noise_filter="false" percent="0"/>
					</noise_filter>
					<inertial_filter>
						<property ref="scale_dsx" touch_inertia="true" inertial_mass="3" release_inertia="true" friction="0.99999"/>
						<property ref="scale_dsy" touch_inertia="true" inertial_mass="3" release_inertia="true" friction="0.99999"/>
					</inertial_filter>
				</processing>
				<mapping>
					<update>
						<gesture_event>
							<property ref="scale_dsx" target="scaleX" func="linear" factor="0.0033" delta_threshold="true" delta_min="0.0001" delta_max="1"/>
							<property ref="scale_dsy" target="scaleY" func="linear" factor="0.0033" delta_threshold="true" delta_min="0.0001" delta_max="1"/>
						</gesture_event>
					</update>
				</mapping>
			</Gesture>
			
			
			
			
			
			
			<Gesture id="hold" type="hold">
				<match>
					<action>
						<initial>
							<point event_duration_threshold="500" translation_threshold="2"/>
							<cluster point_number="0" point_number_min="1" point_number_max="5"/>
						</initial>
					</action>
				</match>	
				<analysis>
					<algorithm class="kinemetric" type="continuous">
						<library module="hold"/>
						<returns>
							<property id="hold_x" var="x"/>
							<property id="hold_y" var="y"/>
							<property id="hold_n" var="n"/>
						</returns>
					</algorithm>
				</analysis>	
				<mapping>
					<update dispatch_type="discrete" reset="cluster_remove">
						<gesture_event>
							<property ref="hold_x"/>
							<property ref="hold_y"/>
							<property ref="hold_n"/>
						</gesture_event>
					</update>
				</mapping>
			</Gesture>
			
			
			<Gesture id="n-hold" type="hold">
				<match>
					<action>
						<initial>
							<point event_duration_threshold="500" translation_threshold="2"/>
							<cluster point_number="0" point_number_min="1" point_number_max="5"/>
						</initial>
					</action>
				</match>	
				<analysis>
					<algorithm>
						<library module="hold"/>
						<returns>
							<property id="hold_x" var="x"/>
							<property id="hold_y" var="y"/>
							<property id="hold_n" var="n"/>
						</returns>
					</algorithm>
				</analysis>	
				<mapping>
					<update dispatch_type="discrete" dispatch_reset="cluster_remove">
						<gesture_event>
							<property ref="hold_x"/>
							<property ref="hold_y"/>
							<property ref="hold_n"/>
						</gesture_event>
					</update>
				</mapping>
			</Gesture>
			
			<Gesture id="3-finger-hold" type="hold">
				<match>
					<action>
						<initial>
							<point event_duration_threshold="500" translation_threshold="2"/>
							<cluster point_number="3"/>
						</initial>
					</action>
				</match>	
				<analysis>
					<algorithm>
						<library module="hold"/>
						<returns>
							<property id="hold_x" var="x"/>
							<property id="hold_y" var="y"/>
							<property id="hold_n" var="n"/>
						</returns>
					</algorithm>
				</analysis>	
				<mapping>
					<update dispatch_type="discrete" dispatch_reset="cluster_remove">
						<gesture_event>
							<property ref="hold_x"/>
							<property ref="hold_y"/>
							<property ref="hold_n"/>
						</gesture_event>
					</update>
				</mapping>
			</Gesture>
			
			
			<Gesture id="tap" type="tap">
				<match>
					<action>
						<initial>
							<point event_duration_threshold="200" translation_threshold="10"/>
							<event touch_event="touchEnd"/>
						</initial>
					</action>
				</match>	
				<analysis>
					<algorithm class="temporalmetric" type="discrete">
						<library module="tap"/>
						<returns>
							<property id="tap_x" var="x"/>
							<property id="tap_y" var="y"/>
							<property id="tap_n" var="n"/>
						</returns>
					</algorithm>
				</analysis>	
				<mapping>
					<update dispatch_type="discrete" dispatch_mode="batch" dispatch_interval="200">
						<gesture_event>
							<property ref="tap_x"/>
							<property ref="tap_y"/>
							<property ref="tap_n"/>
						</gesture_event>
					</update>
				</mapping>
			</Gesture>
			
			<Gesture id="n-tap" type="tap">
				<match>
					<action>
						<initial>
							<point event_duration_threshold="200" translation_threshold="10"/>
							<cluster point_number="0"/>
							<event touch_event="touchEnd"/>
						</initial>
					</action>
				</match>	
				<analysis>
					<algorithm class="temporalmetric" type="discrete">
						<library module="tap"/>
						<returns>
							<property id="tap_x" var="x"/>
							<property id="tap_y" var="y"/>
							<property id="tap_n" var="n"/>
						</returns>
					</algorithm>
				</analysis>	
				<mapping>
					<update dispatch_type="discrete" dispatch_mode="batch" dispatch_interval="200">
						<gesture_event>
							<property ref="tap_x"/>
							<property ref="tap_y"/>
							<property ref="tap_n"/>
						</gesture_event>
					</update>
				</mapping>
			</Gesture>
			
			
			<Gesture id="3-finger-tap" type="tap">
				<match>
					<action>
						<initial>
							<point event_duration_threshold="200" translation_threshold="10"/>
							<cluster point_number="3"/>
							<event touch_event="touchEnd"/>
						</initial>
					</action>
				</match>	
				<analysis>
					<algorithm class="temporalmetric" type="discrete">
						<library module="tap"/>
						<returns>
							<property id="tap_x" var="x"/>
							<property id="tap_y" var="y"/>
							<property id="tap_n" var="n"/>
						</returns>
					</algorithm>
				</analysis>	
				<mapping>
					<update dispatch_type="discrete">
						<gesture_event>
							<property ref="tap_x"/>
							<property ref="tap_y"/>
							<property ref="tap_n"/>
						</gesture_event>
					</update>
				</mapping>
			</Gesture>
			
			<Gesture id="double_tap" type="double_tap">
				<match >
					<action type="discrete">
						<initial>
							<point event_duration_threshold="300" interevent_duration_threshold="300" translation_threshold="20"/>
							<event gesture_event="tap"/>
						</initial>
					</action>
				</match>	
				<analysis>
					<algorithm class="temporalmetric" type="discrete">
						<library module="double_tap"/>
						<returns>
							<property id="double_tap_x" var="x"/>
							<property id="double_tap_y" var="y"/>
							<property id="double_tap_n" var="n"/>
						</returns>
					</algorithm>
				</analysis>	
				<mapping>
					<update dispatch_type="discrete" dispatch_mode="batch" dispatch_interval="200">
						<gesture_event>
							<property ref="double_tap_x"/>
							<property ref="double_tap_y"/>
							<property ref="double_tap_n"/>
						</gesture_event>
					</update>
				</mapping>
			</Gesture>
			
			<Gesture id="n-double_tap" type="double_tap">
				<match>
					<action>
						<initial>
							<point event_duration_threshold="300" interevent_duration_threshold="300" translation_threshold="20"/>
							<cluster point_number="0"/>
							<event gesture_event="tap"/>
						</initial>
					</action>
				</match>	
				<analysis>
					<algorithm class="temporalmetric" type="discrete">
						<library module="double_tap"/>
						<returns>
							<property id="double_tap_x" var="x"/>
							<property id="double_tap_y" var="y"/>
							<property id="double_tap_n" var="n"/>
						</returns>
					</algorithm>
				</analysis>	
				<mapping>
					<update dispatch_type="discrete" dispatch_mode="batch" dispatch_interval="200">
						<gesture_event>
							<property ref="double_tap_x"/>
							<property ref="double_tap_y"/>
							<property ref="double_tap_n"/>
						</gesture_event>
					</update>
				</mapping>
			</Gesture>
			
			<Gesture id="1-finger-double_tap" type="double_tap">
				<match>
					<action>
						<initial>
							<point event_duration_threshold="300" interevent_duration_threshold="300" translation_threshold="20"/>
							<cluster point_number="1"/>
							<event gesture_event="tap"/>
						</initial>
					</action>
				</match>	
				<analysis>
					<algorithm class="temporalmetric" type="discrete">
						<library module="double_tap"/>
						<returns>
							<property id="double_tap_x" var="x"/>
							<property id="double_tap_y" var="y"/>
							<property id="double_tap_n" var="n"/>
						</returns>
					</algorithm>
				</analysis>	
				<mapping>
					<update dispatch_type="discrete" dispatch_mode="batch" dispatch_interval="200">
						<gesture_event>
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
							<point event_duration_threshold="300" interevent_duration_threshold="300" translation_threshold="20"/>
							<event gesture_event="tap"/>
						</initial>
					</action>
				</match>	
				<analysis>
					<algorithm class="temporalmetric" type="discrete">
						<library module="triple_tap"/>
						<returns>
							<property id="triple_tap_x" var="x"/>
							<property id="triple_tap_y" var="y"/>
							<property id="triple_tap_n" var="n"/>
						</returns>
					</algorithm>
				</analysis>
				<mapping>
					<update dispatch_type="discrete" dispatch_mode="batch" dispatch_interval="200">
						<gesture_event>
							<property ref="triple_tap_x"/>
							<property ref="triple_tap_y"/>
							<property ref="triple_tap_n"/>
						</gesture_event>
					</update>
				</mapping>
			</Gesture>
			
			<Gesture id="n-triple_tap" type="triple_tap">
				<match>
					<action>
						<initial>
							<point event_duration_threshold="300" interevent_duration_threshold="300" translation_threshold="20"/>
							<cluster point_number="0"/>
							<event gesture_event="tap" />
						</initial>
					</action>
				</match>	
				<analysis>
					<algorithm class="temporalmetric" type="discrete">
						<library module="triple_tap"/>
						<returns>
							<property id="triple_tap_x" var="x"/>
							<property id="triple_tap_y" var="y"/>
							<property id="triple_tap_n" var="n"/>
						</returns>
					</algorithm>
				</analysis>
				<mapping>
					<update dispatch_type="discrete" dispatch_mode="batch" dispatch_interval="200">
						<gesture_event>
							<property ref="triple_tap_x"/>
							<property ref="triple_tap_y"/>
						</gesture_event>
					</update>
				</mapping>
			</Gesture>
			
			<Gesture id="1-finger-triple_tap" type="triple_tap">
				<match>
					<action>
						<initial>
							<point event_duration_threshold="300" interevent_duration_threshold="300" translation_threshold="20"/>
							<cluster point_number="1"/>
							<event gesture_event="tap"/>
						</initial>
					</action>
				</match>	
				<analysis>
					<algorithm class="temporalmetric" type="discrete">
						<library module="triple_tap"/>
						<returns>
							<property id="triple_tap_x" var="x"/>
							<property id="triple_tap_y" var="y"/>
							<property id="triple_tap_n" var="n"/>
						</returns>
					</algorithm>
				</analysis>
				<mapping>
					<update dispatch_type="discrete" dispatch_mode="batch" dispatch_interval="200">
						<gesture_event>
							<property ref="triple_tap_x"/>
							<property ref="triple_tap_y"/>
						</gesture_event>
					</update>
				</mapping>
			</Gesture>
			
			
			
			<Gesture id="n-flick" type="flick">
				<comment>The 'n-flick' gesture can be activated by any number of touch points. When a touch down is recognized on a touch object, the velocity and 
				acceleration of the touch points are tracked. If acceleration of the cluster is above the acceleration threshold a flick event is dispatched.</comment>
				<match>
					<action>
						<initial>
							<cluster point_number="0" point_number_min="1" point_number_max="5" acceleration_min="0.5"/>
							<event touch_event="TouchEnd"/>
						</initial>
					</action>
				</match>
				<analysis>
					<algorithm class="kinemetric" type="continuous">
						<library module="flick"/>
						<returns>
							<property id="flick_dx" var="etm_dx"/>
							<property id="flick_dy" var="etm_dy"/>
						</returns>
					</algorithm>
				</analysis>	
				<processing>
					<inertial_filter>
						<property ref="flick_dx"/>
						<property ref="flick_dy"/>
					</inertial_filter>
				</processing>
				<mapping>
					<update dispatch_type="discrete" dispatch_mode="cluster_remove" dispatch_reset="cluster_remove">
						<gesture_event>
							<property ref="flick_dx" target=""/>
							<property ref="flick_dy" target=""/>
						</gesture_event>
					</update>
				</mapping>
			</Gesture>
			
			<Gesture id="flick" type="flick">
				<comment>The 'n-flick' gesture can be activated by any number of touch points. When a touch down is recognized on a touch object, the velocity and 
				acceleration of the touch points are tracked. If acceleration of the cluster is above the acceleration threshold a flick event is dispatched.</comment>
				<match>
					<action>
						<initial>
							<cluster point_number="0" point_number_min="1" point_number_max="5" acceleration_min="0.5"/>
							<event touch_event="TouchEnd"/>
						</initial>
					</action>
				</match>
				<analysis>
					<algorithm class="kinemetric" type="continuous">
						<library module="flick"/>
						<returns>
							<property id="flick_dx" var="etm_dx"/>
							<property id="flick_dy" var="etm_dy"/>
						</returns>
					</algorithm>
				</analysis>	
				<processing>
					<inertial_filter>
						<property ref="flick_dx"/>
						<property ref="flick_dy"/>
					</inertial_filter>
				</processing>
				<mapping>
					<update dispatch_type="discrete" reset="cluster_remove">
						<gesture_event>
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
							<event touch_event="TouchEnd"/>
						</initial>
					</action>
				</match>
				<analysis>
					<algorithm class="kinemetric" type="continuous">
						<library module="swipe" />
						<returns>
							<property id="swipe_dx" var="etm_dx"/>
							<property id="swipe_dy" var="etm_dy"/>
						</returns>
					</algorithm>
				</analysis>	
				<processing>
					<inertial_filter>
						<property ref="swipe_dx" release_inertia="false" friction="0.99999"/>
						<property ref="swipe_dy" release_inertia="false" friction="0.99999"/>
					</inertial_filter>
				</processing>
				<mapping>
					<update dispatch_type="discrete">
						<gesture_event>
							<property ref="swipe_dx" target=""/>
							<property ref="swipe_dy" target=""/>
						</gesture_event>
					</update>
				</mapping>
			</Gesture>
			
			<Gesture id="swipe" type="swipe">
				<comment>The 'n-swipe' gesture can be activated by any number of touch points. When a touch down is recognized on a touch object, the velocity and 
				acceleration of the touch points are tracked. If acceleration of the cluster is below the acceleration threshold a swipe event is dispatched.</comment>
				<match>
					<action>
						<initial>
							<cluster point_number="0" point_number_min="1" point_number_max="5" acceleration_max="0.01"/>
							<event touch_event="TouchEnd"/>
						</initial>
					</action>
				</match>
				<analysis>
					<algorithm class="kinemetric" type="continuous">
						<library module="swipe"/>
						<returns>
							<property id="swipe_dx" var="etm_dx"/>
							<property id="swipe_dy" var="etm_dy"/>
						</returns>
					</algorithm>
				</analysis>	
				<processing>
					<inertial_filter>
						<property ref="swipe_dx" release_inertia="false" friction="0.99999"/>
						<property ref="swipe_dy" release_inertia="false" friction="0.99999"/>
					</inertial_filter>
				</processing>
				<mapping>
					<update dispatch_type="discrete">
						<gesture_event>
							<property ref="swipe_dx" target=""/>
							<property ref="swipe_dy" target=""/>
						</gesture_event>
					</update>
				</mapping>
			</Gesture>
			
			<Gesture id="n-scroll" type="scroll">
			<comment>The 'n-scroll' gesture can be activated by any number of touch points. When a touch down is recognized on a touch object, the velocity and 
				acceleration of the touch points are tracked. If velocity of the cluster is above the translation threshold a scroll event is dispatched.</comment>
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
						<returns>
							<property id="scroll_dx" var="etm_dx"/>
							<property id="scroll_dy" var="etm_dy"/>
						</returns>
					</algorithm>
				</analysis>	
				<processing>
					<inertial_filter>
						<property ref="scroll_dx" release_inertia="true" friction="0.94"/>
						<property ref="scroll_dy" release_inertia="true" friction="0.94"/>
					</inertial_filter>
					<delta_filter>
						<property ref="scroll_dx" delta_threshold="false" delta_min="0" delta_max="1"/>
						<property ref="scroll_dy" delta_threshold="false" delta_min="0" delta_max="1"/>
					</delta_filter>
				</processing>
				<mapping>
					<update dispatch_type="continuous">
						<gesture_event>
							<property ref="scroll_dx" target=""/>
							<property ref="scroll_dy" target=""/>
						</gesture_event>
					</update>
				</mapping>
			</Gesture>
			
			<Gesture id="scroll" type="scroll">
			<comment>The 'n-scroll' gesture can be activated by any number of touch points. When a touch down is recognized on a touch object, the velocity and 
				acceleration of the touch points are tracked. If velocity of the cluster is above the translation threshold a scroll event is dispatched.</comment>
				<match>
					<action>
						<initial>
							<cluster point_number="0" point_number_min="0" point_number_max="5" translation_min="4"/>
						</initial>
					</action>
				</match>
				<analysis>
					<algorithm class="kinemetric" type="continuous">
						<library module="scroll"/>
						<returns>
							<property id="scroll_dx" var="etm_dx"/>
							<property id="scroll_dy" var="etm_dy"/>
						</returns>
					</algorithm>
				</analysis>	
				<processing>
					<inertial_filter>
						<property ref="scroll_dx" />
						<property ref="scroll_dy"/>
					</inertial_filter>
					<delta_filter>
						<property ref="scroll_dx" delta_threshold="false" delta_min="0" delta_max="1"/>
						<property ref="scroll_dy" delta_threshold="false" delta_min="0" delta_max="1"/>
					</delta_filter>
				</processing>
				<mapping>
					<update dispatch_type="continuous">
						<gesture_event>
							<property ref="scroll_dx" target=""/>
							<property ref="scroll_dy" target=""/>
						</gesture_event>
					</update>
				</mapping>
			</Gesture>
			
			
			<Gesture id="3-finger-tilt" type="tilt">
				<match>
					<action>
						<initial>
							<cluster point_number="3" point_number_min="" point_number_max="" separation_min="0.01"/>
						</initial>
					</action>
				</match>
				<analysis>
					<algorithm class="kinemetric" type="continuous">
						<library module="tilt"/>
						<returns>
							<property id="tilt_dx" var="dsx"/>
							<property id="tilt_dy" var="dsy"/>
						</returns>
					</algorithm>
				</analysis>	
				<processing>
					<noise_filter>
						<property ref="tilt_dx" noise_filter="false" percent="0"/>
						<property ref="tilt_dy" noise_filter="false" percent="0"/>
					</noise_filter>
					<inertial_filter>
						<property ref="tilt_dx" release_inertia="false" friction="0"/>
						<property ref="tilt_dy" release_inertia="false" friction="0"/>
					</inertial_filter>
					<delta_filter>
						<property ref="tilt_dx" delta_threshold="false" delta_min="0.0001" delta_max="1"/>
						<property ref="tilt_dy" delta_threshold="false" delta_min="0.0001" delta_max="1"/>
					</delta_filter>
				</processing>
				<mapping>
					<update dispatch_type="continuous">
						<gesture_event>
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
							<cluster point_number="1" point_number_min="1" point_number_max="1" rotation_min="0.001"/>
						</initial>
					</action>
				</match>
				<analysis>
					<algorithm class="kinemetric" type="continuous">
						<library module="pivot"/>
						<returns>
							<property id="pivot_dtheta" var="pivot_dtheta"/>
						</returns>
					</algorithm>
				</analysis>	
				<processing>
					<inertial_filter>
						<property ref="pivot_dtheta" release_inertia="false" friction="0.996"/>
					</inertial_filter>
					<delta_filter>
						<property ref="pivot_dtheta" delta_threshold="false" delta_min="0.0001" delta_max="1"/>
					</delta_filter>
					<multiply_filter>
						<property ref="pivot_dtheta" multiply="false" func="linear" factor="0.00002"/>
					</multiply_filter>
				</processing>
				<mapping>
					<update dispatch_type="continuous">
						<gesture_event>
							<property ref="pivot_dtheta" target="rotate" func="linear" factor="0.00002" />
						</gesture_event>
					</update>
				</mapping>
			</Gesture>
			
			<Gesture id="5-finger-orient" type="orient">
				<match>
					<action>
						<initial>
							<cluster point_number="5" point_number_min="" point_number_max="" rotation_min="0.01"/>
						</initial>
					</action>
				</match>
				<analysis>
					<algorithm class="kinemetric" type="continuous">
						<library module="orient"/>
						<returns>
							<property id="dx" var="orient_dx"/>
							<property id="dy" var="orient_dy"/>
							<property id="orient_hand" var="hand"/>
							<property id="orient_thumbID" var="thumbID"/>
						</returns>
					</algorithm>
				</analysis>	
				<mapping>
					<update dispatch_type="continuous">
						<gesture_event>
							<property ref="orient_dx"/>
							<property ref="orient_dy"/>
							<property ref="orient_hand"/>
							<property ref="orient_thumbID"/>
						</gesture_event>
					</update>
				</mapping>
			</Gesture>
			
			
			<Gesture id="1-finger-stroke" type="stroke">
				<match>
					<action>
						<initial>
							<point event_duration_threshold="200" path_svg="M 136 74L 143 69L 172 59L 113 106L 118 93L 124 83L 130 75L 138 68L 151 63L 164 61" path_pts="(x=0.5233415233415233, y=0.40786240786240785),(x=0.4619164619164619, y=0.4103194103194103),(x=0.4054054054054054, y=0.43734643734643736),(x=0.3587223587223587, y=0.48157248157248156),(x=0.343980343980344, y=0.542997542997543),(x=0.36363636363636365, y=0.601965601965602),(x=0.4054054054054054, y=0.6461916461916462),(x=0.45945945945945943, y=0.6756756756756757),(x=0.5208845208845209, y=0.683046683046683),(x=0.5823095823095823, y=0.6756756756756757),(x=0.6388206388206388, y=0.6486486486486487),(x=0.687960687960688, y=0.6093366093366093),(x=0.7199017199017199, y=0.5528255528255528),(x=0.742014742014742, y=0.49385749385749383),(x=0.7469287469287469, y=0.4324324324324324),(x=0.7444717444717445, y=0.371007371007371),(x=0.7321867321867321, y=0.3095823095823096),(x=0.7125307125307125, y=0.24815724815724816),(x=0.6855036855036855, y=0.19164619164619165),(x=0.6486486486486487, y=0.14004914004914004),(x=0.6044226044226044, y=0.09090909090909091),(x=0.5528255528255528, y=0.051597051597051594),(x=0.4963144963144963, y=0.02457002457002457),(x=0.4348894348894349, y=0.007371007371007371),(x=0.37346437346437344, y=0),(x=0.312039312039312, y=0.004914004914004914),(x=0.25061425061425063, y=0.02457002457002457),(x=0.19656019656019655, y=0.05651105651105651),(x=0.14987714987714987, y=0.09828009828009827),(x=0.11056511056511056, y=0.14742014742014742),(x=0.07616707616707616, y=0.19901719901719903),(x=0.04668304668304668, y=0.25307125307125306),(x=0.02457002457002457, y=0.312039312039312),(x=0.009828009828009828, y=0.37346437346437344),(x=0.002457002457002457, y=0.4348894348894349),(x=0, y=0.4963144963144963),(x=0.002457002457002457, y=0.5577395577395577),(x=0.014742014742014743, y=0.6191646191646192),(x=0.036855036855036855, y=0.6781326781326781),(x=0.06388206388206388, y=0.7346437346437347),(x=0.09582309582309582, y=0.7862407862407862),(x=0.13513513513513514, y=0.8304668304668305),(x=0.18181818181818182, y=0.8722358722358722),(x=0.23095823095823095, y=0.9066339066339066),(x=0.28255528255528256, y=0.941031941031941),(x=0.33906633906633904, y=0.9656019656019655),(x=0.39803439803439805, y=0.9852579852579852),(x=0.45945945945945943, y=0.995085995085995),(x=0.5208845208845209, y=1),(x=0.5823095823095823, y=0.995085995085995)"/>
							<cluster point_number="1"/>
							<event touchEvent="TouchEnd"/>
						</initial>
					</action>
				</match>	
				<analysis>
					<algorithm class="vectormetric" type="continuous">
						<library module="stroke"/>
						<returns>
							<property id="stroke_x" type="stroke" var=""/>
							<property id="stroke_y" type="stroke" var=""/>
							<property id="stroke_prob" type="stroke" var=""/>
						</returns>
					</algorithm>
				</analysis>	
				<mapping>
					<update dispatch_type="discrete">
						<gesture_event>
							<property ref="stroke_x"/>
							<property ref="stroke_y"/>
							<property ref="stroke_prob"/>
						</gesture_event>
					</update>
				</mapping>
			</Gesture>
			
			
			
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
							<property id="dx" var="dx"/>
							<property id="dy" var="dy"/>
							<property id="dsx" var="ds"/>
							<property id="dsy" var="ds"/>
							<property id="dtheta" var="dtheta"/>
						</returns>
					</algorithm>
				</analysis>	
				<processing>
					<noise_filter>
						<property ref="dx" noise_filter="false" percent="80"/>
						<property ref="dy" noise_filter="false" percent="80"/>
						<property ref="dsx" noise_filter="false" percent="80"/>
						<property ref="dsy" noise_filter="false" percent="80"/>
						<property ref="dtheta" noise_filter="false" percent="100"/>
					</noise_filter>
					<inertial_filter>
						<property ref="dx" release_inertia="true" friction="0.994"/>
						<property ref="dy" release_inertia="true" friction="0.994"/>
						<property ref="dsx" release_inertia="true" friction="0.994"/>
						<property ref="dsy" release_inertia="true" friction="0.994"/>
						<property ref="dtheta" release_inertia="true" friction="0.994"/>
					</inertial_filter>
					<delta_filter>
						<property ref="dx" delta_threshold="false" delta_min="0.01" delta_max="100"/>
						<property ref="dy" delta_threshold="false" delta_min="0.01" delta_max="100"/>
						<property ref="dsx" delta_threshold="true" delta_min="0.0001" delta_max="1"/>
						<property ref="dsy" delta_threshold="true" delta_min="0.0001" delta_max="1"/>
						<property ref="dtheta" delta_threshold="true" delta_min="0.01" delta_max="20"/>
					</delta_filter>
				</processing>
				<mapping>
					<update dispatch_type="continuous">
						<gesture_event>
							<property ref="dx" target="x"/>
							<property ref="dy" target="y"/>
							<property ref="dsx" target="scaleX" func="linear" factor="0.0033"/>
							<property ref="dsy" target="scaleY" func="linear" factor="0.0033"/>
							<property ref="dtheta" target="rotation"/>
						</gesture_event>
					</update>
				</mapping>
			</Gesture>
			
		</Gesture_set>
	</Gestures>;

	}

}