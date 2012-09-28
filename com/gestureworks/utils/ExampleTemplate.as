package com.gestureworks.utils
{
	import com.gestureworks.cml.element.GraphicElement;
	import com.gestureworks.cml.element.TextElement;
	import flash.display.Sprite;
	import flash.events.Event;
	
	public class ExampleTemplate extends Sprite 
	{
		
		public function Main():void 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
			createHeader();
		}
		
		public function createHeader():void {
			var backPane:GraphicElement = new GraphicElement();
			
			backPane.shape = "rectangle";
			
			backPane.width = 450;
			backPane.height = 700;
			
			backPane.color = 0x111111;
			backPane.lineStroke = 0;
			
			backPane.y = 10;
			
			addChild(backPane);
		}
		
		public function createTitle(value:String):void {
			var title:TextElement = new TextElement();
			
			title.text = value;
			
			title.x = 30;
			title.y = 30;
			title.fontSize = 20;
			title.width = 400;
			title.color = 0xffffff;
			title.selectable = false;
			title.font = "OpenSansBold";
			
			addChild(title);
		}
		
		public function createDesc(value:String):void {
			var desc:TextElement = new TextElement();
			
			desc.htmlText = value;
			
			desc.x = 30;
			desc.y = 60;
			
			desc.color = 0xffffff;
			desc.fontSize = 16;
			desc.width = 400;
			desc.height = 1000;
			desc.wordWrap = true;
			desc.multiline = true;
			desc.selectable = false;
			desc.textAlign = "justify";
			desc.font = "OpenSansRegular";
			desc.leading = -4.5;
			
			addChild(desc);
		}
	}
	
}