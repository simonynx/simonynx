package fj1.modules.login.view
{
	import fj1.common.GameInstance;
	import fj1.common.config.CustomConfig;
	import fj1.modules.login.signals.LoginSignal;
	import fj1.modules.login.signals.LoginUISignals;
	import fj1.modules.login.view.ui.LoginUI;

	import tempest.common.logging.ILogger;
	import tempest.common.logging.TLog;
	import tempest.common.mvc.base.Mediator;

	public class LoginUIMediator extends Mediator
	{
		private static const log:ILogger = TLog.getLogger(LoginUIMediator);

		[Inject]
		public var loginUI:LoginUI;

		[Inject]
		public var loginUISignals:LoginUISignals;

		[Inject]
		public var loginSignals:LoginSignal;

		public function LoginUIMediator()
		{
			super();
		}

		public override function onRegister():void
		{
			addSignal(loginSignals.loginFailed, onLoginFailedHandler);
			addSignal(loginUISignals.showTipPanel, onShowTipPanel);
			addSignal(loginUISignals.showLineSelectPanel, onShowLineSelectPanel);
			addSignal(loginUISignals.showRoleCreatePanel, onShowRoleCreatePanel);
			addSignal(loginUISignals.showP2Panel, onShowP2Panel);
			addSignal(loginUISignals.showP2ResetPanel, onShowP2ResetPanel);
			addSignal(loginUISignals.showP2SetPanel, onShowP2ResetPanel);
			addSignal(loginUISignals.showLoginPanel, onShowLoginPanel);
		}

		public override function onRemove():void
		{
		}

		private function onShowTipPanel(str:String, color:uint = 0xFFFFFF):void
		{
			loginUI.showTipPanel(str, color);
		}

		private function onShowLineSelectPanel():void
		{
			loginUI.showPanel(loginUI.lineSelectPanel);
		}

		private function onShowRoleCreatePanel():void
		{
			loginUI.showPanel(loginUI.roleCreatePanel);
		}

		private function onShowP2Panel():void
		{
			loginUI.showPanel(loginUI.p2Panel);
		}

		private function onShowP2ResetPanel():void
		{
			loginUI.showPanel(loginUI.p2ResetPanel);
		}

		private function onShowP2SetPanel():void
		{
			loginUI.showPanel(loginUI.p2SetPanel);
		}

		private function onShowLoginPanel(auto:Boolean = false):void
		{
			if (CustomConfig.instance.user_id == 0)
			{
				loginUI.showPanel(loginUI.loginPanel);
			}
			else if (auto)
			{
				loginSignals.login.dispatch();
			}
		}

		private function onLoginFailedHandler(errorId:int, message:String):void
		{
			// TODO Auto Generated method stub
		}
	}
}
