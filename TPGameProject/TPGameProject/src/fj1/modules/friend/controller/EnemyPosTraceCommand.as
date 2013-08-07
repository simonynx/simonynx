package fj1.modules.friend.controller
{
	import fj1.manager.MessageManager;
	import tempest.common.mvc.base.Command;

	public class EnemyPosTraceCommand extends Command
	{
		override public function getHandle():Function
		{
			return this.query;
		}

		private function query(playerId:int, online:Boolean):void
		{
			if (!online)
			{
				MessageManager.instance.addHintById_client(2026, "仇人不在线无法查看。");
				return;
			}
		}
	}
}
