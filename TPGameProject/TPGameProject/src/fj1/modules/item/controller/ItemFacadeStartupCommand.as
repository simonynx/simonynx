package fj1.modules.item.controller
{
	import fj1.common.GameInstance;
	import fj1.common.ui.TWindowManager;
	import fj1.modules.item.service.ItemService;
	import fj1.modules.item.signals.ItemSignal;
	import fj1.modules.item.view.AwardDepotMediator;
	import fj1.modules.item.view.HeroBagMediator;
	import fj1.modules.item.view.HeroDepotMediator;
	import fj1.modules.item.view.components.HeroBagPanel;
	import fj1.modules.item.view.components.HeroDepotPanel;
	import tempest.common.keyboard.KeyCodes;
	import tempest.common.logging.*;
	import tempest.common.mvc.base.Command;
	import tempest.manager.KeyboardManager;

	public class ItemFacadeStartupCommand extends Command
	{
		[Inject]
		public var itemSignals:ItemSignal;
		[Inject]
		public var service:ItemService;
		private static const log:ILogger = TLog.getLogger(ItemFacadeStartupCommand);

		public override function execute():void
		{
			log.info("物品模块启动");
			//注册热键
			KeyboardManager.addHotkey("包裹(B)", [KeyCodes.B.keyCode], onBagHandler);
			mediatorMap.map(TWindowManager.instance.getWindow(HeroBagPanel.NAME), HeroBagMediator);
			mediatorMap.map(TWindowManager.instance.getWindow(HeroDepotPanel.NAME), HeroDepotMediator);
			commandMap.map([itemSignals.showHeroBag], ShowHeroBagCommand);
			commandMap.map([itemSignals.showHeroDepot], ShowHeroDepotCommand);
			commandMap.map([GameInstance.mainCharData.signals.initComplete], ItemLoginCompleteCheckCommand);
			service.init();
		}

		private function onBagHandler():void
		{
			TWindowManager.instance.showPopup2(null, HeroBagPanel.NAME, false, false, TWindowManager.MODEL_REMOVE_OR_ADD);
		}
	}
}
