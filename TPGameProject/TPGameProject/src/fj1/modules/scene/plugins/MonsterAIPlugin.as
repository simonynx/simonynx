package fj1.modules.scene.plugins
{
	import fj1.common.GameInstance;
	import fj1.common.vo.character.Hero;
	import fj1.modules.battle.signals.BattleSignals;
	import fj1.modules.main.MainFacade;

	import flash.geom.Point;

	import tempest.engine.SceneCharacter;
	import tempest.engine.core.ISceneCharacterPlugin;
	import tempest.engine.tools.SceneUtil;
	import tempest.engine.vo.map.MapTile;
	import tempest.engine.vo.move.MoveCallBack;

	public class MonsterAIPlugin implements ISceneCharacterPlugin
	{
		private var _target:SceneCharacter;
		private var _initTileX:int;
		private var _initTileY:int;

		private static const RADIUS:int = 25; //追踪范围
		private static const BATTLE_RADIUS:int = 1; //战斗范围
		private static const SPEED:int = 135; //追踪移动速度

		public function MonsterAIPlugin()
		{
		}

		public function get name():String
		{
			return "MonsterAIPlugin";
		}

		public function setup(target:SceneCharacter):void
		{
			_target = target;
			_initTileX = target.tile_x;
			_initTileY = target.tile_y;
		}

		public function shutdown():void
		{
			_target = null;
		}

		public function update():void
		{
			var mainChar:SceneCharacter = GameInstance.mainChar;

			if (inBattleRange(mainChar))
			{
				return;
			}

			if (inTrackRange(mainChar))
			{
				var callBack:MoveCallBack = new MoveCallBack();
				callBack.onWalkArrived = onArrived;
				_target.walk(mainChar.tile, SPEED, BATTLE_RADIUS, callBack);
			}
			else //回到起始点
			{
				if (_target.tile_x != _initTileX && _target.tile_y != _initTileY)
				{
					_target.walk(new Point(_initTileX, _initTileY), SPEED);
				}
			}
		}

		private function onArrived(char:SceneCharacter, mapTile:MapTile):void
		{
			if (inBattleRange(char))
			{
				var battleSignals:BattleSignals = MainFacade.instance.inject.getInstance(BattleSignals) as BattleSignals;
				battleSignals.battleStart.dispatch(); //战斗开始
			}
		}

		private function inTrackRange(mainChar:SceneCharacter):Boolean
		{
			return Math.abs(_initTileX - mainChar.tile_x) <= RADIUS && Math.abs(_initTileY - mainChar.tile_y) <= RADIUS;
		}

		private function inBattleRange(mainChar:SceneCharacter):Boolean
		{
			return Math.abs(_target.tile_x - mainChar.tile_x) <= BATTLE_RADIUS && Math.abs(_target.tile_y - mainChar.tile_y) <= BATTLE_RADIUS;
		}
	}
}
