package fj1.modules.battle.view.components
{
	import flash.display.MovieClip;
	import flash.geom.Point;
	
	import assets.EmbedRes;
	
	import fj1.modules.battle.constants.BattleCamp;
	import fj1.modules.battle.constants.BattleConst;

	/**
	 * 保存逻辑坐标和像素坐标的映射关系
	 * @author linxun
	 *
	 */
	public class BattleGrid
	{
		private var _proxy:*;
		private var _posArray:Array;


		/**
		 * 保存逻辑坐标和像素坐标的映射关系
		 *
		 */
		public function BattleGrid()
		{
			_posArray = [];
			_proxy =  (new EmbedRes.battleGrid());
			initPos(BattleCamp.LEFT, "left", _proxy);
			initPos(BattleCamp.RIGHT, "right", _proxy);
		}
		
		public function get proxy():*
		{
			return _proxy;
		}

		private function initPos(camp:int, campName:String, mc:*):void
		{
			var fields:Array = [];
			for (var y:int = 0; y < BattleConst.BATTLE_GRID_HEIGHT; ++y)
			{
				fields[y] = [];
				for (var x:int = 0; x < BattleConst.BATTLE_GRID_WIDTH; ++x)
				{
					var posMC:MovieClip = mc.getChildByName(campName + "_" + y + "_" + x) as MovieClip;
					fields[y][x] = new Point(posMC.x, posMC.y);
				}
			}
			_posArray[camp] = fields;
		}

		public function getPixelPos(camp:int, logicX:int, logicY:int):Point
		{
			return _posArray[camp][logicY][logicX];
		}
	}
}
