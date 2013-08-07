package fj1.modules.mainUI.hintAreas
{

	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	
	import fj1.common.ui.factories.AutoCompleteTextFieldFactory;
	
	import tempest.common.time.vo.TimerData;
	import tempest.manager.TimerManager;
	import tempest.utils.HtmlUtil;

	public class MainUIFlyTextArea2 extends BaseFlyObjectArea
	{
		protected var _textBuffer:Vector.<String>;
		private var addTimer:TimerData;

		private var _textFieldFactory:AutoCompleteTextFieldFactory;

		public function MainUIFlyTextArea2(parent:DisplayObjectContainer, constraints:Object, width:Number, height:Number, maxLen:int, textFieldFactory:AutoCompleteTextFieldFactory)
		{
			_textBuffer = new Vector.<String>();
			_textFieldFactory = textFieldFactory;
			super(parent, constraints, width, height, maxLen);
		}

		public function addText(value:String):void
		{
			_textBuffer.push(value);

			if (_textBuffer.length == 1 && (!addTimer || !addTimer.running))
			{
				if (!addTimer)
				{
					addTimer = TimerManager.createNormalTimer((_textFieldFactory.completeTime * 1000 + 500) / _maxLen, 0, update);
				}
				else
				{
					addTimer.start();
				}
				_addText(_textBuffer.shift());
			}
		}

		private function update():void
		{
			if (_textBuffer.length == 0)
			{
				addTimer.stop();
				return;
			}

			if (objectList.length == _maxLen)
			{
				return;
			}

			_addText(_textBuffer.shift());
		}

		private function _addText(value:String):void
		{
			var tf:TextField = _textFieldFactory.newInstance();
			tf.width = this.width;
			tf.autoSize = TextFieldAutoSize.CENTER;
			tf.htmlText = HtmlUtil.tag("font", [{key: "size", value: 19}], value);
			this.addObject(tf);
		}

		override protected function onHideComplete(event:Event):void
		{
			super.onHideComplete(event);
		}
	}
}

