package fj1.modules.card.command
{
	import fj1.common.ui.TWindowManager;
	import fj1.modules.card.net.CardService;
	import fj1.modules.card.view.CardBagMediator;
	import fj1.modules.card.view.CardInfoPanelMediator;
	import fj1.modules.card.view.components.CardBagPanel;
	import fj1.modules.card.view.components.CardInfoPanel;

	import tempest.common.logging.ILogger;
	import tempest.common.logging.TLog;
	import tempest.common.mvc.base.Command;

	public class CardFacadeStartupCommand extends Command
	{
		[Inject]
		public var cardService:CardService;

		private static const log:ILogger = TLog.getLogger(CardFacadeStartupCommand);

		override public function execute():void
		{
			cardService.init();

			TWindowManager.instance.registerWindowMediator(CardBagPanel, CardBagMediator, mediatorMap.map);
			TWindowManager.instance.registerWindowMediator(CardInfoPanel, CardInfoPanelMediator, mediatorMap.map);
		}
	}
}
