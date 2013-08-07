package fj1.modules.loading.controller
{
	import shell.AppUIMananger;
	import shell.AppUINames;

	import fj1.modules.loading.signals.LoadSignals;
	import fj1.modules.loading.view.LoadMediator;
	import fj1.modules.loading.view.components.MainLoader;

	import org.osflash.signals.Signal;

	import tempest.common.mvc.base.Command;

	public class LoadFacadeStartupCommand extends Command
	{
		[Inject]
		public var signals:LoadSignals;

		public function LoadFacadeStartupCommand()
		{
			super();

		}

		override public function execute():void
		{
			commandMap.map([signals.loadRes], LoadResCommand);
			commandMap.map([signals.loadResComplete], LoadResCompleteCommand);

			var mainLoader:MainLoader = AppUIMananger.addUI(AppUINames.MAIN_LOADER, new MainLoader());

			mediatorMap.map(mainLoader, LoadMediator);

			signals.loadRes.dispatch();
		}
	}
}
