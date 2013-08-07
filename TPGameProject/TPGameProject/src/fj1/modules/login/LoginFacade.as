package fj1.modules.login
{
	import fj1.common.GameInstance;
	import fj1.modules.login.controller.LoginFacadeShutdownCommand;
	import fj1.modules.login.controller.LoginFacadeStartupCommand;
	import fj1.modules.login.model.LoginModel;
	import fj1.modules.login.net.LoginService;
	import fj1.modules.login.signals.LoginModelSignal;
	import fj1.modules.login.signals.LoginSignal;
	import fj1.modules.login.signals.LoginUISignals;

	import tempest.common.mvc.TFacade;

	public class LoginFacade extends TFacade
	{
		private static var _instance:LoginFacade;

		public function LoginFacade()
		{
			super();
			if (_instance)
			{
				throw new Error("LoginFacade is Singleton");
			}
		}

		public static function get instance():LoginFacade
		{
			return _instance ||= new LoginFacade();
		}

		public override function startup():void
		{
			inject.mapSingleton(LoginSignal);
			inject.mapSingleton(LoginUISignals);
			inject.mapSingleton(LoginService);
			inject.mapSingleton(LoginModel);
			commandMap.map([this.startupSignal], LoginFacadeStartupCommand, true);
			commandMap.map([this.shutdownSignal], LoginFacadeShutdownCommand, true);
			super.startup();
		}

		public override function showdown():void
		{
			inject.unmap(LoginSignal);
			inject.unmap(LoginUISignals);
			inject.unmap(LoginService);
			inject.unmap(LoginModel);
			super.showdown();
		}
	}
}
