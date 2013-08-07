package fj1.modules.newmail.controller
{
	import fj1.common.GameInstance;
	import fj1.common.ui.TWindowManager;
	import fj1.modules.newmail.service.MailService;
	import fj1.modules.newmail.signals.MailSignal;
	import fj1.modules.newmail.view.MailInfoPanelMediator;
	import fj1.modules.newmail.view.MailTabPanelMediator;
	import fj1.modules.newmail.view.MiniFriendsPanelMediator;
	import fj1.modules.newmail.view.components.MailInfoPanel;
	import fj1.modules.newmail.view.components.MailTabPanel;
	import fj1.modules.newmail.view.components.MiniFriendsPanel;
	import tempest.common.keyboard.KeyCodes;
	import tempest.common.logging.*;
	import tempest.common.mvc.base.Command;
	import tempest.manager.KeyboardManager;

	public class MailFacadeStartupCommand extends Command
	{
		private static const log:ILogger = TLog.getLogger(MailFacadeStartupCommand);
		[Inject]
		public var service:MailService;
		[Inject]
		public var signal:MailSignal;

		public override function execute():void
		{
			log.info("邮件模块启动");
			//删除邮件
			commandMap.map([signal.mailDelete], MailDeleteCommand);
			//发送邮件
			commandMap.map([signal.sendMail], SendMailCommand);
			//显示邮件面板
			commandMap.map([signal.showMailPanel], ShowMailPanelCommand);
			//发邮件
			commandMap.map([signal.writeMailForChat], WriteMailForChatCommand);
			//注册中介器
//			mediatorMap.map(TWindowManager.instance.getWindow(MailTabPanel.NAME), MailTabPanelMediator);
//			mediatorMap.map(TWindowManager.instance.getWindow(MailInfoPanel.NAME), MailInfoPanelMediator);
			TWindowManager.instance.registerWindowMediator(MailTabPanel, MailTabPanelMediator, mediatorMap.map);
			TWindowManager.instance.registerWindowMediator(MailInfoPanel, MailInfoPanelMediator, mediatorMap.map);
			TWindowManager.instance.registerWindowMediator(MiniFriendsPanel, MiniFriendsPanelMediator, mediatorMap.map);
			//注册热键
			KeyboardManager.addHotkey("邮件(Y)", [KeyCodes.Y.keyCode], function():void
			{
				signal.showMailPanel.dispatch(-1);
			});
			service.init();
		}
	}
}
