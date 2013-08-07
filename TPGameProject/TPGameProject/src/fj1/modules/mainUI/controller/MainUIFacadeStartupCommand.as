package fj1.modules.mainUI.controller
{
	import fj1.common.GameInstance;
	import fj1.modules.mainUI.service.MainUIService;
	import fj1.modules.mainUI.view.MainUIMediator;
	import tempest.common.mvc.base.Command;

	public class MainUIFacadeStartupCommand extends Command
	{
		[Inject]
		public var service:MainUIService;

		public override function execute():void
		{
			service.init();
			mediatorMap.map(GameInstance.app.mainUI, MainUIMediator);
		}
	}
}
