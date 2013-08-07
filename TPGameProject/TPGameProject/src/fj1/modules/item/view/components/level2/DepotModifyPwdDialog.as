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
	import tempest.common.logging.ILogger;
	import tempest.common.logging.TLog;
	import tempest.common.rsl.TRslManager;
	import tempest.ui.components.TButton;
	import tempest.ui.events.DataEvent;
	import tempest.utils.RegexUtil;

	public class DepotModifyPwdDialog extends BaseWindow
	{
		private var log:ILogger = TLog.getLogger(DepotModifyPwdDialog);
		private var _tf_oldPwd:TInputText;
		private var _tf_newPwd:TInputText;
		private var _tf_newPwdRepeat:TInputText;
		private var _btn_submit:TButton;
		private var _btn_cancel:TButton;
		public static const RePassWord:String = "repasword";
		private var _panelType:String;

		public function DepotModifyPwdDialog(panelType:String)
		{
			super({horizontalCenter: 0, verticalCenter: 0}, TRslManager.getInstance(UIResourceLib.UI_GAME_GUI_DEPOT_MODIFY_PWD_INPUT), TWindowManager.NAME_SINGLE_DIALOG);
			_tf_oldPwd = new TInputText(null, null, _proxy.tf_oldPwd);
			_tf_oldPwd.passwordModel(6);
			_tf_oldPwd.restrict = RegexUtil.Number;
			_tf_newPwd = new TInputText(null, null, _proxy.tf_newPwd);
			_tf_newPwd.passwordModel(6);
			_tf_newPwd.restrict = RegexUtil.Number;
			_tf_newPwdRepeat = new TInputText(null, null, _proxy.tf_newPwdRepeat);
			_tf_newPwdRepeat.passwordModel(6);
			_tf_newPwdRepeat.restrict = RegexUtil.Number;
			_panelType = panelType;
			_btn_submit = new TButton(null, _proxy.btn_submit, LanguageManager.translate(100008, "确定"), onClick);
			_btn_cancel = new TButton(null, _proxy.btn_cancel, LanguageManager.translate(100009, "取消"), onCanel);
		}

		private function onClick(event:MouseEvent):void
		{
			if (_panelType.length > 0)
			{
				switch (_panelType)
				{
					case RePassWord:
						if (check())
						{
							this.dispatchEvent(new DataEvent(DataEvent.DATA, [_tf_oldPwd.text, _tf_newPwd.text]));
							this.closeWindow();
						}
						break;
				}
			}
		}

		private function onCanel(e:MouseEvent):void
		{
			this.closeWindow();
		}

		private function check2():Boolean
		{
			if (_tf_newPwd.text.length == 0)
			{
				return false;
			}
			return true;
		}

		private function check():Boolean
		{
			if (_tf_newPwd.text != _tf_newPwdRepeat.text)
			{
				MessageManager.instance.addHintById_client(10005, "密码不一致"); //密码不一致
				return false;
			}
			return true;
		}
	}
}
