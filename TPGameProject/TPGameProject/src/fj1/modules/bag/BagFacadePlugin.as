package fj1.modules.bag
{

	import fj1.modules.bag.controller.BagStartupCommand;
	import fj1.modules.bag.signals.BagSignals;

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
