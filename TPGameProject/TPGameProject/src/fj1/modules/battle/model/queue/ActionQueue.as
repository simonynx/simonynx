package fj1.modules.battle.model.queue
{
	import fj1.modules.battle.model.vo.RoundInfo;

	import ghostcat.operation.Queue;

	public class ActionQueue extends Queue implements IAction
	{
		protected var roundInfo:RoundInfo;

		public function ActionQueue(roundInfo:RoundInfo)
		{
			super();
			this.roundInfo = roundInfo;
			addChildren();
		}

		/**
		 *  添加子集
		 *
		 */
		protected function addChildren():void
		{

		}
	}
}
