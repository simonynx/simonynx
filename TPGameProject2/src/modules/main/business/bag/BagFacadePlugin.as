package modules.main.business.bag
{

	import modules.main.business.bag.controller.BagStartupCommand;
	import modules.main.business.bag.signals.BagSignals;

	import tempest.common.mvc.base.TFacadePlugin;

	public class BagFacadePlugin extends TFacadePlugin
	{
		public function BagFacadePlugin()
		{
			super();
		}

		override protected function startup():void
		{
			inject.mapSingleton(BagSignals);

			commandMap.map([this.startupSignal], BagStartupCommand);
		}
	}
}
