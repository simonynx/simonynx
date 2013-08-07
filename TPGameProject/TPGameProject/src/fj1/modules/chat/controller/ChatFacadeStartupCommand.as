package fj1.modules.chat.controller
{
	import fj1.common.GameInstance;
	import fj1.common.ui.TWindowManager;
	import fj1.modules.chat.model.ChatModel;
	import fj1.modules.chat.view.ChatPanelMediator;
	import fj1.modules.chat.view.HornInputMediator;
	import fj1.modules.chat.view.HornPanelMediator;
	import fj1.modules.chat.view.MainChatMediator;
	import fj1.modules.chat.view.components.HornInputPanel;
	
	import tempest.common.logging.ILogger;
	import tempest.common.logging.TLog;
	import tempest.common.mvc.base.Command;

	public class ChatFacadeStartupCommand extends Command
	{
		[Inject]
		public var model:ChatModel;
		private static const log:ILogger = TLog.getLogger(ChatFacadeStartupCommand);

		override public function execute():void
		{
			log.info("聊天模块启动");
			model.initSmileys();
			mediatorMap.map(GameInstance.app.mainUI.mainChatPanel, MainChatMediator);
//			mediatorMap.map(TWindowManager.instance.getWindow(HornInputPanel.NAME), HornInputMediator);
			TWindowManager.instance.registerWindowMediator(HornInputPanel, HornInputMediator, mediatorMap.map);
			mediatorMap.map(GameInstance.app.mainUI.mainChatPanel.chatPanel, ChatPanelMediator);
			mediatorMap.map(GameInstance.app.mainUI.mainChatPanel.hornPanel, HornPanelMediator);
		}
	}
}
