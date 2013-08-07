package fj1.modules.item
{
	import fj1.modules.item.controller.ItemFacadeStartupCommand;
	import fj1.modules.item.service.ItemService;
	import fj1.modules.item.signals.ItemSignal;
	import tempest.common.mvc.base.TFacadePlugin;

	public class ItemFacadePlugin extends TFacadePlugin
	{
		public function ItemFacadePlugin()
		{
			super();
		}

		override protected function startup():void
		{
			inject.mapSingleton(ItemSignal);
			inject.mapSingleton(ItemService);
			commandMap.map([this.startupSignal], ItemFacadeStartupCommand);
		}
	}
}
