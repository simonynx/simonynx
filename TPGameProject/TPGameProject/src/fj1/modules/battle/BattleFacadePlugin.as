package fj1.modules.battle
{
	import fj1.modules.battle.command.BattleFacadeStartupCommand;
	import fj1.modules.battle.model.BattleModel;
	import fj1.modules.battle.signals.BattleSignals;

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
			inject.mapSingleton(BattleModel);

			commandMap.map([this.startupSignal], BattleFacadeStartupCommand);
		}
	}
}
