package fj1.modules.login.controller
{
	import fj1.common.GameInstance;
	import fj1.common.config.CustomConfig;
	import fj1.common.helper.TAlertHelper;
	import fj1.common.res.lan.LanguageManager;
	import fj1.manager.NetManager;
	import fj1.modules.login.net.LoginService;
	import fj1.modules.login.signals.LoginUISignals;

	import flash.events.Event;

	import tempest.common.logging.*;
	import tempest.common.mvc.base.Command;

	public class LoginCommand extends Command
	{
		private static const log:ILogger = TLog.getLogger(LoginCommand);
		[Inject]
		public var loginService:LoginService;
		[Inject]
		public var loginUISignals:LoginUISignals;

		override public function getHandle():Function
		{
			return this.login;
		}

		private function login(relogin:Boolean = false):void
		{
			if (NetManager.loginSocket.connected)
			{
				loginUISignals.showTipPanel.dispatch(LanguageManager.translate(45002, "正在登陆..."));
				//发送登陆请求
				loginService.sendAuthLogonChallenge();
			}
			else
			{
				var host:String = CustomConfig.instance.login_host;
				var port:int = int(CustomConfig.instance.login_port.shift());
				NetManager.connect(NetManager.loginSocket, host, port, connectHandler, ioErrorHandler, securityErrorHandler);
				log.info("连接登陆服务器 host:{0} port:{1}", host, port);
				loginUISignals.showTipPanel.dispatch(LanguageManager.translate(45001, "正在连接登陆服务器..."));
			}
		}

		private function connectHandler(e:Event):void
		{
			this.login(true);
		}

		private function ioErrorHandler(e:Event):void
		{
		}

		private function securityErrorHandler(e:Event):void
		{
			if (CustomConfig.instance.login_port.length != 0)
			{
				this.login(true);
			}
			else
			{
				loginUISignals.showLoginPanel.dispatch();
				TAlertHelper.showAlert(1724, "连接登陆服务器失败!");
			}
		}
	}
}
