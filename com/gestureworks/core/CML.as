////////////////////////////////////////////////////////////////////////////////
//
//  IDEUM
//  Copyright 2011-2012 Ideum
//  All Rights Reserved.
//
//  GestureWorks
//
//  File:    CML.as
//  Authors:  Ideum
//             
//  NOTICE: Ideum permits you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

package com.gestureworks.core
{
	
	public class CML
	{
		public static var Objects:XML;
	/* =
	
	   <GestureWorksApplication>
	
	   <StageKit>
	   <BackgroundKit type="" src="" fill_type="" fill_colorA="" fill_colorB="" width="" height="" radius=""/>
	   <SplashKit>
	   <Logo src="" width="" height="" x="" y="" scale="" rotation=""/>
	   <Preloader type="" src="" fill_type="" fill_colorA="" fill_colorB="" width="" height="" radius=""/>
	   <Version content=""/>
	   </SplashKit>
	   </StageKit>
	
	   <CanvasKit>
	
	   <ComponentKit>
	   <TouchContainer id="touchContainer" componentId ="0" width="300" height="300" debugStyle="css_Debug_Style_1">
	   <Graphic id="objectBack" width="100%" height="100%" fillColor1="0x009966"/>
	   <ImageElement id="image" src="library/assets/background.png" width="90" height="90" x="20" y="20">
	
	   <GestureEvents>
	   <Gesture id="doubleTap"/>
	   </GestureEvents>
	   </ImageElement>
	   <ButtonElement id="btn" label="hello" fillColor1="0x009966" width="120" height="30" bottom="30" horizontalCenter="0" alpha=".6" lineColor="0xFFFFFF" lineAlpha=".6" lineStroke="2" cornerRadius="15" labelAlign="left" labelSize="15">
	   <GestureEvents>
	   <Gesture id="drag"/>
	   <Gesture id="rotation"/>
	   <Gesture id="scale"/>
	   <GestureSet id="object_manipulation"/>
	   </GestureEvents>
	   <ObjectEvents>
	   <Event id="Complete"/>
	   </ObjectEvents>
	   </ButtonElement>
	   </TouchContainer>
	   </ComponentKit>
	
	
	   <ComponentKit>
	   <TouchContainer id="touchContainer" componentId ="1" width="300" height="300" debugStyle="css_Debug_Style_1">
	   <Graphic id="objectBack" width="100%" height="100%" fillColor1="0x009966"/>
	   <ImageElement id="image" src="library/assets/background.png" width="90" height="90" x="20" y="20">
	
	   <GestureEvents>
	   <Gesture id="doubleTap"/>
	   </GestureEvents>
	   </ImageElement>
	   <ButtonElement id="btn" label="hello" fillColor1="0x009966" width="120" height="30" bottom="30" horizontalCenter="0" alpha=".6" lineColor="0xFFFFFF" lineAlpha=".6" lineStroke="2" cornerRadius="15" labelAlign="left" labelSize="15">
	   <GestureEvents>
	   <Gesture id="drag"/>
	   <Gesture id="rotation"/>
	   <Gesture id="scale"/>
	   </GestureEvents>
	   <ObjectEvents>
	   <Event id="Complete"/>
	   </ObjectEvents>
	   </ButtonElement>
	   </TouchContainer>
	   </ComponentKit>
	
	   <ComponentKit>
	   </ComponentKit>
	
	   <object id="library object">
	   </object>
	   </CanvasKit>
	
	   <DebugKit>
	   <DebugLayer id="" type = "point_shapes" displayOn="true" theme = "" shape = "ring" width = "" height = "" radius = "15" stroke_color = "0x9BD6EA" stroke_thickness = "8" stroke_alpha = "0.9" fill_color = "0x9BD6EA"  fill_alpha = "0.9" fill_type = "solid" filter = "blur"/>
	   <DebugLayer id = "" type = "point_vectors"  displayOn="false" theme = "" shape = "line" width = "" height = "" radius = "15" stroke_color = "0x9BD6EA" stroke_thickness = "2" stroke_alpha = "0.9" fill_color = "0x9BD6EA"  fill_alpha = "0.9" fill_type = "solid" filter = "blur"/>
	
	   <DebugLayer id = "" type = "cluster_circle" displayOn="false"  theme = "" shape = "ring" stroke_color = "0x79BBD8" stroke_thickness = "20" stroke_alpha = "0.9"/>
	   <DebugLayer id = "" type = "cluster_box" displayOn="false"  theme = "" shape = "ring" stroke_color = "0x79BBD8" stroke_thickness = "4" stroke_alpha = "0.9"/>
	   <DebugLayer id = "" type = "cluster_center" displayOn="false"  theme = "" shape = "circle" radius ="20" stroke_color = "0x9BD6EA" stroke_thickness = "4" stroke_alpha = "0.9"/>
	   <DebugLayer id = "" type = "cluster_web" displayOn="false"  theme = "" line_type="solid" shape = "starweb" stroke_color = "0x79BBD8" stroke_thickness = "4" stroke_alpha = "0.9"/>
	   <DebugLayer id = "" type = "cluster_rotation" displayOn="false"  shape = "segment" percent ="0.7" a_stroke_color = "0x4B7BCC" a_stroke_thickness = "2" a_stroke_alpha = "0.85" a_fill_color = "0x9BD6EA" a_fill_alpha = "0.3" b_stroke_color = "0xFF0000" b_stroke_thickness = "2" b_stroke_alpha = "0.5"  b_fill_color = "0xFF0000" b_fill_alpha = "0.3"/>
	   <DebugLayer id = "" type = "cluster_orientation" displayOn="false"   shape = "" radius = "100" stroke_color = "0xFF0000" stroke_thickness = "10" stroke_alpha = "0.5" />
	   <DebugLayer id = "" type = "cluster_vector_data" displayOn="false"  theme = "" line_type="solid" indicators="true" radius ="50" stroke_color = "0x9BD6EA" stroke_thickness = "4" stroke_alpha = "0.9" fill_color = "0x9BD6EA"  fill_alpha = "0.1" text_color = "0xFFFFFF" text_size = "12" text_alpha = "1" />
	   <DebugLayer id = "" type = "cluster_data_list" displayOn="false"  theme = "" indicators = "true" width = "" height = "" radius = "10" stroke_color = "0x9BD6EA" stroke_thickness = "4" stroke_alpha = "0.9" fill_color = "0x9BD6EA"  fill_alpha = "0.1" text_color = "0x9BD6EA" text_size = "14" text_alpha = "1" />
	   <DebugLayer id = "" type="cluster_line_chart" displayOn="false"  theme = "" indicators = "true" width = "" height = "" radius = "10" stroke_color = "0x9BD6EA" stroke_thickness = "4" stroke_alpha = "0.9" fill_color = "0x9BD6EA"  fill_alpha = "0.1" text_color = "0x9BD6EA" text_size = "14" text_alpha = "1"/>
	   <DebugLayer id = "" type="cluster_histogram_chart" displayOn="false"  theme = "" indicators = "true" width = "" height = "" radius = "10" stroke_color = "0x9BD6EA" stroke_thickness = "4" stroke_alpha = "0.9" fill_color = "0x9BD6EA"  fill_alpha = "0.1" text_color = "0x9BD6EA" text_size = "14" text_alpha = "1"/>
	
	   <DebugLayer id="" type="gesture_history"/>
	   <DebugLayer id="" type="gesture_timeline"/>
	   <DebugLayer id="" type="gesture_event_text"/>
	   <DebugLayer id="" type="gesture_event_icon"/>
	
	   < DebugLayer id = "" type = "touchobject_data_list" displayOn = "false"  theme = "" indicators = "true" width = "" height = "" radius = "20" stroke_color = "0x9BD6EA" stroke_thickness = "4" stroke_alpha = "0.9" fill_color = "0x9BD6EA"  fill_alpha = "0.1" text_color = "0x9BD6EA" text_size = "14" text_alpha = "1"/>
	   < DebugLayer id = "" type = "touchobject_transform" displayOn = "false"  theme = "" indicators = "true" width = "" height = "" radius = "10" stroke_color = "0x9BD6EA" stroke_thickness = "4" stroke_alpha = "0.9" fill_color = "0x9BD6EA"  fill_alpha = "0.1" text_color = "0x9BD6EA" text_size = "14" text_alpha = "1" />
	   < DebugLayer id = "" type= "touchobject_pivot" displayOn = "false"  theme = "" indicators = "true" width = "" height = "" radius = "10" stroke_color = "0x9BD6EA" stroke_thickness = "4" stroke_alpha = "0.9" fill_color = "0x9BD6EA"  fill_alpha = "0.1" text_color = "0x9BD6EA" text_size = "14" text_alpha = "1"/>
	   <DebugLayer id="" type="touchobject_history"/>
	   </DebugKit>
	
	 </GestureWorksApplication>;*/
	}
}