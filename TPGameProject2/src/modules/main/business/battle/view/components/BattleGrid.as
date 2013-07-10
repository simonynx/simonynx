package modules.main.business.battle.view.components
{
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.geom.Point;

	import modules.main.business.battle.constants.BattleCamp;
	import modules.main.business.battle.constants.BattleConst;

	/**
	 * 保存逻辑坐标和像素坐标的映射关系
	 * @author linxun
	 *
	 */
	public class BattleGrid
	{
		private var _posArray:Array;


		/**
		 * 保存逻辑坐标和像素坐标的映射关系
		 *
		 */
		public function BattleGrid()
		{
			_posArray = [];
		}

		public function init(content:*):void
		{
			var mc:MovieClip = content.getChildAt(0) as MovieClip;
			initPos(BattleCamp.LEFT, "left", mc);
			initPos(BattleCamp.RIGHT, "right", mc);
		}

		private function initPos(camp:int, campName:String, mc:MovieClip):void
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
