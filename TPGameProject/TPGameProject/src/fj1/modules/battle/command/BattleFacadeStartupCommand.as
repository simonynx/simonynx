package fj1.modules.battle.command
{
	import fj1.common.GameInstance;
	import fj1.modules.battle.signals.BattleSignals;
	import fj1.modules.battle.view.BattleUiMediator;
	
	import tempest.common.mvc.base.Command;

	public class BattleFacadeStartupCommand extends Command
	{
		[Inject]
		public var battleSignals:BattleSignals;

		public function BattleFacadeStartupCommand()
		{
			super();
		}

		override public function execute():void
		{
			mediatorMap.map(GameInstance.battleScene.battleUI, BattleUiMediator);
			commandMap.map([battleSignals.quitBattle], QuitBattleCommand);
			commandMap.map([battleSignals.battleStart], BattleStartCommand);
		}
	}
}
