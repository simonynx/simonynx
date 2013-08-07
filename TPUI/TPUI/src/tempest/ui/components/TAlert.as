package tempest.ui.components
{
	import flash.display.DisplayObject;
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.ui.Keyboard;
	import flash.ui.Mouse;

	import tempest.ui.CursorManager;
	import tempest.ui.FetchHelper;
	import tempest.ui.Language;
	import tempest.ui.PopupManager;
	import tempest.ui.TPUGlobals;
	import tempest.ui.UIStyle;
	import tempest.ui.components.textFields.TText;
	import tempest.ui.events.DataEvent;
	import tempest.ui.events.TAlertEvent;
	import tempest.ui.events.TComponentEvent;
	import tempest.ui.events.TWindowEvent;

	public class TAlert extends TWindow
	{
		public static const CLOSE:uint = 0x0000;
		public static const YES:uint = 0x0001;
		public static const NO:uint = 0x0002;
		public static const OK:uint = 0x0004;
		public static const CANCEL:uint = 0x0008;
		protected var _lbl_title:TText;
		protected var _tf_msg:TText;
		protected var _btn_left:TButton;
		protected var _btn_right:TButton;
		protected var _closeHandler:Function;

		public function TAlert(text:String, title:String, flags:uint = OK, closeHandler:Function = null, defaultButtonFlag:uint = OK, name:String = "")
		{
			_closeHandler = closeHandler;
			super({horizontalCenter: 0, verticalCenter: 0}, new UIStyle.alertSkin(), name);
			_lbl_title = new TLabel(null, _proxy.title, title, TextFieldAutoSize.CENTER);
			var result:Array = testString(text);
			var isMultiline:Boolean = result[0] as Boolean;
			var isWordWrap:Boolean = result[1] as Boolean;
			_tf_msg = new TText(null, _proxy.tf_msg, text, TextFieldAutoSize.CENTER);
			_tf_msg.multiline = isMultiline;
			_tf_msg.wordWrap = isWordWrap;
			_tf_msg.mouseEnabled = false;
			_tf_msg.editable = false;
			_tf_msg.selectable = false;
			var flagNum:int = 0;
			if (flags & YES)
			{
				if (initButton(YES, defaultButtonFlag))
					++flagNum;
			}
			if (flags & NO)
			{
				if (initButton(NO, defaultButtonFlag))
					++flagNum;
			}
			if (flags & OK)
			{
				if (initButton(OK, defaultButtonFlag))
					++flagNum;
			}
			if (flags & CANCEL)
			{
				if (initButton(CANCEL, defaultButtonFlag))
					++flagNum;
			}
			if (flagNum == 1)
			{
				_btn_left.x = (this.width - _btn_left.width) / 2;
				(_proxy.btn_right as SimpleButton).visible = false;
			}
			if (closeHandler != null)
				this.addEventListener(DataEvent.DATA, closeHandler);
//			if (_tf_msg.height > defaultTextHeight)
//			{
//				if (_btn_left)
//					_btn_left.y += _tf_msg.height - defaultTextHeight;
//				if (_btn_right)
//					_btn_right.y += _tf_msg.height - defaultTextHeight;
//				_proxy.bg.height += _tf_msg.height - defaultTextHeight;
//				this.useRawSize();
//			}
			this.addEventListener(TComponentEvent.SHOW, onShow);
		}

		public function get tf_msg():TText
		{
			return _tf_msg;
		}

		protected function testString(text:String):Array
		{
			var isWordWrap:Boolean = false;
			var isMultiline:Boolean = false;
			var testTextField:TextField = new TextField();
			testTextField.width = _proxy.tf_msg.width;
			testTextField.height = _proxy.tf_msg.height;
			var defaultTextHeight:Number = testTextField.height; //记录文本赋值前文本高度
			var defaultTextWidth:Number = testTextField.width;
			testTextField.multiline = true;
			testTextField.wordWrap = true;
			testTextField.text = text; //判断文本是一行还是多行
			testTextField.autoSize = TextFieldAutoSize.CENTER;
			if (testTextField.numLines > 1)
				isMultiline = true;
//			if (isMultiline)
//			{
//				testTextField.wordWrap = false;
//				testTextField.text = text; //判断是否需要wordWrap
//				if (testTextField.numLines > 1)
//					isWordWrap = false;
//				else
//					isWordWrap = true;
//				testTextField.autoSize = TextFieldAutoSize.NONE;
//				testTextField.text = "";
//				testTextField.wordWrap = true;
//				testTextField.width = defaultTextWidth; //恢复因为设置wordWrap而变长的宽度
//			}
			isWordWrap = isMultiline;
			return [isMultiline, isWordWrap];
		}

		protected function set text(value:String):void
		{
			var result:Array = testString(value);
			_tf_msg.multiline = result[0] as Boolean;
			_tf_msg.wordWrap = result[1] as Boolean;
			_tf_msg.text = value;
		}

		private function onShow(event:TComponentEvent):void
		{
			//Alert显示时，临时禁用拾取
			if (FetchHelper.instance.isFetching)
			{
				FetchHelper.instance.pause = true;
			}
		}

		override public function closeWindow():void
		{
			super.closeWindow();
			if (FetchHelper.instance.isFetching)
			{
				FetchHelper.instance.pause = false;
			}
		}

		private function initButton(flag:uint, defaultButtonFlag:uint):Boolean
		{
			var text:String = getFlagText(flag);
			if (!_btn_left)
			{
				_btn_left = new TButton(null, _proxy.btn_left, text);
				_btn_left.data = flag;
				_btn_left.addEventListener(MouseEvent.CLICK, onClick);
				if (flag & defaultButtonFlag)
				{
					_btn_left.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
				}
				return true;
			}
			if (!_btn_right)
			{
				_btn_right = new TButton(null, _proxy.btn_right, text);
				_btn_right.data = flag;
				_btn_right.addEventListener(MouseEvent.CLICK, onClick);
				if (flag & defaultButtonFlag)
				{
					_btn_right.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
				}
				return true;
			}
			return false;
		}

		protected function getFlagText(flag:int):String
		{
			switch (flag)
			{
				case YES:
					return Language.YES;
				case NO:
					return Language.NO;
				case OK:
					return Language.OK;
				case CANCEL:
					return Language.CANCEL;
				default:
					return "";
			}
		}

		protected function getDefaulText(left:Boolean):String
		{
			var flag:int = left ? int(_btn_left.data) : int(_btn_right.data);
			return getFlagText(flag);
		}

		public function get btn_left():TButton
		{
			return _btn_left;
		}

		public function get btn_right():TButton
		{
			return _btn_right;
		}

		/**
		 * 设置按钮文本
		 * @param flag
		 * @param text
		 *
		 */
		public function setButtonText(flag:int, text:String):void
		{
			if (_btn_left && _btn_left.data == flag)
			{
				_btn_left.text = text;
			}
			if (_btn_right && _btn_right.data == flag)
			{
				_btn_right.text = text;
			}
		}

		override protected function onClose(event:MouseEvent):void
		{
			super.onClose(event);
			if (_closeHandler != null)
			{
				var dFlag:int = CLOSE;
				if (dFlag == CLOSE && _btn_left && (_btn_left.data == NO || _btn_left.data == CANCEL))
				{
					dFlag = int(_btn_left.data);
				}
				if (dFlag == CLOSE && _btn_right && (_btn_right.data == NO || _btn_right.data == CANCEL))
				{
					dFlag = int(_btn_right.data);
				}
				dispatchEvent(new TAlertEvent(DataEvent.DATA, dFlag));
			}
//				dispatchEvent(new TAlertEvent(DataEvent.DATA, CLOSE));
		}

		/**
		 * 按钮按下触发
		 * @param event
		 *
		 */
		protected function onClick(event:MouseEvent):void
		{
			closeWindow();
			if (_closeHandler != null)
			{
				dispatchEvent(new TAlertEvent(DataEvent.DATA, (event.currentTarget as TButton).data as int /*flag*/));
			}
		}

		private function onKeyDown(event:KeyboardEvent):void
		{
			if (event.keyCode == Keyboard.ENTER)
			{
				closeWindow();
				if (_closeHandler != null)
					dispatchEvent(new TAlertEvent(DataEvent.DATA, (event.currentTarget as TButton).data as int /*flag*/));
			}
		}

		/**
		 * 显示Tip
		 * @param content 内容
		 * @param title 标题
		 * @param modal 是否是模式对话框
		 * @param flags 按钮类型 可以是 TAlert.CANCEL, TAlert.OK, TAlert.YES, TAlert.NO之间的任意组合，最多支持2个
		 * @param closeHandler 关闭处理
		 * @param defaultButtonFlag 回车对应的按钮
		 * @return
		 *
		 */
		public static function Show(content:String, title:String = "", modal:Boolean = true, flags:uint = OK, closeHandler:Function = null, defaultButtonFlag:uint = OK):TAlert
		{
			return Show2(null, content, title, modal, flags, closeHandler, defaultButtonFlag);
		}

		public static function showAlert(parentWindow:TWindow, alert:TAlert, modal:Boolean):void
		{
			PopupManager.instance.showPopup(parentWindow, alert, modal, null);
			if (modal)
			{
				PopupManager.showSolidCover(alert, 0, UIStyle.COVER_ALPHA, true);
			}
			//如果是模式对话框，则将焦点设到提示框
			if (modal)
			{
				TPUGlobals.stage.focus = alert;
			}
		}

		public static function Show2(parentWindow:TWindow, content:String, title:String = "", modal:Boolean = true, flags:uint = OK, closeHandler:Function = null, defaultButtonFlag:uint = OK):TAlert
		{
			var alert:TAlert = new TAlert(content, title, flags, closeHandler, defaultButtonFlag);
			showAlert(parentWindow, alert, modal);
			return alert;
		}
	}
}
