package fj1.modules.card
{
	import fj1.common.MutexHandler;
	import fj1.common.MutexManager;
	import fj1.common.WindowMutex;
	import fj1.common.data.dataobject.Card;
	import fj1.common.staticdata.GMCMDKeys;
	import fj1.common.staticdata.WindowMutexName;
	import fj1.common.ui.TWindowManager;
	import fj1.common.ui.WindowPair;
	import fj1.manager.SlotItemManager;
	import fj1.modules.card.command.CardFacadeStartupCommand;
	import fj1.modules.card.command.CardGMCommand;
	import fj1.modules.card.net.CardService;
	import fj1.modules.card.signals.CardBagSignals;
	import fj1.modules.card.view.components.CardBagPanel;
	import fj1.modules.card.view.components.CardInfoPanel;

	import tempest.common.keyboard.KeyCodes;
	import tempest.common.logging.ILogger;
	import tempest.common.logging.TLog;
	import tempest.common.mvc.base.TFacadePlugin;
	import tempest.manager.GMCommandMananger;
	import tempest.manager.KeyboardManager;
	import tempest.ui.events.TWindowEvent;

	public class CardFacadePlugin extends TFacadePlugin
	{
		private static const log:ILogger = TLog.getLogger(CardFacadePlugin);

		public function CardFacadePlugin()
		{
			super();
		}

		override protected function startup():void
		{
			log.info("武将模块启动");
			//注册热键
			KeyboardManager.addHotkey("武将(P)", [KeyCodes.P.keyCode], onShowCardBagHandler);
			GMCommandMananger.register(GMCMDKeys.CARD, CardGMCommand.exec);

			inject.mapSingleton(CardBagSignals);
			inject.mapSingleton(CardService);
			commandMap.map([this.startupSignal], CardFacadeStartupCommand);
		}

		private function onShowCardBagHandler():void
		{
			var windowMutex:WindowMutex = MutexManager.instance.windowMutex;
			if (windowMutex.name == WindowMutexName.CARDBAG_GROUP)
			{
				WindowPair.instance.closeAll();
			}
			else
			{
				MutexManager.instance.windowMutex.showPair(WindowMutexName.CARDBAG_GROUP, CardBagPanel.NAME, CardInfoPanel.NAME);
			}
		}
	}
}
