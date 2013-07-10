package modules.main.business.battle.model.queue
{
	import ghostcat.operation.Queue;
	import modules.main.business.battle.model.vo.RoundInfo;

	public class NormalActionQueue implements IActionQueue
	{
		private var _queue:Queue;
		private var roundInfo:RoundInfo;

		public function NormalActionQueue(roundInfo:RoundInfo)
		{
			_queue = new Queue();
			this.roundInfo = roundInfo;
			sortQueue();
		}

		public function get queue():Queue
		{
			return _queue;
		}

		public function sortQueue():void
		{
			
		}
	}
}
