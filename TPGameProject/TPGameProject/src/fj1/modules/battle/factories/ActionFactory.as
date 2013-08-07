package fj1.modules.battle.factories
{
	import fj1.modules.battle.constants.BattleConst;
	import fj1.modules.battle.model.queue.CombatAttactQueue;
	import fj1.modules.battle.model.queue.IAction;
	import fj1.modules.battle.model.queue.NormalActionQueue;
	import fj1.modules.battle.model.vo.RoundInfo;

	import tempest.common.logging.ILogger;
	import tempest.common.logging.TLog;

	public class ActionFactory
	{
		private static const log:ILogger = TLog.getLogger(ActionFactory);

		public function ActionFactory()
		{
		}

		public static function create(roundInfo:RoundInfo):IAction
		{
			switch (roundInfo.actionType)
			{
				case BattleConst.ACTION_NORMAL:
					return new NormalActionQueue(roundInfo);
				case BattleConst.ACTION_SKILL:
					return new CombatAttactQueue(roundInfo);
			}
			log.error("create() 创建IAction失败，无效的actionType = " + roundInfo.actionType);
			return null;
		}
	}
}
