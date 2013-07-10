package modules.main.business.battle.model
{
	import flash.geom.Point;
	import flash.utils.Dictionary;

	import modules.main.business.battle.model.entity.BattlePlayer;
	import modules.main.business.battle.signals.BattleModelSignals;

	import tempest.common.mvc.base.Actor;

	public class BattleModel extends Actor
	{
		private var _playerDic:Dictionary;
		private var _signals:BattleModelSignals;

		public function BattleModel()
		{
			super();
			_playerDic = new Dictionary();
		}

		public function get playerDic():Dictionary
		{
			return _playerDic;
		}

		public function addPlayer(player:BattlePlayer):void
		{
			_playerDic[player.guid] = player;
			signals.playerAdd.dispatch(player);
		}

		public function getPlayer(guid:int):BattlePlayer
		{
			return _playerDic[guid];
		}

		public function getPlayerLogicPos(pos:Point):BattlePlayer
		{
			for each (var player:BattlePlayer in _playerDic)
			{
				if (player.logicX == pos.x && player.logicY == pos.y)
				{
					return player;
				}
			}
			return null;
		}

		public function removePlayer(guid:int):void
		{
			_playerDic[guid] = null;
			signals.playerRemove.dispatch(guid);
		}

		public function removeAllPlayer():void
		{
			_playerDic = new Dictionary();
		}

		public function get signals():BattleModelSignals
		{
			return _signals ||= new BattleModelSignals();
		}
	}
}
