package fj1.modules.mainUI.hintAreas
{
	import fj1.common.staticdata.ChatConst;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextFormat;
	import tempest.ui.UIStyle;
	import tempest.ui.components.textFields.TScrollText;

	public class SystemMsgArea extends TScrollText
	{
		private var _parent:DisplayObjectContainer;

		public function SystemMsgArea(parent:DisplayObjectContainer, constraints:Object)
		{
			_parent = parent;
			var sprite:Sprite = new Sprite();
			sprite.graphics.beginFill(0x000000);
			sprite.graphics.drawRect(0, 0, 10, 28);
			sprite.graphics.endFill();
			sprite.alpha = 0.5;
			super(constraints, sprite);
			_padding = 5;
			var textFormat:TextFormat = new TextFormat(UIStyle.fontName, 14, UIStyle.NORMAL_TEXT, true);
			textFormat.color = ChatConst.channelConfig[ChatConst.CHANNEL_NOTICE].color2;
			defaultTextFormat = textFormat;
			this.textFilters = [UIStyle.textBoundFilter];
			this.addEventListener(Event.COMPLETE, onComplete);
			this.visible = false;
		}

		private function onComplete(event:Event):void
		{
			this.visible = false;
//			if (_parent)
//			{
//				_parent.removeChild(this);
//			}
		}

		public function show(str:String):void
		{
			this.visible = true;
//			if (_parent && !this.parent)
//			{
//				_parent.addChild(this);
//			}
			setText(str);
		}
	}
}
