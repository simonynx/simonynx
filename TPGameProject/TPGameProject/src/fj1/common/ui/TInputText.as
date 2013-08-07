package fj1.common.ui
{
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.events.TextEvent;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	import flash.utils.ByteArray;
	import tempest.common.keyboard.KeyCodes;
	import tempest.ui.components.textFields.TText;
	import tempest.ui.helper.TextHelper;
	import tempest.utils.RegexUtil;
	import tempest.utils.StringUtil;

	public class TInputText extends TText
	{
		private var oldText:String = null;
		private var _checkHandler:Function = null;
		private var _baseCheckHandler:Function = null; //基础合法性的函数，在_checkHandler前优先发挥作用
		private var _model:int;
		private var _minValue:int = 0;
		private var _maxValue:int = int.MAX_VALUE;
		private static const MODEL_DEFAULT:int = 0;
		private static const MODEL_NUM:int = 1;
		private static const MODEL_PWD:int = 2;
		private static const MODEL_BYTE_LIMIT:int = 3;
		/**
		 * 是否在FocusOut时触发文本修改
		 */
		public var changeWhenFocusOut:Boolean = true;

		/**
		 *
		 * @param checkHandler 验证输入合法性的函数：格式为 function(inputStr:String):Boolean{}
		 * @param constraints
		 * @param _proxy
		 * @param text
		 * @param autoSizeType
		 * @param mutiline
		 *
		 */
		public function TInputText(checkHandler:Function, constraints:Object = null, _proxy:* = null, text:String = "", autoSizeType:String = TextFieldAutoSize.NONE)
		{
			autoFixSize = false;
			_model = MODEL_DEFAULT;
			_checkHandler = checkHandler;
			super(constraints, _proxy, text, autoSizeType);
			this.addEventListener(TextEvent.TEXT_INPUT, onInput);
//			this.addEventListener(FocusEvent.FOCUS_IN, onFocusIn);
			this.addEventListener(FocusEvent.FOCUS_OUT, onFocusOut);
		}

		public function set checkHandler(value:Function):void
		{
			_checkHandler = value;
		}

		override protected function addChildren():void
		{
			super.addChildren();
			this.editable = true;
		}

		private function onInput(e:TextEvent):void
		{
			oldText = text;
			if (_model == MODEL_PWD && _disableIO)
			{
				e.preventDefault();
			}
		}

		override protected function onChange(event:Event):void
		{
			_text = _textField.text;
			var text2:String = _text;
			var changed:Boolean = false;
			switch (_model)
			{
				case MODEL_NUM:
					var value:int = parseInt(text);
					if (value != 0 && value.toString() != text.replace(/^0+/, ""))
					{
						text = _maxValue.toString(); //已经越界
					}
					else if (value > _maxValue)
					{
						text = _maxValue.toString();
					}
					else if (text.length > 1 && text.indexOf("0") == 0)
					{
						text = value.toString();
					}
					break;
				case MODEL_BYTE_LIMIT:
//					var byteStr:String = StringUtil.fixStr(text, textField.maxChars);
//					if (byteStr)
//					{
//						text = byteStr;
//					}
					break;
			}
			if (_checkHandler != null && !_checkHandler(text))
			{
				text = oldText;
			}
			if (oldText != text)
			{
				dispatchEvent(event);
			}
			//_checkHandler或之上的处理中改变了text，将光标定位到末尾
			if (text2 != text)
			{
				addEventListener(Event.ENTER_FRAME, onDelaySetSelect);
			}
		}

		public function appendText(newText:String):void
		{
			text += (textField.maxChars > 0) ? newText.substr(0, textField.maxChars - textField.length) : newText;
		}

		private function onDelaySetSelect(event:Event):void
		{
			removeEventListener(Event.ENTER_FRAME, onDelaySetSelect);
			_textField.setSelection(text.length, text.length);
		}

		/**
		 * 设置为数字输入的输入框，默认可以输入9位
		 * @param charCount
		 *
		 */
		public function numberModel(min:int = 0, max:int = int.MAX_VALUE):void
		{
			_model = MODEL_NUM;
			_minValue = min;
			_maxValue = max;
			textField.restrict = RegexUtil.Number;
//			textField.maxChars = max.toString().length;
			if (text.length == 0)
			{
				text = _minValue.toString();
			}
		}
		private var _disableIO:Boolean = false;

		/**
		 * 设置为密码输入的输入框，默认可以输入16字符（未考虑汉字）
		 * @param charCount
		 *
		 */
		public function passwordModel(charCount:int = 16, disableIO:Boolean = false):void
		{
			_model = MODEL_PWD;
			_disableIO = disableIO;
			textField.displayAsPassword = true;
			textField.maxChars = charCount;
			textField.selectable = false;
		}

		public function setSelectionToEnd():void
		{
			textField.setSelection(textField.length, textField.length);
		}

		/**
		 * 按字节数限制的输入框
		 * @param charCount
		 *
		 */
		public function byteLimitModel(maxCount:int = 12):void
		{
			_model = MODEL_BYTE_LIMIT;
			textField.maxChars = maxCount;
		}

//		/**
//		 * 如果显示0，焦点设置时自动清空
//		 * @param event
//		 *
//		 */
//		private function onFocusIn(event:FocusEvent):void
//		{
//			if (_model == MODEL_NUM && text == "0")
//				text = "";
//		}
		private function onFocusOut(event:FocusEvent):void
		{
			if (!changeWhenFocusOut)
			{
				return;
			}
			if (_model == MODEL_NUM)
			{
				var value:int = parseInt(text);
				if (text.length == 0 || isNaN(value) || value < _minValue)
				{
					if (_checkHandler != null)
					{
						if (_checkHandler(_minValue.toString()) && _minValue != parseInt(text))
						{
							text = _minValue.toString();
						}
					}
					else
					{
						text = _minValue.toString();
					}
				}
			}
		}
	}
}
