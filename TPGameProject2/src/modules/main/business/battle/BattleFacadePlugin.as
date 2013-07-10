package modules.main.business.battle
{
	import modules.main.business.battle.command.BattleFacadeStartupCommand;
	import modules.main.business.battle.model.BattleModel;
	import modules.main.business.battle.signals.BattlePlayerSignals;
	import modules.main.business.battle.signals.BattleSignals;

	import tempest.common.mvc.base.TFacadePlugin;

	public class BattleFacadePlugin extends TFacadePlugin
	{
		public function BattleFacadePlugin()
		{
			super();
		}

		override protected function startup():void
		{
			inject.mapSingleton(BattleSignals);
			inject.mapSingleton(BattlePlayerSignals);
			inject.mapSingleton(BattleModel);

			commandMap.map([this.startupSignal], BattleFacadeStartupCommand);
		}
	}
}
