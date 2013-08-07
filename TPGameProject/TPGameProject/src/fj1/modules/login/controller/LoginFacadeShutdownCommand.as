package fj1.modules.login.controller
{
	import assets.UIRoleLib;

	import fj1.common.GameInstance;
	import tempest.common.rsl.RslManager;
	import fj1.common.res.ResPaths;
	import fj1.modules.login.model.LoginModel;
	import fj1.modules.login.net.LoginService;
	import fj1.modules.login.view.ui.LoginUI;

	import shell.AppUIMananger;
	import shell.AppUINames;

	import tempest.common.logging.*;
	import tempest.common.mvc.base.Command;
	import tempest.common.rsl.TRslManager;
	import tempest.ui.TPApplication;

	public class LoginFacadeShutdownCommand extends Command
	{
		private static const log:ILogger = TLog.getLogger(LoginFacadeShutdownCommand);
		[Inject]
		public var loginModel:LoginModel;
		[Inject]
		public var loginService:LoginService;

		public override function execute():void
		{
			log.info("登陆模块关闭");
			//销毁数据对象
			loginModel.dispose();
			loginService.dispose();

			var loginUI:LoginUI = AppUIMananger.getUI(AppUINames.LOGIN_UI);

			loginUI.hide();
//			GameInstance.ui.loginUI.hide();
//			GameInstance.ui.loginUI = null;
			RslManager.unload(ResPaths.getUIPath("Role.swf"));
		}
	}
}
