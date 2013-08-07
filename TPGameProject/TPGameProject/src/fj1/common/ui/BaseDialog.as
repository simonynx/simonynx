package fj1.common.ui
{
	import fj1.common.res.lan.LanguageManager;

	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.MouseEvent;
	import flash.text.TextField;

	import tempest.ui.components.TButton;
	import tempest.ui.components.textFields.TTextArea;

	/**
	 * 基础的对话框类
	 * 资源包括普通窗口的基础资源，和
	 * btn_submit，btn_cancel：按钮
	 * tf_msg：内容文本区域
	 * txt_waring：内容文本区域2（非必须）
	 * @author linxun
	 *
	 */
	public class BaseDialog extends BaseWindow
	{
		public static const CANCEL:uint = 0x0008;
		public static const OK:uint = 0x0004;
		protected var _btn_submit:TButton;
		protected var _btn_cancel:TButton;
		protected var _textArea:TTextArea;

		public function BaseDialog(proxy:* = null, name:String = "", title:String = "", msg:String = "", submitText:String = "", cancelText:String = "")
		{
			super({horizontalCenter: 0, verticalCenter: 0}, proxy, name);
			switchToChatWhenEnter = false;
//			_proxy.tf_msg.mouseWheelEnabled = false;
			_textArea = new TTextArea(null, _proxy.tf_msg);
//			_textArea.mouseWheelEnabled = false;
			_textArea.text = msg;
			if (!submitText)
			{
				submitText = LanguageManager.translate(100008, "确定");
			}
			if (!cancelText)
			{
				cancelText = LanguageManager.translate(100009, "取消");
			}
			if (_proxy.hasOwnProperty("btn_submit"))
			{
				_btn_submit = new TButton(null, _proxy.btn_submit, submitText, onSubmitClick);
			}
			if (_proxy.hasOwnProperty("btn_cancel"))
			{
				_btn_cancel = new TButton(null, _proxy.btn_cancel, cancelText, onCancelClick);
			}
		}

		public function setMsg(value:String):void
		{
			_textArea.text = value;
		}

		public function get msgTextArea():TTextArea
		{
			return _textArea;
		}

		public function get msgTextField():TextField
		{
			return _proxy.tf_msg;
		}

		public function setWaring(value:String):void
		{
			if (_proxy.hasOwnProperty("txt_waring"))
			{
				_proxy.txt_waring.text = value;
			}
		}

		/**
		 *设置按钮名称
		 * @param value
		 *
		 */
		protected function setBtnText(value:String):void
		{
			if (value.length > 0)
			{
				_btn_submit.text = value;
			}
		}

		protected function onSubmitClick(event:MouseEvent):void
		{
			this.closeWindow();
		}

		protected function onCancelClick(event:MouseEvent):void
		{
			this.closeWindow();
		}

		public function get btn_submit():TButton
		{
			return _btn_submit;
		}

		public function get btn_cancel():TButton
		{
			return _btn_cancel;
		}
	}
}


