package fj1.modules.login.view
{
	import fj1.common.GameInstance;
	import fj1.common.helper.TAlertHelper;
	import fj1.common.res.lan.LanguageManager;
	import fj1.modules.login.net.LoginService;
	import fj1.modules.login.signals.LoginUISignals;
	import fj1.modules.login.view.ui.components.P2SetPanel;

	import tempest.common.mvc.base.Mediator;
	import tempest.ui.components.TAlert;
	import tempest.ui.components.TButton;

	public class LoginUI_P2SetPanelMediator extends Mediator
	{
		[Inject]
		public var p2SetPanel:P2SetPanel;
		[Inject]
		public var loginService:LoginService;
		[Inject]
		public var loginUISignals:LoginUISignals;

		public function LoginUI_P2SetPanelMediator()
		{
			super();
		}

		override public function onRegister():void
		{
			addSignal(p2SetPanel.onOkClick, onOK); //确定 
			p2SetPanel.reset();
		}

		/**
		 * 确定
		 * @param e
		 *
		 */
		private function onOK(newPwd:String, newPwd2:String):void
		{
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
			loginService.sendCreateP2(newPwd);
			//
			loginUISignals.showTipPanel.dispatch(LanguageManager.translate(45012, "正在初始化二次密码..."));
		}

		override public function onRemove():void
		{
			p2SetPanel.clear();
		}
	}
}
