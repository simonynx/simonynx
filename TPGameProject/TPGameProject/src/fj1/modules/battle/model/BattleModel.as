package fj1.modules.battle.model
{
	import fj1.modules.battle.factories.ActionFactory;
	import fj1.modules.battle.model.queue.IAction;
	import fj1.modules.battle.model.vo.RoundInfo;
	import fj1.modules.battle.signals.BattleSignals;
	
	import ghostcat.events.OperationEvent;
	import ghostcat.operation.Queue;
	
	import tempest.common.logging.ILogger;
	import tempest.common.logging.TLog;
	import tempest.common.mvc.base.Actor;

	public class BattleModel extends Actor
	{
		[Inject]
		public var battleSignals:BattleSignals;
		
		private static const log:ILogger = TLog.getLogger(BattleModel);
		
		private var _queue:Queue; //总队列

		public function BattleModel()
		{
			super();
		}

		public function startQueue(roundInfoArr:Vector.<RoundInfo>):void
		{
			var length:int = roundInfoArr.length;
			if (length == 0)
				return;
			haltQueue();

			var arr:Array = [];
			for (var i:int; i < length; i++)
			{
				var roundInfo:RoundInfo = roundInfoArr[i];
				var action:IAction = ActionFactory.create(roundInfo);
				arr.push(action)
			}
			_queue = new Queue(arr);
			_queue.addEventListener(OperationEvent.OPERATION_COMPLETE, onBattleComplete);
			_queue.execute();
		}

		/**
		 * 中止战斗
		 *
		 */
		public function haltQueue():void
		{
			if (_queue)
			{
				_queue.removeEventListener(OperationEvent.OPERATION_COMPLETE, onBattleComplete);
				_queue.halt();
				_queue = null;
			}
		}

		/**
		 * 战斗完成
		 * @param event
		 *
		 */
		private function onBattleComplete(event:OperationEvent):void
		{
			log.log("战斗结束");
			_queue.removeEventListener(OperationEvent.OPERATION_COMPLETE, onBattleComplete);
			_queue = null;
			battleSignals.battleEnd.dispatch(null);
		}
	}
}
