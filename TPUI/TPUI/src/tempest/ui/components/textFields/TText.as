package tempest.ui.components.textFields
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	import flash.events.TimerEvent;
	import flash.system.Capabilities;
	import flash.text.StyleSheet;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import flash.utils.Timer;

	import tempest.common.logging.*;
	import tempest.common.staticdata.CursorPriority;
	import tempest.ui.CursorManager;
	import tempest.ui.UIStyle;
	import tempest.ui.components.TComponent;
	import tempest.ui.helper.TextFieldHelper;
	import tempest.ui.helper.TextHelper;
	import tempest.utils.Fun;
	import tempest.utils.StringUtil;

	[Event(name = "change", type = "flash.events.Event")]
	public class TText extends TComponent
	{
		private static const log:ILogger = TLog.getLogger(TText);
		protected var _editable:Boolean = false;
//		protected var _panel:MovieClip;
		protected var _selectable:Boolean = false;
		protected var _html:Boolean = false;
		protected var _format:TextFormat;
//		protected var _autoSize:Boolean = true;
		protected var _text:String = "";
		protected var _textField:TextField = null;
		private var _textValided:Boolean = false; //标记文本是否需要在draw时赋值
		public static const INPUT:String = "input";
		protected var _byteLimit:int = -1;
		private var _model:int = 0;

		protected var _fixModelOverLimit:int = 0; //文本当超出byteLimit时的处理类型
		public static const OL_CUT_AND_ADD_TAIL:int = 0; //缩短文本并添加后缀"..."
		public static const OL_ADD_TAIL:int = 1; //添加后缀"..."
		public static const OL_NONE:int = 1; //不添加后缀

		/**
		 * 金钱显示模式，该模式下显示的数值将被逗号分割
		 * text属性返回的字符串中将不包含逗号
		 */
		public static const MODEL_MONEY:int = 1;

		/**
		 * 是否自动调整宽度
		 */
		public var autoFixSize:Boolean = true;

		public function TText(constraints:Object = null, _proxy:* = null, text:String = "", autoSizeType:String = TextFieldAutoSize.LEFT)
		{
			initText(_proxy, text);
			super(constraints, _proxy);
			_textField.autoSize = autoSizeType;
			if (selectable || editable)
			{
				this.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
				this.addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
			}
			else
			{
				this.removeEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
				this.removeEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
			}
			invalidateNow();
		}

		private function initText(proxy:*, text:String):void
		{
			if (text)
			{
				_text = text;
			}
			else
			{
				if (proxy)
				{
					var proxyText:TextField = proxy as TextField;
					if (!proxyText && proxy.hasOwnProperty("text"))
						proxyText = proxy.text as TextField;
					if (proxyText)
					{
						_text = proxyText.text;
					}
					else
					{
						_text = "";
					}
				}
				else
				{
					_text = "";
				}
			}
		}

		/**
		 * Creates and adds the child display objects of this component.
		 */
		override protected function addChildren():void
		{
			if (_proxy)
			{
				_textField = _proxy as TextField;
				if (!_textField && _proxy.hasOwnProperty("text"))
					_textField = _proxy.text as TextField;
			}
			if (!_textField)
			{
				_format = new TextFormat(UIStyle.fontName, UIStyle.fontSize, UIStyle.LABEL_TEXT);
				_textField = new TextField();
				_textField.height = _height;
				_textField.width = _width;
				addChild(_textField);
			}
			_textField.addEventListener(Event.CHANGE, onChange);
			_textField.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
//			_textField.addEventListener(TextEvent.LINK, onTextLink);			
			_textField.addEventListener(TextEvent.TEXT_INPUT, onTextInput);
		}

		///////////////////////////////////
		// public methods
		///////////////////////////////////
		/**
		 * Draws the visual ui of the component.
		 */
		override protected function draw():void
		{
			super.draw();
			if (!_textValided)
			{
				_textValided = true;
				if (_html)
				{
					_textField.htmlText = _text;
				}
				else
				{
					_textField.text = _text;
				}
				//兼容版本 10.3.183.5处理、
				if (_textField.multiline && _textField.wordWrap)
				{
					processVersion10_3();
				}
			}
			if (_editable)
			{
				_textField.selectable = true;
				_textField.type = TextFieldType.INPUT;
			}
			else
			{
				_textField.selectable = _selectable;
				_textField.type = TextFieldType.DYNAMIC;
			}
			if (_format && !_html)
			{
				_textField.defaultTextFormat = _format;
				_textField.setTextFormat(_format);
			}
//			if(_textField.autoSize == TextFieldAutoSize.NONE)
//			{
//				_textField.height = _textField.textHeight;
//			}
			if (autoFixSize)
			{
				fixSize();
			}
		}

		public function set byteLimit(value:int):void
		{
			_byteLimit = value;
			_textValided = false;
			invalidate();
		}

		public function setByteLimit(value:int, fixModel:int):void
		{
			byteLimit = value;
			_fixModelOverLimit = fixModel;
		}
		/*************************************************
		 *
		 * 兼容版本 10.3.183.5 判断是否是错误的竖排情形，如果是错误排版，延时3帧，重新创建TextField并设置字符串
		 * text字段的变化，才会引发此检查
		 *
		 * ***********************************************/
		private var _delayCount:int = 0;

		private function processVersion10_3():void
		{
			if (Capabilities.version.split(" ")[1] == "10,3,183,5")
			{
				_delayCount = 0;
				this.addEventListener(Event.ENTER_FRAME, onDelayReRend);
			}
		}

		private function onDelayReRend(event:Event):void
		{
			_delayCount++;
			if (_delayCount == 3)
			{
				_delayCount = 0;
				event.currentTarget.removeEventListener(event.type, arguments.callee);
				if (_textField.text != "" && _textField.numLines >= _textField.text.replace(/[\s]/g, "").length)
				{
					_textField.parent.removeChild(_textField);
					_textField = copyTextField();
					addChild(_textField);
					log.debug("ReRend");
					this.dispatchEvent(new Event(Event.RESIZE));
				}
			}
		}

		private function copyTextField():TextField
		{
			var newTextField:TextField = new TextField();
			newTextField.x = _textField.x;
			newTextField.y = _textField.y;
			newTextField.height = _textField.height;
			newTextField.width = _textField.width;
			newTextField.addEventListener(Event.CHANGE, onChange);
			newTextField.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			newTextField.multiline = _textField.multiline;
			newTextField.styleSheet = _textField.styleSheet;
			newTextField.defaultTextFormat = _textField.defaultTextFormat;
			newTextField.maxChars = _textField.maxChars;
			newTextField.restrict = _textField.restrict;
			newTextField.displayAsPassword = _textField.displayAsPassword;
			newTextField.filters = _textField.filters;
			newTextField.autoSize = _textField.autoSize;
			if (_editable)
			{
				newTextField.selectable = true;
				newTextField.type = TextFieldType.INPUT;
			}
			else
			{
				newTextField.selectable = _selectable;
				newTextField.type = TextFieldType.DYNAMIC;
			}
			if (_html)
			{
				newTextField.htmlText = _text;
			}
			else
			{
				newTextField.text = _text;
			}
			newTextField.scrollV = _textField.scrollV;
			return newTextField;
		}

		private function fixSize():void
		{
			if (_textField.autoSize == TextFieldAutoSize.CENTER)
			{
				if (_textField.x < 0)
				{
					//_textFeild的左边界小于0，为了保证TText的width和其实际占用的宽度相同，移动_textFeild位置到0
					_textField.width = _textField.width - 2 * _textField.x;
				}
				if (!_proxy || _proxy is TextField)
				{
					this.graphics.clear();
					this.graphics.drawRect(0, 0, _textField.width + _textField.x * 2, _textField.height);
					useRawSize();
				}
				else
				{
					if (_textField.x >= 0)
						setProxySize(_textField.width + _textField.x * 2, _textField.height);
					else
						setProxySize(_textField.width, _textField.height);
				}
			}
			else
			{
				measureChildren();
			}
		}

		///////////////////////////////////
		// event handlers
		///////////////////////////////////
		private function onTextInput(event:TextEvent):void
		{
			dispatchEvent(event);
		}

		/**
		 * Called when the text in the text field is manually changed.
		 */
		protected function onChange(event:Event):void
		{
			_text = _textField.text;
			dispatchEvent(event);
		}

		protected function onKeyDown(event:KeyboardEvent):void
		{
			if (event.keyCode == 13)
			{
				dispatchEvent(new Event(TText.INPUT));
			}
		}

		protected function onMouseOver(event:MouseEvent):void
		{
			CursorManager.instance.setDefaultCursor();
		}

		protected function onMouseOut(event:MouseEvent):void
		{
			if (this.mouseX <= 0 || this.mouseY <= 0 || this.mouseX >= this.width || this.mouseY >= this.height)
			{
				CursorManager.instance.removeDefaultCursor();
			}
		}

		///////////////////////////////////
		// getter/setters
		///////////////////////////////////
		/**
		 * Gets / sets the text of this Label.
		 */
		public function set text(t:String):void
		{
			if (_model == MODEL_MONEY)
			{
				t = TextFieldHelper.getMoneyFormat(t);
			}
			if (_byteLimit > 0)
			{
				var byteStr:String = StringUtil.fixStr(t, _byteLimit);
				if (byteStr)
				{
					if (_fixModelOverLimit == OL_CUT_AND_ADD_TAIL)
					{
						t = byteStr.substr(0, byteStr.length - 1) + "...";
					}
					else if (_fixModelOverLimit == OL_ADD_TAIL)
					{
						t = byteStr + "...";
					}
					else
					{
						t = byteStr;
					}
				}
			}
			if (_text == t)
				return;
			_textValided = false; //文本是否需要在draw时赋值
			_text = t;
			if (_text == null)
				_text = "";
			if (_toolTip)
				_toolTip.data = _text;
			invalidateNow();
		}

		public function get text():String
		{
			if (_model == MODEL_MONEY)
			{
				return TextFieldHelper.getMoney(_text);
			}
			else
			{
				return _text;
			}
		}

		/**
		 * Returns a reference to the internal text field in the component.
		 */
		public function get textField():TextField
		{
			return _textField;
		}

		/**
		 * 显示模式
		 * @param value
		 */
		public function set model(value:int):void
		{
			_model = value;
		}

		/**
		 * Gets / sets whether or not this text component will be editable.
		 */
		public function set editable(b:Boolean):void
		{
			_editable = b;
			if (_editable)
			{
				this.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
				this.addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
			}
			else
			{
				this.removeEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
				this.removeEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
			}
			invalidate();
		}

		public function get editable():Boolean
		{
			return _editable;
		}

		/**
		 * Gets / sets whether or not this text component will be selectable. Only meaningful if editable is false.
		 */
		public function set selectable(b:Boolean):void
		{
			_selectable = b;
			if (_selectable)
			{
				this.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
				this.addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
			}
			else
			{
				this.removeEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
				this.removeEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
			}
			invalidate();
		}

		public function get selectable():Boolean
		{
			return _selectable;
		}

		/**
		 * Gets / sets whether or not text will be rendered as HTML or plain text.
		 */
		public function set html(b:Boolean):void
		{
			_html = b;
			invalidateNow();
		}

		public function get html():Boolean
		{
			return _html;
		}

		public function set multiline(b:Boolean):void
		{
			_textField.multiline = b;
			invalidateNow();
		}

		public function get multiline():Boolean
		{
			return _textField.multiline;
		}

		/**
		 * Sets/gets whether this component is enabled or not.
		 */
		public override function set enabled(value:Boolean):void
		{
			super.enabled = value;
			_textField.tabEnabled = value;
		}

		public override function set width(value:Number):void
		{
			if (_textField.autoSize == TextFieldAutoSize.CENTER)
				_textField.width = value - 2 * _textField.x;
			else
				_textField.width = value;
			invalidateNow();
		}

		public override function set height(value:Number):void
		{
//			super.height = value;
//			
//			_textFeild.height = super.height;
//			
//			this.setSize(this.$width, this.$height);
			_textField.height = value;
			super.height = value;
		}

		public function set wordWrap(value:Boolean):void
		{
			_textField.wordWrap = value;
			invalidateNow();
		}

		public function get wordWrap():Boolean
		{
			return _textField.wordWrap;
		}

		public function set format(value:TextFormat):void
		{
			_format = value;
			invalidateNow();
		}

		public function set autoSizeType(value:String):void
		{
			_textField.autoSize = value;
		}

		public function get autoSizeType():String
		{
			return _textField.autoSize;
		}

		override public function set mouseEnabled(value:Boolean):void
		{
			super.mouseEnabled = value;
			_textField.mouseEnabled = value;
		}

		public function get mouseWheelEnabled():Boolean
		{
			return _textField.mouseWheelEnabled;
		}

		public function set mouseWheelEnabled(value:Boolean):void
		{
			_textField.mouseWheelEnabled = value;
		}

		public function set maxChars(value:int):void
		{
			_textField.maxChars = value;
		}

		public function set restrict(value:String):void
		{
			_textField.restrict = value;
		}

		public function set displayAsPassword(value:Boolean):void
		{
			_textField.displayAsPassword = value;
		}

		public function get scrollV():int
		{
			return _textField.scrollV;
		}

		public function set scrollV(value:int):void
		{
			_textField.scrollV = value;
		}

		public function get maxScrollV():int
		{
			return _textField.maxScrollV;
		}

		public function get numLines():int
		{
			return _textField.numLines;
		}

		public override function set filters(value:Array):void
		{
			_textField.filters = value;
		}

		public function set proxyFilters(value:Array):void
		{
			_proxy.filters = value;
//			_textField.filters = value;
		}

		public override function get filters():Array
		{
			return _textField.filters;
		}

		public function get textWidth():Number
		{
			return _textField.textWidth;
		}
	}
}
