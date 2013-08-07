package fj1.modules.messageBox.controller
{
	import fj1.common.GameInstance;
	import fj1.common.ui.TWindowManager;
	import fj1.modules.messageBox.signals.MessageSignal;
	import fj1.modules.messageBox.view.MessagePanelMediator;
	import fj1.modules.messageBox.view.components.MessagePanel;
	import tempest.common.logging.*;
	import tempest.common.mvc.base.Command;

	public class MessageFacadeStartupCommand extends Command
	{
		private static const log:ILogger = TLog.getLogger(MessageFacadeStartupCommand);
		[Inject]
		public var signal:MessageSignal;

		public override function execute():void
		{
			log.info("消息盒子模块启动");
			//注册命令
			commandMap.map([signal.showMessagePanel], ShowMessagePanelCommand);
			commandMap.map([signal.messageBoxAll], MessageBoxAllCommand);
			TWindowManager.instance.registerWindowMediator(MessagePanel, MessagePanelMediator, mediatorMap.map);
		}
	}
}
