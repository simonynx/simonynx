package fj1.modules.mainUI
{
	import fj1.modules.mainUI.controller.MainUIFacadeStartupCommand;
	import fj1.modules.mainUI.model.MainUIModel;
	import fj1.modules.mainUI.service.MainUIService;
	import fj1.modules.mainUI.signal.MainUISignal;
	import tempest.common.mvc.base.TFacadePlugin;

	public class MainUIFacadePlugin extends TFacadePlugin
	{
		public function MainUIFacadePlugin()
		{
			super();
		}

		override protected function startup():void
		{
			inject.mapSingleton(MainUISignal);
			inject.mapSingleton(MainUIService);
			inject.mapSingleton(MainUIModel);
			commandMap.map([this.startupSignal], MainUIFacadeStartupCommand);
		}
	}
}
