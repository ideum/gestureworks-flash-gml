package com.gestureworks.utils
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	public class ExampleTemplate extends Sprite 
	{		
		public function ExampleTemplate():void 
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
			
			var backPane:Sprite = new Sprite();
			
			backPane.graphics.beginFill(0x111111, 1);
			backPane.graphics.lineStyle(10);
			backPane.graphics.drawRect(0, 0, 450, 700);
			backPane.graphics.endFill();
			
			backPane.y = 10;
			
			addChild(backPane);
		}
		
		public function createTitle(value:String):void {
			var title:TextField = new TextField();
			
			title.text = value;
			title.embedFonts = true;
			
			var titleFmt:TextFormat = new TextFormat();
			titleFmt.font = "OpenSansBold";
			titleFmt.bold = true;
			titleFmt.size = 20;
			titleFmt.color = 0xffffff;
			
			title.setTextFormat(titleFmt);
			
			title.x = 30;
			title.y = 30;
			title.width = 400;
			title.selectable = false;
			
			addChild(title);
		}
		
		public function createDesc(value:String):void {
			var desc:TextField = new TextField();
			desc.embedFonts = true;
			desc.multiline = true;
			desc.wordWrap = true;
			desc.htmlText = value;
			
			desc.x = 30;
			desc.y = 60;
			
			var descFmt:TextFormat = new TextFormat();
			
			descFmt.color = 0xffffff;
			descFmt.size = 16;
			
			desc.selectable = false;
			descFmt.align = TextFormatAlign.JUSTIFY;
			descFmt.font = "OpenSansRegular";
			descFmt.leading = -4.5;
			
			desc.width = 400;
			desc.height = 1000;
			
			desc.setTextFormat(descFmt);
			
			addChild(desc);
		}
	}
	
}