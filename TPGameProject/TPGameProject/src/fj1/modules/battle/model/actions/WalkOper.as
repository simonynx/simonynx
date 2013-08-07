package fj1.modules.battle.model.actions
{
	import com.gskinner.motion.GTween;
	import com.gskinner.motion.GTweener;

	import fj1.modules.battle.constants.BattleConst;
	import fj1.modules.battle.view.components.element.BattleCharacter;

	import flash.filters.BlurFilter;
	import flash.geom.Point;

	import ghostcat.operation.Oper;

	import tempest.engine.staticdata.Direction;
	import tempest.engine.staticdata.Status;

	public class WalkOper extends Oper
	{
		private var _castPlayer:BattleCharacter;
		private var _targetPoint:Point;
		private var _onArrived:Function;
		private var _dir:int;

		/**
		 *
		 * @param castPlayer 动作发起者
		 * @param targetPoint 目标点
		 * @param dir 方向
		 * @param onArrived 走到目标点后触发的回调函数：参数:onArrived(castPlayer:BattleCharacter):void
		 *
		 */
		public function WalkOper(castPlayer:BattleCharacter, targetPoint:Point, dir:int, onArrived:Function = null)
		{
			super();
			_castPlayer = castPlayer;
			_targetPoint = targetPoint;
			_onArrived = onArrived;
			_dir = dir;
		}

		override public function execute():void
		{
			_castPlayer.playTo(Status.STAND, _dir);
			_castPlayer.filters = [new BlurFilter(5, 5)];
			GTweener.to(_castPlayer, 0.1, {alpha: 0.5}, {onComplete: function(gt:GTween):void
			{
				GTweener.to(_castPlayer, 0.3, {x: _targetPoint.x, y: _targetPoint.y}, {onComplete: function(gt:GTween):void
				{
					_castPlayer.filters = null;
					GTweener.to(_castPlayer, 0.1, {alpha: 1}, {onComplete: function(gt:GTween):void
					{
						if (_onArrived != null)
						{
							_onArrived(_castPlayer);
						}
						result();
					}});
				}});
			}});
		}
	}
}
