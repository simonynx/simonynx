package fj1.modules.item.view.components.level2
{
	import assets.UIResourceLib;
	import fj1.common.res.lan.LanguageManager;
	import fj1.common.ui.BaseWindow;
	import fj1.common.ui.TInputText;
	import fj1.common.ui.TWindowManager;
	import fj1.manager.MessageManager;
	import flash.display.SimpleButton;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import tempest.common.rsl.TRslManager;
	import tempest.ui.components.TButton;
	import tempest.ui.events.DataEvent;
	import tempest.utils.RegexUtil;

	public class DepotSetPwdDialog extends BaseWindow
	{
		private var _tf_newPwd:TInputText;
		private var _tf_newPwdRepeat:TInputText;
		private var _btn_submit:TButton;
		private var _btn_cancel:TButton;

		public function DepotSetPwdDialog()
		{
			super({horizontalCenter: 0, verticalCenter: 0}, TRslManager.getInstance(UIResourceLib.UI_GAME_GUI_DEPOT_SET_PWD_INPUT), TWindowManager.NAME_SINGLE_DIALOG);
			_tf_newPwd = new TInputText(null, null, _proxy.tf_newPwd);
			_tf_newPwd.passwordModel(6);
			_tf_newPwd.restrict = RegexUtil.Number;
			_tf_newPwdRepeat = new TInputText(null, null, _proxy.tf_newPwdRepeat);
			_tf_newPwdRepeat.passwordModel(6);
			_tf_newPwdRepeat.restrict = RegexUtil.Number;
			_btn_submit = new TButton(null, _proxy.btn_submit, LanguageManager.translate(100008, "确定"), onClick);
			_btn_cancel = new TButton(null, _proxy.btn_cancel, LanguageManager.translate(100009, "取消"), onClick);
		}

		private function onClick(event:MouseEvent):void
		{
			switch (event.currentTarget)
			{
				case _btn_submit:
					if (check())
					{
						this.dispatchEvent(new DataEvent(DataEvent.DATA, _tf_newPwd.text));
						this.closeWindow();
					}
					break;
				case _btn_cancel:
					this.closeWindow();
					break;
			}
		}

		private function check():Boolean
		{
			if (_tf_newPwd.text != _tf_newPwdRepeat.text)
			{
				MessageManager.instance.addHintById_client(10004, "密码不一致"); //密码不一致
				return false;
			}
			return true;
		}

		private function setLabel(txtOld:String, txtNew:String):void
		{
			_proxy.txt_label1.text = txtOld;
			_proxy.txt_label2.text = txtNew;
		}
	}
}
