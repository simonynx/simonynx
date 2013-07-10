package modules.main
{
	import modules.main.business.bag.BagFacadePlugin;
	import modules.main.business.bag.signals.BagSignals;
	import modules.main.business.battle.BattleFacadePlugin;
	import modules.main.business.scene.SceneFacadePlugin;
	import modules.main.controller.MainFacadeStartupCommand;

	import tempest.common.mvc.TFacade;

	public class MainFacade extends TFacade
	{
		private static var _instance:MainFacade;

		public function MainFacade()
		{
			super();
			if (_instance)
			{
				throw new Error("MainFacade is Singleton");
			}
		}

		public static function get instance():MainFacade
		{
			return _instance ||= new MainFacade();
		}

		override public function startup():void
		{
			commandMap.map([this.startupSignal], MainFacadeStartupCommand, true);
			this.addPlugin(new BagFacadePlugin());
			this.addPlugin(new SceneFacadePlugin());
			this.addPlugin(new BattleFacadePlugin());

			super.startup();
		}
	}
}
