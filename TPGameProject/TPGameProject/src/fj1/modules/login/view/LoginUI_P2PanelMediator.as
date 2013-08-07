package fj1.modules.login.view
{
	import fj1.common.GameInstance;
	import fj1.common.helper.TAlertHelper;
	import fj1.common.res.lan.LanguageManager;
	import fj1.modules.login.net.LoginService;
	import fj1.modules.login.signals.LoginUISignals;
	import fj1.modules.login.view.ui.components.P2Panel;

	import tempest.common.mvc.base.Mediator;
	import tempest.ui.components.TAlert;

	public class LoginUI_P2PanelMediator extends Mediator
	{
		[Inject]
		public var p2Panel:P2Panel;
		[Inject]
		public var loginService:LoginService;
		[Inject]
		public var loginUISignals:LoginUISignals;

		public function LoginUI_P2PanelMediator()
		{
			super();
		}

		override public function onRegister():void
		{
			addSignal(p2Panel.onChangeClick, changeHandler); //更改 
			addSignal(p2Panel.onOkClick, onOK); //确定 
			p2Panel.reset();
		}

		/**
		 * 更改
		 * @param e
		 *
		 */
		private function changeHandler():void
		{
			loginUISignals.showP2ResetPanel.dispatch();
		}

		/**
		 * 确定
		 * @param e
		 *
		 */
		private function onOK(pwd:String):void
		{
			if (pwd.length == 0)
			{
				TAlert.Show(LanguageManager.translate(50284, "密碼不能爲空"));
				return;
			}
			//向服务器发送密码验证
			loginService.sendAuthP2(pwd);
			loginUISignals.showTipPanel.dispatch(LanguageManager.translate(45011, "正在验证二次密码..."));
		}

		override public function onRemove():void
		{
			p2Panel.clear();
		}
	}
}
