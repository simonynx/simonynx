package fj1.modules.chat.view
{
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.text.TextFormat;

	import tempest.common.keyboard.KeyCodes;
	import tempest.ui.components.textFields.TRichTextField;

	public class TextInputHistoryLogger
	{
		private var _rtf_input:TRichTextField;
		private var _txtFormat:TextFormat;
		private var _inputHistory:Array = []; //输入框记录
		private var _inputHistoryMaxLen:int = 5;
		private var _curInputHistoryIndex:int = -1;

		public function TextInputHistoryLogger(rtf_input:TRichTextField, txtFormat:TextFormat)
		{
			_rtf_input = rtf_input;
			_txtFormat = txtFormat;
			_rtf_input.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
		}

		private function onKeyUp(event:KeyboardEvent):void
		{
			switch (event.keyCode)
			{
				case KeyCodes.UP.keyCode: //上下键记录历史
					if (_curInputHistoryIndex <= 0)
						return;
					--_curInputHistoryIndex;
					_rtf_input.clear();
					_rtf_input.append(_inputHistory[_curInputHistoryIndex] as String, null, false, _txtFormat);
					//设置光标显示在文本末尾
					setTextFieldSelection(_rtf_input.textfield.length);
					break;
				case KeyCodes.DOWN.keyCode:
					if (_curInputHistoryIndex >= _inputHistory.length - 1)
						return;
					++_curInputHistoryIndex;
					_rtf_input.clear();
					_rtf_input.append(_inputHistory[_curInputHistoryIndex] as String, null, false, _txtFormat);
					//设置光标显示在文本末尾		
					setTextFieldSelection(_rtf_input.textfield.length);
					break;
			}
		}

		/**
		 * 设置文本框光标位置
		 * @param index
		 *
		 */
		public function setTextFieldSelection(index:int):void
		{
			_rtf_input.addEventListener(Event.ENTER_FRAME, function(event:Event):void
			{
				event.currentTarget.removeEventListener(event.type, arguments.callee);
				_rtf_input.textfield.setSelection(index, index); //光标设置到目标位置
			});
		}

		/**
		 * 记录输入
		 * @param content
		 *
		 */
		public function logInput(content:String):void
		{
			if (content == "")
				return;
			_inputHistory.push(content);
			if (_inputHistory.length > _inputHistoryMaxLen)
				_inputHistory.splice(0, 1);
			_curInputHistoryIndex = _inputHistory.length; //定位到末尾
		}

	}
}
