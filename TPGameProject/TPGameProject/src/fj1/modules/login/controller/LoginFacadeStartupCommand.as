package fj1.modules.login.controller
{
	import fj1.common.GameInstance;
	import fj1.modules.login.model.LoginModel;
	import fj1.modules.login.net.LoginService;
	import fj1.modules.login.signals.LoginSignal;
	import fj1.modules.login.signals.LoginUISignals;
	import fj1.modules.login.view.*;
	import fj1.modules.login.view.ui.LoginUI;
	import shell.AppUIMananger;
	import shell.AppUINames;
	import tempest.common.logging.*;
	import tempest.common.mvc.base.Command;
	import tempest.ui.TPApplication;

	public class LoginFacadeStartupCommand extends Command
	{
		private static const log:ILogger = TLog.getLogger(LoginFacadeStartupCommand);
		[Inject]
		public var loginModel:LoginModel;
		[Inject]
		public var loginService:LoginService;
		[Inject]
		public var loginSignal:LoginSignal;
		[Inject]
		public var loginUISignals:LoginUISignals;

		public override function execute():void
		{
			log.info("登陆模块启动");
			//注册命令
			commandMap.map([loginSignal.login], LoginCommand); //登陆
			commandMap.map([loginSignal.selectRoleSuccess], SelectRole_SuccessCommand);
			//注册数据对象
			loginModel.init();
			loginService.init();
			//注册视图
			var loginUI:LoginUI = AppUIMananger.addUI(AppUINames.LOGIN_UI, new LoginUI());
			mediatorMap.map(loginUI, LoginUIMediator);
			mediatorMap.map(loginUI.loginPanel, LoginUI_LoginPanelMediator);
			mediatorMap.map(loginUI.lineSelectPanel, LoginUI_LineSelectPanelMediator);
			mediatorMap.map(loginUI.roleCreatePanel, LoginUI_RoleCreatePanelMediator);
			mediatorMap.map(loginUI.p2Panel, LoginUI_P2PanelMediator);
			mediatorMap.map(loginUI.p2SetPanel, LoginUI_P2SetPanelMediator);
			mediatorMap.map(loginUI.p2ResetPanel, LoginUI_P2ResetPanelMediator);
			//显示登陆界面
			loginUI.show();
			//登陆
			loginUISignals.showLoginPanel.dispatch(true);
//			GameInstance.signal.sound.addBackGroundSound.dispatch("music01.mp3");
		}
	}
}
