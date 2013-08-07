package fj1.modules.friend
{
	import fj1.modules.friend.controller.FriendFacadeStartupCommand;
	import fj1.modules.friend.model.FriendModel;
	import fj1.modules.friend.service.FriendService;
	import fj1.modules.friend.signals.FriendSignal;
	import tempest.common.mvc.base.TFacadePlugin;

	public class FriendFacadePlugin extends TFacadePlugin
	{
		public function FriendFacadePlugin()
		{
			super();
		}

		override protected function startup():void
		{
			inject.mapSingleton(FriendSignal);
			inject.mapSingleton(FriendService);
			inject.mapSingleton(FriendModel);
			commandMap.map([this.startupSignal], FriendFacadeStartupCommand);
		}
	}
}
