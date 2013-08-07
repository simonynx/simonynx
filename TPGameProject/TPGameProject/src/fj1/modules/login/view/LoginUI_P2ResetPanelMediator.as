package fj1.modules.login.view
{
	import fj1.common.GameInstance;
	import fj1.common.helper.TAlertHelper;
	import fj1.common.res.lan.LanguageManager;
	import fj1.manager.MessageManager;
	import fj1.modules.login.net.LoginService;
	import fj1.modules.login.signals.LoginUISignals;
	import fj1.modules.login.view.ui.components.P2ResetPanel;

	import tempest.common.mvc.base.Mediator;
	import tempest.ui.components.TAlert;
	import tempest.ui.components.TButton;

	public class LoginUI_P2ResetPanelMediator extends Mediator
	{
		[Inject]
		public var p2ResetPanel:P2ResetPanel;
		[Inject]
		public var loginService:LoginService;

		[Inject]
		public var loginUISignals:LoginUISignals;

		public function LoginUI_P2ResetPanelMediator()
		{
			super();
		}

		override public function onRegister():void
		{
			addSignal(p2ResetPanel.onOkClick, onOK); //确定 
			addSignal(p2ResetPanel.onClose, closeHandler); //确定 
			p2ResetPanel.reset();
		}

		/**
		 * 确定
		 * @param e
		 *
		 */
		private function onOK(oldPwd:String, newPwd:String, newPwd2:String):void
		{
			if (oldPwd.length == 0)
			{
				TAlert.Show(LanguageManager.translate(50284, "密碼不能爲空"));
				return;
			}
			if (newPwd.length == 0)
			{
				TAlert.Show(LanguageManager.translate(1069, "请输入新密码"));
				return;
			}
			if (newPwd2.length == 0)
			{
				TAlert.Show(LanguageManager.translate(1070, "请再次输入新密码"));
				return;
			}
			if (newPwd != newPwd2)
			{
				TAlert.Show(LanguageManager.translate(1071, "前后密码不一致"));
				return;
			}
			//向服务器发送密码验证
			loginService.sendModifyP2(oldPwd, newPwd);
			loginUISignals.showTipPanel.dispatch(LanguageManager.translate(45013, "正在修改二次密码..."));
		}

		private function closeHandler():void
		{
			loginUISignals.showP2Panel.dispatch();
		}

		override public function onRemove():void
		{
			p2ResetPanel.clear();
		}
	}
}
